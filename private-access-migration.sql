-- Montaigne ECG : restreint l’application au compte déjà présent dans study_data.
-- Avant l’exécution, vérifier qu’il existe exactement un compte autorisé.
create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table if not exists private.allowed_app_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  added_at timestamptz not null default now()
);
revoke all on private.allowed_app_users from public, anon, authenticated;

-- Le projet personnel ne doit avoir qu’une ligne existante. Elle devient l’unique allowlist.
do $$
begin
  if (select count(*) from public.study_data) <> 1 then
    raise exception 'Expected exactly one existing study_data account before creating the allowlist';
  end if;
end $$;
insert into private.allowed_app_users(user_id)
select user_id from public.study_data
on conflict (user_id) do nothing;

create or replace function public.is_app_user()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from private.allowed_app_users
    where user_id = (select auth.uid())
  );
$$;
revoke all on function public.is_app_user() from public, anon;
grant execute on function public.is_app_user() to authenticated;

drop policy if exists study_data_select_own on public.study_data;
drop policy if exists study_data_insert_own on public.study_data;
drop policy if exists study_data_update_own on public.study_data;
drop policy if exists study_data_delete_own on public.study_data;
create policy study_data_select_own on public.study_data
  for select to authenticated
  using ((select public.is_app_user()) and (select auth.uid()) = user_id);
create policy study_data_insert_own on public.study_data
  for insert to authenticated
  with check ((select public.is_app_user()) and (select auth.uid()) = user_id);
create policy study_data_update_own on public.study_data
  for update to authenticated
  using ((select public.is_app_user()) and (select auth.uid()) = user_id)
  with check ((select public.is_app_user()) and (select auth.uid()) = user_id);
create policy study_data_delete_own on public.study_data
  for delete to authenticated
  using ((select public.is_app_user()) and (select auth.uid()) = user_id);

create or replace function public.sync_study_data(p_payload jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = pg_catalog, public
as $$
declare
  uid uuid := auth.uid();
  existing_payload jsonb;
  merged_payload jsonb;
begin
  if uid is null or not public.is_app_user() then
    raise exception 'This account is not authorized';
  end if;
  insert into public.study_data(user_id, payload)
    values (uid, coalesce(p_payload, '{}'::jsonb))
    on conflict (user_id) do nothing;
  select payload into existing_payload from public.study_data where user_id = uid for update;
  merged_payload := public.merge_study_payload(existing_payload, coalesce(p_payload, '{}'::jsonb));
  update public.study_data set payload = merged_payload, revision = revision + 1, updated_at = now()
    where user_id = uid;
  return merged_payload;
end;
$$;
revoke all on function public.sync_study_data(jsonb) from public, anon, authenticated;
grant execute on function public.sync_study_data(jsonb) to authenticated;

-- Montaigne ECG : un document de sauvegarde par compte.
-- Les données ne sont accessibles qu'à l'utilisateur authentifié propriétaire de la ligne.
create table if not exists public.study_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  revision bigint not null default 1,
  updated_at timestamptz not null default now()
);
alter table public.study_data
  add column if not exists revision bigint not null default 1;

alter table public.study_data enable row level security;

-- Rend ce script réexécutable et remplace toute ancienne politique trop large.
drop policy if exists "Users manage their own study data" on public.study_data;
drop policy if exists "study_data_select_own" on public.study_data;
drop policy if exists "study_data_insert_own" on public.study_data;
drop policy if exists "study_data_update_own" on public.study_data;
drop policy if exists "study_data_delete_own" on public.study_data;

create policy "study_data_select_own" on public.study_data
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "study_data_insert_own" on public.study_data
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "study_data_update_own" on public.study_data
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "study_data_delete_own" on public.study_data
  for delete to authenticated using ((select auth.uid()) = user_id);

revoke all on public.study_data from anon;
grant select, insert, update, delete on public.study_data to authenticated;

-- Fusion atomique par identifiant, avec dernière modification gagnante et tombstones.
create or replace function public.merge_study_rows(
  p_old jsonb, p_new jsonb, p_collection text, p_tombstones jsonb
) returns jsonb
language sql immutable
set search_path = pg_catalog, public
as $$
  with candidates as (
    select value as item from jsonb_array_elements(coalesce(p_old, '[]'::jsonb))
    union all
    select value as item from jsonb_array_elements(coalesce(p_new, '[]'::jsonb))
  ), alive as (
    select c.item
    from candidates c
    where not exists (
      select 1 from jsonb_array_elements(coalesce(p_tombstones, '[]'::jsonb)) t(value)
      where t.value->>'collection' = p_collection
        and t.value->>'id' = c.item->>'id'
        and coalesce(t.value->>'deletedAt', '') >= coalesce(c.item->>'updatedAt', '')
    )
  ), latest as (
    select distinct on (item->>'id') item
    from alive
    order by item->>'id', coalesce(item->>'updatedAt', '') desc
  )
  select coalesce(jsonb_agg(item), '[]'::jsonb) from latest;
$$;

create or replace function public.merge_study_payload(p_old jsonb, p_new jsonb)
returns jsonb
language plpgsql immutable
set search_path = pg_catalog, public
as $$
declare
  result jsonb := coalesce(p_old, '{}'::jsonb) || coalesce(p_new, '{}'::jsonb);
  tombstones jsonb;
  collection text;
begin
  select coalesce(jsonb_agg(value), '[]'::jsonb) into tombstones
  from (
    select distinct on (value->>'collection', value->>'id') value
    from (
      select value from jsonb_array_elements(coalesce(p_old->'tombstones', '[]'::jsonb))
      union all
      select value from jsonb_array_elements(coalesce(p_new->'tombstones', '[]'::jsonb))
    ) all_tombstones
    order by value->>'collection', value->>'id', value->>'deletedAt' desc
  ) latest_tombstones;

  result := jsonb_set(result, '{tombstones}', tombstones, true);
  foreach collection in array array['cards', 'logs', 'tasks', 'chapters', 'courses'] loop
    result := jsonb_set(result, array[collection],
      public.merge_study_rows(p_old->collection, p_new->collection, collection, tombstones), true);
  end loop;
  return result;
end;
$$;

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
  if uid is null then raise exception 'Authentication required'; end if;
  insert into public.study_data(user_id, payload) values (uid, coalesce(p_payload, '{}'::jsonb))
    on conflict (user_id) do nothing;
  select payload into existing_payload from public.study_data where user_id = uid for update;
  merged_payload := public.merge_study_payload(existing_payload, coalesce(p_payload, '{}'::jsonb));
  update public.study_data
    set payload = merged_payload, revision = revision + 1, updated_at = now()
    where user_id = uid;
  return merged_payload;
end;
$$;

revoke all on function public.merge_study_rows(jsonb, jsonb, text, jsonb) from public, anon, authenticated;
revoke all on function public.merge_study_payload(jsonb, jsonb) from public, anon, authenticated;
revoke all on function public.sync_study_data(jsonb) from public, anon, authenticated;
grant execute on function public.merge_study_rows(jsonb, jsonb, text, jsonb) to authenticated;
grant execute on function public.merge_study_payload(jsonb, jsonb) to authenticated;
grant execute on function public.sync_study_data(jsonb) to authenticated;

-- Active les notifications temps réel si la table n'est pas déjà dans la publication.
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
  and not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'study_data'
  ) then
    alter publication supabase_realtime add table public.study_data;
  end if;
end $$;

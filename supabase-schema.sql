-- À exécuter dans Supabase SQL Editor si tu souhaites préparer la synchronisation
create table if not exists public.study_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.study_data enable row level security;
create policy "Users manage their own study data" on public.study_data
for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

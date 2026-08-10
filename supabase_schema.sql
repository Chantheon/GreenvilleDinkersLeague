-- Dink League shared database
-- Run this once in your Supabase SQL Editor.
create table if not exists public.league_state (
  league_id text primary key,
  state jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.league_state enable row level security;

-- For a private league, use the anon key with a hard-to-guess league_id.
-- This policy lets anyone who knows the league_id read/write that league.
create policy "league state public read"
on public.league_state for select
to anon, authenticated
using (true);

create policy "league state public insert"
on public.league_state for insert
to anon, authenticated
with check (true);

create policy "league state public update"
on public.league_state for update
to anon, authenticated
using (true)
with check (true);

-- Enable realtime for live score/team updates.
alter publication supabase_realtime add table public.league_state;

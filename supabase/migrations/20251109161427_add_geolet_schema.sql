create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  family text not null check (family in ('script','phone','city')),
  country text,
  meta jsonb not null default '{}'
);
alter table skill_tags enable row level security;
create policy "rt skill_tags" on skill_tags for select using (true);

create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  kind text not null check (kind in ('country','region','city')),
  name text not null,
  country text,
  geometry jsonb,
  centroid_lonlat double precision[] not null,
  bbox double precision[] not null,
  meta jsonb not null default '{}'
);
alter table regions enable row level security;
create policy "rt regions" on regions for select using (true);
create index regions_kind_idx on regions (kind);
create index regions_country_idx on regions (country);

create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('language_snippet','phone_number','city_locate')),
  payload jsonb not null,
  primary_tags text[] not null,
  difficulty int not null default 1,
  answer jsonb not null
);
alter table fact_cards enable row level security;
create policy "rt fact_cards" on fact_cards for select using (true);
create index fact_cards_type_idx on fact_cards (type);
create index fact_cards_tags_gin on fact_cards using gin (primary_tags);

create table user_fact_stats (
  user_id uuid not null references auth.users(id) on delete cascade,
  fact_id uuid not null references fact_cards(id) on delete cascade,
  seen int not null default 0,
  correct int not null default 0,
  ease real not null default 2.5,
  last_seen_at timestamptz,
  due_at timestamptz,
  primary key (user_id, fact_id)
);
alter table user_fact_stats enable row level security;
create policy "own ufs" on user_fact_stats
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index ufs_due_idx on user_fact_stats (user_id, due_at) where due_at is not null;

create table game_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null,
  created_at timestamptz not null default now(),
  summary jsonb not null default '{}'
);
alter table game_sessions enable row level security;
create policy "own sessions" on game_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index game_sessions_user_time on game_sessions (user_id, created_at desc);

create table insight_rounds (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  played_at timestamptz,
  country text,
  target_country text,
  distance_m float,
  time_ms int,
  meta jsonb
);
alter table insight_rounds enable row level security;
create policy "own insight" on insight_rounds
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index insight_user_time on insight_rounds (user_id, played_at);
create index insight_user_target on insight_rounds (user_id, target_country);
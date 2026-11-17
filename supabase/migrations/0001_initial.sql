create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text not null default 'Usuario PORTAL',
  bio text not null default '',
  avatar_url text,
  created_at timestamptz not null default now(),
  constraint username_format check (username is null or username ~ '^[a-zA-Z0-9_]{3,24}$')
);
create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(content) between 1 and 2000),
  visibility text not null default 'public' check (visibility in ('public','followers','private')),
  created_at timestamptz not null default now()
);
create table if not exists public.places (
  id uuid primary key default gen_random_uuid(),
  provider text not null,
  provider_place_id text not null,
  name text not null,
  display_name text not null,
  latitude double precision not null check (latitude between -90 and 90),
  longitude double precision not null check (longitude between -180 and 180),
  created_at timestamptz not null default now(),
  unique(provider, provider_place_id)
);
create table if not exists public.saved_places (
  user_id uuid not null references public.profiles(id) on delete cascade,
  place_id uuid not null references public.places(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(user_id, place_id)
);
create index if not exists posts_created_at_idx on public.posts(created_at desc);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles(id, display_name)
  values (new.id, coalesce(nullif(new.raw_user_meta_data ->> 'display_name',''), 'Usuario PORTAL'))
  on conflict (id) do nothing;
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.places enable row level security;
alter table public.saved_places enable row level security;

create policy "Authenticated users read profiles" on public.profiles
for select to authenticated using (true);
create policy "Users update own profile" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);
create policy "Read public posts or own posts" on public.posts
for select to authenticated using (visibility = 'public' or author_id = auth.uid());
create policy "Create own posts" on public.posts
for insert to authenticated with check (author_id = auth.uid());
create policy "Update own posts" on public.posts
for update to authenticated using (author_id = auth.uid()) with check (author_id = auth.uid());
create policy "Delete own posts" on public.posts
for delete to authenticated using (author_id = auth.uid());
create policy "Read places" on public.places
for select to authenticated using (true);
create policy "Add places" on public.places
for insert to authenticated with check (true);
create policy "Read own saved places" on public.saved_places
for select to authenticated using (user_id = auth.uid());
create policy "Save own places" on public.saved_places
for insert to authenticated with check (user_id = auth.uid());
create policy "Delete own saved places" on public.saved_places
for delete to authenticated using (user_id = auth.uid());

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.profiles, public.posts to authenticated;
grant select, insert on public.places to authenticated;
grant select, insert, delete on public.saved_places to authenticated;

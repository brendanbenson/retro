CREATE TABLE retro_items (
  id bigserial,
  retro_id text,
  message text,
  type text,
  archived_at TIMESTAMP,
  finished_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT now()
)
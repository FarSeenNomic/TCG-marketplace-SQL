-- 001_init.sql
-- Purpose: Initialize database schema (tables, keys, relationships, constraints)
-- Target DB: PostgreSQL (Supabase-compatible)
-- Run order: 001_init.sql -> 002_insert_data.sql -> 003_queries_examples.sql

/*
// TCG Site
Table card {
  id number [primary key]
  cardname varchar
  price number 
}
Table MTG_card {
  id number [pk, ref: -card.id]
  colour MTG_card.colour
  desc string
}
enum MTG_card.colour {
  white
  blue
  black
  red
  green
}

Table YGO_card {
  id number [pk, ref: -card.id]
  level number
  set string

  checks {
    `0 <= level <= 15` [name: 'chk_level']
  }
}

Table ESO_card {
  id number [pk, ref: -card.id]
  desc string
  position enum
  mana enum
}

table account {
  id number [pk]
  cc number
  address string
}
table seller_brand {
  id number [pk, ref: -account.id, not null]
  game table [pk]
  seller_status account.seller_status
}
enum account.seller_status {
  no
  pending
  yes
}

table cart {
  id number [pk]
  buyer number [ref: -account.id, not null]
  archive bool
}
table specific_cart_item {
  id number [pk]
  card id [ref: -card_instance.id]
  cart number [ref: >cart.id, not null]
}
table generic_cart_item {
  id number [pk]
  quantity number
  card id [ref: -card.id]
  cart number [ref: >cart.id, not null]
}
table card_instance {
  id number [pk]
  instance_of number [ref: -card.id, not null]
  condition number
  seller number [ref: -account.id, not null]
  date date
  processed bool
}
*/

-- ENUMS
CREATE TYPE mtg_card_colour AS ENUM (
  'white',
  'blue',
  'black',
  'red',
  'green'
);

CREATE TYPE account_seller_status AS ENUM (
  'no',
  'pending',
  'yes'
);

-- TABLES
CREATE TABLE card (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cardname VARCHAR(255) NOT NULL,
  price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE mtg_card (
  id BIGINT PRIMARY KEY REFERENCES card(id) ON DELETE CASCADE,
  colour mtg_card_colour NOT NULL,
  "desc" TEXT
);

CREATE TABLE ygo_card (
  id BIGINT PRIMARY KEY REFERENCES card(id) ON DELETE CASCADE,
  level INTEGER,
  "set" VARCHAR(255),
  CONSTRAINT chk_level CHECK (level >= 0 AND level <= 15)
);

CREATE TABLE eso_card (
  id BIGINT PRIMARY KEY REFERENCES card(id) ON DELETE CASCADE,
  "desc" TEXT,
  "position" VARCHAR(50),
  mana VARCHAR(50)
);

CREATE TABLE account (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cc BIGINT,
  address TEXT
);

CREATE TABLE seller_brand (
  seller_id BIGINT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
  game VARCHAR(100) NOT NULL,
  seller_status account_seller_status,
  PRIMARY KEY (id, game)
);

CREATE TABLE cart (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  buyer_id BIGINT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
  archive BOOLEAN DEFAULT FALSE
);

CREATE TABLE card_instance (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  instance_of BIGINT NOT NULL REFERENCES card(id) ON DELETE CASCADE,
  condition INTEGER,
  seller BIGINT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
  date DATE,
  processed BOOLEAN DEFAULT FALSE
);

CREATE TABLE specific_cart_item (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  card_instance BIGINT REFERENCES card_instance(id) ON DELETE CASCADE,
  cart BIGINT NOT NULL REFERENCES cart(id) ON DELETE CASCADE
);

CREATE TABLE generic_cart_item (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  quantity INTEGER NOT NULL DEFAULT 1,
  card BIGINT REFERENCES card(id) ON DELETE CASCADE,
  cart BIGINT NOT NULL REFERENCES cart(id) ON DELETE CASCADE
);

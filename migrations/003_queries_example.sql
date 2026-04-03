-- 003_queries_examples.sql
-- Purpose: Example queries for TCG Marketplace project

-- =========================
-- READ (SELECT) — 3 examples
-- =========================

-- READ #1: List all cards currently up for sale (card_instances) with base card details and seller address.
SELECT
  ci.id AS instance_id,
  c.cardname,
  c.price,
  ci.condition,
  ci.date AS listed_date,
  a.address AS seller_address
FROM card_instance ci
JOIN card c ON c.id = ci.instance_of
JOIN account a ON a.id = ci.seller
WHERE ci.processed = FALSE
ORDER BY ci.date DESC;

-- READ #2: Show all Magic: The Gathering (MTG) cards joined with their specific MTG details.
SELECT
  c.id,
  c.cardname,
  c.price,
  m.colour,
  m."desc"
FROM card c
JOIN mtg_card m ON m.id = c.id
ORDER BY c.price DESC;

-- READ #3: Calculate the total number of items and cart value for a specific cart (Cart 2) using generic items.
SELECT
  ct.id AS cart_id,
  SUM(gci.quantity) AS total_cards,
  SUM(gci.quantity * c.price) AS cart_total_value
FROM cart ct
JOIN generic_cart_item gci ON gci.cart = ct.id
JOIN card c ON c.id = gci.card
WHERE ct.id = 2
GROUP BY ct.id;


-- =========================
-- UPDATE — 3 examples
-- =========================

-- UPDATE #1: Update the price of a specific card
UPDATE card
SET price = 55000.00
WHERE cardname = 'Black Lotus';

-- UPDATE #2: Mark a specific card instance as processed (e.g., when sold)
UPDATE card_instance
SET processed = TRUE
WHERE id = 2;

-- UPDATE #3: Archive an active cart
UPDATE cart
SET archive = TRUE
WHERE id = 1;


-- =========================
-- DELETE — 3 examples
-- =========================
-- NOTE: In real systems, deletes are often replaced with "soft delete" (is_deleted flag).
-- For class requirements, here are real DELETE examples wrapped in a transaction and rolled back.

BEGIN;

-- DELETE #1: Remove a specific item from a cart
DELETE FROM specific_cart_item
WHERE id = 1;

-- DELETE #2: Remove a seller brand who is 'pending'
DELETE FROM seller_brand
WHERE seller_status = 'pending';

-- DELETE #3: Delete a card entirely (cascades to mtg_card/ygo_card/eso_card, card_instance, generic_cart_item, and specific_cart_item)
DELETE FROM card
WHERE id = 1;

-- Roll back so the database isn't permanently changed by demo deletes
ROLLBACK;

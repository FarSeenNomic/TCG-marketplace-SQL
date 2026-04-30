-- 003_queries_examples.sql
-- Purpose: Example queries for TCG Marketplace project

-- =========================
-- VIEW — 1 example
-- =========================
-- VIEW #1 - saves a select that shows a table of all ygo_cards and their parameters that appear in card table.
CREATE VIEW ygo_card_view AS
SELECT
  c.id,
  c.cardname,
  c.price,
  y.level,
  y."set"
FROM card c
JOIN ygo_card y ON y.id = c.id;

-- =========================
-- TRIGGER — 1 example
-- =========================
-- TRIGGER #1 -
CREATE OR REPLACE FUNCTION prevent_buying_own_card()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM card_instance ci
        JOIN cart c ON c.id = NEW.cart
        WHERE ci.id = NEW.card_instance
          AND ci.seller = c.buyer_id
    ) THEN
        RAISE EXCEPTION 'A seller cannot buy their own card listing.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_buying_own_card
BEFORE INSERT OR UPDATE ON specific_cart_item
FOR EACH ROW
EXECUTE FUNCTION prevent_buying_own_card();

-- =========================
-- READ (SELECT) — 6 examples
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

--Read #4 display all generic cart items where the card deosnt ecists in card table
SELECT *
FROM generic_cart_item g
WHERE NOT EXISTS (
    SELECT 1
    FROM card c
    WHERE c.id = g.card
);

-- Read #6: Show all generic cart items with cart, buyer, card name, quantity, and subtotal
SELECT 
  ct.id AS cart_id,
  a.id AS buyer_id,
  a.address AS buyer_address,
  c.cardname,
  gci.quantity,
  c.price,
  (gci.quantity * c.price) AS subtotal
FROM generic_cart_item gci
JOIN cart ct ON ct.id = gci.cart
JOIN acccount a ON a.id = ct.buyer_id
JOIN card c ON c.id = gci.card
ORDER BY ct.id, c.cardname,
-- =========================
-- UPDATE — 6 examples
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
-- DELETE — 6 examples
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

--DELETE #4 Delete an account entirely (cascades to cart, card_instance, specific_cart_item, Generic cart_item)
DELETE FROM account
WHERE id = 1;

--DELETE #5 Delete a generic cart item
DELETE FROM generic_cart_item g
WHERE NOT EXISTS (
  SELECT 1
    FROM card c
    WHERE c.id = g.card
);

--Delete #6 Delete all accounts
DELETE FROM account;

-- Roll back so the database isn't permanently changed by demo deletes
ROLLBACK;

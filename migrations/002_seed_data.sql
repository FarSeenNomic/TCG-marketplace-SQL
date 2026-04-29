-- 002_seed_data.sql
-- Purpose: Insert sample data (seed data)

-- 1. Insert into card
INSERT INTO card (id, cardname, price) VALUES
(1, 'Black Lotus', 50000.00),
(2, 'Blue-Eyes White Dragon', 1500.00),
(3, 'Elder Dragon', 30.00),
(4, 'Dark Magician', 250.00),
(5, 'Mox Pearl', 3000.00);

-- card IDs will be 1, 2, 3, 4, 5

-- 2. Insert into mtg_card
-- 1: Black Lotus, 5: Mox Pearl
INSERT INTO mtg_card (id, colour, "desc") VALUES
(1, 'black', 'Adds 3 mana of any single color of your choice to your mana pool.'),
(5, 'white', 'Adds 1 white mana to your mana pool.');

-- 3. Insert into ygo_card
-- 2: Blue-Eyes White Dragon, 4: Dark Magician
INSERT INTO ygo_card (id, level, "set") VALUES
(2, 8, 'Legend of Blue Eyes White Dragon'),
(4, 7, 'Legend of Blue Eyes White Dragon');

-- 4. Insert into eso_card
-- 3: Elder Dragon
INSERT INTO eso_card (id, "desc", "position", mana) VALUES
(3, 'A mighty Elder Dragon from the realm.', 'Frontline', 'High');

-- 5. Insert into account
INSERT INTO account (cc, address) VALUES
(1234567812345678, '123 Main St, Springfield'),
(8765432187654321, '456 Elm St, Shelbyville'),
(1111222233334444, '789 Oak Ave, Capital City');

-- account IDs: 1, 2, 3

-- 6. Insert into seller_brand
-- Account 1 sells MTG, Account 2 sells YGO
INSERT INTO seller_brand (id, game, seller_status) VALUES
(1, 'Magic: The Gathering', 'yes'),
(2, 'Yu-Gi-Oh!', 'pending');

-- 7. Insert into cart
-- Account 3 creates a cart
INSERT INTO cart (buyer, archive) VALUES
(3, FALSE),
(1, TRUE);

-- cart IDs: 1, 2

-- 8. Insert into card_instance
-- Sellers listing their cards
INSERT INTO card_instance (instance_of, condition, seller, date, processed) VALUES
(1, 9, 1, '2023-01-15', FALSE), -- Account 1 lists Black Lotus
(2, 8, 2, '2023-02-20', FALSE), -- Account 2 lists Blue-Eyes White Dragon
(4, 10, 2, '2023-03-05', TRUE);  -- Account 2 lists Dark Magician

-- card_instance IDs: 1, 2, 3

-- 9. Insert into specific_cart_item
-- Cart 1 adds specific card instances
INSERT INTO specific_cart_item (card, cart) VALUES
(1, 1),
(2, 1);

-- 10. Insert into generic_cart_item
-- Cart 2 adds a generic quantity of Elder Dragon
INSERT INTO generic_cart_item (quantity, card, cart) VALUES
(3, 3, 2),
(1, 5, 1);

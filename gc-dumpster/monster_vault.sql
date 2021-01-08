USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('vault_black_money', 'Money Vault', 0),
  ('society_police_black_money', 'Police Black Money', 1);

INSERT INTO `addon_inventory` (name, label, shared) VALUES ('vault', 'Vault', 0);

INSERT INTO `datastore` (name, label, shared) VALUES ('vault', 'Vault', 0);

INSERT INTO `items` (name, label, limit, rare, can_remove) VALUES ('taeratto_blackcard', 'บัตรดำ(ตู้เซฟ)', 1, 1, 0);
INSERT INTO roles (code, name) VALUES
('citoyen', 'Citoyen'),
('autorite', 'Autorite'),
('ministere', 'Ministere'),
('admin', 'Admin')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO provinces (name, code, centroid_latitude, centroid_longitude, ecological_score) VALUES
('Kinshasa', 'KIN', -4.3250000, 15.3222000, 68),
('Kongo Central', 'KCO', -5.8167000, 13.4500000, 74),
('Kwilu', 'KWI', -5.0389000, 18.8162000, 72),
('Haut-Katanga', 'HKA', -11.6647000, 27.4794000, 70)
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score);


INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Gombe', 'KIN-GOM', -4.3050000, 15.3120000, 78, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Limete', 'KIN-LIM', -4.3550000, 15.3470000, 64, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Barumbu', 'KIN-BAR', -4.3240000, 15.3270000, 52, 'critique' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Ngaliema', 'KIN-NGA', -4.3840000, 15.2250000, 69, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Masina', 'KIN-MAS', -4.3830000, 15.3910000, 58, 'critique' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Kalamu', 'KIN-KAL', -4.3450000, 15.3180000, 72, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Kisenso', 'KIN-KIS', -4.4180000, 15.3460000, 47, 'critique' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Nsele', 'KIN-NSE', -4.3160000, 15.5000000, 81, 'faible' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Lemba', 'KIN-LEM', -4.4000000, 15.3500000, 67, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Matete', 'KIN-MAT', -4.3833000, 15.3667000, 62, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Kasa-Vubu', 'KIN-KAV', -4.3333000, 15.3000000, 66, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Bandalungwa', 'KIN-BAN', -4.3333000, 15.2833000, 65, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Lingwala', 'KIN-LIN', -4.3167000, 15.3000000, 63, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Kinshasa', 'KIN-KIN', -4.3167000, 15.3167000, 61, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Kintambo', 'KIN-KIT', -4.3333000, 15.2667000, 70, 'modere' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Selembao', 'KIN-SEL', -4.3500000, 15.2667000, 59, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Bumbu', 'KIN-BUM', -4.3667000, 15.3000000, 57, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Makala', 'KIN-MAK', -4.3667000, 15.3167000, 56, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Ngaba', 'KIN-NGB', -4.3833000, 15.3333000, 60, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Ndjili', 'KIN-NDJ', -4.3833000, 15.3833000, 58, 'critique' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Kimbanseke', 'KIN-KIM', -4.4167000, 15.4333000, 51, 'critique' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Maluku', 'KIN-MLK', -4.0500000, 16.0500000, 84, 'faible' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Mont-Ngafula', 'KIN-MNG', -4.4333000, 15.2667000, 55, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

INSERT INTO communes (province_id, name, code, centroid_latitude, centroid_longitude, ecological_score, risk_level)
SELECT id, 'Ngiri-Ngiri', 'KIN-NGI', -4.3500000, 15.2833000, 60, 'eleve' FROM provinces WHERE code = 'KIN'
ON DUPLICATE KEY UPDATE ecological_score = VALUES(ecological_score), risk_level = VALUES(risk_level);

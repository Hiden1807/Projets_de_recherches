INSERT INTO users (role_id, province_id, commune_id, username, email, password, first_name, last_name, phone, organization, is_verified)
SELECT r.id, p.id, c.id, 'grace', 'grace@example.com', 'hashed-password-demo', 'Grace', 'Mbala', '+243810000001', 'Citoyenne', TRUE
FROM roles r, provinces p, communes c
WHERE r.code = 'citoyen' AND p.code = 'KIN' AND c.code = 'KIN-LIM'
ON DUPLICATE KEY UPDATE organization = VALUES(organization);

INSERT INTO users (role_id, province_id, commune_id, username, email, password, first_name, last_name, phone, organization, is_verified)
SELECT r.id, p.id, c.id, 'autorite.barumbu', 'autorite@example.com', 'hashed-password-demo', 'Jean', 'Kanku', '+243810000002', 'Brigade urbaine', TRUE
FROM roles r, provinces p, communes c
WHERE r.code = 'autorite' AND p.code = 'KIN' AND c.code = 'KIN-BAR'
ON DUPLICATE KEY UPDATE organization = VALUES(organization);

INSERT INTO users (role_id, province_id, commune_id, username, email, password, first_name, last_name, phone, organization, is_verified)
SELECT r.id, p.id, NULL, 'ministere', 'ministere@example.com', 'hashed-password-demo', 'Amina', 'Tshisekedi', '+243810000003', 'Ministere de l''Environnement', TRUE
FROM roles r, provinces p
WHERE r.code = 'ministere' AND p.code = 'KIN'
ON DUPLICATE KEY UPDATE organization = VALUES(organization);

INSERT INTO signalements (
  title, description, photo, created_by_id, category_id, province_id, commune_id,
  latitude, longitude, gps_accuracy, position_source, detected_category_label,
  gravity, urgency_level, status, ai_score, eco_score_impact, ai_summary,
  ai_recommendation, is_probable_duplicate, fraud_flags
)
SELECT
  'Caniveau bouche pres du marche',
  'Caniveau obstrue par des dechets plastiques, eau stagnante devant plusieurs boutiques.',
  'signalements/demo-caniveau.jpg',
  u.id, cat.id, p.id, c.id,
  -4.3218000, 15.3239000, 8.50, 'browser', 'Caniveau bouche',
  'eleve', 'intervention rapide', 'en_cours', 92, 17,
  'Caniveau obstrue avec risque d''inondation locale.',
  'Envoyer une equipe d''assainissement dans les 24 heures.',
  FALSE,
  JSON_ARRAY()
FROM users u, categories cat, provinces p, communes c
WHERE u.username = 'grace' AND cat.slug = 'caniveau-bouche' AND p.code = 'KIN' AND c.code = 'KIN-BAR';

INSERT INTO analyses_ia (
  signalement_id, category_detected, gravity, urgency, summary, recommendation,
  confidence_score, coherence, intervention_type, priority_level, recommended_delay,
  suggested_team, duplicate_probability, fraud_flags, raw_response
)
SELECT
  s.id, 'Caniveau bouche', 'eleve', 'intervention rapide',
  s.ai_summary, s.ai_recommendation, 92, 'forte', 'equipe terrain',
  'priorite haute', '24 heures', 'assainissement', 12, JSON_ARRAY(), JSON_OBJECT('provider', 'demo')
FROM signalements s
WHERE s.title = 'Caniveau bouche pres du marche';

INSERT INTO notifications (user_id, notification_type, title, message, payload)
SELECT u.id, 'signalement_received', 'Signalement recu', 'Votre signalement est en analyse IA.', JSON_OBJECT('signalement_id', s.id)
FROM users u, signalements s
WHERE u.username = 'grace' AND s.title = 'Caniveau bouche pres du marche';

INSERT INTO alertes (title, message, alert_type, severity, province_id, commune_id, starts_at, ends_at, published_by_id)
SELECT
  'Alerte pluie intense',
  'Fortes pluies prevues ce soir. Evitez de jeter des dechets dans les caniveaux.',
  'rain',
  'warning',
  p.id,
  c.id,
  NOW(),
  DATE_ADD(NOW(), INTERVAL 12 HOUR),
  u.id
FROM provinces p, communes c, users u
WHERE p.code = 'KIN' AND c.code = 'KIN-LIM' AND u.username = 'ministere';

INSERT INTO contenus_educatifs (title, slug, content_type, topic, excerpt, body, is_ai_generated, is_published)
VALUES
('Reduire les dechets plastiques dans le quartier', 'reduire-dechets-plastiques', 'article', 'Dechets', 'Gestes simples pour limiter les depots sauvages.', 'Organiser le tri local, eviter les depots informels et signaler les points noirs.', FALSE, TRUE),
('Prevenir les inondations avant les fortes pluies', 'prevenir-inondations', 'guide', 'Inondations', 'Identifier les drains sensibles et proteger les passages.', 'Verifier les caniveaux, alerter rapidement et documenter les zones recurrentes.', TRUE, TRUE);

INSERT INTO rapports (title, report_type, summary, statistics, major_incidents, recommendations, chart_payload, generated_by_id)
SELECT
  'Rapport national IA',
  'national',
  'Synthese nationale pilote Kinshasa avec recommandations IA.',
  JSON_OBJECT('total', 1, 'critique', 0, 'en_cours', 1),
  JSON_ARRAY(JSON_OBJECT('title', 'Caniveau bouche pres du marche', 'gravity', 'eleve')),
  JSON_ARRAY('Prioriser les drains obstrues', 'Publier un suivi hebdomadaire'),
  JSON_OBJECT('categories', JSON_ARRAY(JSON_OBJECT('name', 'Caniveau bouche', 'total', 1))),
  u.id
FROM users u
WHERE u.username = 'ministere';

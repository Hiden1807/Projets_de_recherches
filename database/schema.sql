CREATE DATABASE IF NOT EXISTS eco_rdc_intelligence CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eco_rdc_intelligence;

CREATE TABLE roles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(30) NOT NULL UNIQUE,
  name VARCHAR(80) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE provinces (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  code VARCHAR(16) NOT NULL UNIQUE,
  centroid_latitude DECIMAL(10,7),
  centroid_longitude DECIMAL(10,7),
  ecological_score TINYINT UNSIGNED DEFAULT 72,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE communes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  province_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(120) NOT NULL,
  code VARCHAR(24) NOT NULL UNIQUE,
  centroid_latitude DECIMAL(10,7),
  centroid_longitude DECIMAL(10,7),
  ecological_score TINYINT UNSIGNED DEFAULT 70,
  risk_level VARCHAR(20) DEFAULT 'modere',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_communes_province FOREIGN KEY (province_id) REFERENCES provinces(id),
  CONSTRAINT unique_commune_per_province UNIQUE (province_id, name),
  INDEX idx_communes_risk (province_id, risk_level)
);

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_id BIGINT UNSIGNED NOT NULL,
  province_id BIGINT UNSIGNED NULL,
  commune_id BIGINT UNSIGNED NULL,
  username VARCHAR(150) NOT NULL UNIQUE,
  email VARCHAR(254) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(150),
  last_name VARCHAR(150),
  phone VARCHAR(32),
  organization VARCHAR(160),
  avatar VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE,
  is_verified BOOLEAN DEFAULT FALSE,
  last_login TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id),
  CONSTRAINT fk_users_province FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE SET NULL,
  CONSTRAINT fk_users_commune FOREIGN KEY (commune_id) REFERENCES communes(id) ON DELETE SET NULL,
  INDEX idx_users_role (role_id),
  INDEX idx_users_commune (commune_id)
);

CREATE TABLE categories (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  slug VARCHAR(140) NOT NULL UNIQUE,
  icon VARCHAR(48) DEFAULT 'leaf',
  color VARCHAR(16) DEFAULT '#15803d',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE signalements (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  description TEXT NOT NULL,
  photo VARCHAR(255) NOT NULL,
  before_photo VARCHAR(255),
  after_photo VARCHAR(255),
  created_by_id BIGINT UNSIGNED NOT NULL,
  category_id BIGINT UNSIGNED NULL,
  province_id BIGINT UNSIGNED NULL,
  commune_id BIGINT UNSIGNED NULL,
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  gps_accuracy DECIMAL(9,2),
  position_source VARCHAR(20) DEFAULT 'unknown',
  exif_latitude DECIMAL(10,7),
  exif_longitude DECIMAL(10,7),
  exif_taken_at TIMESTAMP NULL,
  position_discrepancy_m INT UNSIGNED,
  detected_category_label VARCHAR(120),
  gravity VARCHAR(20) DEFAULT 'moyen',
  urgency_level VARCHAR(80),
  status VARCHAR(20) DEFAULT 'en_attente',
  ai_score TINYINT UNSIGNED DEFAULT 0,
  eco_score_impact TINYINT UNSIGNED DEFAULT 0,
  ai_summary TEXT,
  ai_recommendation TEXT,
  is_probable_duplicate BOOLEAN DEFAULT FALSE,
  duplicate_of_id BIGINT UNSIGNED NULL,
  fraud_flags JSON,
  authority_notes TEXT,
  resolved_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_signalements_user FOREIGN KEY (created_by_id) REFERENCES users(id),
  CONSTRAINT fk_signalements_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  CONSTRAINT fk_signalements_province FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE SET NULL,
  CONSTRAINT fk_signalements_commune FOREIGN KEY (commune_id) REFERENCES communes(id) ON DELETE SET NULL,
  CONSTRAINT fk_signalements_duplicate FOREIGN KEY (duplicate_of_id) REFERENCES signalements(id) ON DELETE SET NULL,
  INDEX idx_signalements_status_gravity (status, gravity),
  INDEX idx_signalements_commune_status (commune_id, status),
  INDEX idx_signalements_location (latitude, longitude),
  INDEX idx_signalements_created_category (created_at, category_id)
);

CREATE TABLE analyses_ia (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  signalement_id BIGINT UNSIGNED NOT NULL UNIQUE,
  category_detected VARCHAR(120) NOT NULL,
  gravity VARCHAR(20) NOT NULL,
  urgency VARCHAR(120),
  summary TEXT,
  recommendation TEXT,
  confidence_score TINYINT UNSIGNED DEFAULT 0,
  coherence VARCHAR(40) DEFAULT 'moyenne',
  intervention_type VARCHAR(120),
  priority_level VARCHAR(80),
  recommended_delay VARCHAR(80),
  suggested_team VARCHAR(120),
  duplicate_probability TINYINT UNSIGNED DEFAULT 0,
  fraud_flags JSON,
  raw_response JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ai_signalement FOREIGN KEY (signalement_id) REFERENCES signalements(id) ON DELETE CASCADE
);

CREATE TABLE status_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  signalement_id BIGINT UNSIGNED NOT NULL,
  old_status VARCHAR(20),
  new_status VARCHAR(20) NOT NULL,
  changed_by_id BIGINT UNSIGNED NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_history_signalement FOREIGN KEY (signalement_id) REFERENCES signalements(id) ON DELETE CASCADE,
  CONSTRAINT fk_history_user FOREIGN KEY (changed_by_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE historique_statuts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  signalement_id BIGINT UNSIGNED NOT NULL,
  old_status VARCHAR(20),
  new_status VARCHAR(20) NOT NULL,
  changed_by_id BIGINT UNSIGNED NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historique_signalement FOREIGN KEY (signalement_id) REFERENCES signalements(id) ON DELETE CASCADE,
  CONSTRAINT fk_historique_user FOREIGN KEY (changed_by_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_historique_signalement (signalement_id),
  INDEX idx_historique_created (created_at)
);

CREATE TABLE authority_comments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  signalement_id BIGINT UNSIGNED NOT NULL,
  author_id BIGINT UNSIGNED NULL,
  body TEXT NOT NULL,
  is_internal BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_comments_signalement FOREIGN KEY (signalement_id) REFERENCES signalements(id) ON DELETE CASCADE,
  CONSTRAINT fk_comments_user FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE preuves_resolution (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  signalement_id BIGINT UNSIGNED NOT NULL,
  photo VARCHAR(255) NOT NULL,
  comment TEXT NOT NULL,
  resolved_by_id BIGINT UNSIGNED NULL,
  resolved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  CONSTRAINT fk_preuves_signalement FOREIGN KEY (signalement_id) REFERENCES signalements(id) ON DELETE CASCADE,
  CONSTRAINT fk_preuves_user FOREIGN KEY (resolved_by_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_preuves_signalement (signalement_id),
  INDEX idx_preuves_resolved_at (resolved_at)
);

CREATE TABLE notifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  notification_type VARCHAR(40) NOT NULL,
  title VARCHAR(160) NOT NULL,
  message TEXT NOT NULL,
  payload JSON,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_notifications_user_read (user_id, is_read),
  INDEX idx_notifications_created (created_at)
);

CREATE TABLE alertes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  message TEXT NOT NULL,
  alert_type ENUM('rain', 'flood', 'pollution', 'erosion', 'sanitation', 'cleanup') NOT NULL,
  severity ENUM('info', 'watch', 'warning', 'critical') NOT NULL DEFAULT 'info',
  province_id BIGINT UNSIGNED NULL,
  commune_id BIGINT UNSIGNED NULL,
  starts_at TIMESTAMP NOT NULL,
  ends_at TIMESTAMP NULL,
  is_active BOOLEAN DEFAULT TRUE,
  is_official BOOLEAN DEFAULT TRUE,
  published_by_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_alertes_province FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE SET NULL,
  CONSTRAINT fk_alertes_commune FOREIGN KEY (commune_id) REFERENCES communes(id) ON DELETE SET NULL,
  CONSTRAINT fk_alertes_user FOREIGN KEY (published_by_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_alertes_active_severity (is_active, severity),
  INDEX idx_alertes_location (province_id, commune_id, is_active)
);

CREATE TABLE contenus_educatifs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  slug VARCHAR(200) NOT NULL UNIQUE,
  content_type VARCHAR(20) DEFAULT 'article',
  topic VARCHAR(120) NOT NULL,
  excerpt TEXT NOT NULL,
  body LONGTEXT NOT NULL,
  image VARCHAR(255),
  pdf_file VARCHAR(255),
  video_url VARCHAR(255),
  status ENUM('draft', 'published', 'archived') DEFAULT 'published',
  is_official BOOLEAN DEFAULT FALSE,
  is_featured BOOLEAN DEFAULT FALSE,
  approved_by_id BIGINT UNSIGNED NULL,
  published_at TIMESTAMP NULL,
  target_commune_id BIGINT UNSIGNED NULL,
  is_ai_generated BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT TRUE,
  author_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_content_commune FOREIGN KEY (target_commune_id) REFERENCES communes(id) ON DELETE SET NULL,
  CONSTRAINT fk_content_author FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_content_approved_by FOREIGN KEY (approved_by_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_content_topic (topic),
  INDEX idx_content_published (is_published),
  INDEX idx_content_status (status, is_official, is_featured)
);

CREATE TABLE publications_officielles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  slug VARCHAR(200) NOT NULL UNIQUE,
  publication_type ENUM('actualite', 'education', 'communique', 'rapport-public', 'campagne') NOT NULL,
  excerpt TEXT NOT NULL,
  body LONGTEXT,
  scope_label VARCHAR(120),
  province_id BIGINT UNSIGNED NULL,
  commune_id BIGINT UNSIGNED NULL,
  status ENUM('draft', 'published', 'archived') DEFAULT 'published',
  is_public BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  author_id BIGINT UNSIGNED NULL,
  published_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_publications_province FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE SET NULL,
  CONSTRAINT fk_publications_commune FOREIGN KEY (commune_id) REFERENCES communes(id) ON DELETE SET NULL,
  CONSTRAINT fk_publications_author FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_publications_type_status (publication_type, status, is_public),
  INDEX idx_publications_location (province_id, commune_id, status)
);

CREATE TABLE rapports (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  report_type VARCHAR(20) NOT NULL,
  summary TEXT NOT NULL,
  statistics JSON,
  major_incidents JSON,
  recommendations JSON,
  chart_payload JSON,
  pdf VARCHAR(255),
  generated_by_id BIGINT UNSIGNED NULL,
  generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_reports_user FOREIGN KEY (generated_by_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_reports_type (report_type),
  INDEX idx_reports_generated (generated_at)
);

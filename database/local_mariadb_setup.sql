CREATE DATABASE IF NOT EXISTS eco_rdc_intelligence
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'eco_rdc'@'localhost'
  IDENTIFIED BY 'eco_rdc_local_password';

CREATE USER IF NOT EXISTS 'eco_rdc'@'127.0.0.1'
  IDENTIFIED BY 'eco_rdc_local_password';

ALTER USER 'eco_rdc'@'localhost'
  IDENTIFIED BY 'eco_rdc_local_password';

ALTER USER 'eco_rdc'@'127.0.0.1'
  IDENTIFIED BY 'eco_rdc_local_password';

GRANT ALL PRIVILEGES ON eco_rdc_intelligence.* TO 'eco_rdc'@'localhost';
GRANT ALL PRIVILEGES ON eco_rdc_intelligence.* TO 'eco_rdc'@'127.0.0.1';

FLUSH PRIVILEGES;

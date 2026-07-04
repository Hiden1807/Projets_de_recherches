INSERT INTO categories (name, slug, icon, color) VALUES
('Dechets', 'dechets', 'trash-2', '#16a34a'),
('Inondation', 'inondation', 'waves', '#2563eb'),
('Erosion', 'erosion', 'mountain', '#b45309'),
('Pollution d''eau', 'pollution-deau', 'droplets', '#0891b2'),
('Caniveau bouche', 'caniveau-bouche', 'construction', '#475569'),
('Deforestation', 'deforestation', 'trees', '#15803d'),
('Pollution de l''air', 'pollution-de-lair', 'cloud', '#7c3aed'),
('Autre incident environnemental', 'autre-incident-environnemental', 'leaf', '#0f766e')
ON DUPLICATE KEY UPDATE color = VALUES(color), icon = VALUES(icon);


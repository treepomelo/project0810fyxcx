--  本地联调 Demo 数据；不会被正式 migration 自动执行。
SET NAMES utf8mb4;
-- One clearly marked local demo SPU makes both product systems independently testable.
-- It reuses the existing product category and is not a new production product model.
INSERT INTO product_spu (name, keyword, introduction, description, category_id, pic_url, price, market_price, cost_price, stock, status, tenant_id)
SELECT 'DEV_DEMO_传统风物礼盒', '非遗 美食 风物', '地方风物与非遗饮食文化礼盒', '本地联调用的传统风物商品。', 110, '/static/heritage/demo-food.jpg', 2990, 3990, 1990, 100, 1, 0
WHERE NOT EXISTS (SELECT 1 FROM product_spu WHERE name='DEV_DEMO_传统风物礼盒' AND deleted=0);
INSERT INTO heritage_service (product_system_id, title, cover_url, summary, description, price, city, location, booking_enabled, status, sort)
SELECT ps.id, 'DEV_DEMO_锡绣手作体验', '/static/heritage/demo-handcraft.jpg', '跟随老师完成一件锡绣作品', '适合初学者的非遗手作体验。', 9900, '苏州', '非遗体验馆', 1, 1, 1
FROM heritage_product_system ps WHERE ps.code='HANDCRAFT_EXPERIENCE' AND NOT EXISTS (SELECT 1 FROM heritage_service s WHERE s.title='DEV_DEMO_锡绣手作体验' AND s.deleted=0);
INSERT INTO heritage_service (product_system_id, title, cover_url, summary, description, price, city, location, booking_enabled, status, sort)
SELECT ps.id, 'DEV_DEMO_传统养生陪伴', '/static/heritage/demo-wellness.jpg', '传统养生文化陪伴服务', '面向成人的非医疗文化体验。', 12900, '杭州', '康养文化馆', 1, 1, 2
FROM heritage_product_system ps WHERE ps.code='WELLNESS_COMPANION' AND NOT EXISTS (SELECT 1 FROM heritage_service s WHERE s.title='DEV_DEMO_传统养生陪伴' AND s.deleted=0);
INSERT INTO heritage_service (product_system_id, title, cover_url, summary, description, price, city, location, booking_enabled, status, sort)
SELECT ps.id, 'DEV_DEMO_江南民俗演艺', '/static/heritage/demo-performance.jpg', '江南传统民俗演艺体验', '小型民俗演艺与文化讲解。', 15900, '苏州', '民俗剧场', 1, 1, 3
FROM heritage_product_system ps WHERE ps.code='FOLK_PERFORMANCE' AND NOT EXISTS (SELECT 1 FROM heritage_service s WHERE s.title='DEV_DEMO_江南民俗演艺' AND s.deleted=0);
INSERT INTO heritage_service_schedule (service_id, start_time, end_time, location, capacity, booked_count, status)
SELECT s.id, DATE_ADD(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 7 DAY) + INTERVAL 2 HOUR, s.location, 10, 0, 1 FROM heritage_service s WHERE s.title LIKE 'DEV_DEMO_%' AND s.deleted=0 AND NOT EXISTS (SELECT 1 FROM heritage_service_schedule x WHERE x.service_id=s.id AND x.start_time > NOW() AND x.deleted=0);
INSERT INTO heritage_service_schedule (service_id, start_time, end_time, location, capacity, booked_count, status)
SELECT s.id, DATE_ADD(NOW(), INTERVAL 21 DAY), DATE_ADD(NOW(), INTERVAL 21 DAY) + INTERVAL 2 HOUR, s.location, 0, 0, 1 FROM heritage_service s WHERE s.title LIKE 'DEV_DEMO_%' AND s.deleted=0 AND NOT EXISTS (SELECT 1 FROM heritage_service_schedule x WHERE x.service_id=s.id AND x.start_time > DATE_ADD(NOW(), INTERVAL 14 DAY) AND x.deleted=0);
INSERT IGNORE INTO heritage_product_system_spu (product_system_id, spu_id, sort, status)
SELECT ps.id, p.id, 1, 1 FROM heritage_product_system ps JOIN (SELECT id FROM product_spu WHERE status=1 AND deleted=0 ORDER BY id LIMIT 1) p ON 1=1 WHERE ps.code='CULTURAL_CREATIVE';
INSERT IGNORE INTO heritage_product_system_spu (product_system_id, spu_id, sort, status)
SELECT ps.id, p.id, 1, 1 FROM heritage_product_system ps JOIN (SELECT id FROM product_spu WHERE status=1 AND deleted=0 ORDER BY id LIMIT 1 OFFSET 1) p ON 1=1 WHERE ps.code='HERITAGE_FOOD';

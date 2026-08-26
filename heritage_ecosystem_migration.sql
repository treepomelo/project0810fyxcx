-- 一期非遗生态模块独立迁移；MySQL 8，幂等、无物理外键、不修改既有表。
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS heritage_product_system (
  id BIGINT NOT NULL AUTO_INCREMENT,
  code VARCHAR(64) NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500) NULL,
  icon_url VARCHAR(500) NULL,
  cover_url VARCHAR(500) NULL,
  sort INT NOT NULL DEFAULT 0,
  status TINYINT NOT NULL DEFAULT 1,
  creator VARCHAR(64) NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updater VARCHAR(64) NULL,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted BIT NOT NULL DEFAULT b'0',
  tenant_id BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id), UNIQUE KEY uk_heritage_product_system_code (code),
  KEY idx_heritage_product_system_status_sort (status, deleted, sort, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗五大产品体系';

CREATE TABLE IF NOT EXISTS heritage_product_system_spu (
  id BIGINT NOT NULL AUTO_INCREMENT,
  product_system_id BIGINT NOT NULL,
  spu_id BIGINT NOT NULL,
  sort INT NOT NULL DEFAULT 0,
  status TINYINT NOT NULL DEFAULT 1,
  creator VARCHAR(64) NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updater VARCHAR(64) NULL,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted BIT NOT NULL DEFAULT b'0',
  tenant_id BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id), UNIQUE KEY uk_heritage_system_spu (product_system_id, spu_id),
  KEY idx_heritage_system_spu_system (product_system_id, status, deleted, sort, id),
  KEY idx_heritage_system_spu_spu (spu_id, status, deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗产品体系与商城SPU关系';

CREATE TABLE IF NOT EXISTS heritage_service (
  id BIGINT NOT NULL AUTO_INCREMENT,
  product_system_id BIGINT NOT NULL,
  title VARCHAR(200) NOT NULL,
  cover_url VARCHAR(500) NULL,
  summary VARCHAR(500) NULL,
  description TEXT NULL,
  price INT NOT NULL DEFAULT 0,
  city VARCHAR(100) NULL,
  location VARCHAR(255) NULL,
  booking_enabled BIT NOT NULL DEFAULT b'0',
  status TINYINT NOT NULL DEFAULT 0,
  sort INT NOT NULL DEFAULT 0,
  creator VARCHAR(64) NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updater VARCHAR(64) NULL,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted BIT NOT NULL DEFAULT b'0',
  tenant_id BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id), KEY idx_heritage_service_system (product_system_id, status, deleted, sort, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗统一服务';

CREATE TABLE IF NOT EXISTS heritage_service_schedule (
  id BIGINT NOT NULL AUTO_INCREMENT,
  service_id BIGINT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  location VARCHAR(255) NULL,
  capacity INT NOT NULL DEFAULT 0,
  booked_count INT NOT NULL DEFAULT 0,
  status TINYINT NOT NULL DEFAULT 1,
  creator VARCHAR(64) NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updater VARCHAR(64) NULL,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted BIT NOT NULL DEFAULT b'0',
  tenant_id BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id), KEY idx_heritage_schedule_service (service_id, status, deleted, start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗服务场次';

CREATE TABLE IF NOT EXISTS heritage_service_booking (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  service_id BIGINT NOT NULL,
  schedule_id BIGINT NOT NULL,
  contact_name VARCHAR(100) NOT NULL,
  contact_phone VARCHAR(32) NOT NULL,
  people_count INT NOT NULL,
  remark VARCHAR(500) NULL,
  status TINYINT NOT NULL DEFAULT 0,
  creator VARCHAR(64) NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updater VARCHAR(64) NULL,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted BIT NOT NULL DEFAULT b'0',
  tenant_id BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id), KEY idx_heritage_booking_user (user_id, status, deleted, create_time),
  KEY idx_heritage_booking_schedule (schedule_id, status, deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗服务预约';

CREATE TABLE IF NOT EXISTS heritage_cooperation_application (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  company_name VARCHAR(200) NOT NULL,
  contact_name VARCHAR(100) NOT NULL,
  contact_phone VARCHAR(32) NOT NULL,
  cooperation_type VARCHAR(64) NOT NULL,
  requirement VARCHAR(1000) NOT NULL,
  status TINYINT NOT NULL DEFAULT 0,
  admin_remark VARCHAR(1000) NULL,
  processed_by BIGINT NULL,
  processed_time DATETIME NULL,
  creator VARCHAR(64) NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updater VARCHAR(64) NULL,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted BIT NOT NULL DEFAULT b'0',
  tenant_id BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id), KEY idx_heritage_cooperation_user (user_id, status, deleted, create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗合作申请';

INSERT IGNORE INTO heritage_product_system (code, name, description, sort, status)
VALUES
 ('CULTURAL_CREATIVE', '文创雅物', '非遗元素衍生的文创产品与生活美学内容', 1, 1),
 ('HERITAGE_FOOD', '美食风物', '具有非遗文化特色的饮食与地方风物', 2, 1),
 ('HANDCRAFT_EXPERIENCE', '手作体验', '可预约的非遗手作体验服务', 3, 1),
 ('WELLNESS_COMPANION', '康养陪伴', '非遗文化相关的康养与陪伴服务', 4, 1),
 ('FOLK_PERFORMANCE', '民俗演艺', '非遗民俗表演与演艺服务', 5, 1);

-- RC1 Final Closure: Admin permission definitions. Role assignment remains deployment-specific.
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Product-System-SPU Query', 'heritage:product-system-spu:query', 3, 1, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:product-system-spu:query' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Product-System-SPU Create', 'heritage:product-system-spu:create', 3, 2, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:product-system-spu:create' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Product-System-SPU Update', 'heritage:product-system-spu:update', 3, 3, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:product-system-spu:update' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Product-System-SPU Delete', 'heritage:product-system-spu:delete', 3, 4, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:product-system-spu:delete' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Schedule Create', 'heritage:schedule:create', 3, 5, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:schedule:create' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Schedule Update', 'heritage:schedule:update', 3, 6, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:schedule:update' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Schedule Delete', 'heritage:schedule:delete', 3, 7, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:schedule:delete' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Service Update', 'heritage:service:update', 3, 8, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:service:update' AND deleted=0);
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status, visible, keep_alive, always_show, creator, updater)
SELECT 'Heritage Service Delete', 'heritage:service:delete', 3, 9, 0, '', '#', NULL, 0, b'1', b'1', b'1', 'migration', 'migration'
WHERE NOT EXISTS (SELECT 1 FROM system_menu WHERE permission='heritage:service:delete' AND deleted=0);
/*
 Navicat Premium Data Transfer

 Source Server         : mysql_01
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : localhost:3306
 Source Schema         : heritage_ruoyi

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 26/08/2026 16:11:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for heritage_category
-- ----------------------------
DROP TABLE IF EXISTS `heritage_category`;
CREATE TABLE `heritage_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `tenant_id` bigint NOT NULL DEFAULT 1,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_category_code`(`code` ASC, `tenant_id` ASC, `deleted` ASC) USING BTREE,
  INDEX `idx_heritage_category_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Heritage category' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_category
-- ----------------------------

-- ----------------------------
-- Table structure for heritage_cooperation_application
-- ----------------------------
DROP TABLE IF EXISTS `heritage_cooperation_application`;
CREATE TABLE `heritage_cooperation_application`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `company_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cooperation_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `requirement` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `admin_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `processed_by` bigint NULL DEFAULT NULL,
  `processed_time` datetime NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_heritage_cooperation_user`(`user_id` ASC, `status` ASC, `deleted` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗合作申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_cooperation_application
-- ----------------------------
INSERT INTO `heritage_cooperation_application` VALUES (1, 11, 'DEV_E2E_COMPANY', 'DEV_E2E_MEMBER_A', '19900000001', 'CULTURAL_TOURISM', 'local e2e cooperation', 1, NULL, NULL, NULL, '11', '2026-08-26 01:11:17', '233', '2026-08-26 01:16:00', b'0', 0);
INSERT INTO `heritage_cooperation_application` VALUES (2, 11, 'DEV_E2E_RC1_20260826091613 company', 'E2E A', '19900000001', 'CULTURAL_TOURISM', 'DEV_E2E_RC1_20260826091613 cooperation', 1, NULL, 233, '2026-08-26 09:16:17', '11', '2026-08-26 09:16:17', '233', '2026-08-26 09:16:17', b'0', 0);
INSERT INTO `heritage_cooperation_application` VALUES (3, 11, 'DEV_E2E_RC1_DB_20260826091640', 'A', '19900000001', 'CULTURAL_TOURISM', 'DEV_E2E_RC1_DB_20260826091640', 1, NULL, 233, '2026-08-26 09:16:42', '11', '2026-08-26 09:16:41', '233', '2026-08-26 09:16:42', b'0', 0);
INSERT INTO `heritage_cooperation_application` VALUES (4, 11, 'DEV_E2E_FINAL_20260826105000 company', 'E2E A', '19900000001', 'CULTURAL_TOURISM', 'DEV_E2E_FINAL_20260826105000 cooperation', 2, NULL, 233, '2026-08-26 10:44:29', '11', '2026-08-26 10:44:30', '233', '2026-08-26 10:44:29', b'0', 0);
INSERT INTO `heritage_cooperation_application` VALUES (5, 11, 'DEV_E2E_FINAL_20260826105000 rejected', 'E2E A', '19900000001', 'HERITAGE_EVENT', 'DEV_E2E_FINAL_20260826105000 rejected', 3, NULL, 233, '2026-08-26 10:44:30', '11', '2026-08-26 10:44:30', '233', '2026-08-26 10:44:30', b'0', 0);
INSERT INTO `heritage_cooperation_application` VALUES (6, 11, 'DEV_E2E_FINAL_20260826110000 company', 'E2E A', '19900000001', 'CULTURAL_TOURISM', 'DEV_E2E_FINAL_20260826110000 cooperation', 2, NULL, 233, '2026-08-26 10:50:07', '11', '2026-08-26 10:50:07', '233', '2026-08-26 10:50:07', b'0', 0);
INSERT INTO `heritage_cooperation_application` VALUES (7, 11, 'DEV_E2E_FINAL_20260826110000 rejected', 'E2E A', '19900000001', 'HERITAGE_EVENT', 'DEV_E2E_FINAL_20260826110000 rejected', 3, NULL, 233, '2026-08-26 10:50:07', '11', '2026-08-26 10:50:08', '233', '2026-08-26 10:50:07', b'0', 0);

-- ----------------------------
-- Table structure for heritage_legacy_id_map
-- ----------------------------
DROP TABLE IF EXISTS `heritage_legacy_id_map`;
CREATE TABLE `heritage_legacy_id_map`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint NOT NULL,
  `entity_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `legacy_id` bigint NOT NULL,
  `target_id` bigint NULL DEFAULT NULL,
  `checksum` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_legacy_map`(`entity_type` ASC, `legacy_id` ASC, `batch_id` ASC) USING BTREE,
  INDEX `idx_heritage_legacy_batch`(`batch_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Heritage legacy id map' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_legacy_id_map
-- ----------------------------

-- ----------------------------
-- Table structure for heritage_level
-- ----------------------------
DROP TABLE IF EXISTS `heritage_level`;
CREATE TABLE `heritage_level`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `tenant_id` bigint NOT NULL DEFAULT 1,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_level_code`(`code` ASC, `tenant_id` ASC, `deleted` ASC) USING BTREE,
  INDEX `idx_heritage_level_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Heritage level' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_level
-- ----------------------------

-- ----------------------------
-- Table structure for heritage_migration_batch
-- ----------------------------
DROP TABLE IF EXISTS `heritage_migration_batch`;
CREATE TABLE `heritage_migration_batch`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_schema` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_count` int NOT NULL DEFAULT 0,
  `success_count` int NOT NULL DEFAULT 0,
  `isolated_count` int NOT NULL DEFAULT 0,
  `conflict_count` int NOT NULL DEFAULT 0,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `started_at` datetime NULL DEFAULT NULL,
  `finished_at` datetime NULL DEFAULT NULL,
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_batch_no`(`batch_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Heritage migration batch' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_migration_batch
-- ----------------------------

-- ----------------------------
-- Table structure for heritage_product_system
-- ----------------------------
DROP TABLE IF EXISTS `heritage_product_system`;
CREATE TABLE `heritage_product_system`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `icon_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_product_system_code`(`code` ASC) USING BTREE,
  INDEX `idx_heritage_product_system_status_sort`(`status` ASC, `deleted` ASC, `sort` ASC, `id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗五大产品体系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_product_system
-- ----------------------------
INSERT INTO `heritage_product_system` VALUES (1, 'CULTURAL_CREATIVE', '文创雅物', '非遗元素衍生的文创产品与生活美学内容', NULL, NULL, 1, 1, NULL, '2026-08-25 23:14:54', NULL, '2026-08-25 23:14:54', b'0', 0);
INSERT INTO `heritage_product_system` VALUES (2, 'HERITAGE_FOOD', '美食风物', '具有非遗文化特色的饮食与地方风物', NULL, NULL, 2, 1, NULL, '2026-08-25 23:14:54', NULL, '2026-08-25 23:14:54', b'0', 0);
INSERT INTO `heritage_product_system` VALUES (3, 'HANDCRAFT_EXPERIENCE', '手作体验', '可预约的非遗手作体验服务', NULL, NULL, 3, 1, NULL, '2026-08-25 23:14:54', NULL, '2026-08-25 23:14:54', b'0', 0);
INSERT INTO `heritage_product_system` VALUES (4, 'WELLNESS_COMPANION', '康养陪伴', '非遗文化相关的康养与陪伴服务', NULL, NULL, 4, 1, NULL, '2026-08-25 23:14:54', NULL, '2026-08-25 23:14:54', b'0', 0);
INSERT INTO `heritage_product_system` VALUES (5, 'FOLK_PERFORMANCE', '民俗演艺', '非遗民俗表演与演艺服务', NULL, NULL, 5, 1, NULL, '2026-08-25 23:14:54', NULL, '2026-08-25 23:14:54', b'0', 0);

-- ----------------------------
-- Table structure for heritage_product_system_spu
-- ----------------------------
DROP TABLE IF EXISTS `heritage_product_system_spu`;
CREATE TABLE `heritage_product_system_spu`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_system_id` bigint NOT NULL,
  `spu_id` bigint NOT NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_system_spu`(`product_system_id` ASC, `spu_id` ASC) USING BTREE,
  INDEX `idx_heritage_system_spu_system`(`product_system_id` ASC, `status` ASC, `deleted` ASC, `sort` ASC, `id` ASC) USING BTREE,
  INDEX `idx_heritage_system_spu_spu`(`spu_id` ASC, `status` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗产品体系与商城SPU关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_product_system_spu
-- ----------------------------
INSERT INTO `heritage_product_system_spu` VALUES (1, 1, 85, 1, 1, NULL, '2026-08-25 23:15:24', NULL, '2026-08-25 23:15:24', b'0', 0);
INSERT INTO `heritage_product_system_spu` VALUES (6, 2, 86, 1, 1, NULL, '2026-08-26 09:15:46', NULL, '2026-08-26 09:20:10', b'0', 0);
INSERT INTO `heritage_product_system_spu` VALUES (20, 1, 86, 90, 1, '233', '2026-08-26 10:44:07', '233', '2026-08-26 10:50:06', b'1', 0);

-- ----------------------------
-- Table structure for heritage_project
-- ----------------------------
DROP TABLE IF EXISTS `heritage_project`;
CREATE TABLE `heritage_project`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `official_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint NOT NULL,
  `level_id` bigint NOT NULL,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `region` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `recommended` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 1,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_heritage_project_no`(`project_no` ASC, `tenant_id` ASC, `deleted` ASC) USING BTREE,
  INDEX `idx_heritage_project_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_heritage_project_level`(`level_id` ASC) USING BTREE,
  INDEX `idx_heritage_project_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Heritage project' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_project
-- ----------------------------

-- ----------------------------
-- Table structure for heritage_service
-- ----------------------------
DROP TABLE IF EXISTS `heritage_service`;
CREATE TABLE `heritage_service`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_system_id` bigint NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `price` int NOT NULL DEFAULT 0,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `booking_enabled` bit(1) NOT NULL DEFAULT b'0',
  `status` tinyint NOT NULL DEFAULT 0,
  `sort` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_heritage_service_system`(`product_system_id` ASC, `status` ASC, `deleted` ASC, `sort` ASC, `id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗统一服务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_service
-- ----------------------------
INSERT INTO `heritage_service` VALUES (4, 3, 'DEV_DEMO_锡绣手作体验', '/static/heritage/demo-handcraft.jpg', '跟随老师完成一件锡绣作品', '适合初学者的非遗手作体验。', 9900, '苏州', '非遗体验馆', b'1', 1, 1, NULL, '2026-08-26 09:18:25', '233', '2026-08-26 14:34:01', b'0', 0);
INSERT INTO `heritage_service` VALUES (5, 4, 'DEV_DEMO_传统养生陪伴', '/static/heritage/demo-wellness.jpg', '传统养生文化陪伴服务', '面向成人的非医疗文化体验。', 12900, '杭州', '康养文化馆', b'1', 1, 2, NULL, '2026-08-26 09:18:25', NULL, '2026-08-26 09:18:25', b'0', 0);
INSERT INTO `heritage_service` VALUES (6, 5, 'DEV_DEMO_江南民俗演艺', '/static/heritage/demo-performance.jpg', '江南传统民俗演艺体验', '小型民俗演艺与文化讲解。', 15900, '苏州', '民俗剧场', b'1', 1, 3, NULL, '2026-08-26 09:18:25', NULL, '2026-08-26 09:18:25', b'0', 0);

-- ----------------------------
-- Table structure for heritage_service_booking
-- ----------------------------
DROP TABLE IF EXISTS `heritage_service_booking`;
CREATE TABLE `heritage_service_booking`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `service_id` bigint NOT NULL,
  `schedule_id` bigint NOT NULL,
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `people_count` int NOT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_heritage_booking_user`(`user_id` ASC, `status` ASC, `deleted` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_heritage_booking_schedule`(`schedule_id` ASC, `status` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗服务预约' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_service_booking
-- ----------------------------
INSERT INTO `heritage_service_booking` VALUES (13, 11, 4, 9, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826105000 booking', 4, '11', '2026-08-26 10:44:29', '233', '2026-08-26 10:44:29', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (14, 11, 4, 9, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826105000 booking', 2, '11', '2026-08-26 10:44:29', '11', '2026-08-26 10:44:29', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (15, 11, 4, 9, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826105000 reject', 3, '11', '2026-08-26 10:44:29', '233', '2026-08-26 10:44:29', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (16, 11, 4, 12, 'E2E A', '19900000001', 1, 'DEV_E2E_FINAL_20260826105000 unlimited A', 2, '11', '2026-08-26 10:44:30', '11', '2026-08-26 10:44:29', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (17, 12, 4, 12, 'E2E B', '19900000002', 1, 'DEV_E2E_FINAL_20260826105000 unlimited B', 2, '12', '2026-08-26 10:44:30', '12', '2026-08-26 10:44:29', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (18, 11, 4, 9, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826110000 booking', 4, '11', '2026-08-26 10:50:07', '233', '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (19, 11, 4, 9, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826110000 booking', 2, '11', '2026-08-26 10:50:07', '11', '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (20, 11, 4, 9, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826110000 reject', 3, '11', '2026-08-26 10:50:07', '233', '2026-08-26 10:50:07', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (21, 11, 4, 12, 'E2E A', '19900000001', 1, 'DEV_E2E_FINAL_20260826110000 unlimited A', 2, '11', '2026-08-26 10:50:07', '11', '2026-08-26 10:50:07', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (22, 12, 4, 12, 'E2E B', '19900000002', 1, 'DEV_E2E_FINAL_20260826110000 unlimited B', 2, '12', '2026-08-26 10:50:07', '12', '2026-08-26 10:50:07', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (23, 11, 4, 15, 'E2E A', '19900000001', 2, 'DEV_E2E_FINAL_20260826110000 active schedule', 2, '11', '2026-08-26 10:50:08', '11', '2026-08-26 10:50:08', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (24, 10, 6, 11, 'DEV_E2E_USER_A', '17712341234', 1, 'INHERIT_PHASE1_E2E', 2, '10', '2026-08-26 15:42:21', '10', '2026-08-26 15:42:21', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (25, 10, 6, 11, 'DEV_E2E_USER_A', '17712341234', 1, 'INHERIT_PHASE1_E2E', 2, '10', '2026-08-26 15:42:57', '10', '2026-08-26 15:42:59', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (26, 10, 6, 11, 'DEV_E2E_USER_A', '17712341234', 1, 'INHERIT_PHASE1_E2E', 2, '10', '2026-08-26 15:43:34', '10', '2026-08-26 15:43:34', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (27, 10, 6, 11, 'DEV_E2E_USER_A', '17712341234', 1, 'INHERIT_PHASE1_E2E', 2, '10', '2026-08-26 15:45:25', '10', '2026-08-26 15:45:25', b'0', 0);
INSERT INTO `heritage_service_booking` VALUES (28, 10, 6, 11, 'DEV_E2E_USER_A', '17712341234', 1, 'INHERIT_PHASE1_E2E', 2, '10', '2026-08-26 15:49:54', '10', '2026-08-26 15:49:54', b'0', 0);

-- ----------------------------
-- Table structure for heritage_service_schedule
-- ----------------------------
DROP TABLE IF EXISTS `heritage_service_schedule`;
CREATE TABLE `heritage_service_schedule`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `service_id` bigint NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `capacity` int NOT NULL DEFAULT 0,
  `booked_count` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_heritage_schedule_service`(`service_id` ASC, `status` ASC, `deleted` ASC, `start_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗服务场次' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage_service_schedule
-- ----------------------------
INSERT INTO `heritage_service_schedule` VALUES (9, 4, '2026-09-02 09:18:25', '2026-09-02 11:18:25', '非遗体验馆', 10, 4, 1, NULL, '2026-08-26 09:18:25', '233', '2026-08-26 10:50:07', b'0', 0);
INSERT INTO `heritage_service_schedule` VALUES (10, 5, '2026-09-02 09:18:25', '2026-09-02 11:18:25', '康养文化馆', 10, 0, 1, NULL, '2026-08-26 09:18:25', NULL, '2026-08-26 09:18:25', b'0', 0);
INSERT INTO `heritage_service_schedule` VALUES (11, 6, '2026-09-02 09:18:25', '2026-09-02 11:18:25', '民俗剧场', 10, 0, 1, NULL, '2026-08-26 09:18:25', '10', '2026-08-26 15:49:54', b'0', 0);
INSERT INTO `heritage_service_schedule` VALUES (12, 4, '2026-09-16 09:18:25', '2026-09-16 11:18:25', '非遗体验馆', 0, 0, 1, NULL, '2026-08-26 09:18:25', '12', '2026-08-26 10:50:07', b'0', 0);
INSERT INTO `heritage_service_schedule` VALUES (13, 5, '2026-09-16 09:18:25', '2026-09-16 11:18:25', '康养文化馆', 0, 0, 1, NULL, '2026-08-26 09:18:25', NULL, '2026-08-26 09:18:25', b'0', 0);
INSERT INTO `heritage_service_schedule` VALUES (14, 6, '2026-09-16 09:18:25', '2026-09-16 11:18:25', '民俗剧场', 0, 0, 1, NULL, '2026-08-26 09:18:25', NULL, '2026-08-26 09:18:25', b'0', 0);
INSERT INTO `heritage_service_schedule` VALUES (15, 4, '2026-08-26 13:50:08', '2026-08-26 15:50:08', 'DEV_E2E_FINAL_20260826110000 updated', 4, 0, 1, '233', '2026-08-26 10:50:08', '233', '2026-08-26 10:50:08', b'1', 0);

-- ----------------------------
-- Table structure for infra_api_access_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_api_access_log`;
CREATE TABLE `infra_api_access_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '??????',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '?????',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '????',
  `response_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '????',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??? UA',
  `operate_module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `operate_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '???',
  `operate_type` tinyint NULL DEFAULT 0 COMMENT '????',
  `begin_time` datetime NOT NULL COMMENT '??????',
  `end_time` datetime NOT NULL COMMENT '??????',
  `duration` int NOT NULL COMMENT '????',
  `result_code` int NOT NULL DEFAULT 0 COMMENT '???',
  `result_msg` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37032 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'API ?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_api_access_log
-- ----------------------------

-- ----------------------------
-- Table structure for infra_api_error_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_api_error_log`;
CREATE TABLE `infra_api_error_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `application_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `request_params` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??? UA',
  `exception_time` datetime NOT NULL COMMENT '??????',
  `exception_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '???',
  `exception_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???????',
  `exception_root_cause_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????????',
  `exception_stack_trace` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `exception_class_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????????',
  `exception_file_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????????',
  `exception_method_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????????',
  `exception_line_number` int NOT NULL COMMENT '??????????',
  `process_status` tinyint NOT NULL COMMENT '????',
  `process_time` datetime NULL DEFAULT NULL COMMENT '????',
  `process_user_id` int NULL DEFAULT 0 COMMENT '??????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24515 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_api_error_log
-- ----------------------------

-- ----------------------------
-- Table structure for infra_codegen_column
-- ----------------------------
DROP TABLE IF EXISTS `infra_codegen_column`;
CREATE TABLE `infra_codegen_column`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `table_id` bigint NOT NULL COMMENT '???',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `data_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `nullable` bit(1) NOT NULL COMMENT '??????',
  `primary_key` bit(1) NOT NULL COMMENT '????',
  `ordinal_position` int NOT NULL COMMENT '??',
  `java_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Java ????',
  `java_field` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Java ???',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `example` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `create_operation` bit(1) NOT NULL COMMENT '??? Create ???????',
  `update_operation` bit(1) NOT NULL COMMENT '??? Update ???????',
  `list_operation` bit(1) NOT NULL COMMENT '??? List ???????',
  `list_operation_condition` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '=' COMMENT 'List ?????????',
  `list_operation_result` bit(1) NOT NULL COMMENT '??? List ?????????',
  `html_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_table_id`(`table_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2880 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_codegen_column
-- ----------------------------

-- ----------------------------
-- Table structure for infra_codegen_table
-- ----------------------------
DROP TABLE IF EXISTS `infra_codegen_table`;
CREATE TABLE `infra_codegen_table`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `data_source_config_id` bigint NOT NULL COMMENT '????????',
  `scene` tinyint NOT NULL DEFAULT 1 COMMENT '????',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '???',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '???',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '???',
  `class_comment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??',
  `template_type` tinyint NOT NULL DEFAULT 1 COMMENT '????',
  `front_type` tinyint NOT NULL COMMENT '????',
  `parent_menu_id` bigint NULL DEFAULT NULL COMMENT '?????',
  `master_table_id` bigint NULL DEFAULT NULL COMMENT '?????',
  `sub_join_column_id` bigint NULL DEFAULT NULL COMMENT '???????????',
  `sub_join_many` bit(1) NULL DEFAULT NULL COMMENT '??????????',
  `tree_parent_column_id` bigint NULL DEFAULT NULL COMMENT '????????',
  `tree_name_column_id` bigint NULL DEFAULT NULL COMMENT '?????????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 210 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '???????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_codegen_table
-- ----------------------------

-- ----------------------------
-- Table structure for infra_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_config`;
CREATE TABLE `infra_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `type` tinyint NOT NULL COMMENT '????',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `visible` bit(1) NOT NULL COMMENT '????',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_config
-- ----------------------------
INSERT INTO `infra_config` VALUES (2, 'biz', 1, '用户管理-账号初始密码', 'system.user.init-password', '123456', b'0', '初始化密码 123456', 'admin', '2021-01-05 17:03:48', '1', '2024-07-20 17:22:47', b'0');
INSERT INTO `infra_config` VALUES (7, 'url', 2, 'MySQL 监控的地址', 'url.druid', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:33:38', b'0');
INSERT INTO `infra_config` VALUES (8, 'url', 2, 'SkyWalking 监控的地址', 'url.skywalking', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:57:03', b'0');
INSERT INTO `infra_config` VALUES (9, 'url', 2, 'Spring Boot Admin 监控的地址', 'url.spring-boot-admin', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:52:07', b'0');
INSERT INTO `infra_config` VALUES (10, 'url', 2, 'Swagger 接口文档的地址', 'url.swagger', '', b'1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:59:00', b'0');
INSERT INTO `infra_config` VALUES (12, 'test2', 2, 'test3', 'test4', 'test5', b'1', 'test6', '1', '2023-12-03 09:55:16', '1', '2025-04-06 21:00:09', b'0');
INSERT INTO `infra_config` VALUES (13, '用户管理-账号初始密码', 2, '用户管理-注册开关', 'system.user.register-enabled', 'true', b'0', '', '1', '2025-04-26 17:23:41', '1', '2025-04-26 17:23:41', b'0');

-- ----------------------------
-- Table structure for infra_data_source_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_data_source_config`;
CREATE TABLE `infra_data_source_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_data_source_config
-- ----------------------------

-- ----------------------------
-- Table structure for infra_file
-- ----------------------------
DROP TABLE IF EXISTS `infra_file`;
CREATE TABLE `infra_file`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `config_id` bigint NULL DEFAULT NULL COMMENT '????',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '???',
  `path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? URL',
  `type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `size` int NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2330 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '???' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_file
-- ----------------------------

-- ----------------------------
-- Table structure for infra_file_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_config`;
CREATE TABLE `infra_file_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `storage` tinyint NOT NULL COMMENT '???',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `master` bit(1) NOT NULL COMMENT '??????',
  `config` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_file_config
-- ----------------------------

-- ----------------------------
-- Table structure for infra_file_content
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_content`;
CREATE TABLE `infra_file_content`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `config_id` bigint NOT NULL COMMENT '????',
  `path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `content` mediumblob NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_config_id_path`(`config_id` ASC, `path` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 358 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '???' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_file_content
-- ----------------------------

-- ----------------------------
-- Table structure for infra_job
-- ----------------------------
DROP TABLE IF EXISTS `infra_job`;
CREATE TABLE `infra_job`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '????',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `handler_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????',
  `cron_expression` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'CRON ???',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT '????',
  `retry_interval` int NOT NULL DEFAULT 0 COMMENT '????',
  `monitor_timeout` int NOT NULL DEFAULT 0 COMMENT '??????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_job
-- ----------------------------

-- ----------------------------
-- Table structure for infra_job_log
-- ----------------------------
DROP TABLE IF EXISTS `infra_job_log`;
CREATE TABLE `infra_job_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `job_id` bigint NOT NULL COMMENT '????',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `handler_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????',
  `execute_index` tinyint NOT NULL DEFAULT 1 COMMENT '?????',
  `begin_time` datetime NOT NULL COMMENT '??????',
  `end_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `duration` int NULL DEFAULT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '????',
  `result` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_job_id`(`job_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 987 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '???????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of infra_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for inherit_inheritor
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor`;
CREATE TABLE `inherit_inheritor`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `pinyin` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名拼音',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `cover` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图',
  `gender` tinyint NOT NULL DEFAULT 0 COMMENT '性别',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '传承人级别',
  `province_code` int NULL DEFAULT NULL COMMENT '省编码',
  `city_code` int NULL DEFAULT NULL COMMENT '市编码',
  `district_code` int NULL DEFAULT NULL COMMENT '区县编码',
  `introduction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '简介',
  `profile` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '个人事迹',
  `specialty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '技艺特长',
  `experience` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '从艺经历',
  `audit_status` tinyint NOT NULL DEFAULT 0 COMMENT '审核状态',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `display_status` tinyint NOT NULL DEFAULT 1 COMMENT '展示状态',
  `published_at` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `is_recommend` tinyint NOT NULL DEFAULT 0 COMMENT '是否推荐',
  `recommend_sort` int NOT NULL DEFAULT 0 COMMENT '推荐排序',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_inheritor_audit`(`audit_status` ASC, `status` ASC) USING BTREE,
  INDEX `idx_inheritor_region`(`province_code` ASC, `city_code` ASC, `district_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor
-- ----------------------------
INSERT INTO `inherit_inheritor` VALUES (1, '本地联调传承人', 'bendilianjiaochengren', NULL, NULL, 0, '00000000000', NULL, '省级代表性传承人', NULL, NULL, NULL, '本地联调测试数据', '本地联调测试数据', '联调测试', '用于一期小程序本地功能验证', 1, NULL, '2026-08-25 13:55:34', 1, '2026-08-25 13:55:34', 0, 0, 0, 0, 'codex', '2026-08-25 13:55:34', 'codex', '2026-08-25 13:55:34', b'0', 0);
INSERT INTO `inherit_inheritor` VALUES (2, 'DEV_DEMO_传承人', 'dev_demo_chengren', '/static/heritage/demo-inheritor.jpg', '/static/heritage/demo-inheritor.jpg', 0, '19900000001', NULL, '省级代表性传承人', NULL, NULL, NULL, '用于传承人后端联调的公开演示数据', '仅供本地 E2E 使用。', '传统手工艺', NULL, 1, NULL, NULL, 1, NULL, 0, 0, 1, 0, '', '2026-08-26 13:54:02', '', '2026-08-26 15:50:41', b'0', 0);

-- ----------------------------
-- Table structure for inherit_inheritor_follow
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_follow`;
CREATE TABLE `inherit_inheritor_follow`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户编号（逻辑关联）',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_inheritor`(`user_id` ASC, `inheritor_id` ASC) USING BTREE,
  INDEX `idx_follow_inheritor`(`inheritor_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人关注表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor_follow
-- ----------------------------
INSERT INTO `inherit_inheritor_follow` VALUES (1, 10, 1, '10', '2026-08-25 15:37:58', '10', '2026-08-26 15:54:41', b'0', 0);
INSERT INTO `inherit_inheritor_follow` VALUES (2, 10, 2, '10', '2026-08-26 15:44:12', '10', '2026-08-26 15:50:41', b'1', 0);

-- ----------------------------
-- Table structure for inherit_inheritor_product_relation
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_product_relation`;
CREATE TABLE `inherit_inheritor_product_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `spu_id` bigint NOT NULL COMMENT '商品 SPU 编号（逻辑关联）',
  `is_representative` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否代表商品',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用，0停用',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_inheritor_spu`(`inheritor_id` ASC, `spu_id` ASC) USING BTREE,
  INDEX `idx_product_relation_inheritor`(`inheritor_id` ASC) USING BTREE,
  INDEX `idx_product_relation_spu`(`spu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人与商品关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor_product_relation
-- ----------------------------
INSERT INTO `inherit_inheritor_product_relation` VALUES (1, 2, 85, b'1', 1, 1, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);
INSERT INTO `inherit_inheritor_product_relation` VALUES (2, 2, 86, b'1', 1, 1, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);

-- ----------------------------
-- Table structure for inherit_inheritor_project_relation
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_project_relation`;
CREATE TABLE `inherit_inheritor_project_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `project_id` bigint NOT NULL COMMENT '非遗项目编号（逻辑关联）',
  `is_primary` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否主项目',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_inheritor_project`(`inheritor_id` ASC, `project_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人与非遗项目关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor_project_relation
-- ----------------------------

-- ----------------------------
-- Table structure for inherit_inheritor_qualification
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_qualification`;
CREATE TABLE `inherit_inheritor_qualification`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '级别',
  `issuer` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '颁发机构',
  `issue_date` date NULL DEFAULT NULL COMMENT '颁发日期',
  `certificate_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证书编号',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '说明',
  `image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片地址',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_qualification_inheritor`(`inheritor_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人荣誉/资质表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor_qualification
-- ----------------------------
INSERT INTO `inherit_inheritor_qualification` VALUES (1, 1, '资质', '本地联调资质', '省级', '本地联调测试单位', NULL, NULL, '用于一期小程序本地功能验证', NULL, 0, 0, 'codex', '2026-08-25 13:55:34', 'codex', '2026-08-25 13:55:34', b'0', 0);
INSERT INTO `inherit_inheritor_qualification` VALUES (2, 2, '资质', 'DEV_DEMO_资质一', '省级', '本地文化馆', NULL, NULL, '本地 E2E 资质一', NULL, 1, 0, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);
INSERT INTO `inherit_inheritor_qualification` VALUES (3, 2, '荣誉', 'DEV_DEMO_荣誉一', '市级', '本地文化馆', NULL, NULL, '本地 E2E 荣誉一', NULL, 2, 0, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);

-- ----------------------------
-- Table structure for inherit_inheritor_service_relation
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_service_relation`;
CREATE TABLE `inherit_inheritor_service_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `service_id` bigint NOT NULL COMMENT '非遗服务编号（逻辑关联）',
  `is_representative` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否代表服务',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用，0停用',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_inheritor_service`(`inheritor_id` ASC, `service_id` ASC) USING BTREE,
  INDEX `idx_service_relation_inheritor`(`inheritor_id` ASC) USING BTREE,
  INDEX `idx_service_relation_service`(`service_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人与非遗服务关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor_service_relation
-- ----------------------------
INSERT INTO `inherit_inheritor_service_relation` VALUES (1, 2, 4, b'1', 1, 1, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);
INSERT INTO `inherit_inheritor_service_relation` VALUES (2, 2, 5, b'1', 1, 1, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);
INSERT INTO `inherit_inheritor_service_relation` VALUES (3, 2, 6, b'1', 1, 1, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);

-- ----------------------------
-- Table structure for inherit_inheritor_work
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_work`;
CREATE TABLE `inherit_inheritor_work`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作品名称',
  `cover` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图',
  `images` json NULL COMMENT '作品图片',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作品描述',
  `year` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创作年份',
  `material` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '材质',
  `technique` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '技法',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_work_inheritor`(`inheritor_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人作品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inherit_inheritor_work
-- ----------------------------
INSERT INTO `inherit_inheritor_work` VALUES (1, 1, '本地联调作品', NULL, NULL, '用于一期小程序本地功能验证', '2026', '联调材料', '联调技艺', 0, 0, 'codex', '2026-08-25 13:55:34', 'codex', '2026-08-25 13:55:34', b'0', 0);
INSERT INTO `inherit_inheritor_work` VALUES (2, 2, 'DEV_DEMO_作品一', '/static/heritage/demo-work-1.jpg', NULL, '本地 E2E 作品一', '2024', '铜', '錾刻', 1, 0, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);
INSERT INTO `inherit_inheritor_work` VALUES (3, 2, 'DEV_DEMO_作品二', '/static/heritage/demo-work-2.jpg', NULL, '本地 E2E 作品二', '2023', '丝', '织造', 2, 0, '', '2026-08-26 13:54:02', '', '2026-08-26 13:54:02', b'0', 0);

-- ----------------------------
-- Table structure for marketplace_after_sale
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_after_sale`;
CREATE TABLE `marketplace_after_sale`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `after_sale_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `platform_order_id` bigint NOT NULL,
  `merchant_order_id` bigint NOT NULL,
  `order_item_id` bigint NOT NULL,
  `member_id` bigint NOT NULL,
  `merchant_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `apply_count` int NOT NULL,
  `apply_amount` bigint NOT NULL,
  `reason_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `evidence_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `admin_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `return_logistics_company` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `return_tracking_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `apply_time` datetime NOT NULL,
  `approve_time` datetime NULL DEFAULT NULL,
  `reject_time` datetime NULL DEFAULT NULL,
  `return_time` datetime NULL DEFAULT NULL,
  `refund_time` datetime NULL DEFAULT NULL,
  `pay_refund_id` bigint NULL DEFAULT NULL,
  `request_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `version` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_after_sale_member_request`(`member_id` ASC, `request_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_marketplace_after_sale_no`(`after_sale_no` ASC) USING BTREE,
  INDEX `idx_marketplace_after_sale_item`(`order_item_id` ASC) USING BTREE,
  INDEX `idx_marketplace_after_sale_merchant_status`(`merchant_order_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace owned after-sale' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_after_sale
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_finance_ledger
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_finance_ledger`;
CREATE TABLE `marketplace_finance_ledger`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL,
  `shop_id` bigint NULL DEFAULT NULL,
  `biz_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `biz_id` bigint NOT NULL,
  `merchant_order_id` bigint NULL DEFAULT NULL,
  `order_item_id` bigint NULL DEFAULT NULL,
  `amount` bigint NOT NULL,
  `balance_after` bigint NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_finance_event`(`merchant_id` ASC, `biz_type` ASC, `biz_id` ASC) USING BTREE,
  INDEX `idx_finance_merchant_time`(`merchant_id` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Merchant finance ledger; amount is signed fen' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_finance_ledger
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_merchant
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_merchant`;
CREATE TABLE `marketplace_merchant`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `short_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` tinyint NOT NULL COMMENT '1 PERSONAL, 2 COMPANY, 3 INSTITUTION',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 enabled, 1 disabled',
  `contact_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `contact_mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `logo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `audit_status` tinyint NOT NULL DEFAULT 0 COMMENT '0 pending, 1 approved, 2 rejected',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_merchant_no`(`merchant_no` ASC) USING BTREE,
  INDEX `idx_marketplace_merchant_status`(`status` ASC, `audit_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace merchant' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_merchant
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_merchant_inheritor
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_merchant_inheritor`;
CREATE TABLE `marketplace_merchant_inheritor`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL,
  `inheritor_id` bigint NOT NULL COMMENT 'Stable ID; validated through future inheritor-api, never cross-module FK',
  `status` tinyint NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mi_merchant`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_mi_inheritor`(`inheritor_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Merchant/Inheritor cooperation relation; not an authorization relation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_merchant_inheritor
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_merchant_order
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_merchant_order`;
CREATE TABLE `marketplace_merchant_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `platform_order_id` bigint NOT NULL,
  `merchant_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  `status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `goods_amount` bigint NOT NULL,
  `discount_amount` bigint NOT NULL DEFAULT 0,
  `delivery_amount` bigint NOT NULL DEFAULT 0,
  `pay_amount` bigint NOT NULL,
  `refund_amount` bigint NOT NULL DEFAULT 0,
  `merchant_name_snapshot` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `shop_name_snapshot` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `version` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  `shipping_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'EXPRESS or NO_EXPRESS',
  `logistics_company_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `logistics_company_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `tracking_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ship_time` datetime NULL DEFAULT NULL,
  `receive_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `delivery_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_merchant_order_no`(`merchant_order_no` ASC) USING BTREE,
  INDEX `idx_marketplace_merchant_order_platform`(`platform_order_id` ASC) USING BTREE,
  INDEX `idx_marketplace_merchant_order_merchant`(`merchant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_marketplace_merchant_order_platform_status`(`platform_order_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace merchant fulfillment order' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_merchant_order
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_order
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_order`;
CREATE TABLE `marketplace_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `member_id` bigint NOT NULL,
  `order_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_amount` bigint NOT NULL,
  `discount_amount` bigint NOT NULL DEFAULT 0,
  `delivery_amount` bigint NOT NULL DEFAULT 0,
  `pay_amount` bigint NOT NULL,
  `pay_order_id` bigint NULL DEFAULT NULL,
  `receiver_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `receiver_mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `receiver_area_id` int NOT NULL,
  `receiver_detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cancel_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cancel_time` datetime NULL DEFAULT NULL,
  `pay_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `request_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_hash` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `version` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_order_no`(`order_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_marketplace_order_request`(`member_id` ASC, `request_key` ASC) USING BTREE,
  UNIQUE INDEX `uk_marketplace_order_pay_order`(`pay_order_id` ASC) USING BTREE,
  INDEX `idx_marketplace_order_member_status`(`member_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_marketplace_order_status_create_time`(`status` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace platform order' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_order
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_order_item
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_order_item`;
CREATE TABLE `marketplace_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `platform_order_id` bigint NOT NULL,
  `merchant_order_id` bigint NOT NULL,
  `spu_id` bigint NOT NULL,
  `sku_id` bigint NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sku_properties` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `pic_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` bigint NOT NULL,
  `count` int NOT NULL,
  `total_amount` bigint NOT NULL,
  `merchant_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  `refund_status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NONE',
  `refund_amount` bigint NOT NULL DEFAULT 0,
  `refunded_count` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_marketplace_item_platform`(`platform_order_id` ASC) USING BTREE,
  INDEX `idx_marketplace_item_merchant_order`(`merchant_order_id` ASC) USING BTREE,
  INDEX `idx_marketplace_item_sku`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace immutable product order item snapshot' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_order_item
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_product_relation
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_product_relation`;
CREATE TABLE `marketplace_product_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  `spu_id` bigint NOT NULL COMMENT 'Stable Mall SPU ID; no cross-module FK',
  `merchant_product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `active_spu_id` bigint GENERATED ALWAYS AS ((case when ((`deleted` = 0x00) and (`status` = 0)) then `spu_id` else NULL end)) STORED NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_product_active_spu`(`active_spu_id` ASC) USING BTREE,
  INDEX `idx_marketplace_product_shop`(`shop_id` ASC) USING BTREE,
  INDEX `idx_marketplace_product_merchant`(`merchant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace owns Product-to-Merchant operating relation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_product_relation
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_shop
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_shop`;
CREATE TABLE `marketplace_shop`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL,
  `shop_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `logo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `banner` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `active_merchant_id` bigint GENERATED ALWAYS AS ((case when ((`deleted` = 0x00) and (`status` = 0)) then `merchant_id` else NULL end)) STORED NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_shop_no`(`shop_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_marketplace_shop_active_merchant`(`active_merchant_id` ASC) USING BTREE,
  INDEX `idx_marketplace_shop_merchant`(`merchant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Marketplace shop; schema permits history/future 1:N, phase 1 allows one active shop' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_shop
-- ----------------------------

-- ----------------------------
-- Table structure for marketplace_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `marketplace_withdraw`;
CREATE TABLE `marketplace_withdraw`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `withdraw_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `merchant_id` bigint NOT NULL,
  `amount` bigint NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `apply_time` datetime NOT NULL,
  `audit_time` datetime NULL DEFAULT NULL,
  `audit_user_id` bigint NULL DEFAULT NULL,
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `payment_method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `payment_account_snapshot` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_marketplace_withdraw_no`(`withdraw_no` ASC) USING BTREE,
  INDEX `idx_withdraw_merchant_status`(`merchant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Merchant manual withdraw request' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketplace_withdraw
-- ----------------------------

-- ----------------------------
-- Table structure for member_address
-- ----------------------------
DROP TABLE IF EXISTS `member_address`;
CREATE TABLE `member_address`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收件人姓名',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收件人手机号',
  `area_id` bigint NOT NULL COMMENT '地区编号',
  `detail_address` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收件详细地址',
  `default_status` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否默认地址',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_member_address_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_member_address_default`(`user_id` ASC, `default_status` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户收件地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_address
-- ----------------------------
INSERT INTO `member_address` VALUES (2, 10, '11', '11111111111', 110101, '1111', b'1', '10', '2026-08-25 21:30:34', '10', '2026-08-25 21:30:34', b'0');

-- ----------------------------
-- Table structure for member_user
-- ----------------------------
DROP TABLE IF EXISTS `member_user`;
CREATE TABLE `member_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `sex` tinyint NULL DEFAULT NULL COMMENT '性别',
  `birthday` datetime NULL DEFAULT NULL COMMENT '出生日期',
  `area_id` int NULL DEFAULT NULL COMMENT '所在地',
  `mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户备注',
  `point` int NOT NULL DEFAULT 0 COMMENT '积分',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '加密密码',
  `register_ip` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '注册 IP',
  `register_terminal` tinyint NULL DEFAULT NULL COMMENT '注册终端',
  `login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录 IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `tag_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户标签编号列表',
  `level_id` bigint NULL DEFAULT NULL COMMENT '等级编号',
  `experience` int NULL DEFAULT NULL COMMENT '经验',
  `group_id` bigint NULL DEFAULT NULL COMMENT '用户分组编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_member_user_mobile`(`mobile` ASC, `tenant_id` ASC, `deleted` ASC) USING BTREE,
  INDEX `idx_member_user_status`(`status` ASC) USING BTREE,
  INDEX `idx_member_user_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_user
-- ----------------------------
INSERT INTO `member_user` VALUES (1, '娴嬭瘯鐢ㄦ埛', NULL, NULL, NULL, NULL, NULL, 0, '', 0, '15601691300', NULL, '$2a$04$.vd8nPeLwxt6hnSzmAoAyul8BOLX7Cib6QhcxRe30rfvrIPQHH1OG', '127.0.0.1', NULL, '127.0.0.1', '2026-08-14 17:02:19', NULL, NULL, NULL, NULL, '1', '2026-08-14 14:38:02', NULL, '2026-08-14 17:02:19', b'0', 1);
INSERT INTO `member_user` VALUES (10, '本地测试用户', NULL, NULL, NULL, NULL, NULL, 0, '', 0, '17712341234', NULL, '$2a$10$4nPk/g81euJjqAFMoPIBkuOtu9I.WM4knB6rJ4Ll0HZa6BYODMskK', '127.0.0.1', NULL, '127.0.0.1', '2026-08-26 15:55:09', NULL, NULL, NULL, NULL, '', '2026-08-25 15:36:16', NULL, '2026-08-26 15:55:09', b'0', 0);
INSERT INTO `member_user` VALUES (11, 'DEV_E2E_MEMBER_A', NULL, NULL, NULL, NULL, NULL, 0, '', 0, '19900000001', NULL, '$2a$10$l4/Eb5JsorudAFCxsS/9qeqOe.QrJ.InmQPzeEXnPqoooAHp5P4t2', '127.0.0.1', 20, '127.0.0.1', '2026-08-26 10:50:06', NULL, NULL, NULL, NULL, 'local-e2e', '2026-08-26 00:56:19', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `member_user` VALUES (12, 'DEV_E2E_MEMBER_B', NULL, NULL, NULL, NULL, NULL, 0, '', 0, '19900000002', NULL, '$2a$10$l4/Eb5JsorudAFCxsS/9qeqOe.QrJ.InmQPzeEXnPqoooAHp5P4t2', '127.0.0.1', 20, '127.0.0.1', '2026-08-26 10:50:06', NULL, NULL, NULL, NULL, 'local-e2e', '2026-08-26 00:56:19', NULL, '2026-08-26 10:50:06', b'0', 0);

-- ----------------------------
-- Table structure for pay_app
-- ----------------------------
DROP TABLE IF EXISTS `pay_app`;
CREATE TABLE `pay_app`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` tinyint NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `order_notify_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `refund_notify_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `transfer_notify_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pay_app_key`(`app_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RuoYi payment application' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_app
-- ----------------------------

-- ----------------------------
-- Table structure for pay_channel
-- ----------------------------
DROP TABLE IF EXISTS `pay_channel`;
CREATE TABLE `pay_channel`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` tinyint NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `fee_rate` double NOT NULL DEFAULT 0,
  `app_id` bigint NOT NULL,
  `config` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pay_channel_app_code`(`app_id` ASC, `code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RuoYi payment channel' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_channel
-- ----------------------------

-- ----------------------------
-- Table structure for pay_notify_log
-- ----------------------------
DROP TABLE IF EXISTS `pay_notify_log`;
CREATE TABLE `pay_notify_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `notify_times` int NOT NULL,
  `response` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` tinyint NOT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pay_notify_log_task`(`task_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RuoYi payment notification log' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_notify_log
-- ----------------------------

-- ----------------------------
-- Table structure for pay_notify_task
-- ----------------------------
DROP TABLE IF EXISTS `pay_notify_task`;
CREATE TABLE `pay_notify_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app_id` bigint NOT NULL,
  `type` tinyint NOT NULL,
  `data_id` bigint NOT NULL,
  `merchant_order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `merchant_refund_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `merchant_transfer_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL,
  `next_notify_time` datetime NULL DEFAULT NULL,
  `last_execute_time` datetime NULL DEFAULT NULL,
  `notify_times` int NOT NULL,
  `max_notify_times` int NOT NULL,
  `notify_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pay_notify_next`(`status` ASC, `next_notify_time` ASC) USING BTREE,
  INDEX `idx_pay_notify_data`(`type` ASC, `data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RuoYi payment notification task' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_notify_task
-- ----------------------------

-- ----------------------------
-- Table structure for pay_order
-- ----------------------------
DROP TABLE IF EXISTS `pay_order`;
CREATE TABLE `pay_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app_id` bigint NOT NULL,
  `channel_id` bigint NULL DEFAULT NULL,
  `channel_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `user_type` tinyint NULL DEFAULT NULL,
  `merchant_order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `subject` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `body` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `notify_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price` int NOT NULL,
  `channel_fee_rate` double NOT NULL DEFAULT 0,
  `channel_fee_price` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL,
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_time` datetime NOT NULL,
  `success_time` datetime NULL DEFAULT NULL,
  `extension_id` bigint NULL DEFAULT NULL,
  `no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `refund_price` int NOT NULL DEFAULT 0,
  `channel_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `channel_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pay_order_app_merchant`(`app_id` ASC, `merchant_order_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_pay_order_no`(`no` ASC) USING BTREE,
  INDEX `idx_pay_order_status_expire`(`status` ASC, `expire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RuoYi payment order' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_order
-- ----------------------------

-- ----------------------------
-- Table structure for pay_order_extension
-- ----------------------------
DROP TABLE IF EXISTS `pay_order_extension`;
CREATE TABLE `pay_order_extension`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_id` bigint NOT NULL,
  `channel_id` bigint NOT NULL,
  `channel_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL,
  `channel_extras` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `channel_error_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `channel_error_msg` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `channel_notify_data` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_pay_order_extension_no`(`no` ASC) USING BTREE,
  INDEX `idx_pay_order_extension_order`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RuoYi payment attempt' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_order_extension
-- ----------------------------

-- ----------------------------
-- Table structure for product_brand
-- ----------------------------
DROP TABLE IF EXISTS `product_brand`;
CREATE TABLE `product_brand`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT 0,
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'product foundation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_brand
-- ----------------------------

-- ----------------------------
-- Table structure for product_category
-- ----------------------------
DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NOT NULL DEFAULT 0,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_category
-- ----------------------------
INSERT INTO `product_category` VALUES (110, 0, '本地测试分类', 'https://dummyimage.com/600x600/eeeeee/333333.png&text=Test+Product', 999, 0, 'local-test', '2026-08-25 17:27:04', 'local-test', '2026-08-25 17:27:04', b'0', 0);
INSERT INTO `product_category` VALUES (111, 110, '本地测试商品', 'https://dummyimage.com/600x600/eeeeee/333333.png&text=Test+Product', 1, 0, 'local-test', '2026-08-25 17:27:04', 'local-test', '2026-08-25 17:27:04', b'0', 0);

-- ----------------------------
-- Table structure for product_property
-- ----------------------------
DROP TABLE IF EXISTS `product_property`;
CREATE TABLE `product_property`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'product foundation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_property
-- ----------------------------

-- ----------------------------
-- Table structure for product_property_value
-- ----------------------------
DROP TABLE IF EXISTS `product_property_value`;
CREATE TABLE `product_property_value`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `property_id` bigint NULL DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_property_value_property_id`(`property_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'product foundation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_property_value
-- ----------------------------

-- ----------------------------
-- Table structure for product_sku
-- ----------------------------
DROP TABLE IF EXISTS `product_sku`;
CREATE TABLE `product_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `spu_id` bigint NOT NULL,
  `properties` json NULL,
  `price` int NOT NULL DEFAULT -1,
  `market_price` int NULL DEFAULT NULL,
  `cost_price` int NOT NULL DEFAULT -1,
  `bar_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `pic_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `stock` int NULL DEFAULT 0,
  `weight` double NULL DEFAULT NULL,
  `volume` double NULL DEFAULT NULL,
  `first_brokerage_price` int NULL DEFAULT NULL,
  `second_brokerage_price` int NULL DEFAULT NULL,
  `sales_count` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_sku_spu_id`(`spu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 126 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'product foundation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_sku
-- ----------------------------
INSERT INTO `product_sku` VALUES (124, 85, '[]', 9900, 12900, 5000, 'TEST-85', 'https://dummyimage.com/600x600/eeeeee/333333.png&text=Test+Product', 100, 0.5, 0.001, 0, 0, 0, 'local-test', '2026-08-25 18:17:46', 'local-test', '2026-08-25 18:17:46', b'0', 0);
INSERT INTO `product_sku` VALUES (125, 124, '[]', 9900, 12900, 5000, 'TEST-124', 'https://dummyimage.com/600x600/eeeeee/333333.png&text=Test+Product', 100, 0.5, 0.001, 0, 0, 0, 'local-test', '2026-08-25 18:20:21', 'local-test', '2026-08-25 18:20:21', b'0', 0);

-- ----------------------------
-- Table structure for product_spu
-- ----------------------------
DROP TABLE IF EXISTS `product_spu`;
CREATE TABLE `product_spu`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `keyword` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `introduction` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category_id` bigint NOT NULL,
  `brand_id` bigint NULL DEFAULT NULL,
  `pic_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slider_pic_urls` json NULL,
  `sort` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 0,
  `spec_type` bit(1) NOT NULL DEFAULT b'0',
  `price` int NOT NULL DEFAULT -1,
  `market_price` int NOT NULL DEFAULT -1,
  `cost_price` int NOT NULL DEFAULT -1,
  `stock` int NOT NULL DEFAULT 0,
  `delivery_template_id` bigint NOT NULL DEFAULT 0,
  `give_integral` int NOT NULL DEFAULT 0,
  `sub_commission_type` bit(1) NOT NULL DEFAULT b'0',
  `sales_count` int NOT NULL DEFAULT 0,
  `virtual_sales_count` int NOT NULL DEFAULT 0,
  `browse_count` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  `delivery_types` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配送方式数组，逗号分隔，对应 ProductSpuDO.deliveryTypes',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_spu_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_product_spu_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 87 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'product foundation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_spu
-- ----------------------------
INSERT INTO `product_spu` VALUES (85, '本地测试商品', '测试 商品', '用于验证小程序商品列表', '<p>本地商品联调测试</p>', 111, NULL, 'https://dummyimage.com/600x600/eeeeee/333333.png&text=Test+Product', '[\"https://dummyimage.com/600x600/eeeeee/333333.png&text=Test+Product\"]', 999, 1, b'0', 9900, 12900, 5000, 100, 0, 0, b'0', 0, 0, 18, 'local-test', '2026-08-25 18:12:29', 'local-test', '2026-08-26 14:33:59', b'0', 0, '2');
INSERT INTO `product_spu` VALUES (86, 'DEV_DEMO_传统风物礼盒', '非遗 美食 风物', '地方风物与非遗饮食文化礼盒', '本地联调用的传统风物商品。', 110, NULL, '/static/heritage/demo-food.jpg', NULL, 0, 1, b'0', 2990, 3990, 1990, 100, 0, 0, b'0', 0, 0, 10, '', '2026-08-26 09:15:46', '', '2026-08-26 12:29:44', b'0', 0, NULL);

-- ----------------------------
-- Table structure for system_dept
-- ----------------------------
DROP TABLE IF EXISTS `system_dept`;
CREATE TABLE `system_dept`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '???id',
  `sort` int NOT NULL DEFAULT 0 COMMENT '????',
  `leader_user_id` bigint NULL DEFAULT NULL COMMENT '???',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `status` tinyint NOT NULL COMMENT '?????0?? 1???',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 118 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '???' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_dept
-- ----------------------------

-- ----------------------------
-- Table structure for system_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_data`;
CREATE TABLE `system_dict_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `sort` int NOT NULL DEFAULT 0 COMMENT '????',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '???0?? 1???',
  `color_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'css ??',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1061146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_dict_data
-- ----------------------------
INSERT INTO `system_dict_data` VALUES (1061137, 1, '国家级代表性传承人', '国家级代表性传承人', 'inherit_inheritor_level', 0, 'danger', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061138, 2, '省级代表性传承人', '省级代表性传承人', 'inherit_inheritor_level', 0, 'warning', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061139, 3, '市级代表性传承人', '市级代表性传承人', 'inherit_inheritor_level', 0, 'primary', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061140, 4, '区县级代表性传承人', '区县级代表性传承人', 'inherit_inheritor_level', 0, 'info', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061141, 1, '荣誉', '荣誉', 'inherit_qualification_type', 0, 'primary', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061142, 2, '资质', '资质', 'inherit_qualification_type', 0, 'success', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061143, 3, '代表性传承人身份', '代表性传承人身份', 'inherit_qualification_type', 0, 'warning', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061144, 4, '获奖', '获奖', 'inherit_qualification_type', 0, 'danger', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_dict_data` VALUES (1061145, 5, '证书', '证书', 'inherit_qualification_type', 0, 'info', '', NULL, 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');

-- ----------------------------
-- Table structure for system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_type`;
CREATE TABLE `system_dict_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '???0?? 1???',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `deleted_time` datetime NULL DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1061101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_dict_type
-- ----------------------------
INSERT INTO `system_dict_type` VALUES (1061099, '传承人级别', 'inherit_inheritor_level', 0, '传承人级别/身份', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0', NULL);
INSERT INTO `system_dict_type` VALUES (1061100, '荣誉/资质类型', 'inherit_qualification_type', 0, '传承人荣誉/资质类型', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0', NULL);

-- ----------------------------
-- Table structure for system_login_log
-- ----------------------------
DROP TABLE IF EXISTS `system_login_log`;
CREATE TABLE `system_login_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `log_type` bigint NOT NULL COMMENT '????',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '??????',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `result` tinyint NOT NULL COMMENT '????',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??? UA',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5572 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_login_log
-- ----------------------------
INSERT INTO `system_login_log` VALUES (5500, 103, '', 0, 1, '13900000001', 10, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/iHJOgOxd2S', NULL, '2026-08-25 15:30:46', NULL, '2026-08-25 15:30:46', b'0', 0);
INSERT INTO `system_login_log` VALUES (5501, 103, '', 0, 1, '13900000001', 10, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/iHJOgOxd2S', NULL, '2026-08-25 15:30:52', NULL, '2026-08-25 15:30:52', b'0', 0);
INSERT INTO `system_login_log` VALUES (5502, 103, '', 0, 1, '13900000001', 10, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/iHJOgOxd2S', NULL, '2026-08-25 15:30:58', NULL, '2026-08-25 15:30:58', b'0', 0);
INSERT INTO `system_login_log` VALUES (5503, 103, '', 0, 1, '13900000001', 10, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/iHJOgOxd2S', NULL, '2026-08-25 15:31:09', NULL, '2026-08-25 15:31:09', b'0', 0);
INSERT INTO `system_login_log` VALUES (5504, 103, '', 10, 1, '17712341234', 0, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/iHJOgOxd2S', NULL, '2026-08-25 15:36:33', NULL, '2026-08-25 15:36:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (5505, 200, '', 10, 1, '17712341234', 0, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/Coae2sGX67', '10', '2026-08-25 15:50:36', '10', '2026-08-25 15:50:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (5506, 103, '', 10, 1, '17712341234', 10, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/Coae2sGX67', NULL, '2026-08-25 15:50:53', NULL, '2026-08-25 15:50:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (5507, 103, '', 10, 1, '17712341234', 0, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/Coae2sGX67', NULL, '2026-08-25 15:51:00', NULL, '2026-08-25 15:51:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (5508, 103, '', 10, 1, '17712341234', 0, '192.168.3.23', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/1644292570 sid/1Ihqc44Ap5', NULL, '2026-08-25 17:21:32', NULL, '2026-08-25 17:21:32', b'0', 0);
INSERT INTO `system_login_log` VALUES (5509, 103, '', 1, 1, '15601691300', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-25 23:19:48', NULL, '2026-08-25 23:19:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (5510, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 00:56:33', NULL, '2026-08-26 00:56:33', b'0', 0);
INSERT INTO `system_login_log` VALUES (5511, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 00:56:34', NULL, '2026-08-26 00:56:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (5512, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:11:17', NULL, '2026-08-26 01:11:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (5513, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:11:17', NULL, '2026-08-26 01:11:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (5514, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:15:41', NULL, '2026-08-26 01:15:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (5515, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:16:00', NULL, '2026-08-26 01:16:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (5516, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:16:48', NULL, '2026-08-26 01:16:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (5517, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:16:48', NULL, '2026-08-26 01:16:48', b'0', 0);
INSERT INTO `system_login_log` VALUES (5518, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:17:26', NULL, '2026-08-26 01:17:26', b'0', 0);
INSERT INTO `system_login_log` VALUES (5519, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:17:44', NULL, '2026-08-26 01:17:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (5520, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:18:11', NULL, '2026-08-26 01:18:11', b'0', 0);
INSERT INTO `system_login_log` VALUES (5521, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:18:47', NULL, '2026-08-26 01:18:47', b'0', 0);
INSERT INTO `system_login_log` VALUES (5522, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:21:06', NULL, '2026-08-26 01:21:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (5523, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:23:50', NULL, '2026-08-26 01:23:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (5524, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 01:23:50', NULL, '2026-08-26 01:23:50', b'0', 0);
INSERT INTO `system_login_log` VALUES (5525, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:16:14', NULL, '2026-08-26 09:16:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (5526, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (5527, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_login_log` VALUES (5528, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:16:41', NULL, '2026-08-26 09:16:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (5529, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:16:42', NULL, '2026-08-26 09:16:42', b'0', 0);
INSERT INTO `system_login_log` VALUES (5530, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:17:17', NULL, '2026-08-26 09:17:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (5531, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:17:17', NULL, '2026-08-26 09:17:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (5532, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:17:36', NULL, '2026-08-26 09:17:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (5533, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:17:36', NULL, '2026-08-26 09:17:36', b'0', 0);
INSERT INTO `system_login_log` VALUES (5534, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:20:07', NULL, '2026-08-26 09:20:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (5535, 103, '', 11, 1, '19900000001', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 09:25:13', NULL, '2026-08-26 09:25:13', b'0', 0);
INSERT INTO `system_login_log` VALUES (5536, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:26:05', NULL, '2026-08-26 10:26:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (5537, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:26:05', NULL, '2026-08-26 10:26:05', b'0', 0);
INSERT INTO `system_login_log` VALUES (5538, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:26:06', NULL, '2026-08-26 10:26:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (5539, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (5540, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (5541, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (5542, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:32:43', NULL, '2026-08-26 10:32:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (5543, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (5544, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_login_log` VALUES (5545, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:35:43', NULL, '2026-08-26 10:35:43', b'0', 0);
INSERT INTO `system_login_log` VALUES (5546, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:36:00', NULL, '2026-08-26 10:36:00', b'0', 0);
INSERT INTO `system_login_log` VALUES (5547, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:37:14', NULL, '2026-08-26 10:37:14', b'0', 0);
INSERT INTO `system_login_log` VALUES (5548, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:42:17', NULL, '2026-08-26 10:42:17', b'0', 0);
INSERT INTO `system_login_log` VALUES (5549, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:44:07', NULL, '2026-08-26 10:44:07', b'0', 0);
INSERT INTO `system_login_log` VALUES (5550, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:44:25', NULL, '2026-08-26 10:44:25', b'0', 0);
INSERT INTO `system_login_log` VALUES (5551, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (5552, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (5553, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_login_log` VALUES (5554, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:45:31', NULL, '2026-08-26 10:45:31', b'0', 0);
INSERT INTO `system_login_log` VALUES (5555, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 10:46:24', NULL, '2026-08-26 10:46:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (5556, 103, '', 11, 1, '19900000001', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (5557, 103, '', 12, 1, '19900000002', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (5558, 100, '', 233, 2, 'heritagee2eadmin', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (5559, 103, '', 10, 1, '17712341234', 0, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.01.2510290 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/510615475 sid/Jvkj1KvHY9', NULL, '2026-08-26 11:52:45', NULL, '2026-08-26 11:52:45', b'0', 0);
INSERT INTO `system_login_log` VALUES (5560, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:32:06', NULL, '2026-08-26 15:32:06', b'0', 0);
INSERT INTO `system_login_log` VALUES (5561, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:39:59', NULL, '2026-08-26 15:39:59', b'0', 0);
INSERT INTO `system_login_log` VALUES (5562, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:41:03', NULL, '2026-08-26 15:41:03', b'0', 0);
INSERT INTO `system_login_log` VALUES (5563, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:42:20', NULL, '2026-08-26 15:42:20', b'0', 0);
INSERT INTO `system_login_log` VALUES (5564, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:42:56', NULL, '2026-08-26 15:42:56', b'0', 0);
INSERT INTO `system_login_log` VALUES (5565, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:43:34', NULL, '2026-08-26 15:43:34', b'0', 0);
INSERT INTO `system_login_log` VALUES (5566, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:44:12', NULL, '2026-08-26 15:44:12', b'0', 0);
INSERT INTO `system_login_log` VALUES (5567, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:45:24', NULL, '2026-08-26 15:45:24', b'0', 0);
INSERT INTO `system_login_log` VALUES (5568, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:49:53', NULL, '2026-08-26 15:49:53', b'0', 0);
INSERT INTO `system_login_log` VALUES (5569, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:50:38', NULL, '2026-08-26 15:50:38', b'0', 0);
INSERT INTO `system_login_log` VALUES (5570, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:54:41', NULL, '2026-08-26 15:54:41', b'0', 0);
INSERT INTO `system_login_log` VALUES (5571, 103, '', 10, 1, '17712341234', 0, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.19045; zh-CN) PowerShell/7.2.4', NULL, '2026-08-26 15:55:09', NULL, '2026-08-26 15:55:09', b'0', 0);

-- ----------------------------
-- Table structure for system_mail_account
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_account`;
CREATE TABLE `system_mail_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??',
  `host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SMTP ?????',
  `port` int NOT NULL COMMENT 'SMTP ?????',
  `ssl_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '???? SSL',
  `starttls_enable` bit(1) NOT NULL DEFAULT b'0' COMMENT '???? STARTTLS',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_mail_account
-- ----------------------------

-- ----------------------------
-- Table structure for system_mail_log
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_log`;
CREATE TABLE `system_mail_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `user_id` bigint NULL DEFAULT NULL COMMENT '????',
  `user_type` tinyint NULL DEFAULT NULL COMMENT '????',
  `to_mails` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `cc_mails` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????',
  `bcc_mails` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????',
  `account_id` bigint NOT NULL COMMENT '??????',
  `from_mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `template_id` bigint NOT NULL COMMENT '????',
  `template_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '???????',
  `template_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `send_status` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `send_time` datetime NULL DEFAULT NULL COMMENT '????',
  `send_message_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????? ID',
  `send_exception` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 368 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_mail_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_mail_template
-- ----------------------------
DROP TABLE IF EXISTS `system_mail_template`;
CREATE TABLE `system_mail_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `account_id` bigint NOT NULL COMMENT '?????????',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?????',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `content` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '????',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_mail_template
-- ----------------------------

-- ----------------------------
-- Table structure for system_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_menu`;
CREATE TABLE `system_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `permission` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `type` tinyint NOT NULL COMMENT '????',
  `sort` int NOT NULL DEFAULT 0 COMMENT '????',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '???ID',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '????',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '???',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `visible` bit(1) NOT NULL DEFAULT b'1' COMMENT '????',
  `keep_alive` bit(1) NOT NULL DEFAULT b'1' COMMENT '????',
  `always_show` bit(1) NOT NULL DEFAULT b'1' COMMENT '??????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6806 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_menu
-- ----------------------------
INSERT INTO `system_menu` VALUES (6758, '非遗管理', '', 1, 15, 0, '/inherit', 'ep:medal', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6759, '传承人管理', 'inherit:inheritor:query', 2, 1, 6758, 'inheritor', 'ep:user', 'inherit/inheritor/index', 'InheritInheritor', 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6760, '传承人查询', 'inherit:inheritor:query', 3, 1, 6759, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6761, '传承人创建', 'inherit:inheritor:create', 3, 2, 6759, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6762, '传承人更新', 'inherit:inheritor:update', 3, 3, 6759, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6763, '传承人删除', 'inherit:inheritor:delete', 3, 4, 6759, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6764, '传承人审核', 'inherit:inheritor:audit', 3, 5, 6759, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6765, '荣誉资质管理', 'inherit:inheritor-qualification:query', 2, 2, 6758, 'qualification', 'ep:medal', 'inherit/inheritorQualification/index', 'InheritInheritorQualification', 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6766, '荣誉资质查询', 'inherit:inheritor-qualification:query', 3, 1, 6765, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6767, '荣誉资质创建', 'inherit:inheritor-qualification:create', 3, 2, 6765, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6768, '荣誉资质更新', 'inherit:inheritor-qualification:update', 3, 3, 6765, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6769, '荣誉资质删除', 'inherit:inheritor-qualification:delete', 3, 4, 6765, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6770, '作品管理', 'inherit:inheritor-work:query', 2, 3, 6758, 'work', 'ep:picture', 'inherit/inheritorWork/index', 'InheritInheritorWork', 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6771, '作品查询', 'inherit:inheritor-work:query', 3, 1, 6770, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6772, '作品创建', 'inherit:inheritor-work:create', 3, 2, 6770, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6773, '作品更新', 'inherit:inheritor-work:update', 3, 3, 6770, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6774, '作品删除', 'inherit:inheritor-work:delete', 3, 4, 6770, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6775, '非遗项目关系', 'inherit:inheritor-project-relation:query', 2, 4, 6758, 'project-relation', 'ep:link', 'inherit/inheritorProjectRelation/index', 'InheritInheritorProjectRelation', 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6776, '关系查询', 'inherit:inheritor-project-relation:query', 3, 1, 6775, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6777, '关系创建', 'inherit:inheritor-project-relation:create', 3, 2, 6775, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6778, '关系更新', 'inherit:inheritor-project-relation:update', 3, 3, 6775, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6779, '关系删除', 'inherit:inheritor-project-relation:delete', 3, 4, 6775, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-25 13:49:40', 'admin', '2026-08-25 13:49:40', b'0');
INSERT INTO `system_menu` VALUES (6780, 'Heritage Product Query', 'heritage:product-system:query', 3, 1, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6781, 'Heritage Service Query', 'heritage:service:query', 3, 2, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6782, 'Heritage Schedule Query', 'heritage:schedule:query', 3, 3, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6783, 'Heritage Booking Query', 'heritage:booking:query', 3, 4, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6784, 'Heritage Booking Update', 'heritage:booking:update', 3, 5, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6785, 'Heritage Cooperation Query', 'heritage:cooperation:query', 3, 6, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6786, 'Heritage Cooperation Update', 'heritage:cooperation:update', 3, 7, 0, '', '', '', NULL, 0, b'1', b'1', b'1', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0');
INSERT INTO `system_menu` VALUES (6787, 'Heritage Product-System-SPU Query', 'heritage:product-system-spu:query', 3, 1, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6788, 'Heritage Product-System-SPU Create', 'heritage:product-system-spu:create', 3, 2, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6789, 'Heritage Product-System-SPU Update', 'heritage:product-system-spu:update', 3, 3, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6790, 'Heritage Product-System-SPU Delete', 'heritage:product-system-spu:delete', 3, 4, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6791, 'Heritage Schedule Create', 'heritage:schedule:create', 3, 5, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6792, 'Heritage Schedule Update', 'heritage:schedule:update', 3, 6, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6793, 'Heritage Schedule Delete', 'heritage:schedule:delete', 3, 7, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6794, 'Heritage Service Update', 'heritage:service:update', 3, 8, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6795, 'Heritage Service Delete', 'heritage:service:delete', 3, 9, 0, '', '#', NULL, NULL, 0, b'1', b'1', b'1', 'migration', '2026-08-26 10:30:25', 'migration', '2026-08-26 10:30:25', b'0');
INSERT INTO `system_menu` VALUES (6796, '传承人商品关系', 'inherit:inheritor-product-relation:query', 2, 5, 6758, 'product-relation', 'ep:goods', 'inherit/inheritorProductRelation/index', 'InheritInheritorProductRelation', 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6797, '商品关系查询', 'inherit:inheritor-product-relation:query', 3, 1, 6796, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6798, '商品关系创建', 'inherit:inheritor-product-relation:create', 3, 2, 6796, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6799, '商品关系更新', 'inherit:inheritor-product-relation:update', 3, 3, 6796, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6800, '商品关系删除', 'inherit:inheritor-product-relation:delete', 3, 4, 6796, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6801, '传承人服务关系', 'inherit:inheritor-service-relation:query', 2, 6, 6758, 'service-relation', 'ep:service', 'inherit/inheritorServiceRelation/index', 'InheritInheritorServiceRelation', 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6802, '服务关系查询', 'inherit:inheritor-service-relation:query', 3, 1, 6801, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6803, '服务关系创建', 'inherit:inheritor-service-relation:create', 3, 2, 6801, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6804, '服务关系更新', 'inherit:inheritor-service-relation:update', 3, 3, 6801, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');
INSERT INTO `system_menu` VALUES (6805, '服务关系删除', 'inherit:inheritor-service-relation:delete', 3, 4, 6801, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', '2026-08-26 13:53:00', 'admin', '2026-08-26 13:53:00', b'0');

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `type` tinyint NOT NULL COMMENT '?????1?? 2???',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '?????0?? 1???',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notice
-- ----------------------------

-- ----------------------------
-- Table structure for system_notify_message
-- ----------------------------
DROP TABLE IF EXISTS `system_notify_message`;
CREATE TABLE `system_notify_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `user_id` bigint NOT NULL COMMENT '??id',
  `user_type` tinyint NOT NULL COMMENT '????',
  `template_id` bigint NOT NULL COMMENT '????',
  `template_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_nickname` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???????',
  `template_content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_type` int NOT NULL COMMENT '????',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `read_status` bit(1) NOT NULL COMMENT '????',
  `read_time` datetime NULL DEFAULT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id_user_type_read_status`(`user_id` ASC, `user_type` ASC, `read_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notify_message
-- ----------------------------

-- ----------------------------
-- Table structure for system_notify_template
-- ----------------------------
DROP TABLE IF EXISTS `system_notify_template`;
CREATE TABLE `system_notify_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `type` tinyint NOT NULL COMMENT '??',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '??',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notify_template
-- ----------------------------

-- ----------------------------
-- Table structure for system_oauth2_access_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_access_token`;
CREATE TABLE `system_oauth2_access_token`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `user_id` bigint NOT NULL COMMENT '????',
  `user_type` tinyint NOT NULL COMMENT '????',
  `user_info` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `access_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `expires_time` datetime NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_access_token`(`access_token` ASC) USING BTREE,
  INDEX `idx_refresh_token`(`refresh_token` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108703 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 ????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_access_token
-- ----------------------------
INSERT INTO `system_oauth2_access_token` VALUES (108635, 10, 1, '{}', '91abb8629050449fa80e8555affc017a', '07437405bf8e41e2b1e9e984ee4eb7a5', 'default', NULL, '2026-08-25 16:06:33', NULL, '2026-08-25 15:36:33', '10', '2026-08-25 15:50:36', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108636, 10, 1, '{}', '56da643f3e0e4ea9a480c64316f66f04', '32d102d2012746c0a17771d90f7205bd', 'default', NULL, '2026-08-25 16:21:00', NULL, '2026-08-25 15:51:00', NULL, '2026-08-25 17:04:25', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108637, 10, 1, '{}', '2355a2cc951d47328945a1dd3a60f5d3', '32d102d2012746c0a17771d90f7205bd', 'default', NULL, '2026-08-25 17:34:25', NULL, '2026-08-25 17:04:25', NULL, '2026-08-25 17:04:25', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108638, 10, 1, '{}', '054e9b5f692041dfadf18e4bcb69e295', 'df86aa8b566442418dc7bc76832df2ef', 'default', NULL, '2026-08-25 17:51:32', NULL, '2026-08-25 17:21:32', NULL, '2026-08-25 21:30:05', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108639, 10, 1, '{}', 'cd0cdde4e2af4863b4981d79e0992e77', 'df86aa8b566442418dc7bc76832df2ef', 'default', NULL, '2026-08-25 22:00:05', NULL, '2026-08-25 21:30:05', NULL, '2026-08-26 11:26:03', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108640, 11, 1, '{}', '7000d46358d94ba790f56caeb6f7ccb9', '638114c525f84e3a957fda9eda828894', 'default', NULL, '2026-08-26 01:26:34', NULL, '2026-08-26 00:56:34', NULL, '2026-08-26 00:56:34', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108641, 12, 1, '{}', '04b54a81e5aa450a8ed7ced72ec20a18', '2762a00047ad443c8e45d037dd395501', 'default', NULL, '2026-08-26 01:26:34', NULL, '2026-08-26 00:56:34', NULL, '2026-08-26 00:56:34', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108642, 11, 1, '{}', 'bd07a3161bbb49348c8606ae2c8b3faf', 'e7ba4b0b5e474253a2ee74c53b5d1ea0', 'default', NULL, '2026-08-26 01:41:17', NULL, '2026-08-26 01:11:17', NULL, '2026-08-26 01:11:17', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108643, 12, 1, '{}', '28110e3641524411bb94ce1f25297ee8', '99acd6b0f0d2460dba1e89ca07567b6c', 'default', NULL, '2026-08-26 01:41:17', NULL, '2026-08-26 01:11:17', NULL, '2026-08-26 01:11:17', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108644, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'f437cfd041c744089622d61f42d61c22', 'c786eb4e54794386a2556ce7eec50485', 'default', NULL, '2026-08-26 01:45:41', NULL, '2026-08-26 01:15:41', NULL, '2026-08-26 01:15:41', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108645, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'acc0703b5d0e4938bb38f1e84c963e3f', 'cebbf877c8dd42f282ff9fd13fde7c40', 'default', NULL, '2026-08-26 01:46:00', NULL, '2026-08-26 01:16:00', NULL, '2026-08-26 01:16:00', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108646, 11, 1, '{}', '149b8bf31a0242248bccbf719983ee43', '0c2c468c0b304caea281dba2f7e93e5c', 'default', NULL, '2026-08-26 01:46:48', NULL, '2026-08-26 01:16:48', NULL, '2026-08-26 01:16:48', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108647, 12, 1, '{}', 'ef4b0d72ab98452faf070341ae0a5da2', '3a3188a824904b66bde80451a7ba1e96', 'default', NULL, '2026-08-26 01:46:48', NULL, '2026-08-26 01:16:48', NULL, '2026-08-26 01:16:48', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108648, 11, 1, '{}', '073ee80144ac4f239f51b67541f5dc76', '5025c69d1b7b48fa9ce23f5cb8803f39', 'default', NULL, '2026-08-26 01:47:26', NULL, '2026-08-26 01:17:26', NULL, '2026-08-26 01:17:26', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108649, 11, 1, '{}', 'e9b10b10e40248bdadc9c79170eca31b', '9c7bc234d9dd411ca2a21215871a9289', 'default', NULL, '2026-08-26 01:47:44', NULL, '2026-08-26 01:17:44', NULL, '2026-08-26 01:17:44', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108650, 11, 1, '{}', 'd9941b63c89e4a87aff036044fe0ca8c', '0f05e7104e2142f4b12e5f0c40291e96', 'default', NULL, '2026-08-26 01:48:11', NULL, '2026-08-26 01:18:11', NULL, '2026-08-26 01:18:11', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108651, 11, 1, '{}', 'd9f447d392814a4285262b0a6fc39e06', '3a4d2b612d134b7f8d1a8a8a36d76fe5', 'default', NULL, '2026-08-26 01:48:47', NULL, '2026-08-26 01:18:47', NULL, '2026-08-26 01:18:47', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108652, 11, 1, '{}', 'e9fe82c956264d479cc878105f0ae617', '777f1e99888649c59d8163b1fda65b84', 'default', NULL, '2026-08-26 01:51:06', NULL, '2026-08-26 01:21:06', NULL, '2026-08-26 01:21:06', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108653, 11, 1, '{}', '7e897085d7b641c2a589ed492c41806f', '90a0e31fb07e4e0ba8571aa163066d88', 'default', NULL, '2026-08-26 01:53:50', NULL, '2026-08-26 01:23:50', NULL, '2026-08-26 01:23:50', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108654, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'a58a6f9856ce48fea725a6e9f6c0187a', 'fde542b501f5438ca4b3768a05f7bbd9', 'default', NULL, '2026-08-26 01:53:50', NULL, '2026-08-26 01:23:50', NULL, '2026-08-26 01:23:50', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108655, 11, 1, '{}', 'f167479437784211b95231824e0ade0b', '3217464d9adc46bab6827dcb22b05dd1', 'default', NULL, '2026-08-26 09:46:15', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108656, 12, 1, '{}', '2b24f003924e4d5e86eb19f1a1ff5552', '2489a08f776e44aab229e3da87da9767', 'default', NULL, '2026-08-26 09:46:15', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108657, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'd776b3443f224195938a6ab8dfe072ab', 'f0cd92054a9f4901999caaf5779d2200', 'default', NULL, '2026-08-26 09:46:15', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108658, 11, 1, '{}', 'a57e774dfab64b13b1289aaa957a589c', '1aba405613564ba58a603ceacd881e5e', 'default', NULL, '2026-08-26 09:46:41', NULL, '2026-08-26 09:16:41', NULL, '2026-08-26 09:16:41', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108659, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '6da3e1af32494df5b11559a3478ecda8', 'dd2153b96bf8414cb261aa413f11bad5', 'default', NULL, '2026-08-26 09:46:42', NULL, '2026-08-26 09:16:42', NULL, '2026-08-26 09:16:42', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108660, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '085f56915fd54633a4fa62e00ca75405', '8d51ec1b1014444f9752bf3edca98424', 'default', NULL, '2026-08-26 09:47:17', NULL, '2026-08-26 09:17:17', NULL, '2026-08-26 09:17:17', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108661, 11, 1, '{}', '44594507052d4706998ffd33dd9528b9', '99b15e124cf14182a6c33eb88a917213', 'default', NULL, '2026-08-26 09:47:17', NULL, '2026-08-26 09:17:17', NULL, '2026-08-26 09:17:17', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108662, 11, 1, '{}', 'cf4be52220514c80b46e839480de7918', 'a94f45ffe417486ea81e427ca9f5e209', 'default', NULL, '2026-08-26 09:47:36', NULL, '2026-08-26 09:17:36', NULL, '2026-08-26 09:17:36', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108663, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '757864d6aac6424e90f31b71f19ec82f', '41459da646a14faa966ad44cda909ea3', 'default', NULL, '2026-08-26 09:47:36', NULL, '2026-08-26 09:17:36', NULL, '2026-08-26 09:17:36', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108664, 11, 1, '{}', 'c1f313f064f34836809683c461ff665a', 'a87af64f56034c8c868655e232edf55b', 'default', NULL, '2026-08-26 09:50:07', NULL, '2026-08-26 09:20:07', NULL, '2026-08-26 09:20:07', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108665, 11, 1, '{}', '5595a3bd25114460b02f7a24a9ed82d8', '28bf2221bc8b44c6b0fd4d6782a667e9', 'default', NULL, '2026-08-26 10:56:05', NULL, '2026-08-26 10:26:05', NULL, '2026-08-26 10:26:05', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108666, 12, 1, '{}', '87302ce8c78b4e98beac4c1d7dbdfb92', '629eca32a0ed48f79dbcdce07586c926', 'default', NULL, '2026-08-26 10:56:05', NULL, '2026-08-26 10:26:05', NULL, '2026-08-26 10:26:05', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108667, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '615b86143d4a40d18ce782d429f38df6', '306e5479df414693a468fa899d167272', 'default', NULL, '2026-08-26 10:56:06', NULL, '2026-08-26 10:26:06', NULL, '2026-08-26 10:26:06', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108668, 11, 1, '{}', 'e9e02e51d30a42a6aba10ecfcbf63f3d', '60134e0bbbe342eeb78a268903fa3ccd', 'default', NULL, '2026-08-26 11:00:56', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108669, 12, 1, '{}', '2851315e65e24c628776f235976e601c', '3c8642a7433546b5b9d1af51074ed93b', 'default', NULL, '2026-08-26 11:00:56', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108670, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '0aa041d13a524bbeb21d88625d20c2b4', '9fe8ec9caa434afcb09604fe475dd1b9', 'default', NULL, '2026-08-26 11:00:56', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108671, 11, 1, '{}', 'b6614c698abb46d5bf30a25a68361512', '80be0fa5a5f341829be70506d19b2af5', 'default', NULL, '2026-08-26 11:02:44', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108672, 12, 1, '{}', 'ce5048421f5b495f9ee916ceed0c8376', 'b8002d71fea34bc3834b5d56b035c629', 'default', NULL, '2026-08-26 11:02:44', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108673, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '3847485d8d3e4843a01e57f59449e9e8', 'a596536a37f04a9da97fbf0f01228868', 'default', NULL, '2026-08-26 11:02:44', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108674, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '5af34e8d6aff47588447c1d1388bb0ed', '7dc039c1ee094fb0ba3879947de358b5', 'default', NULL, '2026-08-26 11:05:43', NULL, '2026-08-26 10:35:43', NULL, '2026-08-26 10:35:43', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108675, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'a407409734ca47c5a7d4e4071a04aca4', '0aa5701da84b4b47bc86e27b71849634', 'default', NULL, '2026-08-26 11:06:00', NULL, '2026-08-26 10:36:00', NULL, '2026-08-26 10:36:00', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108676, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'ed558dfdfd6a44b58c4ae06f5b219eb8', '122ce06384f142f2a8e0f5c29e6c233e', 'default', NULL, '2026-08-26 11:07:14', NULL, '2026-08-26 10:37:14', NULL, '2026-08-26 10:37:14', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108677, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '64d3e7157d014dd4ab1d51ef1f1dec71', '6342e82e7d244dd3a09edd9f1a1259e3', 'default', NULL, '2026-08-26 11:12:18', NULL, '2026-08-26 10:42:18', NULL, '2026-08-26 10:42:18', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108678, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '3fe6bc35df4d4bc1a9b5ecd599dd7c9a', '2162d927bbe1463fa503b9cd22c846f1', 'default', NULL, '2026-08-26 11:14:07', NULL, '2026-08-26 10:44:07', NULL, '2026-08-26 10:44:07', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108679, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'd654f01ce4064605b168a548fca9da4f', '6cad1f8ebccb48cdac29f0303d94e630', 'default', NULL, '2026-08-26 11:14:25', NULL, '2026-08-26 10:44:25', NULL, '2026-08-26 10:44:25', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108680, 11, 1, '{}', '0b4c272f1b61489d81ac1baff92331d7', 'ce9447f94b744e8bb93f65207404b8b7', 'default', NULL, '2026-08-26 11:14:28', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108681, 12, 1, '{}', '11e673e27f9c4262a532e7dc2c51e3ac', 'dc662cba4dee428dbb46969909a04b06', 'default', NULL, '2026-08-26 11:14:28', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108682, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'f2b97b4e97884a7aafd95b2bad165f5a', '7ee301f9420149bdb8f711928bca8be3', 'default', NULL, '2026-08-26 11:14:28', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108683, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'dfc400302ef043f9a51d57c962f32d9c', '307641432bf64c6b9fb8dbfd9311484e', 'default', NULL, '2026-08-26 11:15:31', NULL, '2026-08-26 10:45:31', NULL, '2026-08-26 10:45:31', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108684, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', '3a9c23df57fd44ef86b2d1e9d22e2ecd', '71b2aaa5f0bd4b3a8dce608433ba82a6', 'default', NULL, '2026-08-26 11:16:24', NULL, '2026-08-26 10:46:24', NULL, '2026-08-26 10:46:24', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108685, 11, 1, '{}', '5c112b4980b84ca5aeb0a929c9b1076f', 'c51e8908fcab4401b680bddb7c10e2cb', 'default', NULL, '2026-08-26 11:20:06', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108686, 12, 1, '{}', '024b186fae2d4b8da8bb9eef674f742f', '55eefd8cfced4100812c580b88df9150', 'default', NULL, '2026-08-26 11:20:06', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108687, 233, 2, '{\"nickname\":\"Heritage E2E Admin\",\"deptId\":null}', 'd941bc520d1546a588e057878067e738', '06f849cb9c5049b8ad36422ad0a633c5', 'default', NULL, '2026-08-26 11:20:06', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108688, 10, 1, '{}', '7daddf8203c94b9d859a5beb0c7a9959', 'df86aa8b566442418dc7bc76832df2ef', 'default', NULL, '2026-08-26 11:56:03', NULL, '2026-08-26 11:26:03', NULL, '2026-08-26 12:33:36', b'1', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108689, 10, 1, '{}', 'd503debba03946458f5da5c444fbfff2', 'a56295ab49c046a1942c7356a8a4f283', 'default', NULL, '2026-08-26 12:22:45', NULL, '2026-08-26 11:52:45', NULL, '2026-08-26 11:52:45', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108690, 10, 1, '{}', 'f50609ba5a04413680a6e0bf24f47327', 'df86aa8b566442418dc7bc76832df2ef', 'default', NULL, '2026-08-26 13:03:36', NULL, '2026-08-26 12:33:36', NULL, '2026-08-26 12:33:36', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108691, 10, 1, '{}', 'd5b263a69be54530a6e566871d3236a7', 'f3b8ba7c4b5a4e698291c1e653eaca49', 'default', NULL, '2026-08-26 16:02:06', NULL, '2026-08-26 15:32:06', NULL, '2026-08-26 15:32:06', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108692, 10, 1, '{}', '7e08f14d224f4f91b4e87b4e5217b2d9', '66a45e456efb4ddc9427101b3e8278bc', 'default', NULL, '2026-08-26 16:09:59', NULL, '2026-08-26 15:39:59', NULL, '2026-08-26 15:39:59', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108693, 10, 1, '{}', '14c7997bbc9b4e1f8f812151ffa7af28', '6f1f838ba942466bb8b07cc9f21fb61d', 'default', NULL, '2026-08-26 16:11:03', NULL, '2026-08-26 15:41:03', NULL, '2026-08-26 15:41:03', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108694, 10, 1, '{}', '28e684728447482c9249d7911daa351d', '85d7002e8bcb4ded90bba73d48f60229', 'default', NULL, '2026-08-26 16:12:20', NULL, '2026-08-26 15:42:20', NULL, '2026-08-26 15:42:20', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108695, 10, 1, '{}', '6c0d1bfeea81481b8d8560e4ee6b4a55', '6e5ef03aee114161b7a03fc81b12a274', 'default', NULL, '2026-08-26 16:12:56', NULL, '2026-08-26 15:42:56', NULL, '2026-08-26 15:42:56', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108696, 10, 1, '{}', '15eeaa67de704c45b4a3ffdde355d222', 'aad83664ba1547ef89b1983242326214', 'default', NULL, '2026-08-26 16:13:34', NULL, '2026-08-26 15:43:34', NULL, '2026-08-26 15:43:34', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108697, 10, 1, '{}', '4f3c537cc0634613a179cb6d286b66c6', '1919eb1f2d0743f58aecacb3824821e6', 'default', NULL, '2026-08-26 16:14:12', NULL, '2026-08-26 15:44:12', NULL, '2026-08-26 15:44:12', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108698, 10, 1, '{}', '77947015f3964f6b9046ca694f13587a', '16ed279691de4a81a16f6028609f0072', 'default', NULL, '2026-08-26 16:15:24', NULL, '2026-08-26 15:45:24', NULL, '2026-08-26 15:45:24', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108699, 10, 1, '{}', '0f02d7b1775e42ac8278351af2830a12', 'e8218678ff3c4108bbf81364c4a1c827', 'default', NULL, '2026-08-26 16:19:53', NULL, '2026-08-26 15:49:53', NULL, '2026-08-26 15:49:53', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108700, 10, 1, '{}', '2f032a73aaff4b55bb4b47703d282f7e', 'ec1593d3ab4747a0977f3a2b0fb19ce3', 'default', NULL, '2026-08-26 16:20:38', NULL, '2026-08-26 15:50:38', NULL, '2026-08-26 15:50:38', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108701, 10, 1, '{}', '09e4b47d7cdb40949f2a0064551522fd', '8fa70e89e8ca427a9e8a1acbab7175a3', 'default', NULL, '2026-08-26 16:24:41', NULL, '2026-08-26 15:54:41', NULL, '2026-08-26 15:54:41', b'0', 0);
INSERT INTO `system_oauth2_access_token` VALUES (108702, 10, 1, '{}', '233b27c67da442f787e761d2b9976fc6', '5262fb4bcb7a48fe8bfd45f96943a534', 'default', NULL, '2026-08-26 16:25:09', NULL, '2026-08-26 15:55:09', NULL, '2026-08-26 15:55:09', b'0', 0);

-- ----------------------------
-- Table structure for system_oauth2_approve
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_approve`;
CREATE TABLE `system_oauth2_approve`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `user_id` bigint NOT NULL COMMENT '????',
  `user_type` tinyint NOT NULL COMMENT '????',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `approved` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `expires_time` datetime NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id_user_type_client_id`(`user_id` ASC, `user_type` ASC, `client_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 ???' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_approve
-- ----------------------------

-- ----------------------------
-- Table structure for system_oauth2_client
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_client`;
CREATE TABLE `system_oauth2_client`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '??',
  `access_token_validity_seconds` int NOT NULL COMMENT '????????',
  `refresh_token_validity_seconds` int NOT NULL COMMENT '????????',
  `redirect_uris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????? URI ??',
  `authorized_grant_types` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `auto_approve_scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?????????',
  `authorities` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `resource_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `additional_information` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_client_id`(`client_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 ????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_client
-- ----------------------------
INSERT INTO `system_oauth2_client` VALUES (1, 'default', 'admin123', '芋道源码', 'http://test.yudao.iocoder.cn/20250502/sort2_1746189740718.png', '我是描述', 0, 1800, 2592000, '[\"https://www.iocoder.cn\",\"https://doc.iocoder.cn\"]', '[\"password\",\"authorization_code\",\"implicit\",\"refresh_token\",\"client_credentials\"]', '[\"user.read\",\"user.write\"]', '[]', '[\"user.read\",\"user.write\"]', '[]', '{}', '1', '2022-05-11 21:47:12', '1', '2025-12-07 20:07:09', b'0');
INSERT INTO `system_oauth2_client` VALUES (40, 'test', 'test2', 'biubiu', 'http://test.yudao.iocoder.cn/20251227/javayuanma_1766829882970.jpg', '啦啦啦啦', 0, 1800, 43200, '[\"https://www.iocoder.cn\"]', '[\"password\",\"authorization_code\",\"implicit\"]', '[\"user_info\",\"projects\"]', '[\"user_info\"]', '[]', '[]', '{}', '1', '2022-05-12 00:28:20', '1', '2025-12-27 18:04:44', b'0');
INSERT INTO `system_oauth2_client` VALUES (41, 'yudao-sso-demo-by-code', 'test', '基于授权码模式，如何实现 SSO 单点登录？', 'http://test.yudao.iocoder.cn/it/20250502/sign_1746181948685.png', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"authorization_code\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-09-29 13:28:31', '1', '2025-05-02 18:32:30', b'0');
INSERT INTO `system_oauth2_client` VALUES (42, 'yudao-sso-demo-by-password', 'test', '基于密码模式，如何实现 SSO 单点登录？', 'http://test.yudao.iocoder.cn/oauth2/20260615/iShot_2026-05-31_23.18.10.png', NULL, 0, 1800, 43200, '[\"http://127.0.0.1:18080\"]', '[\"password\",\"refresh_token\"]', '[\"user.read\",\"user.write\"]', '[]', '[]', '[]', NULL, '1', '2022-10-04 17:40:16', '1', '2026-06-15 18:58:30', b'0');

-- ----------------------------
-- Table structure for system_oauth2_code
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_code`;
CREATE TABLE `system_oauth2_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `user_id` bigint NOT NULL COMMENT '????',
  `user_type` tinyint NOT NULL COMMENT '????',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `expires_time` datetime NOT NULL COMMENT '????',
  `redirect_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????? URI ??',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 155 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 ????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_code
-- ----------------------------

-- ----------------------------
-- Table structure for system_oauth2_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_refresh_token`;
CREATE TABLE `system_oauth2_refresh_token`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `user_id` bigint NOT NULL COMMENT '????',
  `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `user_type` tinyint NOT NULL COMMENT '????',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `scopes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `expires_time` datetime NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_refresh_token`(`refresh_token` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3557 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 ????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_oauth2_refresh_token
-- ----------------------------
INSERT INTO `system_oauth2_refresh_token` VALUES (3493, 10, '07437405bf8e41e2b1e9e984ee4eb7a5', 1, 'default', NULL, '2026-09-24 15:36:33', NULL, '2026-08-25 15:36:33', NULL, '2026-08-25 15:50:36', b'1', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3494, 10, '32d102d2012746c0a17771d90f7205bd', 1, 'default', NULL, '2026-09-24 15:51:00', NULL, '2026-08-25 15:51:00', NULL, '2026-08-25 15:51:00', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3495, 10, 'df86aa8b566442418dc7bc76832df2ef', 1, 'default', NULL, '2026-09-24 17:21:32', NULL, '2026-08-25 17:21:32', NULL, '2026-08-25 17:21:32', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3496, 11, '638114c525f84e3a957fda9eda828894', 1, 'default', NULL, '2026-09-25 00:56:34', NULL, '2026-08-26 00:56:34', NULL, '2026-08-26 00:56:34', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3497, 12, '2762a00047ad443c8e45d037dd395501', 1, 'default', NULL, '2026-09-25 00:56:34', NULL, '2026-08-26 00:56:34', NULL, '2026-08-26 00:56:34', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3498, 11, 'e7ba4b0b5e474253a2ee74c53b5d1ea0', 1, 'default', NULL, '2026-09-25 01:11:17', NULL, '2026-08-26 01:11:17', NULL, '2026-08-26 01:11:17', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3499, 12, '99acd6b0f0d2460dba1e89ca07567b6c', 1, 'default', NULL, '2026-09-25 01:11:17', NULL, '2026-08-26 01:11:17', NULL, '2026-08-26 01:11:17', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3500, 233, 'c786eb4e54794386a2556ce7eec50485', 2, 'default', NULL, '2026-09-25 01:15:41', NULL, '2026-08-26 01:15:41', NULL, '2026-08-26 01:15:41', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3501, 233, 'cebbf877c8dd42f282ff9fd13fde7c40', 2, 'default', NULL, '2026-09-25 01:16:00', NULL, '2026-08-26 01:16:00', NULL, '2026-08-26 01:16:00', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3502, 11, '0c2c468c0b304caea281dba2f7e93e5c', 1, 'default', NULL, '2026-09-25 01:16:48', NULL, '2026-08-26 01:16:48', NULL, '2026-08-26 01:16:48', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3503, 12, '3a3188a824904b66bde80451a7ba1e96', 1, 'default', NULL, '2026-09-25 01:16:48', NULL, '2026-08-26 01:16:48', NULL, '2026-08-26 01:16:48', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3504, 11, '5025c69d1b7b48fa9ce23f5cb8803f39', 1, 'default', NULL, '2026-09-25 01:17:26', NULL, '2026-08-26 01:17:26', NULL, '2026-08-26 01:17:26', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3505, 11, '9c7bc234d9dd411ca2a21215871a9289', 1, 'default', NULL, '2026-09-25 01:17:44', NULL, '2026-08-26 01:17:44', NULL, '2026-08-26 01:17:44', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3506, 11, '0f05e7104e2142f4b12e5f0c40291e96', 1, 'default', NULL, '2026-09-25 01:18:11', NULL, '2026-08-26 01:18:11', NULL, '2026-08-26 01:18:11', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3507, 11, '3a4d2b612d134b7f8d1a8a8a36d76fe5', 1, 'default', NULL, '2026-09-25 01:18:47', NULL, '2026-08-26 01:18:47', NULL, '2026-08-26 01:18:47', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3508, 11, '777f1e99888649c59d8163b1fda65b84', 1, 'default', NULL, '2026-09-25 01:21:06', NULL, '2026-08-26 01:21:06', NULL, '2026-08-26 01:21:06', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3509, 11, '90a0e31fb07e4e0ba8571aa163066d88', 1, 'default', NULL, '2026-09-25 01:23:50', NULL, '2026-08-26 01:23:50', NULL, '2026-08-26 01:23:50', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3510, 233, 'fde542b501f5438ca4b3768a05f7bbd9', 2, 'default', NULL, '2026-09-25 01:23:50', NULL, '2026-08-26 01:23:50', NULL, '2026-08-26 01:23:50', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3511, 11, '3217464d9adc46bab6827dcb22b05dd1', 1, 'default', NULL, '2026-09-25 09:16:15', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3512, 12, '2489a08f776e44aab229e3da87da9767', 1, 'default', NULL, '2026-09-25 09:16:15', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3513, 233, 'f0cd92054a9f4901999caaf5779d2200', 2, 'default', NULL, '2026-09-25 09:16:15', NULL, '2026-08-26 09:16:15', NULL, '2026-08-26 09:16:15', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3514, 11, '1aba405613564ba58a603ceacd881e5e', 1, 'default', NULL, '2026-09-25 09:16:41', NULL, '2026-08-26 09:16:41', NULL, '2026-08-26 09:16:41', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3515, 233, 'dd2153b96bf8414cb261aa413f11bad5', 2, 'default', NULL, '2026-09-25 09:16:42', NULL, '2026-08-26 09:16:42', NULL, '2026-08-26 09:16:42', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3516, 233, '8d51ec1b1014444f9752bf3edca98424', 2, 'default', NULL, '2026-09-25 09:17:17', NULL, '2026-08-26 09:17:17', NULL, '2026-08-26 09:17:17', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3517, 11, '99b15e124cf14182a6c33eb88a917213', 1, 'default', NULL, '2026-09-25 09:17:17', NULL, '2026-08-26 09:17:17', NULL, '2026-08-26 09:17:17', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3518, 11, 'a94f45ffe417486ea81e427ca9f5e209', 1, 'default', NULL, '2026-09-25 09:17:36', NULL, '2026-08-26 09:17:36', NULL, '2026-08-26 09:17:36', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3519, 233, '41459da646a14faa966ad44cda909ea3', 2, 'default', NULL, '2026-09-25 09:17:36', NULL, '2026-08-26 09:17:36', NULL, '2026-08-26 09:17:36', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3520, 11, 'a87af64f56034c8c868655e232edf55b', 1, 'default', NULL, '2026-09-25 09:20:07', NULL, '2026-08-26 09:20:07', NULL, '2026-08-26 09:20:07', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3521, 11, '28bf2221bc8b44c6b0fd4d6782a667e9', 1, 'default', NULL, '2026-09-25 10:26:05', NULL, '2026-08-26 10:26:05', NULL, '2026-08-26 10:26:05', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3522, 12, '629eca32a0ed48f79dbcdce07586c926', 1, 'default', NULL, '2026-09-25 10:26:05', NULL, '2026-08-26 10:26:05', NULL, '2026-08-26 10:26:05', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3523, 233, '306e5479df414693a468fa899d167272', 2, 'default', NULL, '2026-09-25 10:26:06', NULL, '2026-08-26 10:26:06', NULL, '2026-08-26 10:26:06', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3524, 11, '60134e0bbbe342eeb78a268903fa3ccd', 1, 'default', NULL, '2026-09-25 10:30:56', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3525, 12, '3c8642a7433546b5b9d1af51074ed93b', 1, 'default', NULL, '2026-09-25 10:30:56', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3526, 233, '9fe8ec9caa434afcb09604fe475dd1b9', 2, 'default', NULL, '2026-09-25 10:30:56', NULL, '2026-08-26 10:30:56', NULL, '2026-08-26 10:30:56', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3527, 11, '80be0fa5a5f341829be70506d19b2af5', 1, 'default', NULL, '2026-09-25 10:32:44', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3528, 12, 'b8002d71fea34bc3834b5d56b035c629', 1, 'default', NULL, '2026-09-25 10:32:44', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3529, 233, 'a596536a37f04a9da97fbf0f01228868', 2, 'default', NULL, '2026-09-25 10:32:44', NULL, '2026-08-26 10:32:44', NULL, '2026-08-26 10:32:44', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3530, 233, '7dc039c1ee094fb0ba3879947de358b5', 2, 'default', NULL, '2026-09-25 10:35:43', NULL, '2026-08-26 10:35:43', NULL, '2026-08-26 10:35:43', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3531, 233, '0aa5701da84b4b47bc86e27b71849634', 2, 'default', NULL, '2026-09-25 10:36:00', NULL, '2026-08-26 10:36:00', NULL, '2026-08-26 10:36:00', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3532, 233, '122ce06384f142f2a8e0f5c29e6c233e', 2, 'default', NULL, '2026-09-25 10:37:14', NULL, '2026-08-26 10:37:14', NULL, '2026-08-26 10:37:14', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3533, 233, '6342e82e7d244dd3a09edd9f1a1259e3', 2, 'default', NULL, '2026-09-25 10:42:18', NULL, '2026-08-26 10:42:18', NULL, '2026-08-26 10:42:18', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3534, 233, '2162d927bbe1463fa503b9cd22c846f1', 2, 'default', NULL, '2026-09-25 10:44:07', NULL, '2026-08-26 10:44:07', NULL, '2026-08-26 10:44:07', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3535, 233, '6cad1f8ebccb48cdac29f0303d94e630', 2, 'default', NULL, '2026-09-25 10:44:25', NULL, '2026-08-26 10:44:25', NULL, '2026-08-26 10:44:25', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3536, 11, 'ce9447f94b744e8bb93f65207404b8b7', 1, 'default', NULL, '2026-09-25 10:44:28', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3537, 12, 'dc662cba4dee428dbb46969909a04b06', 1, 'default', NULL, '2026-09-25 10:44:28', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3538, 233, '7ee301f9420149bdb8f711928bca8be3', 2, 'default', NULL, '2026-09-25 10:44:28', NULL, '2026-08-26 10:44:28', NULL, '2026-08-26 10:44:28', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3539, 233, '307641432bf64c6b9fb8dbfd9311484e', 2, 'default', NULL, '2026-09-25 10:45:31', NULL, '2026-08-26 10:45:31', NULL, '2026-08-26 10:45:31', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3540, 233, '71b2aaa5f0bd4b3a8dce608433ba82a6', 2, 'default', NULL, '2026-09-25 10:46:24', NULL, '2026-08-26 10:46:24', NULL, '2026-08-26 10:46:24', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3541, 11, 'c51e8908fcab4401b680bddb7c10e2cb', 1, 'default', NULL, '2026-09-25 10:50:06', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3542, 12, '55eefd8cfced4100812c580b88df9150', 1, 'default', NULL, '2026-09-25 10:50:06', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3543, 233, '06f849cb9c5049b8ad36422ad0a633c5', 2, 'default', NULL, '2026-09-25 10:50:06', NULL, '2026-08-26 10:50:06', NULL, '2026-08-26 10:50:06', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3544, 10, 'a56295ab49c046a1942c7356a8a4f283', 1, 'default', NULL, '2026-09-25 11:52:45', NULL, '2026-08-26 11:52:45', NULL, '2026-08-26 11:52:45', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3545, 10, 'f3b8ba7c4b5a4e698291c1e653eaca49', 1, 'default', NULL, '2026-09-25 15:32:06', NULL, '2026-08-26 15:32:06', NULL, '2026-08-26 15:32:06', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3546, 10, '66a45e456efb4ddc9427101b3e8278bc', 1, 'default', NULL, '2026-09-25 15:39:59', NULL, '2026-08-26 15:39:59', NULL, '2026-08-26 15:39:59', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3547, 10, '6f1f838ba942466bb8b07cc9f21fb61d', 1, 'default', NULL, '2026-09-25 15:41:03', NULL, '2026-08-26 15:41:03', NULL, '2026-08-26 15:41:03', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3548, 10, '85d7002e8bcb4ded90bba73d48f60229', 1, 'default', NULL, '2026-09-25 15:42:20', NULL, '2026-08-26 15:42:20', NULL, '2026-08-26 15:42:20', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3549, 10, '6e5ef03aee114161b7a03fc81b12a274', 1, 'default', NULL, '2026-09-25 15:42:56', NULL, '2026-08-26 15:42:56', NULL, '2026-08-26 15:42:56', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3550, 10, 'aad83664ba1547ef89b1983242326214', 1, 'default', NULL, '2026-09-25 15:43:34', NULL, '2026-08-26 15:43:34', NULL, '2026-08-26 15:43:34', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3551, 10, '1919eb1f2d0743f58aecacb3824821e6', 1, 'default', NULL, '2026-09-25 15:44:12', NULL, '2026-08-26 15:44:12', NULL, '2026-08-26 15:44:12', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3552, 10, '16ed279691de4a81a16f6028609f0072', 1, 'default', NULL, '2026-09-25 15:45:24', NULL, '2026-08-26 15:45:24', NULL, '2026-08-26 15:45:24', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3553, 10, 'e8218678ff3c4108bbf81364c4a1c827', 1, 'default', NULL, '2026-09-25 15:49:53', NULL, '2026-08-26 15:49:53', NULL, '2026-08-26 15:49:53', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3554, 10, 'ec1593d3ab4747a0977f3a2b0fb19ce3', 1, 'default', NULL, '2026-09-25 15:50:38', NULL, '2026-08-26 15:50:38', NULL, '2026-08-26 15:50:38', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3555, 10, '8fa70e89e8ca427a9e8a1acbab7175a3', 1, 'default', NULL, '2026-09-25 15:54:41', NULL, '2026-08-26 15:54:41', NULL, '2026-08-26 15:54:41', b'0', 0);
INSERT INTO `system_oauth2_refresh_token` VALUES (3556, 10, '5262fb4bcb7a48fe8bfd45f96943a534', 1, 'default', NULL, '2026-09-25 15:55:09', NULL, '2026-08-26 15:55:09', NULL, '2026-08-26 15:55:09', b'0', 0);

-- ----------------------------
-- Table structure for system_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `system_operate_log`;
CREATE TABLE `system_operate_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `trace_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '??????',
  `user_id` bigint NOT NULL COMMENT '????',
  `user_type` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `sub_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `biz_id` bigint NOT NULL COMMENT '????????',
  `action` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `success` bit(1) NOT NULL DEFAULT b'1' COMMENT '????',
  `extra` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '?????',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??? UA',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9216 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????? V2 ??' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_operate_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_post
-- ----------------------------
DROP TABLE IF EXISTS `system_post`;
CREATE TABLE `system_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `sort` int NOT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '???0?? 1???',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_post
-- ----------------------------

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS `system_role`;
CREATE TABLE `system_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???????',
  `sort` int NOT NULL COMMENT '????',
  `data_scope` tinyint NOT NULL DEFAULT 1 COMMENT '?????1??????? 2??????? 3???????? 4????????????',
  `data_scope_dept_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '????(??????)',
  `status` tinyint NOT NULL COMMENT '?????0?? 1???',
  `type` tinyint NOT NULL COMMENT '????',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 165 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_role
-- ----------------------------
INSERT INTO `system_role` VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 0, 1, '超级管理员', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:21', b'0', 1);
INSERT INTO `system_role` VALUES (2, '普通角色', 'common', 2, 2, '', 0, 1, '普通角色', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:20', b'0', 1);
INSERT INTO `system_role` VALUES (3, 'CRM 管理员', 'crm_admin', 2, 1, '', 0, 1, 'CRM 专属角色', '1', '2024-02-24 10:51:13', '1', '2024-02-24 02:51:32', b'0', 1);
INSERT INTO `system_role` VALUES (109, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', b'0', 121);
INSERT INTO `system_role` VALUES (111, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', b'0', 122);
INSERT INTO `system_role` VALUES (155, '测试数据权限12', 'test-dp', 4, 2, '[112,100,102,103,104,105,107,108]', 0, 2, '1111', '1', '2025-03-31 14:58:06', '1', '2026-06-26 10:42:44', b'0', 1);
INSERT INTO `system_role` VALUES (164, 'Heritage E2E Role', 'heritage_e2e', 9999, 1, '', 0, 2, 'local-only heritage E2E', 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);

-- ----------------------------
-- Table structure for system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_role_menu`;
CREATE TABLE `system_role_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `role_id` bigint NOT NULL COMMENT '??ID',
  `menu_id` bigint NOT NULL COMMENT '??ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7120 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '????????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_role_menu
-- ----------------------------
INSERT INTO `system_role_menu` VALUES (7098, 164, 6780, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7099, 164, 6781, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7100, 164, 6782, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7101, 164, 6783, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7102, 164, 6784, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7103, 164, 6785, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7104, 164, 6786, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7105, 164, 6787, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7106, 164, 6788, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7107, 164, 6789, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7108, 164, 6790, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7109, 164, 6791, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7110, 164, 6792, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7111, 164, 6793, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7112, 164, 6794, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);
INSERT INTO `system_role_menu` VALUES (7113, 164, 6795, '', '2026-08-26 10:30:25', '', '2026-08-26 10:30:25', b'0', 0);

-- ----------------------------
-- Table structure for system_sms_channel
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_channel`;
CREATE TABLE `system_sms_channel`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `signature` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '????',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `api_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? API ???',
  `api_secret` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? API ???',
  `callback_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?????? URL',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_channel
-- ----------------------------

-- ----------------------------
-- Table structure for system_sms_code
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_code`;
CREATE TABLE `system_sms_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `create_ip` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? IP',
  `scene` tinyint NOT NULL COMMENT '????',
  `today_index` tinyint NOT NULL COMMENT '????????',
  `used` tinyint NOT NULL COMMENT '????',
  `used_time` datetime NULL DEFAULT NULL COMMENT '????',
  `used_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? IP',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mobile`(`mobile` ASC) USING BTREE COMMENT '???'
) ENGINE = InnoDB AUTO_INCREMENT = 696 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_code
-- ----------------------------
INSERT INTO `system_sms_code` VALUES (695, '17371341270', '9999', '192.168.3.23', 1, 1, 0, NULL, NULL, NULL, '2026-08-25 15:28:40', NULL, '2026-08-25 15:28:40', b'0', 0);

-- ----------------------------
-- Table structure for system_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_log`;
CREATE TABLE `system_sms_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `channel_id` bigint NOT NULL COMMENT '??????',
  `channel_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `template_id` bigint NOT NULL COMMENT '????',
  `template_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_type` tinyint NOT NULL COMMENT '????',
  `template_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `template_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `api_template_id` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? API ?????',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `user_id` bigint NULL DEFAULT NULL COMMENT '????',
  `user_type` tinyint NULL DEFAULT NULL COMMENT '????',
  `send_status` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `send_time` datetime NULL DEFAULT NULL COMMENT '????',
  `api_send_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? API ???????',
  `api_send_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? API ???????',
  `api_request_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? API ????????? ID',
  `api_serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? API ???????',
  `receive_status` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '????',
  `api_receive_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'API ???????',
  `api_receive_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'API ???????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1569 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `system_sms_template`;
CREATE TABLE `system_sms_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `type` tinyint NOT NULL COMMENT '????',
  `status` tinyint NOT NULL COMMENT '????',
  `code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `api_template_id` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? API ?????',
  `channel_id` bigint NOT NULL COMMENT '??????',
  `channel_code` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_sms_template
-- ----------------------------

-- ----------------------------
-- Table structure for system_social_client
-- ----------------------------
DROP TABLE IF EXISTS `system_social_client`;
CREATE TABLE `system_social_client`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `social_type` tinyint NOT NULL COMMENT '???????',
  `user_type` tinyint NOT NULL COMMENT '????',
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `client_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `agent_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `public_key` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'publicKey ??',
  `status` tinyint NOT NULL COMMENT '??',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '??????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_social_client
-- ----------------------------

-- ----------------------------
-- Table structure for system_social_user
-- ----------------------------
DROP TABLE IF EXISTS `system_social_user`;
CREATE TABLE `system_social_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '??(????)',
  `type` tinyint NOT NULL COMMENT '???????',
  `openid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? openid',
  `token` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '?? token',
  `raw_token_info` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?? Token ?????? JSON ??',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `raw_user_info` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????????? JSON ??',
  `code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??????? code',
  `state` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????? state',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type_openid`(`type` ASC, `openid` ASC) USING BTREE,
  INDEX `idx_type_code_state`(`type` ASC, `code` ASC, `state` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_social_user
-- ----------------------------

-- ----------------------------
-- Table structure for system_social_user_bind
-- ----------------------------
DROP TABLE IF EXISTS `system_social_user_bind`;
CREATE TABLE `system_social_user_bind`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '??(????)',
  `user_id` bigint NOT NULL COMMENT '????',
  `user_type` tinyint NOT NULL COMMENT '????',
  `social_type` tinyint NOT NULL COMMENT '???????',
  `social_user_id` bigint NOT NULL COMMENT '???????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_type_social_user_id`(`user_type` ASC, `social_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 165 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_social_user_bind
-- ----------------------------

-- ----------------------------
-- Table structure for system_tenant
-- ----------------------------
DROP TABLE IF EXISTS `system_tenant`;
CREATE TABLE `system_tenant`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `contact_user_id` bigint NULL DEFAULT NULL COMMENT '????????',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `contact_mobile` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '????',
  `websites` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '??????',
  `package_id` bigint NOT NULL COMMENT '??????',
  `expire_time` datetime NOT NULL COMMENT '????',
  `account_count` int NOT NULL COMMENT '????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 162 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '???' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_tenant
-- ----------------------------
INSERT INTO `system_tenant` VALUES (1, '芋道源码', NULL, '芋艿', '17321315478', 0, 'www.iocoder.cn,127.0.0.1:3000,wxc4598c446f8a9cb3', 0, '2099-02-19 17:14:16', 9999, '1', '2021-01-05 17:03:47', '1', '2025-08-19 05:18:41', b'0');
INSERT INTO `system_tenant` VALUES (121, '小租户', 110, '小王2', '15601691300', 0, 'zsxq.iocoder.cn,123321', 111, '2026-07-10 00:00:00', 30, '1', '2022-02-22 00:56:14', '1', '2025-08-19 21:19:29', b'0');
INSERT INTO `system_tenant` VALUES (122, '测试租户', 113, '芋道', '15601691300', 0, 'test.iocoder.cn,222,333', 111, '2023-04-29 00:00:00', 50, '1', '2022-03-07 21:37:58', '1', '2026-06-01 23:29:35', b'0');

-- ----------------------------
-- Table structure for system_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS `system_tenant_package`;
CREATE TABLE `system_tenant_package`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '?????0?? 1???',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '??',
  `menu_ids` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_tenant_package
-- ----------------------------
INSERT INTO `system_tenant_package` VALUES (111, '普通套餐', 0, '小功能', '[1,2,5,1031,1032,1033,1034,1035,1036,1037,1038,1039,1050,1051,1052,1053,1054,1056,1057,1058,1059,1060,1063,1064,1065,1066,1067,1070,1075,1077,1078,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1117,1118,1119,1120,100,101,102,1126,103,1127,1128,1129,106,1130,107,1132,1133,110,1134,111,1135,112,1136,113,1137,2161,114,1138,1139,115,1140,116,1141,1142,1143,1150,1161,1162,1166,1173,1174,2713,2714,1178,2715,2716,2717,2718,2720,2721,1185,2722,1186,1187,2723,1188,2724,1189,2725,1190,2726,1191,2727,1192,2728,2729,1193,1194,2730,1195,2731,2732,1197,2733,1198,2734,1199,2735,1200,1201,1202,2739,2740,1207,1208,1209,2745,1210,2746,1211,2747,1212,2748,1213,1215,1216,1217,1218,1219,1220,2756,1221,2757,1222,1224,1225,1226,1227,1228,1229,1237,1238,2262,1239,1240,1241,1242,1243,2275,2276,2277,1255,1256,1257,2281,1258,2282,1259,2283,1260,2284,2285,2287,2288,2293,2294,2297,2300,2301,2302,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2363,2364,5011,5012,2472,2478,2479,2480,2481,2482,2483,2484,2485,2486,2487,2488,2489,2490,2491,2492,2493,2494,2495,2497,2525,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,2549,1014,2550,1015,2551,1016,2552,1017,2553,1018,2554,1019,2555,1020,2556,2557,2558,2559]', '1', '2022-02-22 00:54:00', '1', '2025-09-06 20:52:25', b'0');
INSERT INTO `system_tenant_package` VALUES (113, '测试套餐（啥都没有）', 0, '', '[2160,1254,2159]', '1', '2026-06-01 23:22:39', '1', '2026-06-09 14:44:00', b'0');

-- ----------------------------
-- Table structure for system_user_post
-- ----------------------------
DROP TABLE IF EXISTS `system_user_post`;
CREATE TABLE `system_user_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '??ID',
  `post_id` bigint NOT NULL DEFAULT 0 COMMENT '??ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 130 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_user_post
-- ----------------------------
INSERT INTO `system_user_post` VALUES (112, 1, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', b'0', 1);
INSERT INTO `system_user_post` VALUES (113, 100, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', b'0', 1);
INSERT INTO `system_user_post` VALUES (115, 104, 1, '1', '2022-05-16 19:36:28', '1', '2022-05-16 19:36:28', b'0', 1);
INSERT INTO `system_user_post` VALUES (116, 117, 2, '1', '2022-07-09 17:40:26', '1', '2022-07-09 17:40:26', b'0', 1);
INSERT INTO `system_user_post` VALUES (117, 118, 1, '1', '2022-07-09 17:44:44', '1', '2022-07-09 17:44:44', b'0', 1);
INSERT INTO `system_user_post` VALUES (119, 114, 5, '1', '2024-03-24 20:45:51', '1', '2024-03-24 20:45:51', b'0', 1);
INSERT INTO `system_user_post` VALUES (123, 115, 1, '1', '2024-04-04 09:37:14', '1', '2024-04-04 09:37:14', b'0', 1);
INSERT INTO `system_user_post` VALUES (124, 115, 2, '1', '2024-04-04 09:37:14', '1', '2024-04-04 09:37:14', b'0', 1);
INSERT INTO `system_user_post` VALUES (125, 1, 2, '1', '2024-07-13 22:31:39', '1', '2024-07-13 22:31:39', b'0', 1);
INSERT INTO `system_user_post` VALUES (128, 139, 2, '1', '2025-12-05 21:43:27', '1', '2025-12-05 21:43:27', b'0', 1);
INSERT INTO `system_user_post` VALUES (129, 139, 4, '1', '2025-12-05 21:43:27', '1', '2025-12-05 21:43:27', b'0', 1);

-- ----------------------------
-- Table structure for system_user_role
-- ----------------------------
DROP TABLE IF EXISTS `system_user_role`;
CREATE TABLE `system_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `user_id` bigint NOT NULL COMMENT '??ID',
  `role_id` bigint NOT NULL COMMENT '??ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '????????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_user_role
-- ----------------------------
INSERT INTO `system_user_role` VALUES (1, 1, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:17', b'0', 1);
INSERT INTO `system_user_role` VALUES (2, 2, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:13', b'0', 1);
INSERT INTO `system_user_role` VALUES (5, 100, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:12', b'0', 1);
INSERT INTO `system_user_role` VALUES (6, 100, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:11', b'0', 1);
INSERT INTO `system_user_role` VALUES (10, 103, 1, '1', '2022-01-11 13:19:45', '1', '2022-01-11 13:19:45', b'0', 1);
INSERT INTO `system_user_role` VALUES (14, 110, 109, '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', b'0', 121);
INSERT INTO `system_user_role` VALUES (15, 111, 110, '110', '2022-02-23 13:14:38', '110', '2022-02-23 13:14:38', b'0', 121);
INSERT INTO `system_user_role` VALUES (16, 113, 111, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', b'0', 122);
INSERT INTO `system_user_role` VALUES (18, 1, 2, '1', '2022-05-12 20:39:29', '1', '2022-05-12 20:39:29', b'0', 1);
INSERT INTO `system_user_role` VALUES (22, 115, 2, '1', '2022-07-21 22:08:30', '1', '2022-07-21 22:08:30', b'0', 1);
INSERT INTO `system_user_role` VALUES (35, 112, 1, '1', '2024-03-15 20:00:24', '1', '2024-03-15 20:00:24', b'0', 1);
INSERT INTO `system_user_role` VALUES (36, 118, 1, '1', '2024-03-17 09:12:08', '1', '2024-03-17 09:12:08', b'0', 1);
INSERT INTO `system_user_role` VALUES (46, 117, 1, '1', '2024-10-02 10:16:11', '1', '2024-10-02 10:16:11', b'0', 1);
INSERT INTO `system_user_role` VALUES (47, 104, 2, '1', '2025-01-04 10:40:33', '1', '2025-01-04 10:40:33', b'0', 1);
INSERT INTO `system_user_role` VALUES (48, 100, 155, '1', '2025-04-04 10:41:14', '1', '2025-04-04 10:41:14', b'0', 1);
INSERT INTO `system_user_role` VALUES (49, 142, 1, '1', '2025-07-23 09:11:42', '1', '2025-07-23 09:11:42', b'0', 1);
INSERT INTO `system_user_role` VALUES (50, 142, 2, '1', '2025-10-07 20:50:37', '1', '2025-10-07 20:50:37', b'0', 1);
INSERT INTO `system_user_role` VALUES (51, 139, 1, '1', '2025-12-05 22:36:57', '1', '2025-12-05 22:36:57', b'0', 1);
INSERT INTO `system_user_role` VALUES (52, 139, 2, '1', '2025-12-05 22:37:00', '1', '2025-12-05 22:37:00', b'0', 1);
INSERT INTO `system_user_role` VALUES (53, 114, 2, '1', '2026-01-04 18:15:40', '1', '2026-01-04 18:15:40', b'0', 1);
INSERT INTO `system_user_role` VALUES (54, 114, 3, '1', '2026-01-04 18:16:19', '1', '2026-01-04 18:16:19', b'0', 1);
INSERT INTO `system_user_role` VALUES (61, 232, 164, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_user_role` VALUES (62, 233, 164, 'e2e', '2026-08-26 01:15:28', 'e2e', '2026-08-26 01:15:28', b'0', 0);

-- ----------------------------
-- Table structure for system_users
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '??',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '??ID',
  `post_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `sex` tinyint NULL DEFAULT 0 COMMENT '????',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '?????0?? 1???',
  `login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '??????',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '????',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_mobile`(`mobile` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE,
  INDEX `idx_dept_id`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_users
-- ----------------------------
INSERT INTO `system_users` VALUES (1, 'admin', '$2a$04$.vd8nPeLwxt6hnSzmAoAyul8BOLX7Cib6QhcxRe30rfvrIPQHH1OG', '芋道源码', '管理员', 103, '[1,2]', '13aoteman@126.com', '18818260272', 1, '', 0, '127.0.0.1', '2026-08-24 12:35:00', 'admin', '2021-01-05 17:03:47', NULL, '2026-08-24 12:35:00', b'0', 1);
INSERT INTO `system_users` VALUES (100, 'yudao', '$2a$04$.vd8nPeLwxt6hnSzmAoAyul8BOLX7Cib6QhcxRe30rfvrIPQHH1OG', '芋道', '不要吓我', 104, '[1]', 'yudao@iocoder.cn', '15601691300', 1, NULL, 0, '127.0.0.1', '2026-06-17 09:37:17', '', '2021-01-07 09:07:17', NULL, '2026-06-17 09:37:17', b'0', 1);
INSERT INTO `system_users` VALUES (103, 'yuanma', '$2a$04$k/d6mc0nySN0i2udwcI8Ee8V5aM5OHixBRbQfXmPuFTUl3Zf/DBs.', '源码', NULL, 106, NULL, 'yuanma@iocoder.cn', '15601701300', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2026-04-27 13:19:27', '', '2021-01-13 23:50:35', NULL, '2026-04-27 13:19:27', b'0', 1);
INSERT INTO `system_users` VALUES (104, 'test', '$2a$04$BrwaYn303hjA/6TnXqdGoOLhyHOAA0bVrAFu6.1dJKycqKUnIoRz2', '测试号', NULL, 107, '[1,2]', '111@qq.com', '15601691200', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2026-06-16 11:37:56', '', '2021-01-21 02:13:53', NULL, '2026-06-16 11:37:56', b'0', 1);
INSERT INTO `system_users` VALUES (107, 'admin107', '$2a$10$dYOOBKMO93v/.ReCqzyFg.o67Tqk.bbc2bhrpyBGkIw9aypCtr2pm', '芋艿', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '', NULL, '1', '2022-02-20 22:59:33', '1', '2025-04-21 14:23:08', b'0', 118);
INSERT INTO `system_users` VALUES (108, 'admin108', '$2a$10$y6mfvKoNYL1GXWak8nYwVOH.kCWqjactkzdoIDgiKl93WN3Ejg.Lu', '芋艿', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '', NULL, '1', '2022-02-20 23:00:50', '1', '2025-04-21 14:23:08', b'0', 119);
INSERT INTO `system_users` VALUES (109, 'admin109', '$2a$10$JAqvH0tEc0I7dfDVBI7zyuB4E3j.uH6daIjV53.vUS6PknFkDJkuK', '芋艿', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '', NULL, '1', '2022-02-20 23:11:50', '1', '2025-04-21 14:23:08', b'0', 120);
INSERT INTO `system_users` VALUES (110, 'admin110', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', '小王', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2024-07-20 22:23:17', '1', '2022-02-22 00:56:14', NULL, '2025-04-21 14:23:08', b'0', 121);
INSERT INTO `system_users` VALUES (111, 'test', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', '测试用户', NULL, NULL, '[]', '', '', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2023-12-30 11:42:17', '110', '2022-02-23 13:14:33', NULL, '2025-04-21 14:23:08', b'0', 121);
INSERT INTO `system_users` VALUES (112, 'newobject', '$2a$04$dB0z8Q819fJWz0hbaLe6B.VfHCjYgWx6LFfET5lyz3JwcqlyCkQ4C', '新对象', NULL, 100, '[]', '', '15601691235', 1, NULL, 0, '127.0.0.1', '2026-06-17 09:07:20', '1', '2022-02-23 19:08:03', NULL, '2026-06-17 09:07:20', b'0', 1);
INSERT INTO `system_users` VALUES (113, 'aoteman', '$2a$10$0acJOIk2D25/oC87nyclE..0lzeu9DtQ/n3geP4fkun/zIVRhHJIO', '芋道1', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '127.0.0.1', '2022-03-19 18:38:51', '1', '2022-03-07 21:37:58', '1', '2025-05-05 15:30:53', b'0', 122);
INSERT INTO `system_users` VALUES (114, 'hrmgr', '$2a$10$TR4eybBioGRhBmDBWkqWLO6NIh3mzYa8KBKDDB5woiGYFVlRAi.fu', 'hr 小姐姐', NULL, NULL, '[5]', '', '15601691236', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2026-01-04 18:16:01', '1', '2022-03-19 21:50:58', NULL, '2026-01-04 18:16:01', b'0', 1);
INSERT INTO `system_users` VALUES (115, 'aotemane', '$2a$04$GcyP0Vyzb2F2Yni5PuIK9ueGxM0tkZGMtDwVRwrNbtMvorzbpNsV2', '阿呆', '11222', 102, '[1,2]', '7648@qq.com', '15601691229', 2, NULL, 0, '', NULL, '1', '2022-04-30 02:55:43', '1', '2025-04-21 14:23:08', b'0', 1);
INSERT INTO `system_users` VALUES (117, 'admin123', '$2a$04$sEtimsHu9YCkYY4/oqElHem2Ijc9ld20eYO6lN.g/21NfLUTDLB9W', '测试号02', '1111', 100, '[2]', '', '15601691234', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2024-10-02 10:16:20', '1', '2022-07-09 17:40:26', '1', '2025-05-14 09:56:04', b'0', 1);
INSERT INTO `system_users` VALUES (118, 'goudan', '$2a$04$3suGZjnA6rM5bErf38u1felbgqbsPHGdRG3l9NkxPCEt2ah9Y6aJi', '狗蛋', NULL, 103, '[1]', '', '15601691239', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2025-11-23 15:28:25', '1', '2022-07-09 17:44:43', NULL, '2025-11-23 15:28:25', b'0', 1);
INSERT INTO `system_users` VALUES (139, 'wwbwwb', '$2a$04$FJLIyg8lbPytP29pbZaiU.LesJvCsYfEaHqQfB0pGQhK3e9BeZmLy', '小秃头', '123', 108, '[2,4]', '', '', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2024-09-10 21:03:58', NULL, '2024-09-10 21:03:58', '1', '2025-12-15 22:38:15', b'0', 1);
INSERT INTO `system_users` VALUES (141, 'admin1', '$2a$04$oj6F6d7HrZ70kYVD3TNzEu.m3TPUzajOVuC66zdKna8KRerK1FmVa', '新用户', NULL, NULL, NULL, '', '', 0, '', 0, '127.0.0.1', '2026-06-17 09:37:18', '1', '2025-04-08 13:09:07', NULL, '2026-06-17 09:37:18', b'0', 1);
INSERT INTO `system_users` VALUES (142, 'test01', '$2a$04$4bCYWZkjxxOC4QE0LY2M9uEEKWeJbLfs489NFtQoyidL5I0FndRaO', 'test01', '', NULL, '[]', '', '19021719925', 1, '', 0, '0:0:0:0:0:0:0:1', '2026-06-17 10:44:58', '1', '2025-07-09 21:07:10', NULL, '2026-06-17 10:44:58', b'0', 1);
INSERT INTO `system_users` VALUES (143, 'a00001', '$2a$04$GhVHFviOw/SsTmiQtifHJesDYFlHMeGK7OWh7aGCCjGGVCmbHVAwa', 'a00001', NULL, 104, NULL, '', '', 0, '', 0, '0:0:0:0:0:0:0:1', '2025-12-01 16:10:13', NULL, '2025-12-01 16:10:13', '1', '2025-12-05 21:34:05', b'0', 1);
INSERT INTO `system_users` VALUES (144, 'aoteman001', '$2a$04$omQOmhz8OyUFBKw77nr8KOtMp6xdvoQ1gWStjk9r8.OYT3Bv6oEYe', 'aoteman00112', NULL, 104, NULL, '', '', 0, '', 1, '0:0:0:0:0:0:0:1', '2025-12-01 17:05:27', '1', '2025-12-01 17:05:27', '1', '2026-06-15 18:58:56', b'0', 1);
INSERT INTO `system_users` VALUES (225, 'im01', '$2a$04$IPEX9AqSCrqtS7i60kbdQu9fwOYDjWUL8jIF0BtrsIyrnu5ulcAvu', 'im01', '', NULL, '[]', '', '', 0, '', 0, '127.0.0.1', '2026-08-24 11:11:14', '1', '2026-08-16 10:29:34', NULL, '2026-08-24 11:11:14', b'0', 1);
INSERT INTO `system_users` VALUES (229, 'im02', '$2a$04$u.wztNhtiffV9ahMm6xLuOpnynXLTvz9LpMHJlYoGfgGRjFy9TS76', 'im02', '', NULL, '[]', '', '', 0, '', 0, '127.0.0.1', '2026-08-24 11:14:44', '1', '2026-08-24 11:12:16', NULL, '2026-08-24 11:14:44', b'0', 1);
INSERT INTO `system_users` VALUES (232, 'heritage_e2e_admin', '$2a$04$nG./SX7tdEN60MHjZ8OYsOlFGTaBOSOHWu9qzc/ZQlDyOX7WjmNf.', 'Heritage E2E Admin', 'local-only heritage E2E', NULL, '', '', '', 0, '', 0, '', NULL, 'e2e', '2026-08-26 01:14:47', 'e2e', '2026-08-26 01:14:47', b'0', 0);
INSERT INTO `system_users` VALUES (233, 'heritagee2eadmin', '$2a$10$l4/Eb5JsorudAFCxsS/9qeqOe.QrJ.InmQPzeEXnPqoooAHp5P4t2', 'Heritage E2E Admin', 'local-only heritage E2E', NULL, '', '', '', 0, '', 0, '127.0.0.1', '2026-08-26 10:50:06', 'e2e', '2026-08-26 01:15:28', NULL, '2026-08-26 10:50:06', b'0', 0);

-- ----------------------------
-- Table structure for trade_cart
-- ----------------------------
DROP TABLE IF EXISTS `trade_cart`;
CREATE TABLE `trade_cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车项编号',
  `user_id` bigint NOT NULL COMMENT '会员编号',
  `spu_id` bigint NOT NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint NOT NULL COMMENT '商品 SKU 编号',
  `count` int NOT NULL COMMENT '商品数量',
  `selected` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否选中',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_trade_cart_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_trade_cart_spu_id`(`spu_id` ASC) USING BTREE,
  INDEX `idx_trade_cart_sku_id`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trade_cart
-- ----------------------------
INSERT INTO `trade_cart` VALUES (12, 10, 85, 124, 3, b'1', '10', '2026-08-25 21:30:05', '10', '2026-08-25 21:30:09', b'0');

-- ----------------------------
-- Table structure for trade_delivery_express_template
-- ----------------------------
DROP TABLE IF EXISTS `trade_delivery_express_template`;
CREATE TABLE `trade_delivery_express_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `charge_mode` tinyint NOT NULL COMMENT '1=按件，2=按重量，3=按体积',
  `sort` int NOT NULL DEFAULT 0,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_trade_delivery_express_template_name_deleted`(`name` ASC, `deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '快递运费模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trade_delivery_express_template
-- ----------------------------

-- ----------------------------
-- Table structure for trade_delivery_express_template_charge
-- ----------------------------
DROP TABLE IF EXISTS `trade_delivery_express_template_charge`;
CREATE TABLE `trade_delivery_express_template_charge`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_id` bigint NOT NULL,
  `area_ids` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '区域编号，以逗号分隔；空代表默认区域',
  `charge_mode` tinyint NOT NULL COMMENT '冗余模板计费方式',
  `start_count` double NOT NULL,
  `start_price` int NOT NULL COMMENT '分',
  `extra_count` double NOT NULL,
  `extra_price` int NOT NULL COMMENT '分',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_trade_delivery_express_template_charge_template_id`(`template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '快递运费模板计费规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trade_delivery_express_template_charge
-- ----------------------------

-- ----------------------------
-- Table structure for trade_delivery_express_template_free
-- ----------------------------
DROP TABLE IF EXISTS `trade_delivery_express_template_free`;
CREATE TABLE `trade_delivery_express_template_free`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_id` bigint NOT NULL,
  `area_ids` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '区域编号，以逗号分隔',
  `free_price` int NOT NULL DEFAULT 0 COMMENT '分',
  `free_count` int NOT NULL DEFAULT 0 COMMENT '件数',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_trade_delivery_express_template_free_template_id`(`template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '快递运费模板包邮规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trade_delivery_express_template_free
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;

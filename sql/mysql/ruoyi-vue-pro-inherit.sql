-- ============================================================
-- 传承人模块 增量 SQL（yudao-module-inherit）
-- 适用数据库：MySQL 8.x，导入顺序：ruoyi-vue-pro.sql -> 本文件
--
-- 内容：
--   1. 5 张业务表（inherit_ 前缀，均带 tenant_id 租户扩展）
--   2. 2 个数据字典（传承人级别、荣誉/资质类型）
--   3. 非遗管理后台菜单（id 7000-7032）
-- ============================================================

-- ----------------------------
-- 1. 传承人表
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor`;
CREATE TABLE `inherit_inheritor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `pinyin` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名拼音（小写无空格，用于拼音搜索）',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像（真人照片）',
  `cover` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图',
  `gender` tinyint NOT NULL DEFAULT 0 COMMENT '性别：0未知 1男 2女',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '传承人级别/身份',
  `province_code` int NULL DEFAULT NULL COMMENT '省份编号（/system/area id）',
  `city_code` int NULL DEFAULT NULL COMMENT '城市编号',
  `district_code` int NULL DEFAULT NULL COMMENT '区县编号',
  `introduction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '简介（一句话）',
  `profile` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '详细介绍',
  `specialty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '擅长技艺（多个用逗号分隔）',
  `experience` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '从业经历',
  `audit_status` tinyint NOT NULL DEFAULT 0 COMMENT '审核状态：0待审核 1已通过 2未通过',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `display_status` tinyint NOT NULL DEFAULT 1 COMMENT '展示状态：0不展示 1展示',
  `published_at` datetime NULL DEFAULT NULL COMMENT '上架（展示）时间',
  `is_recommend` tinyint NOT NULL DEFAULT 0 COMMENT '是否首页推荐：0否 1是',
  `recommend_sort` int NOT NULL DEFAULT 0 COMMENT '首页推荐排序，越小越靠前',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序，越小越靠前',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0正常 1停用',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_inheritor_audit`(`audit_status`, `status`) USING BTREE,
  INDEX `idx_inheritor_region`(`province_code`, `city_code`, `district_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人表';

-- ----------------------------
-- 2. 传承人荣誉/资质表
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_qualification`;
CREATE TABLE `inherit_inheritor_qualification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型：荣誉/资质/代表性传承人身份/获奖/证书',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '级别',
  `issuer` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '颁发机构',
  `issue_date` date NULL DEFAULT NULL COMMENT '颁发日期',
  `certificate_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证书编号',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证书/荣誉图片 url',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序，越小越靠前',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0正常 1停用',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_qualification_inheritor`(`inheritor_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人荣誉/资质表';

-- ----------------------------
-- 3. 传承人作品表
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_work`;
CREATE TABLE `inherit_inheritor_work` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作品名称',
  `cover` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图 url',
  `images` json NULL COMMENT '作品图集（多图）url 列表',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作品描述',
  `year` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创作年份',
  `material` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '材质',
  `technique` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工艺/技法',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序，越小越靠前',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0正常 1停用',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_work_inheritor`(`inheritor_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人作品表';

-- ----------------------------
-- 4. 传承人-非遗项目 关系表（只存关系 ID，非遗项目主数据属未来模块，禁止跨模块外键）
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_project_relation`;
CREATE TABLE `inherit_inheritor_project_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `project_id` bigint NOT NULL COMMENT '非遗项目编号（HeritageProject 模块主键，弱关联）',
  `is_primary` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否主打项目：0否 1是',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序，越小越靠前',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_inheritor_project`(`inheritor_id`, `project_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人-非遗项目 关系表';

-- ----------------------------
-- 5. 传承人关注表（用户复用 member_user 体系，user_id + inheritor_id 唯一）
-- ----------------------------
DROP TABLE IF EXISTS `inherit_inheritor_follow`;
CREATE TABLE `inherit_inheritor_follow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NOT NULL COMMENT '用户编号（member_user.id）',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_inheritor`(`user_id`, `inheritor_id`) USING BTREE,
  INDEX `idx_follow_inheritor`(`inheritor_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传承人关注表';

-- ============================================================
-- 2. 数据字典
-- ============================================================

-- 2.1 传承人级别
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES (7000, '传承人级别', 'inherit_inheritor_level', 0, '传承人级别/身份', 'admin', NOW(), 'admin', NOW(), b'0', NULL);
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
  (7000, 1, '国家级代表性传承人', '国家级代表性传承人', 'inherit_inheritor_level', 0, 'danger', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7001, 2, '省级代表性传承人', '省级代表性传承人', 'inherit_inheritor_level', 0, 'warning', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7002, 3, '市级代表性传承人', '市级代表性传承人', 'inherit_inheritor_level', 0, 'primary', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7003, 4, '区县级代表性传承人', '区县级代表性传承人', 'inherit_inheritor_level', 0, 'info', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0');

-- 2.2 荣誉/资质类型
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES (7001, '荣誉/资质类型', 'inherit_qualification_type', 0, '传承人荣誉/资质类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL);
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
  (7010, 1, '荣誉', '荣誉', 'inherit_qualification_type', 0, 'primary', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7011, 2, '资质', '资质', 'inherit_qualification_type', 0, 'success', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7012, 3, '代表性传承人身份', '代表性传承人身份', 'inherit_qualification_type', 0, 'warning', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7013, 4, '获奖', '获奖', 'inherit_qualification_type', 0, 'danger', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
  (7014, 5, '证书', '证书', 'inherit_qualification_type', 0, 'info', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0');

-- ============================================================
-- 3. 菜单：非遗管理（id 7000-7032）
-- ============================================================
BEGIN;
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7000, '非遗管理', '', 1, 15, 0, '/inherit', 'ep:medal', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7001, '传承人管理', 'inherit:inheritor:query', 2, 1, 7000, 'inheritor', 'ep:user', 'inherit/inheritor/index', 'InheritInheritor', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7002, '传承人查询', 'inherit:inheritor:query', 3, 1, 7001, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7003, '传承人创建', 'inherit:inheritor:create', 3, 2, 7001, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7004, '传承人更新', 'inherit:inheritor:update', 3, 3, 7001, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7005, '传承人删除', 'inherit:inheritor:delete', 3, 4, 7001, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7006, '传承人审核', 'inherit:inheritor:audit', 3, 5, 7001, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7010, '荣誉资质管理', 'inherit:inheritor-qualification:query', 2, 2, 7000, 'qualification', 'ep:medal', 'inherit/inheritorQualification/index', 'InheritInheritorQualification', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7011, '荣誉资质查询', 'inherit:inheritor-qualification:query', 3, 1, 7010, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7012, '荣誉资质创建', 'inherit:inheritor-qualification:create', 3, 2, 7010, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7013, '荣誉资质更新', 'inherit:inheritor-qualification:update', 3, 3, 7010, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7014, '荣誉资质删除', 'inherit:inheritor-qualification:delete', 3, 4, 7010, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7020, '作品管理', 'inherit:inheritor-work:query', 2, 3, 7000, 'work', 'ep:picture', 'inherit/inheritorWork/index', 'InheritInheritorWork', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7021, '作品查询', 'inherit:inheritor-work:query', 3, 1, 7020, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7022, '作品创建', 'inherit:inheritor-work:create', 3, 2, 7020, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7023, '作品更新', 'inherit:inheritor-work:update', 3, 3, 7020, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7024, '作品删除', 'inherit:inheritor-work:delete', 3, 4, 7020, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7030, '非遗项目关系', 'inherit:inheritor-project-relation:query', 2, 4, 7000, 'project-relation', 'ep:link', 'inherit/inheritorProjectRelation/index', 'InheritInheritorProjectRelation', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7031, '关系查询', 'inherit:inheritor-project-relation:query', 3, 1, 7030, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7032, '关系创建', 'inherit:inheritor-project-relation:create', 3, 2, 7030, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7033, '关系更新', 'inherit:inheritor-project-relation:update', 3, 3, 7030, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES (7034, '关系删除', 'inherit:inheritor-project-relation:delete', 3, 4, 7030, '', '', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');
COMMIT;

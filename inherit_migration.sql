SET NAMES utf8mb4;
-- ============================================================
-- yudao-module-inherit 增量迁移
-- 基线：dev
-- 来源：main 分支传承人模块
-- 性质：非破坏性、可重复执行
-- 本脚本仅执行非破坏性增量操作。
-- ============================================================

CREATE TABLE IF NOT EXISTS `inherit_inheritor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `pinyin` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名拼音',
  `avatar` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `cover` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图',
  `gender` tinyint NOT NULL DEFAULT '0' COMMENT '性别',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号',
  `level` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '传承人级别',
  `province_code` int DEFAULT NULL COMMENT '省编码',
  `city_code` int DEFAULT NULL COMMENT '市编码',
  `district_code` int DEFAULT NULL COMMENT '区县编码',
  `introduction` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简介',
  `profile` text COLLATE utf8mb4_unicode_ci COMMENT '个人事迹',
  `specialty` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '技艺特长',
  `experience` text COLLATE utf8mb4_unicode_ci COMMENT '从艺经历',
  `audit_status` tinyint NOT NULL DEFAULT '0' COMMENT '审核状态',
  `audit_remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `display_status` tinyint NOT NULL DEFAULT '1' COMMENT '展示状态',
  `published_at` datetime DEFAULT NULL COMMENT '发布时间',
  `is_recommend` tinyint NOT NULL DEFAULT '0' COMMENT '是否推荐',
  `recommend_sort` int NOT NULL DEFAULT '0' COMMENT '推荐排序',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_inheritor_audit` (`audit_status`,`status`),
  KEY `idx_inheritor_region` (`province_code`,`city_code`,`district_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人表';

CREATE TABLE IF NOT EXISTS `inherit_inheritor_qualification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `level` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '级别',
  `issuer` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '颁发机构',
  `issue_date` date DEFAULT NULL COMMENT '颁发日期',
  `certificate_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '证书编号',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '说明',
  `image_url` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片地址',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_qualification_inheritor` (`inheritor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人荣誉/资质表';

CREATE TABLE IF NOT EXISTS `inherit_inheritor_work` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作品名称',
  `cover` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图',
  `images` json DEFAULT NULL COMMENT '作品图片',
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '作品描述',
  `year` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创作年份',
  `material` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '材质',
  `technique` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '技法',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_work_inheritor` (`inheritor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人作品表';

CREATE TABLE IF NOT EXISTS `inherit_inheritor_project_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `project_id` bigint NOT NULL COMMENT '非遗项目编号（逻辑关联）',
  `is_primary` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否主项目',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inheritor_project` (`inheritor_id`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人与非遗项目关系表';

CREATE TABLE IF NOT EXISTS `inherit_inheritor_follow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户编号（逻辑关联）',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_inheritor` (`user_id`,`inheritor_id`),
  KEY `idx_follow_inheritor` (`inheritor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人关注表';

-- 字典类型：按 type + 未删除状态幂等
INSERT INTO `system_dict_type` (`name`,`type`,`status`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人级别','inherit_inheritor_level',0,'传承人级别/身份','admin',NOW(),'admin',NOW(),b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_type` WHERE `type`='inherit_inheritor_level' AND `deleted`=b'0');
INSERT INTO `system_dict_type` (`name`,`type`,`status`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '荣誉/资质类型','inherit_qualification_type',0,'传承人荣誉/资质类型','admin',NOW(),'admin',NOW(),b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_type` WHERE `type`='inherit_qualification_type' AND `deleted`=b'0');

-- 字典数据：按 dict_type + value + 未删除状态幂等，不指定固定主键
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 1,'国家级代表性传承人','国家级代表性传承人','inherit_inheritor_level',0,'danger','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_inheritor_level' AND `value`='国家级代表性传承人' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 2,'省级代表性传承人','省级代表性传承人','inherit_inheritor_level',0,'warning','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_inheritor_level' AND `value`='省级代表性传承人' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 3,'市级代表性传承人','市级代表性传承人','inherit_inheritor_level',0,'primary','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_inheritor_level' AND `value`='市级代表性传承人' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 4,'区县级代表性传承人','区县级代表性传承人','inherit_inheritor_level',0,'info','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_inheritor_level' AND `value`='区县级代表性传承人' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 1,'荣誉','荣誉','inherit_qualification_type',0,'primary','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_qualification_type' AND `value`='荣誉' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 2,'资质','资质','inherit_qualification_type',0,'success','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_qualification_type' AND `value`='资质' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 3,'代表性传承人身份','代表性传承人身份','inherit_qualification_type',0,'warning','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_qualification_type' AND `value`='代表性传承人身份' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 4,'获奖','获奖','inherit_qualification_type',0,'danger','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_qualification_type' AND `value`='获奖' AND `deleted`=b'0');
INSERT INTO `system_dict_data` (`sort`,`label`,`value`,`dict_type`,`status`,`color_type`,`css_class`,`remark`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT 5,'证书','证书','inherit_qualification_type',0,'info','',NULL,'admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type`='inherit_qualification_type' AND `value`='证书' AND `deleted`=b'0');

-- 菜单：使用自然键查找，不指定固定主键；不写入角色菜单关系
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '非遗管理','',1,15,0,'/inherit','ep:medal',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=0 AND `path`='/inherit' AND `deleted`=b'0');
SET @inherit_root_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=0 AND `path`='/inherit' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);

INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人管理','inherit:inheritor:query',2,1,@inherit_root_id,'inheritor','ep:user','inherit/inheritor/index','InheritInheritor',0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='inheritor' AND `deleted`=b'0');
SET @inherit_inheritor_menu_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='inheritor' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人查询','inherit:inheritor:query',3,1,@inherit_inheritor_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_inheritor_menu_id AND `permission`='inherit:inheritor:query' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人创建','inherit:inheritor:create',3,2,@inherit_inheritor_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_inheritor_menu_id AND `permission`='inherit:inheritor:create' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人更新','inherit:inheritor:update',3,3,@inherit_inheritor_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_inheritor_menu_id AND `permission`='inherit:inheritor:update' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人删除','inherit:inheritor:delete',3,4,@inherit_inheritor_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_inheritor_menu_id AND `permission`='inherit:inheritor:delete' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人审核','inherit:inheritor:audit',3,5,@inherit_inheritor_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_inheritor_menu_id AND `permission`='inherit:inheritor:audit' AND `deleted`=b'0');

INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '荣誉资质管理','inherit:inheritor-qualification:query',2,2,@inherit_root_id,'qualification','ep:medal','inherit/inheritorQualification/index','InheritInheritorQualification',0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='qualification' AND `deleted`=b'0');
SET @inherit_qualification_menu_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='qualification' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '荣誉资质查询','inherit:inheritor-qualification:query',3,1,@inherit_qualification_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_qualification_menu_id AND `permission`='inherit:inheritor-qualification:query' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '荣誉资质创建','inherit:inheritor-qualification:create',3,2,@inherit_qualification_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_qualification_menu_id AND `permission`='inherit:inheritor-qualification:create' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '荣誉资质更新','inherit:inheritor-qualification:update',3,3,@inherit_qualification_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_qualification_menu_id AND `permission`='inherit:inheritor-qualification:update' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '荣誉资质删除','inherit:inheritor-qualification:delete',3,4,@inherit_qualification_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_qualification_menu_id AND `permission`='inherit:inheritor-qualification:delete' AND `deleted`=b'0');

INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '作品管理','inherit:inheritor-work:query',2,3,@inherit_root_id,'work','ep:picture','inherit/inheritorWork/index','InheritInheritorWork',0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='work' AND `deleted`=b'0');
SET @inherit_work_menu_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='work' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '作品查询','inherit:inheritor-work:query',3,1,@inherit_work_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_work_menu_id AND `permission`='inherit:inheritor-work:query' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '作品创建','inherit:inheritor-work:create',3,2,@inherit_work_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_work_menu_id AND `permission`='inherit:inheritor-work:create' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '作品更新','inherit:inheritor-work:update',3,3,@inherit_work_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_work_menu_id AND `permission`='inherit:inheritor-work:update' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '作品删除','inherit:inheritor-work:delete',3,4,@inherit_work_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_work_menu_id AND `permission`='inherit:inheritor-work:delete' AND `deleted`=b'0');

INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '非遗项目关系','inherit:inheritor-project-relation:query',2,4,@inherit_root_id,'project-relation','ep:link','inherit/inheritorProjectRelation/index','InheritInheritorProjectRelation',0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='project-relation' AND `deleted`=b'0');
SET @inherit_relation_menu_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='project-relation' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '关系查询','inherit:inheritor-project-relation:query',3,1,@inherit_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_relation_menu_id AND `permission`='inherit:inheritor-project-relation:query' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '关系创建','inherit:inheritor-project-relation:create',3,2,@inherit_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_relation_menu_id AND `permission`='inherit:inheritor-project-relation:create' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '关系更新','inherit:inheritor-project-relation:update',3,3,@inherit_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_relation_menu_id AND `permission`='inherit:inheritor-project-relation:update' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '关系删除','inherit:inheritor-project-relation:delete',3,4,@inherit_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_relation_menu_id AND `permission`='inherit:inheritor-project-relation:delete' AND `deleted`=b'0');
-- ============================================================
-- 传承人跨模块关系（非物理外键，逻辑关联 product_spu / heritage_service）
-- ============================================================
CREATE TABLE IF NOT EXISTS `inherit_inheritor_product_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `spu_id` bigint NOT NULL COMMENT '商品 SPU 编号（逻辑关联）',
  `is_representative` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否代表商品',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inheritor_spu` (`inheritor_id`,`spu_id`),
  KEY `idx_product_relation_inheritor` (`inheritor_id`),
  KEY `idx_product_relation_spu` (`spu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人与商品关系表';

CREATE TABLE IF NOT EXISTS `inherit_inheritor_service_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `inheritor_id` bigint NOT NULL COMMENT '传承人编号',
  `service_id` bigint NOT NULL COMMENT '非遗服务编号（逻辑关联）',
  `is_representative` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否代表服务',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  `creator` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `tenant_id` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inheritor_service` (`inheritor_id`,`service_id`),
  KEY `idx_service_relation_inheritor` (`inheritor_id`),
  KEY `idx_service_relation_service` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='传承人与非遗服务关系表';

-- 新关系权限菜单：按自然键查找，重复执行不会创建重复菜单，也不写死 role_menu。
SET @inherit_root_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=0 AND `path`='/inherit' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人商品关系','inherit:inheritor-product-relation:query',2,5,@inherit_root_id,'product-relation','ep:goods','inherit/inheritorProductRelation/index','InheritInheritorProductRelation',0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0'
WHERE @inherit_root_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='product-relation' AND `deleted`=b'0');
SET @inherit_product_relation_menu_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='product-relation' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '商品关系查询','inherit:inheritor-product-relation:query',3,1,@inherit_product_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_product_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_product_relation_menu_id AND `permission`='inherit:inheritor-product-relation:query' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '商品关系创建','inherit:inheritor-product-relation:create',3,2,@inherit_product_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_product_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_product_relation_menu_id AND `permission`='inherit:inheritor-product-relation:create' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '商品关系更新','inherit:inheritor-product-relation:update',3,3,@inherit_product_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_product_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_product_relation_menu_id AND `permission`='inherit:inheritor-product-relation:update' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '商品关系删除','inherit:inheritor-product-relation:delete',3,4,@inherit_product_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_product_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_product_relation_menu_id AND `permission`='inherit:inheritor-product-relation:delete' AND `deleted`=b'0');

INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '传承人服务关系','inherit:inheritor-service-relation:query',2,6,@inherit_root_id,'service-relation','ep:service','inherit/inheritorServiceRelation/index','InheritInheritorServiceRelation',0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0'
WHERE @inherit_root_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='service-relation' AND `deleted`=b'0');
SET @inherit_service_relation_menu_id := (SELECT `id` FROM `system_menu` WHERE `parent_id`=@inherit_root_id AND `path`='service-relation' AND `deleted`=b'0' ORDER BY `id` LIMIT 1);
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '服务关系查询','inherit:inheritor-service-relation:query',3,1,@inherit_service_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_service_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_service_relation_menu_id AND `permission`='inherit:inheritor-service-relation:query' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '服务关系创建','inherit:inheritor-service-relation:create',3,2,@inherit_service_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_service_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_service_relation_menu_id AND `permission`='inherit:inheritor-service-relation:create' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '服务关系更新','inherit:inheritor-service-relation:update',3,3,@inherit_service_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_service_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_service_relation_menu_id AND `permission`='inherit:inheritor-service-relation:update' AND `deleted`=b'0');
INSERT INTO `system_menu` (`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
SELECT '服务关系删除','inherit:inheritor-service-relation:delete',3,4,@inherit_service_relation_menu_id,'','',NULL,NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0' WHERE @inherit_service_relation_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `parent_id`=@inherit_service_relation_menu_id AND `permission`='inherit:inheritor-service-relation:delete' AND `deleted`=b'0');
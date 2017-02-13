/*
Navicat MySQL Data Transfer

Source Server         : 192.168.0.79
Source Server Version : 50624
Source Host           : 192.168.0.79:3306
Source Database       : retail-db

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2016-06-08 09:34:15
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for area
-- ----------------------------
DROP TABLE IF EXISTS `area`;
CREATE TABLE `area` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父区域',
  `code` char(20) DEFAULT NULL COMMENT '编码',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=419 DEFAULT CHARSET=utf8 COMMENT='区域信息表';

-- ----------------------------
-- Table structure for branch
-- ----------------------------
DROP TABLE IF EXISTS `branch`;
CREATE TABLE `branch` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户ID，该分店所属商户，tenant.id',
  `branch_type` tinyint(3) unsigned DEFAULT NULL COMMENT '0总部1配送中心2分店',
  `code` varchar(20) NOT NULL COMMENT '代码',
  `name` varchar(30) NOT NULL COMMENT '名称',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `contacts` varchar(20) DEFAULT NULL COMMENT '联系人',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `geolocation` varchar(255) DEFAULT NULL,
  `area_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `status` tinyint(3) unsigned DEFAULT '1' COMMENT '状态0 停用1启用',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `type` tinyint(3) unsigned DEFAULT '1' COMMENT '1实体店2网店3微店',
  `is_tinyhall` tinyint(1) DEFAULT '0' COMMENT '是否微餐厅',
  `is_takeout` tinyint(1) DEFAULT '0' COMMENT '是否外卖0否1是',
  `takeout_status` tinyint(3) unsigned DEFAULT '1' COMMENT '外卖状态：1-正常，2-暂停',
  `amount` decimal(11,3) DEFAULT '0.000' COMMENT '起送金额',
  `takeout_range` int(11) DEFAULT '0' COMMENT '起送范围',
  `takeout_amount` decimal(11,3) DEFAULT '0.000' COMMENT '送餐费',
  `takeout_time` varchar(12) DEFAULT NULL COMMENT '配送时间段 08:00-11:00 (24小时制）',
  `start_takeout_time` varchar(6) DEFAULT NULL COMMENT '配送开始时间',
  `end_takeout_time` varchar(6) DEFAULT NULL COMMENT '配送结束时间',
  `shipping_price_type` tinyint(3) DEFAULT NULL COMMENT '1=配送价1, 2=配送价2 ',
  `is_buffet` tinyint(1) DEFAULT '0',
  `is_invite` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8 COMMENT='门店信息（组织结构表，含总部、配送中心、分店）';

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL COMMENT '编码',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `state` tinyint(3) DEFAULT '0' COMMENT '状态：0正常1停用',
  `mnemonic` varchar(50) DEFAULT NULL COMMENT '助记码',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户ID，该分店所属商户，tenant.id',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='品牌';

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品分类',
  `tenant_id` bigint(20) DEFAULT NULL,
  `cat_code` char(20) NOT NULL COMMENT '商品分类码\n',
  `cat_name` varchar(20) NOT NULL COMMENT '商品分类名称',
  `mnemonics` varchar(20) DEFAULT NULL COMMENT '助记码',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '上级分类ID\n外键',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '0-正常\n1-删除\n',
  `category_type` tinyint(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1160 DEFAULT CHARSET=utf8 COMMENT='商品分类\r\n';

-- ----------------------------
-- Table structure for check_order
-- ----------------------------
DROP TABLE IF EXISTS `check_order`;
CREATE TABLE `check_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `code` varchar(20) DEFAULT NULL,
  `storage_id` bigint(20) DEFAULT NULL COMMENT '仓库id',
  `make_by` bigint(20) NOT NULL COMMENT '制单人',
  `make_name` varchar(20) DEFAULT NULL COMMENT '制单人姓名',
  `make_at` datetime NOT NULL COMMENT '制单时间',
  `check_quantity` decimal(17,3) DEFAULT NULL,
  `check_amount` decimal(25,3) DEFAULT NULL,
  `really_quantity` decimal(14,3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='盘点单';

-- ----------------------------
-- Table structure for check_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `check_order_detail`;
CREATE TABLE `check_order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(20) DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `purchase_price` decimal(11,3) DEFAULT '0.000' COMMENT '进价',
  `quantity` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '库存数量',
  `check_order_id` bigint(20) DEFAULT NULL COMMENT '入库单Id\n',
  `goods_id` bigint(20) NOT NULL COMMENT '商品Id',
  `really_quantity` decimal(11,3) DEFAULT '0.000' COMMENT '实际数量',
  `check_quantity` decimal(14,3) DEFAULT NULL,
  `check_amount` decimal(22,3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8 COMMENT='盘点单明细\n';

-- ----------------------------
-- Table structure for currency
-- ----------------------------
DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `currency_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '货币ID\n\n0-默认货币,人民币',
  `currency_code` char(20) NOT NULL COMMENT '货币代码',
  `currency_name` varchar(20) NOT NULL COMMENT '货币名称',
  `currency_rate` decimal(8,4) NOT NULL COMMENT '货币兑换率\n',
  `memo` varchar(255) DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='货币表\n';

-- ----------------------------
-- Table structure for district
-- ----------------------------
DROP TABLE IF EXISTS `district`;
CREATE TABLE `district` (
  `id` bigint(19) unsigned NOT NULL AUTO_INCREMENT COMMENT '行政区域ID(编码)',
  `pid` bigint(20) DEFAULT NULL COMMENT '行政区域父ID',
  `name` varchar(20) DEFAULT NULL COMMENT '行政区域ID',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=659005 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID，sys_user.id（只有设置了用户ID的员工可以登录系统）',
  `login_name` varchar(30) DEFAULT NULL COMMENT '登录帐号，sys_user.login_name（冗余字段）',
  `code` varchar(20) DEFAULT NULL COMMENT '工号',
  `name` varchar(50) DEFAULT NULL,
  `password_for_local` varchar(50) DEFAULT NULL COMMENT '本地登录密码\n仅用于POS本地登录\n',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `email` varchar(45) DEFAULT NULL COMMENT '邮箱',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `state` bigint(1) DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `sex` tinyint(3) unsigned DEFAULT NULL COMMENT '1男2女',
  `head_portrait_big` varchar(45) DEFAULT NULL COMMENT '头像路径,大图',
  `head_portrait_small` varchar(45) DEFAULT NULL COMMENT '小图',
  `discount_rate` int(11) DEFAULT '0' COMMENT '折扣率',
  `discount_amount` int(11) DEFAULT NULL,
  `card_id` bigint(20) DEFAULT NULL COMMENT '卡号',
  `card_code` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 COMMENT='员工信息';

-- ----------------------------
-- Table structure for employee_pos_r
-- ----------------------------
DROP TABLE IF EXISTS `employee_pos_r`;
CREATE TABLE `employee_pos_r` (
  `employee_id` bigint(20) DEFAULT NULL COMMENT '员工id',
  `pos_authority_key` varchar(10) DEFAULT NULL COMMENT '权限编码',
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户pos权限';

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) NOT NULL COMMENT '商品分类\n外键\n',
  `goods_name` varchar(50) NOT NULL COMMENT '商品名称\n',
  `bar_code` char(13) DEFAULT NULL COMMENT '条码',
  `spec` varchar(50) DEFAULT NULL COMMENT '规格',
  `purchasing_price` decimal(11,3) DEFAULT '0.000' COMMENT '菜品进价',
  `sale_price` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '零售价',
  `goods_unit_id` bigint(20) DEFAULT NULL COMMENT '单位',
  `vip_price1` decimal(11,3) DEFAULT '0.000' COMMENT '会员价1',
  `vip_price2` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '会员价2',
  `goods_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '商品状态\n0-正常\n1-停售',
  `supplier_id` bigint(20) DEFAULT NULL COMMENT '供应商id',
  `brand_id` bigint(20) DEFAULT NULL COMMENT '品牌id',
  `short_name` varchar(20) DEFAULT NULL COMMENT '商品简称',
  `mnemonic` varchar(50) DEFAULT NULL COMMENT '助记码',
  `photo` varchar(200) DEFAULT NULL COMMENT '图片路径',
  `is_dsc` tinyint(1) DEFAULT '0' COMMENT '是否有折扣0否1是',
  `is_store` tinyint(1) DEFAULT '0' COMMENT '是否管理库存0否1是',
  `goods_type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1普通商品2大包装商品3原料',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '最后更新人',
  `last_update_at` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户id',
  `is_weigh` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否称重',
  `price_type` tinyint(3) DEFAULT NULL COMMENT '已不使用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10459 DEFAULT CHARSET=utf8 COMMENT='商品';

-- ----------------------------
-- Table structure for goods_bar
-- ----------------------------
DROP TABLE IF EXISTS `goods_bar`;
CREATE TABLE `goods_bar` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` bigint(20) unsigned NOT NULL COMMENT '包装内商品的id',
  `bar_code` varchar(13) DEFAULT NULL COMMENT '条码',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户ID，该分店所属商户，tenant.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='商品条码';

-- ----------------------------
-- Table structure for goods_library
-- ----------------------------
DROP TABLE IF EXISTS `goods_library`;
CREATE TABLE `goods_library` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `goods_name` varchar(50) NOT NULL COMMENT '商品名称\n',
  `spec` varchar(50) DEFAULT NULL COMMENT '规格',
  `bar_code` varchar(13) DEFAULT NULL COMMENT '条码',
  `photo` varchar(200) DEFAULT NULL COMMENT '图片路径',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '最后更新人',
  `last_update_at` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品标准库';

-- ----------------------------
-- Table structure for goods_unit
-- ----------------------------
DROP TABLE IF EXISTS `goods_unit`;
CREATE TABLE `goods_unit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `unit_code` char(3) NOT NULL COMMENT '编码\n',
  `unit_name` varchar(10) DEFAULT NULL COMMENT '名称',
  `mnemonic` varchar(50) DEFAULT NULL COMMENT '助记码',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2019 DEFAULT CHARSET=utf8 COMMENT='商品单位';

-- ----------------------------
-- Table structure for jz_sale_brand_day
-- ----------------------------
DROP TABLE IF EXISTS `jz_sale_brand_day`;
CREATE TABLE `jz_sale_brand_day` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `car_date` varchar(10) NOT NULL COMMENT '结转日期（YYYY-mm-dd）',
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  `brand_id` bigint(20) NOT NULL COMMENT '品牌id',
  `sale_num` bigint(20) NOT NULL COMMENT '销售数量（销售数量）',
  `sale_discount_num` bigint(20) NOT NULL COMMENT '销售优惠单数',
  `sale_trunc_num` bigint(20) DEFAULT NULL COMMENT '销售抹零单数',
  `sale_give_num` bigint(20) DEFAULT NULL COMMENT '销售赠送金额',
  `return_num` bigint(20) NOT NULL COMMENT '退货数量',
  `return_discount_num` bigint(20) DEFAULT NULL COMMENT '退货优惠单数',
  `return_trunc_num` bigint(20) DEFAULT NULL COMMENT '退货抹零单数',
  `return_give_num` bigint(20) DEFAULT NULL COMMENT '退货赠送金额',
  `sale_amount` decimal(13,3) NOT NULL COMMENT '销售金额',
  `sale_discount_amount` decimal(13,3) NOT NULL COMMENT '销售优惠金额',
  `sale_trunc_amount` decimal(13,3) DEFAULT NULL COMMENT '销售抹零金额',
  `sale_give_amount` decimal(13,3) DEFAULT NULL COMMENT '销售赠送金额',
  `return_amount` decimal(13,3) NOT NULL COMMENT '退货金额',
  `return_discount_amount` decimal(13,3) DEFAULT NULL COMMENT '退货优惠金额',
  `return_trunc_amount` decimal(13,3) DEFAULT NULL COMMENT '退货抹零金额',
  `return_give_amount` decimal(13,3) DEFAULT NULL COMMENT '退货赠送金额',
  `sale_goods_cost` decimal(13,3) NOT NULL COMMENT '销售成本',
  `amount` decimal(13,3) NOT NULL COMMENT '总额',
  `return_goods_cost` decimal(13,3) NOT NULL COMMENT '退货成本',
  `create_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `search_user` (`car_date`,`tenant_id`,`branch_id`,`brand_id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8 COMMENT='销售日结转品牌';

-- ----------------------------
-- Table structure for jz_sale_cat_day
-- ----------------------------
DROP TABLE IF EXISTS `jz_sale_cat_day`;
CREATE TABLE `jz_sale_cat_day` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `car_date` varchar(10) NOT NULL COMMENT '结转日期（YYYY-mm-dd）',
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  `cat_id` bigint(20) NOT NULL COMMENT '分类id',
  `sale_num` bigint(20) NOT NULL COMMENT '销售单数（销售数量）',
  `sale_discount_num` bigint(20) NOT NULL COMMENT '销售优惠单数',
  `sale_trunc_num` bigint(20) DEFAULT NULL COMMENT '销售抹零单数',
  `sale_give_num` bigint(20) DEFAULT NULL COMMENT '销售赠送金额',
  `return_num` bigint(20) NOT NULL COMMENT '退货单数（退货数量）',
  `return_discount_num` bigint(20) DEFAULT NULL COMMENT '退货优惠单数',
  `return_trunc_num` bigint(20) DEFAULT NULL COMMENT '退货抹零单数',
  `return_give_num` bigint(20) DEFAULT NULL COMMENT '退货赠送金额',
  `sale_amount` decimal(13,3) NOT NULL COMMENT '销售金额',
  `sale_discount_amount` decimal(13,3) NOT NULL COMMENT '销售优惠金额',
  `sale_trunc_amount` decimal(13,3) DEFAULT NULL COMMENT '销售抹零金额',
  `sale_give_amount` decimal(13,3) DEFAULT NULL COMMENT '销售赠送金额',
  `return_amount` decimal(13,3) NOT NULL COMMENT '退货金额',
  `return_discount_amount` decimal(13,3) DEFAULT NULL COMMENT '退货优惠金额',
  `return_trunc_amount` decimal(13,3) DEFAULT NULL COMMENT '退货抹零金额',
  `return_give_amount` decimal(13,3) DEFAULT NULL COMMENT '退货赠送金额',
  `sale_goods_cost` decimal(13,3) NOT NULL COMMENT '销售成本',
  `amount` decimal(13,3) NOT NULL COMMENT '总额',
  `return_goods_cost` decimal(13,3) NOT NULL COMMENT '退货成本',
  `create_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `search_user` (`car_date`,`tenant_id`,`branch_id`,`cat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='销售日结转分类';

-- ----------------------------
-- Table structure for jz_sale_day
-- ----------------------------
DROP TABLE IF EXISTS `jz_sale_day`;
CREATE TABLE `jz_sale_day` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `car_date` varchar(10) NOT NULL COMMENT '结转日期（YYYY-mm-dd）',
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  `sale_num` bigint(20) NOT NULL COMMENT '销售单数（销售数量）',
  `sale_discount_num` bigint(20) NOT NULL COMMENT '销售优惠单数',
  `sale_trunc_num` bigint(20) NOT NULL COMMENT '销售抹零单数',
  `sale_give_num` bigint(20) NOT NULL COMMENT '销售赠送金额',
  `return_num` bigint(20) NOT NULL COMMENT '退货单数（退货数量）',
  `return_discount_num` bigint(20) NOT NULL COMMENT '退货优惠单数',
  `return_trunc_num` bigint(20) NOT NULL COMMENT '退货抹零单数',
  `return_give_num` bigint(20) NOT NULL COMMENT '退货赠送金额',
  `sale_amount` decimal(13,3) NOT NULL COMMENT '销售金额',
  `sale_discount_amount` decimal(13,3) NOT NULL COMMENT '销售优惠金额',
  `sale_trunc_amount` decimal(13,3) NOT NULL COMMENT '销售抹零金额',
  `sale_give_amount` decimal(13,3) NOT NULL COMMENT '销售赠送金额',
  `return_amount` decimal(13,3) NOT NULL COMMENT '退货金额',
  `return_discount_amount` decimal(13,3) NOT NULL COMMENT '退货优惠金额',
  `return_trunc_amount` decimal(13,3) NOT NULL COMMENT '退货抹零金额',
  `return_give_amount` decimal(13,3) NOT NULL COMMENT '退货赠送金额',
  `sale_goods_cost` decimal(13,3) NOT NULL COMMENT '销售成本',
  `amount` decimal(13,3) NOT NULL COMMENT '总额',
  `return_goods_cost` decimal(13,3) NOT NULL COMMENT '退货成本',
  `create_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `search_user` (`car_date`,`tenant_id`,`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COMMENT='销售日结转';

-- ----------------------------
-- Table structure for jz_sale_goods_day
-- ----------------------------
DROP TABLE IF EXISTS `jz_sale_goods_day`;
CREATE TABLE `jz_sale_goods_day` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `car_date` varchar(10) NOT NULL COMMENT '结转日期（YYYY-mm-dd）',
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  `goods_id` bigint(20) NOT NULL COMMENT '商品id',
  `sale_num` bigint(20) NOT NULL COMMENT '销售单数（销售数量）',
  `sale_discount_num` bigint(20) NOT NULL COMMENT '销售优惠单数',
  `sale_trunc_num` bigint(20) DEFAULT NULL COMMENT '销售抹零单数',
  `sale_give_num` bigint(20) DEFAULT NULL COMMENT '销售赠送金额',
  `return_num` bigint(20) NOT NULL COMMENT '退货单数（退货数量）',
  `return_discount_num` bigint(20) DEFAULT NULL COMMENT '退货优惠单数',
  `return_trunc_num` bigint(20) DEFAULT NULL COMMENT '退货抹零单数',
  `return_give_num` bigint(20) DEFAULT NULL COMMENT '退货赠送金额',
  `sale_amount` decimal(13,3) NOT NULL COMMENT '销售金额',
  `sale_discount_amount` decimal(13,3) NOT NULL COMMENT '销售优惠金额',
  `sale_trunc_amount` decimal(13,3) DEFAULT NULL COMMENT '销售抹零金额',
  `sale_give_amount` decimal(13,3) DEFAULT NULL COMMENT '销售赠送金额',
  `return_amount` decimal(13,3) NOT NULL COMMENT '退货金额',
  `return_discount_amount` decimal(13,3) DEFAULT NULL COMMENT '退货优惠金额',
  `return_trunc_amount` decimal(13,3) DEFAULT NULL COMMENT '退货抹零金额',
  `return_give_amount` decimal(13,3) DEFAULT NULL COMMENT '退货赠送金额',
  `sale_goods_cost` decimal(13,3) NOT NULL COMMENT '销售成本',
  `amount` decimal(13,3) NOT NULL COMMENT '总额',
  `return_goods_cost` decimal(13,3) NOT NULL COMMENT '退货成本',
  `create_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `search_user` (`car_date`,`tenant_id`,`branch_id`,`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=utf8 COMMENT='销售日结转商品';

-- ----------------------------
-- Table structure for jz_sale_month
-- ----------------------------
DROP TABLE IF EXISTS `jz_sale_month`;
CREATE TABLE `jz_sale_month` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `car_date` varchar(7) NOT NULL COMMENT '结转日期（YYYY-mm-dd）',
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL,
  `sale_num` bigint(20) NOT NULL COMMENT '销售单数（销售数量）',
  `sale_discount_num` bigint(20) NOT NULL COMMENT '销售优惠单数',
  `sale_trunc_num` bigint(20) NOT NULL COMMENT '销售抹零单数',
  `sale_give_num` bigint(20) NOT NULL COMMENT '销售赠送金额',
  `return_num` bigint(20) NOT NULL COMMENT '退货单数（退货数量）',
  `return_discount_num` bigint(20) NOT NULL COMMENT '退货优惠单数',
  `return_trunc_num` bigint(20) NOT NULL COMMENT '退货抹零单数',
  `return_give_num` bigint(20) NOT NULL COMMENT '退货赠送金额',
  `sale_amount` decimal(13,3) NOT NULL COMMENT '销售金额',
  `sale_discount_amount` decimal(13,3) NOT NULL COMMENT '销售优惠金额',
  `sale_trunc_amount` decimal(13,3) NOT NULL COMMENT '销售抹零金额',
  `sale_give_amount` decimal(13,3) NOT NULL COMMENT '销售赠送金额',
  `return_amount` decimal(13,3) NOT NULL COMMENT '退货金额',
  `return_discount_amount` decimal(13,3) NOT NULL COMMENT '退货优惠金额',
  `return_trunc_amount` decimal(13,3) NOT NULL COMMENT '退货抹零金额',
  `return_give_amount` decimal(13,3) NOT NULL COMMENT '退货赠送金额',
  `sale_goods_cost` decimal(13,3) NOT NULL COMMENT '销售成本',
  `amount` decimal(13,3) NOT NULL COMMENT '总额',
  `return_goods_cost` decimal(13,3) NOT NULL COMMENT '退货成本',
  `create_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `search_user` (`car_date`,`tenant_id`,`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COMMENT='销售日结转';

-- ----------------------------
-- Table structure for pack_goods
-- ----------------------------
DROP TABLE IF EXISTS `pack_goods`;
CREATE TABLE `pack_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pack_id` bigint(20) DEFAULT NULL COMMENT '大包装id，对应商品表类型为大包装的商品',
  `goods_id` bigint(20) unsigned NOT NULL COMMENT '包装内商品的id',
  `quantity` int(11) DEFAULT '1' COMMENT '包装内商品数量',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户ID，该分店所属商户，tenant.id',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='包装商品';

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '前台支付方式',
  `payment_code` char(20) NOT NULL COMMENT '''支付代码''\nCSH 现金\nCRD 银行卡\nZFB 支付宝\nWZF 微信支付\nJFD 积分抵现\nCZF 储值支付\n\n',
  `payment_name` varchar(20) NOT NULL COMMENT '''支付名称''',
  `payment_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0-正常\n1-停用',
  `currency_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '货币ID\n\n0-默认货币,人民币',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '0-正常\n1-删除\n',
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '所属门店，默认为0，代表总部',
  `is_score` tinyint(3) DEFAULT NULL COMMENT '0否1是',
  `is_change` tinyint(3) DEFAULT NULL COMMENT '0否1是',
  `is_memo` tinyint(3) DEFAULT NULL COMMENT '0否1是',
  `is_sale` tinyint(3) DEFAULT NULL COMMENT '0否1是',
  `fix_value` decimal(11,3) DEFAULT NULL COMMENT '固定面值',
  `fix_num` int(11) DEFAULT NULL COMMENT '单笔限次',
  `payment_type` tinyint(3) DEFAULT NULL COMMENT '支付类型',
  `is_voucher` tinyint(3) DEFAULT '0' COMMENT '是否代金券：0否1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=269 DEFAULT CHARSET=utf8 COMMENT='支付方式';

-- ----------------------------
-- Table structure for pos
-- ----------------------------
DROP TABLE IF EXISTS `pos`;
CREATE TABLE `pos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '所属门店，默认为0，代表总部',
  `device_code` varchar(45) DEFAULT NULL COMMENT '设备码',
  `pos_code` varchar(3) DEFAULT NULL COMMENT 'pos机编码',
  `branch_code` varchar(20) DEFAULT NULL COMMENT '门店编码',
  `password` varchar(32) DEFAULT NULL COMMENT 'pos密码',
  `status` tinyint(3) unsigned DEFAULT NULL COMMENT '0停用\n1启用',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `branch_name` varchar(30) DEFAULT NULL COMMENT '冗余字段：门店名称',
  `access_token` varchar(32) DEFAULT NULL COMMENT '同步使用',
  `tenant_code` char(8) DEFAULT NULL,
  `app_name` varchar(50) DEFAULT NULL COMMENT 'app名称',
  `app_version` varchar(50) DEFAULT NULL COMMENT 'app版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COMMENT='pos信息';

-- ----------------------------
-- Table structure for pos_authority
-- ----------------------------
DROP TABLE IF EXISTS `pos_authority`;
CREATE TABLE `pos_authority` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL COMMENT '权限编码 1001',
  `parentcode` varchar(10) DEFAULT NULL,
  `name` varchar(20) NOT NULL COMMENT '权限名称',
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '1功能权限2',
  `branch_id` bigint(20) DEFAULT NULL,
  `order_key` int(11) DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pos权限表';

-- ----------------------------
-- Table structure for pos_config
-- ----------------------------
DROP TABLE IF EXISTS `pos_config`;
CREATE TABLE `pos_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint(20) NOT NULL,
  `pos_id` bigint(20) NOT NULL,
  `package_name` varchar(50) NOT NULL COMMENT 'POS配置参数\n配置参数可以分组，每组作为一个参数包，具有不同的用途\n',
  `pos_confg_version` varchar(20) NOT NULL COMMENT '版本\n\n程序升级后，如果设置参数的结构发生变化，需要同时改变设置参数的版本标识，原则上与第一个使用的程序版本一致\n',
  `config` text NOT NULL COMMENT '各设置参数以json格式文本保存在字段中，完成支持json语法\n\n空设置\n{}\n\n基本结构\n{\n    "key1": {\n        “key1-1": ''value'', \n        "key1-2": 3000 ,\n        desc:''说明1''\n    },\n        "key2-1": {\n        "ip": "localhost",\n        "port": 8000\n        desc:''说明2''\n  },\n}\n',
  `ls_dirty` tinyint(1) NOT NULL DEFAULT '0' COMMENT '数据在本地被修改0否1是',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pos参数设置';

-- ----------------------------
-- Table structure for s_config
-- ----------------------------
DROP TABLE IF EXISTS `s_config`;
CREATE TABLE `s_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(45) DEFAULT NULL COMMENT '参数名',
  `value` varchar(45) DEFAULT NULL COMMENT '参数值',
  `is_deleted` tinyint(1) NOT NULL COMMENT '删除标记',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_at` datetime DEFAULT NULL COMMENT '创建时间',
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '修改人',
  `last_update_at` datetime DEFAULT NULL COMMENT '修改时间',
  `type` varchar(10) NOT NULL COMMENT '类型 0:条目限制 1:图片限制',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='系统配置参数表';

-- ----------------------------
-- Table structure for s_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `s_dict_item`;
CREATE TABLE `s_dict_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dict_type_id` bigint(20) NOT NULL COMMENT '字典类型',
  `key` int(11) NOT NULL COMMENT '字典Key',
  `value` varchar(20) NOT NULL COMMENT '字典Value',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `is_internal` tinyint(1) NOT NULL COMMENT '系统内部字典项，用户不可见',
  `is_readonly` tinyint(1) NOT NULL COMMENT '只读，不能修改',
  `order_key` int(11) NOT NULL DEFAULT '0' COMMENT '排序码',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_at` datetime DEFAULT NULL COMMENT '创建时间',
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '修改人',
  `last_update_at` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='字典值';

-- ----------------------------
-- Table structure for s_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `s_dict_type`;
CREATE TABLE `s_dict_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dict_type_name` varchar(50) NOT NULL COMMENT '字典类型',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `is_internal` tinyint(1) NOT NULL COMMENT '系统内部字典，用户不能修改',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_at` datetime DEFAULT NULL COMMENT '创建时间',
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '修改人',
  `last_update_at` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint(1) NOT NULL COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='字典类型';

-- ----------------------------
-- Table structure for s_error_log
-- ----------------------------
DROP TABLE IF EXISTS `s_error_log`;
CREATE TABLE `s_error_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `controller_name` varchar(50) DEFAULT NULL COMMENT '资源名称，URL中的Controller部分',
  `action_name` varchar(50) DEFAULT NULL COMMENT '操作名称，URL中的Action部分',
  `error_code` varchar(20) DEFAULT NULL COMMENT '错误代码',
  `error_message` varchar(100) DEFAULT NULL COMMENT '错误消息',
  `exception_message` text NOT NULL COMMENT '异常信息,Exception.message',
  `occurred_at` datetime NOT NULL COMMENT '发生时间',
  `op_log_id` bigint(20) DEFAULT NULL COMMENT '操作日志ID，s_op_log.id',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='错误日志表';

-- ----------------------------
-- Table structure for s_job_detail
-- ----------------------------
DROP TABLE IF EXISTS `s_job_detail`;
CREATE TABLE `s_job_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `job_name` varchar(164) NOT NULL COMMENT '作业名称',
  `group_name` varchar(164) NOT NULL,
  `cron` varchar(164) NOT NULL,
  `describe` varchar(164) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='作业任务';

-- ----------------------------
-- Table structure for s_op_log
-- ----------------------------
DROP TABLE IF EXISTS `s_op_log`;
CREATE TABLE `s_op_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `controller_name` varchar(50) NOT NULL COMMENT '资源名称，URL中的Controller部分',
  `action_name` varchar(50) NOT NULL COMMENT '操作名称，URL中的action部分',
  `operate_depth` int(11) DEFAULT NULL COMMENT '操作深度，字典，离用户最近的资源深度为1，依次2、3、4...，持久化数据一般位于最深层（暂不使用此子段）',
  `old_content` text COMMENT '操作前内容（暂不使用此字段）',
  `new_content` text NOT NULL COMMENT '操作后内容（记录params）',
  `is_authorized` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否授权，1是（默认），0否',
  `session_id` varchar(32) NOT NULL COMMENT 'SESSIONID',
  `is_success` tinyint(1) NOT NULL DEFAULT '1' COMMENT '操作结果，1成功（默认），0失败',
  `error_log_id` bigint(20) DEFAULT NULL COMMENT '错误日志ID，s_error_log.id',
  `user_id` bigint(20) DEFAULT NULL COMMENT '操作人，sys_user.id',
  `operate_at` datetime NOT NULL COMMENT '操作时间，发生日期时间',
  `host_ip` bigint(20) NOT NULL COMMENT '操作主机IP，IPV4/IPV6',
  `host_agent` varchar(100) NOT NULL COMMENT '操作主机系统，操作系统、浏览器等信息',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注，其他的需要说明的信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='操作日志表';

-- ----------------------------
-- Table structure for sale
-- ----------------------------
DROP TABLE IF EXISTS `sale`;
CREATE TABLE `sale` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) DEFAULT NULL COMMENT 'POS数据主键ID',
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '所属门店，默认为0，代表总部',
  `sale_code` char(30) NOT NULL COMMENT '销售账单号\n',
  `pos_id` bigint(20) DEFAULT '0',
  `sale_mode` tinyint(3) unsigned NOT NULL COMMENT '销售方式\n0-堂食\n1-外卖\n2-自提\n',
  `pos_code` char(20) DEFAULT '0' COMMENT 'POS号(冗余字段)\n',
  `table_id` bigint(20) DEFAULT '0' COMMENT '桌号\n0-无桌号销售\n',
  `total_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '销售合计\n（所有单品计价的合计 商品原价*数量）',
  `discount_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '折扣额\n',
  `give_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '赠送额\n',
  `long_amount` decimal(11,3) DEFAULT NULL COMMENT '长款金额',
  `trunc_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '抹零额',
  `is_free_of_charge` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否免单',
  `service_fee` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '所有服务费的合计，属于加收项目\n包括座位费、加工费等\n单项加工费另表保存',
  `received_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '实收金额=total_amount-discount_amount-give_amount-trunc_amount=sum(sale_payment.pay_total)-long_amount',
  `order_attendant` varchar(20) DEFAULT NULL COMMENT '订台人',
  `service_attendant` varchar(20) DEFAULT NULL COMMENT '值台人',
  `table_open_at` datetime DEFAULT NULL COMMENT '开台时间',
  `open_attendant` varchar(20) DEFAULT NULL COMMENT '开台人',
  `cashier` bigint(20) DEFAULT NULL COMMENT '收银员',
  `checkout_at` datetime DEFAULT NULL COMMENT '结账时间',
  `promotion_id` bigint(20) DEFAULT '0' COMMENT '促销活动',
  `is_refund` tinyint(1) DEFAULT NULL COMMENT '是否退货 0：销售 1 ：退货',
  `order_status` tinyint(3) unsigned DEFAULT '0' COMMENT '订单状态\n0-录入\n1-已提交\n2-（卖方）已确认\n3-（卖方）已拒绝\n4-已支付\n5-已取消\n',
  `delivery_status` tinyint(3) unsigned DEFAULT '0' COMMENT '0-未发货\n1-已发货\n2-已收货\n',
  `sale_order_code` char(20) DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `sale_type` tinyint(3) DEFAULT '0' COMMENT '订单类型：0-pos订单，1-o2o订单',
  PRIMARY KEY (`id`),
  KEY `idx_sale_tenant_id_branch_id_sale_code` (`tenant_id`,`branch_id`,`sale_code`),
  KEY `idx_sale_tenant_id_branch_id_create_at` (`tenant_id`,`branch_id`,`create_at`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COMMENT='销售账单流水';

-- ----------------------------
-- Table structure for sale_detail
-- ----------------------------
DROP TABLE IF EXISTS `sale_detail`;
CREATE TABLE `sale_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sale_code` char(30) NOT NULL COMMENT '销售账单号\n',
  `package_id` bigint(20) DEFAULT '0' COMMENT '套餐',
  `goods_id` bigint(20) NOT NULL COMMENT '商品',
  `is_package` tinyint(1) DEFAULT NULL COMMENT '是否套餐或套餐内商品',
  `promotion_id` bigint(20) DEFAULT NULL COMMENT '促销活动',
  `quantity` decimal(11,3) DEFAULT '0.000' COMMENT '数量',
  `sale_price` decimal(11,3) DEFAULT '0.000' COMMENT '售价\n\n',
  `sale_price_actual` decimal(11,3) DEFAULT '0.000' COMMENT '实际售价',
  `total_amount` decimal(11,3) DEFAULT '0.000' COMMENT '应收合计\n\n',
  `is_free_of_charge` tinyint(1) DEFAULT '0' COMMENT '是否免单或赠送',
  `received_amount` decimal(11,3) DEFAULT '0.000' COMMENT '实收合计',
  `is_refund` tinyint(1) DEFAULT NULL COMMENT '是否冲销',
  `is_printed` tinyint(1) DEFAULT '0',
  `is_produced` tinyint(1) DEFAULT '0',
  `is_served` tinyint(1) DEFAULT '0',
  `parent_packag_id` bigint(20) DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '所属门店，默认为0，代表总部',
  `discount_amount` decimal(11,3) DEFAULT '0.000' COMMENT '折扣金额',
  `discount_amount1` decimal(11,3) DEFAULT '0.000',
  PRIMARY KEY (`id`),
  KEY `idx_sale_detail_tenant_id_branch_id_create_at` (`tenant_id`,`branch_id`,`create_at`),
  KEY `idx_sale_detail_tenant_id_branch_id_sale_code` (`tenant_id`,`branch_id`,`sale_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1414 DEFAULT CHARSET=utf8 COMMENT='销售明细流水\r\n';

-- ----------------------------
-- Table structure for sale_payment
-- ----------------------------
DROP TABLE IF EXISTS `sale_payment`;
CREATE TABLE `sale_payment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sale_payment_code` char(30) NOT NULL COMMENT '付款单号\n',
  `sale_code` char(30) NOT NULL COMMENT '销售流水号\n',
  `payment_id` bigint(20) NOT NULL COMMENT '支付方式\n外键\n',
  `payment_code` char(20) NOT NULL COMMENT '支付代码',
  `pay_total` decimal(11,3) NOT NULL COMMENT '应付金额',
  `amount` decimal(11,3) NOT NULL COMMENT '实付金额',
  `pos_id` bigint(20) DEFAULT NULL,
  `change_amount` decimal(11,3) DEFAULT NULL COMMENT '找零金额\n',
  `memo` varchar(255) DEFAULT NULL,
  `cashier` bigint(20) DEFAULT NULL COMMENT '收银员\n',
  `payment_at` datetime DEFAULT NULL COMMENT '付款时间\n',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL,
  `is_refund` tinyint(1) DEFAULT NULL COMMENT '是否退货 0：销售 1 ：退货',
  `branch_id` bigint(20) DEFAULT NULL COMMENT '所属门店，默认为0，代表总部',
  PRIMARY KEY (`id`),
  KEY `idx_sale_payment_tenant_id_branch_id_create_at` (`tenant_id`,`branch_id`,`create_at`),
  KEY `idx_sale_payment_tenant_id_branch_id_sale_code` (`tenant_id`,`branch_id`,`sale_code`)
) ENGINE=InnoDB AUTO_INCREMENT=834 DEFAULT CHARSET=utf8 COMMENT='支付单流水';

-- ----------------------------
-- Table structure for sequence
-- ----------------------------
DROP TABLE IF EXISTS `sequence`;
CREATE TABLE `sequence` (
  `name` varchar(50) NOT NULL,
  `current_value` int(11) unsigned NOT NULL,
  `increment` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sequence2
-- ----------------------------
DROP TABLE IF EXISTS `sequence2`;
CREATE TABLE `sequence2` (
  `name` varchar(50) NOT NULL,
  `current_value` int(11) unsigned NOT NULL,
  `seq_date` date NOT NULL,
  `increment` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shift
-- ----------------------------
DROP TABLE IF EXISTS `shift`;
CREATE TABLE `shift` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `shift_code` char(4) DEFAULT NULL COMMENT '班次编码',
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL COMMENT '结束时间',
  `branch_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='班次设置';

-- ----------------------------
-- Table structure for shipping_plan
-- ----------------------------
DROP TABLE IF EXISTS `shipping_plan`;
CREATE TABLE `shipping_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `shipping_at` datetime DEFAULT NULL COMMENT '配送时间，默认当前时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配送计划';

-- ----------------------------
-- Table structure for shipping_plan_detail
-- ----------------------------
DROP TABLE IF EXISTS `shipping_plan_detail`;
CREATE TABLE `shipping_plan_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `shipping_plan_id` bigint(20) DEFAULT NULL COMMENT '配送计划Id',
  `goods_id` bigint(20) DEFAULT NULL COMMENT '商品Id',
  `shipping_price` decimal(11,3) DEFAULT '0.000' COMMENT '配送价',
  `cycle` int(11) DEFAULT '0' COMMENT '配送周期',
  `shipping_num` decimal(11,3) DEFAULT '0.000' COMMENT '配送数量',
  `shipping_amount` decimal(11,3) DEFAULT '0.000' COMMENT '配送金额',
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配送计划明细';

-- ----------------------------
-- Table structure for storage
-- ----------------------------
DROP TABLE IF EXISTS `storage`;
CREATE TABLE `storage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `storage_name` varchar(30) DEFAULT NULL,
  `storage_address` varchar(200) DEFAULT NULL COMMENT '仓库地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仓库表';

-- ----------------------------
-- Table structure for store
-- ----------------------------
DROP TABLE IF EXISTS `store`;
CREATE TABLE `store` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `storage_id` bigint(20) DEFAULT NULL COMMENT '仓库Id',
  `goods_id` bigint(20) NOT NULL COMMENT '商品Id',
  `quantity` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '库存数量',
  `avg_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '成本',
  `store_at` datetime DEFAULT NULL COMMENT '出入库时间',
  `store_amount` decimal(19,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ten_bra_goods` (`tenant_id`,`branch_id`,`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8 COMMENT='库存表';

-- ----------------------------
-- Table structure for store_account
-- ----------------------------
DROP TABLE IF EXISTS `store_account`;
CREATE TABLE `store_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `occur_incurred` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '发生成本',
  `occur_quantity` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '发生数量',
  `occur_amount` decimal(19,3) DEFAULT NULL,
  `goods_id` bigint(20) NOT NULL COMMENT '商品Id',
  `occur_at` datetime DEFAULT NULL COMMENT '发生时间',
  `store_incurred` decimal(11,3) DEFAULT NULL COMMENT '库存成本',
  `store_quantity` decimal(11,3) DEFAULT NULL COMMENT '库存数量',
  `store_amount` decimal(19,3) DEFAULT NULL,
  `occur_type` tinyint(3) DEFAULT NULL COMMENT '发生类型1 零售销售 2盘点损益 3采购进货 4采购退货 5零售退货 6：线上销售 7线上退货 8打包入库 9打包出库 10拆包入库 11拆包出库',
  `order_code` varchar(20) DEFAULT NULL COMMENT '单据号',
  `store_account_at` datetime DEFAULT NULL COMMENT '发生时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=731 DEFAULT CHARSET=utf8 COMMENT='库存流水';

-- ----------------------------
-- Table structure for store_order
-- ----------------------------
DROP TABLE IF EXISTS `store_order`;
CREATE TABLE `store_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(20) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `code` varchar(20) DEFAULT NULL COMMENT '单号规则见用例',
  `storage_id` bigint(20) NOT NULL COMMENT '仓库id',
  `make_by` bigint(20) NOT NULL COMMENT '制单人',
  `make_name` varchar(20) DEFAULT NULL COMMENT '制单人姓名',
  `make_at` datetime NOT NULL COMMENT '制单时间',
  `quantity` decimal(14,3) DEFAULT NULL,
  `amount` decimal(22,3) DEFAULT NULL,
  `order_type` tinyint(4) DEFAULT NULL COMMENT '1进货2退货',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='采购单';

-- ----------------------------
-- Table structure for store_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `store_order_detail`;
CREATE TABLE `store_order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(20) DEFAULT NULL,
  `last_update_by` varchar(20) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '门店Id',
  `purchase_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '采购单价',
  `quantity` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '采购数量',
  `amount` decimal(19,3) DEFAULT NULL,
  `store_order_id` bigint(20) DEFAULT NULL COMMENT '采购单Id',
  `goods_id` bigint(20) NOT NULL COMMENT '商品Id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9219 DEFAULT CHARSET=utf8 COMMENT='采购单明细';

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL COMMENT '编码',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `state` tinyint(3) DEFAULT '0' COMMENT '状态：0正常1停用',
  `linkman` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(15) DEFAULT NULL COMMENT '联系电话',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户ID，该分店所属商户，tenant.id',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商';

-- ----------------------------
-- Table structure for tenant_config
-- ----------------------------
DROP TABLE IF EXISTS `tenant_config`;
CREATE TABLE `tenant_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(45) DEFAULT NULL COMMENT '参数名',
  `value` varchar(45) DEFAULT NULL COMMENT '参数值',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_at` datetime DEFAULT NULL COMMENT '创建时间',
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '修改人',
  `last_update_at` datetime DEFAULT NULL COMMENT '修改时间',
  `tenant_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商户配置参数表';

-- ----------------------------
-- Table structure for time_param
-- ----------------------------
DROP TABLE IF EXISTS `time_param`;
CREATE TABLE `time_param` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='时段设置（外卖时段或就餐时段）';

-- ----------------------------
-- Table structure for user_log
-- ----------------------------
DROP TABLE IF EXISTS `user_log`;
CREATE TABLE `user_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `login_time` datetime DEFAULT NULL COMMENT '登陆时间戳',
  `exit_time` datetime DEFAULT NULL COMMENT '下班时间戳',
  `rest_money` decimal(11,3) DEFAULT NULL COMMENT '备用金',
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `pos_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for init_tenant
-- ----------------------------
DROP PROCEDURE IF EXISTS `init_tenant`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` PROCEDURE `init_tenant`(IN tenant_id INT,IN user_id INT,IN login_name VARCHAR(20),IN branch_name VARCHAR(30),IN phone VARCHAR(30),IN contacts VARCHAR(30),OUT branch_id INT)
BEGIN 
DECLARE area_id INT;
DECLARE category_id INT;
DECLARE t_error INTEGER DEFAULT 0;  
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error=1; 
START TRANSACTION;  
INSERT INTO `retail-db`.`area` (`tenant_id`,`parent_id`,`code`,`name`,`create_by`,`create_at`, `last_update_by`, `last_update_at`,`is_deleted`)
VALUES(tenant_id,'-1','00','总部直属','admin',NOW(),'',NOW(),'0');
SELECT LAST_INSERT_ID() INTO area_id;
INSERT INTO `retail-db`.`branch` (`tenant_id`,`branch_type`,`code`,`name`,`area_id`,`parent_id`,`status`,`phone`, `contacts`, `address`, `geolocation`,`create_by`,`create_at`, `last_update_by`, `last_update_at`,`is_deleted`,`type`,shipping_price_type)
VALUES(tenant_id,'0','000','总部' ,area_id,'-1','1',phone,contacts,'','','admin',NOW(),'',NOW(),'0','1',1);
SELECT LAST_INSERT_ID() INTO branch_id;
INSERT INTO `retail-db`.`employee` (`tenant_id`, `branch_id`, `user_id`, `login_name`, `code`, `name`, `password_for_local`, `phone`, `qq`, `email`, `memo`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `state`, `birthday`, `sex`, `head_portrait_big`, `head_portrait_small`, `discount_rate`, `discount_amount`)
VALUES ( tenant_id, branch_id, user_id, login_name, '0000', contacts, '21218cca77804d2ba1922c33e0151105', '', '', '', '', 'admin', NOW(), '', NOW(), '0', '1', NULL, NULL, '', '', '0', '0');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'CSH', '现金', '0', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', '1', NULL, '1', NULL, NULL, '1');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'CRD', '银行卡', '0', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', NULL, '1', '1', NULL, NULL, '2');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'ZFB', '支付宝', '1', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', NULL, NULL, '1', NULL, NULL, '3');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'WX', '微支付', '1', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', NULL, NULL, '1', NULL, NULL, '4');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'DJQ', '代金券', '0', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', NULL, NULL, '1', '0.000', '0', '5');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'JF', '积分', '0', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', '1', NULL, '1', NULL, NULL, '6');
INSERT INTO  `payment` ( `payment_code`, `payment_name`, `payment_status`, `currency_id`, `create_by`, `create_at`, `last_update_by`, `last_update_at`, `is_deleted`, `tenant_id`, `branch_id`, `is_score`, `is_change`, `is_memo`, `is_sale`, `fix_value`, `fix_num`, `payment_type`) VALUES ( 'HYQB', '会员储值', '0', '1', 'admin', NOW(), '', NOW(), '0', tenant_id, branch_id, '1', NULL, NULL, '1', NULL, NULL, '7');
IF t_error = 1 THEN
		SELECT -1 INTO branch_id;
    ROLLBACK;
ELSE
		
    COMMIT;
END IF;  
SELECT branch_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for currval
-- ----------------------------
DROP FUNCTION IF EXISTS `currval`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` FUNCTION `currval`(seq_name VARCHAR (50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE VALUE INTEGER ;
  SET VALUE = 0 ;
  SELECT 
    current_value INTO VALUE 
  FROM
    sequence 
  WHERE NAME = seq_name ;
  IF VALUE = 0 
  THEN SET VALUE = 1 ;
  INSERT INTO sequence (NAME, current_value) 
  VALUES
    (seq_name, VALUE) ;
  END IF ;
  RETURN VALUE ;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for currval_today
-- ----------------------------
DROP FUNCTION IF EXISTS `currval_today`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` FUNCTION `currval_today`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
 DECLARE v INTEGER;
         DECLARE dt DATE;
         DECLARE dtCurrent DATE;
         SET v = 0;
         SET dt = NULL;
         SET dtCurrent = CURRENT_DATE();
         SELECT current_value, seq_date INTO v, dt
                   FROM sequence2
                   WHERE NAME = seq_name;
		 IF v = 0 THEN
			SET v = 1;
			INSERT INTO sequence2(NAME, current_value, seq_date) VALUES(seq_name, v, dtCurrent);		 
         ELSEIF dt <> dtCurrent THEN
			SET v = 1;
            UPDATE sequence2
				SET current_value = v, seq_date = dtCurrent
                WHERE NAME = seq_name;
		 END IF;
         RETURN v;
    END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for nextval
-- ----------------------------
DROP FUNCTION IF EXISTS `nextval`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` FUNCTION `nextval`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
         UPDATE sequence
                   SET current_value = current_value + increment
                   WHERE NAME = seq_name;
         RETURN currval(seq_name);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for nextval_today
-- ----------------------------
DROP FUNCTION IF EXISTS `nextval_today`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` FUNCTION `nextval_today`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
		 DECLARE dtCurrent DATE;
         SET dtCurrent = CURRENT_DATE();
         UPDATE sequence2
                   SET current_value = current_value + increment
                   WHERE NAME = seq_name AND seq_date = dtCurrent;
         RETURN currval_today(seq_name);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for setval
-- ----------------------------
DROP FUNCTION IF EXISTS `setval`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` FUNCTION `setval`(seq_name VARCHAR(50), VALUE INTEGER) RETURNS int(11)
    DETERMINISTIC
BEGIN
         UPDATE sequence
                   SET current_value = VALUE
                   WHERE NAME = seq_name;
         RETURN currval(seq_name);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for setval_today
-- ----------------------------
DROP FUNCTION IF EXISTS `setval_today`;
DELIMITER ;;
CREATE DEFINER=`dev`@`%` FUNCTION `setval_today`(seq_name VARCHAR(50), VALUE INTEGER) RETURNS int(11)
    DETERMINISTIC
BEGIN
		 DECLARE dtCurrent DATE;
         SET dtCurrent = CURRENT_DATE();
         UPDATE sequence2
                   SET current_value = VALUE, seq_date = dtCurrent
                   WHERE NAME = seq_name;
         RETURN currval_today(seq_name);
END
;;
DELIMITER ;

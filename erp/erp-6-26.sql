/*
 Navicat Premium Data Transfer

 Source Server         : local-mysql
 Source Server Type    : MySQL
 Source Server Version : 50622
 Source Host           : localhost
 Source Database       : erp

 Target Server Type    : MySQL
 Target Server Version : 50622
 File Encoding         : utf-8

 Date: 06/27/2016 13:50:54 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `branch`
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
  `status` tinyint(3) unsigned DEFAULT '1' COMMENT '状态0 停用1启用',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='门店信息（组织结构表，含总部、配送中心、分店）';

-- ----------------------------
--  Records of `branch`
-- ----------------------------
BEGIN;
INSERT INTO `branch` VALUES ('1', '1', '0', '01', '演示门店', '13988228828', '11', '11', '1', '1', null, null, null, null, '0'), ('2', null, '1', '1', '1', '1', '1', '1', '1', '1', null, null, null, null, '1'), ('3', null, '1', '1', '1', '1', '1', '1', '1', '1', null, null, null, null, '1'), ('4', null, '1', '1', '1', '1', '1', '1', '1', '1', null, null, null, '1111', '1'), ('5', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2016-06-13 17:03:28', '管理员用户', null, null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `brand`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='品牌';

-- ----------------------------
--  Table structure for `category`
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
  `parent_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='商品分类\r\n';

-- ----------------------------
--  Records of `category`
-- ----------------------------
BEGIN;
INSERT INTO `category` VALUES ('1', '1', '01', '鱼', 'y', '-1', null, null, '管理员用户', '2016-06-27 13:29:53', '0', '0', '所有分类'), ('2', '1', '0101', '分类0222', 'fl0222', '1', null, null, '管理员用户', '2016-06-15 15:03:57', '1', '0', '111'), ('3', '1', '0102', '222', '222', '1', '管理员用户', '2016-06-15 15:17:46', null, null, '1', '0', '11122');
COMMIT;

-- ----------------------------
--  Table structure for `check_order`
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
  `status` int(11) DEFAULT NULL,
  `audit_name` varchar(20) DEFAULT NULL,
  `audit_at` datetime DEFAULT NULL,
  `check_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='盘点单';

-- ----------------------------
--  Records of `check_order`
-- ----------------------------
BEGIN;
INSERT INTO `check_order` VALUES ('1', null, null, null, null, '0', null, null, '1', 'PD16062001001', null, '1', '管理员用户', '2016-06-20 09:26:28', '3.000', '4.000', null, '2', null, null, null), ('2', null, null, null, null, '0', null, null, '1', 'PD16062001002', null, '1', '管理员用户', '2016-06-20 09:27:00', '55.000', '88.000', null, '2', null, null, null), ('3', null, null, null, null, '0', null, null, '1', 'PD16062001003', null, '1', '管理员用户', '2016-06-20 09:28:44', '0.000', '0.000', null, '2', null, null, null), ('4', null, null, null, null, '0', null, '1', '1', 'PD16062001004', null, '1', '管理员用户', '2016-06-20 09:33:12', '0.000', '0.000', null, '1', '管理员用户', '2016-06-20 09:33:34', '2016-06-20 09:33:34'), ('5', null, null, null, null, '0', null, '1', '1', 'PD16062001005', null, '1', '管理员用户', '2016-06-20 09:33:46', '0.000', '0.000', null, '1', '管理员用户', '2016-06-20 09:33:47', '2016-06-20 09:33:47'), ('6', null, null, null, null, '0', null, '1', '1', 'PD16062001006', null, '1', '管理员用户', '2016-06-20 09:33:57', '3.000', '4.000', null, '1', '管理员用户', '2016-06-20 09:33:58', '2016-06-20 09:33:58'), ('7', null, null, null, null, '0', null, '1', '1', 'PD16062001007', null, '1', '管理员用户', '2016-06-20 11:20:44', '11.000', '44.000', null, '1', '管理员用户', '2016-06-20 11:28:52', '2016-06-20 11:28:52'), ('9', null, null, null, null, '0', null, '1', '1', 'PD16062001014', null, '1', '管理员用户', '2016-06-20 18:08:26', '0.000', '0.000', null, '1', '管理员用户', '2016-06-20 18:08:27', '2016-06-20 18:08:27'), ('10', null, null, null, null, '0', null, '1', '1', 'PD16062001015', null, '1', '管理员用户', '2016-06-20 18:10:29', '-29.000', '0.000', null, '1', '管理员用户', '2016-06-20 18:10:32', '2016-06-20 18:10:32'), ('11', null, null, null, null, '0', null, '1', '1', 'PD16062001016', null, '1', '管理员用户', '2016-06-20 18:17:03', '1.000', '0.000', null, '1', '管理员用户', '2016-06-20 18:17:04', '2016-06-20 18:17:04'), ('12', null, null, null, null, '0', null, '1', '1', 'PD16062101001', null, '1', '管理员用户', '2016-06-21 10:06:46', '1.000', '0.000', null, '1', '管理员用户', '2016-06-21 10:06:47', '2016-06-21 10:06:47'), ('13', null, null, null, null, '0', null, '1', '1', 'PD16062701001', null, '1', '管理员用户', '2016-06-27 13:41:08', '1.000', '0.000', null, '1', '管理员用户', '2016-06-27 13:41:21', '2016-06-27 13:41:21');
COMMIT;

-- ----------------------------
--  Table structure for `check_order_detail`
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
  `code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='盘点单明细\n';

-- ----------------------------
--  Records of `check_order_detail`
-- ----------------------------
BEGIN;
INSERT INTO `check_order_detail` VALUES ('1', null, null, null, null, '0', null, null, '1', '4.000', '0.000', '1', '12', '1.000', '1.000', '4.000', 'PD16062001001'), ('2', null, null, null, null, '0', null, null, '1', '0.000', '0.000', '1', '13', '2.000', '2.000', '0.000', 'PD16062001001'), ('3', null, null, null, null, '0', null, null, '1', '4.000', '0.000', '2', '12', '22.000', '22.000', '88.000', 'PD16062001002'), ('4', null, null, null, null, '0', null, null, '1', '0.000', '0.000', '2', '13', '33.000', '33.000', '0.000', 'PD16062001002'), ('5', null, null, null, null, '0', null, null, '1', '4.000', '0.000', '3', '12', '0.000', '0.000', '0.000', 'PD16062001003'), ('6', null, null, null, null, '0', null, null, '1', '0.000', '0.000', '3', '13', '0.000', '0.000', '0.000', 'PD16062001003'), ('7', null, null, null, null, '0', null, '1', '1', '4.000', '0.000', '4', '12', '0.000', '0.000', '0.000', 'PD16062001004'), ('8', null, null, null, null, '0', null, '1', '1', '0.000', '0.000', '4', '13', '0.000', '0.000', '0.000', 'PD16062001004'), ('9', null, null, null, null, '0', null, '1', '1', '4.000', '0.000', '5', '12', '0.000', '0.000', '0.000', 'PD16062001005'), ('10', null, null, null, null, '0', null, '1', '1', '0.000', '0.000', '5', '13', '0.000', '0.000', '0.000', 'PD16062001005'), ('11', null, null, null, null, '0', null, '1', '1', '4.000', '0.000', '6', '12', '1.000', '1.000', '4.000', 'PD16062001006'), ('12', null, null, null, null, '0', null, '1', '1', '0.000', '0.000', '6', '13', '2.000', '2.000', '0.000', 'PD16062001006'), ('13', null, null, null, null, '0', null, '1', '1', '4.000', '0.000', '7', '12', '11.000', '11.000', '44.000', 'PD16062001007'), ('14', null, null, null, null, '0', null, '1', '1', null, '29.000', '9', '12', '28.000', '-1.000', null, 'PD16062001014'), ('15', null, null, null, null, '0', null, '1', '1', null, '10.000', '9', '13', '11.000', '1.000', null, 'PD16062001014'), ('16', null, null, null, null, '0', null, '1', '1', null, '57.000', '10', '12', '27.000', '-30.000', null, 'PD16062001015'), ('17', null, null, null, null, '0', null, '1', '1', null, '21.000', '10', '13', '22.000', '1.000', null, 'PD16062001015'), ('18', null, null, null, null, '0', null, '1', '1', null, '84.000', '11', '12', '88.000', '4.000', null, 'PD16062001016'), ('19', null, null, null, null, '0', null, '1', '1', null, '43.000', '11', '13', '40.000', '-3.000', null, 'PD16062001016'), ('20', null, null, null, null, '0', null, '1', '1', null, '88.000', '12', '12', '88.000', '0.000', null, 'PD16062101001'), ('21', null, null, null, null, '0', null, '1', '1', null, '40.000', '12', '13', '41.000', '1.000', null, 'PD16062101001'), ('22', null, null, null, null, '0', null, '1', '1', null, '8.000', '13', '12', '8.000', '0.000', null, 'PD16062701001'), ('23', null, null, null, null, '0', null, '1', '1', null, '17.000', '13', '13', '18.000', '1.000', null, 'PD16062701001');
COMMIT;

-- ----------------------------
--  Table structure for `goods`
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) NOT NULL COMMENT '商品分类\n外键\n',
  `goods_name` varchar(50) NOT NULL COMMENT '商品名称\n',
  `bar_code` char(13) DEFAULT NULL COMMENT '条码',
  `spec` varchar(50) DEFAULT NULL COMMENT '规格',
  `purchasing_price` decimal(11,3) DEFAULT '0.000' COMMENT '进价',
  `sale_price` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '零售价',
  `goods_unit_id` bigint(20) DEFAULT NULL COMMENT '单位',
  `vip_price1` decimal(11,3) DEFAULT '0.000' COMMENT '会员价1',
  `vip_price2` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '会员价2',
  `goods_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '商品状态\n0-正常\n1-停售',
  `brand_id` bigint(20) DEFAULT NULL COMMENT '品牌id',
  `short_name` varchar(20) DEFAULT NULL COMMENT '商品简称',
  `mnemonic` varchar(50) DEFAULT NULL COMMENT '助记码',
  `photo` varchar(200) DEFAULT NULL COMMENT '图片路径',
  `is_dsc` tinyint(1) DEFAULT '0' COMMENT '是否有折扣0否1是',
  `is_store` tinyint(1) DEFAULT '0' COMMENT '是否管理库存0否1是',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL COMMENT '最后更新人',
  `last_update_at` datetime DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户id',
  `price_type` tinyint(3) DEFAULT NULL COMMENT '已不使用',
  `goods_unit_name` varchar(20) DEFAULT NULL,
  `category_name` varchar(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='商品';

-- ----------------------------
--  Records of `goods`
-- ----------------------------
BEGIN;
INSERT INTO `goods` VALUES ('1', '1', '111', '2233', null, '0.000', '0.000', '1', null, '0.000', '0', null, null, '11', null, '0', '0', null, '管理员用户', '2016-06-15 17:01:17', null, null, '1', '1', null, '条', '鱼', '1'), ('2', '1', '我问问', '22222', null, '42.000', '121.000', '1', null, '1221.000', '0', null, null, 'www', null, '0', '0', null, '管理员用户', '2016-06-15 16:59:58', null, null, '1', '1', null, '条', '鱼', '1'), ('3', '1', '222', '01000001', null, '0.000', '0.000', '1', null, '0.000', '0', null, null, '2222', null, '0', '1', null, '管理员用户', '2016-06-15 17:01:28', null, null, '1', '1', null, '条', '鱼', '1'), ('4', '1', '2222', '01000001', null, '4.000', '1.000', '2', null, '3.000', '0', null, null, '222222', null, '0', '1', null, '管理员用户', '2016-06-15 17:02:33', null, null, '1', '1', null, '份', '鱼', '1'), ('5', '1', '22', '01000002', null, '0.000', '1.000', '1', null, '1.000', '0', null, null, '22', null, '0', '1', null, '管理员用户', '2016-06-15 17:06:28', null, null, '1', '1', null, '条', '鱼', '1'), ('6', '1', '文档', '01000003', null, '5.000', '1.000', '1', '4.000', '44.000', '0', null, null, 'wd', null, '0', '0', null, '管理员用户', '2016-06-16 10:02:57', null, null, '1', '1', null, '条', '鱼', '1'), ('7', '1', '222', '1', null, '0.000', '0.000', '1', '0.000', '0.000', '0', null, null, '2222', null, '0', '0', null, '管理员用户', '2016-06-17 10:53:30', null, null, '1', '1', null, '条', '鱼', '1'), ('8', '1', '222', '2', null, '0.000', '0.000', '1', '0.000', '0.000', '0', null, null, '222', null, '0', '0', null, '管理员用户', '2016-06-17 10:53:34', null, null, '1', '1', null, '条', '鱼', '1'), ('9', '1', '12321', '3', null, '0.000', '0.000', '1', '0.000', '0.000', '0', null, null, '12321', null, '0', '0', null, '管理员用户', '2016-06-17 10:53:39', null, null, '1', '1', null, '条', '鱼', '1'), ('10', '1', '2222', '4', null, '0.000', '0.000', '2', '0.000', '0.000', '0', null, null, '2222', null, '0', '0', null, '管理员用户', '2016-06-17 10:53:44', null, null, '1', '1', null, '份', '鱼', '1'), ('11', '1', '11', '1111', null, '0.000', '0.000', '1', '0.000', '0.000', '0', null, null, '11', null, '0', '1', null, '管理员用户', '2016-06-16 11:23:35', null, null, '1', '1', null, '条', '鱼', '1'), ('12', '1', '黄河鲤鱼', '0001', null, '10.000', '23.000', '1', '20.000', '23.000', '0', null, null, 'hhly', null, '0', '0', '黄河鲤鱼', '管理员用户', '2016-06-27 13:30:37', null, null, '0', '1', null, '条', '鱼', '1'), ('13', '1', '鲫鱼', '0002', null, '8.000', '22.000', '1', '15.000', '15.000', '0', null, null, 'jy', null, '0', '0', null, '管理员用户', '2016-06-27 13:31:22', null, null, '0', '1', null, '条', '鱼', '1');
COMMIT;

-- ----------------------------
--  Table structure for `goods_bar`
-- ----------------------------
DROP TABLE IF EXISTS `goods_bar`;
CREATE TABLE `goods_bar` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` bigint(20) unsigned NOT NULL COMMENT '商品的id',
  `bar_code` varchar(13) DEFAULT NULL COMMENT '条码',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '商户ID，该分店所属商户，tenant.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品条码';

-- ----------------------------
--  Table structure for `goods_unit`
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='商品单位';

-- ----------------------------
--  Records of `goods_unit`
-- ----------------------------
BEGIN;
INSERT INTO `goods_unit` VALUES ('1', '01', '条', null, null, null, '管理员用户', '2016-06-14 17:44:06', '0', '1'), ('2', '02', '份', null, null, null, '管理员用户', '2016-06-14 17:44:19', '0', '1');
COMMIT;

-- ----------------------------
--  Table structure for `jz_sale_day`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售日结转';

-- ----------------------------
--  Table structure for `payment`
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='支付方式';

-- ----------------------------
--  Records of `payment`
-- ----------------------------
BEGIN;
INSERT INTO `payment` VALUES ('1', 'CSH', '现金', '0', '0', null, null, null, null, '0', null, '0', '1', '1', '1', '1', '1.000', '10', '1', '1'), ('2', 'ZFB', '支付宝', '0', '0', null, null, null, null, '0', null, '0', '1', '1', '1', '1', '1.000', '1', '2', '1'), ('3', 'WZF', '微信', '0', '0', null, null, null, null, '0', null, '0', '1', '1', '1', '1', '11.000', '11', '11', '1');
COMMIT;

-- ----------------------------
--  Table structure for `pos`
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='pos信息';

-- ----------------------------
--  Records of `pos`
-- ----------------------------
BEGIN;
INSERT INTO `pos` VALUES ('1', '1', '1', '', '001', '01', '222222', '1', null, null, null, '2016-06-15 10:22:25', '管理员用户', '1', '演示门店', '', '88888888', null, null), ('2', '1', '1', null, '002', '01', '111111', '1', null, null, null, '2016-06-21 10:49:25', '管理员用户', '0', '演示门店', null, '88888888', null, null);
COMMIT;

-- ----------------------------
--  Table structure for `pos_config`
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
--  Table structure for `s_config`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统配置参数表';

-- ----------------------------
--  Table structure for `s_dict_item`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典值';

-- ----------------------------
--  Table structure for `s_dict_type`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典类型';

-- ----------------------------
--  Table structure for `s_emp`
-- ----------------------------
DROP TABLE IF EXISTS `s_emp`;
CREATE TABLE `s_emp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL COMMENT '名称',
  `addr` varchar(255) DEFAULT NULL COMMENT '地址',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `user_id` bigint(20) DEFAULT NULL COMMENT '登录用户id',
  `login_name` varchar(30) DEFAULT NULL COMMENT '登录账号',
  `tenant_id` bigint(20) NOT NULL,
  `branch_id` bigint(20) NOT NULL COMMENT '父资源',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='员工';

-- ----------------------------
--  Records of `s_emp`
-- ----------------------------
BEGIN;
INSERT INTO `s_emp` VALUES ('1', '鹏', '青岛', '13900228828', null, '1', 'admin', '1', '1', null, null, null, null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `s_error_log`
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
--  Table structure for `s_job_detail`
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
--  Table structure for `s_op_log`
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
--  Table structure for `s_operate`
-- ----------------------------
DROP TABLE IF EXISTS `s_operate`;
CREATE TABLE `s_operate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `op_code` varchar(10) DEFAULT '00',
  `op_name` varchar(50) NOT NULL COMMENT '操作名称\n\n',
  `action_name` varchar(50) DEFAULT NULL COMMENT 'action名称',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='操作定义';

-- ----------------------------
--  Records of `s_operate`
-- ----------------------------
BEGIN;
INSERT INTO `s_operate` VALUES ('1', '001', '菜单操作', null, null), ('2', '002', '显示功能页面', null, null), ('3', '003', '操作', '', null);
COMMIT;

-- ----------------------------
--  Table structure for `s_privilege`
-- ----------------------------
DROP TABLE IF EXISTS `s_privilege`;
CREATE TABLE `s_privilege` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `res_id` bigint(20) NOT NULL COMMENT '资源ID, s_res.id',
  `op_id` bigint(20) NOT NULL COMMENT '操作ID, s_operate.id',
  `is_free` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否不进行权限控制，0-否（默认）1-是。为1时，不做权限控制。',
  PRIMARY KEY (`id`),
  KEY `fk_s_privilege_s_res1_idx` (`res_id`),
  KEY `fk_s_privilege_s_operate1_idx` (`op_id`),
  CONSTRAINT `s_privilege_ibfk_1` FOREIGN KEY (`op_id`) REFERENCES `s_operate` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `s_privilege_ibfk_2` FOREIGN KEY (`res_id`) REFERENCES `s_res` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='权限定义表';

-- ----------------------------
--  Records of `s_privilege`
-- ----------------------------
BEGIN;
INSERT INTO `s_privilege` VALUES ('1', '1', '1', '0'), ('2', '5', '1', '0'), ('3', '14', '1', '0'), ('4', '31', '1', '0'), ('5', '2', '2', '0'), ('6', '3', '2', '0'), ('7', '4', '2', '0'), ('8', '6', '2', '0'), ('9', '7', '2', '0'), ('10', '8', '2', '0'), ('11', '9', '2', '0'), ('12', '10', '2', '0'), ('13', '11', '2', '0'), ('14', '12', '2', '0'), ('15', '13', '2', '0'), ('16', '15', '2', '0'), ('17', '16', '2', '0'), ('18', '17', '2', '0'), ('19', '18', '2', '0'), ('20', '19', '2', '0'), ('21', '20', '2', '0'), ('22', '21', '2', '0'), ('23', '22', '2', '0'), ('25', '24', '2', '0'), ('26', '25', '2', '0'), ('27', '26', '2', '0'), ('28', '27', '2', '0'), ('29', '28', '2', '0'), ('30', '29', '2', '0'), ('31', '30', '2', '0'), ('32', '32', '2', '0'), ('33', '33', '1', '0'), ('34', '34', '1', '0'), ('35', '35', '1', '0'), ('36', '36', '1', '0'), ('37', '37', '2', '0'), ('38', '38', '2', '0'), ('39', '39', '2', '0'), ('40', '40', '2', '0'), ('41', '41', '2', '0');
COMMIT;

-- ----------------------------
--  Table structure for `s_res`
-- ----------------------------
DROP TABLE IF EXISTS `s_res`;
CREATE TABLE `s_res` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `package_name` varchar(50) NOT NULL COMMENT '子系统默认包名，用于区分子系统',
  `res_code` varchar(10) DEFAULT '00',
  `res_name` varchar(50) NOT NULL COMMENT '资源名称',
  `controller_name` varchar(50) DEFAULT NULL COMMENT 'Controller名称',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `parent_id` bigint(20) NOT NULL COMMENT '父资源',
  `res_status` tinyint(3) unsigned NOT NULL COMMENT '资源状态\n0-正常\n1-停用',
  `res_type` tinyint(3) NOT NULL DEFAULT '3' COMMENT '资源类型：1-正式发布，2-预览，3-测试',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统资源';

-- ----------------------------
--  Records of `s_res`
-- ----------------------------
BEGIN;
INSERT INTO `s_res` VALUES ('1', 'smart.light.web', '10', '系统管理', 'sys', '', '0', '1', '1'), ('2', 'smart.light.web', '11', '商户管理', 'tenant', '', '1', '1', '1'), ('3', 'smart.light.web', '12', '角色管理', 'employeeRole', '', '1', '1', '1'), ('4', 'smart.light.web', '13', '员工管理', 'sysEmp', '', '1', '1', '1'), ('5', 'smart.light.web', '20', '基础资料', 'base', '', '0', '0', '1'), ('6', 'smart.light.web', '14', '门店管理', 'branch', '', '1', '1', '1'), ('7', 'smart.light.web', '15', 'pos管理', 'pos', '', '5', '0', '1'), ('8', 'smart.light.web', '21', '分类管理', 'category', '', '5', '0', '1'), ('9', 'smart.light.web', '22', '商品单位', 'goodsUnit', '', '5', '0', '1'), ('10', 'smart.light.web', '23', '商品条码', 'goodsBar', '', '5', '1', '1'), ('11', 'smart.light.web', '24', '商品管理', 'goods', '', '5', '0', '1'), ('12', 'smart.light.web', '16', '支付方式', 'payment', '', '1', '1', '1'), ('13', 'smart.light.web', '29', '分组管理', 'baseGroup', '', '14', '1', '1'), ('14', 'smart.light.web', '30', '库存管理', 'bus', '', '0', '0', '1'), ('15', 'smart.light.web', '31', '商品入库', 'storeOrder', 'index#orderType=1', '14', '0', '1'), ('16', 'smart.light.web', '32', '商品出库', 'storeOrder', 'index#orderType=2', '14', '0', '1'), ('17', 'smart.light.web', '33', '商品盘点', 'checkOrder', '', '14', '0', '1'), ('18', 'smart.light.web', '34', '库存查询', 'store', 'index#1', '33', '0', '1'), ('19', 'smart.light.web', '35', '流水查询', 'sale', 'index#1', '33', '0', '1'), ('20', 'smart.light.web', '51', '流水统计', 'sale', 'index#2', '33', '1', '1'), ('21', 'smart.light.web', '52', '库存统计', 'StoreAccount', 'index#2', '33', '1', '1'), ('22', 'smart.light.web', '63', '入库历史', 'busWarningHisData', '', '33', '1', '1'), ('24', 'smart.light.web', '53', '出库历史', 'busChargingPileData', '', '33', '1', '1'), ('25', 'smart.light.web', '64', '盘点历史', 'busChargingPileHisData', '', '33', '1', '1'), ('26', 'smart.light.web', '54', '库存流水', 'storeAccount', '', '33', '0', '1'), ('27', 'smart.light.web', '55', 'wifi', 'busWifiData', '', '33', '1', '1'), ('28', 'smart.light.web', '81', '定时任务', 'jobScheduler', '', '36', '1', '1'), ('29', 'smart.light.web', '82', '操作日志', 'busLog', '', '36', '1', '1'), ('30', 'smart.light.web', '28', '档案同步', 'baseDeviceSync', '', '14', '1', '1'), ('31', 'smart.light.web', '60', '数据查询', 'tabCaly', '', '0', '1', '1'), ('32', 'smart.light.web', '83', '出入库查询', 'test', '', '31', '1', '1'), ('33', 'smart.light.web', '50', '统计分析', 'currentdata', '', '0', '0', '1'), ('34', 'smart.light.web', '60', '历史数据', 'hisdata', '', '0', '1', '1'), ('35', 'smart.light.web', '70', '统计分析', 'data', '', '0', '1', '1'), ('36', 'smart.light.web', '80', '系统设置', 'sysset', '', '0', '1', '1'), ('37', 'smart.light.web', '71', '线损查询', 'chart', 'chartloos#1', '35', '1', '1'), ('38', 'smart.light.web', '72', '用电量查询', 'chart', 'chartelectricity#1', '35', '1', '1'), ('39', 'smart.light.web', '73', '在线率查询', 'chart', 'chartread#1', '35', '1', '1'), ('40', 'smart.light.web', '74', '线损分析', 'chart', null, '35', '1', '1'), ('41', 'smart.light.web', '75', '用电量分析', 'chart', null, '35', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `s_role`
-- ----------------------------
DROP TABLE IF EXISTS `s_role`;
CREATE TABLE `s_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `package_name` varchar(20) NOT NULL COMMENT '子系统默认包名，用于区分子系统',
  `tenant_id` bigint(19) unsigned DEFAULT NULL COMMENT '客户ID，saas系统为0',
  `role_code` varchar(20) DEFAULT NULL COMMENT '角色编码',
  `role_name` varchar(50) NOT NULL COMMENT '角色名称\n\n',
  `create_by` varchar(50) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='角色信息';

-- ----------------------------
--  Records of `s_role`
-- ----------------------------
BEGIN;
INSERT INTO `s_role` VALUES ('1', 'smart.light.web', '0', '01', '管理员', null, null, null, null, '0'), ('2', 'smart.light.web', '0', '02', '操作员', null, null, null, null, '0'), ('3', 'smart.light.web', null, '03', '看v', null, null, null, null, '1'), ('4', 'smart.light.web', null, '04', '222222', null, null, null, null, '0'), ('5', 'smart.light.web', null, '05', '111', null, null, null, null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `s_role_privilege_r`
-- ----------------------------
DROP TABLE IF EXISTS `s_role_privilege_r`;
CREATE TABLE `s_role_privilege_r` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID，s_role.id',
  `privilege_id` bigint(20) NOT NULL COMMENT '权限ID，s_privilege.id',
  `limit_date` date DEFAULT NULL COMMENT '使用期限',
  `is_disable` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`role_id`,`privilege_id`),
  KEY `fk_s_role_privilege_s_role1_idx` (`role_id`) USING BTREE,
  KEY `fk_s_role_privilege_s_privilege1_idx` (`privilege_id`) USING BTREE,
  CONSTRAINT `s_role_privilege_r_ibfk_1` FOREIGN KEY (`privilege_id`) REFERENCES `s_privilege` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `s_role_privilege_r_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `s_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色权限关系表';

-- ----------------------------
--  Records of `s_role_privilege_r`
-- ----------------------------
BEGIN;
INSERT INTO `s_role_privilege_r` VALUES ('2', '1', null, '0'), ('2', '2', null, '0'), ('2', '3', null, '0'), ('2', '4', null, '0'), ('2', '5', null, '0'), ('2', '6', null, '0'), ('2', '7', null, '0'), ('2', '8', null, '0'), ('2', '9', null, '0'), ('2', '10', null, '0'), ('2', '11', null, '0'), ('2', '12', null, '0'), ('2', '13', null, '0'), ('2', '14', null, '0'), ('2', '15', null, '0'), ('2', '16', null, '0'), ('2', '17', null, '0'), ('2', '18', null, '0'), ('2', '19', null, '0'), ('2', '20', null, '0'), ('2', '21', null, '0'), ('2', '22', null, '0'), ('2', '23', null, '0'), ('2', '25', null, '0'), ('2', '26', null, '0'), ('2', '27', null, '0'), ('2', '28', null, '0'), ('2', '29', null, '0'), ('2', '30', null, '0'), ('2', '31', null, '0'), ('2', '32', null, '0'), ('2', '33', null, '0'), ('2', '34', null, '0'), ('2', '35', null, '0'), ('2', '36', null, '0'), ('2', '37', null, '0'), ('2', '38', null, '0'), ('2', '39', null, '0'), ('2', '40', null, '0'), ('2', '41', null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `s_user`
-- ----------------------------
DROP TABLE IF EXISTS `s_user`;
CREATE TABLE `s_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '唯一ID，自增',
  `login_name` varchar(30) NOT NULL COMMENT '登录帐号',
  `login_pass` varchar(32) DEFAULT NULL COMMENT '登录密码（32位md5加密）',
  `user_type` tinyint(3) unsigned NOT NULL COMMENT '用户类型（1-路灯管理局；）',
  `bind_mobile` varchar(20) DEFAULT NULL COMMENT '用户绑定的手机号',
  `bind_wechat` varchar(64) DEFAULT NULL COMMENT '用户绑定的微信号OpenID',
  `bind_email` varchar(50) DEFAULT NULL,
  `bind_qq` varchar(20) DEFAULT NULL,
  `state` tinyint(3) unsigned NOT NULL COMMENT '用户状态（0-未激活；1-启用；2-停用）未激活的帐号为无效帐号，3分钟后可重复注册',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `login_count` int(11) DEFAULT '0' COMMENT '登录次数',
  `last_login_time` datetime DEFAULT NULL COMMENT '上次登录时间',
  `last_login_ip` varchar(20) DEFAULT NULL COMMENT '上次登录IP',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统用户表';

-- ----------------------------
--  Records of `s_user`
-- ----------------------------
BEGIN;
INSERT INTO `s_user` VALUES ('1', 'admin', '21218cca77804d2ba1922c33e0151105', '1', '12333322222', null, null, null, '1', '管理员用户', '296', '2016-06-27 13:28:52', '0:0:0:0:0:0:0:1', null, '2016-04-13 15:21:09', null, '2016-04-13 15:21:09', null, '0'), ('4', '21010014', '111', '1', '12233222222', null, null, null, '2', '222', '0', null, null, null, '2016-04-13 15:32:44', null, '2016-04-13 15:32:44', null, '0'), ('5', '21010015', '21218cca77804d2ba1922c33e0151105', '1', '18382727276', null, null, null, '2', '12345', '0', null, null, null, '2016-04-13 15:54:48', null, '2016-04-13 15:54:48', null, '0'), ('6', '21010016', '21218cca77804d2ba1922c33e0151105', '1', '14456789012', null, null, null, '1', '12345678', '0', null, null, null, '2016-04-13 19:01:04', null, '2016-04-13 19:01:04', null, '0'), ('7', '21010017', '21218cca77804d2ba1922c33e0151105', '1', '13899922821', null, null, null, '1', '3213213', '0', null, null, null, '2016-04-13 19:01:29', null, '2016-04-13 19:01:29', null, '0'), ('8', '21010018', '21218cca77804d2ba1922c33e0151105', '1', '13988277222', null, null, null, '1', 'www', '0', null, null, null, '2016-04-14 15:13:11', null, '2016-04-14 15:13:11', null, '0'), ('9', '21010019', '21218cca77804d2ba1922c33e0151105', '1', '13899298271', null, null, null, '1', '管理员1', '1', '2016-04-18 14:15:46', '0:0:0:0:0:0:0:1', null, '2016-04-18 14:15:34', null, '2016-04-18 14:15:34', null, '0'), ('10', '21010020', '21218cca77804d2ba1922c33e0151105', '1', '13828282828', null, null, null, '1', '21', '0', null, null, null, '2016-06-03 15:11:48', null, '2016-06-03 15:11:48', null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `s_user_role_r`
-- ----------------------------
DROP TABLE IF EXISTS `s_user_role_r`;
CREATE TABLE `s_user_role_r` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID，sys_user.id',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID，s_role.id',
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_s_user_role_r_s_role1_idx` (`role_id`),
  KEY `fk_s_user_role_r_sys_user1_idx` (`user_id`),
  CONSTRAINT `s_user_role_r_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `s_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `s_user_role_r_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `s_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户角色关系表';

-- ----------------------------
--  Records of `s_user_role_r`
-- ----------------------------
BEGIN;
INSERT INTO `s_user_role_r` VALUES ('1', '2'), ('4', '2'), ('5', '2'), ('6', '2'), ('7', '2'), ('8', '2'), ('9', '2'), ('10', '2');
COMMIT;

-- ----------------------------
--  Table structure for `sale`
-- ----------------------------
DROP TABLE IF EXISTS `sale`;
CREATE TABLE `sale` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) DEFAULT NULL COMMENT 'POS数据主键ID',
  `tenant_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL COMMENT '所属门店，默认为0，代表总部',
  `sale_code` char(30) NOT NULL COMMENT '销售账单号\n',
  `pos_id` bigint(20) DEFAULT '0',
  `pos_code` char(20) DEFAULT '0' COMMENT 'POS号(冗余字段)\n',
  `total_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '销售合计\n（所有单品计价的合计 商品原价*数量）',
  `discount_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '折扣额\n',
  `give_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '赠送额\n',
  `long_amount` decimal(11,3) DEFAULT NULL COMMENT '长款金额',
  `trunc_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '抹零额',
  `is_free_of_charge` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否免单',
  `service_fee` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '所有服务费的合计，属于加收项目\n包括座位费、加工费等\n单项加工费另表保存',
  `received_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '实收金额=total_amount-discount_amount-give_amount-trunc_amount=sum(sale_payment.pay_total)-long_amount',
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
  `sale_type` tinyint(3) DEFAULT '0' COMMENT '订单类型：0-pos订单',
  PRIMARY KEY (`id`),
  KEY `idx_sale_tenant_id_branch_id_sale_code` (`tenant_id`,`branch_id`,`sale_code`),
  KEY `idx_sale_tenant_id_branch_id_create_at` (`tenant_id`,`branch_id`,`create_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售账单流水';

-- ----------------------------
--  Table structure for `sale_detail`
-- ----------------------------
DROP TABLE IF EXISTS `sale_detail`;
CREATE TABLE `sale_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sale_code` char(30) NOT NULL COMMENT '销售账单号\n',
  `goods_id` bigint(20) NOT NULL COMMENT '商品',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售明细流水\r\n';

-- ----------------------------
--  Table structure for `sale_payment`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付单流水';

-- ----------------------------
--  Table structure for `sequence`
-- ----------------------------
DROP TABLE IF EXISTS `sequence`;
CREATE TABLE `sequence` (
  `name` varchar(50) NOT NULL,
  `current_value` int(11) unsigned NOT NULL,
  `increment` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `sequence`
-- ----------------------------
BEGIN;
INSERT INTO `sequence` VALUES ('dd', '0', '1'), ('tenant', '61011000', '1'), ('tenant_hzg', '71010004', '1'), ('tenant_test', '21010020', '1');
COMMIT;

-- ----------------------------
--  Table structure for `sequence2`
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
--  Records of `sequence2`
-- ----------------------------
BEGIN;
INSERT INTO `sequence2` VALUES ('CK11', '1', '2016-06-27', '1'), ('dd11', '4', '2016-03-01', '1'), ('dd17', '1', '2016-03-09', '1'), ('dd9', '12', '2016-02-28', '1'), ('PD11', '1', '2016-06-27', '1'), ('RK11', '1', '2016-06-27', '1');
COMMIT;

-- ----------------------------
--  Table structure for `store`
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
  `avg_amount` decimal(11,3) DEFAULT '0.000' COMMENT '成本',
  `store_at` datetime DEFAULT NULL COMMENT '出入库时间',
  `store_amount` decimal(19,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ten_bra_goods` (`tenant_id`,`branch_id`,`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='库存表';

-- ----------------------------
--  Records of `store`
-- ----------------------------
BEGIN;
INSERT INTO `store` VALUES ('4', '管理员用户', '2016-06-27 13:38:52', '管理员用户', '2016-06-27 13:41:21', '0', null, '1', '1', null, '12', '8.000', null, null, null), ('5', '管理员用户', '2016-06-27 13:38:52', '管理员用户', '2016-06-27 13:41:21', '0', null, '1', '1', null, '13', '18.000', null, null, null);
COMMIT;

-- ----------------------------
--  Table structure for `store_account`
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
  `occur_incurred` decimal(11,3) DEFAULT '0.000' COMMENT '发生成本',
  `occur_quantity` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '发生数量',
  `occur_amount` decimal(19,3) DEFAULT NULL,
  `goods_id` bigint(20) NOT NULL COMMENT '商品Id',
  `occur_at` datetime DEFAULT NULL COMMENT '发生时间',
  `store_incurred` decimal(11,3) DEFAULT NULL COMMENT '库存成本',
  `store_quantity` decimal(11,3) DEFAULT NULL COMMENT '库存数量',
  `store_amount` decimal(19,3) DEFAULT NULL,
  `occur_type` tinyint(3) DEFAULT NULL COMMENT '发生类型1 pos销售 2盘点损益 3入库 ',
  `order_code` varchar(20) DEFAULT NULL COMMENT '单据号',
  `store_account_at` datetime DEFAULT NULL COMMENT '发生时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=737 DEFAULT CHARSET=utf8 COMMENT='库存流水';

-- ----------------------------
--  Records of `store_account`
-- ----------------------------
BEGIN;
INSERT INTO `store_account` VALUES ('731', '管理员用户', '2016-06-27 13:38:52', null, null, '0', null, '1', '1', null, '10.000', null, '12', '2016-06-27 13:38:51', null, '10.000', null, '3', 'RK16062701001', null), ('732', '管理员用户', '2016-06-27 13:38:52', null, null, '0', null, '1', '1', null, '20.000', null, '13', '2016-06-27 13:38:51', null, '20.000', null, '3', 'RK16062701001', null), ('733', '管理员用户', '2016-06-27 13:40:05', null, null, '0', null, '1', '1', null, '2.000', null, '12', '2016-06-27 13:40:05', null, '8.000', null, '4', 'CK16062701001', null), ('734', '管理员用户', '2016-06-27 13:40:05', null, null, '0', null, '1', '1', null, '3.000', null, '13', '2016-06-27 13:40:05', null, '17.000', null, '4', 'CK16062701001', null), ('735', '管理员用户', '2016-06-27 13:41:21', null, null, '0', null, '1', '1', null, '0.000', null, '12', '2016-06-27 13:41:21', null, '8.000', null, '5', 'PD16062701001', null), ('736', '管理员用户', '2016-06-27 13:41:21', null, null, '0', null, '1', '1', null, '1.000', null, '13', '2016-06-27 13:41:21', null, '18.000', null, '5', 'PD16062701001', null);
COMMIT;

-- ----------------------------
--  Table structure for `store_order`
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
  `make_by` bigint(20) NOT NULL COMMENT '制单人',
  `make_name` varchar(20) DEFAULT NULL COMMENT '制单人姓名',
  `make_at` datetime NOT NULL COMMENT '制单时间',
  `quantity` decimal(14,3) DEFAULT NULL,
  `amount` decimal(22,3) DEFAULT NULL,
  `order_type` tinyint(4) DEFAULT NULL COMMENT '1入库2出库',
  `status` int(11) DEFAULT NULL,
  `audit_name` varchar(20) DEFAULT NULL,
  `audit_at` datetime DEFAULT NULL,
  `store_order_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COMMENT='（出入库）单据';

-- ----------------------------
--  Records of `store_order`
-- ----------------------------
BEGIN;
INSERT INTO `store_order` VALUES ('21', null, null, null, null, '0', '进货', '1', '1', 'RK16062701001', '1', '管理员用户', '2016-06-27 13:37:15', '30.000', '260.000', '1', '1', '管理员用户', '2016-06-27 13:38:51', '2016-06-27 13:38:51'), ('22', null, null, null, null, '0', '商品出库', '1', '1', 'CK16062701001', '1', '管理员用户', '2016-06-27 13:39:49', '5.000', '44.000', '2', '1', '管理员用户', '2016-06-27 13:40:05', '2016-06-27 13:40:05');
COMMIT;

-- ----------------------------
--  Table structure for `store_order_detail`
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
  `purchase_amount` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '单价',
  `quantity` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '数量',
  `amount` decimal(19,3) DEFAULT NULL,
  `store_order_id` bigint(20) DEFAULT NULL COMMENT '入库单Id',
  `goods_id` bigint(20) NOT NULL COMMENT '商品Id',
  `store_order_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='单据明细';

-- ----------------------------
--  Records of `store_order_detail`
-- ----------------------------
BEGIN;
INSERT INTO `store_order_detail` VALUES ('29', null, null, null, null, '0', null, '1', '1', '10.000', '10.000', '100.000', '21', '12', 'RK16062701001'), ('30', null, null, null, null, '0', null, '1', '1', '8.000', '20.000', '160.000', '21', '13', 'RK16062701001'), ('31', null, null, null, null, '0', null, '1', '1', '10.000', '2.000', '20.000', '22', '12', 'CK16062701001'), ('32', null, null, null, null, '0', null, '1', '1', '8.000', '3.000', '24.000', '22', '13', 'CK16062701001');
COMMIT;

-- ----------------------------
--  Table structure for `tenant`
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant` (
  `id` bigint(19) unsigned NOT NULL AUTO_INCREMENT COMMENT '商户唯一ID，自增',
  `user_id` bigint(19) unsigned DEFAULT NULL COMMENT '对应的用户ID，sys_user.id',
  `code` char(8) DEFAULT NULL COMMENT '商户ID，8位纯数字',
  `name` varchar(50) DEFAULT NULL COMMENT '商户名称',
  `address` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `province` char(6) DEFAULT NULL COMMENT '所在省份区划代码',
  `city` char(6) DEFAULT NULL COMMENT '所在地市区划代码',
  `county` char(6) DEFAULT NULL COMMENT '所在区县区划代码',
  `phone_number` varchar(20) NOT NULL COMMENT '手机号',
  `linkman` varchar(20) NOT NULL COMMENT '联系人',
  `business` tinyint(3) unsigned DEFAULT NULL COMMENT '行业：1-快餐店',
  `business1` char(1) DEFAULT '1' COMMENT '一级业态：1-餐饮，2-零售',
  `business2` char(3) DEFAULT NULL COMMENT '二级业态',
  `business3` char(5) DEFAULT NULL COMMENT '三级业态',
  `email` varchar(50) DEFAULT NULL,
  `qq` varchar(20) DEFAULT NULL,
  `status` tinyint(3) unsigned NOT NULL COMMENT '状态：0-未激活，1-启用，2-停用',
  `paid_total` decimal(11,3) DEFAULT NULL COMMENT '缴费额（指商户激活以来，支付的软件费总金额）',
  `goods_id` bigint(20) unsigned DEFAULT NULL COMMENT '当前激活的软件版本ID，goods.id',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_test` tinyint(1) unsigned zerofill DEFAULT '1' COMMENT '是否是测试环境下的账号-1为测试账号-0为正式账号',
  `cashier_name` varchar(20) DEFAULT NULL COMMENT '安全收银账号',
  `cashier_pwd` varchar(20) DEFAULT NULL COMMENT '安全收银密码',
  `img_url` varchar(255) DEFAULT NULL COMMENT '商户logo存储路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='商户信息表';

-- ----------------------------
--  Records of `tenant`
-- ----------------------------
BEGIN;
INSERT INTO `tenant` VALUES ('1', '1', '88888888', '演示商户', '演示商户', '1', '1', '1', '13899882288', '鹏', '1', '1', '1', '1', '1', '1', '1', '1.000', '1', '1', null, null, null, null, '0', '1', '1', '1', '1');
COMMIT;

-- ----------------------------
--  View structure for `v_check_order_detail`
-- ----------------------------
DROP VIEW IF EXISTS `v_check_order_detail`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_check_order_detail` AS select `d`.`id` AS `detail_id`,`d`.`memo` AS `memo`,`d`.`tenant_id` AS `tenant_id`,`d`.`branch_id` AS `branch_id`,`d`.`purchase_price` AS `purchase_price`,`d`.`quantity` AS `store_quantity`,`d`.`really_quantity` AS `really_quantity`,`d`.`check_quantity` AS `check_quantity`,`d`.`check_amount` AS `check_amount`,`d`.`check_order_id` AS `check_order_id`,`d`.`code` AS `check_order_code`,`d`.`goods_id` AS `goods_id`,`g`.`bar_code` AS `bar_code`,`g`.`goods_name` AS `goods_name`,`g`.`category_name` AS `category_name`,`g`.`goods_unit_name` AS `goods_unit_name`,`g`.`sale_price` AS `sale_price` from (`check_order_detail` `d` join `goods` `g` on(((`d`.`goods_id` = `g`.`id`) and (`d`.`is_deleted` = 0)))) where (1 = 1);

-- ----------------------------
--  View structure for `v_store_account_goods`
-- ----------------------------
DROP VIEW IF EXISTS `v_store_account_goods`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_store_account_goods` AS (select `g`.`bar_code` AS `bar_code`,`g`.`goods_name` AS `goods_name`,`s`.`occur_incurred` AS `occur_incurred`,`s`.`occur_quantity` AS `occur_quantity`,`s`.`occur_amount` AS `occur_amount`,`s`.`store_incurred` AS `store_incurred`,`s`.`store_quantity` AS `store_quantity`,`s`.`store_amount` AS `store_amount`,`s`.`occur_type` AS `occur_type`,`s`.`occur_at` AS `occur_at`,`s`.`order_code` AS `order_code`,`s`.`branch_id` AS `branch_id`,`g`.`category_id` AS `category_id`,`g`.`id` AS `id`,`s`.`tenant_id` AS `tenant_id` from (`store_account` `s` join `goods` `g`) where ((`s`.`goods_id` = `g`.`id`) and (`s`.`is_deleted` = 0)));

-- ----------------------------
--  View structure for `v_store_goods`
-- ----------------------------
DROP VIEW IF EXISTS `v_store_goods`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_store_goods` AS (select `g`.`bar_code` AS `bar_code`,`g`.`goods_name` AS `goods_name`,`g`.`category_name` AS `category_name`,`g`.`goods_unit_name` AS `goods_unit_name`,`s`.`avg_amount` AS `avg_amount`,`g`.`sale_price` AS `sale_price`,`s`.`quantity` AS `quantity`,`s`.`store_amount` AS `store_amount`,`s`.`branch_id` AS `branch_id`,`g`.`category_id` AS `category_id`,`g`.`id` AS `id`,`s`.`tenant_id` AS `tenant_id` from (`store` `s` join `goods` `g`) where ((`s`.`goods_id` = `g`.`id`) and (`s`.`is_deleted` = 0)));

-- ----------------------------
--  View structure for `v_store_order_detail`
-- ----------------------------
DROP VIEW IF EXISTS `v_store_order_detail`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_store_order_detail` AS select `d`.`id` AS `id`,`d`.`memo` AS `memo`,`d`.`tenant_id` AS `tenant_id`,`d`.`branch_id` AS `branch_id`,`d`.`purchase_amount` AS `purchase_amount`,`d`.`quantity` AS `quantity`,`d`.`amount` AS `amount`,`d`.`store_order_id` AS `store_order_id`,`d`.`store_order_code` AS `store_order_code`,`d`.`goods_id` AS `goods_id`,`g`.`bar_code` AS `bar_code`,`g`.`goods_name` AS `goods_name`,`g`.`category_name` AS `category_name`,`g`.`goods_unit_name` AS `goods_unit_name`,`g`.`sale_price` AS `sale_price` from (`store_order_detail` `d` join `goods` `g` on((`d`.`goods_id` = `g`.`id`))) where (`d`.`is_deleted` = 0);

-- ----------------------------
--  Procedure structure for `proc_goods_store_info`
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_goods_store_info`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_goods_store_info`(IN tenant_id BIGINT(20),
 IN branch_id BIGINT(20),
 IN goods_is_delete INT,
 IN queryStr VARCHAR(2000),
 IN page_ INT,
 IN pageSize INT)
BEGIN
SET @APPLY_SQL_GOODS = CONCAT('  AND g.tenant_id = ',tenant_id,case when ifnull( goods_is_delete,'') = '' then '' else CONCAT(' and g.is_deleted = ',goods_is_delete) end);
SET @APPLY_SQL_STORE = CONCAT(' AND s.is_deleted = 0 AND s.tenant_id = ', tenant_id ,' AND s.branch_id =  ',branch_id);
SET @APPLY_SQL = 'SELECT 
    go_.id AS goods_id,
    go_.bar_code,
    go_.goods_name,
    go_.category_name,
    go_.goods_unit_name,
    go_.sale_price,
    sto_.id AS store_id,
    sto_.quantity AS store_quantity,
    sto_.avg_amount AS store_avg_amount,
    sto_.store_amount,
    sto_.store_at,
    sto_.branch_id AS store_branch_id,
    sto_.tenant_id AS store_tenant_id,
    go_.purchasing_price
FROM
    (SELECT 
        *
    FROM
        goods g
    WHERE
        1=1 %%%G ) go_
        LEFT JOIN
    (SELECT 
        *
    FROM
        store s
    WHERE 1=1 %%%S) sto_ ON go_.id = sto_.goods_id
    WHERE 1=1 %%%p
 %%%PS ';
SET @PAGE_S = case when ifnull( page_,'') = '' then '' else CONCAT(' LIMIT ',page_,' , ',pageSize) end;
SET @APPLY_SQL =  REPLACE(@APPLY_SQL,'%%%G',@APPLY_SQL_GOODS);
SET @APPLY_SQL =  REPLACE(@APPLY_SQL,'%%%S',@APPLY_SQL_STORE);
SET @APPLY_SQL =  REPLACE(@APPLY_SQL,'%%%PS',@PAGE_S);
SET @APPLY_SQL =  REPLACE(@APPLY_SQL,'%%%p',ifnull(queryStr,''));
PREPARE stmt4 FROM @APPLY_SQL;
EXECUTE stmt4;
END
 ;;
delimiter ;

-- ----------------------------
--  Function structure for `currval`
-- ----------------------------
DROP FUNCTION IF EXISTS `currval`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `currval`(seq_name VARCHAR (50)) RETURNS int(11)
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
delimiter ;

-- ----------------------------
--  Function structure for `currval_today`
-- ----------------------------
DROP FUNCTION IF EXISTS `currval_today`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `currval_today`(seq_name VARCHAR(50)) RETURNS int(11)
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
delimiter ;

-- ----------------------------
--  Function structure for `nextval`
-- ----------------------------
DROP FUNCTION IF EXISTS `nextval`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `nextval`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
         UPDATE sequence
                   SET current_value = current_value + increment
                   WHERE NAME = seq_name;
         RETURN currval(seq_name);
END
 ;;
delimiter ;

-- ----------------------------
--  Function structure for `nextval_today`
-- ----------------------------
DROP FUNCTION IF EXISTS `nextval_today`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `nextval_today`(seq_name VARCHAR(50)) RETURNS int(11)
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
delimiter ;

-- ----------------------------
--  Function structure for `setval`
-- ----------------------------
DROP FUNCTION IF EXISTS `setval`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `setval`(seq_name VARCHAR(50), VALUE INTEGER) RETURNS int(11)
    DETERMINISTIC
BEGIN
         UPDATE sequence
                   SET current_value = VALUE
                   WHERE NAME = seq_name;
         RETURN currval(seq_name);
END
 ;;
delimiter ;

-- ----------------------------
--  Function structure for `setval_today`
-- ----------------------------
DROP FUNCTION IF EXISTS `setval_today`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `setval_today`(seq_name VARCHAR(50), VALUE INTEGER) RETURNS int(11)
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
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

/*
 Navicat Premium Data Transfer

 Source Server         : local-mysql
 Source Server Type    : MySQL
 Source Server Version : 50622
 Source Host           : localhost
 Source Database       : smartlight

 Target Server Type    : MySQL
 Target Server Version : 50622
 File Encoding         : utf-8

 Date: 06/12/2016 16:25:14 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `base_area`
-- ----------------------------
DROP TABLE IF EXISTS `base_area`;
CREATE TABLE `base_area` (
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `base_area_type` tinyint(3) DEFAULT NULL COMMENT '区域属性：1线路2台区，通过配置读取写入',
  `base_area_name` varchar(20) DEFAULT NULL COMMENT '名称',
  `base_area_pid` bigint(20) DEFAULT NULL COMMENT '父节点id',
  `base_area_pname` varchar(20) DEFAULT NULL COMMENT '父节点名称',
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` bigint(20) DEFAULT NULL COMMENT '员工id，区域管理者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='区域\n';

-- ----------------------------
--  Records of `base_area`
-- ----------------------------
BEGIN;
INSERT INTO `base_area` VALUES (null, null, null, null, '1', '1', '1', '1', '2', '1', '1', '1', null), (null, null, null, null, '1', '1', '2', '3', '4', '5', '6', '2', '7'), (null, null, null, null, '1', '1', '2', '3', '吕鹏', '5', '6', '3', '7'), (null, null, null, null, '1', '2', '2', '2', '2', '2', '2', '4', '2'), (null, null, null, null, '1', '1', '1', '1', '1', '1', '1', '5', '1'), (null, null, null, null, '1', null, '1', '1', '111332我', '-1', null, '6', '111'), (null, null, null, null, '1', null, '1', '1', '222', '6', null, '7', '222'), (null, null, null, null, '1', null, '1', '1', '222', '-1', null, '8', '222'), (null, null, null, null, '0', null, '1', '1', '区域2', '-1', '所有区域', '9', '5'), (null, null, null, null, '1', null, '1', '1', '112', '-1', '所有区域', '10', '5'), (null, null, null, null, '1', null, '1', '1', '222', '10', '112', '11', '5'), (null, null, null, null, '0', null, '1', '1', '区域2-1', '9', '1', '12', '1'), (null, null, null, null, '0', null, '1', '1', '区域2-2', '9', '1', '13', '1'), (null, null, null, null, '0', null, '1', '1', '区域3', '-1', '所有区域', '14', '1'), (null, null, null, null, '0', null, '1', '1', '区域3-1', '14', '区域3', '15', '1'), (null, null, null, null, '0', null, '1', '1', '区域3-1-1', '15', '区域3-1', '16', '1'), (null, null, null, null, '0', null, '1', '1', '区域3-1-2', '15', '区域3-1', '17', '1'), (null, null, null, null, '1', null, '1', '1', 'quyu2', '9', '区域2', '18', '1'), (null, null, null, null, '0', null, '1', '1', '111', '-1', '所有区域', '19', '1'), (null, null, null, null, '0', null, '1', '1', 'www', '9', '区域2', '20', '1'), (null, null, null, null, '0', null, '1', '1', '测试', '-1', '所有区域', '21', '1');
COMMIT;

-- ----------------------------
--  Table structure for `base_bill_board`
-- ----------------------------
DROP TABLE IF EXISTS `base_bill_board`;
CREATE TABLE `base_bill_board` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bill_board_code` varchar(20) DEFAULT NULL COMMENT '广告牌编码',
  `base_bill_board_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `base_bound_device_id` bigint(20) DEFAULT NULL,
  `base_bound_devicec_code` varchar(10) DEFAULT NULL COMMENT '终端设备编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='广告牌';
delimiter ;;
CREATE TRIGGER `synchronization_bound_bill_board_rl` BEFORE INSERT ON `base_bill_board` FOR EACH ROW begin 
INSERT INTO bus_bill_board_data (dept_id,base_bill_board_code,base_bill_board_devaddr) VALUES (NEW.dept_id,NEW.base_bill_board_code,NEW.base_bill_board_devaddr);
END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `synchronization_bound_bill_board_real` AFTER INSERT ON `base_bill_board` FOR EACH ROW begin
		INSERT INTO bus_bill_board_data (dept_id,base_bill_board_code,base_bill_board_devaddr) 
		VALUES (NEW.dept_id,NEW.base_bill_board_code,NEW.base_bill_board_devaddr);
END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `tri_222stuInsertsss` BEFORE UPDATE ON `base_bill_board` FOR EACH ROW begin
declare c int;
set c = (select id from bse_bill_board where id=new.id);
update class set id = c + 1 where id = new.id;
end;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `tri_stuInsertsss` AFTER UPDATE ON `base_bill_board` FOR EACH ROW begin
declare c int;
set c = (select id from bse_bill_board where id=new.id);
update class set id = c + 1 where id = new.id;
end;
 ;;
delimiter ;

-- ----------------------------
--  Records of `base_bill_board`
-- ----------------------------
BEGIN;
INSERT INTO `base_bill_board` VALUES (null, null, null, null, '1', '1', '1', '1', '1', '1', null, null), (null, null, null, null, '1', '12', null, '2', '12', '12', '4', '2'), (null, null, null, null, '0', '广告牌1', null, '3', '广告牌1', '20151122', '327', 'bill327'), (null, null, null, null, '0', '111', null, '4', '11', '111', '7', '1'), (null, null, null, null, '0', '321', null, '5', '2231', '321', '9', '2'), (null, null, null, null, null, '999', null, '6', '999', '999', '327', '999');
COMMIT;

-- ----------------------------
--  Table structure for `base_bound_device`
-- ----------------------------
DROP TABLE IF EXISTS `base_bound_device`;
CREATE TABLE `base_bound_device` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `base_bound_device_no` int(11) DEFAULT NULL COMMENT '终端序号-测量点号（1-2040',
  `base_bound_devicec_addr` varchar(20) DEFAULT NULL COMMENT '终端设备地址-测量点地址',
  `base_bound_device_port` int(11) DEFAULT NULL COMMENT '通信端口号 默认31',
  `base_bound_device_procode` varchar(10) DEFAULT NULL COMMENT '协议类型：路灯07，配置项',
  `base_bound_device_speed` tinyint(3) DEFAULT NULL COMMENT '通信速率 ：默认3。1:600;2:1200;3:2400;4:4800;5:7200;6:9600;7:19200',
  `base_bound_devicec_col_addr` varchar(20) DEFAULT NULL COMMENT '采集器地址 ：默认0',
  `base_terminal_id` bigint(20) DEFAULT NULL COMMENT '集中控制器id',
  `base_bound_devicec_code` varchar(10) DEFAULT NULL COMMENT '终端设备编号（自编码）',
  `base_bound_devicec_lng` varchar(45) DEFAULT NULL COMMENT '经度',
  `base_bound_devicec_lat` varchar(45) DEFAULT NULL COMMENT '纬度',
  `is_top` tinyint(1) DEFAULT NULL COMMENT '是否总表0否1是',
  `base_bound_devicec_type` tinyint(3) DEFAULT NULL COMMENT '类型：1路灯2水表3热表4四表合一',
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=348 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='终端设备';
delimiter ;;
CREATE TRIGGER `synchronization_bound_device_real` AFTER INSERT ON `base_bound_device` FOR EACH ROW begin

	INSERT INTO bus_bound_device_data (dept_id,base_terminal_addr,base_bound_device_addr) 
		VALUES (NEW.dept_id,NEW.base_terminal_addr,NEW.base_bound_devicec_addr);

end;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `synchronization_bound_device_del` AFTER UPDATE ON `base_bound_device` FOR EACH ROW BEGIN
	IF NEW.is_deleted=1 THEN
		UPDATE bus_bound_device_data set is_deleted=1 WHERE base_terminal_addr = NEW.base_terminal_addr 
		AND base_bound_device_addr=NEW.base_bound_devicec_addr;
	END IF;
END;
 ;;
delimiter ;

-- ----------------------------
--  Records of `base_bound_device`
-- ----------------------------
BEGIN;
INSERT INTO `base_bound_device` VALUES (null, null, null, null, '0', null, null, '3', '201511220479', '31', '07', '3', '0', '2', '3', '120.389014', '36.071745', '0', '1', '327', '37020001'), (null, null, null, null, '0', null, null, '4', '201511220137', '31', '07', '3', '0', '2', '4', '120.389374', '36.071103', '0', '1', '328', '37020001'), (null, null, null, null, '0', null, null, '5', '201511220708', '31', '07', '3', '0', '2', '5', '120.387505', '36.070491', '0', '1', '329', '37020001'), (null, null, null, null, '0', null, null, '6', '201511220088', '31', '07', '3', '0', '2', '6', '120.387146', '36.070053', '0', '1', '330', '37020001'), (null, null, null, null, '0', null, null, '7', '201511220020', '31', '07', '3', '0', '2', '7', null, null, '0', '1', '331', '37020001'), (null, null, null, null, '0', null, null, '8', '201511220056', '31', '07', '3', '0', '2', '8', null, null, '0', '1', '332', '37020001'), (null, null, null, null, '0', null, null, '9', '201511220284', '31', '07', '3', '0', '2', '9', null, null, '0', '1', '333', '37020001'), (null, null, null, null, '0', null, null, '10', '201511220602', '31', '07', '3', '0', '2', '10', null, null, '0', '1', '334', '37020001'), (null, null, null, null, '0', null, null, '11', '201511220072', '31', '07', '3', '0', '2', '11', null, null, '0', '1', '335', '37020001'), (null, null, null, null, '1', null, null, '12', '201511220660', '31', '07', '3', '0', '2', '12', null, null, '0', '1', '336', '37020001'), (null, null, null, null, '1', null, null, '13', '201511229999', '31', '07', '3', '0', '2', '99', null, null, '0', '1', '337', '37020001'), (null, null, null, null, '1', null, null, '14', '201511228888', '31', '07', '3', '0', '2', '88', null, null, '0', '1', '338', '37020001'), (null, null, null, null, null, null, null, '15', '20161111', '31', '07', '3', '0', '2', '66', null, null, '0', '1', '346', '37020001'), (null, null, null, null, '1', null, null, '3', '201611220001', '31', '07', '3', '0', '14', '0011', '120.282109', '36.278385', '0', '1', '347', '05910001');
COMMIT;

-- ----------------------------
--  Table structure for `base_camera`
-- ----------------------------
DROP TABLE IF EXISTS `base_camera`;
CREATE TABLE `base_camera` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bound_device_id` bigint(20) DEFAULT NULL COMMENT '终端设备id',
  `base_camera_ip` varchar(45) DEFAULT NULL COMMENT '摄像头ip',
  `base_camera_factory` varchar(45) DEFAULT NULL COMMENT '厂家',
  `base_bound_devicec_code` varchar(10) DEFAULT NULL COMMENT '终端设备编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='摄像头';

-- ----------------------------
--  Records of `base_camera`
-- ----------------------------
BEGIN;
INSERT INTO `base_camera` VALUES (null, null, null, null, '1', '1', '1', '1', '1', '1', '1', null), (null, null, null, null, '1', '112', null, '2', '4', '112', '112', '2'), (null, null, null, null, '0', '摄像头1', null, '3', '327', '192.168.1.99', 'zcl摄像头1', 'zcl2'), (null, null, null, null, '0', '1', null, '4', '7', '1', '1', '1'), (null, null, null, null, '0', '11', null, '5', '9', '11', '11', '2');
COMMIT;

-- ----------------------------
--  Table structure for `base_charging_pile`
-- ----------------------------
DROP TABLE IF EXISTS `base_charging_pile`;
CREATE TABLE `base_charging_pile` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bound_device_id` bigint(20) DEFAULT NULL COMMENT '终端设备id',
  `base_charging_pile_addr` varchar(20) DEFAULT NULL COMMENT '充电桩地址',
  `base_charging_pile_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `base_bound_devicec_code` varchar(10) DEFAULT NULL COMMENT '终端设备编码，自编码标示灯杆',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='充电桩';
delimiter ;;
CREATE TRIGGER `synchronization_base_charging_pile_real` AFTER INSERT ON `base_charging_pile` FOR EACH ROW begin
		INSERT INTO bus_charging_pile_data (dept_id,base_charging_pile_devaddr) 
		VALUES (NEW.dept_id,NEW.base_charging_pile_devaddr);
END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `synchronization_base_charging_pile_del` AFTER UPDATE ON `base_charging_pile` FOR EACH ROW begin
	IF NEW.is_deleted=1 THEN
		UPDATE bus_charging_pile_data set is_deleted=1 WHERE base_charging_pile_devaddr = NEW.base_charging_pile_devaddr ;
	END IF;
end;
 ;;
delimiter ;

-- ----------------------------
--  Records of `base_charging_pile`
-- ----------------------------
BEGIN;
INSERT INTO `base_charging_pile` VALUES ('2016-04-27 13:42:36', null, null, null, '0', null, null, '8', '327', '327', '327327', '327pippo'), (null, null, null, null, '1', null, null, '9', '327', '999', '999999', '999-99');
COMMIT;

-- ----------------------------
--  Table structure for `base_group`
-- ----------------------------
DROP TABLE IF EXISTS `base_group`;
CREATE TABLE `base_group` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_group_name` varchar(20) DEFAULT NULL COMMENT '分组名称',
  `base_group_code` varchar(20) DEFAULT NULL COMMENT '编号：范围01-16\n',
  `base_terminal_id` bigint(20) DEFAULT NULL COMMENT '集中控制器id\n',
  `base_group_cmd` int(11) DEFAULT NULL COMMENT '触发器操作cmd 命令字',
  `base_group_cmd_no` tinyint(4) DEFAULT NULL COMMENT '触发器操作 分路号',
  `base_group_cmd_light` int(11) DEFAULT NULL COMMENT '触发器操作当前亮度数值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='分组\n';
delimiter ;;
CREATE TRIGGER `synchronization_group_info` AFTER UPDATE ON `base_group` FOR EACH ROW BEGIN
	DECLARE lightNo INT;
	DECLARE terminalCode VARCHAR(20);

	IF new.base_group_cmd != old.base_group_cmd THEN	/*13分组控制开  14分组控制关 15分组控制调光*/
		SET lightNo = NEW.base_group_cmd_no;
		SELECT base_terminal_addr INTO terminalCode from base_terminal where id=new.base_terminal_id and is_deleted=0;
		IF new.base_group_cmd=13 THEN
			IF lightNo=3 THEN
				UPDATE bus_bound_device_data set bus_bound_device_data_swich = 128 ,last_update_at=CURRENT_TIMESTAMP()  WHERE  bus_bound_device_data_dev_type<3 AND base_terminal_addr=terminalCode; 
			ELSE
				UPDATE bus_bound_device_data set bus_bound_device_data_swich = 128 ,last_update_at=CURRENT_TIMESTAMP()  WHERE  bus_bound_device_data_dev_type=lightNo AND base_terminal_addr=terminalCode; 
			END IF;
			
		ELSEIF new.base_group_cmd=14 THEN
			IF lightNo=3 THEN
				UPDATE bus_bound_device_data set bus_bound_device_data_swich = 127 ,last_update_at=CURRENT_TIMESTAMP()  WHERE  bus_bound_device_data_dev_type<3 AND base_terminal_addr=terminalCode; 
			ELSE
				UPDATE bus_bound_device_data set bus_bound_device_data_swich = 127 ,last_update_at=CURRENT_TIMESTAMP()  WHERE  bus_bound_device_data_dev_type=lightNo AND base_terminal_addr=terminalCode; 
			END IF;
		ELSEIF NEW.base_group_cmd=15 THEN
			IF lightNo=3 THEN
				UPDATE bus_bound_device_data set bus_bound_device_data_swich = 128 ,last_update_at=CURRENT_TIMESTAMP(),bus_bound_device_data_value = NEW.base_group_cmd_light  WHERE  bus_bound_device_data_dev_type<3 AND base_terminal_addr=terminalCode; 
			ELSE
				UPDATE bus_bound_device_data set bus_bound_device_data_swich = 128 ,last_update_at=CURRENT_TIMESTAMP(),bus_bound_device_data_value = NEW.base_group_cmd_light  WHERE  bus_bound_device_data_dev_type=lightNo AND base_terminal_addr=terminalCode; 
			END IF;
		END IF;
	END IF;
END;
 ;;
delimiter ;

-- ----------------------------
--  Records of `base_group`
-- ----------------------------
BEGIN;
INSERT INTO `base_group` VALUES (null, null, null, null, '1', '1', '1', '1', '1', '1', '1', null, null, null), (null, null, null, null, '1', null, null, '2', '分组1', '01', null, null, null, null), (null, null, null, null, '1', null, null, '3', '分组2', '02', '5', null, null, null), (null, null, null, null, '0', null, null, '4', '01组', '01', '2', null, null, null), (null, null, null, null, '0', null, null, '5', '02组', '02', '5', null, null, null), (null, null, null, null, '0', null, null, '6', '01', '01', '5', null, null, null), (null, null, null, null, '0', null, null, '7', '222', '02', '2', null, null, null), (null, null, null, null, '0', null, null, '8', '111', '03', '2', null, null, null), (null, null, null, null, '0', null, null, '9', '去去去', '问问', '5', null, null, null), (null, null, null, null, '1', null, null, '10', '1', '1', '5', null, null, null);
COMMIT;

-- ----------------------------
--  Table structure for `base_group_bound_device_r`
-- ----------------------------
DROP TABLE IF EXISTS `base_group_bound_device_r`;
CREATE TABLE `base_group_bound_device_r` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL COMMENT '分组id\n',
  `base_bound_device_id` bigint(20) DEFAULT NULL COMMENT '终端设备id',
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bound_devicec_code` varchar(10) DEFAULT NULL COMMENT '终端设备编号',
  `base_bound_devicec_addr` varchar(20) DEFAULT NULL COMMENT '终端设备地址',
  `base_terminal_addr` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='分组-终端设备';

-- ----------------------------
--  Records of `base_group_bound_device_r`
-- ----------------------------
BEGIN;
INSERT INTO `base_group_bound_device_r` VALUES (null, null, null, null, '0', '1', '1', null, '1', '1', null, null, null), (null, null, null, null, '0', '1', '1', null, '1', '2', null, null, null), (null, null, null, null, '0', '1', '1', '1', '1', '3', null, null, null), (null, null, null, null, '0', null, null, '2', '4', '4', '2', '22', '37020001'), (null, null, null, null, '0', null, null, '2', '9', '5', '2', '1', '37020001'), (null, null, null, null, '0', null, null, '3', '7', '6', '1', '2', '37020006'), (null, null, null, null, '1', null, null, '4', '4', '7', '2', '22', '37020001'), (null, null, null, null, '1', null, null, '4', '9', '8', '2', '1', '37020001'), (null, null, null, null, '0', null, null, '5', '7', '9', '1', '2', '37020006'), (null, null, null, null, '1', null, null, '4', '4', '10', '2', '22', '37020001'), (null, null, null, null, '1', null, null, '4', '9', '11', '2', '1', '37020001'), (null, null, null, null, '0', null, null, '6', '7', '12', '1', '2', '37020006'), (null, null, null, null, '0', null, null, '7', '4', '13', '2', '22', '37020001'), (null, null, null, null, '0', null, null, '7', '9', '14', '2', '1', '37020001'), (null, null, null, null, '1', null, null, '4', '10', '15', '2', '22', '37020001'), (null, null, null, null, '1', null, null, '4', '11', '16', '2', '1', '37020001'), (null, null, null, null, '0', null, null, '4', '10', '17', '2', '22', '37020001'), (null, null, null, null, '0', null, null, '4', '11', '18', '2', '1', '37020001'), (null, null, null, null, '0', null, null, '8', '4', '19', '2', '22', '37020001'), (null, null, null, null, '0', null, null, '9', '7', '20', '1', '2', '37020006'), (null, null, null, null, '0', null, null, '10', '7', '21', '1', '2', '37020006');
COMMIT;

-- ----------------------------
--  Table structure for `base_terminal`
-- ----------------------------
DROP TABLE IF EXISTS `base_terminal`;
CREATE TABLE `base_terminal` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `base_terminal_sms` varchar(20) DEFAULT NULL COMMENT 'sms卡号',
  `base_terminal_Lng` varchar(45) DEFAULT NULL COMMENT '经度',
  `base_terminal_lat` varchar(45) DEFAULT NULL COMMENT '纬度',
  `base_area_id` bigint(20) DEFAULT NULL COMMENT '区域id，叶子节点\n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='集中控制器';
delimiter ;;
CREATE TRIGGER `synchronization_terminal_real` AFTER INSERT ON `base_terminal` FOR EACH ROW BEGIN

	INSERT INTO bus_terminal_data (dept_id,base_terminal_addr,is_deleted) VALUES (NEW.dept_id,NEW.base_terminal_addr,0);

END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `synchronization_terminal_real_del` AFTER UPDATE ON `base_terminal` FOR EACH ROW BEGIN
	IF NEW.is_deleted=1 THEN
		UPDATE bus_terminal_data set is_deleted=1 WHERE base_terminal_addr = NEW.base_terminal_addr;
	END IF;
END;
 ;;
delimiter ;

-- ----------------------------
--  Records of `base_terminal`
-- ----------------------------
BEGIN;
INSERT INTO `base_terminal` VALUES (null, null, null, null, '1', '1', '1', '1', '1', '1', '1', '1', '1'), (null, null, null, null, '0', null, null, '2', '37020001', '13332223322', '120.3893', '36.071978', '12'), (null, null, null, null, '1', null, null, '3', '22222222222222', '222', '222', '222', '12'), (null, null, null, null, '1', null, null, '4', '2222222', '12222222222', '2222', '222', '12'), (null, null, null, null, '0', null, null, '5', '37020006', '13989898989', '1', '1', '13'), (null, null, null, null, '0', null, null, '6', '37020003', '13790987787', '1', '1', '16'), (null, null, null, null, '0', null, null, '7', '37020004', '13909029876', '1', '1', '17'), (null, null, null, null, '1', null, null, '8', 'www', '13233333333', '222', '222', '19'), (null, null, null, null, '0', null, null, '9', '37020005', '13909998876', '1', '1', '13'), (null, null, null, null, '1', null, null, '10', '37020003', '13988288282', '120.381397', '36.087147', '20'), (null, null, null, null, '0', null, null, '11', '37020011', '13988276222', '120.389445', '36.075304', '19'), (null, null, null, null, '0', null, null, '12', '37020012', '13987662772', '120.383696', '36.079155', '19'), (null, null, null, null, '1', null, null, '13', '38020001', '123', '11', null, null), (null, null, null, null, '0', null, null, '14', '05910001', '13333333333', '120.282949', '36.279698', '21');
COMMIT;

-- ----------------------------
--  Table structure for `base_wifi`
-- ----------------------------
DROP TABLE IF EXISTS `base_wifi`;
CREATE TABLE `base_wifi` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bound_device_id` bigint(20) DEFAULT NULL COMMENT '终端设备id',
  `base_wifi_ip` varchar(45) DEFAULT NULL COMMENT 'ip\n',
  `base_wifi_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `base_bound_devicec_code` varchar(10) DEFAULT NULL COMMENT '终端设备编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
delimiter ;;
CREATE TRIGGER `synchronization_bound_base_wifi_real` AFTER INSERT ON `base_wifi` FOR EACH ROW begin
		INSERT INTO bus_wifi_data (dept_id,base_wifi_devaddr) 
		VALUES (NEW.dept_id,NEW.base_wifi_devaddr);
END;
 ;;
delimiter ;
delimiter ;;
CREATE TRIGGER `synchronization_bound_base_wifi_del` AFTER UPDATE ON `base_wifi` FOR EACH ROW begin
	IF NEW.is_deleted=1 THEN
		UPDATE bus_wifi_data set is_deleted=1 WHERE base_wifi_devaddr = NEW.base_wifi_devaddr ;
	END IF;
end;
 ;;
delimiter ;

-- ----------------------------
--  Records of `base_wifi`
-- ----------------------------
BEGIN;
INSERT INTO `base_wifi` VALUES (null, null, null, null, '1', '1', '1', '1', '1', '1', '1', null), (null, null, null, null, '0', 'ww', null, '2', '327', 'ww', 'zclwifi', 'zclwifi'), (null, null, null, null, '0', 'wifi-1', null, '3', '9', 'wifi-11', 'wifi-1', '2'), (null, null, null, null, null, 'wifi-2', null, '4', '327', '192.168.1.1', '123', '2');
COMMIT;

-- ----------------------------
--  Table structure for `bus_bill_board_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_bill_board_data`;
CREATE TABLE `bus_bill_board_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bill_board_code` varchar(20) DEFAULT NULL COMMENT '广告牌编码',
  `base_bill_board_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `bus_bill_board_data_content` varchar(255) DEFAULT NULL COMMENT '广告内容',
  `bus_bill_board_data_warning_state` tinyint(1) DEFAULT NULL COMMENT '报警状态：默认0正常，1损坏',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='广告牌实时信息';

-- ----------------------------
--  Records of `bus_bill_board_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_bill_board_data` VALUES ('2016-04-28 10:22:52', '2016-04-28 10:22:54', null, null, '0', '1', '1', '1', '1', '20151122', '1', '1'), (null, null, null, null, null, null, null, '2', '999', '999', null, null);
COMMIT;

-- ----------------------------
--  Table structure for `bus_bill_board_his_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_bill_board_his_data`;
CREATE TABLE `bus_bill_board_his_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_bill_board_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `bus_bill_board_his_data_electricity` decimal(9,2) DEFAULT NULL COMMENT '电量',
  `bus_bill_board_his_data_day_time` datetime DEFAULT NULL COMMENT '数据冻结时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='广告牌冻结信息';

-- ----------------------------
--  Table structure for `bus_bound_device_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_bound_device_data`;
CREATE TABLE `bus_bound_device_data` (
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `base_bound_device_addr` varchar(20) DEFAULT NULL COMMENT '路灯地址',
  `bus_bound_device_data_voltage` decimal(7,2) DEFAULT NULL COMMENT '电压',
  `bus_bound_device_data_electric` decimal(7,4) DEFAULT NULL COMMENT '电流',
  `bus_bound_device_data_power` decimal(7,4) DEFAULT NULL COMMENT '功率',
  `bus_bound_device_data_electricity` decimal(9,2) DEFAULT NULL COMMENT '电量',
  `bus_bound_device_data_swich` int(11) DEFAULT NULL COMMENT '开关状态0开1关',
  `bus_bound_device_data_dev_type` tinyint(3) DEFAULT NULL COMMENT '类型：1主灯2辅灯',
  `bus_bound_device_data_value` int(11) DEFAULT NULL COMMENT '亮度',
  `bus_bound_device_data_waring_state` int(1) DEFAULT NULL COMMENT '报警状态：默认0正常，1损坏',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='终端设备实时信息';

-- ----------------------------
--  Records of `bus_bound_device_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_bound_device_data` VALUES (null, '2016-05-06 16:51:00', null, null, null, null, null, '4', '37020001', '201511220284', '235.80', '0.1070', '0.0055', '0.00', '128', '1', null, null), (null, '2016-05-06 16:51:00', null, null, null, null, null, '5', '37020001', '201511220284', '235.80', '0.0430', '0.0032', '0.00', '128', '2', null, null), ('2016-06-03 13:19:11', null, null, null, '1', null, null, '6', '05910001', '201611220001', null, null, null, null, null, null, null, null);
COMMIT;

-- ----------------------------
--  Table structure for `bus_bound_device_his_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_bound_device_his_data`;
CREATE TABLE `bus_bound_device_his_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `base_bound_device_no` int(11) DEFAULT NULL COMMENT '终端序号-测量点号（1-2040',
  `bus_bound_device_his_data_voltage` decimal(7,2) DEFAULT NULL COMMENT '电压',
  `bus_bound_device_his_data_electric` decimal(7,4) DEFAULT NULL COMMENT '电流',
  `bus_bound_device_his_data_power` decimal(7,4) DEFAULT NULL COMMENT '功率',
  `bus_bound_device_his_data_electricity` decimal(9,2) DEFAULT NULL COMMENT '电量',
  `bus_bound_device_his_data_swich` int(1) DEFAULT NULL COMMENT '开关状态0开1关',
  `bus_bound_device_his_data_dev_type` tinyint(3) DEFAULT NULL COMMENT '类型：1主灯2辅灯',
  `bus_bound_device_his_data_value` int(11) DEFAULT NULL COMMENT '亮度',
  `bus_bound_device_his_data_query_time` datetime DEFAULT NULL COMMENT '终端抄读时间',
  `bus_bound_device_his_data_day_time` datetime DEFAULT NULL COMMENT '数据冻结时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='终端设备历史信息';

-- ----------------------------
--  Records of `bus_bound_device_his_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_bound_device_his_data` VALUES (null, null, null, null, null, null, null, '209', '37020001', '3', '234.00', '0.1060', '0.5500', '0.00', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '210', '37020001', '3', '234.00', '0.0430', '0.3400', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '213', '37020001', '5', '234.10', '0.1080', '0.5500', '0.02', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '214', '37020001', '5', '234.10', '0.0420', '0.3300', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '215', '37020001', '6', '234.10', '0.1050', '0.5200', '0.00', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '216', '37020001', '6', '234.10', '0.0410', '0.3200', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '217', '37020001', '7', '234.00', '0.1080', '0.5200', '0.01', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '218', '37020001', '7', '234.00', '0.0430', '0.3200', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '219', '37020001', '8', '234.00', '0.1050', '0.5500', '0.01', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '220', '37020001', '8', '234.00', '0.0470', '0.3400', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '221', '37020001', '9', '234.70', '0.1070', '0.5500', '0.00', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '222', '37020001', '9', '234.70', '0.0450', '0.3300', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '223', '37020001', '10', '234.20', '0.1010', '0.5300', '0.00', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '224', '37020001', '10', '234.20', '0.0420', '0.3400', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '225', '37020001', '11', '234.20', '0.1050', '0.5300', '0.01', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '226', '37020001', '11', '234.20', '0.0420', '0.3200', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '227', '37020001', '12', '234.20', '0.0000', '0.0000', '0.09', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '228', '37020001', '12', '234.20', '0.0000', '0.0000', '128.00', '0', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '235', '37020001', '4', '233.80', '0.1010', '0.5100', '0.04', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '236', '37020001', '4', '233.80', '0.0450', '0.3100', '0.01', '128', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '237', '37020001', '13', '233.80', '0.1010', '0.5100', '0.04', '128', '1', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00'), (null, null, null, null, null, null, null, '238', '37020001', '13', '233.80', '0.0450', '0.3100', '0.01', '128', '2', null, '2016-04-19 09:22:00', '2016-04-18 00:00:00');
COMMIT;

-- ----------------------------
--  Table structure for `bus_bound_device_treploss_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_bound_device_treploss_data`;
CREATE TABLE `bus_bound_device_treploss_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `bus_bound_device_data_read_percent` decimal(5,2) DEFAULT NULL COMMENT '抄读成功率',
  `bus_bound_device_data_loss_percent` decimal(5,2) DEFAULT NULL COMMENT '线损率',
  `bus_bound_device_data_total_electricity` decimal(9,2) DEFAULT NULL COMMENT '总表电量',
  `bus_bound_device_data_part_electricity` decimal(9,2) DEFAULT NULL COMMENT '分表电量',
  `bus_bound_device_data_read_total` int(11) DEFAULT NULL COMMENT '设备总数',
  `bus_bound_device_data_read_value` int(11) DEFAULT NULL COMMENT '抄读成功总数',
  `bus_bound_device_data_loss_type` tinyint(3) DEFAULT NULL COMMENT '类型：1路灯2充电桩3广告牌',
  `bus_bound_device_data_day_time` datetime DEFAULT NULL COMMENT '数据冻结时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='终端设备统计信息';

-- ----------------------------
--  Records of `bus_bound_device_treploss_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_bound_device_treploss_data` VALUES (null, null, null, null, null, null, '1', '5', '1', '1.00', null, '0.00', '0.00', '0', '0', '1', '2016-05-19 00:00:00'), (null, null, null, null, null, null, '1', '6', '1', '2.00', null, '0.00', '0.00', '0', '0', '2', '2016-05-19 00:00:00'), (null, null, null, null, null, null, '1', '7', '1', '3.00', null, '0.00', '0.00', '0', '0', '3', '2016-05-19 00:00:00');
COMMIT;

-- ----------------------------
--  Table structure for `bus_charging_pile_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_charging_pile_data`;
CREATE TABLE `bus_charging_pile_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_charging_pile_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `bus_charging_pile_data_voltage` decimal(7,2) DEFAULT NULL COMMENT '电压',
  `bus_charging_pile_data_electric` decimal(7,4) DEFAULT NULL COMMENT '电流',
  `bus_charging_pile_data_power` decimal(7,4) DEFAULT NULL COMMENT '功率',
  `bus_charging_pile_data_electricity` decimal(9,2) DEFAULT NULL COMMENT '电量',
  `bus_charging_pile_data_state` tinyint(1) DEFAULT NULL COMMENT '状态：0使用1空闲',
  `bus_charging_pile_data_warning_state` tinyint(1) DEFAULT NULL COMMENT '报警状态：默认0正常，1损坏',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `bus_charging_pile_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_charging_pile_data` VALUES ('2016-04-27 14:22:55', null, null, null, '0', '1', '1', '1', '327327', '1.00', '1.0000', '1.0000', '1.00', '1', '1'), (null, null, null, null, '1', null, null, '2', '999999', null, null, null, null, null, null);
COMMIT;

-- ----------------------------
--  Table structure for `bus_charging_pile_his_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_charging_pile_his_data`;
CREATE TABLE `bus_charging_pile_his_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_charging_pile_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `bus_charging_pile_his_data_voltage` decimal(7,2) DEFAULT NULL COMMENT '电压',
  `bus_charging_pile_his_data_electric` decimal(7,4) DEFAULT NULL COMMENT '电流',
  `bus_charging_pile_his_data_power` decimal(7,4) DEFAULT NULL COMMENT '功率',
  `bus_charging_pile_his_data_electricity` decimal(9,2) DEFAULT NULL COMMENT '电量',
  `bus_charging_pile_his_data_query_time` datetime DEFAULT NULL COMMENT '终端抄读时间',
  `bus_charging_pile_his_data_day_time` datetime DEFAULT NULL COMMENT '数据冻结时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='充电桩历史信息';

-- ----------------------------
--  Records of `bus_charging_pile_his_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_charging_pile_his_data` VALUES ('2016-04-27 15:59:58', null, null, null, '0', null, null, '1', '327327', '1.00', '1.0000', '1.0000', '1.00', '2016-04-27 16:00:52', '2016-04-27 16:00:56');
COMMIT;

-- ----------------------------
--  Table structure for `bus_log`
-- ----------------------------
DROP TABLE IF EXISTS `bus_log`;
CREATE TABLE `bus_log` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bus_log_content` text COMMENT '报文内容\n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `bus_log`
-- ----------------------------
BEGIN;
INSERT INTO `bus_log` VALUES ('2016-04-28 11:04:39', null, 'zcl', null, '0', '1', '1', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `bus_terminal_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_terminal_data`;
CREATE TABLE `bus_terminal_data` (
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_update_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `bus_terminal_data_switch` tinyint(3) DEFAULT '0' COMMENT '总控开关（拉合闸状态  0无状态，1拉闸，2合闸，3异常状态）',
  `bus_terminal_data_loop` varchar(8) DEFAULT NULL COMMENT '回路状态（8位二进制，异常为1）',
  `bus_terminal_data_model` tinyint(3) DEFAULT '1' COMMENT '控制模式：1继电器控制，2载波广播控制',
  `bus_terminal_data_state` tinyint(1) DEFAULT '1' COMMENT '在线状态 0在线1不在线',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='集中控制器实时数据信息';
delimiter ;;
CREATE TRIGGER `synchronization_light_switch` AFTER UPDATE ON `bus_terminal_data` FOR EACH ROW BEGIN
	
	IF new.bus_terminal_data_switch != old.bus_terminal_data_switch THEN	/*1拉闸，2合闸*/
		IF new.bus_terminal_data_switch=1 THEN
			UPDATE bus_bound_device_data set bus_bound_device_data_swich = 127 ,last_update_at=CURRENT_TIMESTAMP()  WHERE new.base_terminal_addr=base_terminal_addr;  /*开关状态0开1关*/
		ELSEIF new.bus_terminal_data_switch=2 THEN
			UPDATE bus_bound_device_data set bus_bound_device_data_swich = 128 ,last_update_at=CURRENT_TIMESTAMP()  WHERE new.base_terminal_addr=base_terminal_addr;
		END IF;
	END IF;
END;
 ;;
delimiter ;

-- ----------------------------
--  Records of `bus_terminal_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_terminal_data` VALUES ('2016-04-26 10:32:35', null, null, null, '0', '1', '1', '1', '37020001', '2', '3', '1', '0'), ('2016-05-09 09:54:37', '2016-05-09 09:54:37', null, null, '1', null, null, '2', '38020001', null, null, null, '1'), ('2016-06-03 13:16:28', '2016-06-03 13:16:28', null, null, '0', null, null, '3', '05910001', '0', '3', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `bus_terminal_date_set`
-- ----------------------------
DROP TABLE IF EXISTS `bus_terminal_date_set`;
CREATE TABLE `bus_terminal_date_set` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_id` bigint(20) DEFAULT NULL COMMENT '集中控制器id',
  `bus_terminal_date_set_name` varchar(20) DEFAULT NULL COMMENT '名字\n',
  `bus_terminal_date_set_no` int(11) DEFAULT NULL COMMENT '序号',
  `bus_terminal_date_set_level` tinyint(3) DEFAULT NULL COMMENT '优先级 默认0 普通 1紧急',
  `bus_terminal_date_set_open` varchar(10) DEFAULT NULL COMMENT '开灯时间（时分秒）',
  `bus_terminal_date_set_close` varchar(255) DEFAULT NULL COMMENT '关灯时间',
  `bus_terminal_date_set_begin` datetime DEFAULT NULL COMMENT '有效时间起（年月日时分秒）',
  `bus_terminal_date_set_end` datetime DEFAULT NULL COMMENT '有效时间止',
  `bus_terminal_date_set_is_year` tinyint(1) DEFAULT NULL COMMENT '年通用类型：1通用0不通用，默认0',
  `bus_terminal_date_set_default` tinyint(1) DEFAULT NULL COMMENT '是否默认数据 0否1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='时段任务设置';

-- ----------------------------
--  Records of `bus_terminal_date_set`
-- ----------------------------
BEGIN;
INSERT INTO `bus_terminal_date_set` VALUES (null, null, null, null, '0', null, null, '1', '2', '时段-1', '1', '0', '17:30', '06:00', '2016-06-06 00:00:00', '2016-06-06 00:00:00', '0', '0'), (null, null, null, null, '0', null, null, '2', '2', '时段-1', '1', '0', '17:30', '06:00', '2016-06-06 00:00:00', '2016-06-06 00:00:00', '0', '0'), (null, null, null, null, '0', null, null, '3', '5', '时段-1', '1', '0', '17:30', '08:00', '2016-06-06 00:00:00', '2016-06-06 00:00:00', '0', '0'), (null, null, null, null, '0', null, null, '4', '6', '时段-1', '1', '0', '17:30', '06:00', '2016-06-06 00:00:00', '2016-06-06 00:00:00', '0', '0'), (null, null, null, null, '0', null, null, '5', '6', '时段-1', '1', '0', '17:30', '06:00', '2016-06-06 00:00:00', '2016-06-06 00:00:00', '0', '0');
COMMIT;

-- ----------------------------
--  Table structure for `bus_terminal_energy_set`
-- ----------------------------
DROP TABLE IF EXISTS `bus_terminal_energy_set`;
CREATE TABLE `bus_terminal_energy_set` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bus_terminal_energy_set_begin` datetime DEFAULT NULL,
  `bus_terminal_energy_set_end` datetime DEFAULT NULL COMMENT '结束时间',
  `base_group_id` bigint(20) DEFAULT NULL COMMENT '分组id\n',
  `bus_terminal_energy_set_type` tinyint(3) DEFAULT NULL,
  `bus_terminal_energy_set_value` int(11) DEFAULT NULL COMMENT '亮度值',
  `base_ter_date_set_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='集中器节能设置';

-- ----------------------------
--  Records of `bus_terminal_energy_set`
-- ----------------------------
BEGIN;
INSERT INTO `bus_terminal_energy_set` VALUES (null, null, null, null, '0', '无', null, '1', '2016-06-06 04:00:00', '2016-06-06 05:00:00', '0', '0', '10', '3');
COMMIT;

-- ----------------------------
--  Table structure for `bus_terminal_his_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_terminal_his_data`;
CREATE TABLE `bus_terminal_his_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `bus_terminal_his_data_switch` tinyint(3) DEFAULT NULL COMMENT '总控开关（拉合闸状态  0无状态，1拉闸，2合闸，3异常状态）',
  `bus_terminal_his_data_loop` varchar(8) DEFAULT NULL COMMENT '回路状态（8位二进制，异常为1）',
  `bus_terminal_his_data_model` tinyint(3) DEFAULT NULL COMMENT '控制模式：1继电器控制，2载波广播控制',
  `bus_terminal_his_data_state` tinyint(1) DEFAULT NULL COMMENT '在线状态 0在线1不在线',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='集中控制器历史数据信息';

-- ----------------------------
--  Records of `bus_terminal_his_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_terminal_his_data` VALUES ('2016-04-26 11:35:05', null, null, null, '0', '1', '1', '1', '37020001', '1', '7', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `bus_terminal_total_his_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_terminal_total_his_data`;
CREATE TABLE `bus_terminal_total_his_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `base_bound_device_no` int(11) DEFAULT NULL COMMENT '终端序号-测量点号（1-2040',
  `bus_terminal_total_his_data_tariff_no` tinyint(3) DEFAULT NULL COMMENT '费率类型 0=总费率',
  `bus_terminal_total_his_data_electricity` decimal(19,5) DEFAULT NULL COMMENT '电量',
  `bus_terminal_total_his_data_query_time` datetime DEFAULT NULL COMMENT '终端抄读时间',
  `bus_terminal_total_his_data_day_time` datetime DEFAULT NULL COMMENT '数据冻结时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='终端电量历史信息';

-- ----------------------------
--  Table structure for `bus_terminal_warning_set`
-- ----------------------------
DROP TABLE IF EXISTS `bus_terminal_warning_set`;
CREATE TABLE `bus_terminal_warning_set` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bus_terminal_warning_power_upper` decimal(5,2) DEFAULT NULL COMMENT '功率上限',
  `bus_terminal_warning_power_limit` decimal(5,2) DEFAULT NULL COMMENT '功率下限',
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='集中控制器报警设置';

-- ----------------------------
--  Records of `bus_terminal_warning_set`
-- ----------------------------
BEGIN;
INSERT INTO `bus_terminal_warning_set` VALUES (null, null, null, null, '0', '1', '1', '1', '1.00', '1.00', '1');
COMMIT;

-- ----------------------------
--  Table structure for `bus_warning_his_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_warning_his_data`;
CREATE TABLE `bus_warning_his_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bus_warning_his_data_warning_state` tinyint(1) DEFAULT NULL COMMENT '报警状态：默认0正常，1损坏',
  `bus_warning_his_data_dev_type` tinyint(3) DEFAULT NULL COMMENT '类型：1主灯2辅灯',
  `base_terminal_addr` varchar(20) DEFAULT NULL COMMENT '集中器地址',
  `base_bound_device_no` int(11) DEFAULT NULL COMMENT '终端序号-测量点号（1-2040',
  `base_warning_his_data_confirm` tinyint(1) DEFAULT '1' COMMENT ' 报警设备修复确认 0 未确认  1确认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `bus_warning_his_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_warning_his_data` VALUES ('2016-04-26 16:13:50', null, null, 'Pippo', '0', '1', '1', '1', '1', '1', '37020001', '3', '1');
COMMIT;

-- ----------------------------
--  Table structure for `bus_wifi_data`
-- ----------------------------
DROP TABLE IF EXISTS `bus_wifi_data`;
CREATE TABLE `bus_wifi_data` (
  `create_at` datetime DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bus_wifi_data_warning_state` tinyint(1) DEFAULT NULL COMMENT '报警状态：默认0正常，1损坏',
  `base_wifi_devaddr` varchar(45) DEFAULT NULL COMMENT '设备地址',
  `base_wifi_id` bigint(20) DEFAULT NULL COMMENT 'wifiid\n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `bus_wifi_data`
-- ----------------------------
BEGIN;
INSERT INTO `bus_wifi_data` VALUES ('2016-04-28 10:17:53', '2016-04-28 10:17:57', null, null, '0', '1', '1', '1', '1', 'zclwifi', '1'), (null, null, null, null, null, null, null, '2', null, '123', null);
COMMIT;

-- ----------------------------
--  Table structure for `job_scheduler`
-- ----------------------------
DROP TABLE IF EXISTS `job_scheduler`;
CREATE TABLE `job_scheduler` (
  `create_at` datetime DEFAULT NULL,
  `create_by` varchar(50) DEFAULT NULL,
  `last_update_at` datetime DEFAULT NULL,
  `last_update_by` varchar(50) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `rate` int(10) DEFAULT NULL COMMENT '频率',
  `begin_time` datetime DEFAULT NULL,
  `type` tinyint(3) DEFAULT '1' COMMENT '类型1-日冻结',
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='定时任务表\n';

-- ----------------------------
--  Records of `job_scheduler`
-- ----------------------------
BEGIN;
INSERT INTO `job_scheduler` VALUES (null, null, null, null, '0', '11', '11', '2016-04-18 11:02:25', '1', '21');
COMMIT;

-- ----------------------------
--  Table structure for `s_dept`
-- ----------------------------
DROP TABLE IF EXISTS `s_dept`;
CREATE TABLE `s_dept` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL COMMENT '部门名称',
  `parent_name` varchar(20) DEFAULT NULL COMMENT '父节点名称',
  `code` varchar(20) DEFAULT NULL COMMENT '编码',
  `memo` varchar(255) DEFAULT NULL COMMENT '备注',
  `parent_id` bigint(20) NOT NULL COMMENT '父资源',
  `is_deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='部门';

-- ----------------------------
--  Records of `s_dept`
-- ----------------------------
BEGIN;
INSERT INTO `s_dept` VALUES ('1', '系统管理', '所有部门', '00', '系统默认', '-1', '0'), ('2', '2', '2', '2', '2', '2', '1'), ('3', '部门1', '所有部门', '0101', '部门9时开始看看', '-1', '1'), ('4', '部门1-2', '部门1', '1', '1', '3', '1'), ('5', '部门2', '所有部门', '02', '22', '-1', '0'), ('6', 'qq', '部门1', 'qq', 'qq', '3', '1'), ('7', '22', '部门2', '222', '22', '5', '1'), ('8', '部门3', '所有部门', '部门3', '部门3', '-1', '1'), ('9', '部门1', '所有部门', '01', '部门1', '-1', '0'), ('10', '部门3', '所有部门', '03', '部门3', '-1', '0'), ('11', '部门3-1q', '部门3', '0310', '部门0312', '10', '0'), ('12', '部门3-1-1', '部门3-1', '0311', '2321', '11', '0'), ('13', 'bumw我', '所有部门', '0312', null, '-1', '0'), ('14', 'sq', '部门3-1q', 's', 's', '11', '1'), ('15', 'w', '部门3-1q', '111w', 'w', '11', '1'), ('16', 'w', '部门3-1q', 'ww', 'ww', '11', '1'), ('17', '宋园路', '部门1', '1111', '111', '9', '0'), ('18', '123456i', '部门1', 'i234', null, '9', '0');
COMMIT;

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
  `dept_id` bigint(20) NOT NULL COMMENT '父资源',
  `login_name` varchar(30) DEFAULT NULL COMMENT '登录账号',
  `is_deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='部门';

-- ----------------------------
--  Records of `s_emp`
-- ----------------------------
BEGIN;
INSERT INTO `s_emp` VALUES ('1', '管理员用户', '1', '1', '1', '1', '1', 'admin', '0'), ('2', '吕999', '3213pp', '12333322222', null, '3', '12', '21010013', '1'), ('3', '222', '22222', '12233222222', null, '4', '-1', '21010014', '1'), ('4', '12345', '问1321', '18382727276', null, '5', '9', '21010015', '1'), ('5', '12345678', '阿斯顿飞规划局快乐；', '14456789012', null, '6', '-1', '21010016', '0'), ('6', '3213213', '2223232', '13899922821', null, '7', '9', '21010017', '0'), ('7', 'www', '1111', '13988277222', null, '8', '13', '21010018', '0'), ('8', '管理员1', '11111', '13899298271', null, '9', '1', '21010019', '0'), ('9', '21', '23456', '13828282828', null, '10', '17', '21010020', '0');
COMMIT;

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
INSERT INTO `s_res` VALUES ('1', 'smart.light.web', '10', '系统管理', 'sys', '', '0', '0', '1'), ('2', 'smart.light.web', '10', '部门管理', 'sysDept', '', '1', '0', '1'), ('3', 'smart.light.web', '11', '角色管理', 'employeeRole', '', '1', '0', '1'), ('4', 'smart.light.web', '12', '员工管理', 'sysEmp', '', '1', '0', '1'), ('5', 'smart.light.web', '20', '基础资料', 'base', '', '0', '0', '1'), ('6', 'smart.light.web', '21', '区域管理', 'baseArea', '', '5', '0', '1'), ('7', 'smart.light.web', '22', '集中控制器', 'baseTerminal', '', '5', '0', '1'), ('8', 'smart.light.web', '23', '终端设备', 'baseBoundDevice', '', '5', '0', '1'), ('9', 'smart.light.web', '24', '充电桩查询', 'baseChargingPile', '', '5', '0', '1'), ('10', 'smart.light.web', '25', '广告牌查询', 'baseBillBoard', '', '5', '0', '1'), ('11', 'smart.light.web', '26', '摄像头查询', 'baseCamera', '', '5', '0', '1'), ('12', 'smart.light.web', '27', 'wifi查询', 'baseWifi', '', '5', '0', '1'), ('13', 'smart.light.web', '29', '分组管理', 'baseGroup', '', '14', '0', '1'), ('14', 'smart.light.web', '30', '参数设置', 'bus', '', '0', '0', '1'), ('15', 'smart.light.web', '31', '时段任务', 'busTerminalDateSet', '', '14', '0', '1'), ('16', 'smart.light.web', '32', '集中器节能设置', 'busTerminalEnergySet', '', '14', '1', '1'), ('17', 'smart.light.web', '51', '集中控制器', 'busTerminalData', '', '33', '0', '1'), ('18', 'smart.light.web', '61', '集中控制器', 'busTerminalHisData', '', '34', '0', '1'), ('19', 'smart.light.web', '52', '终端设备', 'busBoundDeviceData', '', '33', '0', '1'), ('20', 'smart.light.web', '62', '终端设备', 'busBoundDeviceHisData', '', '34', '0', '1'), ('21', 'smart.light.web', '37', '报警设置', 'busTerminalWarningSet', '', '14', '1', '1'), ('22', 'smart.light.web', '63', '报警历史', 'busWarningHisData', '', '34', '0', '1'), ('24', 'smart.light.web', '53', '充电桩设备', 'busChargingPileData', '', '33', '0', '1'), ('25', 'smart.light.web', '64', '充电桩设备', 'busChargingPileHisData', '', '34', '0', '1'), ('26', 'smart.light.web', '54', '广告牌', 'busBillBoardData', '', '33', '0', '1'), ('27', 'smart.light.web', '55', 'wifi', 'busWifiData', '', '33', '0', '1'), ('28', 'smart.light.web', '81', '定时任务', 'jobScheduler', '', '36', '0', '1'), ('29', 'smart.light.web', '82', '操作日志', 'busLog', '', '36', '0', '1'), ('30', 'smart.light.web', '28', '档案同步', 'baseDeviceSync', '', '14', '0', '1'), ('31', 'smart.light.web', '60', '通信功能', 'tabCaly', '', '0', '1', '1'), ('32', 'smart.light.web', '83', '通信功能', 'test', '', '31', '1', '1'), ('33', 'smart.light.web', '50', '实时数据', 'currentdata', '', '0', '0', '1'), ('34', 'smart.light.web', '60', '历史数据', 'hisdata', '', '0', '0', '1'), ('35', 'smart.light.web', '70', '数据分析', 'data', '', '0', '0', '1'), ('36', 'smart.light.web', '80', '系统设置', 'sysset', '', '0', '0', '1'), ('37', 'smart.light.web', '71', '线损查询', 'chart', 'chartloos#1', '35', '0', '1'), ('38', 'smart.light.web', '72', '用电量查询', 'chart', 'chartelectricity#1', '35', '0', '1'), ('39', 'smart.light.web', '73', '在线率查询', 'chart', 'chartread#1', '35', '0', '1'), ('40', 'smart.light.web', '74', '线损分析', 'chart', null, '35', '0', '1'), ('41', 'smart.light.web', '75', '用电量分析', 'chart', null, '35', '0', '1');
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
INSERT INTO `s_role` VALUES ('1', 'smart.light.web', '0', '01', '管理员', null, null, null, null, '0'), ('2', 'smart.light.web', '0', '02', '操作员', null, null, null, null, '0'), ('3', 'smart.light.web', null, '03', '看v', null, null, null, null, '1'), ('4', 'smart.light.web', null, '04', '2222', null, null, null, null, '0'), ('5', 'smart.light.web', null, '05', '111', null, null, null, null, '0');
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
INSERT INTO `s_user` VALUES ('1', 'admin', '21218cca77804d2ba1922c33e0151105', '1', '12333322222', null, null, null, '1', '管理员用户', '192', '2016-06-12 09:43:48', '0:0:0:0:0:0:0:1', null, '2016-04-13 15:21:09', null, '2016-04-13 15:21:09', null, '0'), ('4', '21010014', '111', '1', '12233222222', null, null, null, '2', '222', '0', null, null, null, '2016-04-13 15:32:44', null, '2016-04-13 15:32:44', null, '0'), ('5', '21010015', '21218cca77804d2ba1922c33e0151105', '1', '18382727276', null, null, null, '2', '12345', '0', null, null, null, '2016-04-13 15:54:48', null, '2016-04-13 15:54:48', null, '0'), ('6', '21010016', '21218cca77804d2ba1922c33e0151105', '1', '14456789012', null, null, null, '1', '12345678', '0', null, null, null, '2016-04-13 19:01:04', null, '2016-04-13 19:01:04', null, '0'), ('7', '21010017', '21218cca77804d2ba1922c33e0151105', '1', '13899922821', null, null, null, '1', '3213213', '0', null, null, null, '2016-04-13 19:01:29', null, '2016-04-13 19:01:29', null, '0'), ('8', '21010018', '21218cca77804d2ba1922c33e0151105', '1', '13988277222', null, null, null, '1', 'www', '0', null, null, null, '2016-04-14 15:13:11', null, '2016-04-14 15:13:11', null, '0'), ('9', '21010019', '21218cca77804d2ba1922c33e0151105', '1', '13899298271', null, null, null, '1', '管理员1', '1', '2016-04-18 14:15:46', '0:0:0:0:0:0:0:1', null, '2016-04-18 14:15:34', null, '2016-04-18 14:15:34', null, '0'), ('10', '21010020', '21218cca77804d2ba1922c33e0151105', '1', '13828282828', null, null, null, '1', '21', '0', null, null, null, '2016-06-03 15:11:48', null, '2016-06-03 15:11:48', null, '0');
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
--  Table structure for `sequence`
-- ----------------------------
DROP TABLE IF EXISTS `sequence`;
CREATE TABLE `sequence` (
  `name` varchar(50) NOT NULL,
  `current_value` int(11) unsigned NOT NULL,
  `increment` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `sequence2`
-- ----------------------------
BEGIN;
INSERT INTO `sequence2` VALUES ('dd11', '4', '2016-03-01', '1'), ('dd17', '1', '2016-03-09', '1'), ('dd9', '12', '2016-02-28', '1');
COMMIT;

-- ----------------------------
--  View structure for `v_area_bill`
-- ----------------------------
DROP VIEW IF EXISTS `v_area_bill`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_area_bill` AS select `a`.`id` AS `id`,`a`.`base_area_name` AS `baseAreaName`,`a`.`base_area_pid` AS `baseAreaPid`,'' AS `baseTerminalSmsfrom`,0 AS `isArea` from `base_area` `a` where (`a`.`is_deleted` = 0) union all select `t2`.`id` AS `tid`,`t2`.`base_bill_board_code` AS `baseTerminalAddr`,`t`.`base_area_id` AS `baseAreaPid`,`t2`.`base_bill_board_devaddr` AS `baseTerminalSmsfrom`,1 AS `isArea` from ((`base_terminal` `t` left join `base_bound_device` `t1` on((`t`.`id` = `t1`.`base_terminal_id`))) left join `base_bill_board` `t2` on((`t1`.`id` = `t2`.`base_bound_device_id`))) where ((`t`.`is_deleted` = 0) and (`t1`.`is_deleted` = 0) and (`t2`.`is_deleted` = 0));

-- ----------------------------
--  View structure for `v_area_camera`
-- ----------------------------
DROP VIEW IF EXISTS `v_area_camera`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_area_camera` AS select `a`.`id` AS `id`,`a`.`base_area_name` AS `baseAreaName`,`a`.`base_area_pid` AS `baseAreaPid`,'' AS `baseTerminalSmsfrom`,0 AS `isArea` from `base_area` `a` where (`a`.`is_deleted` = 0) union all select `t2`.`id` AS `tid`,`t2`.`base_bound_devicec_code` AS `baseTerminalAddr`,`t`.`base_area_id` AS `baseAreaPid`,`t2`.`base_camera_ip` AS `baseTerminalSmsfrom`,1 AS `isArea` from ((`base_terminal` `t` left join `base_bound_device` `t1` on((`t`.`id` = `t1`.`base_terminal_id`))) left join `base_camera` `t2` on((`t1`.`id` = `t2`.`base_bound_device_id`))) where ((`t`.`is_deleted` = 0) and (`t1`.`is_deleted` = 0) and (`t2`.`is_deleted` = 0));

-- ----------------------------
--  View structure for `v_area_pile`
-- ----------------------------
DROP VIEW IF EXISTS `v_area_pile`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_area_pile` AS select `a`.`id` AS `id`,`a`.`base_area_name` AS `baseAreaName`,`a`.`base_area_pid` AS `baseAreaPid`,'' AS `baseTerminalSmsfrom`,0 AS `isArea` from `base_area` `a` where (`a`.`is_deleted` = 0) union all select `t2`.`id` AS `tid`,`t2`.`base_bound_devicec_code` AS `baseTerminalAddr`,`t`.`base_area_id` AS `baseAreaPid`,`t2`.`base_charging_pile_devaddr` AS `baseTerminalSmsfrom`,1 AS `isArea` from ((`base_terminal` `t` left join `base_bound_device` `t1` on((`t`.`id` = `t1`.`base_terminal_id`))) left join `base_charging_pile` `t2` on((`t1`.`id` = `t2`.`base_bound_device_id`))) where ((`t`.`is_deleted` = 0) and (`t1`.`is_deleted` = 0) and (`t2`.`is_deleted` = 0));

-- ----------------------------
--  View structure for `v_area_terminal`
-- ----------------------------
DROP VIEW IF EXISTS `v_area_terminal`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_area_terminal` AS select `a`.`id` AS `id`,`a`.`base_area_name` AS `baseAreaName`,`a`.`base_area_pid` AS `baseAreaPid`,'' AS `baseTerminalSmsfrom`,'0' AS `isArea`,'' AS `lng`,'' AS `lat`,'' AS `looptype`,'' AS `state`,'' AS `switch` from `base_area` `a` where (`a`.`is_deleted` = 0) union all select `t`.`id` AS `tid`,`t`.`base_terminal_addr` AS `baseTerminalAddr`,`t`.`base_area_id` AS `baseAreaPid`,`t`.`base_terminal_sms` AS `baseTerminalSmsfrom`,'1' AS `isArea`,`t`.`base_terminal_Lng` AS `lng`,`t`.`base_terminal_lat` AS `lat`,`d`.`bus_terminal_data_loop` AS `looptype`,`d`.`bus_terminal_data_state` AS `state`,`d`.`bus_terminal_data_switch` AS `switch` from (`base_terminal` `t` left join `bus_terminal_data` `d` on((`d`.`base_terminal_addr` = `t`.`base_terminal_addr`))) where (`t`.`is_deleted` = 0);

-- ----------------------------
--  View structure for `v_area_wifi`
-- ----------------------------
DROP VIEW IF EXISTS `v_area_wifi`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_area_wifi` AS select `a`.`id` AS `id`,`a`.`base_area_name` AS `baseAreaName`,`a`.`base_area_pid` AS `baseAreaPid`,'' AS `baseTerminalSmsfrom`,0 AS `isArea` from `base_area` `a` where (`a`.`is_deleted` = 0) union all select `t2`.`id` AS `tid`,`t2`.`base_bound_devicec_code` AS `baseTerminalAddr`,`t`.`base_area_id` AS `baseAreaPid`,`t2`.`base_wifi_devaddr` AS `baseTerminalSmsfrom`,1 AS `isArea` from ((`base_terminal` `t` left join `base_bound_device` `t1` on((`t`.`id` = `t1`.`base_terminal_id`))) left join `base_wifi` `t2` on((`t1`.`id` = `t2`.`base_bound_device_id`))) where ((`t`.`is_deleted` = 0) and (`t1`.`is_deleted` = 0) and (`t2`.`is_deleted` = 0));

-- ----------------------------
--  View structure for `v_terminal_device`
-- ----------------------------
DROP VIEW IF EXISTS `v_terminal_device`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_terminal_device` AS select `t`.`id` AS `tid`,`d`.`id` AS `mid`,`t`.`base_terminal_addr` AS `taddr`,`t`.`base_terminal_Lng` AS `tlng`,`t`.`base_terminal_lat` AS `tlat`,`d`.`base_bound_device_no` AS `mno`,`d`.`base_bound_devicec_addr` AS `maddr`,`d`.`base_bound_devicec_lng` AS `mlng`,`d`.`base_bound_devicec_lat` AS `mlat`,`d`.`base_bound_devicec_code` AS `mcode`,(select `tb`.`bus_bound_device_data_swich` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zswich`,(select `tb`.`bus_bound_device_data_value` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zlevel`,(select `tb`.`bus_bound_device_data_swich` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `fswich`,(select `tb`.`bus_bound_device_data_value` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `flevel`,(select `tb`.`bus_bound_device_data_electric` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zelectric`,(select `tb`.`bus_bound_device_data_electricity` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zelectricity`,(select `tb`.`bus_bound_device_data_electric` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `felectric`,(select `tb`.`bus_bound_device_data_electricity` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `felectricity`,(select `tb`.`bus_bound_device_data_power` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zpower`,(select `tb`.`bus_bound_device_data_voltage` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zvoltage`,(select `tb`.`bus_bound_device_data_power` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `fpower`,(select `tb`.`bus_bound_device_data_voltage` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `fvoltage`,(select `tb`.`bus_bound_device_data_waring_state` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 1)) order by `tb`.`last_update_at` desc limit 1) AS `zstate`,(select `tb`.`bus_bound_device_data_waring_state` from `bus_bound_device_data` `tb` where ((`tb`.`base_terminal_addr` = `t`.`base_terminal_addr`) and (`tb`.`base_bound_device_addr` = `d`.`base_bound_devicec_addr`) and (`tb`.`bus_bound_device_data_dev_type` = 0)) order by `tb`.`last_update_at` desc limit 1) AS `fstate`,(select count(`t`.`id`) from `base_camera` `t` where (`t`.`base_bound_device_id` = `d`.`id`)) AS `cameranum`,(select count(`t1`.`id`) from `base_bill_board` `t1` where (`t1`.`base_bound_device_id` = `d`.`id`)) AS `boardnum`,(select count(`t2`.`id`) from `base_charging_pile` `t2` where (`t2`.`base_bound_device_id` = `d`.`id`)) AS `pilenum`,(select count(`t3`.`id`) from `base_wifi` `t3` where (`t3`.`base_bound_device_id` = `d`.`id`)) AS `wifinum` from (`base_bound_device` `d` left join `base_terminal` `t` on((`d`.`base_terminal_id` = `t`.`id`))) where ((`t`.`is_deleted` = 0) and (`d`.`is_deleted` = 0)) order by `taddr`,`mno`;

-- ----------------------------
--  Procedure structure for `trep_loss`
-- ----------------------------
DROP PROCEDURE IF EXISTS `trep_loss`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `trep_loss`(IN cDate datetime)
BEGIN

	DECLARE totalUsedE DECIMAL DEFAULT 0;
	DECLARE logicAddr CHARACTER;
	DECLARE totalTime DATE;
	DECLARE totalLightNums,readLightNums,totalPileNums,readPileNums,totalBillNums,readBillNums INT;
	DECLARE deptID,logicAddrId,tmpTrepLossID BIGINT;
	DECLARE tmpLightUsedE,tmpPileUsedE,tmpBillUsedE,tmpMeterUsedE,tmpTotalPartE DECIMAL DEFAULT 0;
	DECLARE tmpLoss,tmpLightP,tmpPileP,tmpBillP DECIMAL;
	DECLARE no_more_basearea INT DEFAULT 0;
	DECLARE  cur_area CURSOR FOR  SELECT DISTINCT base_area_id FROM base_terminal;  /*First: Delcare a cursor,首先这里对游标进行定义*/
	DECLARE  CONTINUE HANDLER FOR NOT FOUND  SET  no_more_basearea = 1; /*when "not found" occur,just continue,这个是个条件处理,针对NOT FOUND的条件*/

	OPEN cur_area;
	FETCH cur_area INTO deptID;
	REPEAT
		IF NOT no_more_basearea THEN
			select id,base_terminal_addr INTO logicAddrId,logicAddr from  base_terminal where base_area_id = deptID;
			IF (logicAddr IS NOT NULL) THEN
					select count(t.base_bound_device_no) INTO totalLightNums from base_bound_device t 
							where t.base_terminal_addr=logicAddr and t.base_terminal_id=logicAddrId and t.base_bound_device_no!=2;
					/*从电量表中取对应集中器的测量点为2的数据为总表数据，进行计算总表用电量*/
					CALL trep_loss_total_meter(cDate,logicAddr,totalUsedE);
					/*调用存储过程执行计算所有某集中器下路灯用电量*/
					CALL trep_loss_part_light(cDate,logicAddr,readLightNums,tmpLightUsedE);
					/*计算充电桩总数*/
					select count(1) INTO totalPileNums from base_bound_device t RIGHT join base_charging_pile t1 ON t.id=t1.base_bound_device_id 
							where t.base_terminal_addr=logicAddr and t.base_terminal_id=logicAddrId and t.base_bound_device_no!=2;
					/*调用存储过程执行计算所有某集中器下充电桩用电量*/
					CALL trep_loss_part_pile(cDate,logicAddr,readPileNums,tmpPileUsedE);
					
					/*计算广告牌总数*/
					select count(1) INTO totalBillNums from base_bound_device t RIGHT join base_bill_board t1 ON t.id=t1.base_bound_device_id 
							where t.base_terminal_addr=logicAddr and t.base_terminal_id=logicAddrId and t.base_bound_device_no!=2;
					
					/*调用存储过程执行计算所有某集中器下广告牌用电量*/
					CALL trep_loss_part_bill(cDate,logicAddr,readBillNums,tmpBillUsedE);

					/*后续如果增加设备类型，则继续增加响应存储过程*/

					/*==========================汇总某终端\deptid下数据========================================*/
					SET tmpTotalPartE = tmpLightUsedE + tmpPileUsedE + tmpBillUsedE;
					IF totalUsedE=0 OR tmpTotalPartE>totalUsedE THEN
						SET tmpLoss = null;
					ELSE
						SET tmpLoss = ROUND((1-tmpTotalPartE/totalUsedE)*100,2);
					END IF;
					
					IF totalLightNums=0 THEN
						set tmpLightP = 0; 
					ELSEIF readLightNums > totalLightNums THEN
						SET tmpLightP = 100;
					ELSE
						SET tmpLightP = ROUND((1-readLightNums/totalLightNums)*100,2);
					END IF;

					IF totalPileNums=0 THEN
						set tmpPileP = 0; 
					ELSEIF readPileNums > totalPileNums THEN
						SET tmpPileP = 100;
					ELSE
						SET tmpPileP = ROUND((1-readPileNums/totalPileNums)*100,2);
					END IF;

					IF totalBillNums=0 THEN
						set tmpBillP = 0; 
					ELSEIF readBillNums > totalBillNums THEN
						SET tmpBillP = 100;
					ELSE
						SET tmpBillP = ROUND((1-readBillNums/totalBillNums)*100,2);
					END IF;
					

					/*数据插入 insert  bus_bound_device_treploss_data  LIGHT*/
					select id INTO tmpTrepLossID FROM bus_bound_device_treploss_data t where t.bus_bound_device_data_day_time=cDate
					and t.base_terminal_addr=logicAddr and bus_bound_device_data_loss_type=1 LIMIT 1;
					IF tmpTrepLossID IS NULL THEN
						INSERT INTO bus_bound_device_treploss_data (dept_id,base_terminal_addr,bus_bound_device_data_read_percent,bus_bound_device_data_loss_percent,
						bus_bound_device_data_total_electricity,bus_bound_device_data_part_electricity,bus_bound_device_data_read_total,
						bus_bound_device_data_read_value,bus_bound_device_data_loss_type,bus_bound_device_data_day_time) 
						VALUES (deptID,logicAddr,tmpLightP,tmpLoss,totalUsedE,tmpLightUsedE,totalLightNums,readLightNums,1,cDate);
					ELSE
						update bus_bound_device_treploss_data SET dept_id=deptID ,base_terminal_addr=logicAddr,bus_bound_device_data_read_percent=tmpLightP,
								bus_bound_device_data_loss_percent=tmpLoss,bus_bound_device_data_total_electricity=totalUsedE,
								bus_bound_device_data_part_electricity=tmpLightUsedE,bus_bound_device_data_read_total=totalLightNums,bus_bound_device_data_read_value=readLightNums,
								bus_bound_device_data_loss_type=1,bus_bound_device_data_day_time=cDate where id=tmpTrepLossID;
					END IF;

					/*数据插入 insert  bus_bound_device_treploss_data  PILE*/
					select id INTO tmpTrepLossID FROM bus_bound_device_treploss_data t where t.bus_bound_device_data_day_time=cDate
					and t.base_terminal_addr=logicAddr and bus_bound_device_data_loss_type=2 LIMIT 1;
					IF tmpTrepLossID IS NULL THEN
						INSERT INTO bus_bound_device_treploss_data (dept_id,base_terminal_addr,bus_bound_device_data_read_percent,bus_bound_device_data_loss_percent,
						bus_bound_device_data_total_electricity,bus_bound_device_data_part_electricity,bus_bound_device_data_read_total,
						bus_bound_device_data_read_value,bus_bound_device_data_loss_type,bus_bound_device_data_day_time) 
						VALUES (deptID,logicAddr,tmpPileP,tmpLoss,totalUsedE,tmpPileUsedE,totalPileNums,readPileNums,1,cDate);
					ELSE
						update bus_bound_device_treploss_data SET dept_id=deptID ,base_terminal_addr=logicAddr,bus_bound_device_data_read_percent=tmpPileP,
								bus_bound_device_data_loss_percent=tmpLoss,bus_bound_device_data_total_electricity=totalUsedE,
								bus_bound_device_data_part_electricity=tmpPileUsedE,bus_bound_device_data_read_total=totalPileNums,bus_bound_device_data_read_value=readPileNums,
								bus_bound_device_data_loss_type=1,bus_bound_device_data_day_time=cDate where id=tmpTrepLossID;
					END IF;


					/*数据插入 insert  bus_bound_device_treploss_data  BILL*/
					select id INTO tmpTrepLossID FROM bus_bound_device_treploss_data t where t.bus_bound_device_data_day_time=cDate
					and t.base_terminal_addr=logicAddr and bus_bound_device_data_loss_type=3 LIMIT 1;
					IF tmpTrepLossID IS NULL THEN
						INSERT INTO bus_bound_device_treploss_data (dept_id,base_terminal_addr,bus_bound_device_data_read_percent,bus_bound_device_data_loss_percent,
						bus_bound_device_data_total_electricity,bus_bound_device_data_part_electricity,bus_bound_device_data_read_total,
						bus_bound_device_data_read_value,bus_bound_device_data_loss_type,bus_bound_device_data_day_time) 
						VALUES (deptID,logicAddr,tmpBillP,tmpLoss,totalUsedE,tmpBillUsedE,totalBillNums,readBillNums,1,cDate);
					ELSE
						update bus_bound_device_treploss_data SET dept_id=deptID ,base_terminal_addr=logicAddr,bus_bound_device_data_read_percent=tmpBillP,
								bus_bound_device_data_loss_percent=tmpLoss,bus_bound_device_data_total_electricity=totalUsedE,
								bus_bound_device_data_part_electricity=tmpBillUsedE,bus_bound_device_data_read_total=totalBillNums,bus_bound_device_data_read_value=readBillNums,
								bus_bound_device_data_loss_type=1,bus_bound_device_data_day_time=cDate where id=tmpTrepLossID;
					END IF;


			END IF;
		END IF;
	FETCH cur_area INTO deptID;
	UNTIL no_more_basearea END REPEAT;
	CLOSE cur_area;
END
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `trep_loss_part_bill`
-- ----------------------------
DROP PROCEDURE IF EXISTS `trep_loss_part_bill`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `trep_loss_part_bill`(IN cDate datetime, IN logicaddr varchar(20), OUT readNum int, OUT usedPartE decimal(19,5))
BEGIN
	DECLARE readNumP INT;
	DECLARE eP,eC DECIMAL;
	select count(1) INTO readNumP from base_bound_device t RIGHT join base_bill_board t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_bill_board_his_data t2 ON t1.base_bill_board_devaddr=t2.base_bill_board_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_bill_board_his_data_day_time=date_sub(cDate,interval 1 day);

	select count(1) INTO readNum from base_bound_device t RIGHT join base_bill_board t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_bill_board_his_data t2 ON t1.base_bill_board_devaddr=t2.base_bill_board_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_bill_board_his_data_day_time=cDate;

	IF readNumP>0 THEN
		IF readNum > 0 THEN
				select sum(t2.bus_bill_board_his_data_electricity) INTO eP from base_bound_device t RIGHT join base_bill_board t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_bill_board_his_data t2 ON t1.base_bill_board_devaddr=t2.base_bill_board_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_bill_board_his_data_day_time=date_sub(cDate,interval 1 day);

				select sum(t2.bus_bill_board_his_data_electricity) INTO eC from base_bound_device t RIGHT join base_bill_board t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_bill_board_his_data t2 ON t1.base_bill_board_devaddr=t2.base_bill_board_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_bill_board_his_data_day_time=cDate;

				SET usedPartE = eC - eP ;
				
		END IF;
	ELSE
		SET usedPartE = 0;
	END IF;

END
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `trep_loss_part_light`
-- ----------------------------
DROP PROCEDURE IF EXISTS `trep_loss_part_light`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `trep_loss_part_light`(IN cDate datetime, IN logicaddr varchar(20), OUT readNum int, OUT usedPartE decimal(19,5))
BEGIN
	DECLARE readNumP INT;
	DECLARE ePone,eCone,ePtwo,eCtwo DECIMAL;	
	select count(1) INTO readNumP from bus_bound_device_his_data t where t.base_terminal_addr=logicaddr 
	and t.bus_bound_device_his_data_day_time=date_sub(cDate,interval 1 day) and t.bus_bound_device_his_data_dev_type=1;
	
	select count(1) INTO readNum from bus_bound_device_his_data t where t.base_terminal_addr=logicaddr 
	and t.bus_bound_device_his_data_day_time=cDate and t.bus_bound_device_his_data_dev_type=2;
	
	IF readNumP>0 THEN
		IF readNum>0 THEN
			select SUM(t.bus_bound_device_his_data_electricity) INTO ePone from bus_bound_device_his_data t where t.base_terminal_addr=logicaddr 
			and t.bus_bound_device_his_data_day_time=date_sub(cDate,interval 1 day) and t.bus_bound_device_his_data_dev_type=1;

			select SUM(t.bus_bound_device_his_data_electricity) INTO eCone from bus_bound_device_his_data t where t.base_terminal_addr=logicaddr 
			and t.bus_bound_device_his_data_day_time=cDate and t.bus_bound_device_his_data_dev_type=1;
			
			select SUM(t.bus_bound_device_his_data_electricity) INTO ePtwo from bus_bound_device_his_data t where t.base_terminal_addr=logicaddr 
			and t.bus_bound_device_his_data_day_time=date_sub(cDate,interval 1 day) and t.bus_bound_device_his_data_dev_type=2;

			select SUM(t.bus_bound_device_his_data_electricity) INTO eCtwo from bus_bound_device_his_data t where t.base_terminal_addr=logicaddr 
			and t.bus_bound_device_his_data_day_time=cDate and t.bus_bound_device_his_data_dev_type=2;

			SET usedPartE = (eCone - ePone ) + (eCtwo - ePtwo) ;

		END IF;
	ELSE
		SET usedPartE = 0;
	END IF;

END
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `trep_loss_part_pile`
-- ----------------------------
DROP PROCEDURE IF EXISTS `trep_loss_part_pile`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `trep_loss_part_pile`(IN cDate datetime, IN logicaddr varchar(20), OUT readNum int, OUT usedPartE decimal(19,5))
BEGIN
	DECLARE readNumP INT;
	DECLARE eP,eC DECIMAL;
	select count(1) INTO readNumP from base_bound_device t RIGHT join base_charging_pile t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_charging_pile_his_data t2 ON t1.base_charging_pile_devaddr=t2.base_charging_pile_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_charging_pile_his_data_day_time=date_sub(cDate,interval 1 day);

	select count(1) INTO readNum from base_bound_device t RIGHT join base_charging_pile t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_charging_pile_his_data t2 ON t1.base_charging_pile_devaddr=t2.base_charging_pile_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_charging_pile_his_data_day_time=cDate;

	IF readNumP>0 THEN
		IF readNum > 0 THEN
				select sum(t2.bus_charging_pile_his_data_electricity) INTO eP from base_bound_device t RIGHT join base_charging_pile t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_charging_pile_his_data t2 ON t1.base_charging_pile_devaddr=t2.base_charging_pile_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_charging_pile_his_data_day_time=date_sub(cDate,interval 1 day);

				select sum(t2.bus_charging_pile_his_data_electricity) INTO eC from base_bound_device t RIGHT join base_charging_pile t1 ON t.id=t1.base_bound_device_id 
							RIGHT JOIN bus_charging_pile_his_data t2 ON t1.base_charging_pile_devaddr=t2.base_charging_pile_devaddr
							where t.base_terminal_addr=logicaddr and t.base_bound_device_no!=2 
							and t2.bus_charging_pile_his_data_day_time=cDate;

				SET usedPartE = eC - eP ;
				
		END IF;
	ELSE
		SET usedPartE = 0;
	END IF;

END
 ;;
delimiter ;

-- ----------------------------
--  Procedure structure for `trep_loss_total_meter`
-- ----------------------------
DROP PROCEDURE IF EXISTS `trep_loss_total_meter`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `trep_loss_total_meter`(IN cDate datetime, IN logicaddr varchar(20), OUT electricity decimal(19,5))
BEGIN

DECLARE electricity_cur decimal;
DECLARE electricity_pri decimal;

select bus_terminal_total_his_data_electricity INTO electricity_cur from bus_terminal_total_his_data where 
bus_terminal_total_his_data_day_time = cDate and bus_terminal_total_his_data_tariff_no=0 
and base_terminal_addr=logicaddr and base_bound_device_no=2 limit 1;

select bus_terminal_total_his_data_electricity INTO electricity_pri from bus_terminal_total_his_data where 
bus_terminal_total_his_data_day_time = date_sub(cDate,interval 1 day) and bus_terminal_total_his_data_tariff_no=0 
and base_terminal_addr=logicaddr and base_bound_device_no=2 limit 1;


IF (electricity_cur IS NULL || electricity_pri IS NULL) THEN

SET electricity = 0;
ELSE
SET electricity = electricity_cur - electricity_pri;

END IF;



END
 ;;
delimiter ;

-- ----------------------------
--  Function structure for `currval`
-- ----------------------------
DROP FUNCTION IF EXISTS `currval`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `currval`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
         DECLARE VALUE INTEGER;
         SET VALUE = 0;
         SELECT current_value INTO VALUE
                   FROM sequence
                   WHERE NAME = seq_name;
		 IF VALUE = 0 THEN
			SET VALUE = 1;
			INSERT INTO sequence(NAME, current_value) VALUES(seq_name, VALUE);
		 END IF;
         RETURN VALUE;
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

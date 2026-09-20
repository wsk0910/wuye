-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        8.0.12 - MySQL Community Server - GPL
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  12.5.0.6684
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 导出  表 smart_property.complaint 结构
CREATE TABLE IF NOT EXISTS `complaint` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner_id` bigint(20) NOT NULL COMMENT '投诉人ID',
  `type` tinyint(4) NOT NULL COMMENT '类型: 1-投诉 2-建议',
  `title` varchar(100) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态: 0-待处理 1-处理中 2-已处理',
  `reply` text COMMENT '回复内容',
  `handler_id` bigint(20) DEFAULT NULL COMMENT '处理人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='投诉建议表';

-- 正在导出表  smart_property.complaint 的数据：~6 rows (大约)
DELETE FROM `complaint`;
INSERT INTO `complaint` (`id`, `owner_id`, `type`, `title`, `content`, `status`, `reply`, `handler_id`, `create_time`, `update_time`) VALUES
	(1, 1, 1, '楼道卫生问题', '1栋1单元楼道卫生打扫不及时，垃圾堆积，希望加强清洁频次', 2, '感谢您的反馈，我们已安排保洁人员加强该区域清洁，每日打扫两次。', 2, '2026-02-28 16:59:14', '2026-03-10 16:59:14'),
	(2, 2, 2, '建议增设快递柜', '小区目前快递柜数量不足，建议在2栋附近增设快递柜，方便业主取件', 2, '感谢您的建议，我们已与快递柜运营商联系，计划下月在2栋增设一组快递柜。', 2, '2026-03-02 16:59:14', '2026-03-10 16:59:14'),
	(3, 3, 1, '夜间施工噪音', '隔壁装修户晚上10点后还在施工，严重影响休息，请物业管理', 1, NULL, NULL, '2026-03-07 16:59:14', '2026-03-10 16:59:14'),
	(4, 4, 2, '建议增加健身器材', '小区健身区域器材较少，建议增加一些适合老年人的健身器材', 0, NULL, NULL, '2026-03-08 16:59:14', '2026-03-10 16:59:14'),
	(5, 5, 1, '地下车库照明不足', '地下车库B区照明灯损坏多处，光线昏暗存在安全隐患', 0, NULL, NULL, '2026-03-09 16:59:14', '2026-03-10 16:59:14'),
	(6, 6, 2, '建议开设业主活动室', '希望物业能开设业主活动室，供业主们下棋、读书等休闲活动', 0, NULL, NULL, '2026-03-10 16:59:14', '2026-03-10 16:59:14'),
	(7, 9, 1, '12', '3123123', 2, '123123', 2, '2026-03-10 18:17:37', '2026-03-10 18:18:53');

-- 导出  表 smart_property.config 结构
CREATE TABLE IF NOT EXISTS `config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) NOT NULL COMMENT '配置键',
  `config_value` varchar(500) DEFAULT NULL COMMENT '配置值',
  `config_name` varchar(100) DEFAULT NULL COMMENT '配置名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统配置表';

-- 正在导出表  smart_property.config 的数据：~5 rows (大约)
DELETE FROM `config`;
INSERT INTO `config` (`id`, `config_key`, `config_value`, `config_name`, `remark`, `create_time`, `update_time`) VALUES
	(1, 'property_fee_rate', '2.5', '物业费单价', '元/平方米/月', '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(2, 'water_fee_rate', '3.5', '水费单价', '元/吨', '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(3, 'electric_fee_rate', '0.6', '电费单价', '元/度', '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(4, 'parking_fee', '200', '停车费', '元/月', '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(5, 'community_name', '阳光花园小区', '小区名称', '', '2026-03-10 16:59:13', '2026-03-10 16:59:13');

-- 导出  表 smart_property.fee 结构
CREATE TABLE IF NOT EXISTS `fee` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner_id` bigint(20) NOT NULL COMMENT '业主ID',
  `type` tinyint(4) NOT NULL COMMENT '费用类型: 1-物业费 2-水费 3-电费 4-停车费 5-其他',
  `amount` decimal(10,2) NOT NULL COMMENT '费用金额',
  `period` varchar(20) DEFAULT NULL COMMENT '费用周期',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态: 0-未缴 1-已缴',
  `pay_time` datetime DEFAULT NULL COMMENT '缴费时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='费用表';

-- 正在导出表  smart_property.fee 的数据：~17 rows (大约)
DELETE FROM `fee`;
INSERT INTO `fee` (`id`, `owner_id`, `type`, `amount`, `period`, `status`, `pay_time`, `remark`, `create_time`, `update_time`) VALUES
	(1, 1, 1, 223.75, '2024-01', 1, '2026-01-09 16:59:13', '物业费', '2026-01-04 16:59:13', '2026-03-10 16:59:13'),
	(2, 1, 1, 223.75, '2024-02', 1, '2026-02-08 16:59:13', '物业费', '2026-02-03 16:59:13', '2026-03-10 16:59:13'),
	(3, 1, 1, 223.75, '2024-03', 0, NULL, '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:13'),
	(4, 1, 2, 45.50, '2024-01', 1, '2026-01-14 16:59:13', '水费', '2026-01-09 16:59:13', '2026-03-10 16:59:13'),
	(5, 1, 3, 128.40, '2024-01', 1, '2026-01-14 16:59:13', '电费', '2026-01-09 16:59:13', '2026-03-10 16:59:13'),
	(6, 2, 1, 300.00, '2024-01', 1, '2026-01-11 16:59:13', '物业费', '2026-01-04 16:59:13', '2026-03-10 16:59:13'),
	(7, 2, 1, 300.00, '2024-02', 1, '2026-02-10 16:59:13', '物业费', '2026-02-03 16:59:13', '2026-03-10 16:59:13'),
	(8, 2, 1, 300.00, '2024-03', 1, '2026-03-10 16:59:33', '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:33'),
	(9, 2, 4, 200.00, '2024-01', 1, '2026-01-19 16:59:13', '停车费', '2026-01-14 16:59:13', '2026-03-10 16:59:13'),
	(10, 3, 1, 239.50, '2024-01', 1, '2026-01-07 16:59:13', '物业费', '2026-01-04 16:59:13', '2026-03-10 16:59:13'),
	(11, 3, 1, 239.50, '2024-02', 0, NULL, '物业费', '2026-02-03 16:59:13', '2026-03-10 16:59:13'),
	(12, 3, 1, 239.50, '2024-03', 0, NULL, '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:13'),
	(13, 4, 1, 276.25, '2024-03', 0, NULL, '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:13'),
	(14, 5, 1, 220.00, '2024-03', 1, '2026-03-10 18:18:43', '物业费', '2026-03-05 16:59:13', '2026-03-10 18:18:43'),
	(15, 6, 1, 338.00, '2024-03', 0, NULL, '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:13'),
	(16, 7, 1, 255.00, '2024-03', 0, NULL, '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:13'),
	(17, 8, 1, 246.50, '2024-03', 0, NULL, '物业费', '2026-03-05 16:59:13', '2026-03-10 16:59:13'),
	(18, 9, 2, 12.00, '1312', 1, '2026-03-10 18:17:29', '131', '2026-03-10 18:16:26', '2026-03-10 18:17:29'),
	(19, 9, 5, 133.00, '维修费', 1, '2026-03-10 18:20:06', '报修单号:9 - 123', '2026-03-10 18:20:06', '2026-03-10 18:20:06');

-- 导出  表 smart_property.inspection 结构
CREATE TABLE IF NOT EXISTS `inspection` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `inspector_id` bigint(20) DEFAULT NULL COMMENT '巡检人ID',
  `area` varchar(100) DEFAULT NULL COMMENT '巡检区域',
  `content` text COMMENT '巡检内容',
  `result` text COMMENT '巡检结果',
  `problem` text COMMENT '问题描述',
  `images` varchar(500) DEFAULT NULL COMMENT '图片',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态: 0-正常 1-有问题',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='巡检记录表';

-- 正在导出表  smart_property.inspection 的数据：~8 rows (大约)
DELETE FROM `inspection`;
INSERT INTO `inspection` (`id`, `inspector_id`, `area`, `content`, `result`, `problem`, `images`, `status`, `create_time`, `update_time`) VALUES
	(1, 2, '1栋1单元', '检查楼道照明、消防设施、卫生情况', '照明正常，消防设施完好，卫生良好', NULL, NULL, 0, '2026-03-09 16:59:14', '2026-03-10 16:59:14'),
	(2, 2, '1栋2单元', '检查楼道照明、消防设施、卫生情况', '发现问题', '3楼消防栓玻璃破损，需更换', NULL, 1, '2026-03-09 16:59:14', '2026-03-10 16:59:14'),
	(3, 2, '2栋1单元', '检查楼道照明、消防设施、卫生情况', '照明正常，消防设施完好，卫生良好', NULL, NULL, 0, '2026-03-08 16:59:14', '2026-03-10 16:59:14'),
	(4, 2, '2栋2单元', '检查楼道照明、消防设施、卫生情况', '照明正常，消防设施完好，卫生良好', NULL, NULL, 0, '2026-03-08 16:59:14', '2026-03-10 16:59:14'),
	(5, 2, '地下车库A区', '检查照明、通风、消防设施', '发现问题', '部分照明灯损坏，通风正常', NULL, 1, '2026-03-07 16:59:14', '2026-03-10 16:59:14'),
	(6, 2, '地下车库B区', '检查照明、通风、消防设施', '照明正常，通风正常，消防设施完好', NULL, NULL, 0, '2026-03-07 16:59:14', '2026-03-10 16:59:14'),
	(7, 2, '小区绿化带', '检查绿化养护情况', '绿化良好，无病虫害', NULL, NULL, 0, '2026-03-06 16:59:14', '2026-03-10 16:59:14'),
	(8, 2, '儿童游乐区', '检查游乐设施安全', '发现问题', '秋千座椅螺丝松动，需加固', NULL, 1, '2026-03-05 16:59:14', '2026-03-10 16:59:14'),
	(9, 1, '13', '1', '31', NULL, NULL, 0, '2026-03-10 18:16:42', '2026-03-10 18:16:42'),
	(10, 2, '12', '12', '3', NULL, NULL, 0, '2026-03-10 18:19:03', '2026-03-10 18:19:03');

-- 导出  表 smart_property.notice 结构
CREATE TABLE IF NOT EXISTS `notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `publisher_id` bigint(20) DEFAULT NULL COMMENT '发布人ID',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态: 0-草稿 1-已发布',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';

-- 正在导出表  smart_property.notice 的数据：~6 rows (大约)
DELETE FROM `notice`;
INSERT INTO `notice` (`id`, `title`, `content`, `publisher_id`, `status`, `create_time`, `update_time`) VALUES
	(1, '关于小区停水通知', '尊敬的业主：因市政管网维修，本小区将于本周六（3月15日）上午8:00-12:00停水，请各位业主提前做好储水准备，给您带来不便敬请谅解。', 2, 1, '2026-03-08 16:59:14', '2026-03-10 16:59:14'),
	(2, '春季消防安全检查通知', '为确保小区消防安全，物业将于下周一至周五进行消防设施检查，届时工作人员可能需要进入您的房屋检查烟感器等设备，请予以配合。', 2, 1, '2026-03-05 16:59:14', '2026-03-10 16:59:14'),
	(3, '关于规范电动车停放的通知', '近期发现部分业主将电动车停放在楼道内充电，存在严重安全隐患。请各位业主将电动车停放至指定充电区域，违规停放将予以清理。', 2, 1, '2026-02-28 16:59:14', '2026-03-10 16:59:14'),
	(4, '物业费缴纳提醒', '尊敬的业主：2024年第一季度物业费已开始收取，请尚未缴费的业主尽快完成缴费，可通过线上系统或物业服务中心缴纳。', 2, 1, '2026-02-23 16:59:14', '2026-03-10 16:59:14'),
	(5, '小区绿化养护通知', '为美化小区环境，物业将于近期对小区绿化进行修剪养护，届时可能会产生一定噪音，请业主们谅解。', 2, 1, '2026-02-18 16:59:14', '2026-03-10 16:59:14'),
	(6, '端午节放假通知', '端午节期间（6月8日-10日），物业服务中心正常值班，如有紧急事务请拨打24小时服务热线：400-123-4567。祝各位业主节日快乐！', 2, 0, '2026-03-10 16:59:14', '2026-03-10 16:59:14'),
	(7, '31', '313', 1, 1, '2026-03-10 18:16:31', '2026-03-10 18:16:31');

-- 导出  表 smart_property.owner 结构
CREATE TABLE IF NOT EXISTS `owner` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '关联用户ID',
  `name` varchar(50) NOT NULL COMMENT '姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证号',
  `building` varchar(20) DEFAULT NULL COMMENT '楼栋',
  `unit` varchar(20) DEFAULT NULL COMMENT '单元',
  `room` varchar(20) DEFAULT NULL COMMENT '房号',
  `area` decimal(10,2) DEFAULT NULL COMMENT '房屋面积',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='业主表';

-- 正在导出表  smart_property.owner 的数据：~8 rows (大约)
DELETE FROM `owner`;
INSERT INTO `owner` (`id`, `user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`, `create_time`, `update_time`) VALUES
	(1, 5, '张三', '13912345001', '320123199001011234', '1', '1', '101', 89.50, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(2, 6, '李四', '13912345002', '320123199002021234', '1', '1', '102', 120.00, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(3, 7, '王五', '13912345003', '320123199003031234', '1', '2', '201', 95.80, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(4, 8, '赵六', '13912345004', '320123199004041234', '1', '2', '202', 110.50, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(5, 9, '钱七', '13912345005', '320123199005051234', '2', '1', '301', 88.00, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(6, 10, '孙八', '13912345006', '320123199006061234', '2', '1', '302', 135.20, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(7, 11, '周九', '13912345007', '320123199007071234', '2', '2', '401', 102.00, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(8, 12, '吴十', '13912345008', '320123199008081234', '2', '2', '402', 98.60, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(9, 15, '123', '13123', '12313', '113', '1231', '1231', 2.00, '2026-03-10 18:15:43', '2026-03-10 18:16:04');

-- 导出  表 smart_property.repair 结构
CREATE TABLE IF NOT EXISTS `repair` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner_id` bigint(20) NOT NULL COMMENT '报修业主ID',
  `title` varchar(100) NOT NULL COMMENT '报修标题',
  `content` text COMMENT '报修内容',
  `images` varchar(500) DEFAULT NULL COMMENT '报修图片',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态: 0-待处理 1-已派单 2-维修中 3-待缴费 4-待评价 5-已完成',
  `worker_id` bigint(20) DEFAULT NULL COMMENT '维修工ID',
  `cost` decimal(10,2) DEFAULT NULL COMMENT '维修费用',
  `repair_record` text COMMENT '维修记录',
  `rating` tinyint(4) DEFAULT NULL COMMENT '评分',
  `comment` varchar(500) DEFAULT NULL COMMENT '评价内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报修表';

-- 正在导出表  smart_property.repair 的数据：~8 rows (大约)
DELETE FROM `repair`;
INSERT INTO `repair` (`id`, `owner_id`, `title`, `content`, `images`, `status`, `worker_id`, `cost`, `repair_record`, `rating`, `comment`, `create_time`, `update_time`) VALUES
	(1, 1, '卫生间漏水', '卫生间天花板漏水，已经影响到正常使用，请尽快处理', NULL, 5, 3, 150.00, '更换了水管接头，修复漏水点', 5, '维修师傅很专业，服务态度好', '2026-02-23 16:59:13', '2026-03-10 16:59:13'),
	(2, 2, '门锁损坏', '入户门锁打不开，需要更换', NULL, 5, 4, 280.00, '更换了新门锁', 4, '修好了，谢谢', '2026-02-26 16:59:13', '2026-03-10 16:59:13'),
	(3, 3, '空调不制冷', '客厅空调开机后不制冷，显示正常', NULL, 4, 3, 200.00, '清洗了空调滤网，添加制冷剂', NULL, NULL, '2026-03-02 16:59:13', '2026-03-10 16:59:13'),
	(4, 4, '马桶堵塞', '卫生间马桶堵塞，无法正常使用', NULL, 3, 4, 80.00, '疏通了下水道', NULL, NULL, '2026-03-07 16:59:13', '2026-03-10 16:59:13'),
	(5, 5, '电路跳闸', '厨房电路经常跳闸，怀疑线路老化', NULL, 1, 3, NULL, NULL, NULL, NULL, '2026-03-08 16:59:13', '2026-03-10 16:59:13'),
	(6, 1, '窗户漏风', '卧室窗户密封不好，冬天漏风严重', NULL, 0, NULL, NULL, NULL, NULL, NULL, '2026-03-09 16:59:13', '2026-03-10 16:59:13'),
	(7, 6, '热水器故障', '热水器打不着火，无法使用热水', NULL, 0, NULL, NULL, NULL, NULL, NULL, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(8, 7, '墙面渗水', '客厅墙面有渗水痕迹，墙皮脱落', NULL, 0, NULL, NULL, NULL, NULL, NULL, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(9, 9, '123', '1312', NULL, 5, 3, 133.00, '222', 3, '223', '2026-03-10 18:17:23', '2026-03-10 18:20:11');

-- 导出  表 smart_property.user 结构
CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `role` tinyint(4) NOT NULL DEFAULT '3' COMMENT '角色: 1-超级管理员 2-物业管理员 3-业主 4-维修工',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态: 0-禁用 1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

-- 正在导出表  smart_property.user 的数据：~14 rows (大约)
DELETE FROM `user`;
INSERT INTO `user` (`id`, `username`, `password`, `real_name`, `phone`, `avatar`, `role`, `status`, `create_time`, `update_time`) VALUES
	(1, 'admin', '123456', '超级管理员', NULL, NULL, 1, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(2, 'property', '123456', '物业管理员', NULL, NULL, 2, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(3, 'worker1', '123456', '张师傅', '13800000001', NULL, 4, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(4, 'worker2', '123456', '李师傅', '13800000002', NULL, 4, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(5, 'worker3', '123456', '王师傅', '13800000003', NULL, 4, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(6, '13912345001', '123456', '张三', '13912345001', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(7, '13912345002', '123456', '李四', '13912345002', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(8, '13912345003', '123456', '王五', '13912345003', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(9, '13912345004', '123456', '赵六', '13912345004', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(10, '13912345005', '123456', '钱七', '13912345005', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(11, '13912345006', '123456', '孙八', '13912345006', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(12, '13912345007', '123456', '周九', '13912345007', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(13, '13912345008', '123456', '吴十', '13912345008', NULL, 3, 1, '2026-03-10 16:59:13', '2026-03-10 16:59:13'),
	(15, '123', '123', '123', '1312312312', NULL, 3, 1, '2026-03-10 18:11:40', '2026-03-10 18:11:40');

-- 导出  表 smart_property.visitor 结构
CREATE TABLE IF NOT EXISTS `visitor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner_id` bigint(20) NOT NULL COMMENT '预约业主ID',
  `visitor_name` varchar(50) NOT NULL COMMENT '访客姓名',
  `visitor_phone` varchar(20) DEFAULT NULL COMMENT '访客电话',
  `visitor_id_card` varchar(20) DEFAULT NULL COMMENT '访客身份证',
  `reason` varchar(255) DEFAULT NULL COMMENT '来访事由',
  `visit_time` datetime DEFAULT NULL COMMENT '预计来访时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态: 0-待审核 1-已通过 2-已拒绝 3-已来访',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='访客预约表';

-- 正在导出表  smart_property.visitor 的数据：~6 rows (大约)
DELETE FROM `visitor`;
INSERT INTO `visitor` (`id`, `owner_id`, `visitor_name`, `visitor_phone`, `visitor_id_card`, `reason`, `visit_time`, `status`, `remark`, `create_time`, `update_time`) VALUES
	(1, 1, '张伟', '13611112222', '320123199501011234', '亲戚来访', '2026-03-11 16:59:14', 1, '', '2026-03-09 16:59:14', '2026-03-10 16:59:14'),
	(2, 2, '李娜', '13622223333', '320123199602021234', '朋友聚会', '2026-03-12 16:59:14', 1, '', '2026-03-09 16:59:14', '2026-03-10 16:59:14'),
	(3, 3, '王磊', '13633334444', '320123199703031234', '送货上门', '2026-03-11 16:59:14', 0, '大件家具配送', '2026-03-10 16:59:14', '2026-03-10 16:59:14'),
	(4, 4, '刘芳', '13644445555', '320123199804041234', '家政服务', '2026-03-13 16:59:14', 0, '', '2026-03-10 16:59:14', '2026-03-10 16:59:14'),
	(5, 1, '陈明', '13655556666', '320123199905051234', '维修空调', '2026-03-05 16:59:14', 3, '空调维修师傅', '2026-03-04 16:59:14', '2026-03-10 16:59:14'),
	(6, 5, '赵丽', '13666667777', '320123199006061234', '探望父母', '2026-03-07 16:59:14', 3, '', '2026-03-06 16:59:14', '2026-03-10 16:59:14'),
	(7, 9, '123', '123', '123', '1', '2026-03-11 16:00:00', 1, '12312', '2026-03-10 18:17:44', '2026-03-10 18:18:57');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

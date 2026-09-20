-- 创建数据库
CREATE DATABASE IF NOT EXISTS smart_property DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_property;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `real_name` VARCHAR(50) COMMENT '真实姓名',
    `phone` VARCHAR(20) COMMENT '手机号',
    `avatar` VARCHAR(255) COMMENT '头像',
    `role` TINYINT NOT NULL DEFAULT 3 COMMENT '角色: 1-超级管理员 2-物业管理员 3-业主 4-维修工',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用 1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 业主表
CREATE TABLE IF NOT EXISTS `owner` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT COMMENT '关联用户ID',
    `name` VARCHAR(50) NOT NULL COMMENT '姓名',
    `phone` VARCHAR(20) COMMENT '手机号',
    `id_card` VARCHAR(20) COMMENT '身份证号',
    `building` VARCHAR(20) COMMENT '楼栋',
    `unit` VARCHAR(20) COMMENT '单元',
    `room` VARCHAR(20) COMMENT '房号',
    `area` DECIMAL(10,2) COMMENT '房屋面积',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业主表';

-- 报修表
CREATE TABLE IF NOT EXISTS `repair` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `owner_id` BIGINT NOT NULL COMMENT '报修业主ID',
    `title` VARCHAR(100) NOT NULL COMMENT '报修标题',
    `content` TEXT COMMENT '报修内容',
    `images` VARCHAR(500) COMMENT '报修图片',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0-待处理 1-已派单 2-维修中 3-待缴费 4-待评价 5-已完成',
    `worker_id` BIGINT COMMENT '维修工ID',
    `cost` DECIMAL(10,2) COMMENT '维修费用',
    `repair_record` TEXT COMMENT '维修记录',
    `rating` TINYINT COMMENT '评分',
    `comment` VARCHAR(500) COMMENT '评价内容',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报修表';

-- 费用表
CREATE TABLE IF NOT EXISTS `fee` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `owner_id` BIGINT NOT NULL COMMENT '业主ID',
    `type` TINYINT NOT NULL COMMENT '费用类型: 1-物业费 2-水费 3-电费 4-停车费 5-其他',
    `amount` DECIMAL(10,2) NOT NULL COMMENT '费用金额',
    `period` VARCHAR(20) COMMENT '费用周期',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0-未缴 1-已缴',
    `pay_time` DATETIME COMMENT '缴费时间',
    `remark` VARCHAR(255) COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='费用表';

-- 通知公告表
CREATE TABLE IF NOT EXISTS `notice` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL COMMENT '标题',
    `content` TEXT COMMENT '内容',
    `publisher_id` BIGINT COMMENT '发布人ID',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0-草稿 1-已发布',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知公告表';

-- 投诉建议表
CREATE TABLE IF NOT EXISTS `complaint` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `owner_id` BIGINT NOT NULL COMMENT '投诉人ID',
    `type` TINYINT NOT NULL COMMENT '类型: 1-投诉 2-建议',
    `title` VARCHAR(100) NOT NULL COMMENT '标题',
    `content` TEXT COMMENT '内容',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0-待处理 1-处理中 2-已处理',
    `reply` TEXT COMMENT '回复内容',
    `handler_id` BIGINT COMMENT '处理人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='投诉建议表';

-- 访客预约表
CREATE TABLE IF NOT EXISTS `visitor` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `owner_id` BIGINT NOT NULL COMMENT '预约业主ID',
    `visitor_name` VARCHAR(50) NOT NULL COMMENT '访客姓名',
    `visitor_phone` VARCHAR(20) COMMENT '访客电话',
    `visitor_id_card` VARCHAR(20) COMMENT '访客身份证',
    `reason` VARCHAR(255) COMMENT '来访事由',
    `visit_time` DATETIME COMMENT '预计来访时间',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0-待审核 1-已通过 2-已拒绝 3-已来访',
    `remark` VARCHAR(255) COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访客预约表';

-- 巡检记录表
CREATE TABLE IF NOT EXISTS `inspection` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `inspector_id` BIGINT COMMENT '巡检人ID',
    `area` VARCHAR(100) COMMENT '巡检区域',
    `content` TEXT COMMENT '巡检内容',
    `result` TEXT COMMENT '巡检结果',
    `problem` TEXT COMMENT '问题描述',
    `images` VARCHAR(500) COMMENT '图片',
    `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0-正常 1-有问题',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='巡检记录表';

-- 系统配置表
CREATE TABLE IF NOT EXISTS `config` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `config_key` VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    `config_value` VARCHAR(500) COMMENT '配置值',
    `config_name` VARCHAR(100) COMMENT '配置名称',
    `remark` VARCHAR(255) COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- 初始化系统配置
INSERT INTO `config` (`config_key`, `config_value`, `config_name`, `remark`) VALUES 
('property_fee_rate', '2.5', '物业费单价', '元/平方米/月'),
('water_fee_rate', '3.5', '水费单价', '元/吨'),
('electric_fee_rate', '0.6', '电费单价', '元/度'),
('parking_fee', '200', '停车费', '元/月'),
('community_name', '阳光花园小区', '小区名称', '');

-- 初始化超级管理员
INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`) VALUES ('admin', '123456', '超级管理员', 1, 1);
-- 初始化物业管理员
INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`) VALUES ('property', '123456', '物业管理员', 2, 1);
-- 初始化维修工
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('worker1', '123456', '张师傅', '13800000001', 4, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('worker2', '123456', '李师傅', '13800000002', 4, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('worker3', '123456', '王师傅', '13800000003', 4, 1);

-- 初始化业主用户
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345001', '123456', '张三', '13912345001', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345002', '123456', '李四', '13912345002', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345003', '123456', '王五', '13912345003', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345004', '123456', '赵六', '13912345004', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345005', '123456', '钱七', '13912345005', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345006', '123456', '孙八', '13912345006', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345007', '123456', '周九', '13912345007', 3, 1);
INSERT INTO `user` (`username`, `password`, `real_name`, `phone`, `role`, `status`) VALUES ('13912345008', '123456', '吴十', '13912345008', 3, 1);

-- 初始化业主信息
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (5, '张三', '13912345001', '320123199001011234', '1', '1', '101', 89.5);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (6, '李四', '13912345002', '320123199002021234', '1', '1', '102', 120.0);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (7, '王五', '13912345003', '320123199003031234', '1', '2', '201', 95.8);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (8, '赵六', '13912345004', '320123199004041234', '1', '2', '202', 110.5);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (9, '钱七', '13912345005', '320123199005051234', '2', '1', '301', 88.0);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (10, '孙八', '13912345006', '320123199006061234', '2', '1', '302', 135.2);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (11, '周九', '13912345007', '320123199007071234', '2', '2', '401', 102.0);
INSERT INTO `owner` (`user_id`, `name`, `phone`, `id_card`, `building`, `unit`, `room`, `area`) VALUES (12, '吴十', '13912345008', '320123199008081234', '2', '2', '402', 98.6);

-- 初始化报修数据
INSERT INTO `repair` (`owner_id`, `title`, `content`, `status`, `worker_id`, `cost`, `repair_record`, `rating`, `comment`, `create_time`) VALUES 
(1, '卫生间漏水', '卫生间天花板漏水，已经影响到正常使用，请尽快处理', 5, 3, 150.00, '更换了水管接头，修复漏水点', 5, '维修师傅很专业，服务态度好', DATE_SUB(NOW(), INTERVAL 15 DAY)),
(2, '门锁损坏', '入户门锁打不开，需要更换', 5, 4, 280.00, '更换了新门锁', 4, '修好了，谢谢', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(3, '空调不制冷', '客厅空调开机后不制冷，显示正常', 4, 3, 200.00, '清洗了空调滤网，添加制冷剂', NULL, NULL, DATE_SUB(NOW(), INTERVAL 8 DAY)),
(4, '马桶堵塞', '卫生间马桶堵塞，无法正常使用', 3, 4, 80.00, '疏通了下水道', NULL, NULL, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(5, '电路跳闸', '厨房电路经常跳闸，怀疑线路老化', 1, 3, NULL, NULL, NULL, NULL, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, '窗户漏风', '卧室窗户密封不好，冬天漏风严重', 0, NULL, NULL, NULL, NULL, NULL, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(6, '热水器故障', '热水器打不着火，无法使用热水', 0, NULL, NULL, NULL, NULL, NULL, NOW()),
(7, '墙面渗水', '客厅墙面有渗水痕迹，墙皮脱落', 0, NULL, NULL, NULL, NULL, NULL, NOW());

-- 初始化费用数据
INSERT INTO `fee` (`owner_id`, `type`, `amount`, `period`, `status`, `pay_time`, `remark`, `create_time`) VALUES 
(1, 1, 223.75, '2024-01', 1, DATE_SUB(NOW(), INTERVAL 60 DAY), '物业费', DATE_SUB(NOW(), INTERVAL 65 DAY)),
(1, 1, 223.75, '2024-02', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), '物业费', DATE_SUB(NOW(), INTERVAL 35 DAY)),
(1, 1, 223.75, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 2, 45.50, '2024-01', 1, DATE_SUB(NOW(), INTERVAL 55 DAY), '水费', DATE_SUB(NOW(), INTERVAL 60 DAY)),
(1, 3, 128.40, '2024-01', 1, DATE_SUB(NOW(), INTERVAL 55 DAY), '电费', DATE_SUB(NOW(), INTERVAL 60 DAY)),
(2, 1, 300.00, '2024-01', 1, DATE_SUB(NOW(), INTERVAL 58 DAY), '物业费', DATE_SUB(NOW(), INTERVAL 65 DAY)),
(2, 1, 300.00, '2024-02', 1, DATE_SUB(NOW(), INTERVAL 28 DAY), '物业费', DATE_SUB(NOW(), INTERVAL 35 DAY)),
(2, 1, 300.00, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 4, 200.00, '2024-01', 1, DATE_SUB(NOW(), INTERVAL 50 DAY), '停车费', DATE_SUB(NOW(), INTERVAL 55 DAY)),
(3, 1, 239.50, '2024-01', 1, DATE_SUB(NOW(), INTERVAL 62 DAY), '物业费', DATE_SUB(NOW(), INTERVAL 65 DAY)),
(3, 1, 239.50, '2024-02', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 35 DAY)),
(3, 1, 239.50, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(4, 1, 276.25, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(5, 1, 220.00, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(6, 1, 338.00, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(7, 1, 255.00, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(8, 1, 246.50, '2024-03', 0, NULL, '物业费', DATE_SUB(NOW(), INTERVAL 5 DAY));

-- 初始化通知公告
INSERT INTO `notice` (`title`, `content`, `publisher_id`, `status`, `create_time`) VALUES 
('关于小区停水通知', '尊敬的业主：因市政管网维修，本小区将于本周六（3月15日）上午8:00-12:00停水，请各位业主提前做好储水准备，给您带来不便敬请谅解。', 2, 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
('春季消防安全检查通知', '为确保小区消防安全，物业将于下周一至周五进行消防设施检查，届时工作人员可能需要进入您的房屋检查烟感器等设备，请予以配合。', 2, 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
('关于规范电动车停放的通知', '近期发现部分业主将电动车停放在楼道内充电，存在严重安全隐患。请各位业主将电动车停放至指定充电区域，违规停放将予以清理。', 2, 1, DATE_SUB(NOW(), INTERVAL 10 DAY)),
('物业费缴纳提醒', '尊敬的业主：2024年第一季度物业费已开始收取，请尚未缴费的业主尽快完成缴费，可通过线上系统或物业服务中心缴纳。', 2, 1, DATE_SUB(NOW(), INTERVAL 15 DAY)),
('小区绿化养护通知', '为美化小区环境，物业将于近期对小区绿化进行修剪养护，届时可能会产生一定噪音，请业主们谅解。', 2, 1, DATE_SUB(NOW(), INTERVAL 20 DAY)),
('端午节放假通知', '端午节期间（6月8日-10日），物业服务中心正常值班，如有紧急事务请拨打24小时服务热线：400-123-4567。祝各位业主节日快乐！', 2, 0, NOW());

-- 初始化投诉建议
INSERT INTO `complaint` (`owner_id`, `type`, `title`, `content`, `status`, `reply`, `handler_id`, `create_time`) VALUES 
(1, 1, '楼道卫生问题', '1栋1单元楼道卫生打扫不及时，垃圾堆积，希望加强清洁频次', 2, '感谢您的反馈，我们已安排保洁人员加强该区域清洁，每日打扫两次。', 2, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(2, 2, '建议增设快递柜', '小区目前快递柜数量不足，建议在2栋附近增设快递柜，方便业主取件', 2, '感谢您的建议，我们已与快递柜运营商联系，计划下月在2栋增设一组快递柜。', 2, DATE_SUB(NOW(), INTERVAL 8 DAY)),
(3, 1, '夜间施工噪音', '隔壁装修户晚上10点后还在施工，严重影响休息，请物业管理', 1, NULL, NULL, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 2, '建议增加健身器材', '小区健身区域器材较少，建议增加一些适合老年人的健身器材', 0, NULL, NULL, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(5, 1, '地下车库照明不足', '地下车库B区照明灯损坏多处，光线昏暗存在安全隐患', 0, NULL, NULL, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(6, 2, '建议开设业主活动室', '希望物业能开设业主活动室，供业主们下棋、读书等休闲活动', 0, NULL, NULL, NOW());

-- 初始化访客预约
INSERT INTO `visitor` (`owner_id`, `visitor_name`, `visitor_phone`, `visitor_id_card`, `reason`, `visit_time`, `status`, `remark`, `create_time`) VALUES 
(1, '张伟', '13611112222', '320123199501011234', '亲戚来访', DATE_ADD(NOW(), INTERVAL 1 DAY), 1, '', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, '李娜', '13622223333', '320123199602021234', '朋友聚会', DATE_ADD(NOW(), INTERVAL 2 DAY), 1, '', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, '王磊', '13633334444', '320123199703031234', '送货上门', DATE_ADD(NOW(), INTERVAL 1 DAY), 0, '大件家具配送', NOW()),
(4, '刘芳', '13644445555', '320123199804041234', '家政服务', DATE_ADD(NOW(), INTERVAL 3 DAY), 0, '', NOW()),
(1, '陈明', '13655556666', '320123199905051234', '维修空调', DATE_SUB(NOW(), INTERVAL 5 DAY), 3, '空调维修师傅', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(5, '赵丽', '13666667777', '320123199006061234', '探望父母', DATE_SUB(NOW(), INTERVAL 3 DAY), 3, '', DATE_SUB(NOW(), INTERVAL 4 DAY));

-- 初始化巡检记录
INSERT INTO `inspection` (`inspector_id`, `area`, `content`, `result`, `problem`, `status`, `create_time`) VALUES 
(2, '1栋1单元', '检查楼道照明、消防设施、卫生情况', '照明正常，消防设施完好，卫生良好', NULL, 0, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, '1栋2单元', '检查楼道照明、消防设施、卫生情况', '发现问题', '3楼消防栓玻璃破损，需更换', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, '2栋1单元', '检查楼道照明、消防设施、卫生情况', '照明正常，消防设施完好，卫生良好', NULL, 0, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, '2栋2单元', '检查楼道照明、消防设施、卫生情况', '照明正常，消防设施完好，卫生良好', NULL, 0, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, '地下车库A区', '检查照明、通风、消防设施', '发现问题', '部分照明灯损坏，通风正常', 1, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, '地下车库B区', '检查照明、通风、消防设施', '照明正常，通风正常，消防设施完好', NULL, 0, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, '小区绿化带', '检查绿化养护情况', '绿化良好，无病虫害', NULL, 0, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, '儿童游乐区', '检查游乐设施安全', '发现问题', '秋千座椅螺丝松动，需加固', 1, DATE_SUB(NOW(), INTERVAL 5 DAY));

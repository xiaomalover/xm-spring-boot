/*
SQLyog Ultimate v12.2.6 (64 bit)
MySQL - 8.0.12 : Database - xm_boot
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`xm_boot` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `xm_boot`;

/*Table structure for table `article_category` */

DROP TABLE IF EXISTS `article_category`;

CREATE TABLE `article_category` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `is_parent` bit(1) DEFAULT NULL COMMENT '是否父类',
  `parent_id` varchar(32) NOT NULL DEFAULT '' COMMENT '父类ID',
  `sort_no` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '排序',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '标题',
  `short_title` varchar(32) NOT NULL DEFAULT '' COMMENT '短标题',
  `relations` varchar(255) NOT NULL DEFAULT '' COMMENT '完整关系',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `article_category` */

insert  into `article_category`(`id`,`is_parent`,`parent_id`,`sort_no`,`title`,`short_title`,`relations`,`status`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('246051614496919552',NULL,'0',1.00,'test','teaaa11','246051614496919552',0,1582954417,'admin',1582959143,'admin'),
('246084721493151744','','0',1.00,'ddd','dd','246084721493151744',0,1582962310,'admin',1582962316,'admin'),
('246084745308409856',NULL,'246084721493151744',1.00,'fff','ddd','246084721493151744,246084745308409856',0,1582962316,'admin',1582962316,'admin');

/*Table structure for table `article_info` */

DROP TABLE IF EXISTS `article_info`;

CREATE TABLE `article_info` (
  `id` varchar(32) NOT NULL,
  `category_id` varchar(32) NOT NULL DEFAULT '' COMMENT '文章分类ID',
  `title` varchar(128) NOT NULL DEFAULT '' COMMENT '文章标题',
  `thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '文章封面图',
  `summary` text COMMENT '文章简介',
  `content` text COMMENT '文章内容',
  `author` varchar(32) DEFAULT NULL COMMENT '作者',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态（0启用;1禁用）',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

/*Data for the table `article_info` */

/*Table structure for table `qrtz_blob_triggers` */

DROP TABLE IF EXISTS `qrtz_blob_triggers`;

CREATE TABLE `qrtz_blob_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_blob_triggers` */

/*Table structure for table `qrtz_calendars` */

DROP TABLE IF EXISTS `qrtz_calendars`;

CREATE TABLE `qrtz_calendars` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(200) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_calendars` */

/*Table structure for table `qrtz_cron_triggers` */

DROP TABLE IF EXISTS `qrtz_cron_triggers`;

CREATE TABLE `qrtz_cron_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `CRON_EXPRESSION` varchar(200) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_cron_triggers` */

insert  into `qrtz_cron_triggers`(`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`CRON_EXPRESSION`,`TIME_ZONE_ID`) values 
('quartzScheduler','com.xm.admin.quartz.jobs.JobWithoutParam','DEFAULT','*/5 * * * * ?','Asia/Shanghai'),
('quartzScheduler','com.xm.admin.quartz.jobs.JobWithParam','DEFAULT','*/5 * * * * ?','Asia/Shanghai');

/*Table structure for table `qrtz_fired_triggers` */

DROP TABLE IF EXISTS `qrtz_fired_triggers`;

CREATE TABLE `qrtz_fired_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_fired_triggers` */

/*Table structure for table `qrtz_job_details` */

DROP TABLE IF EXISTS `qrtz_job_details`;

CREATE TABLE `qrtz_job_details` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_job_details` */

insert  into `qrtz_job_details`(`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`,`DESCRIPTION`,`JOB_CLASS_NAME`,`IS_DURABLE`,`IS_NONCONCURRENT`,`IS_UPDATE_DATA`,`REQUESTS_RECOVERY`,`JOB_DATA`) values 
('quartzScheduler','com.xm.admin.quartz.jobs.JobWithoutParam','DEFAULT',NULL,'com.xm.admin.quartz.jobs.JobWithoutParam','0','0','0','0','��\0sr\0org.quartz.JobDataMap���迩��\0\0xr\0&org.quartz.utils.StringKeyDirtyFlagMap�����](\0Z\0allowsTransientDataxr\0org.quartz.utils.DirtyFlagMap�.�(v\n�\0Z\0dirtyL\0mapt\0Ljava/util/Map;xpsr\0java.util.HashMap���`�\0F\0\nloadFactorI\0	thresholdxp?@\0\0\0\0\0w\0\0\0\0\0\0t\0	parametert\0nullx\0'),
('quartzScheduler','com.xm.admin.quartz.jobs.JobWithParam','DEFAULT',NULL,'com.xm.admin.quartz.jobs.JobWithParam','0','0','0','0','��\0sr\0org.quartz.JobDataMap���迩��\0\0xr\0&org.quartz.utils.StringKeyDirtyFlagMap�����](\0Z\0allowsTransientDataxr\0org.quartz.utils.DirtyFlagMap�.�(v\n�\0Z\0dirtyL\0mapt\0Ljava/util/Map;xpsr\0java.util.HashMap���`�\0F\0\nloadFactorI\0	thresholdxp?@\0\0\0\0\0w\0\0\0\0\0\0t\0	parametert\0Test Jobx\0');

/*Table structure for table `qrtz_locks` */

DROP TABLE IF EXISTS `qrtz_locks`;

CREATE TABLE `qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_locks` */

insert  into `qrtz_locks`(`SCHED_NAME`,`LOCK_NAME`) values 
('quartzScheduler','TRIGGER_ACCESS');

/*Table structure for table `qrtz_paused_trigger_grps` */

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;

CREATE TABLE `qrtz_paused_trigger_grps` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_paused_trigger_grps` */

/*Table structure for table `qrtz_quartz_job` */

DROP TABLE IF EXISTS `qrtz_quartz_job`;

CREATE TABLE `qrtz_quartz_job` (
  `id` varchar(32) NOT NULL,
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(255) DEFAULT NULL,
  `cron_expression` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `job_class_name` varchar(255) DEFAULT NULL,
  `parameter` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `qrtz_quartz_job` */

insert  into `qrtz_quartz_job`(`id`,`created_at`,`created_by`,`updated_at`,`updated_by`,`cron_expression`,`description`,`job_class_name`,`parameter`,`status`) values 
('119642809568333824',1582959143,'admin',1582963170,'admin','*/5 * * * * ?','无参数定时任务','com.xm.admin.quartz.jobs.JobWithoutParam','null',-1),
('95632048328282112',1582959143,'null',1582963349,'null','*/5 * * * * ?','有参测试任务','com.xm.admin.quartz.jobs.JobWithParam','Test Job',-1);

/*Table structure for table `qrtz_scheduler_state` */

DROP TABLE IF EXISTS `qrtz_scheduler_state`;

CREATE TABLE `qrtz_scheduler_state` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_scheduler_state` */

/*Table structure for table `qrtz_simple_triggers` */

DROP TABLE IF EXISTS `qrtz_simple_triggers`;

CREATE TABLE `qrtz_simple_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_simple_triggers` */

/*Table structure for table `qrtz_simprop_triggers` */

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;

CREATE TABLE `qrtz_simprop_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_simprop_triggers` */

/*Table structure for table `qrtz_triggers` */

DROP TABLE IF EXISTS `qrtz_triggers`;

CREATE TABLE `qrtz_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `qrtz_triggers` */

insert  into `qrtz_triggers`(`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`JOB_NAME`,`JOB_GROUP`,`DESCRIPTION`,`NEXT_FIRE_TIME`,`PREV_FIRE_TIME`,`PRIORITY`,`TRIGGER_STATE`,`TRIGGER_TYPE`,`START_TIME`,`END_TIME`,`CALENDAR_NAME`,`MISFIRE_INSTR`,`JOB_DATA`) values 
('quartzScheduler','com.xm.admin.quartz.jobs.JobWithoutParam','DEFAULT','com.xm.admin.quartz.jobs.JobWithoutParam','DEFAULT',NULL,1582963175000,1582963170000,5,'PAUSED','CRON',1582874453000,0,NULL,0,''),
('quartzScheduler','com.xm.admin.quartz.jobs.JobWithParam','DEFAULT','com.xm.admin.quartz.jobs.JobWithParam','DEFAULT',NULL,1582963350000,1582963345000,5,'PAUSED','CRON',1582874455000,0,NULL,0,'');

/*Table structure for table `sys_admin` */

DROP TABLE IF EXISTS `sys_admin`;

CREATE TABLE `sys_admin` (
  `id` varchar(32) NOT NULL,
  `address` varchar(128) NOT NULL DEFAULT '',
  `avatar` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(64) DEFAULT NULL,
  `mobile` varchar(32) DEFAULT NULL,
  `nick_name` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL DEFAULT '',
  `sex` tinyint(1) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `type` tinyint(1) NOT NULL DEFAULT '1',
  `username` varchar(32) DEFAULT NULL,
  `department_id` varchar(32) NOT NULL DEFAULT '',
  `street` varchar(255) NOT NULL DEFAULT '',
  `pass_strength` varchar(2) NOT NULL DEFAULT '',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_admin` */

insert  into `sys_admin`(`id`,`address`,`avatar`,`description`,`email`,`mobile`,`nick_name`,`password`,`sex`,`status`,`type`,`username`,`department_id`,`street`,`pass_strength`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('47599079840026624','[\"440000\",\"440300\",\"440305\"]','','','DM@gmail.com','13888888888','','$2a$10$zXdiP.pMKunw8CmWdahPFunxnjfuXjcEvJdzFAcp79UazQTxb78P2',1,0,1,'admin','87335940934078464','','',1582959143,'admin',1582959143,'admin'),
('87338083204206592','[\"440000\",\"440300\",\"440305\"]','','','a@b.com','13333333333','','$2a$10$zXdiP.pMKunw8CmWdahPFunxnjfuXjcEvJdzFAcp79UazQTxb78P2',1,0,1,'test','87336063856545792','','',1582959143,'admin',1582959143,'admin');

/*Table structure for table `sys_admin_log` */

DROP TABLE IF EXISTS `sys_admin_log`;

CREATE TABLE `sys_admin_log` (
  `id` varchar(32) NOT NULL,
  `cost_time` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(64) NOT NULL DEFAULT '',
  `ip_info` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `request_param` varchar(512) NOT NULL DEFAULT '',
  `request_type` varchar(16) NOT NULL DEFAULT '',
  `request_url` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(32) NOT NULL DEFAULT '',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_admin_log` */

insert  into `sys_admin_log`(`id`,`cost_time`,`ip`,`ip_info`,`name`,`request_param`,`request_type`,`request_url`,`username`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('246089165475680256',28,'127.0.0.1','','登录系统','{\"password\":\"你是看不见我的\",\"captcha\":\"h1le\",\"saveLogin\":\"true\",\"captchaId\":\"0aae84dc5be54346b308f9ce35220125\",\"username\":\"test\"}','POST','/skeleton/login','admin',1582963370,'admin',1582963370,'admin'),
('246088609797509120',6,'127.0.0.1','','添加定时任务','{\"cronExpression\":\"*/4 * * * * ?\",\"paramter\":\"\",\"jobClassName\":\"com.xm.admin.quartz.jobs.JobWithParam\",\"parameter\":\"a\",\"description\":\"aaa\"}','POST','/skeleton/quartzJob/add','admin',1582963237,'admin',1582963237,'admin'),
('246089079333064704',91,'127.0.0.1','','暂停定时任务','{\"cronExpression\":\"*/5 * * * * ?\",\"createdAt\":\"1582959143\",\"updatedBy\":\"null\",\"_index\":\"1\",\"createdBy\":\"null\",\"jobClassName\":\"com.xm.admin.quartz.jobs.JobWithParam\",\"parameter\":\"Test Job\",\"description\":\"有参测试任务\",\"id\":\"95632048328282112\",\"updatedAt\":\"1582963187\",\"status\":\"0\",\"_rowKey\":\"54\"}','POST','/skeleton/quartzJob/pause','admin',1582963349,'admin',1582963349,'admin'),
('246088400082309120',100,'127.0.0.1','','恢复定时任务','{\"cronExpression\":\"*/5 * * * * ?\",\"createdAt\":\"1582959143\",\"updatedBy\":\"null\",\"_index\":\"1\",\"createdBy\":\"null\",\"jobClassName\":\"com.xm.admin.quartz.jobs.JobWithParam\",\"parameter\":\"Test Job\",\"description\":\"有参测试任务\",\"id\":\"95632048328282112\",\"updatedAt\":\"1582963172\",\"status\":\"-1\",\"_rowKey\":\"18\"}','POST','/skeleton/quartzJob/resume','admin',1582963187,'admin',1582963187,'admin');

/*Table structure for table `sys_admin_role` */

DROP TABLE IF EXISTS `sys_admin_role`;

CREATE TABLE `sys_admin_role` (
  `id` varchar(32) NOT NULL,
  `role_id` varchar(32) NOT NULL DEFAULT '',
  `user_id` varchar(32) NOT NULL DEFAULT '',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_admin_role` */

insert  into `sys_admin_role`(`id`,`role_id`,`user_id`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('51919463095734273','496138616573953','51919414177566720',1582959143,'admin',1582959143,'admin'),
('126616146991386624','496138616573952','47599079840026624',1582959143,'admin',1582959143,'admin'),
('126477266149445632','496138616573953','87338083204206592',1582959143,'admin',1582959143,'admin'),
('116844842029420544','496138616573952','116844841647738880',1582959143,'admin',1582959143,'admin'),
('116847350214823936','496138616573952','116846552936353792',1582959143,'admin',1582959143,'admin'),
('116851632993472512','116849032776650752','116847659427303424',1582959143,'admin',1582959143,'admin'),
('116850548648448000','496138616573952','116848891118227456',1582959143,'admin',1582959143,'admin'),
('117180303184760832','496138616573953','117180302777913344',1582959143,'admin',1582959143,'admin');

/*Table structure for table `sys_department` */

DROP TABLE IF EXISTS `sys_department`;

CREATE TABLE `sys_department` (
  `id` varchar(32) NOT NULL,
  `is_parent` bit(1) DEFAULT NULL,
  `parent_id` varchar(32) NOT NULL DEFAULT '',
  `sort_order` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `title` varchar(64) NOT NULL DEFAULT '',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_department` */

insert  into `sys_department`(`id`,`is_parent`,`parent_id`,`sort_order`,`status`,`title`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('87336063856545792','\0','87335940934078464',1.00,0,'数据维护',1582959143,'admin',1582959143,'admin'),
('87335940934078464','','0',1.00,0,'运营中心',1582959143,'admin',1582959143,'admin'),
('117179715390803968','','0',1.00,0,'研发中心',1582959143,'admin',1582959143,'admin'),
('117179754469134336',NULL,'117179715390803968',1.00,0,'研发一部',1582959143,'admin',1582959143,'admin');

/*Table structure for table `sys_permission` */

DROP TABLE IF EXISTS `sys_permission`;

CREATE TABLE `sys_permission` (
  `id` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `parent_id` varchar(32) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` decimal(10,2) NOT NULL DEFAULT '0.00',
  `component` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(128) NOT NULL DEFAULT '',
  `title` varchar(32) NOT NULL DEFAULT '',
  `icon` varchar(32) NOT NULL DEFAULT '',
  `level` tinyint(1) NOT NULL DEFAULT '0',
  `button_type` varchar(32) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_permission` */

insert  into `sys_permission`(`id`,`description`,`name`,`parent_id`,`type`,`sort_order`,`component`,`path`,`title`,`icon`,`level`,`button_type`,`status`,`url`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('5129710648430592','','sys','',0,3.00,'Main','/form','系统管理','ios-settings',1,'',0,'',1582959143,'admin',1582959143,'admin'),
('5129710648430593','','user-manage','5129710648430592',0,1.10,'module/sys/user-manage/userManage','user-manage','管理员管理','md-person',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('5129710648430594','','role-manage','5129710648430592',0,1.50,'module/sys/role-manage/roleManage','role-manage','角色管理','md-contacts',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('5129710648430595','','menu-manage','5129710648430592',0,1.60,'module/sys/menu-manage/menuManage','menu-manage','菜单权限管理','md-menu',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('15701400130424832','','','5129710648430593',1,1.11,'','/skeleton/user/admin/add','添加用户','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('15701915807518720','','','5129710648430593',1,1.13,'','/skeleton/user/admin/disable/**','禁用用户','',3,'disable',0,'',1582959143,'admin',1582959143,'admin'),
('15708892205944832','','','5129710648430593',1,1.14,'','/skeleton/user/admin/enable/**','启用用户','',3,'enable',0,'',1582959143,'admin',1582959143,'admin'),
('16678126574637056','','','5129710648430593',1,1.12,'','/skeleton/user/admin/edit','编辑用户','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('16678447719911424','','','5129710648430593',1,1.15,'','/skeleton/user/delByIds/**','删除用户','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('16687383932047360','','','5129710648430594',1,1.21,'','/skeleton/role/save','添加角色','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('16689632049631232','','','5129710648430594',1,1.22,'','/skeleton/role/edit','编辑角色','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('16689745006432256','','','5129710648430594',1,1.23,'','/skeleton/role/delAllByIds/**','删除角色','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('16689883993083904','','','5129710648430594',1,1.24,'','/skeleton/role/editRolePerm/**','分配权限','',3,'editPerm',0,'',1582959143,'admin',1582959143,'admin'),
('16690313745666048','','','5129710648430594',1,1.25,'','/skeleton/role/setDefault','设为默认角色','',3,'setDefault',0,'',1582959143,'admin',1582959143,'admin'),
('16694861252005888','','','5129710648430595',1,1.31,'','/skeleton/permission/add','添加菜单','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('16695107491205120','','','5129710648430595',1,1.32,'','/skeleton/permission/edit','编辑菜单','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('16695243126607872','','','5129710648430595',1,1.33,'','/skeleton/permission/delByIds/**','删除菜单','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('39915540965232640','','monitor','',0,4.00,'Main','/monitor','系统监控','ios-analytics',1,'',0,'',1582959143,'admin',1582959143,'admin'),
('40238597734928384','','department-manage','5129710648430592',0,1.20,'module/sys/department-manage/departmentManage','department-manage','部门管理','md-git-branch',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('41363147411427328','','log-manage','39915540965232640',0,2.20,'module/sys/log-manage/logManage','log-manage','操作日志管理','md-list-box',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('41363537456533504','','','41363147411427328',1,2.11,'','/skeleton/log/delByIds/**','删除日志','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('41364927394353152','','','41363147411427328',1,2.12,'','/skeleton/log/delAll','清空日志','',3,'undefined',0,'',1582959143,'admin',1582959143,'admin'),
('45235621697949696','','','40238597734928384',1,1.21,'','/skeleton/department/add','添加部门','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('45235787867885568','','','40238597734928384',1,1.22,'','/skeleton/department/edit','编辑部门','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('45235939278065664','','','40238597734928384',1,1.23,'','/skeleton/department/delByIds/*','删除部门','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('84907582589767680','','quartz-job','39915540965232640',0,2.10,'module/sys/quartz-manage/quartzManage','quartz-job','定时任务','md-time',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('84907899767230464','','','84907582589767680',1,2.11,'','/skeleton/quartzJob/add*','添加定时任务','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('84908172535402496','','','84907582589767680',1,2.12,'','/skeleton/quartzJob/edit*','编辑定时任务','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('84908391842975744','','','84907582589767680',1,2.13,'','/skeleton/quartzJob/pause*','暂停定时任务','',3,'disable',0,'',1582959143,'admin',1582959143,'admin'),
('84908678297161728','','','84907582589767680',1,2.14,'','/skeleton/quartzJob/resume*','恢复定时任务','',3,'enable',0,'',1582959143,'admin',1582959143,'admin'),
('84908899202764800','','','84907582589767680',1,2.15,'','/skeleton/quartzJob/delByIds/*','删除定时任务','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('126477677677776896','','article','',0,1.00,'Main','/article','文章管理','ios-book',1,'',0,'',1582959143,'admin',1582959143,'admin'),
('126478074127585280','','articleCategory','126477677677776896',0,1.00,'module/article/category/categoryManage','module/article/category','分类管理','md-bookmarks',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('126495528849510400','','articleInfo','126477677677776896',0,1.00,'module/article/info/articleManage','module/article/info','文章管理','ios-book-outline',2,'',0,'',1582959143,'admin',1582959143,'admin'),
('126612524110974976','','','126478074127585280',1,1.00,'','/skeleton/article/category/add','添加分类','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('126612730214879232','','','126478074127585280',1,1.00,'','/skeleton/article/category/edit','修改分类','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('126613271254929408','','','126478074127585280',1,1.00,'','/skeleton/article/category/delByIds/**','删除分类','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('126613728463425536','','','126495528849510400',1,1.00,'','/skeleton/article/add','添加文章','',3,'add',0,'',1582959143,'admin',1582959143,'admin'),
('126613843764842496','','','126495528849510400',1,1.00,'','/skeleton/article/delByIds/**','删除文章','',3,'delete',0,'',1582959143,'admin',1582959143,'admin'),
('126613956428042240','','','126495528849510400',1,1.00,'','/skeleton/article/edit','修改文章','',3,'edit',0,'',1582959143,'admin',1582959143,'admin'),
('126614281000062976','','','126495528849510400',1,1.00,'','/skeleton/article/enable/**','启用文章','',3,'enable',0,'',1582959143,'admin',1582959143,'admin'),
('126614454480670720','','','126495528849510400',1,1.00,'','/skeleton/article/disable/**','禁用文章','',3,'disable',0,'',1582959143,'admin',1582959143,'admin');

/*Table structure for table `sys_role` */

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
  `id` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL DEFAULT '',
  `default_role` bit(1) DEFAULT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `data_type` int(11) DEFAULT NULL,
  `created_at` int(11) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_role` */

insert  into `sys_role`(`id`,`name`,`default_role`,`description`,`data_type`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('496138616573952','ROLE_ADMIN','','超级管理员 拥有所有权限',NULL,1582959143,'admin',1582963317,'admin'),
('496138616573953','ROLE_USER','\0','普通浏览',NULL,1582959143,'admin',1582963315,'admin');

/*Table structure for table `sys_role_permission` */

DROP TABLE IF EXISTS `sys_role_permission`;

CREATE TABLE `sys_role_permission` (
  `id` varchar(32) NOT NULL,
  `permission_id` varchar(32) NOT NULL DEFAULT '',
  `role_id` varchar(32) NOT NULL DEFAULT '',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0',
  `created_by` varchar(32) NOT NULL DEFAULT '',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_by` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sys_role_permission` */

insert  into `sys_role_permission`(`id`,`permission_id`,`role_id`,`created_at`,`created_by`,`updated_at`,`updated_by`) values 
('126617812872466432','41364927394353152','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812864077824','41363537456533504','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812859883520','41363147411427328','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812851494912','84908899202764800','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812847300608','84908678297161728','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812843106304','84908391842975744','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812834717696','84908172535402496','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812830523392','84907899767230464','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812826329088','84907582589767680','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812822134784','39915540965232640','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812813746176','16695243126607872','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812809551872','16695107491205120','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812801163264','16694861252005888','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812792774656','5129710648430595','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812788580352','16690313745666048','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812784386048','16689883993083904','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812780191744','16689745006432256','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812775997440','16689632049631232','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812767608832','16687383932047360','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812763414528','5129710648430594','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812759220224','45235939278065664','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812755025920','45235787867885568','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812746637312','45235621697949696','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812742443008','40238597734928384','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812729860096','16678447719911424','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812725665792','15708892205944832','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812721471488','15701915807518720','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812713082880','16678126574637056','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812708888576','15701400130424832','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812700499968','5129710648430593','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812696305664','5129710648430592','496138616573952',1582959143,'admin',1582959143,'admin'),
('126632044707975168','5129710648430595','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044703780864','5129710648430594','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044691197952','40238597734928384','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044682809344','5129710648430593','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044678615040','5129710648430592','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044666032128','126495528849510400','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044661837824','126478074127585280','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044645060608','126477677677776896','496138616573953',1582959143,'admin',1582959143,'admin'),
('126617812692111360','126614454480670720','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812683722752','126614281000062976','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812679528448','126613956428042240','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812671139840','126613843764842496','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812662751232','126613728463425536','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812654362624','126495528849510400','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812645974016','126613271254929408','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812641779712','126612730214879232','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812633391104','126612524110974976','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812625002496','126478074127585280','496138616573952',1582959143,'admin',1582959143,'admin'),
('126617812616613888','126477677677776896','496138616573952',1582959143,'admin',1582959143,'admin'),
('126632044716363776','39915540965232640','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044720558080','84907582589767680','496138616573953',1582959143,'admin',1582959143,'admin'),
('126632044724752384','41363147411427328','496138616573953',1582959143,'admin',1582959143,'admin');

/*Table structure for table `user_info` */

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
  `id` varchar(32) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `mobile` varchar(32) NOT NULL DEFAULT '' COMMENT '手机号',
  `password` varchar(64) DEFAULT '' COMMENT '密码',
  `email` varchar(32) DEFAULT '' COMMENT '邮箱',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态',
  `created_at` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `user_info` */

insert  into `user_info`(`id`,`username`,`mobile`,`password`,`email`,`status`,`created_at`,`updated_at`) values 
('245742660202008576','aaaa','13888888888','14e1b600b1fd579f47433b88e8d85291','',1,1582880756,1582880756);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


-- 新闻主要信息表
CREATE TABLE IF NOT EXISTS `news_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `label` varchar(64) NOT NULL,
  `source` varchar(128) NOT NULL,
  `main_image` varchar(128),
  `title` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `create_date` datetime NOT NULL,
  `news_date` datetime NOT NULL,
  `source_comment_num` int(11),
  `topic_word` varchar(64)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- 新闻具体内容表
CREATE TABLE IF NOT EXISTS `content_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `news_id` int(11) NOT NULL,
  `content` VARCHAR(8000) COLLATE utf8_unicode_ci NOT NULL,
  `content_type` int(1) NOT NULL,
  `index_id` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- 用户信息表
CREATE TABLE `user` (
  `id` INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `openid` VARCHAR(150) COLLATE UTF8_UNICODE_CI NOT NULL UNIQUE KEY,
  `token` VARCHAR(300) COLLATE UTF8_UNICODE_CI NOT NULL,
  `session_key` VARCHAR(200) COLLATE UTF8_UNICODE_CI DEFAULT NULL,
  `avartarUrl` VARCHAR(800) COLLATE UTF8_UNICODE_CI DEFAULT NULL,
  `nickName` VARCHAR(70) COLLATE UTF8_UNICODE_CI DEFAULT NULL,
  `country` VARCHAR(80) COLLATE UTF8_UNICODE_CI DEFAULT NULL,
  `province` VARCHAR(80) COLLATE UTF8_UNICODE_CI DEFAULT NULL,
  `city` VARCHAR(80) COLLATE UTF8_UNICODE_CI DEFAULT NULL,
  `gender` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;


-- 新闻栏目ID和栏目信息映射表
CREATE TABLE IF NOT EXISTS `label_column_mapping` (
  `label_id` INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `label` VARCHAR(64) NOT NULL UNIQUE KEY,
  `column_name` VARCHAR(60) COLLATE UTF8_UNICODE_CI NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;
INSERT INTO `label_column_mapping`(`label`,`column_name`) VALUES ('sport','体育');
INSERT INTO `label_column_mapping`(`label`,`column_name`) VALUES ('ent','娱乐');
INSERT INTO `label_column_mapping`(`label`,`column_name`) VALUES ('politics','体育');
INSERT INTO `label_column_mapping`(`label`,`column_name`) VALUES ('recommend','推荐');


-- 用户个人栏目表
CREATE TABLE IF NOT EXISTS `user_column_mapping`(
	`openid` VARCHAR(150) COLLATE UTF8_UNICODE_CI NOT NULL,
	`label_id` INT(11) AUTO_INCREMENT NOT NULL,
	CONSTRAINT FOREIGN KEY(`openid`) REFERENCES `user`(`openid`)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY(`label_id`) REFERENCES `label_column_mapping`(`label_id`)
	ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;


-- 点击记录表
CREATE TABLE IF NOT EXISTS `user_clicks`(
	`id` INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`user_id` INT(11) NOT NULL,
	`news_id` INT(11) NOT NULL,
	`start_time` DATETIME NOT NULL,
	`duration` INT(11) DEFAULT NULL,
	`label` VARCHAR(64) NOT NULL,
	CONSTRAINT FOREIGN KEY(`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY(`label`) REFERENCES `label_column_mapping`(`label`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;


-- 用户评论记录表
CREATE TABLE IF NOT EXISTS `user_comment`(
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT(11) NOT NULL,
  `news_id` INT(11) NOT NULL,
  `nick_name` VARCHAR(20) COLLATE utf8_unicode_ci NOT NULL,
  `comment` VARCHAR(1500) COLLATE utf8_unicode_ci NOT NULL,
  `created_date` DATETIME NOT NULL,
  	CONSTRAINT FOREIGN KEY(`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY(`news_id`) REFERENCES `news_list`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;



-- 收藏记录表
CREATE TABLE IF NOT EXISTS `user_collection`(
	`id` INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`user_id` INT(11) NOT NULL,
	`news_id` INT(11) NOT NULL,
	CONSTRAINT FOREIGN KEY(`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY(`news_id`) REFERENCES `news_list`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;

-- 点赞记录表
CREATE TABLE IF NOT EXISTS `user_thumbsup`(
	`id` INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`user_id` INT(11) NOT NULL,
	`news_id` INT(11) NOT NULL,
	CONSTRAINT FOREIGN KEY(`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FOREIGN KEY(`news_id`) REFERENCES `news_list`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;



-- 算法表
CREATE TABLE IF NOT EXISTS `algorithm`(
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `algorithm` varchar(256) NOT NULL,
  `algorithm_ch` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;
INSERT INTO `algorithm`(`algorithm`,`algorithm_ch`,`contributor`,`description`) VALUES ('mostPopular_recommend\.py','热点新闻推荐算法','网宿科技','Hot-Based Recommendation');
INSERT INTO `algorithm`(`algorithm`,`algorithm_ch`,`contributor`,`description`) VALUES ('content_recommend\.py','基于内同相似度推荐算法','网宿科技','Content-Based Recommendation');
INSERT INTO `algorithm`(`algorithm`,`algorithm_ch`,`contributor`,`description`) VALUES ('ucf_recommend\.py','协同过滤算法','网宿科技','Collaboratice Filtering');


-- 栏目下可选算法表
CREATE TABLE IF NOT EXISTS `label_algorithm` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `label_id` INT(11) NOT NULL,
  `algorithm_id` INT(11) NOT NULL,
  CONSTRAINT FOREIGN KEY(`label_id`) REFERENCES `label_column_mapping`(`label_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY(`algorithm_id`) REFERENCES `algorithm`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;



-- 用户 栏目 算法关联表
CREATE TABLE IF NOT EXISTS `user_label_al` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  `algorithm_id` int(11) NOT NULL,
  CONSTRAINT FOREIGN KEY(`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY(`label_id`) REFERENCES `label_column_mapping`(`label_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY(`algorithm_id`) REFERENCES `algorithm`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_UNICODE_CI;

/*
Navicat MySQL Data Transfer

Source Server         : winter
Source Server Version : 50723
Source Host           : localhost:3306
Source Database       : winter

Target Server Type    : MYSQL
Target Server Version : 50723
File Encoding         : 65001

Date: 2018-12-24 14:38:37
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for contests
-- ----------------------------
DROP TABLE IF EXISTS `contests`;
CREATE TABLE `contests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `mainText` text,
  `startTime` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `endTime` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `url` text,
  `platform` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for files
-- ----------------------------
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `realName` text NOT NULL COMMENT 'filename',
  `path` text NOT NULL,
  `author` text,
  `time` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `type` smallint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for matches
-- ----------------------------
DROP TABLE IF EXISTS `matches`;
CREATE TABLE `matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(11) NOT NULL DEFAULT '0',
  `date` date NOT NULL DEFAULT '2000-01-01',
  `title` text NOT NULL,
  `mainText` text,
  `gold` smallint(6) NOT NULL DEFAULT '0',
  `silver` smallint(6) NOT NULL DEFAULT '0',
  `bronze` smallint(6) NOT NULL DEFAULT '0',
  `newsUrl` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for members
-- ----------------------------
DROP TABLE IF EXISTS `members`;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(16) NOT NULL DEFAULT '佚名',
  `grade` int(4) DEFAULT '2000',
  `major` char(24) DEFAULT NULL,
  `email` char(30) DEFAULT NULL,
  `blog` char(80) DEFAULT NULL,
  `introduce` text,
  `photo` int(11) DEFAULT NULL,
  `work` text,
  `identity` smallint(6) NOT NULL DEFAULT '0',
  `status` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `title` text CHARACTER SET utf8,
  `mainText` text CHARACTER SET utf8,
  `author` text CHARACTER SET utf8,
  `publishTime` datetime NOT NULL,
  `lookCount` int(1) NOT NULL DEFAULT '0',
  `status` smallint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for photoes
-- ----------------------------
DROP TABLE IF EXISTS `photoes`;
CREATE TABLE `photoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userName` char(18) NOT NULL,
  `fileid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userName` (`userName`),
  KEY `fileid` (`fileid`),
  CONSTRAINT `fileid` FOREIGN KEY (`fileid`) REFERENCES `files` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userName` FOREIGN KEY (`userName`) REFERENCES `users` (`userName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for speaks
-- ----------------------------
DROP TABLE IF EXISTS `speaks`;
CREATE TABLE `speaks` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `mainText` text CHARACTER SET utf8,
  `author` char(18) CHARACTER SET utf8 NOT NULL DEFAULT '匿名',
  `publishTime` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `isUser` smallint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `userName` char(20) NOT NULL,
  `password` char(35) NOT NULL,
  `nickName` char(20) DEFAULT NULL,
  `motto` text,
  `status` smallint(6) NOT NULL DEFAULT '0',
  `power` smallint(1) NOT NULL DEFAULT '0',
  `alowModify` smallint(1) NOT NULL DEFAULT '1',
  `className` char(20) DEFAULT NULL,
  `school` char(20) DEFAULT NULL,
  `email` char(30) DEFAULT NULL,
  `blog` char(80) DEFAULT NULL,
  `codeforcesid` char(20) DEFAULT NULL,
  `newcoderid` char(20) DEFAULT NULL,
  `atcoderid` char(20) DEFAULT NULL,
  `vjudgeid` char(20) DEFAULT NULL,
  `upcojid` char(20) DEFAULT NULL,
  `lduojid` char(20) DEFAULT NULL,
  `rating` int(1) NOT NULL DEFAULT '0',
  `codeforcesRating` int(1) NOT NULL DEFAULT '0',
  `newcoderRating` int(1) NOT NULL DEFAULT '0',
  `atcoderRating` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`userName`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

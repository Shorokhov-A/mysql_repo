-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение».
-- Задание №1.

DROP DATABASE IF EXISTS `shop`;
CREATE DATABASE `shop`;
USE `shop`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL,
	`name` VARCHAR(255),
	`birthday_at` DATE,
	`created_at` DATETIME,
	`updated_at` DATETIME
);

INSERT INTO `users` (`name`, `birthday_at`) VALUES
	('Павел', '1973-02-15'),
	('Алексей', '1991-08-25'),
	('Светлана', '1987-10-14'),
	('Александр', '1986-05-10'),
	('Екатерина', '2001-03-18'),
	('Борис', '1989-06-23');
  
UPDATE `users` SET `created_at` = NOW(), `updated_at` = NOW();
SELECT * FROM `users`; -- Таблица users 1.

-- Задание №2.

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL,
	`name` VARCHAR(255),
	`birthday_at` DATE,
	`created_at` VARCHAR(255),
	`updated_at` VARCHAR(255)
);

INSERT INTO `users` (`name`, `birthday_at`, `created_at`, `updated_at`) VALUES
	('Павел', '1973-02-15', '20.10.2017 8:10', '20.10.2017 8:10'),
	('Алексей', '1991-08-25', '15.01.2020 16:35', '15.01.2020 16:35'),
	('Светлана', '1987-10-14', '13.07.2012 11:05', '13.07.2012 11:05'),
	('Александр', '1986-05-10', '14.04.2019 13:21', '14.04.2019 13:21'),
	('Екатерина', '2001-03-18', '29.12.2007 19:45', '29.12.2007 19:45'),
	('Борис', '1989-06-23', '19.09.2014 15:10', '19.09.2014 15:10');

SELECT * FROM `users`; -- Таблица users 1(2)

UPDATE `users`
SET
`created_at` = STR_TO_DATE(`created_at`, '%d.%m.%Y %k:%i'),
`updated_at` = STR_TO_DATE(`updated_at`, '%d.%m.%Y %k:%i');

ALTER TABLE `users`
CHANGE
`created_at` `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users
CHANGE
`updated_at` `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM `users`; -- Таблица users 1(3)

-- Задание №3.

DROP TABLE IF EXISTS `storehouses_products`;
CREATE TABLE `storehouses_products` (
	`id` SERIAL,
	`storehouse_id` INT UNSIGNED,
	`product_id` INT UNSIGNED,
	`value` INT UNSIGNED,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `storehouses_products` (`storehouse_id`, `product_id`, `value`) VALUES
(1, 490, 0),
(1, 810, 2500),
(1, 2150, 0),
(1, 530, 30),
(1, 940, 500),
(1, 760, 1);
  
SELECT * FROM `storehouses_products` ORDER BY IF (`value` > 0, 0, 1), `value`; -- Таблица storehouses_products 1(4)

-- Задание №4.

SELECT `name`, `birthday_at` FROM `users` WHERE DATE_FORMAT(`birthday_at`, '%M') IN ('may', 'august'); -- Таблица users 1(5)

-- Задание №5.

DROP TABLE IF EXISTS `catalogs`;
CREATE TABLE `catalogs` (
	`id` SERIAL,
	`name` VARCHAR(255),
	UNIQUE `unique_name`(`name`(10))
);

INSERT INTO `catalogs` (`id`, `name`) VALUES
	(1, 'Процессоры'),
	(2, 'Материнские платы'),
	(3, 'Оперативная память'),
	(4, 'Блоки питания'),
	(5, 'Видеокарты');

SELECT * FROM `catalogs` WHERE `id` IN (5, 1, 2) ORDER BY FIELD(`id`, 5, 1, 2); -- Таблица catalogs 1(6)

-- Практическое задание теме «Агрегация данных».
-- Задание №1.

SELECT AVG(TIMESTAMPDIFF(YEAR, `birthday_at`, NOW())) AS `age` FROM `users`; -- Таблица Results 1(7)

-- Задание №2.

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(`birthday_at`), DAY(`birthday_at`))), '%W') AS `day`, COUNT(*) AS `total`
FROM `users`
GROUP BY `day`
ORDER BY `total` DESC; -- Таблица Results 1(8)

-- Задание №3.

SELECT ROUND(EXP(SUM(LN(`id`)))) AS `product of numbers` FROM `users`; -- Таблица Results 1(9)

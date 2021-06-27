USE `shop`;

-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT `id`, `name` FROM `users` WHERE `id` IN (SELECT `user_id` FROM `orders`);

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT 
	`products`.`name` AS `product`,
	`catalogs`.`name` AS `product catalog`
FROM `products`
JOIN `catalogs` ON `products`.`catalog_id` = `catalogs`.`id`;

/* 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, 
 * name). Поля from, to и label содержат английские названия городов, поле name — русское.
 * Выведите список рейсов flights с русскими названиями городов.
*/

DROP DATABASE IF EXISTS `task_7_db`;
CREATE DATABASE `task_7_db`;
USE `task_7_db`;

DROP TABLE IF EXISTS `flights`;
CREATE TABLE `flights` (
	`id` SERIAL PRIMARY KEY,
	`from` VARCHAR(255) NOT NULL,
	`to` VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
	`label` VARCHAR(255) NOT NULL,
	`name` VARCHAR(255) NOT NULL
);

INSERT INTO `flights` (`id`, `from`, `to`) VALUES
(NULL, 'moscow', 'omsk'),
(NULL, 'novgorod', 'kazan'),
(NULL, 'irkutsk', 'moscow'),
(NULL, 'omsk', 'irkutsk'),
(NULL, 'moscow', 'kazan');

INSERT INTO `cities` (`label`, `name`) VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

SELECT * FROM `flights`;
SELECT * FROM `cities`;

SELECT `id`, `c1`.`name` `from`, `c2`.`name` `to`
FROM `flights`
JOIN `cities` `c1` ON `flights`.`from` = `c1`.`label`
JOIN `cities` `c2` ON `flights`.`to` = `c2`.`label`
ORDER BY `id`;


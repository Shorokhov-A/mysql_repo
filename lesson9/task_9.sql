/*
 * Практическое задание по теме “Транзакции,
 * переменные, представления”.
*/

/*
 * 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте
 * транзакции.
*/

DROP DATABASE IF EXISTS `sample`;
CREATE DATABASE `sample`;
USE `sample`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(255),
	`birthday_at` DATE,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

START TRANSACTION;

SELECT @id := `id` FROM `shop`.`users` WHERE id = 1;
SELECT @name := `name` FROM `shop`.`users` WHERE id = 1;
SELECT @birthday_at := `birthday_at` FROM `shop`.`users` WHERE id = 1;
SELECT @created_at := `created_at` FROM `shop`.`users` WHERE id = 1;
SELECT @updated_at := `updated_at` FROM `shop`.`users` WHERE id = 1;

INSERT INTO `users` (`id`, `name`, `birthday_at`, `created_at`, `updated_at`) VALUES
(@id, @name, @birthday_at, @created_at, @updated_at);

DELETE FROM `shop`.`users` WHERE `id` = @id;

COMMIT;

SELECT * FROM `shop`.`users`;
SELECT * FROM `users`;

/*
 * 2. Создайте представление, которое выводит название name товарной позиции из таблицы
 * products и соответствующее название каталога name из таблицы catalogs.
*/

CREATE VIEW `prod_name` AS
SELECT 
	`products`.`name` AS `product`,
	`catalogs`.`name` AS `product catalog`
FROM `shop`.`products`
JOIN `shop`.`catalogs` ON `products`.`catalog_id` = `catalogs`.`id`;

SELECT * FROM `prod_name`;

/*
 * Практическое задание по теме “Хранимые процедуры и
 * функции, триггеры"
*/

/*
 * 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
 * текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
 * 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый
 * вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS TEXT NOT DETERMINISTIC READS SQL DATA
BEGIN
	DECLARE `time` TIME DEFAULT NOW();
	IF (6 <= TIME_FORMAT(`time`, '%H') AND TIME_FORMAT(`time`, '%H') < 12) THEN
		RETURN 'Доброе утро';
	ELSEIF (12 <= TIME_FORMAT(`time`, '%H') AND TIME_FORMAT(`time`, '%H') < 18) THEN
		RETURN 'Добрый день';
	ELSEIF (18 <= TIME_FORMAT(`time`, '%H') AND TIME_FORMAT(`time`, '%H') <= 23) THEN
		RETURN 'Добрый вечер';
	ELSE
		RETURN 'Доброй ночи';
	END IF;
END//

DELIMITER ;

SELECT hello();

/*
 * 2. В таблице products есть два текстовых поля: name с названием товара и description с его
 * описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
 * принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
 * того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
 * NULL-значение необходимо отменить операцию.
*/
USE `shop`;
DROP TRIGGER IF EXISTS products_check_on_insert;
DROP TRIGGER IF EXISTS products_check_on_update;

DELIMITER //

CREATE TRIGGER products_check_on_insert BEFORE INSERT ON `products`
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поля name и description не заполнены';
	END IF;
END//

CREATE TRIGGER products_check_on_update BEFORE UPDATE ON `products`
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Обновление данных прервано. Поля name и description не заполнены';
	END IF;
END//

DELIMITER ;

INSERT INTO `products` (`name`, `description`, `price`, `catalog_id`) VALUES
(NULL, NULL, 5000, 1);

UPDATE `products` SET `name` = NULL, `description` = NULL 
WHERE `id` = 1;


-- Практическое задание по теме “Оптимизация запросов”

/*
 * 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
 * catalogs и products в таблицу logs помещается время и дата создания записи, название
 * таблицы, идентификатор первичного ключа и содержимое поля name.
*/

USE `shop`;

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`table_title` VARCHAR(255) NOT NULL,
	`table_id` BIGINT UNSIGNED NOT NULL,
	`name` VARCHAR(255) NOT NULL
) ENGINE=Archive;

DROP PROCEDURE IF EXISTS write_log;

DELIMITER //
CREATE PROCEDURE write_log(IN table_id INT, table_title VARCHAR(255), name VARCHAR(255))
BEGIN
    INSERT INTO logs VALUES (NOW(), table_title, table_id, name);
END//

DROP TRIGGER IF EXISTS users_log//
CREATE TRIGGER users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
    CALL write_log(NEW.id, "users", NEW.name);
END//

DROP TRIGGER IF EXISTS catalogs_log//
CREATE TRIGGER catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
    CALL write_log(NEW.id, "catalogs", NEW.name);
END//

DROP TRIGGER IF EXISTS products_log//
CREATE TRIGGER products_log AFTER INSERT ON products
FOR EACH ROW
BEGIN
    CALL write_log(NEW.id, "products", NEW.name);
END//

DELIMITER ;

INSERT INTO users (name) VALUES ('Johny');
INSERT INTO catalogs (name) VALUES ('RAM');
INSERT INTO products (name) VALUES ('AData Premier [AD4U266638G19-S]');

SELECT * FROM logs;
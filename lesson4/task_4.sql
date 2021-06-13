USE `vk`;

-- Извлечем данные столбцов firstname, lastname, email из таблицы users (таблица users 1).

SELECT `firstname`, `lastname`, `email` FROM `users`;

-- Отобразим все содержимое таблицы users (таблица users 1(2)).

SELECT * FROM `users`;

/*
 * Проверим работу ключевого слова IGNORE.
 * Для этого попробуем добавить в таблицу users уже существующие данные.
 * Данные полей email, phone, id должны быть уникальными.
 * Без ключевого слова IGNORE работа скрипта в этом месте должна прерваться.
*/

INSERT IGNORE INTO `users` VALUES
('134', 'Alivia', 'Fadel', 'darion.stanton@example.com', '1f8af811a2bb87b1654b6fcee1770d9c35311d66', '6606260113');
SELECT * FROM `users` WHERE `email` = 'darion.stanton@example.com'; -- Работа скрипта не прервалась и запись не вставилась (таблица users 1(3)).

/*
 * Данные для таблицы users генерировались с id в интервале от 100 до 200.
 * Проверим, не появились ли новые ошибочные записи после работы с IGNORE.
 */

SELECT * FROM `users` WHERE `id` > 200; -- Никаких мусорных записей не появилось (таблица users 1(4)).

-- Добавим запись в таблицу users и удалим её.

INSERT INTO `users` VALUES
('210', 'Ivan', 'Petrov', 'petrovan@example.net', '589e4af889d2ac21398fbd45839adc9135bdf885', '55521665494');
SELECT * FROM `users` WHERE `id` = 210; -- Запись добавлена (таблица users 1(5)).
DELETE FROM `users` WHERE `id` = 210;
SELECT * FROM `users` WHERE `id` = 210; -- Запись удалена (таблица users 1(6)).

-- Поработаем с UPDATE.

INSERT INTO `users` VALUES
('210', 'Ivan', 'Petrov', 'petrovan@example.net', '589e4af889d2ac21398fbd45839adc9135bdf885', '55521665494');
UPDATE `users` SET `lastname` = 'PETROFF'
WHERE `lastname` = 'Petrov';
SELECT * FROM `users` WHERE `id` = 210; -- В запись с id 210 внесены изменения (таблица users 1(7)).

/*
 * Поработаем с оператором SELECT ... IMPORT.
 * Создадим таблицу email и заполним её адресами электронной почты из таблицы users.
*/

DROP TABLE IF EXISTS `email`;
CREATE TABLE `email` (
 	`id` SERIAL,
	`address` VARCHAR(120) UNIQUE
);

INSERT INTO
	`email` (`address`)
SELECT
	`email`
FROM 
	`users`;
SELECT * FROM `email`; -- Таблица email создана и заполнена данными (таблица users 1(8)).

-- Очистим таблицу email при помощи TRUNCATE.

TRUNCATE `email`;
SELECT * FROM `email`; -- Таблица email очищена (таблица users 1(9)).

-- Заметаем следы.

DROP TABLE IF EXISTS `email`;
DELETE FROM `users` WHERE `id` = 210;

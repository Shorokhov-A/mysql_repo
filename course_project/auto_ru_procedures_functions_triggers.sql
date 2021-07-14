USE `auto_ru`;

-- Напишем процедуру-счётчик количества объявлений по моделям транспортных средств.

DROP PROCEDURE IF EXISTS `ads_count_by_models`;
DELIMITER //

CREATE PROCEDURE `ads_count_by_models`()
BEGIN
	SELECT 
		CONCAT(`vb`.`brand`, ' ', `vm`.`model_name`) AS `vihicle_model`,
		COUNT(*) AS `ads_number`
	FROM `ads`
	LEFT JOIN `vehicle_brands` `vb` ON `ads`.`vehicle_brand_id` = `vb`.`id`
	LEFT JOIN `vehicle_models` `vm` ON `ads`.`vehicle_model_id` = `vm`.`id`
	GROUP BY `vihicle_model`
	ORDER BY `ads_number` DESC;
END//

DELIMITER ;

CALL `ads_count_by_models`();

-- Напишем процедуру, отображающую объявления в заданном интервале цен.

DROP PROCEDURE IF EXISTS `ads__by_price_range`;
DELIMITER //

CREATE PROCEDURE `ads__by_price_range` (IN `min_price` BIGINT, IN `max_price` BIGINT)
BEGIN
	SET @`min_price` = `min_price`;
	SET @`max_price` = `max_price`;
	SELECT * FROM `ads` WHERE `price` BETWEEN @`min_price` AND @`max_price`;
END//

DELIMITER ;

CALL `ads__by_price_range`(2000, 250000);

/*
 * Напишем функцию, которая принимает в качестве параметра id  пользователя, а в качестве результата выводит
 * приветствие пользователя.
 */

DROP FUNCTION IF EXISTS `users_greeting`;
DELIMITER //

CREATE FUNCTION `users_greeting` (`value` BIGINT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE `messages_count` BIGINT;
	DECLARE `user_name` VARCHAR(255);
	SET @`user_id` = `value`;
	SELECT
		COUNT(*) INTO `messages_count`
	FROM `messages`
	WHERE `to_user_id` = @`user_id` AND `status` = 'unread';
	SELECT
		`name` INTO `user_name`
	FROM `profiles`
	WHERE `user_id` = @`user_id`;
	RETURN CONCAT('Привет, ', `user_name`, '!', ' У Вас ', `messages_count`, ' непрочитанных сообщений.');
END//

DELIMITER ;

SELECT `users_greeting`(98);

/*
 * В таблице ads есть текстовые поля: mileage, содержащее значение пробега транспортного средства,
 * reg_number, содержащее государственный регистрационный номер транспортного средства, region_code -
 * код региона, VIN - VIN-номер транспортного средства и price - цена. Каждое из этих полей должно быть
 * заполнено. Используя триггеры, сделаем так, чтобы каждое из этих полей было заполнено. При попытке
 * присвоить этим полям NULL-значение необходимо отменить операцию.
 */

DROP TRIGGER IF EXISTS `ads_check_on_insert`;
DROP TRIGGER IF EXISTS `ads_check_on_update`;

DELIMITER //

CREATE TRIGGER `ads_check_on_insert` BEFORE INSERT ON `ads`
FOR EACH ROW
BEGIN
	IF NEW.`mileage` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле mileage не заполнено.';
	ELSEIF NEW.`reg_number` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле reg_number не заполнено.';
	ELSEIF NEW.`region_code` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле region_code не заполнено.';
	ELSEIF NEW.`VIN` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле VIN не заполнено.';
	ELSEIF NEW.`price` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле price не заполнено.';
	END IF;
END//

CREATE TRIGGER `ads_check_on_update` BEFORE UPDATE ON `ads`
FOR EACH ROW
BEGIN
	IF NEW.`mileage` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле mileage не заполнено.';
	ELSEIF NEW.`reg_number` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле reg_number не заполнено.';
	ELSEIF NEW.`region_code` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле region_code не заполнено.';
	ELSEIF NEW.`VIN` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле VIN не заполнено.';
	ELSEIF NEW.`price` IS NULL
	THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Ошибка ввода данных. Поле price не заполнено.';
	END IF;
END//

DELIMITER ;

INSERT INTO `ads` VALUES (NULL, '103', NULL, '72078054', '312', '41315460', '3503235', 'Sed doloremque error accusamus omnis officia dolor maxime. Aut nulla aut sed consequatur et dolore officiis. Voluptatem laborum sit saepe. Error est est maxime vero qui sint cum.', '1979-01-17 04:28:26', '1986-05-29 07:45:57', 'Sylvesterville', '0', '4626057', '2', '4', '18', '68', '172');
INSERT INTO `ads` VALUES (NULL, '103', '19959421', NULL, '312', '41315460', '3503235', 'Sed doloremque error accusamus omnis officia dolor maxime. Aut nulla aut sed consequatur et dolore officiis. Voluptatem laborum sit saepe. Error est est maxime vero qui sint cum.', '1979-01-17 04:28:26', '1986-05-29 07:45:57', 'Sylvesterville', '0', '4626057', '2', '4', '18', '68', '172');
INSERT INTO `ads` VALUES (NULL, '103', '19959421', '72078054', NULL, '41315460', '3503235', 'Sed doloremque error accusamus omnis officia dolor maxime. Aut nulla aut sed consequatur et dolore officiis. Voluptatem laborum sit saepe. Error est est maxime vero qui sint cum.', '1979-01-17 04:28:26', '1986-05-29 07:45:57', 'Sylvesterville', '0', '4626057', '2', '4', '18', '68', '172');
INSERT INTO `ads` VALUES (NULL, '103', '19959421', '72078054', '312', NULL, '3503235', 'Sed doloremque error accusamus omnis officia dolor maxime. Aut nulla aut sed consequatur et dolore officiis. Voluptatem laborum sit saepe. Error est est maxime vero qui sint cum.', '1979-01-17 04:28:26', '1986-05-29 07:45:57', 'Sylvesterville', '0', '4626057', '2', '4', '18', '68', '172');
INSERT INTO `ads` VALUES (NULL, '103', '19959421', '72078054', '312', '41315460', '3503235', 'Sed doloremque error accusamus omnis officia dolor maxime. Aut nulla aut sed consequatur et dolore officiis. Voluptatem laborum sit saepe. Error est est maxime vero qui sint cum.', '1979-01-17 04:28:26', '1986-05-29 07:45:57', 'Sylvesterville', '0', NULL, '2', '4', '18', '68', '172');

UPDATE `ads` SET `mileage` = NULL WHERE `id` = 68;
UPDATE `ads` SET `reg_number` = NULL WHERE `id` = 68;
UPDATE `ads` SET `region_code` = NULL WHERE `id` = 68;
UPDATE `ads` SET `VIN` = NULL WHERE `id` = 68;
UPDATE `ads` SET `price` = NULL WHERE `id` = 68;

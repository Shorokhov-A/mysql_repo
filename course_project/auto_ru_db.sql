DROP DATABASE IF EXISTS `auto_ru`;
CREATE DATABASE `auto_ru`;
USE `auto_ru`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL PRIMARY KEY,
	`email` VARCHAR(120) UNIQUE,
	`password_hash` VARCHAR(100),
	`phone` BIGINT UNSIGNED UNIQUE
) COMMENT='Пользователи';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	`user_id` BIGINT UNSIGNED NOT NULL UNIQUE,
	`photo_id` BIGINT UNSIGNED DEFAULT NULL,
	`nickname` VARCHAR(50) NOT NULL COMMENT 'Ник на сайте',
	`name` VARCHAR(255) NOT NULL COMMENT 'Настоящее имя пользователя',
	`birthday` DATE,
	`created_at` DATETIME DEFAULT NOW(),
	`updated_at` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	`hometown` VARCHAR(100) DEFAULT NULL,
	`driving_since` DATE DEFAULT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CHECK(`birthday` < `driving_since`)
) COMMENT='Информация о пользователе';

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
	`id` SERIAL,
  	`from_user_id` BIGINT UNSIGNED NOT NULL,
  	`to_user_id` BIGINT UNSIGNED NOT NULL,
  	`body` TEXT NOT NULL,
  	`created_at` DATETIME DEFAULT NOW(),
  	`status` ENUM('read', 'unread') DEFAULT NULL,
	FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
	FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`),
	CHECK(`from_user_id` <> `to_user_id`)
) COMMENT='Сообщения';

DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` SERIAL PRIMARY KEY,
  `vehicle_type` VARCHAR(255) NOT NULL UNIQUE
) COMMENT='Каталог транспортных средств';

DROP TABLE IF EXISTS `vehicles_category`;
CREATE TABLE `vehicles_category` (
  `id` SERIAL PRIMARY KEY,
  `category_name` VARCHAR(255) NOT NULL UNIQUE,
  `vehicle_type_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicles` (`id`)
) COMMENT='Категории транспортных средств';

DROP TABLE IF EXISTS `vehicle_brands`;
CREATE TABLE `vehicle_brands` (
  `id` SERIAL PRIMARY KEY,
  `brand` VARCHAR(255) NOT NULL,
  `vehicle_type_id` BIGINT UNSIGNED NOT NULL,
  `vehicles_category_id` BIGINT UNSIGNED DEFAULT NULL,
  FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicles` (`id`),
  FOREIGN KEY (`vehicles_category_id`) REFERENCES `vehicles_category` (`id`)
) COMMENT='Марки автомобилей';

DROP TABLE IF EXISTS `vehicle_models`;
CREATE TABLE `vehicle_models` (
  `id` SERIAL PRIMARY KEY,
  `model_name` VARCHAR(255) NOT NULL UNIQUE,
  `vehicle_brand_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_brand_id`) REFERENCES `vehicle_brands` (`id`)
) COMMENT='Модели автомобилей';

DROP TABLE IF EXISTS `vehicle_generations`;
CREATE TABLE `vehicle_generations` (
  `id` SERIAL PRIMARY KEY,
  `generation_code` VARCHAR(255) NOT NULL UNIQUE,
  `year_since` YEAR NOT NULL,
  `year_to` YEAR DEFAULT NULL,
  `vehicle_model_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_model_id`) REFERENCES `vehicle_models` (`id`)
) COMMENT='Поколения моделей';

DROP TABLE IF EXISTS `vehicle_series`;
CREATE TABLE `vehicle_series` (
  `id` SERIAL PRIMARY KEY,
  `series` VARCHAR(255) NOT NULL UNIQUE,
  `vehicle_generation_id` BIGINT UNSIGNED NOT NULL,
  `vehicle_model_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_generation_id`) REFERENCES `vehicle_generations` (`id`),
  FOREIGN KEY (`vehicle_model_id`) REFERENCES `vehicle_models` (`id`)
) COMMENT='Cерии автомобилей';

DROP TABLE IF EXISTS `vehicle_modifications`;
CREATE TABLE `vehicle_modifications` (
  `id` SERIAL PRIMARY KEY,
  `modification` VARCHAR(255) NOT NULL UNIQUE,
  `vehicle_series_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_series_id`) REFERENCES `vehicle_series` (`id`)
) COMMENT='Модификации автомобилей';

DROP TABLE IF EXISTS `vehicle_equipments`;
CREATE TABLE `vehicle_equipments` (
  `id` SERIAL PRIMARY KEY,
  `equipment` VARCHAR(255) NOT NULL UNIQUE,
  `price_min` BIGINT DEFAULT NULL COMMENT 'Цена от',
  `year` YEAR DEFAULT NULL,
  `vehicle_modification_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_modification_id`) REFERENCES `vehicle_modifications` (`id`)
) COMMENT='Комплектации';

DROP TABLE IF EXISTS `vehicle_characteristics`;
CREATE TABLE `vehicle_characteristics` (
  `id` SERIAL PRIMARY KEY,
  `characteristic` VARCHAR(255) NOT NULL UNIQUE,
  `vehicle_modification_id` BIGINT UNSIGNED DEFAULT NULL,
  `vehicle_model_id` BIGINT UNSIGNED DEFAULT NULL,
  FOREIGN KEY (`vehicle_modification_id`) REFERENCES `vehicle_modifications` (`id`),
  FOREIGN KEY (`vehicle_model_id`) REFERENCES `vehicle_models` (`id`)
) COMMENT='Характеристики автомобилей';

DROP TABLE IF EXISTS `vehicle_characteristic_values`;
CREATE TABLE `vehicle_characteristic_values` (
  `value` VARCHAR(255) NOT NULL,
  `unit` VARCHAR(255) NOT NULL COMMENT 'Еденица измерения',
  `vehicle_characteristic_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_characteristic_id`) REFERENCES `vehicle_characteristics` (`id`)
) COMMENT='Значения характеристик автомобиля';

DROP TABLE IF EXISTS `vehicle_options`;
CREATE TABLE `vehicle_options` (
  `id` SERIAL PRIMARY KEY,
  `option` VARCHAR(255) NOT NULL UNIQUE,
  `vehicle_equipment_id` BIGINT UNSIGNED DEFAULT NULL,
  `vehicle_model_id` BIGINT UNSIGNED DEFAULT NULL,
  FOREIGN KEY (`vehicle_equipment_id`) REFERENCES `vehicle_equipments` (`id`),
  FOREIGN KEY (`vehicle_model_id`) REFERENCES `vehicle_models` (`id`)
) COMMENT='Опции';

DROP TABLE IF EXISTS `vehicle_option_values`;
CREATE TABLE `vehicle_option_values` (
  `is_base` TINYINT(1) NOT NULL DEFAULT '1',
  `vehicle_option_id` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`vehicle_option_id`) REFERENCES `vehicle_options` (`id`)
) COMMENT='Значения опций';

DROP TABLE IF EXISTS `ads`;
CREATE TABLE `ads` (
	`id` SERIAL PRIMARY KEY,
	`user_id` BIGINT UNSIGNED NOT NULL,
	`mileage` BIGINT UNSIGNED DEFAULT NULL,
	`reg_number` VARCHAR(10) DEFAULT NULL,
	`region_code` VARCHAR(10) DEFAULT NULL,
	`VIN` VARCHAR(20) DEFAULT NULL,
	`reg_certificate` VARCHAR(10) DEFAULT NULL,
	`body` TEXT DEFAULT NULL,
	`created_at` DATETIME DEFAULT NOW(),
  	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  	`locality` VARCHAR(100) DEFAULT NULL,
  	`phone` BIGINT UNSIGNED DEFAULT NULL,
  	`price` BIGINT DEFAULT NULL,
  	`vehicle_type_id` BIGINT UNSIGNED NOT NULL,
	`vehicles_category_id` BIGINT UNSIGNED DEFAULT NULL,
	`vehicle_brand_id` BIGINT UNSIGNED NOT NULL,
	`vehicle_model_id` BIGINT UNSIGNED NOT NULL,
  	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  	FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicles` (`id`),
	FOREIGN KEY (`vehicles_category_id`) REFERENCES `vehicles_category` (`id`),
	FOREIGN KEY (`vehicle_brand_id`) REFERENCES `vehicle_brands` (`id`),
	FOREIGN KEY (`vehicle_model_id`) REFERENCES `vehicle_models` (`id`)
) COMMENT='Объявления';

DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
	`id` SERIAL PRIMARY KEY,
	`user_id` BIGINT UNSIGNED NOT NULL,
	`filename` VARCHAR(255) NOT NULL,
	`size` INT DEFAULT NULL,
	`metadata` JSON,
	`created_at` DATETIME DEFAULT NOW(),
  	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) COMMENT='Фотографии';

ALTER TABLE `profiles`
ADD CONSTRAINT FOREIGN KEY (`photo_id`) REFERENCES `media` (`id`);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) COMMENT='Фотоальбомы объявлений';

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	`id` SERIAL PRIMARY KEY,
	`album_id` BIGINT UNSIGNED NOT NULL,
	`media_id` BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`),
	FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) COMMENT='Фотоальбомы объявлений';

ALTER TABLE `ads`
ADD `album_id` BIGINT UNSIGNED DEFAULT NULL,
ADD CONSTRAINT FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`);

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
	`id` SERIAL PRIMARY KEY,
	`user_id` BIGINT UNSIGNED NOT NULL,
	`title` VARCHAR(100) NOT NULL,
	`body` TEXT DEFAULT NULL,
	`album_id` BIGINT UNSIGNED DEFAULT NULL,
	`created_at` DATETIME DEFAULT NOW(),
  	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  	`vehicle_type_id` BIGINT UNSIGNED NOT NULL,
	`vehicles_category_id` BIGINT UNSIGNED DEFAULT NULL,
	`vehicle_brand_id` BIGINT UNSIGNED NOT NULL,
	`vehicle_model_id` BIGINT UNSIGNED NOT NULL,
	`vehicle_generation_id` BIGINT UNSIGNED NOT NULL,
	`vehicle_series_id` BIGINT UNSIGNED NOT NULL,
	`vehicle_modification_id` BIGINT UNSIGNED NOT NULL,
  	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  	FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`),
  	FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicles` (`id`),
	FOREIGN KEY (`vehicles_category_id`) REFERENCES `vehicles_category` (`id`),
	FOREIGN KEY (`vehicle_brand_id`) REFERENCES `vehicle_brands` (`id`),
	FOREIGN KEY (`vehicle_model_id`) REFERENCES `vehicle_models` (`id`),
	FOREIGN KEY (`vehicle_generation_id`) REFERENCES `vehicle_generations` (`id`),
	FOREIGN KEY (`vehicle_series_id`) REFERENCES `vehicle_series` (`id`),
 	FOREIGN KEY (`vehicle_modification_id`) REFERENCES `vehicle_modifications` (`id`)
) COMMENT='Отзывы';

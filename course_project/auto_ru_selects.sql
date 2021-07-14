USE `auto_ru`;

-- Найдем 5 самых активных продавцов, разместивших наибольшее количество объявлений.

SELECT
	`user_id`,
	COUNT(*) AS `number of ads`
FROM `ads`
GROUP BY `user_id`
ORDER BY `number of ads` DESC
LIMIT 5;

-- Найдем все объявления, размещенные этими продавцами.

SELECT `user_id`, `id` AS `ad_id` FROM `ads` WHERE `user_id` IN (
	SELECT
		`user_id`
	FROM (
		SELECT
			`user_id`,
			COUNT(*) AS `number of ads`
		FROM `ads`
		GROUP BY `user_id`
		ORDER BY `number of ads` DESC
		LIMIT 5
		) AS `top_sellers`
);

-- Среди объявлений о продаже найдем самый дешевый автомобиль.

SELECT
	CONCAT(`vb`.`brand`, ' ', `vm`.`model_name`) AS `vihicle_model`,
	`ads`.`price`
FROM `ads`
JOIN `vehicle_brands` `vb` ON `ads`.`vehicle_brand_id` = `vb`.`id`
JOIN `vehicle_models` `vm` ON `ads`.`vehicle_model_id` = `vm`.`id`
WHERE `ads`.`price` = (SELECT MIN(`price`) FROM `ads`);

-- Среди объявлений о продаже найдем самый дорогой автомобиль.

SELECT
	CONCAT(`vb`.`brand`, ' ', `vm`.`model_name`) AS `vihicle_model`,
	`ads`.`price`
FROM `ads`
JOIN `vehicle_brands` `vb` ON `ads`.`vehicle_brand_id` = `vb`.`id`
JOIN `vehicle_models` `vm` ON `ads`.`vehicle_model_id` = `vm`.`id`
WHERE `ads`.`price` = (SELECT MAX(`price`) FROM `ads`);

-- Поищем отзывы о моделях автомобилей, продаваемых самым активным продавцом.

SELECT
	CONCAT(`vb`.`brand`, ' ', `vm`.`model_name`) AS `vihicle_model`,
	`r`.`id` AS `review_id`
FROM `ads` 
JOIN `vehicle_brands` `vb` ON `ads`.`vehicle_brand_id` = `vb`.`id`
JOIN `vehicle_models` `vm` ON `ads`.`vehicle_model_id` = `vm`.`id`
JOIN `reviews` `r` ON `ads`.`vehicle_model_id` = `r`.`vehicle_model_id`
WHERE `ads`.`user_id` IN (
	SELECT
		`user_id`
	FROM (
		SELECT
			`user_id`,
			COUNT(*) AS `number of ads`
		FROM `ads`
		GROUP BY `user_id`
		ORDER BY `number of ads` DESC
		LIMIT 1
		) AS `top_seller`
);

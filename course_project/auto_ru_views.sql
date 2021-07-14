USE `auto_ru`;

/*
 * Представление, отображающее количество обзоров, написанных конкретным пользователем.
 */

CREATE OR REPLACE VIEW `reviews_count`
AS SELECT
	`reviews`.`user_id`,
	`p`.`name` AS `user_name`, 
	COUNT(*) AS `reviews_number`
FROM `reviews`
LEFT JOIN `profiles` `p` ON `reviews`.`user_id` = `p`.`user_id`
GROUP BY `reviews`.`user_id`;

SELECT * FROM `reviews_count`;

/* Представление, содержащее идентификатор объявления, название модели транспортного средства из этого объявления,
 * а также список идентификаторов обзоров, соответствующих этой модели транспортного средства, отсортированное по
 * дате создания объявления от новых к старым.
*/

CREATE OR REPLACE VIEW `sorted_ads`
AS SELECT
	`ads`.`id` AS `ad_id`,
	CONCAT(`vb`.`brand`, ' ', `vm`.`model_name`) AS `vihicle_model`,
	`ads`.`created_at`,
	GROUP_CONCAT(DISTINCT `rv`.`id` SEPARATOR ', ') AS `review_IDs`
FROM `ads`
JOIN `vehicle_brands` `vb` ON `ads`.`vehicle_brand_id` = `vb`.`id`
JOIN `vehicle_models` `vm` ON `ads`.`vehicle_model_id` = `vm`.`id`
LEFT JOIN `reviews` `rv` ON `ads`.`vehicle_model_id` = `rv`.`vehicle_model_id`
GROUP BY `ads`.`id`
ORDER BY `ads`.`created_at` DESC;

SELECT * FROM `sorted_ads`;

USE `vk`;

/*
 * 1. Пусть задан некоторый пользователь.
 * Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/

SELECT 
	`from_user_id` AS `user_id`, 
	CONCAT(`firstname`, ' ', `lastname`) AS `name`, 
	COUNT(*) `messages count` 
FROM (
	SELECT `from_user_id`, `to_user_id`, `firstname`, `lastname`
	FROM `users`, `messages` 
	WHERE `messages`.`from_user_id` = `users`.`id`) AS `data`
WHERE `to_user_id` = 191
GROUP BY `from_user_id`
ORDER BY `messages count` DESC
LIMIT 1;

/*
 * 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
 */

SELECT SUM(`likes`) AS `likes count`
FROM (SELECT COUNT(*) AS `likes`
	  FROM `likes`, `profiles`
	  WHERE `likes`.`to_user_id` = `profiles`.`user_id`
	  GROUP BY `likes`.`to_user_id`
	  ORDER BY `profiles`.`birthday` DESC
	  LIMIT 10) AS `count`;

/*
 * 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
 */

SELECT COUNT(*) AS `likes`, `gender` FROM `likes`, `profiles`
WHERE `likes`.`from_user_id` = `profiles`.`user_id`
GROUP BY `gender`
ORDER BY `likes` DESC LIMIT 1;

/*
 * 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании
 * социальной сети.
 */

SELECT `id`, SUM(`acts`) AS `acts` FROM 
	(SELECT `id`, 0 AS `acts` FROM `users`
	UNION
	SELECT `user_id` AS `id`, COUNT(*) AS `acts` FROM `media`
	GROUP BY `user_id`
	UNION
	SELECT `from_user_id` AS `id`, COUNT(*) AS `acts` FROM `likes`
	GROUP BY `from_user_id`
	UNION
	SELECT `from_user_id` AS `id`, COUNT(*) AS `acts` FROM `messages`
	GROUP BY `from_user_id`
	UNION
	SELECT `author_id` AS `id`, COUNT(*) AS `acts` FROM `posts`
	GROUP BY `author_id`) AS `activities`
GROUP BY `id`
ORDER BY `acts`
LIMIT 10;

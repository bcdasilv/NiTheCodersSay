CREATE TABLE IF NOT EXISTS `soundcloud_keys`(
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `spotify_keys`(
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `profiles`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `about_me` VARCHAR(140),
  `bio` VARCHAR(1000),
  `pic_path` VARCHAR(1000) CHARACTER SET utf8,
  `spotify_key` INT,
  `soundcloud_key` INT,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`spotify_key`) REFERENCES spotify_keys(`id`),
  FOREIGN KEY (`soundcloud_key`) REFERENCES soundcloud_keys(`id`));

CREATE TABLE IF NOT EXISTS `users`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(30) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `password` VARCHAR(128) NOT NULL,
  `zipcode` CHAR(5) NOT NULL,
  `dob` DATE NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id`) REFERENCES profiles(`id`));

CREATE TABLE IF NOT EXISTS `matchings`(
  `user_1` INT NOT NULL,
  `user_2` INT NOT NULL,
  PRIMARY KEY (`user_1`, `user_2`),
  FOREIGN KEY (`user_1`) REFERENCES profiles(`id`),
  FOREIGN KEY (`user_2`) REFERENCES profiles(`id`));


DELIMITER $$

CREATE TRIGGER matchings_sorted_ids_check 
BEFORE INSERT ON matchings 
FOR EACH ROW 
	BEGIN   
		IF (NEW.user_1 > NEW.user_2) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'New user_1 id is greater then user_2 id. Please sort the ids before inserting.';	
		END IF; 
	END$$

DELIMITER ;

CREATE DATABASE IF NOT EXISTS `world_happiness`;
USE `world_happiness`;

-- -----------------------------------------------------
-- Table `world_happiness`.`countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `countries` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table `world_happiness`.`happiness_indicators`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `happiness_indicators` (
  `country_id` INT NOT NULL,
  `logged_gdp_per_capita` DECIMAL(10, 3) NOT NULL,
  `social_support` DECIMAL(10, 3) NOT NULL,
  `freedom_to_choose` DECIMAL(10, 3) NOT NULL,
  `ladder_score` DECIMAL(10, 3) NOT NULL,
  `year` INT NOT NULL, 
  PRIMARY KEY (`country_id`, `year`),
  FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
);



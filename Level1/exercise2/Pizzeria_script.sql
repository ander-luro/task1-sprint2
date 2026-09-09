-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`clients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `postal_code` VARCHAR(10) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `region` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`shops`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`shops` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45) NOT NULL,
  `postal_code` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `region` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`jobs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`jobs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `job_position` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `jobs_job_position_unique` (`job_position` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `NIF` CHAR(9) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `job_id` INT NOT NULL,
  `shop_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `employees_nif_unique` (`NIF` ASC) VISIBLE,
  INDEX `employees_job_id_foreign_idx` (`job_id` ASC) VISIBLE,
  INDEX `employees_shop_id_foreign_idx` (`shop_id` ASC) VISIBLE,
  CONSTRAINT `employees_job_id_foreign`
    FOREIGN KEY (`job_id`)
    REFERENCES `pizzeria`.`jobs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `employees_shop_id_foreign`
    FOREIGN KEY (`shop_id`)
    REFERENCES `pizzeria`.`shops` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `types_type_name_unique` (`type_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `categories_category_name_unique` (`category_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `image` VARCHAR(100) NOT NULL,
  `price` DECIMAL(4,2) UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `type_id` INT NOT NULL,
  `category_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `products_type_id_foreign_idx` (`type_id` ASC) VISIBLE,
  INDEX `products_category_id_foreign_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `products_type_id_foreign`
    FOREIGN KEY (`type_id`)
    REFERENCES `pizzeria`.`types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `products_category_id_foreign`
    FOREIGN KEY (`category_id`)
    REFERENCES `pizzeria`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ordered_at` DATETIME NOT NULL,
  `is_deliver` TINYINT(1) NOT NULL,
  `total_price` DECIMAL(5,2) UNSIGNED NOT NULL,
  `client_id` INT NOT NULL,
  `shop_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `orders_client_id_foreign_idx` (`client_id` ASC) VISIBLE,
  INDEX `orders_shop_id_foreign_idx` (`shop_id` ASC) VISIBLE,
  CONSTRAINT `orders_client_id_foreign`
    FOREIGN KEY (`client_id`)
    REFERENCES `pizzeria`.`clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `orders_shop_id_foreign`
    FOREIGN KEY (`shop_id`)
    REFERENCES `pizzeria`.`shops` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`delivers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`delivers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `delivered_at` DATETIME NOT NULL,
  `employee_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `delivers_employee_id_foreign_idx` (`employee_id` ASC) VISIBLE,
  UNIQUE INDEX `delivers_order_id_unique` (`order_id` ASC) VISIBLE,
  CONSTRAINT `delivers_employee_id_foreign`
    FOREIGN KEY (`employee_id`)
    REFERENCES `pizzeria`.`employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `delivers_order_id_foreign`
    FOREIGN KEY (`order_id`)
    REFERENCES `pizzeria`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`order_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order_product` (
  `product_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `quantity` TINYINT NOT NULL,
  PRIMARY KEY (`product_id`, `order_id`),
  INDEX `order_product_order_id_foreign_idx` (`order_id` ASC) VISIBLE,
  INDEX `order_product_product_id_foreign_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `order_product_product_id_foreign`
    FOREIGN KEY (`product_id`)
    REFERENCES `pizzeria`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_product_order_id_foreign`
    FOREIGN KEY (`order_id`)
    REFERENCES `pizzeria`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Data for table `pizzeria`.`jobs`
-- -----------------------------------------------------
START TRANSACTION;
USE `pizzeria`;
INSERT INTO `pizzeria`.`jobs` (`id`, `job_position`) VALUES (1, 'driver');
INSERT INTO `pizzeria`.`jobs` (`id`, `job_position`) VALUES (2, 'cook');

COMMIT;


-- -----------------------------------------------------
-- Data for table `pizzeria`.`types`
-- -----------------------------------------------------
START TRANSACTION;
USE `pizzeria`;
INSERT INTO `pizzeria`.`types` (`id`, `type_name`) VALUES (1, 'pizza');
INSERT INTO `pizzeria`.`types` (`id`, `type_name`) VALUES (2, 'hamburguer');
INSERT INTO `pizzeria`.`types` (`id`, `type_name`) VALUES (3, 'drinks');

COMMIT;

-- -----------------------------------------------------
-- DATA LOADING (INSERTS)
-- -----------------------------------------------------


INSERT INTO `pizzeria`.`clients` (`id`, `first_name`, `last_name`, `address`, `postal_code`, `city`, `region`, `phone`) VALUES
(1, 'Laura', 'Gómez', 'Carrer de Mallorca 123', '08036', 'Barcelona', 'Catalunya', '600111222'),
(2, 'Marc', 'Vila', 'Avinguda Diagonal 456', '08006', 'Barcelona', 'Catalunya', '600333444'),
(3, 'Jordi', 'Mas', 'Carrer Major 12', '17001', 'Girona', 'Catalunya', '600555666');

INSERT INTO `pizzeria`.`shops` (`id`, `address`, `postal_code`, `city`, `region`) VALUES
(1, 'Carrer Aragó 200', '08011', 'Barcelona', 'Catalunya'),
(2, 'Carrer de Santa Clara 5', '17001', 'Girona', 'Catalunya');

INSERT INTO `pizzeria`.`employees` (`id`, `first_name`, `last_name`, `NIF`, `phone`, `job_id`, `shop_id`) VALUES
(1, 'Carlos', 'Ruiz', '12345678A', '611222333', 1, 1),
(2, 'Anna', 'Soler', '23456789B', '622333444', 2, 1),
(3, 'Pau', 'Roca', '34567890C', '633444555', 1, 2);

INSERT INTO `pizzeria`.`categories` (`id`, `category_name`) VALUES
(1, 'Clàssiques'),
(2, 'Especials');

INSERT INTO `pizzeria`.`products` (`id`, `name`, `image`, `price`, `description`, `type_id`, `category_id`) VALUES
(1, 'Pizza Margherita', 'margherita.jpg', 9.50, 'Tomàquet, mozzarella i alfàbrega', 1, 1),
(2, 'Pizza 4 Formatges', '4formatges.jpg', 12.00, 'Mozzarella, gorgonzola, parmesà i gouda', 1, 2),
(3, 'Hamburguesa Completa', 'burger.jpg', 8.50, 'Carn de vedella, formatge, enciam i tomàquet', 2, NULL),
(4, 'Coca-Cola 33cl', 'cocacola.jpg', 2.50, 'Llauna de Coca-Cola freda', 3, NULL),
(5, 'Aigua Mineral 50cl', 'aigua.jpg', 1.80, 'Aigua de font natural', 3, NULL);

INSERT INTO `pizzeria`.`orders` (`id`, `ordered_at`, `is_deliver`, `total_price`, `client_id`, `shop_id`) VALUES
(1, '2026-09-01 20:15:00', 1, 16.30, 1, 1),
(2, '2026-09-02 21:00:00', 1, 15.30, 2, 1),
(3, '2026-09-03 13:30:00', 0, 8.50, 3, 2);

INSERT INTO `pizzeria`.`delivers` (`id`, `delivered_at`, `employee_id`, `order_id`) VALUES
(1, '2026-09-01 20:45:00', 1, 1),
(2, '2026-09-02 21:30:00', 1, 2);

INSERT INTO `pizzeria`.`order_product` (`product_id`, `order_id`, `quantity`) VALUES
(1, 1, 1),
(4, 1, 2),
(5, 1, 1),
(3, 2, 1),
(4, 2, 2),
(5, 2, 1),
(3, 3, 1);


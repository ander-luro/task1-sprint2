-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema optics
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema optics
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optics` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `optics` ;

-- -----------------------------------------------------
-- Table `optics`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`suppliers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `fax` VARCHAR(45) NOT NULL,
  `nif` CHAR(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `suppliers_nif_unique` (`nif` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optics`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`clients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(80) NOT NULL,
  `registration_date` DATE NOT NULL,
  `referred_by` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `clients_email_unique` (`email` ASC) VISIBLE,
  INDEX `clients_referred_by_foreign_idx` (`referred_by` ASC) VISIBLE,
  CONSTRAINT `clients_referred_by_foreign`
    FOREIGN KEY (`referred_by`)
    REFERENCES `optics`.`clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optics`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`addresses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(80) NOT NULL,
  `street_number` VARCHAR(10) NOT NULL,
  `floor` VARCHAR(10) NULL,
  `door` VARCHAR(10) NULL,
  `city` VARCHAR(80) NOT NULL,
  `postal_code` VARCHAR(10) NOT NULL,
  `country` VARCHAR(80) NOT NULL,
  `client_id` INT NULL,
  `supplier_id` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `addresses_client_id_unique` (`client_id` ASC) VISIBLE,
  INDEX `addresses_supplier_id_foreign_idx` (`supplier_id` ASC) VISIBLE,
  CONSTRAINT `addresses_client_id_foreign`
    FOREIGN KEY (`client_id`)
    REFERENCES `optics`.`clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `addresses_supplier_id_foreign`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `optics`.`suppliers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optics`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optics`.`brands`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`brands` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `supplier_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `brand_name_unique` (`name` ASC) VISIBLE,
  INDEX `brands_supplier_id_foreign_idx` (`supplier_id` ASC) VISIBLE,
  CONSTRAINT `brands_supplier_id_foreign`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `optics`.`suppliers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optics`.`glasses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`glasses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `left_prescription` DECIMAL(4,2) NOT NULL,
  `right_prescription` DECIMAL(4,2) NOT NULL,
  `frame_type` ENUM('floating', 'plastic', 'metal') NOT NULL,
  `price` DECIMAL(6,2) NOT NULL,
  `left_glass_color` VARCHAR(45) NOT NULL,
  `right_glass_color` VARCHAR(45) NOT NULL,
  `frame_color` VARCHAR(45) NOT NULL,
  `brand_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `glasses_brand_id_foreign_idx` (`brand_id` ASC) VISIBLE,
  CONSTRAINT `glasses_brand_id_foreign`
    FOREIGN KEY (`brand_id`)
    REFERENCES `optics`.`brands` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optics`.`sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optics`.`sales` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_sale` DATETIME NOT NULL,
  `employee_id` INT NOT NULL,
  `glass_id` INT NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `sales_employee_id_foreign_idx` (`employee_id` ASC) VISIBLE,
  UNIQUE INDEX `glass_id_unique` (`glass_id` ASC) VISIBLE,
  INDEX `sales_client_id_foreign_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `sales_employee_id_foreign`
    FOREIGN KEY (`employee_id`)
    REFERENCES `optics`.`employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sales_glass_id_foreign`
    FOREIGN KEY (`glass_id`)
    REFERENCES `optics`.`glasses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sales_client_id_foreign`
    FOREIGN KEY (`client_id`)
    REFERENCES `optics`.`clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- DATA LOADING (INSERTS)
-- -----------------------------------------------------

INSERT INTO `optics`.`suppliers` (`id`, `name`, `phone`, `fax`, `nif`) VALUES
(1, 'Lenses & Frames Co.', '931112233', '931112234', 'B12345678'),
(2, 'OptiVision Suppliers', '912223344', '912223345', 'B87654321'),
(3, 'Luxottica Supply', '933334455', '933334456', 'B99887766');

INSERT INTO `optics`.`clients` (`id`, `name`, `phone`, `email`, `registration_date`, `referred_by`) VALUES
(1, 'Marta Prat', '600111222', 'marta@email.com', '2025-01-10', NULL),
(2, 'Joan Soler', '600222333', 'joan@email.com', '2025-05-15', 1),
(3, 'Elena Font', '600333444', 'elena@email.com', '2026-02-20', 1);

INSERT INTO `optics`.`addresses` (`id`, `street`, `street_number`, `floor`, `door`, `city`, `postal_code`, `country`, `client_id`, `supplier_id`) VALUES
(1, 'Carrer Gran de Gràcia', '15', '2', '1', 'Barcelona', '08012', 'Espanya', 1, NULL),
(2, 'Rambla Catalunya', '88', '1', '2', 'Barcelona', '08008', 'Espanya', 2, NULL),
(3, 'Carrer de Sants', '200', '4', 'B', 'Barcelona', '08028', 'Espanya', 3, NULL),
(4, 'Polígon Industrial Nord', '45', NULL, NULL, 'Badalona', '08911', 'Espanya', NULL, 1),
(5, 'Avenida de la Industria', '12', NULL, NULL, 'Madrid', '28001', 'Espanya', NULL, 2),
(6, 'Passeig de Gràcia', '50', NULL, NULL, 'Barcelona', '08007', 'Espanya', NULL, 3);

INSERT INTO `optics`.`employees` (`id`, `name`) VALUES
(1, 'Albert Garcia'),
(2, 'Núria Ferrer');

INSERT INTO `optics`.`brands` (`id`, `name`, `supplier_id`) VALUES
(1, 'Ray-Ban', 1),
(2, 'Oakley', 1),
(3, 'Persol', 2),
(4, 'Gucci', 3);

INSERT INTO `optics`.`glasses` (`id`, `left_prescription`, `right_prescription`, `frame_type`, `price`, `left_glass_color`, `right_glass_color`, `frame_color`, `brand_id`) VALUES
(1, 1.25, 1.50, 'metal', 150.00, 'transparent', 'transparent', 'black', 1),
(2, 0.00, 0.00, 'plastic', 180.00, 'green', 'green', 'tortoise', 1),
(3, 2.00, 2.25, 'floating', 220.00, 'transparent', 'transparent', 'gold', 3),
(4, 0.50, 0.50, 'plastic', 195.00, 'brown', 'brown', 'black', 2),
(5, 1.00, 1.00, 'metal', 250.00, 'transparent', 'transparent', 'silver', 4);

INSERT INTO `optics`.`sales` (`id`, `date_sale`, `employee_id`, `glass_id`, `client_id`) VALUES
(1, '2026-03-10 11:30:00', 1, 1, 1),
(2, '2026-04-15 17:00:00', 1, 2, 1),
(3, '2026-06-01 10:15:00', 2, 3, 2),
(4, '2026-07-20 18:45:00', 1, 4, 3);


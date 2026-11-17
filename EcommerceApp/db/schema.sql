-- MySQL schema + seed data for EcommerceApp.
-- Generated from the original SQLite file mydatabase.db.
-- Load with:  mysql -u root -p < db/schema.sql

CREATE DATABASE IF NOT EXISTS ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce;
SET FOREIGN_KEY_CHECKS = 0;

DROP VIEW IF EXISTS `viewlist`;
DROP VIEW IF EXISTS `laptop`;
DROP VIEW IF EXISTS `tv`;
DROP VIEW IF EXISTS `mobile`;
DROP VIEW IF EXISTS `watch`;
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `bid` int DEFAULT NULL,
  `bname` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `Name` varchar(100) DEFAULT NULL,
  `bname` varchar(50) DEFAULT NULL,
  `cname` varchar(50) DEFAULT NULL,
  `pname` varchar(50) DEFAULT NULL,
  `pprice` int DEFAULT NULL,
  `pquantity` int DEFAULT NULL,
  `pimage` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `cid` int DEFAULT NULL,
  `cname` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `contactus`;
CREATE TABLE `contactus` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Name` varchar(100) DEFAULT NULL,
  `Email_Id` varchar(100) DEFAULT NULL,
  `Contact_No` int DEFAULT NULL,
  `Message` varchar(8000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `Name` varchar(100) DEFAULT NULL,
  `Password` varchar(20) DEFAULT NULL,
  `Email_Id` varchar(100) DEFAULT NULL,
  `Contact_No` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `login`;
CREATE TABLE `login` (
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `order_details`;
CREATE TABLE `order_details` (
  `Date` varchar(100) DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `bname` varchar(50) DEFAULT NULL,
  `cname` varchar(50) DEFAULT NULL,
  `pname` varchar(50) DEFAULT NULL,
  `pprice` int DEFAULT NULL,
  `pquantity` int DEFAULT NULL,
  `pimage` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `Order_Id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Customer_Name` varchar(100) DEFAULT NULL,
  `Customer_City` varchar(45) DEFAULT NULL,
  `Date` varchar(100) DEFAULT NULL,
  `Total_Price` int DEFAULT NULL,
  `Status` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `pid` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `pname` varchar(50) DEFAULT NULL,
  `pprice` int DEFAULT NULL,
  `pquantity` int DEFAULT NULL,
  `pimage` varchar(200) DEFAULT NULL,
  `bid` int DEFAULT NULL,
  `cid` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `usermaster`;
CREATE TABLE `usermaster` (
  `Name` varchar(100) DEFAULT NULL,
  `Password` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `brand` (`bid`, `bname`) VALUES
  (1, 'samsung'),
  (2, 'sony'),
  (3, 'lenovo'),
  (4, 'acer'),
  (5, 'onida');

INSERT INTO `category` (`cid`, `cname`) VALUES
  (1, 'laptop'),
  (2, 'tv'),
  (3, 'mobile'),
  (4, 'watch');

INSERT INTO `customer` (`Name`, `Password`, `Email_Id`, `Contact_No`) VALUES
  ('Girish Narvekar', '1234', 'girish@gmail.com', 1234567891),
  ('Pratik Shinde', '1234', 'pratik@gmail.com', 1234),
  ('Yash More', '1234', 'yash@gmail.com', 1234567891);

INSERT INTO `login` (`username`, `password`) VALUES
  ('Swapnil', '1234'),
  ('admin', 'admin');

INSERT INTO `product` (`pid`, `pname`, `pprice`, `pquantity`, `pimage`, `bid`, `cid`) VALUES
  (5, 'sonysmart', 50000, 1, 'sonywatch.webp', 2, 4),
  (6, 'GalaxyBook', 45000, 1, 'samsunglaptop.jpg', 1, 1),
  (7, 'smarttv', 28000, 1, 'onidatv.jpg', 5, 2),
  (8, 'smartphone', 15000, 1, 'lenovomobile.webp', 3, 3),
  (9, 'aspire', 52000, 1, 'acerlaptop.jpg', 4, 1),
  (10, 'Braviass', 52, 1, 'sonytv.jpg', 2, 2),
  (11, 'GalaxyWatch', 22000, 1, 'galaxywatch.webp', 1, 4),
  (14, 'kdl', 45000, 1, 'sony kdl.jpg', 2, 2),
  (15, 'series a7', 21000, 1, 'acer series a7.jpg', 4, 2),
  (17, 'leo', 31000, 1, 'onida leo.jpg', 5, 2),
  (18, 'crystal', 42000, 1, 'samsung crystal.webp', 1, 2),
  (19, 'Aspire 7', 55000, 1, 'acer aspire7.jpg', 4, 1),
  (20, 'ideapad', 37000, 1, 'lenovo ideapad.jpg', 3, 1),
  (21, 'legion', 51000, 1, 'lenovo legion.jpg', 3, 1),
  (22, 'Galaxy Z Fold3', 66000, 1, 'Galaxy z fold3.jpg', 1, 3),
  (23, 'Galaxy S22', 55000, 1, 'Samsung galaxy s22.webp', 1, 3),
  (24, 'Xperia 1v', 56000, 1, 'sony xperia 1v.jpg', 2, 3),
  (26, 'A850', 14500, 1, 'lenovo a850.jpg', 3, 3),
  (27, 'Galaxy watch1', 8000, 1, 'galaxy watch.jpg', 1, 4),
  (28, 'Galaxy Watch2', 95000, 1, 'galaxy watch4.jpg', 1, 4),
  (29, 'Smart Fit', 11000, 1, 'smart fit.jpg', 3, 4),
  (30, 'Sony Smart2', 12000, 1, 'sony smart2.webp', 2, 4),
  (31, 'Gaming Predator', 120000, 1, 'Acer Predator.jpg', 4, 1),
  (32, 'Liquid', 16000, 1, 'Acer liquid.jpg', 4, 3),
  (33, 'Neo QLED', 46000, 1, 'Samsung neo Qled.webp', 1, 2),
  (34, 'VAIO', 53000, 1, 'Sony Vaio.jpg', 2, 1),
  (35, 'Xperia Z', 32000, 1, 'sonyxperiaz.png', 2, 3);

INSERT INTO `usermaster` (`Name`, `Password`) VALUES
  ('Swapnil', '1234'),
  ('admin', 'admin');

CREATE VIEW `viewlist` AS
    SELECT 
       `bname`,
         `cname`,
         `pname`,
         `pprice` ,
         `pquantity` ,
         `pimage` 
    FROM
        ((`brand`
        JOIN `product` ON ((brand.bid = product.bid)))
        JOIN `category` ON ((product.cid = category.cid)));

CREATE VIEW `laptop` AS
    SELECT 
      `bname`,
        `cname`,
        `pname`,
        `pprice`,
        `pquantity` ,
        `pimage` 
    FROM
        ((`brand`
        JOIN `product` ON ((`brand`.`bid` = `product`.`bid`)))
        JOIN `category` ON ((`product`.`cid` = `category`.`cid`)))
    WHERE
        (`category`.`cid` = 1);

CREATE VIEW `tv` AS
    SELECT 
      `bname`,
        `cname` ,
        `pname` ,
        `pprice`,
        `pquantity` ,
        `pimage` 
    FROM
        ((`brand`
        JOIN `product` ON ((`brand`.`bid` = `product`.`bid`)))
        JOIN `category` ON ((`product`.`cid` = `category`.`cid`)))
    WHERE
        (`category`.`cid` = 2);

CREATE VIEW `mobile` AS
    SELECT 
      `bname`,
        `cname`,
        `pname` ,
        `pprice`,
        `pquantity` ,
        `pimage` 
    FROM
        ((`brand`
        JOIN `product` ON ((`brand`.`bid` = `product`.`bid`)))
        JOIN `category` ON ((`product`.`cid` = `category`.`cid`)))
    WHERE
        (`category`.`cid` = 3);

CREATE VIEW `watch` AS
    SELECT 
     `bname` ,
        `cname`,
       `pname` ,
       `pprice` ,
       `pquantity`,
       `pimage` 
    FROM
        ((`brand`
        JOIN `product` ON ((`brand`.`bid` = `product`.`bid`)))
        JOIN `category` ON ((`product`.`cid` = `category`.`cid`)))
    WHERE
        (`category`.`cid` = 4);

SET FOREIGN_KEY_CHECKS = 1;

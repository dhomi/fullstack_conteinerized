-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Gegenereerd op: 17 nov 2024 om 13:12
-- Serverversie: 11.5.2-MariaDB-ubu2404
-- PHP-versie: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `QAsportarticles`
--
CREATE DATABASE IF NOT EXISTS `QAsportarticles` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci;
USE `QAsportarticles`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_booking_line`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_booking_line` (IN `p_booking_number` INT, IN `p_sequence_number` INT, IN `p_order_number` INT, IN `p_article_code` INT, IN `p_amount` DECIMAL(10,2))   BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM booking_line
        WHERE booking_number = p_booking_number
          AND sequence_number = p_sequence_number
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Deze booking_number en sequence_number combinatie bestaat al.';
    ELSE
        
        INSERT INTO booking_line (booking_number, sequence_number, order_number, article_code, amount)
        VALUES (p_booking_number, p_sequence_number, p_order_number, p_article_code, p_amount);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `add_goods_receipt`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_goods_receipt` (IN `p_order_number` INT, IN `p_article_code` INT, IN `p_receipt_date` DATE, IN `p_receipt_quantity` INT, IN `p_status` CHAR(1), IN `p_booking_number` INT, IN `p_sequence_number` INT)   BEGIN
    
    IF NOT EXISTS (
        SELECT 1
        FROM booking_line
        WHERE booking_number = p_booking_number
          AND sequence_number = p_sequence_number
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Booking number and sequence number do not exist in booking_line.';
    ELSE
       
        INSERT INTO goods_receipt (order_number, article_code, receipt_date, receipt_quantity, status, booking_number, sequence_number)
        VALUES (p_order_number, p_article_code, p_receipt_date, p_receipt_quantity, p_status, p_booking_number, p_sequence_number);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `add_order_line`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_order_line` (IN `p_order_number` INT, IN `p_article_code` INT, IN `p_quantity` INT, IN `p_order_price` DECIMAL(10,2))   BEGIN
    DECLARE available_stock INT;

    SELECT stock_quantity INTO available_stock
    FROM sports_articles
    WHERE article_code = p_article_code;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Artikelcode bestaat niet.';
    END IF;

    IF p_quantity > available_stock THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Onvoldoende voorraad voor dit artikel.';
    END IF;

    INSERT INTO order_lines (order_number, article_code, quantity, order_price)
    VALUES (p_order_number, p_article_code, p_quantity, p_order_price);

    UPDATE sports_articles
    SET stock_quantity = stock_quantity - p_quantity
    WHERE article_code = p_article_code;
END$$

DROP PROCEDURE IF EXISTS `check_low_stock`$$
CREATE DEFINER=`root`@`%` PROCEDURE `check_low_stock` ()   BEGIN
    SELECT 
        sa.article_code, 
        sa.article_name, 
        sa.stock_quantity,
        IFNULL(SUM(gr.receipt_quantity), 0) AS total_received,
        sa.stock_quantity - IFNULL(SUM(gr.receipt_quantity), 0) AS remaining_stock
    FROM 
        sports_articles sa
    LEFT JOIN 
        goods_receipt gr ON sa.article_code = gr.article_code
    GROUP BY 
        sa.article_code, sa.article_name, sa.stock_quantity, sa.stock_min
    HAVING 
        remaining_stock < sa.stock_min;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `booking`
--

DROP TABLE IF EXISTS `booking`;
CREATE TABLE IF NOT EXISTS `booking` (
  `booking_number` int(11) NOT NULL AUTO_INCREMENT,
  `booking_date` date NOT NULL,
  `amount` decimal(9,2) NOT NULL,
  `customer_code` int(11) DEFAULT NULL,
  `supplier_code` int(11) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`booking_number`),
  KEY `fk_booking_customer` (`customer_code`),
  KEY `fk_booking_supplier` (`supplier_code`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE TABLE `booking`;

INSERT INTO `booking` (`booking_number`, `booking_date`, `amount`, `customer_code`, `supplier_code`, `status`) VALUES
(1, '2024-07-17', 602.50, NULL, 13, 'A'),
(2, '2024-08-25', 117.50, NULL, 4, 'A'),
(3, '2024-08-27', 399.50, NULL, 4, 'A'),
(4, '2024-09-06', 607.60, NULL, 9, 'A'),
(5, '2024-09-06', 240.00, NULL, 22, 'A'),
(6, '2024-09-11', 422.50, NULL, 20, 'A'),
(7, '2024-09-13', 680.25, NULL, 14, 'A'),
(8, '2024-09-13', 1316.75, NULL, 13, 'A'),
(9, '2024-09-13', 330.75, NULL, 35, 'A'),
(10, '2024-09-14', 966.95, NULL, 35, 'A'),
(11, '2024-09-14', 72.00, NULL, 4, 'A'),
(12, '2024-09-26', 221.25, NULL, 4, 'A'),
(13, '2024-09-26', 466.25, NULL, 14, 'A'),
(14, '2024-10-01', 605.00, NULL, 19, 'A'),
(15, '2024-10-01', 497.50, NULL, 34, 'A'),
(16, '2024-08-01', 715.50, 100, NULL, 'A'),
(17, '2024-08-08', 260.00, 100, NULL, 'A'),
(18, '2024-08-15', 730.00, 100, NULL, 'A'),
(19, '2024-09-11', 765.00, 100, NULL, 'A'),
(20, '2024-08-05', 401.00, 101, NULL, 'A'),
(21, '2024-08-27', 768.50, 101, NULL, 'A'),
(22, '2024-09-08', 215.00, 101, NULL, 'A'),
(23, '2024-08-25', 498.15, 102, NULL, 'A'),
(24, '2024-09-05', 1107.00, 102, NULL, 'A'),
(25, '2024-09-17', 256.25, 102, NULL, 'A');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `booking_line`
--

DROP TABLE IF EXISTS `booking_line`;
CREATE TABLE IF NOT EXISTS `booking_line` (
  `booking_number` int(11) NOT NULL,
  `sequence_number` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `order_number` int(11) NOT NULL,
  `article_code` int(11) NOT NULL,
  PRIMARY KEY (`booking_number`,`sequence_number`),
  KEY `idx_booking_line_booking_number` (`booking_number`),
  KEY `fk_booking_line_order` (`order_number`),
  KEY `fk_booking_line_article` (`article_code`),
  KEY `idx_booking_number_sequence_number` (`booking_number`,`sequence_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE TABLE `booking_line`;

INSERT INTO `booking_line` (`booking_number`, `sequence_number`, `amount`, `order_number`, `article_code`) VALUES
(1, 1, 100.00, 121, 31),
(1, 2, 100.00, 121, 31),
(1, 3, 25.00, 121, 31),
(2, 1, 602.50, 0, 0),
(2, 2, 50.00, 174, 380),
(2, 3, 50.00, 174, 380),
(3, 1, 33.75, 0, 0),
(3, 2, 83.75, 0, 0),
(3, 3, 12.00, 175, 380),
(3, 4, 25.00, 175, 434),
(3, 5, 40.00, 175, 74),
(3, 6, 400.00, 175, 157),
(3, 7, 23.00, 175, 380),
(3, 8, 250.00, 175, 426),
(4, 1, 157.00, 0, 0),
(4, 2, 52.90, 0, 0),
(4, 3, 127.10, 0, 0),
(4, 4, 62.50, 0, 0),
(4, 5, 20.00, 181, 362),
(4, 6, 5.00, 181, 397),
(5, 1, 157.00, 0, 0),
(5, 2, 85.00, 184, 365),
(6, 1, 102.00, 0, 0),
(8, 1, 5.80, 0, 0),
(8, 2, 19.20, 0, 0),
(8, 3, 4.00, 190, 56),
(8, 4, 12.00, 190, 68),
(13, 1, 17.50, 0, 0),
(13, 2, 14.70, 0, 0),
(13, 3, 5.00, 201, 36),
(13, 4, 15.00, 201, 470),
(13, 5, 21.00, 201, 478),
(17, 1, 715.50, 0, 0),
(18, 1, 157.50, 0, 0),
(18, 2, 102.50, 0, 0),
(19, 1, 730.00, 0, 0),
(20, 1, 765.00, 0, 0),
(21, 1, 193.50, 0, 0),
(22, 1, 471.00, 0, 0),
(24, 1, 30.40, 0, 0),
(25, 1, 390.00, 0, 0);

DROP TRIGGER IF EXISTS `before_insert_booking_line`;
DELIMITER $$
CREATE TRIGGER `before_insert_booking_line` BEFORE INSERT ON `booking_line` FOR EACH ROW BEGIN
    DECLARE exists_order INT;
    DECLARE exists_article INT;

    SELECT COUNT(*) INTO exists_order
    FROM orders
    WHERE order_number = NEW.order_number;

    IF exists_order = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'order_number bestaat niet in orders tabel.';
    END IF;

    SELECT COUNT(*) INTO exists_article
    FROM sports_articles
    WHERE article_code = NEW.article_code;

    IF exists_article = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'article_code bestaat niet in sports_articles tabel.';
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `pre_insert_booking_line`;
DELIMITER $$
CREATE TRIGGER `pre_insert_booking_line` BEFORE INSERT ON `booking_line` FOR EACH ROW BEGIN
     SET NEW.sequence_number = (
        SELECT IFNULL(MAX(sequence_number), 0) + 1
        FROM booking_line
        WHERE booking_number = NEW.booking_number
     );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `customer_code` int(11) NOT NULL,
  `customer_name` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `credit_limit` decimal(10,2) DEFAULT NULL,
  `balance` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`customer_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Tabel leegmaken voor invoegen `customers`
--

TRUNCATE TABLE `customers`

INSERT INTO `customers` (`customer_code`, `customer_name`, `address`, `postal_code`, `phone`, `city`, `status`, `credit_limit`, `balance`) VALUES
(100, 'QA Football Articles', 'Football Street 1', '2492 VJ', '012-3456789', 'The Hague', 'A', 1000.00, 0.00),
(101, 'QA Tennis Articles', 'Tennis Street 1', '3078 ZD', '032-1987654', 'Rotterdam', 'A', 1000.00, 0.00),
(102, 'QA General Sports Articles', 'Sport Avenue 1', '9728 JT', '045-6123789', 'Groningen', 'A', 1000.00, 0.00),
(103, 'QA Fitness Articles', 'Sport Street 1', '1076 TW', '089-7654321', 'Amsterdam', 'A', 1000.00, 0.00);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `delivery`
--

DROP TABLE IF EXISTS `delivery`;
CREATE TABLE IF NOT EXISTS `delivery` (
  `purchase_number` int(11) NOT NULL,
  `article_code` int(11) NOT NULL,
  `delivery_date` date NOT NULL,
  `quantity` int(11) NOT NULL,
  `invoice_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`purchase_number`,`article_code`,`delivery_date`),
  KEY `idx_delivery_invoice_number` (`invoice_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE TABLE `delivery`;

INSERT INTO `delivery` (`purchase_number`, `article_code`, `delivery_date`, `quantity`, `invoice_number`) VALUES
(1, 1, '2024-08-08', 23, 1),
(1, 2, '2024-08-08', 2, 1),
(1, 35, '2024-08-08', 60, 1),
(1, 74, '2024-08-08', 90, 1),
(2, 39, '2024-08-11', 18, 2),
(2, 56, '2024-08-11', 45, 2),
(3, 54, '2024-08-15', 35, 3),
(3, 200, '2024-08-15', 3, 3),
(3, 210, '2024-08-20', 15, 4),
(3, 383, '2024-08-20', 10, 4),
(4, 12, '2024-08-21', 15, 5),
(4, 332, '2024-08-21', 100, 5),
(4, 397, '2024-08-26', 12, 6),
(5, 50, '2024-08-31', 9, 8),
(5, 56, '2024-08-25', 10, 8),
(6, 12, '2024-08-30', 20, 7),
(6, 23, '2024-08-30', 45, 7),
(7, 19, '2024-09-05', 78, 9),
(9, 117, '2024-09-14', 60, 10),
(9, 117, '2024-09-17', 15, 10),
(9, 296, '2024-09-14', 8, 10),
(9, 296, '2024-09-17', 2, 10),
(9, 300, '2024-09-14', 17, 10),
(9, 300, '2024-09-17', 10, 10),
(9, 300, '2024-09-19', 8, 10);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `goods_receipt`
--

DROP TABLE IF EXISTS `goods_receipt`;
CREATE TABLE IF NOT EXISTS `goods_receipt` (
  `receipt_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_number` int(11) NOT NULL,
  `article_code` int(11) NOT NULL,
  `receipt_date` date NOT NULL,
  `receipt_quantity` int(11) NOT NULL,
  `status` char(1) NOT NULL,
  `booking_number` int(11) NOT NULL,
  `sequence_number` int(11) NOT NULL,
  PRIMARY KEY (`receipt_id`),
  KEY `booking_number` (`booking_number`,`sequence_number`),
  KEY `idx_article_code` (`article_code`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


TRUNCATE TABLE `goods_receipt`;

INSERT INTO `goods_receipt` (`receipt_id`, `order_number`, `article_code`, `receipt_date`, `receipt_quantity`, `status`, `booking_number`, `sequence_number`) VALUES
(1, 121, 31, '2024-07-31', 25, 'A', 1, 1),
(135, 121, 31, '2024-07-31', 25, 'A', 1, 1),
(136, 121, 87, '2024-07-31', 50, 'A', 1, 1),
(137, 121, 311, '2024-07-31', 50, 'A', 1, 1),
(138, 121, 314, '2024-07-31', 150, 'A', 1, 1),
(139, 121, 365, '2024-07-31', 150, 'A', 1, 1),
(140, 121, 422, '2024-07-31', 25, 'A', 1, 1),
(141, 174, 102, '2024-09-04', 25, 'A', 2, 1),
(142, 174, 380, '2024-09-04', 25, 'A', 2, 1),
(143, 174, 455, '2024-09-10', 50, 'A', 2, 2),
(144, 174, 470, '2024-09-10', 25, 'A', 2, 2),
(145, 175, 36, '2024-09-06', 30, 'A', 3, 1),
(146, 175, 74, '2024-09-06', 20, 'A', 3, 1),
(147, 175, 95, '2024-09-06', 100, 'A', 3, 1),
(148, 175, 380, '2024-09-06', 15, 'A', 3, 1),
(149, 175, 455, '2024-09-06', 50, 'A', 3, 1),
(150, 175, 470, '2024-09-06', 25, 'A', 3, 1),
(151, 175, 478, '2024-09-06', 50, 'A', 3, 1),
(152, 175, 36, '2024-09-15', 20, 'A', 3, 2),
(153, 175, 74, '2024-09-15', 40, 'A', 3, 2),
(154, 175, 102, '2024-09-15', 10, 'A', 3, 2),
(155, 175, 380, '2024-09-15', 30, 'A', 3, 2),
(170, 175, 380, '2024-09-15', 12, 'A', 3, 2),
(171, 175, 434, '2024-09-20', 25, 'A', 3, 3),
(172, 175, 74, '2024-09-20', 40, 'A', 3, 3),
(173, 175, 157, '2024-09-20', 400, 'A', 3, 3),
(174, 175, 380, '2024-09-20', 23, 'A', 3, 3),
(175, 175, 426, '2024-09-25', 250, 'A', 3, 4),
(176, 181, 362, '2024-09-27', 20, 'A', 4, 1),
(177, 181, 397, '2024-09-27', 5, 'A', 4, 1),
(178, 184, 365, '2024-09-19', 85, 'A', 5, 1),
(179, 190, 56, '2024-09-23', 4, 'A', 8, 1),
(180, 190, 68, '2024-09-27', 12, 'A', 8, 2),
(181, 201, 36, '2024-10-02', 5, 'A', 13, 1),
(182, 201, 470, '2024-10-02', 15, 'A', 13, 1),
(183, 201, 478, '2024-10-07', 21, 'A', 13, 2);

DROP TRIGGER IF EXISTS `after_insert_goods_receipt`;
DELIMITER $$
CREATE TRIGGER `after_insert_goods_receipt` AFTER INSERT ON `goods_receipt` FOR EACH ROW BEGIN
    UPDATE sports_articles
    SET stock_quantity = stock_quantity + NEW.receipt_quantity
    WHERE article_code = NEW.article_code;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `invoice`
--

DROP TABLE IF EXISTS `invoice`;
CREATE TABLE IF NOT EXISTS `invoice` (
  `invoice_number` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_date` date NOT NULL,
  `status` char(1) DEFAULT NULL,
  `booking_number` int(11) NOT NULL,
  `sequence_number` int(11) NOT NULL,
  PRIMARY KEY (`invoice_number`),
  KEY `fk_invoice_booking_line` (`booking_number`,`sequence_number`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE TABLE `invoice`;

INSERT INTO `invoice` (`invoice_number`, `invoice_date`, `status`, `booking_number`, `sequence_number`) VALUES
(1, '2024-08-07', 'A', 17, 1),
(2, '2024-08-10', 'A', 21, 1),
(3, '2024-08-15', 'A', 18, 1),
(4, '2024-08-19', 'A', 18, 2),
(5, '2024-08-21', 'A', 19, 1),
(6, '2024-08-25', 'A', 19, 1),
(7, '2024-08-30', 'A', 22, 1),
(8, '2024-08-30', 'A', 24, 1),
(9, '2024-09-05', 'A', 25, 1),
(10, '2024-09-14', 'A', 20, 1);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `order_number` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_code` int(11) NOT NULL,
  `order_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `amount` decimal(6,2) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`order_number`),
  KEY `fk_orders_suppliers` (`supplier_code`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `orders`;

INSERT INTO `orders` (`order_number`, `supplier_code`, `order_date`, `delivery_date`, `amount`, `status`) VALUES
(121, 13, '2024-07-17', '2024-07-31', 602.50, 'C'),
(174, 4, '2024-08-25', '2024-09-04', 117.50, 'C'),
(175, 4, '2024-08-27', '2024-09-06', 399.50, 'C'),
(181, 9, '2024-09-06', '2024-09-27', 607.60, 'C'),
(184, 22, '2024-09-06', '2024-09-16', 240.00, 'C'),
(186, 20, '2024-09-11', '2024-09-18', 422.50, 'C'),
(190, 14, '2024-09-13', '2024-09-23', 680.25, 'C'),
(191, 13, '2024-09-13', '2024-09-27', 1316.75, 'C'),
(192, 35, '2024-09-13', '2024-09-23', 330.75, 'C'),
(197, 35, '2024-09-14', '2024-09-23', 966.95, 'C'),
(200, 4, '2024-09-14', '2024-09-21', 72.00, 'C'),
(201, 4, '2024-09-26', '2024-10-02', 221.25, 'C'),
(202, 14, '2024-09-26', '2024-10-05', 466.25, 'C'),
(203, 19, '2024-10-01', '2024-10-15', 605.00, 'C'),
(204, 34, '2024-10-01', '2024-10-15', 497.50, 'C');

-- --------------------------------------------------------


DROP TABLE IF EXISTS `order_lines`;
CREATE TABLE IF NOT EXISTS `order_lines` (
  `order_number` int(11) NOT NULL,
  `article_code` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `order_price` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`order_number`,`article_code`),
  KEY `idx_order_lines_article_code` (`article_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `order_lines`;

INSERT INTO `order_lines` (`order_number`, `article_code`, `quantity`, `order_price`) VALUES
(121, 31, 25, 6.35),
(121, 87, 50, 1.90),
(121, 311, 50, 1.65),
(121, 314, 100, 0.45),
(121, 422, 25, 2.25),
(174, 102, 25, 0.70),
(174, 380, 10, 0.65),
(174, 455, 50, 1.35),
(174, 470, 25, 0.65),
(175, 36, 50, 0.75),
(175, 74, 100, 0.70),
(175, 102, 10, 0.45),
(175, 157, 100, 0.20),
(175, 380, 10, 0.45),
(175, 426, 10, 0.25),
(175, 434, 10, 0.35),
(175, 455, 50, 0.80),
(175, 470, 25, 0.45),
(175, 478, 50, 0.45),
(181, 257, 10, 3.60),
(181, 263, 25, 15.45),
(181, 362, 10, 6.05),
(181, 397, 5, 7.20),
(186, 143, 10, 1.30),
(190, 23, 10, 1.00),
(190, 50, 6, 0.35),
(190, 56, 10, 1.45),
(190, 102, 25, 0.55),
(190, 455, 100, 1.15);

DROP TRIGGER IF EXISTS `check_stock_before_insert`;
DELIMITER $$
CREATE TRIGGER `check_stock_before_insert` BEFORE INSERT ON `order_lines` FOR EACH ROW BEGIN
    DECLARE available_stock INT;

    SELECT stock_quantity INTO available_stock
    FROM sports_articles
    WHERE article_code = NEW.article_code;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Artikelcode bestaat niet.';
    END IF;

    IF NEW.quantity > available_stock THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Onvoldoende voorraad voor dit artikel.';
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `check_stock_before_update`;
DELIMITER $$
CREATE TRIGGER `check_stock_before_update` BEFORE UPDATE ON `order_lines` FOR EACH ROW BEGIN
    DECLARE available_stock INT;

    SELECT stock_quantity INTO available_stock
    FROM sports_articles
    WHERE article_code = NEW.article_code;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Artikelcode bestaat niet.';
    END IF;

    -- Controleer of de voorraad voldoende is
    IF NEW.quantity > available_stock THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Onvoldoende voorraad voor dit artikel.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `purchases`
--

DROP TABLE IF EXISTS `purchases`;
CREATE TABLE IF NOT EXISTS `purchases` (
  `purchase_number` int(11) NOT NULL,
  `customer_code` int(11) NOT NULL,
  `purchase_date` date DEFAULT NULL,
  PRIMARY KEY (`purchase_number`),
  KEY `fk_purchases_customers` (`customer_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `purchases`;

INSERT INTO `purchases` (`purchase_number`, `customer_code`, `purchase_date`) VALUES
(1, 100, '2024-08-01'),
(2, 101, '2024-08-05'),
(3, 100, '2024-08-08'),
(4, 100, '2024-08-15'),
(5, 102, '2024-08-25'),
(6, 101, '2024-08-27'),
(7, 102, '2024-09-05'),
(8, 101, '2024-09-08'),
(9, 100, '2024-09-11'),
(10, 102, '2024-09-17');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `purchase_line`
--

DROP TABLE IF EXISTS `purchase_line`;
CREATE TABLE IF NOT EXISTS `purchase_line` (
  `purchase_number` int(11) NOT NULL,
  `article_code` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `purchase_price` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`purchase_number`,`article_code`),
  KEY `idx_purchase_line_article_code` (`article_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE TABLE `purchase_line`;

INSERT INTO `purchase_line` (`purchase_number`, `article_code`, `quantity`, `purchase_price`) VALUES
(1, 1, 23, 19.50),
(1, 2, 2, 22.50),
(1, 35, 60, 1.00),
(1, 74, 90, 1.80),
(2, 39, 20, 4.50),
(2, 56, 60, 2.50),
(2, 384, 12, 3.50),
(2, 422, 34, 3.50),
(3, 54, 35, 3.00),
(3, 200, 3, 17.50),
(3, 210, 15, 0.50),
(3, 383, 10, 9.50),
(4, 12, 15, 20.00),
(4, 332, 100, 2.50),
(4, 397, 12, 15.00),
(5, 50, 9, 0.60),
(5, 56, 12, 2.50),
(5, 126, 85, 3.75),
(5, 195, 7, 14.50),
(5, 311, 17, 2.50),
(6, 12, 20, 19.50),
(6, 23, 45, 1.80),
(6, 175, 10, 3.00),
(6, 300, 25, 9.50),
(6, 391, 15, 2.00),
(7, 19, 90, 5.00),
(7, 47, 21, 19.50),
(7, 117, 45, 5.50),
(8, 207, 65, 2.00),
(8, 332, 34, 2.50),
(9, 117, 75, 5.50),
(9, 296, 10, 2.00),
(9, 300, 35, 9.50),
(10, 67, 15, 2.25),
(10, 104, 5, 17.50),
(10, 408, 6, 22.50);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `quotations`
--

DROP TABLE IF EXISTS `quotations`;
CREATE TABLE IF NOT EXISTS `quotations` (
  `quotation_id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_code` int(11) NOT NULL,
  `article_code` int(11) NOT NULL,
  `supplier_article_code` varchar(50) NOT NULL,
  `delivery_time` int(11) NOT NULL,
  `quotation_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`quotation_id`),
  KEY `fk_quotations_article` (`article_code`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;


TRUNCATE TABLE `quotations`;

INSERT INTO `quotations` (`quotation_id`, `supplier_code`, `article_code`, `supplier_article_code`, `delivery_time`, `quotation_price`) VALUES
(1, 35, 190, 'ST4P5', 10, 0.85),
(2, 35, 42, 'ST4P6', 10, 3.30),
(3, 35, 283, 'ST4P2', 10, 3.30),
(4, 21, 364, 'BRE', 10, 2.50),
(5, 21, 108, 'FOR', 10, 2.75),
(6, 21, 408, 'HUL', 10, 11.25),
(7, 21, 117, 'KOR', 10, 2.75),
(8, 21, 210, 'LIG', 10, 0.20),
(9, 21, 195, 'MAG', 10, 7.25),
(10, 21, 471, 'OLI', 10, 5.00),
(11, 21, 397, 'PEP', 10, 7.50),
(12, 21, 1, 'ROD', 10, 9.75),
(13, 21, 12, 'SER', 10, 9.75),
(14, 21, 263, 'TOV', 10, 16.00),
(15, 21, 19, 'VUU', 10, 2.50),
(16, 21, 242, 'ZUU', 10, 1.75),
(17, 22, 286, 'B-011', 14, 12.15),
(18, 22, 281, 'B-034', 14, 6.75),
(19, 22, 39, 'B-076', 14, 2.45),
(20, 22, 28, 'B-104', 14, 22.95),
(21, 22, 335, 'E-002', 10, 2.95),
(22, 22, 365, 'E-003', 10, 0.80),
(23, 22, 210, 'S-015', 14, 0.20),
(24, 22, 471, 'S-077', 14, 5.40),
(25, 22, 103, 'S-118', 14, 9.45),
(26, 22, 364, 'S-154', 14, 2.70),
(27, 34, 82, 'ACMO', 14, 2.15),
(28, 34, 61, 'ALTH', 14, 1.25),
(29, 34, 462, 'ANCE', 14, 1.25),
(30, 34, 390, 'ANEM', 14, 2.15),
(31, 34, 224, 'ANGR', 14, 1.25),
(32, 34, 468, 'ANTI', 14, 0.50),
(33, 34, 153, 'AQUI', 14, 1.55),
(34, 34, 105, 'ARDR', 14, 1.25),
(35, 34, 123, 'BEGO', 14, 0.40),
(36, 34, 87, 'CAMP', 14, 1.85),
(37, 34, 74, 'CHEI', 14, 1.10),
(38, 34, 164, 'CHMA', 14, 1.55),
(39, 34, 300, 'CORT', 14, 5.90),
(40, 34, 398, 'CYNO', 14, 0.60),
(41, 34, 212, 'DELP', 14, 1.85),
(42, 34, 24, 'ECHI', 14, 1.85),
(43, 34, 13, 'ERYN', 14, 1.85),
(44, 34, 427, 'HEDE', 14, 4.65),
(45, 34, 89, 'LUPI', 14, 1.55),
(46, 34, 120, 'OCBA', 14, 1.25),
(47, 34, 285, 'PAPA', 14, 3.10),
(48, 34, 380, 'PARH', 14, 0.60),
(49, 34, 143, 'PHLO', 14, 0.95),
(50, 34, 455, 'PRIM', 14, 1.25),
(51, 34, 319, 'RUSC', 14, 1.25),
(52, 34, 391, 'SALV', 14, 1.25),
(53, 34, 50, 'TAGE', 14, 0.35),
(54, 34, 469, 'TULI', 14, 0.25),
(55, 34, 157, 'VIOL', 14, 0.30),
(56, 34, 31, 'VITI', 14, 6.20),
(57, 34, 253, 'WIST', 14, 0.05),
(58, 35, 89, 'ST1P1', 10, 1.65),
(59, 35, 311, 'ST1P3', 10, 1.65),
(60, 35, 130, 'ST1P4', 10, 1.30),
(61, 35, 61, 'ST1P6', 10, 1.30),
(62, 35, 428, 'ST1P8', 10, 2.95),
(63, 35, 285, 'ST1P9', 10, 3.30),
(64, 35, 467, 'ST2P1', 10, 1.30),
(65, 35, 54, 'ST2P2', 10, 2.00),
(66, 35, 82, 'ST2P3', 10, 2.30),
(67, 35, 205, 'ST2P5', 10, 2.95),
(68, 35, 68, 'ST2P6', 10, 2.00),
(69, 35, 180, 'ST3P1', 10, 4.30),
(70, 35, 427, 'ST3P2', 10, 4.95),
(71, 35, 296, 'ST3P5', 10, 1.30),
(72, 35, 320, 'ST4P1', 10, 7.90),
(73, 21, 103, 'AZA', 10, 8.75),
(74, 13, 312, 'G430', 10, 2.95),
(75, 13, 316, 'H510', 10, 1.95),
(76, 14, 455, '001-2', 10, 1.15),
(77, 14, 212, '012-V', 10, 1.70),
(78, 14, 372, '027-V', 10, 1.45),
(79, 14, 384, '067-V', 10, 2.00),
(80, 14, 297, '082-V', 10, 1.15),
(81, 14, 23, '103-2', 10, 1.05),
(82, 14, 13, '117-V', 10, 1.70),
(83, 14, 467, '118-V', 10, 1.15),
(84, 14, 228, '162-V', 10, 1.15),
(85, 14, 478, '195-1', 10, 0.55),
(86, 14, 390, '201-V', 10, 2.00),
(87, 14, 68, '209-V', 10, 1.70),
(88, 14, 50, '255-1', 10, 0.35),
(89, 14, 164, '257-V', 10, 1.45),
(90, 14, 54, '263-V', 10, 1.70),
(91, 14, 351, '264-V', 10, 1.45),
(92, 14, 398, '273-2', 10, 0.55),
(93, 14, 102, '281-2', 10, 0.55),
(94, 14, 87, '286-V', 10, 1.70),
(95, 14, 71, '300-V', 10, 1.15),
(96, 14, 147, '327-1', 10, 0.45),
(97, 14, 438, '335-V', 10, 1.70),
(98, 14, 311, '362-V', 10, 1.45),
(99, 14, 157, '365-V', 10, 0.30),
(100, 14, 56, '393-V', 10, 1.45),
(101, 14, 363, '397-V', 10, 2.55),
(102, 14, 380, '400-2', 10, 0.55),
(103, 14, 316, '408-V', 10, 1.70),
(104, 14, 35, '471-2', 10, 0.55),
(105, 14, 123, '498-1', 10, 0.35),
(106, 19, 82, 'ACMO', 14, 2.10),
(107, 19, 175, 'ACON', 14, 1.80),
(108, 19, 425, 'ALSC', 14, 1.20),
(109, 19, 61, 'ALTH', 14, 1.20),
(110, 19, 87, 'CAMP', 14, 1.80),
(111, 19, 80, 'CENT', 14, 1.20),
(112, 19, 164, 'CHRY', 14, 1.50),
(113, 19, 56, 'CYNO', 14, 1.50),
(114, 19, 212, 'DELP', 14, 1.80),
(115, 19, 438, 'DIAN', 14, 1.80),
(116, 19, 13, 'ERYN', 14, 1.80),
(117, 19, 372, 'EUPH', 14, 1.50),
(118, 19, 316, 'GEUM', 14, 1.80),
(119, 19, 363, 'GYPS', 14, 2.70),
(120, 19, 467, 'HELI', 14, 1.20),
(121, 19, 486, 'KNIP', 14, 2.10),
(122, 19, 71, 'LAMI', 14, 1.20),
(123, 19, 89, 'LUPI', 14, 1.50),
(124, 19, 234, 'MATR', 14, 1.80),
(125, 19, 78, 'PAEO', 14, 2.70),
(126, 19, 67, 'POTE', 14, 1.35),
(127, 19, 207, 'ROSM', 14, 1.20),
(128, 20, 470, '001', 7, 0.65),
(129, 20, 361, '047', 7, 0.65),
(130, 20, 253, '066', 7, 0.10),
(131, 20, 36, '103', 7, 1.15),
(132, 20, 468, '162', 7, 0.50),
(133, 20, 184, '195', 7, 0.10),
(134, 20, 123, '209', 7, 0.40),
(135, 20, 434, '210', 7, 0.50),
(136, 20, 266, '257', 7, 0.65),
(137, 20, 169, '263', 7, 0.05),
(138, 20, 126, '281', 7, 2.45),
(139, 20, 383, '362', 7, 0.65),
(140, 20, 147, '393', 7, 0.50),
(141, 20, 143, '471', 7, 1.00),
(142, 20, 314, '498', 7, 0.50),
(143, 13, 31, 'G202', 14, 6.50),
(144, 4, 426, 'A075', 7, 0.35),
(145, 4, 157, 'A103', 7, 0.30),
(146, 4, 478, 'A184', 7, 0.60),
(147, 4, 36, 'A004', 7, 1.10),
(148, 4, 95, 'A385', 7, 0.60),
(149, 4, 455, 'A421', 7, 1.20),
(150, 4, 380, 'B148', 7, 0.60),
(151, 4, 102, 'B331', 7, 0.60),
(152, 4, 74, 'B337', 7, 1.10),
(153, 4, 470, 'C274', 7, 0.60),
(154, 4, 434, 'D225', 7, 0.50),
(155, 9, 498, '002', 21, 2.95),
(156, 9, 420, '011', 21, 9.90),
(157, 9, 195, '013', 21, 6.55),
(158, 9, 104, '014', 21, 7.90),
(159, 9, 364, '021', 21, 2.25),
(160, 9, 408, '023', 21, 10.15),
(161, 9, 103, '024', 21, 7.90),
(162, 9, 117, '029', 21, 2.50),
(163, 9, 257, '044', 21, 3.40),
(164, 9, 397, '045', 21, 6.75),
(165, 9, 1, '050', 21, 8.80),
(166, 9, 286, '078', 21, 10.15),
(167, 9, 178, '081', 21, 3.40),
(168, 9, 471, '085', 21, 4.50),
(169, 9, 27, '091', 21, 7.90),
(170, 9, 210, '097', 21, 0.20),
(171, 9, 362, '099', 21, 5.65),
(172, 9, 66, '103', 21, 6.10),
(173, 9, 209, '114', 21, 8.80),
(174, 9, 281, '115', 21, 5.65),
(175, 9, 263, '116', 21, 14.40),
(176, 9, 162, '145', 21, 4.30),
(177, 11, 335, 'E01R', 21, 2.90),
(178, 11, 365, 'E05R', 10, 0.80),
(179, 11, 327, 'E11X', 10, 1.05),
(180, 11, 255, 'E23W', 10, 1.05),
(181, 11, 408, 'H09', 14, 11.95),
(182, 11, 1, 'H10R', 14, 10.35),
(183, 11, 397, 'H14R', 14, 7.95),
(184, 11, 195, 'H14W', 14, 7.70),
(185, 11, 117, 'H17', 14, 2.90),
(186, 11, 103, 'H19O', 14, 9.30),
(187, 11, 12, 'H75P', 14, 10.35),
(188, 11, 263, 'H99G', 14, 16.95),
(189, 13, 67, 'A002', 10, 1.45),
(190, 13, 36, 'A101', 7, 1.15),
(191, 13, 184, 'A103', 7, 0.10),
(192, 13, 314, 'A154', 7, 0.50),
(193, 13, 372, 'A230', 10, 1.65),
(194, 13, 82, 'A395', 10, 2.30),
(195, 13, 383, 'A472', 7, 0.65),
(196, 13, 391, 'A520', 10, 1.30),
(197, 13, 437, 'A677', 10, 1.30),
(198, 13, 365, 'B006', 14, 1.00),
(199, 13, 123, 'B101', 7, 0.40),
(200, 13, 422, 'B111', 10, 2.30),
(201, 13, 311, 'B396', 10, 1.65),
(202, 13, 1, 'B578', 14, 12.70),
(203, 13, 281, 'C051', 14, 8.15),
(204, 13, 262, 'C119', 14, 6.20),
(205, 13, 200, 'C243', 14, 11.40),
(206, 13, 471, 'D029', 14, 6.50),
(207, 13, 362, 'D296', 14, 8.15),
(208, 13, 56, 'D321', 10, 1.65),
(209, 13, 47, 'D555', 14, 12.70),
(210, 13, 364, 'D742', 14, 3.25),
(211, 13, 87, 'E098', 10, 1.95),
(212, 13, 228, 'E409', 10, 1.30),
(213, 13, 300, 'F342', 10, 6.20),
(214, 13, 332, 'F823', 10, 1.65),
(215, 13, 71, 'G001', 10, 1.30),
(216, 34, 39, 'VOETBALSCHOENEN', 14, 2.00);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `sports_articles`
--

DROP TABLE IF EXISTS `sports_articles`;
CREATE TABLE IF NOT EXISTS `sports_articles` (
  `article_code` int(11) NOT NULL,
  `article_name` varchar(50) DEFAULT NULL,
  `category` varchar(30) DEFAULT NULL,
  `size` varchar(15) DEFAULT NULL,
  `color` varchar(15) DEFAULT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT NULL,
  `stock_min` int(11) DEFAULT NULL,
  `VAT_type` char(1) NOT NULL,
  PRIMARY KEY (`article_code`),
  KEY `fk_sports_articles_vat` (`VAT_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `sports_articles`;

INSERT INTO `sports_articles` (`article_code`, `article_name`, `category`, `size`, `color`, `price`, `stock_quantity`, `stock_min`, `VAT_type`) VALUES
(1, 'Premium Football', 'Ball', '5', 'White/Black', 30.00, 50, 10, 'h'),
(2, 'Professional Tennis Racket', 'Racket', 'Standard', 'Black', 150.00, 20, 5, 'h'),
(12, 'Advanced Basketball', 'Ball', '7', 'Orange', 25.00, 40, 10, 'h'),
(13, 'Naam van Artikel 13', 'Categorie', 'Grootte', 'Kleur', 25.00, 30, 5, 'l'),
(19, 'Table Tennis Paddle', 'Racket', 'Standard', 'Red/Black', 15.00, 60, 15, 'l'),
(23, 'Volleyball Net', 'Accessory', 'Standard', 'White', 75.00, 100, 5, 'l'),
(24, 'Naam van Artikel 24', 'Categorie', 'Grootte', 'Kleur', 20.00, 50, 10, 'h'),
(27, 'Running Shoes', 'Footwear', '42', 'Black', 75.00, 50, 5, 'h'),
(28, 'Product Name 28', 'Category', 'Size', 'Color', 10.00, 100, 10, 'h'),
(31, 'Basketbalhoepel', 'Accessoire', 'Stand', 'Oranje', 60.00, 150, 50, 'h'),
(35, 'Tafeltennisbat', 'Racket', 'Stand', 'Rood', 5.00, 100, 50, 'l'),
(36, 'Schemershirt', 'Kleding', 'M', 'Blauw', 22.50, 155, 50, 'l'),
(39, 'Voetbalschoenen', 'Schoenen', '42', 'Wit/Zwart', 65.00, 10, 50, 'h'),
(42, 'BASEBALL GLOVE', 'SPORT', 'LILA', NULL, 90.00, 0, 50, 'h'),
(47, 'PULL-UP BAR', 'FITNESS', 'ROOD', NULL, 50.00, 0, 50, 'h'),
(50, 'SKEELERS', 'SKATEN', 'ZWART', NULL, 50.00, 200, 50, 'h'),
(52, 'BOXING GLOVES', 'BOXING', 'ROOD', NULL, 150.00, 0, 50, 'h'),
(54, 'HOCKEYSTICK', 'HOCKEY', 'ZWART', NULL, 75.00, 50, 50, 'h'),
(56, 'Boksbandage', 'Accessoire', 'L', 'Rood', 7.50, 24, 50, 'l'),
(61, 'TENNISRACKET', 'RACKET', 'BLAUW', NULL, 300.00, 10, 50, 'h'),
(66, 'Product Name 66', 'Category', 'Size', 'Color', 6.10, 100, 10, 'h'),
(67, 'Potentiometer', 'Electronics', 'Standard', 'Black', 15.00, 50, 5, 'h'),
(68, 'MOUNTAINBIKE', 'FIETS', 'ROOD', NULL, 30.00, 37, 50, 'h'),
(71, 'Sporttape', 'Accessoire', '5m', 'Wit', 2.50, 100, 50, 'l'),
(74, 'SOCCER CLEATS', 'FOOTBALL', 'GEEL', NULL, 400.00, 200, 50, 'h'),
(78, 'Hardloopschoenen', 'Schoenen', '43', 'Blauw', 75.00, 100, 50, 'h'),
(80, 'RUGBYBAL', 'BAL', 'BRUIN', NULL, 200.00, 0, 50, 'l'),
(82, 'WATERFLES', 'SPORT', 'WIT', NULL, 7.00, 0, 50, 'l'),
(87, 'Gewichthefriem', 'Accessoire', 'M', 'Zwart', 12.00, 150, 50, 'l'),
(89, 'LACROSSE STICK', 'SPORT', 'GEMEN', NULL, 100.00, 0, 50, 'l'),
(95, 'JUMPBOOT', 'SPORT', 'LILA', NULL, 70.00, 200, 50, 'l'),
(102, 'Unknown Article 102', 'CategoryX', 'SizeX', 'ColorX', 10.00, 135, 10, 'l'),
(103, 'Basketbalschoenen', 'Schoenen', '45', 'Zwart/Rood', 90.00, 100, 50, 'h'),
(104, 'WIELERHANDSCHOENEN', 'FIETS', 'ZWART', NULL, 400.00, 0, 50, 'l'),
(105, 'Tennisballen (3-pack)', 'Bal', 'Stand', 'Geel', 8.00, 100, 50, 'h'),
(108, 'Voetbal', 'Bal', '5', 'Rood/Zwart', 25.00, 10, 50, 'h'),
(111, 'ICE SKATES', 'SKATING', 'ZWART', NULL, 400.00, 0, 50, 'h'),
(112, 'DUMBBELLS SET', 'WEIGHTS', 'GRIJS', NULL, 350.00, 0, 50, 'h'),
(117, 'JUMP ROPE', 'EXERCISE', '', NULL, 250.00, 0, 50, 'h'),
(120, 'SPORTTAS', 'FITNESS', 'ZWART', NULL, 200.00, 0, 50, 'l'),
(123, 'DUMBELLS', 'WEIGHTS', '', NULL, 500.00, 0, 50, 'h'),
(124, 'GYMNASTICS RINGS', 'GYMNASTICS', '', NULL, 120.00, 0, 50, 'h'),
(126, 'ZWEMBANDEN', 'WATERSPORT', 'GEEL', NULL, 350.00, 100, 50, 'l'),
(127, 'ROLLER SKATES', 'SKATING', 'ZWART', NULL, 120.00, 0, 50, 'h'),
(130, 'Sports Cap', 'Accessories', 'One Size', 'Blue', 15.00, 50, 10, 'l'),
(133, 'FIELD HOCKEY BALL', 'FIELD HOCKEY', 'WIT', NULL, 15.00, 0, 50, 'l'),
(135, 'EQUESTRIAN HELMET', 'EQUESTRIAN', 'ZWART', NULL, 300.00, 0, 50, 'h'),
(137, 'ROLLER SKATES', 'SKATING', 'ROZE', NULL, 150.00, 0, 50, 'l'),
(140, 'VOLLEYBALL NET', 'VOLLEYBALL', 'WIT', NULL, 250.00, 0, 50, 'h'),
(143, 'Badmintonshuttle', 'Accessoire', 'Stand', 'Wit', 1.50, 25, 50, 'l'),
(144, 'CAMPING TENT', 'CAMPING', 'GROEN', NULL, 500.00, 0, 50, 'h'),
(147, 'Resistance Bands (set)', 'Accessoire', 'Stand', 'Multicolor', 10.00, 100, 50, 'l'),
(153, 'SPRINGTOUW', 'FITNESS', 'GROEN', NULL, 200.00, 0, 50, 'l'),
(155, 'MARTIAL ARTS MAT', 'MARTIAL ARTS', 'BLAUW', NULL, 400.00, 0, 50, 'h'),
(157, 'Zwemvliezen', 'Accessoire', 'M', 'Blauw', 25.00, 800, 50, 'h'),
(159, 'TREADMILL', 'FITNESS', 'ZWART', NULL, 2500.00, 0, 50, 'h'),
(162, 'PULL-UP BAR', 'FITNESS', 'ROOD', NULL, 50.00, 0, 50, 'h'),
(163, 'WEIGHTED VEST', 'FITNESS', 'ZWART', NULL, 150.00, 0, 50, 'h'),
(164, 'TENNIS RACKET', 'SPORT', 'WIT', NULL, 70.00, 0, 50, 'l'),
(165, 'DIVE MASK', 'DIVING', 'BLAUW', NULL, 120.00, 0, 50, 'l'),
(167, 'FRISBEE', 'OUTDOOR', 'ROOD', NULL, 25.00, 0, 50, 'l'),
(169, 'TENNISTAS', 'TENNIS', 'BLAUW', NULL, 120.00, 0, 50, 'h'),
(170, 'GOLF CLUB', 'SPORT', 'ZWART', NULL, 100.00, 0, 50, 'h'),
(172, 'TABLE TENNIS PADDLE', 'TABLE TENNIS', 'ROOD', NULL, 45.00, 0, 50, 'l'),
(175, 'TENNIS RACKET', 'SPORT', 'WIT', NULL, 70.00, 0, 50, 'l'),
(178, 'Product Name 178', 'Category', 'Size', 'Color', 3.40, 100, 10, 'h'),
(180, 'LOOPBAND', 'FITNESS', 'ZWART', NULL, 20.00, 0, 50, 'h'),
(184, 'RUGBY BALL', 'SPORT', 'BLAUW', NULL, 50.00, 0, 50, 'l'),
(190, 'WATERFLES', 'SPORT', 'WIT', NULL, 7.00, 0, 50, 'l'),
(193, 'CUE STICK', 'BILLIARDS', 'BRUIN', NULL, 180.00, 0, 50, 'h'),
(195, 'DUIKBRIL', 'ZWEMMEN', 'ZWART', NULL, 300.00, 0, 50, 'l'),
(197, 'BILLIARD BALLS SET', 'BILLIARDS', 'MULTI', NULL, 200.00, 0, 50, 'l'),
(200, 'FIETSBAND', 'FIETS', 'ZWART', NULL, 100.00, 0, 50, 'l'),
(203, 'DIVING FINS', 'DIVING', 'BLAUW', NULL, 100.00, 0, 50, 'l'),
(205, 'FLUITJE', 'VOETBAL', 'GROEN', NULL, 500.00, 0, 50, 'l'),
(207, 'RESISTANCE BAND', 'FITNESS', 'GEMEN', NULL, 50.00, 0, 50, 'l'),
(209, 'VOETBAL', 'BAL', 'Size', 'Color', 0.00, 3, 10, 'h'),
(210, 'YOGABAL', 'YOGA', 'PAARS', NULL, 120.00, 0, 50, 'l'),
(211, 'SWIMMING GOGGLES', 'SWIMMING', 'BLAUW', NULL, 75.00, 0, 50, 'l'),
(212, 'BASEBALL GLOVE', 'SPORT', 'LILA', NULL, 90.00, 0, 50, 'h'),
(214, 'JAVELIN', 'TRACK AND FIELD', '', NULL, 150.00, 0, 50, 'h'),
(215, 'ICE HOCKEY STICK', 'ICE HOCKEY', 'ZWART', NULL, 180.00, 0, 50, 'h'),
(218, 'ARCHERY TARGET', 'ARCHERY', '', NULL, 300.00, 0, 50, 'l'),
(220, 'CLIMBING HARNESS', 'CLIMBING', '', NULL, 175.00, 0, 50, 'h'),
(224, 'Sportsokken', 'Kleding', 'M', 'Zwart', 5.00, 100, 50, 'l'),
(225, 'SKIPPING ROPE', 'FITNESS', 'ROOD', NULL, 75.00, 0, 50, 'l'),
(228, 'Springtouw', 'Fitness', '2.5m', 'Rood', 8.00, 10, 50, 'l'),
(232, 'FENCING MASK', 'FENCING', 'ZWART', NULL, 180.00, 0, 50, 'h'),
(234, 'ZWEMBAD', 'WATERSPORT', 'BLAUW', NULL, 25.00, 0, 50, 'h'),
(237, 'PICKLEBALL PADDLE', 'PICKLEBALL', 'BLAUW', NULL, 50.00, 0, 50, 'l'),
(239, 'BOWLING BALL', 'BOWLING', 'ZWART', NULL, 100.00, 0, 50, 'l'),
(242, 'Water Bottle', 'Hydration', '500ml', 'Transparent', 5.00, 200, 50, 'l'),
(245, 'ARCHERY GLOVES', 'ARCHERY', 'BRUIN', NULL, 75.00, 0, 50, 'l'),
(253, 'Golfbal', 'Bal', 'Stand', 'Wit', 1.25, 100, 50, 'l'),
(255, 'BASKETBAL', 'Bal', 'Size', 'Color', 0.00, 0, 10, 'h'),
(257, 'BALANSBOARD', 'Fitness', 'Standard', 'Black', 15.00, 50, 5, 'h'),
(258, 'BICYCLE HELMET', 'CYCLING', 'BLAUW', NULL, 80.00, 0, 50, 'l'),
(260, 'HIKING SHOES', 'HIKING', 'BRUIN', NULL, 400.00, 0, 50, 'h'),
(261, 'MMA GLOVES', 'MARTIAL ARTS', 'ZWART', NULL, 65.00, 0, 50, 'l'),
(262, 'HULAHOEP', 'Fitness', 'Size', 'Color', 10.00, 0, 10, 'h'),
(263, 'Kettlebell', 'Fitness', '10kg', 'Zwart', 35.00, 100, 50, 'h'),
(266, 'MOUNTAINBIKE', 'FIETS', 'ROOD', NULL, 30.00, 0, 50, 'h'),
(269, 'JUMP ROPE', 'FITNESS', 'GEEL', NULL, 15.00, 0, 50, 'l'),
(273, 'BEACH VOLLEYBALL', 'VOLLEYBALL', 'GEEL', NULL, 30.00, 0, 50, 'l'),
(274, 'KARATE UNIFORM', 'MARTIAL ARTS', 'WIT', NULL, 120.00, 0, 50, 'l'),
(276, 'ROLLERBLADES', 'SKATING', 'ZWART', NULL, 275.00, 0, 50, 'h'),
(281, 'Product Name 281', 'Category', 'Size', 'Color', 0.00, 0, 10, 'h'),
(282, 'HIKING BACKPACK', 'HIKING', 'GROEN', NULL, 500.00, 0, 50, 'h'),
(283, 'RUGBY BALL', 'SPORT', 'BLAUW', NULL, 50.00, 0, 50, 'l'),
(285, 'VOETBALDOEL', 'VOETBAL', 'WIT', NULL, 10.00, 0, 50, 'h'),
(286, 'Mountain Bike Helmet', 'Cycling', 'M', 'Red', 75.00, 30, 5, 'h'),
(289, 'YOGA MAT', 'YOGA', 'GROEN', NULL, 45.00, 0, 50, 'l'),
(291, 'DARTBOARD', 'DARTS', '', NULL, 125.00, 0, 50, 'l'),
(292, 'PARALLEL BARS', 'GYMNASTICS', '', NULL, 1500.00, 0, 50, 'h'),
(294, 'HORSE SADDLE', 'EQUESTRIAN', 'BRUIN', NULL, 800.00, 0, 50, 'h'),
(296, 'GIPSKRUIS', 'SPORT', 'WIT', NULL, 50.00, 0, 50, 'l'),
(297, 'Sports Gloves', 'Accessories', 'L', 'Black', 25.00, 100, 20, 'l'),
(298, 'ARCHERY BOW', 'ARCHERY', 'ZWART', NULL, 550.00, 0, 50, 'h'),
(300, 'EXERCISE MAT', 'YOGA', '', NULL, 50.00, 0, 50, 'l'),
(302, 'FITNESS TOWEL', 'FITNESS', 'WIT', NULL, 25.00, 0, 50, 'l'),
(306, 'MOUNTAIN BIKE', 'CYCLING', 'ZWART', NULL, 3500.00, 0, 50, 'h'),
(307, 'FOOTBALL GLOVES', 'FOOTBALL', 'ZWART', NULL, 90.00, 0, 50, 'l'),
(308, 'SCUBA WETSUIT', 'DIVING', 'ZWART', NULL, 300.00, 0, 50, 'h'),
(309, 'SLEDGE HAMMER', 'FITNESS', 'ZWART', NULL, 100.00, 0, 50, 'h'),
(311, 'Trampoline', 'Accessoire', '2m', 'Groen', 200.00, 150, 50, 'h'),
(312, 'SPORT DRINK BOTTLE', 'HYDRATION', 'GEEL', NULL, 200.00, 0, 50, 'l'),
(314, 'TENNISBAL', 'Category', 'Size', 'Color', 10.00, 250, 10, 'h'),
(315, 'BASEBALL CAP', 'BASEBALL', 'BLAUW', NULL, 25.00, 0, 50, 'l'),
(316, 'LACROSSE STICK', 'SPORT', 'GEMEN', NULL, 100.00, 0, 50, 'l'),
(319, 'Voetbalhandschoenen', 'Accessoire', 'Stand', 'Zwart', 12.50, 100, 50, 'l'),
(320, 'SWIM GOGGLES', 'SWIMMING', 'WIT', NULL, 300.00, 0, 50, 'l'),
(327, 'HEADELASTIC', 'TRAINING', 'GEMEN', NULL, 30.00, 0, 50, 'l'),
(332, 'GOLF CLUB', 'SPORT', 'ZWART', NULL, 100.00, 0, 50, 'h'),
(334, 'RUNNING TIGHTS', 'RUNNING', 'ZWART', NULL, 80.00, 0, 50, 'l'),
(335, 'FOOTBALL', 'BAL', 'ROZE', NULL, 150.00, 0, 50, 'l'),
(341, 'FIELD HOCKEY STICK', 'FIELD HOCKEY', 'BRUIN', NULL, 130.00, 0, 50, 'h'),
(345, 'BOWLING PINS SET', 'BOWLING', 'WIT', NULL, 120.00, 0, 50, 'l'),
(348, 'TENNIS SHIRT', 'TENNIS', 'WIT', NULL, 100.00, 0, 50, 'l'),
(350, 'JUDO UNIFORM', 'MARTIAL ARTS', 'WIT', NULL, 100.00, 0, 50, 'l'),
(351, 'Yoga Mat', 'Yoga', 'Standard', 'Purple', 20.00, 150, 30, 'l'),
(354, 'SKI GOGGLES', 'SKIING', 'GRIJS', NULL, 120.00, 0, 50, 'l'),
(355, 'Product Name 355', 'Category', 'Size', 'Color', 1.05, 100, 10, 'h'),
(361, 'RESISTANCE BAND', 'FITNESS', 'GEMEN', NULL, 50.00, 0, 50, 'l'),
(362, 'Yoga Block', '23x15', 'Paars', NULL, 10.00, 40, 50, 'l'),
(363, 'SUPBOARD', 'WATERSPORT', 'BLAUW', NULL, 30.00, 0, 50, 'h'),
(364, 'HARTSLAGMETER', 'FITNESS', 'ZWART', NULL, 150.00, 0, 50, 'l'),
(365, 'TREADMILL', 'FITNESS', '', NULL, 30.00, 785, 50, 'l'),
(367, 'BASKETBALL HOOP', 'SPORT', 'GROEN', NULL, 50.00, 0, 50, 'h'),
(369, 'WEIGHT LIFTING BELT', 'FITNESS', 'ZWART', NULL, 75.00, 0, 50, 'l'),
(371, 'SCUBA TANK', 'DIVING', '', NULL, 800.00, 0, 50, 'h'),
(372, 'HEADELASTIC', 'TRAINING', 'GEMEN', NULL, 30.00, 0, 50, 'l'),
(374, 'TENNIS BALLS', 'TENNIS', 'GEEL', NULL, 10.00, 0, 50, 'l'),
(378, 'SOCCER GOAL NET', 'FOOTBALL', 'WIT', NULL, 250.00, 0, 50, 'h'),
(380, 'Squashbal', 'Bal', 'Stand', 'Blauw', 2.00, 125, 50, 'l'),
(383, 'FITNESSMAT', 'FITNESS', 'GROEN', NULL, 75.00, 0, 50, 'l'),
(384, 'Springtouw', 'Fitness', '3m', 'Rood', 7.50, 100, 50, 'l'),
(386, 'PULL BUOY', 'SWIMMING', 'BLAUW', NULL, 45.00, 0, 50, 'l'),
(387, 'SQUASH RACKET', 'SQUASH', 'ZWART', NULL, 90.00, 0, 50, 'l'),
(388, 'BALLET LEOTARD', 'DANCE', 'ZWART', NULL, 50.00, 0, 50, 'l'),
(390, 'PINGPONGBAL', 'TAFELTENNIS', 'WIT', NULL, 1000.00, 0, 50, 'l'),
(391, 'Hockeybal', 'Bal', 'Stand', 'Geel', 5.50, 10, 50, 'h'),
(394, 'TREADMILL', 'FITNESS', '', NULL, 30.00, 0, 50, 'l'),
(397, 'SPORT DRINK BOTTLE', 'Category', 'Size', 'Color', 20.00, 35, 10, 'l'),
(398, 'Tennisracket', 'Racket', 'Stand', 'Zwart', 45.00, 10, 50, 'h'),
(399, 'WEIGHT BENCH', 'FITNESS', 'ZWART', NULL, 700.00, 0, 50, 'h'),
(401, 'FOLDING BIKE', 'CYCLING', 'ZWART', NULL, 2500.00, 0, 50, 'l'),
(408, 'FIETSHELM', 'FIETS', 'BLAUW', NULL, 175.00, 0, 50, 'h'),
(410, 'BALLET SHOES', 'DANCE', 'ROZE', NULL, 80.00, 0, 50, 'l'),
(419, 'SWIMMING CAP', 'SWIMMING', 'BLAUW', NULL, 30.00, 0, 50, 'l'),
(420, 'TENNIS BALLS', 'Category', 'Size', 'Color', 0.00, 0, 10, 'h'),
(421, 'RUNNING WATER BOTTLE', 'RUNNING', 'GRIJS', NULL, 20.00, 0, 50, 'l'),
(422, 'Tennissokken', 'Kleding', 'M', 'Wit', 3.50, 125, 50, 'l'),
(425, 'BADMINTONRACKET', 'RACKET', 'ROOD', NULL, 85.00, 7, 50, 'l'),
(426, 'Fitnessmat', 'Fitness', '180x6', 'Blauw', 15.00, 500, 50, 'l'),
(427, 'EXERCISE MAT', 'YOGA', '', NULL, 50.00, 0, 50, 'l'),
(428, 'SWIM GOGGLES', 'SWIMMING', 'WIT', NULL, 300.00, 0, 50, 'l'),
(432, 'BALANCE TRAINER', 'FITNESS', 'BLAUW', NULL, 200.00, 0, 50, 'h'),
(433, 'SPEED LADDER', 'FITNESS', 'GEEL', NULL, 50.00, 0, 50, 'l'),
(434, 'Basketbal', 'Bal', '7', 'Oranje', 28.00, 50, 50, 'h'),
(437, 'Product Name 437', 'Category', 'Size', 'Color', 1.30, 100, 10, 'h'),
(438, 'Voetbalshirt', 'Kleding', 'L', 'Rood', 30.00, 100, 50, 'h'),
(441, 'WRESTLING SHOES', 'WRESTLING', 'ROOD', NULL, 250.00, 0, 50, 'h'),
(450, 'BOXING BAG', 'BOXING', '', NULL, 600.00, 0, 50, 'h'),
(452, 'INLINE SKATES', 'SKATING', 'ZWART', NULL, 300.00, 0, 50, 'h'),
(453, 'FENCING FOIL', 'FENCING', 'GRIJS', NULL, 180.00, 0, 50, 'h'),
(455, 'Handbal', 'Bal', 'Stand', 'Gemengd', 20.00, 300, 50, 'h'),
(457, 'KITESURF BOARD', 'KITESURFING', 'BLAUW', NULL, 750.00, 0, 50, 'h'),
(458, 'BASEBALL MITT', 'BASEBALL', 'BRUIN', NULL, 150.00, 0, 50, 'h'),
(462, 'TENNIS BALLS', 'Category', 'Size', 'Color', 1.25, 0, 40, 'h'),
(466, 'BIKE LOCK', 'CYCLING', 'ZWART', NULL, 40.00, 0, 50, 'l'),
(467, 'Sports T-shirt', 'Kleding', 'L', 'Geel', 20.00, 300, 50, 'l'),
(468, 'BOKSHANDSCHOENEN', 'BOKSEN', 'ROOD', NULL, 150.00, 100, 50, 'h'),
(469, 'FOOTBALL', 'BAL', 'ROZE', NULL, 150.00, 0, 50, 'l'),
(470, 'GIPSKRUIS', 'SPORT', 'WIT', NULL, 50.00, 115, 50, 'l'),
(471, 'SOCCER CLEATS', 'FOOTBALL', 'GEEL', NULL, 400.00, 0, 50, 'h'),
(477, 'BADMINTON NET', 'BADMINTON', 'WIT', NULL, 150.00, 0, 50, 'l'),
(478, 'Dumbbell', 'Fitness', '5kg', 'Zwart', 15.00, 171, 50, 'h'),
(481, 'SURFBOARD', 'SURFING', 'WIT', NULL, 600.00, 0, 50, 'h'),
(486, 'BIKE HELMET', 'CYCLING', 'ROOD', NULL, 120.00, 0, 50, 'l'),
(489, 'ROWING MACHINE', 'FITNESS', 'GRIJS', NULL, 1500.00, 0, 50, 'h'),
(493, 'TRIATHLON WETSUIT', 'Running', 'Size', 'Color', 30.00, 0, 40, 'l'),
(497, 'PULL-UP BAR', 'FITNESS', 'ZWART', NULL, 120.00, 0, 50, 'l'),
(498, 'JUMP ROPE', 'EXERCISE', '', NULL, 250.00, 0, 50, 'h');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE IF NOT EXISTS `suppliers` (
  `supplier_code` int(11) NOT NULL,
  `supplier_name` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`supplier_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `suppliers`;

INSERT INTO `suppliers` (`supplier_code`, `supplier_name`, `address`, `city`) VALUES
(4, 'SPORT SHOP HOVENIER G.H.', 'SPORT AVENUE 50', 'ATHLETICAM'),
(9, 'BAUMGARTEN RACING TEAM', 'VELOCE STREET 13', 'CYCLANDIA'),
(11, 'STRUIK SPORT BV.', 'BASKET ROAD 1', 'DUNKCITY'),
(13, 'SPITMAN SPORT AND SONS', 'ATHLETICS AVENUE 9', 'RUNNERSVILLE'),
(14, 'DEZAAIER LEISURE J.A.', 'RECREATION ROAD 101', 'SPORTHAVEN'),
(19, 'MOOIWEER FITNESS CO.', 'KRAFT STREET 24', 'FITVILLAGE'),
(20, 'BLOEM LEISURE Z.H.W.', 'SPORT PARK LINNEAUSHOF 17', 'HILLEGYM'),
(21, 'TRA SPORT A.', 'FITNESS PLACE STREET 10', 'LISSEREN'),
(22, 'ERICA SPORT BV.', 'BALL ROAD 87', 'HEEMFIT'),
(34, 'DE GROENE KAS FITNESS BV.', 'SPORTGLASS ROAD 1', 'FITLAND'),
(35, 'FLORA SPORT BV.', 'PRACTICE STREET 76', 'AALSPORT');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `vat`
--

DROP TABLE IF EXISTS `vat`;
CREATE TABLE IF NOT EXISTS `vat` (
  `type` char(1) NOT NULL,
  `description` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `vat`;

INSERT INTO `vat` (`type`, `description`) VALUES
('h', 'VAT High'),
('l', 'VAT Low'),
('n', 'VAT Zero'),
('v', 'VAT Shifted');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `vat_percentage`
--

DROP TABLE IF EXISTS `vat_percentage`;
CREATE TABLE IF NOT EXISTS `vat_percentage` (
  `type` char(1) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date DEFAULT NULL,
  `percent` decimal(5,3) DEFAULT NULL,
  PRIMARY KEY (`type`,`from_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


TRUNCATE TABLE `vat_percentage`;

INSERT INTO `vat_percentage` (`type`, `from_date`, `to_date`, `percent`) VALUES
('h', '1992-01-01', '1998-01-01', 19.000),
('h', '1998-01-02', NULL, 18.500),
('l', '1975-01-01', '1998-01-01', 4.500),
('l', '1998-01-02', NULL, 6.000);

ALTER TABLE `booking`
  ADD CONSTRAINT `fk_booking_customer` FOREIGN KEY (`customer_code`) REFERENCES `customers` (`customer_code`),
  ADD CONSTRAINT `fk_booking_supplier` FOREIGN KEY (`supplier_code`) REFERENCES `suppliers` (`supplier_code`);

ALTER TABLE `booking_line`
  ADD CONSTRAINT `fk_booking_line_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles` (`article_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_line_booking` FOREIGN KEY (`booking_number`) REFERENCES `booking` (`booking_number`),
  ADD CONSTRAINT `fk_booking_line_order` FOREIGN KEY (`order_number`) REFERENCES `orders` (`order_number`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `delivery`
  ADD CONSTRAINT `fk_delivery_invoice` FOREIGN KEY (`invoice_number`) REFERENCES `invoice` (`invoice_number`),
  ADD CONSTRAINT `fk_delivery_purchase_line` FOREIGN KEY (`purchase_number`,`article_code`) REFERENCES `purchase_line` (`purchase_number`, `article_code`);

ALTER TABLE `goods_receipt`
  ADD CONSTRAINT `goods_receipt_ibfk_1` FOREIGN KEY (`booking_number`,`sequence_number`) REFERENCES `booking_line` (`booking_number`, `sequence_number`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `invoice`
  ADD CONSTRAINT `fk_invoice_booking_line` FOREIGN KEY (`booking_number`,`sequence_number`) REFERENCES `booking_line` (`booking_number`, `sequence_number`);

ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_suppliers` FOREIGN KEY (`supplier_code`) REFERENCES `suppliers` (`supplier_code`);

ALTER TABLE `order_lines`
  ADD CONSTRAINT `fk_order_lines_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles` (`article_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_lines_orders` FOREIGN KEY (`order_number`) REFERENCES `orders` (`order_number`);

ALTER TABLE `purchases`
  ADD CONSTRAINT `fk_purchases_customers` FOREIGN KEY (`customer_code`) REFERENCES `customers` (`customer_code`);

ALTER TABLE `purchase_line`
  ADD CONSTRAINT `fk_purchase_line_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles` (`article_code`),
  ADD CONSTRAINT `fk_purchase_line_purchase` FOREIGN KEY (`purchase_number`) REFERENCES `purchases` (`purchase_number`);


ALTER TABLE `quotations`
  ADD CONSTRAINT `fk_quotations_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles` (`article_code`);

ALTER TABLE `sports_articles`
  ADD CONSTRAINT `fk_sports_articles_vat` FOREIGN KEY (`VAT_type`) REFERENCES `vat` (`type`);


ALTER TABLE `vat_percentage`
  ADD CONSTRAINT `fk_vat_percentage_vat` FOREIGN KEY (`type`) REFERENCES `vat` (`type`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

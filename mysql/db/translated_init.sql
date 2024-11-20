-- --------------------------------------------------------
-- Database: `QAsportarticles`
-- --------------------------------------------------------

-- Drop the database if it exists and create a new one
DROP DATABASE IF EXISTS `QAsportarticles1`;
CREATE DATABASE `QAsportarticles1`;
USE `QAsportarticles1`;

-- --------------------------------------------------------
-- Table structure for table `customers`
-- --------------------------------------------------------

CREATE TABLE `customers` (
    `customer_code` INT PRIMARY KEY,
    `customer_name` VARCHAR(50),
    `address` VARCHAR(50),
    `postal_code` VARCHAR(10),
    `phone` VARCHAR(15),
    `city` VARCHAR(30),
    `status` CHAR(1),
    `credit_limit` DECIMAL(10, 2),
    `balance` DECIMAL(10, 2)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `customers`
INSERT INTO `customers` (`customer_code`, `customer_name`, `address`, `postal_code`, `phone`, `city`, `status`, `credit_limit`, `balance`) VALUES
(100, 'QA Football Articles', 'Football Street 1', '2492 VJ', '012-3456789', 'The Hague', 'A', 1000.00, 0.00),
(101, 'QA Tennis Articles', 'Tennis Street 1', '3078 ZD', '032-1987654', 'Rotterdam', 'A', 1000.00, 0.00),
(102, 'QA General Sports Articles', 'Sport Avenue 1', '9728 JT', '045-6123789', 'Groningen', 'A', 1000.00, 0.00),
(103, 'QA Fitness Articles', 'Sport Street 1', '1076 TW', '089-7654321', 'Amsterdam', 'A', 1000.00, 0.00);

-- --------------------------------------------------------
-- Table structure for table `suppliers`
-- --------------------------------------------------------

CREATE TABLE `suppliers` (
    `supplier_code` INT PRIMARY KEY,
    `supplier_name` VARCHAR(50),
    `address` VARCHAR(50),
    `city` VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `suppliers`
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
-- Table structure for table `sports_articles`
-- --------------------------------------------------------

CREATE TABLE `sports_articles` (
  `article_code` INT(4) NOT NULL AUTO_INCREMENT,
  `article_name` VARCHAR(30) NOT NULL,
  `category` VARCHAR(15) DEFAULT NULL,
  `size` VARCHAR(5) DEFAULT NULL,
  `color` VARCHAR(20) DEFAULT NULL,
  `price` DECIMAL(6,2) DEFAULT NULL,
  `stock_quantity` INT(11) NOT NULL DEFAULT 0,
  `stock_min` INT(11) NOT NULL DEFAULT 0,
  `VAT_type` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`article_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `sports_articles`

INSERT INTO `sports_articles` (`article_code`, `article_name`, `category`, `size`, `color`, `price`, `stock_quantity`, `stock_min`, `VAT_type`) VALUES
(1, 'FOOTBALL GOAL', 'SPORT', 'ORANJ', NULL, 300.00, 0, 50, 'l'),
(2, 'BOXING BAG', 'BOXING', '', NULL, 600.00, 0, 50, 'h'),
(12, 'KNEE PADS', 'PROTECTION', 'BLAUW', NULL, 75.00, 0, 50, 'l'),
(13, 'KNEE PADS', 'PROTECTION', 'BLAUW', NULL, 75.00, 0, 50, 'l'),
(14, 'SURFBOARD', 'WATERSPORT', 'BLAUW', NULL, 450.00, 0, 50, 'h'),
(19, 'BIKE HELMET', 'CYCLING', 'ROOD', NULL, 120.00, 0, 50, 'l'),
(23, 'VOETBALSCHOENEN', 'VOETBAL', 'ZWART', NULL, 500.00, 0, 50, 'h'),
(24, 'GOLFTAS', 'GOLF', 'ZWART', NULL, 50.00, 0, 50, 'h'),
(27, 'Goal', 'Accessoire', 'Stand', 'Wit', 180.00, 100, 50, 'h'),
(31, 'Basketbalhoepel', 'Accessoire', 'Stand', 'Oranje', 60.00, 100, 50, 'h'),
(35, 'Tafeltennisbat', 'Racket', 'Stand', 'Rood', 5.00, 100, 50, 'l'),
(36, 'Schemershirt', 'Kleding', 'M', 'Blauw', 22.50, 100, 50, 'l'),
(39, 'Voetbalschoenen', 'Schoenen', '42', 'Wit/Zwart', 65.00, 10, 50, 'h'),
(42, 'BASEBALL GLOVE', 'SPORT', 'LILA', NULL, 90.00, 0, 50, 'h'),
(47, 'PULL-UP BAR', 'FITNESS', 'ROOD', NULL, 50.00, 0, 50, 'h'),
(50, 'SKEELERS', 'SKATEN', 'ZWART', NULL, 50.00, 6, 50, 'h'),
(52, 'BOXING GLOVES', 'BOXING', 'ROOD', NULL, 150.00, 0, 50, 'h'),
(54, 'HOCKEYSTICK', 'HOCKEY', 'ZWART', NULL, 75.00, 0, 50, 'h'),
(56, 'Boksbandage', 'Accessoire', 'L', 'Rood', 7.50, 10, 50, 'l'),
(61, 'TENNISRACKET', 'RACKET', 'BLAUW', NULL, 300.00, 10, 50, 'h'),
(66, 'DUMBELLS', 'WEIGHTS', '', NULL, 500.00, 0, 50, 'h'),
(68, 'MOUNTAINBIKE', 'FIETS', 'ROOD', NULL, 30.00, 0, 50, 'h'),
(71, 'Sporttape', 'Accessoire', '5m', 'Wit', 2.50, 100, 50, 'l'),
(74, 'SOCCER CLEATS', 'FOOTBALL', 'GEEL', NULL, 400.00, 0, 50, 'h'),
(78, 'Hardloopschoenen', 'Schoenen', '43', 'Blauw', 75.00, 100, 50, 'h'),
(80, 'RUGBYBAL', 'BAL', 'BRUIN', NULL, 200.00, 0, 50, 'l'),
(82, 'WATERFLES', 'SPORT', 'WIT', NULL, 7.00, 0, 50, 'l'),
(87, 'Gewichthefriem', 'Accessoire', 'M', 'Zwart', 12.00, 100, 50, 'l'),
(89, 'LACROSSE STICK', 'SPORT', 'GEMEN', NULL, 100.00, 0, 50, 'l'),
(95, 'JUMPBOOT', 'SPORT', 'LILA', NULL, 70.00, 0, 50, 'l'),
(102, 'JUMPBOOT', 'SPORT', 'LILA', NULL, 70.00, 0, 50, 'l'),
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
(126, 'ZWEMBANDEN', 'WATERSPORT', 'GEEL', NULL, 350.00, 0, 50, 'l'),
(127, 'ROLLER SKATES', 'SKATING', 'ZWART', NULL, 120.00, 0, 50, 'h'),
(130, 'ZWEMVLINDERS', 'WATERSPORT', 'GROEN', NULL, 300.00, 0, 50, 'l'),
(133, 'FIELD HOCKEY BALL', 'FIELD HOCKEY', 'WIT', NULL, 15.00, 0, 50, 'l'),
(135, 'EQUESTRIAN HELMET', 'EQUESTRIAN', 'ZWART', NULL, 300.00, 0, 50, 'h'),
(137, 'ROLLER SKATES', 'SKATING', 'ROZE', NULL, 150.00, 0, 50, 'l'),
(140, 'VOLLEYBALL NET', 'VOLLEYBALL', 'WIT', NULL, 250.00, 0, 50, 'h'),
(143, 'Badmintonshuttle', 'Accessoire', 'Stand', 'Wit', 1.50, 10, 50, 'l'),
(144, 'CAMPING TENT', 'CAMPING', 'GROEN', NULL, 500.00, 0, 50, 'h'),
(147, 'Resistance Bands (set)', 'Accessoire', 'Stand', 'Multicolor', 10.00, 100, 50, 'l'),
(153, 'SPRINGTOUW', 'FITNESS', 'GROEN', NULL, 200.00, 0, 50, 'l'),
(155, 'MARTIAL ARTS MAT', 'MARTIAL ARTS', 'BLAUW', NULL, 400.00, 0, 50, 'h'),
(157, 'Zwemvliezen', 'Accessoire', 'M', 'Blauw', 25.00, 100, 50, 'h'),
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
(178, 'SNOOKERSTOK', 'SNOOKER', 'BRUIN', NULL, 75.00, 0, 50, 'h'),
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
(209, 'VOETBAL', 'BAL', 'ZWART', NULL, 450.00, 10, 50, 'h'),
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
(242, 'FOOTBALL GOAL', 'SPORT', 'ORANJ', NULL, 300.00, 0, 50, 'l'),
(245, 'ARCHERY GLOVES', 'ARCHERY', 'BRUIN', NULL, 75.00, 0, 50, 'l'),
(253, 'Golfbal', 'Bal', 'Stand', 'Wit', 1.25, 100, 50, 'l'),
(255, 'BASKETBAL', 'BAL', 'ORANJ', NULL, 300.00, 0, 50, 'l'),
(257, 'BALANSBOARD', 'FITNESS', 'ZWART', NULL, 75.00, 0, 50, 'h'),
(258, 'BICYCLE HELMET', 'CYCLING', 'BLAUW', NULL, 80.00, 0, 50, 'l'),
(260, 'HIKING SHOES', 'HIKING', 'BRUIN', NULL, 400.00, 0, 50, 'h'),
(261, 'MMA GLOVES', 'MARTIAL ARTS', 'ZWART', NULL, 65.00, 0, 50, 'l'),
(262, 'HULAHOEP', 'FITNESS', 'ROOD', NULL, 125.00, 0, 50, 'l'),
(263, 'Kettlebell', 'Fitness', '10kg', 'Zwart', 35.00, 100, 50, 'h'),
(266, 'MOUNTAINBIKE', 'FIETS', 'ROOD', NULL, 30.00, 0, 50, 'h'),
(269, 'JUMP ROPE', 'FITNESS', 'GEEL', NULL, 15.00, 0, 50, 'l'),
(273, 'BEACH VOLLEYBALL', 'VOLLEYBALL', 'GEEL', NULL, 30.00, 0, 50, 'l'),
(274, 'KARATE UNIFORM', 'MARTIAL ARTS', 'WIT', NULL, 120.00, 0, 50, 'l'),
(276, 'ROLLERBLADES', 'SKATING', 'ZWART', NULL, 275.00, 0, 50, 'h'),
(281, 'Yoga mat', 'Fitness', '180x6', 'Groen', 20.00, 100, 50, 'l'),
(282, 'HIKING BACKPACK', 'HIKING', 'GROEN', NULL, 500.00, 0, 50, 'h'),
(283, 'RUGBY BALL', 'SPORT', 'BLAUW', NULL, 50.00, 0, 50, 'l'),
(285, 'VOETBALDOEL', 'VOETBAL', 'WIT', NULL, 10.00, 0, 50, 'h'),
(286, 'Hometrainer', 'Fitness', 'Stand', 'Zwart', 250.00, 100, 50, 'h'),
(289, 'YOGA MAT', 'YOGA', 'GROEN', NULL, 45.00, 0, 50, 'l'),
(291, 'DARTBOARD', 'DARTS', '', NULL, 125.00, 0, 50, 'l'),
(292, 'PARALLEL BARS', 'GYMNASTICS', '', NULL, 1500.00, 0, 50, 'h'),
(294, 'HORSE SADDLE', 'EQUESTRIAN', 'BRUIN', NULL, 800.00, 0, 50, 'h'),
(296, 'GIPSKRUIS', 'SPORT', 'WIT', NULL, 50.00, 0, 50, 'l'),
(297, 'HANDSCHOENEN', 'VOETBAL', 'ZWART', NULL, 175.00, 0, 50, 'l'),
(298, 'ARCHERY BOW', 'ARCHERY', 'ZWART', NULL, 550.00, 0, 50, 'h'),
(300, 'EXERCISE MAT', 'YOGA', '', NULL, 50.00, 0, 50, 'l'),
(302, 'FITNESS TOWEL', 'FITNESS', 'WIT', NULL, 25.00, 0, 50, 'l'),
(306, 'MOUNTAIN BIKE', 'CYCLING', 'ZWART', NULL, 3500.00, 0, 50, 'h'),
(307, 'FOOTBALL GLOVES', 'FOOTBALL', 'ZWART', NULL, 90.00, 0, 50, 'l'),
(308, 'SCUBA WETSUIT', 'DIVING', 'ZWART', NULL, 300.00, 0, 50, 'h'),
(309, 'SLEDGE HAMMER', 'FITNESS', 'ZWART', NULL, 100.00, 0, 50, 'h'),
(311, 'Trampoline', 'Accessoire', '2m', 'Groen', 200.00, 100, 50, 'h'),
(312, 'SPORT DRINK BOTTLE', 'HYDRATION', 'GEEL', NULL, 200.00, 0, 50, 'l'),
(314, 'TENNISBAL', 'TENIS', 'GEEL', NULL, 500.00, 0, 50, 'l'),
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
(351, 'YOGAMAT', 'YOGA', 'ROZE', NULL, 250.00, 0, 50, 'l'),
(354, 'SKI GOGGLES', 'SKIING', 'GRIJS', NULL, 120.00, 0, 50, 'l'),
(361, 'RESISTANCE BAND', 'FITNESS', 'GEMEN', NULL, 50.00, 0, 50, 'l'),
(362, 'Yoga Block', 'Fitness', '23x15', 'Paars', 10.00, 10, 50, 'l'),
(363, 'SUPBOARD', 'WATERSPORT', 'BLAUW', NULL, 30.00, 0, 50, 'h'),
(364, 'HARTSLAGMETER', 'FITNESS', 'ZWART', NULL, 150.00, 0, 50, 'l'),
(365, 'TREADMILL', 'FITNESS', '', NULL, 30.00, 0, 50, 'l'),
(367, 'BASKETBALL HOOP', 'SPORT', 'GROEN', NULL, 50.00, 0, 50, 'h'),
(369, 'WEIGHT LIFTING BELT', 'FITNESS', 'ZWART', NULL, 75.00, 0, 50, 'l'),
(371, 'SCUBA TANK', 'DIVING', '', NULL, 800.00, 0, 50, 'h'),
(372, 'HEADELASTIC', 'TRAINING', 'GEMEN', NULL, 30.00, 0, 50, 'l'),
(374, 'TENNIS BALLS', 'TENNIS', 'GEEL', NULL, 10.00, 0, 50, 'l'),
(378, 'SOCCER GOAL NET', 'FOOTBALL', 'WIT', NULL, 250.00, 0, 50, 'h'),
(380, 'Squashbal', 'Bal', 'Stand', 'Blauw', 2.00, 10, 50, 'l'),
(383, 'FITNESSMAT', 'FITNESS', 'GROEN', NULL, 75.00, 0, 50, 'l'),
(384, 'Springtouw', 'Fitness', '3m', 'Rood', 7.50, 100, 50, 'l'),
(386, 'PULL BUOY', 'SWIMMING', 'BLAUW', NULL, 45.00, 0, 50, 'l'),
(387, 'SQUASH RACKET', 'SQUASH', 'ZWART', NULL, 90.00, 0, 50, 'l'),
(388, 'BALLET LEOTARD', 'DANCE', 'ZWART', NULL, 50.00, 0, 50, 'l'),
(390, 'PINGPONGBAL', 'TAFELTENNIS', 'WIT', NULL, 1000.00, 0, 50, 'l'),
(391, 'Hockeybal', 'Bal', 'Stand', 'Geel', 5.50, 10, 50, 'h'),
(394, 'TREADMILL', 'FITNESS', '', NULL, 30.00, 0, 50, 'l'),
(397, 'SPORT DRINK BOTTLE', 'HYDRATION', 'GEEL', NULL, 200.00, 0, 50, 'l'),
(398, 'Tennisracket', 'Racket', 'Stand', 'Zwart', 45.00, 10, 50, 'h'),
(399, 'WEIGHT BENCH', 'FITNESS', 'ZWART', NULL, 700.00, 0, 50, 'h'),
(401, 'FOLDING BIKE', 'CYCLING', 'ZWART', NULL, 2500.00, 0, 50, 'l'),
(408, 'FIETSHELM', 'FIETS', 'BLAUW', NULL, 175.00, 0, 50, 'h'),
(410, 'BALLET SHOES', 'DANCE', 'ROZE', NULL, 80.00, 0, 50, 'l'),
(419, 'SWIMMING CAP', 'SWIMMING', 'BLAUW', NULL, 30.00, 0, 50, 'l'),
(420, 'TENNIS BALLS', 'SPORT', 'GEEL', NULL, 600.00, 0, 50, 'h'),
(421, 'RUNNING WATER BOTTLE', 'RUNNING', 'GRIJS', NULL, 20.00, 0, 50, 'l'),
(422, 'Tennissokken', 'Kleding', 'M', 'Wit', 3.50, 100, 50, 'l'),
(425, 'BADMINTONRACKET', 'RACKET', 'ROOD', NULL, 85.00, 7, 50, 'l'),
(426, 'Fitnessmat', 'Fitness', '180x6', 'Blauw', 15.00, 10, 50, 'l'),
(427, 'EXERCISE MAT', 'YOGA', '', NULL, 50.00, 0, 50, 'l'),
(428, 'SWIM GOGGLES', 'SWIMMING', 'WIT', NULL, 300.00, 0, 50, 'l'),
(432, 'BALANCE TRAINER', 'FITNESS', 'BLAUW', NULL, 200.00, 0, 50, 'h'),
(433, 'SPEED LADDER', 'FITNESS', 'GEEL', NULL, 50.00, 0, 50, 'l'),
(434, 'Basketbal', 'Bal', '7', 'Oranje', 28.00, 10, 50, 'h'),
(437, 'BALANSBOARD', 'FITNESS', 'ZWART', NULL, 75.00, 0, 50, 'h'),
(438, 'Voetbalshirt', 'Kleding', 'L', 'Rood', 30.00, 100, 50, 'h'),
(441, 'WRESTLING SHOES', 'WRESTLING', 'ROOD', NULL, 250.00, 0, 50, 'h'),
(450, 'BOXING BAG', 'BOXING', '', NULL, 600.00, 0, 50, 'h'),
(452, 'INLINE SKATES', 'SKATING', 'ZWART', NULL, 300.00, 0, 50, 'h'),
(453, 'FENCING FOIL', 'FENCING', 'GRIJS', NULL, 180.00, 0, 50, 'h'),
(455, 'Handbal', 'Bal', 'Stand', 'Gemengd', 20.00, 100, 50, 'h'),
(457, 'KITESURF BOARD', 'KITESURFING', 'BLAUW', NULL, 750.00, 0, 50, 'h'),
(458, 'BASEBALL MITT', 'BASEBALL', 'BRUIN', NULL, 150.00, 0, 50, 'h'),
(462, 'TENNIS BALLS', 'SPORT', 'GEEL', NULL, 600.00, 0, 50, 'h'),
(466, 'BIKE LOCK', 'CYCLING', 'ZWART', NULL, 40.00, 0, 50, 'l'),
(467, 'Sports T-shirt', 'Kleding', 'L', 'Geel', 20.00, 100, 50, 'l'),
(468, 'BOKSHANDSCHOENEN', 'BOKSEN', 'ROOD', NULL, 150.00, 0, 50, 'h'),
(469, 'FOOTBALL', 'BAL', 'ROZE', NULL, 150.00, 0, 50, 'l'),
(470, 'GIPSKRUIS', 'SPORT', 'WIT', NULL, 50.00, 0, 50, 'l'),
(471, 'SOCCER CLEATS', 'FOOTBALL', 'GEEL', NULL, 400.00, 0, 50, 'h'),
(477, 'BADMINTON NET', 'BADMINTON', 'WIT', NULL, 150.00, 0, 50, 'l'),
(478, 'Dumbbell', 'Fitness', '5kg', 'Zwart', 15.00, 100, 50, 'h'),
(481, 'SURFBOARD', 'SURFING', 'WIT', NULL, 600.00, 0, 50, 'h'),
(486, 'BIKE HELMET', 'CYCLING', 'ROOD', NULL, 120.00, 0, 50, 'l'),
(489, 'ROWING MACHINE', 'FITNESS', 'GRIJS', NULL, 1500.00, 0, 50, 'h'),
(493, 'TRIATHLON WETSUIT', 'SWIMMING', 'ZWART', NULL, 250.00, 0, 50, 'h'),
(497, 'PULL-UP BAR', 'FITNESS', 'ZWART', NULL, 120.00, 0, 50, 'l'),
(498, 'JUMP ROPE', 'EXERCISE', '', NULL, 250.00, 0, 50, 'h');


-- --------------------------------------------------------
-- Table structure for table `purchases`
-- --------------------------------------------------------

CREATE TABLE `purchases` (
  `purchase_number` INT(8) NOT NULL AUTO_INCREMENT,
  `customer_code` INT(4) NOT NULL,
  `purchase_date` DATE DEFAULT NULL,
  PRIMARY KEY (`purchase_number`),
  CONSTRAINT `fk_purchases_customer` FOREIGN KEY (`customer_code`) REFERENCES `customers`(`customer_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=11;

-- Data for table `purchases`
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
-- Table structure for table `purchase_line`
-- --------------------------------------------------------

CREATE TABLE `purchase_line` (
  `purchase_number` INT(8) NOT NULL,
  `article_code` INT(4) NOT NULL,
  `quantity` INT(6) NOT NULL,
  `purchase_price` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`purchase_number`, `article_code`),
  CONSTRAINT `fk_purchase_line_purchases` FOREIGN KEY (`purchase_number`) REFERENCES `purchases`(`purchase_number`),
  CONSTRAINT `fk_purchase_line_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles`(`article_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `purchase_line`
INSERT INTO `purchase_line` (`purchase_number`, `article_code`, `quantity`, `purchase_price`) VALUES
(1, 1, 23, 19.50),
(1, 2, 2, 22.50),
(1, 35, 60, 1.00),
(1, 74, 90, 1.80),
(2, 39, 20, 4.50),
(2, 56, 60, 2.50),
(2, 422, 34, 3.50),
(2, 384, 12, 3.50),
(3, 54, 35, 3.00),
(3, 210, 15, 0.50),
(3, 383, 10, 9.50),
(3, 200, 3, 17.50),
(4, 332, 100, 2.50),
(4, 12, 15, 20.00),
(4, 397, 12, 15.00),
(5, 56, 12, 2.50),
(5, 311, 17, 2.50),
(5, 50, 9, 0.60),
(5, 195, 7, 14.50),
(5, 126, 85, 3.75),
(6, 23, 45, 1.80),
(6, 391, 15, 2.00),
(6, 12, 20, 19.50),
(6, 300, 25, 9.50),
(6, 175, 10, 3.00),
(7, 47, 21, 19.50),
(7, 19, 90, 5.00),
(7, 117, 45, 5.50),
(8, 332, 34, 2.50),
(8, 207, 65, 2.00),
(9, 117, 75, 5.50),
(9, 300, 35, 9.50),
(9, 296, 10, 2.00),
(10, 67, 15, 2.25),
(10, 104, 5, 17.50),
(10, 408, 6, 22.50);

-- --------------------------------------------------------
-- Table structure for table `orders`
-- --------------------------------------------------------

CREATE TABLE `orders` (
  `order_number` INT(4) NOT NULL AUTO_INCREMENT,
  `supplier_code` INT(4) NOT NULL,
  `order_date` DATE DEFAULT NULL,
  `delivery_date` DATE DEFAULT NULL,
  `amount` DECIMAL(6,2) DEFAULT NULL,
  `status` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`order_number`),
  CONSTRAINT `fk_orders_suppliers` FOREIGN KEY (`supplier_code`) REFERENCES `suppliers`(`supplier_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=205;

-- Data for table `orders`
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
-- Table structure for table `order_lines`
-- --------------------------------------------------------

CREATE TABLE `order_lines` (
  `order_number` INT(4) NOT NULL,
  `article_code` INT(4) NOT NULL,
  `quantity` INT(4) DEFAULT NULL,
  `order_price` DECIMAL(4,2) DEFAULT NULL,
  PRIMARY KEY (`order_number`, `article_code`),
  CONSTRAINT `fk_order_lines_orders` FOREIGN KEY (`order_number`) REFERENCES `orders`(`order_number`),
  CONSTRAINT `fk_order_lines_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles`(`article_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `order_lines`

INSERT INTO `order_lines` (`order_number`, `article_code`, `quantity`, `order_price`) VALUES
(121, 314, 150, 0.45),
(121, 365, 150, 0.95),
(121, 422, 25, 2.25),
(121, 311, 50, 1.65),
(121, 87, 50, 1.90),
(121, 31, 25, 6.35),
(174, 455, 50, 1.35),
(174, 380, 25, 0.65),
(174, 102, 25, 0.70),
(174, 470, 25, 0.65),
(175, 36, 50, 0.75),
(175, 426, 250, 0.25),
(175, 157, 400, 0.20),
(175, 478, 50, 0.45),
(175, 95, 100, 0.40),
(175, 455, 50, 0.80),
(175, 380, 50, 0.45),
(175, 102, 10, 0.45),
(175, 74, 100, 0.70),
(175, 470, 25, 0.45),
(175, 434, 25, 0.35),
(181, 257, 10, 3.60),
(181, 397, 5, 7.20),
(181, 362, 20, 6.05),
(181, 209, 3, 9.45),
(181, 263, 25, 15.45),
(184, 365, 200, 1.20),
(186, 468, 100, 0.65),
(186, 126, 100, 3.25),
(186, 143, 25, 1.30),
(190, 455, 100, 1.15),
(190, 23, 100, 1.00),
(190, 467, 200, 1.15),
(190, 68, 25, 1.60),
(190, 50, 200, 0.35),
(190, 54, 50, 1.65),
(190, 102, 25, 0.55),
(190, 56, 20, 1.45),
(191, 36, 100, 1.10),
(191, 184, 1000, 0.10),
(191, 314, 100, 0.50),
(191, 383, 250, 0.60),
(191, 123, 50, 0.40),
(191, 422, 50, 2.15),
(191, 311, 50, 1.50),
(191, 1, 10, 11.70),
(191, 281, 10, 7.55),
(191, 471, 15, 6.00),
(191, 362, 10, 7.55),
(191, 364, 25, 2.95),
(191, 87, 50, 1.80),
(191, 71, 25, 1.20),
(191, 312, 30, 2.75),
(191, 316, 40, 1.75),
(192, 89, 100, 1.65),
(192, 467, 25, 1.35),
(192, 427, 24, 5.05),
(192, 190, 12, 0.90),
(197, 285, 50, 3.75),
(197, 467, 25, 1.45),
(197, 68, 50, 2.30),
(197, 180, 36, 4.85),
(197, 320, 48, 8.95),
(197, 190, 24, 1.00),
(200, 36, 25, 1.25),
(200, 478, 25, 0.65),
(200, 380, 25, 0.70),
(200, 102, 10, 0.70),
(201, 36, 25, 1.25),
(201, 478, 25, 0.70),
(201, 95, 25, 0.70),
(201, 455, 50, 1.45),
(201, 380, 25, 0.70),
(201, 102, 25, 0.75),
(201, 470, 25, 0.75),
(201, 434, 50, 0.55),
(202, 228, 75, 1.35),
(202, 390, 25, 2.40),
(202, 50, 150, 0.40),
(202, 316, 100, 2.05),
(202, 123, 100, 0.40),
(203, 61, 25, 1.15),
(203, 80, 50, 1.15),
(203, 56, 50, 1.40),
(203, 363, 25, 2.65),
(203, 486, 50, 2.05),
(203, 89, 200, 1.40),
(204, 61, 50, 1.00),
(204, 123, 50, 0.35),
(204, 87, 150, 1.55),
(204, 74, 50, 0.95),
(204, 212, 100, 1.50);

-- --------------------------------------------------------
-- Table structure for table `booking`
-- --------------------------------------------------------

CREATE TABLE `booking` (
  `booking_number` INT(6) NOT NULL AUTO_INCREMENT,
  `booking_date` DATE NOT NULL,
  `amount` DECIMAL(9,2) NOT NULL,
  `customer_supplier_code` INT(4) DEFAULT NULL,
  `status` CHAR(1) DEFAULT NULL,
  PRIMARY KEY (`booking_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=26;

-- Data for table `booking`
INSERT INTO `booking` (`booking_number`, `booking_date`, `amount`, `customer_supplier_code`, `status`) VALUES
(1, '2024-07-17', 602.50, 13, 'A'),
(2, '2024-08-25', 117.50, 4, 'A'),
(3, '2024-08-27', 399.50, 4, 'A'),
(4, '2024-09-06', 607.60, 9, 'A'),
(5, '2024-09-06', 240.00, 22, 'A'),
(6, '2024-09-11', 422.50, 20, 'A'),
(7, '2024-09-13', 680.25, 14, 'A'),
(8, '2024-09-13', 1316.75, 13, 'A'),
(9, '2024-09-13', 330.75, 35, 'A'),
(10, '2024-09-14', 966.95, 35, 'A'),
(11, '2024-09-14', 72.00, 4, 'A'),
(12, '2024-09-26', 221.25, 4, 'A'),
(13, '2024-09-26', 466.25, 14, 'A'),
(14, '2024-10-01', 605.00, 19, 'A'),
(15, '2024-10-01', 497.50, 34, 'A'),
(16, '2024-08-01', 715.50, 100, 'A'),
(17, '2024-08-08', 260.00, 100, 'A'),
(18, '2024-08-15', 730.00, 100, 'A'),
(19, '2024-09-11', 765.00, 100, 'A'),
(20, '2024-08-05', 401.00, 101, 'A'),
(21, '2024-08-27', 768.50, 101, 'A'),
(22, '2024-09-08', 215.00, 101, 'A'),
(23, '2024-08-25', 498.15, 102, 'A'),
(24, '2024-09-05', 1107.00, 102, 'A'),
(25, '2024-09-17', 256.25, 102, 'A');

-- --------------------------------------------------------
-- Table structure for table `booking_line`
-- --------------------------------------------------------

CREATE TABLE `booking_line` (
  `booking_number` INT(6) NOT NULL,
  `sequence_number` INT(2) NOT NULL,
  `amount` DECIMAL(9,2) NOT NULL,
  PRIMARY KEY (`booking_number`, `sequence_number`),
  CONSTRAINT `fk_booking_line_booking` FOREIGN KEY (`booking_number`) REFERENCES `booking`(`booking_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `booking_line`
INSERT INTO `booking_line` (`booking_number`, `sequence_number`, `amount`) VALUES
(2, 1, 602.50),
(3, 1, 33.75),
(3, 2, 83.75),
(4, 1, 157.00),
(4, 2, 52.90),
(4, 3, 127.10),
(4, 4, 62.50),
(5, 1, 157.00),
(6, 1, 102.00),
(8, 1, 5.80),
(8, 2, 19.20),
(13, 1, 17.50),
(13, 2, 14.70),
(17, 1, 715.50),
(21, 1, 193.50),
(18, 1, 157.50),
(18, 2, 102.50),
(19, 1, 730.00),
(22, 1, 471.00),
(24, 1, 30.40),
(25, 1, 390.00),
(20, 1, 765.00);

-- Trigger to auto-increment `sequence_number` within `booking_number`
DROP TRIGGER IF EXISTS `pre_insert_booking_line`;
DELIMITER $$
CREATE TRIGGER `pre_insert_booking_line` 
BEFORE INSERT ON `booking_line` FOR EACH ROW
BEGIN
     SET NEW.sequence_number = (
        SELECT IFNULL(MAX(sequence_number), 0) + 1
        FROM booking_line
        WHERE booking_number = NEW.booking_number
     );
END$$
DELIMITER ;

-- --------------------------------------------------------
-- Table structure for table `invoice`
-- --------------------------------------------------------

CREATE TABLE `invoice` (
  `invoice_number` INT(6) NOT NULL AUTO_INCREMENT,
  `invoice_date` DATE NOT NULL,
  `status` CHAR(1) DEFAULT NULL,
  `booking_number` INT(6) DEFAULT NULL,
  `sequence_number` INT(2) DEFAULT NULL,
  PRIMARY KEY (`invoice_number`),
  CONSTRAINT `fk_invoice_booking_line` FOREIGN KEY (`booking_number`, `sequence_number`) REFERENCES `booking_line`(`booking_number`, `sequence_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=11;

-- Data for table `invoice`
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
-- Table structure for table `delivery`
-- --------------------------------------------------------

CREATE TABLE `delivery` (
  `purchase_number` INT(8) NOT NULL,
  `article_code` INT(4) NOT NULL,
  `delivery_date` DATE NOT NULL,
  `quantity` INT(6) NOT NULL,
  `invoice_number` INT(6) DEFAULT NULL,
  PRIMARY KEY (`purchase_number`, `article_code`, `delivery_date`),
  CONSTRAINT `fk_delivery_purchase_line` FOREIGN KEY (`purchase_number`, `article_code`) REFERENCES `purchase_line`(`purchase_number`, `article_code`),
  CONSTRAINT `fk_delivery_invoice` FOREIGN KEY (`invoice_number`) REFERENCES `invoice`(`invoice_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `delivery`
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
(6, 12, '2024-08-30', 20, 7),
(6, 23, '2024-08-30', 45, 7),
(5, 50, '2024-08-31', 9, 8),
(5, 56, '2024-08-25', 10, 8),
(7, 19, '2024-09-05', 78, 9),
(9, 117, '2024-09-14', 60, 10),
(9, 296, '2024-09-14', 8, 10),
(9, 300, '2024-09-14', 17, 10),
(9, 117, '2024-09-17', 15, 10),
(9, 296, '2024-09-17', 2, 10),
(9, 300, '2024-09-17', 10, 10),
(9, 300, '2024-09-19', 8, 10);

-- --------------------------------------------------------
-- Table structure for table `quotations`
-- --------------------------------------------------------

CREATE TABLE `quotations` (
  `supplier_code` INT(4) NOT NULL,
  `article_code` INT(4) NOT NULL,
  `supplier_article_code` VARCHAR(5) DEFAULT NULL,
  `delivery_time` INT(11) DEFAULT NULL,
  `quotation_price` DECIMAL(4,2) DEFAULT NULL,
  PRIMARY KEY (`supplier_code`, `article_code`),
  CONSTRAINT `fk_quotations_suppliers` FOREIGN KEY (`supplier_code`) REFERENCES `suppliers`(`supplier_code`),
  CONSTRAINT `fk_quotations_article` FOREIGN KEY (`article_code`) REFERENCES `sports_articles`(`article_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `quotations`

INSERT INTO `quotations` (`supplier_code`, `article_code`, `supplier_article_code`, `delivery_time`, `quotation_price`) VALUES
(35, 190, 'ST4P5', 10, 0.85),
(35, 42, 'ST4P6', 10, 3.30),
(35, 283, 'ST4P2', 10, 3.30),
(21, 364, 'BRE', 10, 2.50),
(21, 108, 'FOR', 10, 2.75),
(21, 408, 'HUL', 10, 11.25),
(21, 117, 'KOR', 10, 2.75),
(21, 210, 'LIG', 10, 0.20),
(21, 195, 'MAG', 10, 7.25),
(21, 471, 'OLI', 10, 5.00),
(21, 397, 'PEP', 10, 7.50),
(21, 1, 'ROD', 10, 9.75),
(21, 12, 'SER', 10, 9.75),
(21, 263, 'TOV', 10, 16.00),
(21, 19, 'VUU', 10, 2.50),
(21, 242, 'ZUU', 10, 1.75),
(22, 286, 'B-011', 14, 12.15),
(22, 281, 'B-034', 14, 6.75),
(22, 39, 'B-076', 14, 2.45),
(22, 28, 'B-104', 14, 22.95),
(22, 335, 'E-002', 10, 2.95),
(22, 365, 'E-003', 10, 0.80),
(22, 210, 'S-015', 14, 0.20),
(22, 471, 'S-077', 14, 5.40),
(22, 103, 'S-118', 14, 9.45),
(22, 364, 'S-154', 14, 2.70),
(34, 82, 'ACMO', 14, 2.15),
(34, 61, 'ALTH', 14, 1.25),
(34, 462, 'ANCE', 14, 1.25),
(34, 390, 'ANEM', 14, 2.15),
(34, 224, 'ANGR', 14, 1.25),
(34, 468, 'ANTI', 14, 0.50),
(34, 153, 'AQUI', 14, 1.55),
(34, 105, 'ARDR', 14, 1.25),
(34, 123, 'BEGO', 14, 0.40),
(34, 87, 'CAMP', 14, 1.85),
(34, 74, 'CHEI', 14, 1.10),
(34, 164, 'CHMA', 14, 1.55),
(34, 300, 'CORT', 14, 5.90),
(34, 398, 'CYNO', 14, 0.60),
(34, 212, 'DELP', 14, 1.85),
(34, 24, 'ECHI', 14, 1.85),
(34, 13, 'ERYN', 14, 1.85),
(34, 427, 'HEDE', 14, 4.65),
(34, 89, 'LUPI', 14, 1.55),
(34, 120, 'OCBA', 14, 1.25),
(34, 285, 'PAPA', 14, 3.10),
(34, 380, 'PARH', 14, 0.60),
(34, 143, 'PHLO', 14, 0.95),
(34, 455, 'PRIM', 14, 1.25),
(34, 319, 'RUSC', 14, 1.25),
(34, 391, 'SALV', 14, 1.25),
(34, 50, 'TAGE', 14, 0.35),
(34, 469, 'TULI', 14, 0.25),
(34, 157, 'VIOL', 14, 0.30),
(34, 31, 'VITI', 14, 6.20),
(34, 253, 'WIST', 14, 0.05),
(35, 89, 'ST1P1', 10, 1.65),
(35, 311, 'ST1P3', 10, 1.65),
(35, 130, 'ST1P4', 10, 1.30),
(35, 61, 'ST1P6', 10, 1.30),
(35, 428, 'ST1P8', 10, 2.95),
(35, 285, 'ST1P9', 10, 3.30),
(35, 467, 'ST2P1', 10, 1.30),
(35, 54, 'ST2P2', 10, 2.00),
(35, 82, 'ST2P3', 10, 2.30),
(35, 205, 'ST2P5', 10, 2.95),
(35, 68, 'ST2P6', 10, 2.00),
(35, 180, 'ST3P1', 10, 4.30),
(35, 427, 'ST3P2', 10, 4.95),
(35, 296, 'ST3P5', 10, 1.30),
(35, 320, 'ST4P1', 10, 7.90),
(21, 103, 'AZA', 10, 8.75),
(13, 312, 'G430', 10, 2.95),
(13, 316, 'H510', 10, 1.95),
(14, 455, '001-2', 10, 1.15),
(14, 212, '012-V', 10, 1.70),
(14, 372, '027-V', 10, 1.45),
(14, 384, '067-V', 10, 2.00),
(14, 297, '082-V', 10, 1.15),
(14, 23, '103-2', 10, 1.05),
(14, 13, '117-V', 10, 1.70),
(14, 467, '118-V', 10, 1.15),
(14, 228, '162-V', 10, 1.15),
(14, 478, '195-1', 10, 0.55),
(14, 390, '201-V', 10, 2.00),
(14, 68, '209-V', 10, 1.70),
(14, 50, '255-1', 10, 0.35),
(14, 164, '257-V', 10, 1.45),
(14, 54, '263-V', 10, 1.70),
(14, 351, '264-V', 10, 1.45),
(14, 398, '273-2', 10, 0.55),
(14, 102, '281-2', 10, 0.55),
(14, 87, '286-V', 10, 1.70),
(14, 71, '300-V', 10, 1.15),
(14, 147, '327-1', 10, 0.45),
(14, 438, '335-V', 10, 1.70),
(14, 311, '362-V', 10, 1.45),
(14, 157, '365-V', 10, 0.30),
(14, 56, '393-V', 10, 1.45),
(14, 363, '397-V', 10, 2.55),
(14, 380, '400-2', 10, 0.55),
(14, 316, '408-V', 10, 1.70),
(14, 35, '471-2', 10, 0.55),
(14, 123, '498-1', 10, 0.35),
(19, 82, 'ACMO', 14, 2.10),
(19, 175, 'ACON', 14, 1.80),
(19, 425, 'ALSC', 14, 1.20),
(19, 61, 'ALTH', 14, 1.20),
(19, 87, 'CAMP', 14, 1.80),
(19, 80, 'CENT', 14, 1.20),
(19, 164, 'CHRY', 14, 1.50),
(19, 56, 'CYNO', 14, 1.50),
(19, 212, 'DELP', 14, 1.80),
(19, 438, 'DIAN', 14, 1.80),
(19, 13, 'ERYN', 14, 1.80),
(19, 372, 'EUPH', 14, 1.50),
(19, 316, 'GEUM', 14, 1.80),
(19, 363, 'GYPS', 14, 2.70),
(19, 467, 'HELI', 14, 1.20),
(19, 486, 'KNIP', 14, 2.10),
(19, 71, 'LAMI', 14, 1.20),
(19, 89, 'LUPI', 14, 1.50),
(19, 234, 'MATR', 14, 1.80),
(19, 78, 'PAEO', 14, 2.70),
(19, 67, 'POTE', 14, 1.35),
(19, 207, 'ROSM', 14, 1.20),
(20, 470, '001', 7, 0.65),
(20, 361, '047', 7, 0.65),
(20, 253, '066', 7, 0.10),
(20, 36, '103', 7, 1.15),
(20, 468, '162', 7, 0.50),
(20, 184, '195', 7, 0.10),
(20, 123, '209', 7, 0.40),
(20, 434, '210', 7, 0.50),
(20, 266, '257', 7, 0.65),
(20, 169, '263', 7, 0.05),
(20, 126, '281', 7, 2.45),
(20, 383, '362', 7, 0.65),
(20, 147, '393', 7, 0.50),
(20, 143, '471', 7, 1.00),
(20, 314, '498', 7, 0.50),
(13, 31, 'G202', 14, 6.50),
(4, 426, 'A075', 7, 0.35),
(4, 157, 'A103', 7, 0.30),
(4, 478, 'A184', 7, 0.60),
(4, 36, 'A004', 7, 1.10),
(4, 95, 'A385', 7, 0.60),
(4, 455, 'A421', 7, 1.20),
(4, 380, 'B148', 7, 0.60),
(4, 102, 'B331', 7, 0.60),
(4, 74, 'B337', 7, 1.10),
(4, 470, 'C274', 7, 0.60),
(4, 434, 'D225', 7, 0.50),
(9, 498, '002', 21, 2.95),
(9, 420, '011', 21, 9.90),
(9, 195, '013', 21, 6.55),
(9, 104, '014', 21, 7.90),
(9, 364, '021', 21, 2.25),
(9, 408, '023', 21, 10.15),
(9, 103, '024', 21, 7.90),
(9, 117, '029', 21, 2.50),
(9, 257, '044', 21, 3.40),
(9, 397, '045', 21, 6.75),
(9, 1, '050', 21, 8.80),
(9, 286, '078', 21, 10.15),
(9, 178, '081', 21, 3.40),
(9, 471, '085', 21, 4.50),
(9, 27, '091', 21, 7.90),
(9, 210, '097', 21, 0.20),
(9, 362, '099', 21, 5.65),
(9, 66, '103', 21, 6.10),
(9, 209, '114', 21, 8.80),
(9, 281, '115', 21, 5.65),
(9, 263, '116', 21, 14.40),
(9, 162, '145', 21, 4.30),
(11, 335, 'E01R', 21, 2.90),
(11, 365, 'E05R', 10, 0.80),
(11, 327, 'E11X', 10, 1.05),
(11, 255, 'E23W', 10, 1.05),
(11, 408, 'H09', 14, 11.95),
(11, 1, 'H10R', 14, 10.35),
(11, 397, 'H14R', 14, 7.95),
(11, 195, 'H14W', 14, 7.70),
(11, 117, 'H17', 14, 2.90),
(11, 103, 'H19O', 14, 9.30),
(11, 12, 'H75P', 14, 10.35),
(11, 263, 'H99G', 14, 16.95),
(13, 67, 'A002', 10, 1.45),
(13, 36, 'A101', 7, 1.15),
(13, 184, 'A103', 7, 0.10),
(13, 314, 'A154', 7, 0.50),
(13, 372, 'A230', 10, 1.65),
(13, 82, 'A395', 10, 2.30),
(13, 383, 'A472', 7, 0.65),
(13, 391, 'A520', 10, 1.30),
(13, 437, 'A677', 10, 1.30),
(13, 365, 'B006', 14, 1.00),
(13, 123, 'B101', 7, 0.40),
(13, 422, 'B111', 10, 2.30),
(13, 311, 'B396', 10, 1.65),
(13, 1, 'B578', 14, 12.70),
(13, 281, 'C051', 14, 8.15),
(13, 262, 'C119', 14, 6.20),
(13, 200, 'C243', 14, 11.40),
(13, 471, 'D029', 14, 6.50),
(13, 362, 'D296', 14, 8.15),
(13, 56, 'D321', 10, 1.65),
(13, 47, 'D555', 14, 12.70),
(13, 364, 'D742', 14, 3.25),
(13, 87, 'E098', 10, 1.95),
(13, 228, 'E409', 10, 1.30),
(13, 300, 'F342', 10, 6.20),
(13, 332, 'F823', 10, 1.65),
(13, 71, 'G001', 10, 1.30);

-- --------------------------------------------------------
-- Table structure for table `vat` (VAT Types)
-- --------------------------------------------------------

CREATE TABLE `vat` (
  `type` CHAR(1) DEFAULT NULL,
  `description` VARCHAR(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `vat`
INSERT INTO `vat` (`type`, `description`) VALUES
('h', 'VAT High'),
('l', 'VAT Low'),
('v', 'VAT Shifted'),
('n', 'VAT Zero');

-- --------------------------------------------------------
-- Table structure for table `vat_percentage` (VAT Percentages)
-- --------------------------------------------------------

CREATE TABLE `vat_percentage` (
  `type` CHAR(1) DEFAULT NULL,
  `from` DATE DEFAULT NULL,
  `to` DATE DEFAULT NULL,
  `percent` DECIMAL(5,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `vat_percentage`
INSERT INTO `vat_percentage` (`type`, `from`, `to`, `percent`) VALUES
('h', '1992-01-01', NULL, 19.000),
('h', '1998-01-01', '1992-01-01', 18.500),
('l', '1998-01-01', NULL, 6.000),
('l', '1975-01-01', '1998-01-01', 4.500);

-- --------------------------------------------------------
-- Table structure for table `goods_receipt`
-- --------------------------------------------------------

CREATE TABLE `goods_receipt` (
  `order_number` INT(4) NOT NULL,
  `article_code` INT(4) NOT NULL,
  `receipt_date` DATE NOT NULL,
  `receipt_quantity` INT(4) NOT NULL,
  `status` CHAR(1) NOT NULL,
  `booking_number` INT(6) DEFAULT NULL,
  `sequence_number` INT(2) DEFAULT NULL,
  PRIMARY KEY (`order_number`, `article_code`, `receipt_date`),
  CONSTRAINT `fk_goods_receipt_order_lines` FOREIGN KEY (`order_number`, `article_code`) REFERENCES `order_lines`(`order_number`, `article_code`),
  CONSTRAINT `fk_goods_receipt_booking_line` FOREIGN KEY (`booking_number`, `sequence_number`) REFERENCES `booking_line`(`booking_number`, `sequence_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data for table `goods_receipt`
INSERT INTO `goods_receipt` (`order_number`, `article_code`, `receipt_date`, `receipt_quantity`, `status`, `booking_number`, `sequence_number`) VALUES
(121, 31, '2024-07-31', 25, 'A', 2, 1),
(121, 87, '2024-07-31', 50, 'A', 2, 1),
(121, 311, '2024-07-31', 50, 'A', 2, 1),
(121, 314, '2024-07-31', 150, 'A', 2, 1),
(121, 365, '2024-07-31', 150, 'A', 2, 1),
(121, 422, '2024-07-31', 25, 'A', 2, 1),
(174, 102, '2024-09-04', 25, 'A', 3, 1),
(174, 380, '2024-09-04', 25, 'A', 3, 1),
(174, 455, '2024-09-10', 50, 'A', 3, 2),
(174, 470, '2024-09-10', 25, 'A', 3, 2),
(175, 36, '2024-09-06', 30, 'A', 4, 1),
(175, 74, '2024-09-06', 20, 'A', 4, 1),
(175, 95, '2024-09-06', 100, 'A', 4, 1),
(175, 380, '2024-09-06', 15, 'A', 4, 1),
(175, 455, '2024-09-06', 50, 'A', 4, 1),
(175, 470, '2024-09-06', 25, 'A', 4, 1),
(175, 478, '2024-09-06', 50, 'A', 4, 1),
(175, 36, '2024-09-15', 20, 'A', 4, 2),
(175, 74, '2024-09-15', 40, 'A', 4, 2),
(175, 102, '2024-09-15', 10, 'A', 4, 2),
(175, 380, '2024-09-15', 12, 'A', 4, 2),
(175, 434, '2024-09-20', 25, 'A', 4, 3),
(175, 74, '2024-09-20', 40, 'A', 4, 3),
(175, 157, '2024-09-20', 400, 'A', 4, 3),
(175, 380, '2024-09-20', 23, 'A', 4, 3),
(175, 426, '2024-09-25', 250, 'A', 4, 4),
(181, 362, '2024-09-27', 20, 'A', 5, 1),
(181, 397, '2024-09-27', 5, 'A', 5, 1),
(184, 365, '2024-09-19', 85, 'A', 6, 1),
(190, 56, '2024-09-23', 4, 'A', 8, 1),
(190, 68, '2024-09-27', 12, 'A', 8, 2),
(201, 36, '2024-10-02', 5, 'A', 13, 1),
(201, 470, '2024-10-02', 15, 'A', 13, 1),
(201, 478, '2024-10-07', 21, 'A', 13, 2);

-- --------------------------------------------------------
-- Indexes for optimization (optional but recommended)
-- --------------------------------------------------------

CREATE INDEX `idx_purchase_line_article_code` ON `purchase_line`(`article_code`);
CREATE INDEX `idx_order_lines_article_code` ON `order_lines`(`article_code`);
CREATE INDEX `idx_quotations_article_code` ON `quotations`(`article_code`);
CREATE INDEX `idx_delivery_invoice_number` ON `delivery`(`invoice_number`);
CREATE INDEX `idx_booking_line_booking_number` ON `booking_line`(`booking_number`);

-- --------------------------------------------------------
-- Commit all changes
-- --------------------------------------------------------

COMMIT;

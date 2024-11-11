-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Nov 08, 2024 at 01:59 PM
-- Server version: 11.5.2-MariaDB-ubu2404
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `QA_Sportartikelen`
--

-- --------------------------------------------------------

--
-- Table structure for table `sportartikelen`
--

CREATE TABLE `sportartikelen` (
  `artcode` int(4) NOT NULL,
  `artikelnaam` varchar(30) NOT NULL,
  `categorie` varchar(15) DEFAULT NULL,
  `maat` varchar(5) DEFAULT NULL,
  `kleur` varchar(20) DEFAULT NULL,
  `prijs` decimal(6,2) DEFAULT NULL,
  `vrr_aantal` int(11) NOT NULL DEFAULT 0,
  `vrr_min` int(11) NOT NULL DEFAULT 0,
  `BTWtype` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `sportartikelen`
--

INSERT INTO `sportartikelen` (`artcode`, `artikelnaam`, `categorie`, `maat`, `kleur`, `prijs`, `vrr_aantal`, `vrr_min`, `BTWtype`) VALUES
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `sportartikelen`
--
ALTER TABLE `sportartikelen`
  ADD PRIMARY KEY (`artcode`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `sportartikelen`
--
ALTER TABLE `sportartikelen`
  MODIFY `artcode` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=500;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

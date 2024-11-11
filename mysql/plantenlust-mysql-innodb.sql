-- phpMyAdmin SQL Dump
-- version 3.3.5
-- http://www.phpmyadmin.net
--
-- Machine: 127.0.0.1
-- Genereertijd: 26 Dec 2010 om 12:02
-- Serverversie: 5.1.49
-- PHP-Versie: 5.3.3

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `plantenlust`
--
CREATE DATABASE `plantenlust` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `plantenlust`;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `aankoop`
--

CREATE TABLE IF NOT EXISTS `aankoop` (
  `klcode` int(4) NOT NULL,
  `artcode` int(4) NOT NULL,
  `aantal` int(3) DEFAULT NULL,
  PRIMARY KEY (`klcode`,`artcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `aankoop`
--

INSERT INTO `aankoop` (`klcode`, `artcode`, `aantal`) VALUES
(100, 35, 6),
(100, 74, 10),
(101, 384, 5),
(101, 89, 15),
(102, 200, 7);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `aankoopreg`
--

CREATE TABLE IF NOT EXISTS `aankoopreg` (
  `aankoopnr` int(8) NOT NULL,
  `artcode` int(4) NOT NULL,
  `aantal` int(6) NOT NULL,
  `aank_prijs` decimal(8,2) NOT NULL,
	Constraint  pk_aankoopreg   primary key	(aankoopnr,artcode)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `aankoopreg`
--

INSERT INTO `aankoopreg` (`aankoopnr`, `artcode`, `aantal`, `aank_prijs`) VALUES
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

--
-- Tabelstructuur voor tabel `aankopen`
--

CREATE TABLE IF NOT EXISTS `aankopen` (
  `aankoopnr` int(8) NOT NULL AUTO_INCREMENT,
  `klcode` int(4) NOT NULL,
  `aankoopdat` date DEFAULT NULL,
  CONSTRAINT pk_aankopen PRIMARY KEY (`aankoopnr`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Gegevens worden uitgevoerd voor tabel `aankopen`
--

INSERT INTO `aankopen` (`aankoopnr`, `klcode`, `aankoopdat`) VALUES
(1, 100, '1997-08-01'),
(2, 101, '1997-08-05'),
(3, 100, '1997-08-08'),
(4, 100, '1997-08-15'),
(5, 102, '1997-08-25'),
(6, 101, '1997-08-27'),
(7, 102, '1997-09-05'),
(8, 101, '1997-09-08'),
(9, 100, '1997-09-11'),
(10, 102, '1997-09-17');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `best_dnum`
--

CREATE TABLE IF NOT EXISTS `best_dnum` (
  `bestelnr` varchar(4) NOT NULL,
  `levcode` varchar(3) NOT NULL,
  `besteldat` int(6) NOT NULL,
  `leverdat` int(6) NOT NULL,
  `bedrag` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `best_dnum`
--

INSERT INTO `best_dnum` (`bestelnr`, `levcode`, `besteldat`, `leverdat`, `bedrag`) VALUES
('1', '1', 960130, 960214, 1000.00),
('2', '1', 960208, 960314, 1000.00),
('3', '1', 960330, 960414, 1000.00),
('4', '1', 960430, 960514, 1000.00),
('5', '1', 960530, 960614, 1000.00),
('6', '1', 960630, 960714, 1000.00),
('7', '1', 960730, 960814, 1000.00);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `bestellingen`
--

CREATE TABLE IF NOT EXISTS `bestellingen` (
  `bestelnr` int(4) NOT NULL AUTO_INCREMENT,
  `levcode` int(4) NOT NULL,
  `besteldat` date DEFAULT NULL,
  `leverdat` date DEFAULT NULL,
  `bedrag` decimal(6,2) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`bestelnr`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=205 ;

--
-- Gegevens worden uitgevoerd voor tabel `bestellingen`
--

INSERT INTO `bestellingen` (`bestelnr`, `levcode`, `besteldat`, `leverdat`, `bedrag`, `status`) VALUES
(121, 13, '1997-07-17', '1997-07-31', 602.50, 'C'),
(174, 4, '1997-08-25', '1997-09-04', 117.50, 'C'),
(175, 4, '1997-08-27', '1997-09-06', 399.50, 'C'),
(181, 9, '1997-09-06', '1997-09-27', 607.60, 'C'),
(184, 22, '1997-09-06', '1997-09-16', 240.00, 'C'),
(186, 20, '1997-09-11', '1997-09-18', 422.50, 'C'),
(190, 14, '1997-09-13', '1997-09-23', 680.25, 'C'),
(191, 13, '1997-09-13', '1997-09-27', 1316.75, 'C'),
(192, 35, '1997-09-13', '1997-09-23', 330.75, 'C'),
(197, 35, '1997-09-14', '1997-09-23', 966.95, 'C'),
(200, 4, '1997-09-14', '1997-09-21', 72.00, 'C'),
(201, 4, '1997-09-26', '1997-10-02', 221.25, 'C'),
(202, 14, '1997-09-26', '1997-10-05', 466.25, 'C'),
(203, 19, '1997-10-01', '1997-10-15', 605.00, 'C'),
(204, 34, '1997-10-01', '1997-10-15', 497.50, 'C');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `bestelregels`
--

CREATE TABLE IF NOT EXISTS `bestelregels` (
  `bestelnr` int(4) NOT NULL,
  `artcode` int(4) NOT NULL,
  `aantal` int(4) DEFAULT NULL,
  `bestelprijs` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`bestelnr`,`artcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `bestelregels`
--

INSERT INTO `bestelregels` (`bestelnr`, `artcode`, `aantal`, `bestelprijs`) VALUES
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

--
-- Tabelstructuur voor tabel `boeking`
--

CREATE TABLE IF NOT EXISTS `boeking` (
  `boekstuk` int(6) NOT NULL AUTO_INCREMENT,
  `boekdatum` date NOT NULL,
  `bedrag` decimal(9,2) NOT NULL,
  `kllv_code` int(4) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`boekstuk`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

--
-- Gegevens worden uitgevoerd voor tabel `boeking`
--

INSERT INTO `boeking` (`boekstuk`, `boekdatum`, `bedrag`, `kllv_code`, `status`) VALUES
(1, '1997-07-17', 602.50, 13, 'A'),
(2, '1997-08-25', 117.50, 4, 'A'),
(3, '1997-08-27', 399.50, 4, 'A'),
(4, '1997-09-06', 607.60, 9, 'A'),
(5, '1997-09-06', 240.00, 22, 'A'),
(6, '1997-09-11', 422.50, 20, 'A'),
(7, '1997-09-13', 680.25, 14, 'A'),
(8, '1997-09-13', 1316.75, 13, 'A'),
(9, '1997-09-13', 330.75, 35, 'A'),
(10, '1997-09-14', 966.95, 35, 'A'),
(11, '1997-09-14', 72.00, 4, 'A'),
(12, '1997-09-26', 221.25, 4, 'A'),
(13, '1997-09-26', 466.25, 14, 'A'),
(14, '1997-10-01', 605.00, 19, 'A'),
(15, '1997-10-01', 497.50, 34, 'A'),
(16, '1997-08-01', 715.50, 100, 'A'),
(17, '1997-08-08', 260.00, 100, 'A'),
(18, '1997-08-15', 730.00, 100, 'A'),
(19, '1997-09-11', 765.00, 100, 'A'),
(20, '1997-08-05', 401.00, 101, 'A'),
(21, '1997-08-27', 768.50, 101, 'A'),
(22, '1997-09-08', 215.00, 101, 'A'),
(23, '1997-08-25', 498.15, 102, 'A'),
(24, '1997-09-05', 1107.00, 102, 'A'),
(25, '1997-09-17', 256.25, 102, 'A');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `boekregel`
--

CREATE TABLE IF NOT EXISTS `boekregel` (
  `boekstuk` int(6) NOT NULL,
  `vlgnr`    int(2) NOT NULL,
  `bedrag`   decimal(9,2) NOT NULL,
  PRIMARY KEY (`boekstuk`,`vlgnr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `boekregel`
--

INSERT INTO `boekregel` (`boekstuk`, `vlgnr`, `bedrag`) VALUES
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

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `bregels`
--

CREATE TABLE IF NOT EXISTS `bregels` (
  `artcode` int(4) NOT NULL,
  `aantal` int(4) NOT NULL,
  `levcode` int(4) DEFAULT NULL,
  `bestelprijs` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`artcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `bregels`
--


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `btw`
--

CREATE TABLE IF NOT EXISTS `btw` (
  `type` char(1) DEFAULT NULL,
  `omschrijving` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `btw`
--

INSERT INTO `btw` (`type`, `omschrijving`) VALUES
('h', 'btw hoog'),
('l', 'btw laag'),
('v', 'btw verlegt'),
('n', 'btw nul');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `btwperc`
--

CREATE TABLE IF NOT EXISTS `btwperc` (
  `type` char(1) DEFAULT NULL,
  `van` date DEFAULT NULL,
  `tot` date DEFAULT NULL,
  `percent` decimal(5,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `btwperc`
--

INSERT INTO `btwperc` (`type`, `van`, `tot`, `percent`) VALUES
('h', '1992-01-01', NULL, 19.000),
('h', '1998-01-01', '1992-01-01', 18.500),
('l', '1998-01-01', NULL, 6.000),
('l', '1975-01-01', '1998-01-01', 4.500);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `factuur`
--

CREATE TABLE IF NOT EXISTS `factuur` (
  `factnr` int(6) NOT NULL AUTO_INCREMENT,
  `factdatum` date NOT NULL,
  `status` char(1) DEFAULT NULL,
  `boekstuk` int(6) DEFAULT NULL,
  `vlgnr` int(2) DEFAULT NULL,
  PRIMARY KEY (`factnr`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Gegevens worden uitgevoerd voor tabel `factuur`
--

INSERT INTO `factuur` (`factnr`, `factdatum`, `status`, `boekstuk`, `vlgnr`) VALUES
(1, '1997-08-07', 'A', 17, 1),
(2, '1997-08-10', 'A', 21, 1),
(3, '1997-08-15', 'A', 18, 1),
(4, '1997-08-19', 'A', 18, 2),
(5, '1997-08-21', 'A', 19, 1),
(6, '1997-08-25', 'A', 19, 1),
(7, '1997-08-30', 'A', 22, 1),
(8, '1997-08-30', 'A', 24, 1),
(9, '1997-09-05', 'A', 25, 1),
(10, '1997-09-14', 'A', 20, 1);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `goed_ontvangst`
--

CREATE TABLE IF NOT EXISTS `goed_ontvangst` (
  `bestelnr` int(4) NOT NULL,
  `artcode` int(4) NOT NULL,
  `ontv_datum` date NOT NULL,
  `ontv_aantal` int(4) NOT NULL,
  `status` char(1) NOT NULL,
  `boekstuk` int(6) DEFAULT NULL,
  `vlgnr` int(2) DEFAULT NULL,
  PRIMARY KEY (`bestelnr`,`artcode`,`ontv_datum`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `goed_ontvangst`
--

INSERT INTO `goed_ontvangst` (`bestelnr`, `artcode`, `ontv_datum`, `ontv_aantal`, `status`, `boekstuk`, `vlgnr`) VALUES
(121, 31, '1997-07-31', 25, 'A', 2, 1),
(121, 87, '1997-07-31', 50, 'A', 2, 1),
(121, 311, '1997-07-31', 50, 'A', 2, 1),
(121, 314, '1997-07-31', 150, 'A', 2, 1),
(121, 365, '1997-07-31', 150, 'A', 2, 1),
(121, 422, '1997-07-31', 25, 'A', 2, 1),
(174, 102, '1997-09-04', 25, 'A', 3, 1),
(174, 380, '1997-09-04', 25, 'A', 3, 1),
(174, 455, '1997-09-10', 50, 'A', 3, 2),
(174, 470, '1997-09-10', 25, 'A', 3, 2),
(175, 36, '1997-09-06', 30, 'A', 4, 1),
(175, 74, '1997-09-06', 20, 'A', 4, 1),
(175, 95, '1997-09-06', 100, 'A', 4, 1),
(175, 380, '1997-09-06', 15, 'A', 4, 1),
(175, 455, '1997-09-06', 50, 'A', 4, 1),
(175, 470, '1997-09-06', 25, 'A', 4, 1),
(175, 478, '1997-09-06', 50, 'A', 4, 1),
(175, 36, '1997-09-15', 20, 'A', 4, 2),
(175, 74, '1997-09-15', 40, 'A', 4, 2),
(175, 102, '1997-09-15', 10, 'A', 4, 2),
(175, 380, '1997-09-15', 12, 'A', 4, 2),
(175, 434, '1997-09-20', 25, 'A', 4, 3),
(175, 74, '1997-09-20', 40, 'A', 4, 3),
(175, 157, '1997-09-20', 400, 'A', 4, 3),
(175, 380, '1997-09-20', 23, 'A', 4, 3),
(175, 426, '1997-09-25', 250, 'A', 4, 4),
(181, 362, '1997-09-27', 20, 'A', 5, 1),
(181, 397, '1997-09-27', 5, 'A', 5, 1),
(184, 365, '1997-09-19', 85, 'A', 6, 1),
(190, 56, '1997-09-23', 4, 'A', 8, 1),
(190, 68, '1997-09-27', 12, 'A', 8, 2),
(201, 36, '1997-10-02', 5, 'A', 13, 1),
(201, 470, '1997-10-02', 15, 'A', 13, 1),
(201, 478, '1997-10-07', 21, 'A', 13, 2);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `klanten`
--

CREATE TABLE IF NOT EXISTS `klanten` (
  `klcode` int(4) NOT NULL AUTO_INCREMENT,
  `klnaam` varchar(20) NOT NULL,
  `kladres` varchar(25) DEFAULT NULL,
  `klpcode` char(7) DEFAULT NULL,
  `kltele` char(11) DEFAULT NULL,
  `klplaats` varchar(15) DEFAULT NULL,
  `klstatus` char(1) DEFAULT NULL,
  `klcredlim` decimal(8,2) NOT NULL DEFAULT 1000.00,
  `saldo` decimal(8,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`klcode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=104 ;

--
-- Gegevens worden uitgevoerd voor tabel `klanten`
--

INSERT INTO `klanten` (`klcode`, `klnaam`, `kladres`, `klpcode`, `kltele`, `klplaats`, `klstatus`, `klcredlim`, `saldo`) VALUES
(100, 'AS Automatisering', 'Bezuidenhout 1', '5472 ER', '0492-324373', 'BOEKEL', 'A', 1000.00, 0.00),
(101, 'AS Opleiding', 'Bezuidenhout 1', '5472 ER', '0492-321198', 'BOEKEL', 'A', 1000.00, 0.00),
(102, 'AS Backups', 'Bezuidenhout 1', '5472 ER', '0492-324373', 'BOEKEL', 'A', 1000.00, 0.00),
(103, 'AS Informatica', 'Kaaphoorndreef 60', '3463 AV', '030-2628900', 'Utrecht', 'A', 1000.00, 0.00);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `leveranciers`
--

CREATE TABLE IF NOT EXISTS `leveranciers` (
  `levcode` int(4) NOT NULL AUTO_INCREMENT,
  `levnaam` varchar(20) NOT NULL,
  `adres` varchar(25) DEFAULT NULL,
  `woonplaats` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`levcode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=36 ;

--
-- Gegevens worden uitgevoerd voor tabel `leveranciers`
--

INSERT INTO `leveranciers` (`levcode`, `levnaam`, `adres`, `woonplaats`) VALUES
(4, 'HOVENIER G.H.', 'ZANDWEG 50', 'LISSE'),
(9, 'BAUMGARTEN R.', 'TAKSTRAAT 13', 'HILLEGOM'),
(11, 'STRUIK BV.', 'BESSENLAAN 1', 'LISSE'),
(13, 'SPITMAN EN ZN.', 'ACHTERTUIN 9', 'AALSMEER'),
(14, 'DEZAAIER L.J.A.', 'DE GRONDEN 101', 'LISSE'),
(19, 'MOOIWEER FA.', 'VERLENGDE ZOMERSTR. 24', 'AALSMEER'),
(20, 'BLOEM L.Z.H.W.', 'LINNAEUSHOF 17', 'HILLEGOM'),
(21, 'TRA A.', 'KOELEPLEKSTRAAT 10', 'LISSE'),
(22, 'ERICA BV.', 'BERKENWEG 87', 'HEEMSTEDE'),
(34, 'DE GROENE KAS BV.', 'GLASWEG 1', 'AALSMEER'),
(35, 'FLORA BV.', 'OEVERSTRAAT 76', 'AALSMEER');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `levering`
--

CREATE TABLE IF NOT EXISTS `levering` (
  `aankoopnr` int(8) NOT NULL,
  `artcode` int(4) NOT NULL,
  `levdatum` date NOT NULL,
  `aantal` int(6) NOT NULL,
  `factnr` int(6) DEFAULT NULL,
  PRIMARY KEY (`aankoopnr`,`artcode`,`levdatum`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `levering`
--

INSERT INTO `levering` (`aankoopnr`, `artcode`, `levdatum`, `aantal`, `factnr`) VALUES
(1, 1, '1997-08-08', 23, 1),
(1, 2, '1997-08-08', 2, 1),
(1, 35, '1997-08-08', 60, 1),
(1, 74, '1997-08-08', 90, 1),
(2, 39, '1997-08-11', 18, 2),
(2, 56, '1997-08-11', 45, 2),
(3, 54, '1997-08-15', 35, 3),
(3, 200, '1997-08-15', 3, 3),
(3, 210, '1997-08-20', 15, 4),
(3, 383, '1997-08-20', 10, 4),
(4, 12, '1997-08-21', 15, 5),
(4, 332, '1997-08-21', 100, 5),
(4, 397, '1997-08-26', 12, 6),
(6, 12, '1997-08-30', 20, 7),
(6, 23, '1997-08-30', 45, 7),
(5, 50, '1997-08-31', 9, 8),
(5, 56, '1997-08-25', 10, 8),
(7, 19, '1997-09-05', 78, 9),
(9, 117, '1997-09-14', 60, 10),
(9, 296, '1997-09-14', 8, 10),
(9, 300, '1997-09-14', 17, 10),
(9, 117, '1997-09-17', 15, 10),
(9, 296, '1997-09-17', 2, 10),
(9, 300, '1997-09-17', 10, 10),
(9, 300, '1997-09-19', 8, 10);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `offertes`
--

CREATE TABLE IF NOT EXISTS `offertes` (
  `levcode` int(4) NOT NULL,
  `artcode` int(4) NOT NULL,
  `artcodelev` varchar(5) DEFAULT NULL,
  `levtijd` int(11) DEFAULT NULL,
  `offprijs` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`levcode`,`artcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `offertes`
--

INSERT INTO `offertes` (`levcode`, `artcode`, `artcodelev`, `levtijd`, `offprijs`) VALUES
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

--
-- Tabelstructuur voor tabel `planten`
--

CREATE TABLE IF NOT EXISTS `planten` (
  `artcode` int(4) NOT NULL AUTO_INCREMENT,
  `plantennaam` varchar(16) NOT NULL,
  `soort` varchar(7) DEFAULT NULL,
  `kleur` varchar(7) DEFAULT NULL,
  `hoogte` int(11) DEFAULT NULL,
  `bloeibeg` int(11) DEFAULT NULL,
  `bloeieind` int(11) DEFAULT NULL,
  `prijs` decimal(4,2) DEFAULT NULL,
  `vrr_aantal` int(11) NOT NULL DEFAULT '0',
  `vrr_min` int(11) NOT NULL DEFAULT '0',
  `BTWtype` char(1) DEFAULT NULL,
  PRIMARY KEY (`artcode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=500 ;

--
-- Gegevens worden uitgevoerd voor tabel `planten`
--

INSERT INTO `planten` (`artcode`, `plantennaam`, `soort`, `kleur`, `hoogte`, `bloeibeg`, `bloeieind`, `prijs`, `vrr_aantal`, `vrr_min`, `BTWtype`) VALUES
(108, 'FORSYTHIA', 'HEESTER', 'GEEL', 250, 3, 4, 5.50, 10, 50, 'l'),
(434, 'PETUNIA', '1-JARIG', 'ROZE', 25, 7, 10, 0.80, 10, 50, 'l'),
(426, 'ALYSSUM', '1-JARIG', 'PAARS', 10, 6, 9, 0.60, 10, 50, 'l'),
(398, 'HONDSTONG', '2-JARIG', 'BLAUW', 30, 5, 6, 1.00, 10, 50, 'l'),
(143, 'VLAMBLOEM', '1-JARIG', 'GEMENGD', 30, 7, 8, 1.50, 10, 50, 'l'),
(228, 'ENGELS GRAS', 'VAST', 'ROOD', 20, NULL, NULL, 2.00, 10, 50, 'l'),
(391, 'SALIE', 'KRUID', 'VIOLET', 100, 6, 7, 2.00, 10, 50, 'l'),
(362, 'SPAR', 'BOOM', '', 3000, NULL, NULL, 12.50, 10, 50, 'h'),
(380, 'KLAPROOS', '2-JARIG', 'GEMENGD', 40, 6, 6, 1.00, 10, 50, 'l'),
(39, 'POPULIER', 'BOOM', 'WIT', 1000, 3, 4, 4.50, 10, 50, 'h'),
(56, 'HONDSTONG', 'VAST', 'BLAUW', 30, 6, 8, 2.50, 10, 50, 'l'),
(455, 'SLEUTELBLOEM', '2-JARIG', 'GEMENGD', 25, 4, 5, 2.00, 100, 50, 'l'),
(253, 'BLAUW DRUIFJE', 'BOL', 'BLAUW', 20, 2, 6, 0.12, 100, 50, 'l'),
(78, 'PIOEN', 'VAST', 'ROOD', 50, 6, 7, 4.50, 100, 50, 'l'),
(31, 'WIJNSTOK', 'BOOM', '', 600, NULL, NULL, 10.00, 100, 50, 'h'),
(157, 'VIOOLTJE', '2-JARIG', 'GEMENGD', 15, 3, 8, 0.50, 100, 50, 'l'),
(87, 'KLOKJESBLOEM', 'VAST', 'BLAUW', 90, 6, 8, 3.00, 100, 50, 'l'),
(35, 'VIOLIER', '2-JARIG', 'GEMENGD', 60, 6, 7, NULL, 100, 50, 'l'),
(71, 'DOVENETEL', 'VAST', 'GEEL', 25, 4, 5, 2.00, 100, 50, 'l'),
(105, 'DRAGON', 'KRUID', 'WIT', 100, 8, 9, 2.00, 100, 50, 'l'),
(103, 'AZALEA', 'HEESTER', 'ORANJE', 200, 4, 5, 17.50, 100, 50, 'l'),
(478, 'KLAPROOS', '1-JARIG', 'GEMENGD', 35, 6, 9, 1.00, 100, 50, 'l'),
(281, 'BEUK', 'BOOM', 'GROEN', 3000, 4, 5, 12.50, 100, 50, 'h'),
(147, 'ASTER', '1-JARIG', 'GEMENGD', 50, 7, 10, 0.75, 100, 50, 'l'),
(224, 'DILLE', 'KRUID', 'GEEL', 90, 7, 8, 2.00, 100, 50, 'l'),
(263, 'TOVERHAZELAAR', 'BOOM', 'GEEL', 500, 1, 2, 32.00, 100, 50, 'h'),
(467, 'ZONNEBLOEM', 'VAST', 'GEEL', 150, 8, 9, 2.00, 100, 50, 'l'),
(384, 'VUURWERKPLANT', 'VAST', 'ROZE', 150, 6, 7, 3.50, 100, 50, 'l'),
(36, 'ZONNEBLOEM', '1-JARIG', 'GEEL', 150, 8, 10, 1.80, 100, 50, 'l'),
(319, 'ZURING', 'KRUID', 'ROOD', 70, 6, 6, 2.00, 100, 50, 'l'),
(438, 'ANJER', 'VAST', 'WIT', 40, 6, 8, 3.00, 100, 50, 'l'),
(27, 'PAARDEKASTANJE', 'BOOM', 'WIT', 2500, 5, 5, 17.50, 100, 50, 'h'),
(422, 'WOLGRAS', 'WATER', 'WIT', 30, 5, 6, 3.50, 100, 50, 'l'),
(311, 'LEVERKRUID', 'VAST', 'PAARS', 175, 8, 9, 2.50, 100, 50, 'l'),
(286, 'TULPEBOOM', 'BOOM', 'GEEL', 2000, 6, 7, 22.50, 100, 50, 'h'),
(209, 'MEIDOORN', 'BOOM', 'ROZE', 700, 5, 5, 19.50, 100, 50, 'h'),
(425, 'BIESLOOK', 'KRUID', 'PAARS', 20, 7, 8, 2.00, 100, 50, 'l'),
(61, 'STOKROOS', 'VAST', 'ROOD', 250, 6, 9, 2.00, 100, 50, 'l'),
(200, 'ACACIA', 'BOOM', 'WIT', 2500, 6, 6, 17.50, 100, 50, 'h'),
(468, 'LEEUWEBEKJE', '1-JARIG', 'GEMENGD', 50, 7, 8, 0.80, 100, 50, 'l'),
(383, 'JUDASBOOM', 'BOOM', 'ROZE', 800, 5, 5, 9.50, 100, 50, 'h'),
(234, 'KAMILLE', 'VAST', 'WIT', 70, 6, 7, 3.00, 100, 50, 'l'),
(50, 'AFRIKAANTJE', '1-JARIG', 'GEEL', 25, 7, 10, 0.60, 100, 50, 'l'),
(390, 'ANEMOON', 'VAST', 'ROZE', 50, 8, 10, 3.50, 100, 50, 'l'),
(195, 'MAGNOLIA', 'BOOM', 'WIT', 1000, 4, 5, 14.50, 100, 50, 'h'),
(153, 'AKELEI', 'VAST', 'BLAUW', 60, 5, 7, 2.50, 100, 50, 'l'),
(210, 'LIGUSTER', 'HEESTER', 'WIT', 200, 7, 7, 0.40, 100, 50, 'l'),
(314, 'CHRYSANT', '1-JARIG', 'GEEL', 80, 6, 8, 0.80, 100, 50, 'l'),
(285, 'KLAPROOS', 'VAST', 'ROOD', 70, 5, 6, 3.00, 100, 50, 'l'),
(120, 'BASILICUM', 'KRUID', 'WIT', 50, 8, 9, 2.00, 100, 50, 'l'),
(54, 'BOTERBLOEM', 'VAST', 'WIT', 50, 5, 6, 3.00, 100, 50, 'l'),
(255, 'WINTERHEIDE', 'HEIDE', 'WIT', 20, 2, 4, 2.00, 100, 50, 'l'),
(24, 'KOGELDISTEL', 'VAST', 'BLAUW', 175, 6, 7, 3.00, 100, 50, 'l'),
(23, 'KLOKJESBLOEM', '2-JARIG', 'BLAUW', 70, 6, 8, 1.80, 100, 50, 'l'),
(364, 'BREM', 'HEESTER', 'GEEL', 150, 4, 7, 5.00, 100, 50, 'l'),
(126, 'SIERUI', 'BOL', 'BLAUW', 75, 6, 8, 3.75, 100, 50, 'l'),
(178, 'LIJSTERBES', 'BOOM', 'WIT', 500, 5, 5, 7.50, 100, 50, 'h'),
(80, 'KORENBLOEM', 'VAST', 'BLAUW', 80, 7, 8, 2.00, 100, 50, 'l'),
(351, 'TIJM', 'KRUID', 'PAARS', 10, 6, 6, 2.50, 100, 50, 'l'),
(180, 'BOSRANK', 'KLIM', 'PAARS', 300, 7, 9, 6.50, 100, 50, 'l'),
(408, 'HULST', 'BOOM', '', 700, NULL, NULL, 22.50, 100, 50, 'h'),
(104, 'ESDOORN', 'BOOM', 'GROEN', 2500, 6, 6, 17.50, 100, 50, 'h'),
(262, 'PASSIEBLOEM', 'KLIM', 'BLAUW', NULL, 6, 9, 9.50, 100, 50, 'l'),
(363, 'GIPSKRUID', 'VAST', 'WIT', 90, 7, 8, 4.50, 100, 50, 'l'),
(130, 'VINGERHOEDSKRUID', 'VAST', 'GEMENGD', NULL, 6, 8, 2.00, 100, 50, 'l'),
(297, 'MAJORAAN', 'KRUID', 'PAARS', 30, 7, 8, 2.00, 100, 50, 'l'),
(169, 'KROKUS', 'BOL', 'WIT', 15, 2, 3, 0.10, 100, 50, 'l'),
(205, 'DOTTERBLOEM', 'WATER', 'GEEL', 30, 4, 6, 4.50, 100, 50, 'l'),
(257, 'BERK', 'BOOM', '', 2000, NULL, NULL, 7.50, 100, 50, 'h'),
(68, 'DAGLELIE', 'VAST', 'ROOD', 80, 6, 8, 3.00, 100, 50, 'l'),
(190, 'KIKKERBEET', 'WATER', 'WIT', NULL, 7, 8, 1.25, 100, 50, 'l'),
(470, 'GIPSKRUID', '1-JARIG', 'WIT', 50, 6, 7, 1.00, 100, 50, 'l'),
(327, 'STRUIKHEIDE', 'HEIDE', 'GEMENGD', 30, 6, 8, 2.00, 100, 50, 'l'),
(102, 'JUDASPENING', '2-JARIG', 'LILA', 70, 5, 7, 1.00, 100, 50, 'l'),
(162, 'AZIJNBOOM', 'BOOM', 'ROOD', NULL, 6, 7, 9.50, 100, 50, 'h'),
(335, 'BOOMHEIDE', 'HEIDE', 'ROZE', 150, 7, 9, 5.50, 100, 50, 'l'),
(427, 'KLIMOP', 'KLIM', '', NULL, NULL, NULL, 7.50, 100, 50, 'l'),
(164, 'MARGRIET', 'VAST', 'WIT', 70, 6, 8, 2.50, 100, 50, 'l'),
(320, 'WATERLELIE', 'WATER', 'WIT', NULL, NULL, NULL, 12.00, 100, 50, 'l'),
(89, 'LUPINE', 'VAST', 'GEMENGD', 100, 6, 7, 2.50, 100, 50, 'l'),
(498, 'JENEVERBES', 'BOOM', '', 250, NULL, NULL, 6.50, 100, 50, 'h'),
(312, 'LISDODDE', 'WATER', 'GEEL', 200, 8, 9, 4.50, 100, 50, 'l'),
(361, 'RIDDERSPOOR', '1-JARIG', 'GEMENGD', 50, 7, 8, 1.00, 100, 50, 'l'),
(471, 'OLIJFWILG', 'BOOM', 'GEEL', 400, 9, 10, 10.00, 100, 50, 'h'),
(420, 'GOUDEN REGEN', 'BOOM', 'GEEL', 600, 5, 5, 22.00, 100, 50, 'h'),
(66, 'DWERGCYPRES', 'BOOM', '', 500, NULL, NULL, 13.50, 100, 50, 'h'),
(283, 'WATERHYACINT', 'WATER', 'BLAUW', NULL, 6, 9, 5.00, 100, 50, 'l'),
(486, 'VUURPIJL', 'VAST', 'ROOD', 120, 6, 9, 3.50, 100, 50, 'l'),
(13, 'KRUISDISTEL', 'VAST', 'BLAUW', 75, 6, 7, 3.00, 100, 50, 'l'),
(242, 'ZUURBES', 'HEESTER', 'ORANJE', 300, 5, 6, 3.50, 100, 50, 'l'),
(212, 'RIDDERSPOOR', 'VAST', 'LILA', 150, 6, 7, 3.00, 100, 50, 'l'),
(28, 'LINDE', 'BOOM', 'GEEL', 4000, 7, 8, 42.50, 100, 50, 'h'),
(67, 'GANZERIK', 'VAST', 'ROOD', 25, 6, 9, 2.25, 100, 50, 'l'),
(437, 'MUNT', 'KRUID', 'PAARS', 40, 8, 8, 2.00, 100, 50, 'l'),
(266, 'KORENBLOEM', '1-JARIG', 'GEMENGD', 80, 7, 8, 1.00, 100, 50, 'l'),
(82, 'BEREKLAUW', 'VAST', 'WIT', 100, 7, 9, 3.50, 100, 50, 'l'),
(296, 'PETERSELIE', 'KRUID', '', 25, NULL, NULL, 2.00, 100, 50, 'l'),
(372, 'WOLFSMELK', 'VAST', 'GEEL', 60, 4, 4, 2.50, 100, 50, 'l'),
(95, 'VIOLIER', '1-JARIG', 'GEMENGD', 60, 6, 8, 1.00, 100, 50, 'l'),
(47, 'ZILVERSPAR', 'BOOM', '', 3000, NULL, NULL, 19.50, 100, 50, 'h'),
(469, 'TULP', 'BOL', 'GEEL', 30, 4, 6, 0.40, 100, 50, 'l'),
(300, 'PAMPUSGRAS', 'VAST', 'WIT', 300, 9, 10, 9.50, 100, 50, 'l'),
(175, 'MONNIKSKAP', 'VAST', 'VIOLET', 120, 8, 9, 3.00, 100, 50, 'l'),
(428, 'KALMOES', 'WATER', '', 90, NULL, NULL, 4.50, 100, 50, 'l'),
(316, 'NAGELKRUID', 'VAST', 'ORANJE', 50, 7, 8, 3.00, 100, 50, 'l'),
(117, 'KORNOELJE', 'HEESTER', 'GEEL', 300, 5, NULL, 5.50, 100, 50, 'l'),
(397, 'PEPERBOOMPJE', 'HEESTER', 'ROZE', 125, 2, 3, 15.00, 100, 50, 'l'),
(207, 'ROZEMARIJN', 'KRUID', 'BLAUW', 150, 5, 5, 2.00, 100, 50, 'l'),
(74, 'MUURBLOEM', '2-JARIG', 'BRUIN', 50, 4, 5, 1.80, 100, 50, 'l'),
(462, 'KERVEL', 'KRUID', 'WIT', 30, NULL, NULL, 2.00, 100, 50, 'l'),
(123, 'BEGONIA', '1-JARIG', 'ROOD', 15, 6, 9, 0.65, 100, 50, 'l'),
(184, 'IRIS', 'BOL', 'BLAUW', 100, 5, 7, 0.14, 100, 50, 'l'),
(19, 'VUURDOORN', 'HEESTER', 'WIT', NULL, 6, 6, 5.00, 100, 50, 'l'),
(12, 'SERING', 'BOOM', 'PAARS', 500, 5, 6, 19.50, 100, 50, 'h'),
(1, 'RODONDENDRON', 'HEESTER', 'ROOD', 125, 5, 7, 19.50, 100, 50, 'l'),
(42, 'CYPERGRAS', 'WATER', '', 100, NULL, NULL, 5.00, 100, 50, 'l'),
(332, 'BLAASJESKRUID', 'WATER', 'GEEL', NULL, 7, 8, 2.50, 100, 50, 'l'),
(365, 'DOPHEIDE', 'HEIDE', 'ROOD', 35, 6, 9, 1.50, 100, 50, 'l'),
(2, 'GOUDSBLOEM', 'HEESTER', 'ROSE', 150, 6, 8, 22.50, 1, 1, 'l');

alter table aankoop 
add	Constraint 	fk_aank_klant	foreign key (klcode) references klanten (klcode),
add	Constraint 	fk_aank_plant	foreign key (artcode) references planten(artcode),
add	Constraint 	ck_aank_aantal	check (aantal > 0 );

ALTER TABLE aankopen
add CONSTRAINT fk_aank_kla    FOREIGN KEY (klcode) REFERENCES klanten(klcode);

alter table aankoopreg
add	Constraint 	fk_aankr_aank foreign key	(aankoopnr) references aankopen(aankoopnr),
add	Constraint 	fk_aankr_pla  foreign key	(artcode) references planten(artcode);

alter table offertes
add Constraint 	fk_off_lev	  foreign key	(levcode) references leveranciers(levcode),
add	Constraint 	fk_off_art	  foreign key	(artcode) references planten(artcode);

alter table bestellingen
add	Constraint 	fk_best_lev	  foreign key	(levcode) references leveranciers(levcode);

alter table bestelregels
add	Constraint 	fk_breg_best  foreign key	(bestelnr) references bestellingen(bestelnr),
add	Constraint 	fk_breg_art	  foreign key	(artcode) references planten(artcode);

alter table boekregel
add	Constraint 	fk_boekr_boek	foreign key	(boekstuk) references boeking(boekstuk);

alter table goed_ontvangst
add	Constraint 	fk_gontv_breg	foreign key	(bestelnr,artcode) references bestelregels(bestelnr,artcode),
add	Constraint 	fk_gontv_boekr	foreign key	(boekstuk,vlgnr) references boekregel(boekstuk,vlgnr);

alter table factuur
add	Constraint 	fk_fact_boekr	foreign key	(boekstuk,vlgnr) references boekregel(boekstuk,vlgnr);

alter table levering
add	Constraint 	fk_lever_aankr	foreign key	(aankoopnr,artcode) references aankoopreg(aankoopnr,artcode),
add	Constraint 	fk_lever_fact	foreign key (factnr) references factuur(factnr);


DROP TRIGGER IF EXISTS `plantenlust`.`pre_insert_boekregel`;

DELIMITER $$
USE `plantenlust`$$
CREATE TRIGGER `plantenlust`.`pre_insert_boekregel` 
BEFORE INSERT ON `boekregel` FOR EACH ROW
BEGIN
     SET NEW.vlgnr = (
        SELECT IFNULL(MAX(vlgnr), 0) + 1
        FROM boekregel
        WHERE boekstuk = NEW.boekstuk
     );
END$$
DELIMITER ;


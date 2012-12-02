-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `rubycp`
--

-- --------------------------------------------------------

--
-- Table structure for table `ruby_users`
--

CREATE TABLE IF NOT EXISTS `ruby_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(130) NOT NULL,
  `loginkey` varchar(100) NOT NULL,
  `moderator` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `color` int(11) NOT NULL,
  `head` int(11) NOT NULL,
  `face` int(11) NOT NULL,
  `body` int(11) NOT NULL,
  `feet` int(11) NOT NULL,
  `neck` int(11) NOT NULL,
  `hand` int(11) NOT NULL,
  `flag` int(11) NOT NULL,
  `photo` int(11) NOT NULL,
  `coins` int(11) NOT NULL,
  `registration` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `stamps` text NOT NULL,
  `inventory` text NOT NULL,
  `buddies` text NOT NULL,
  `ignored` text NOT NULL,
  `activated` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `ruby_users`
--

INSERT INTO `ruby_users` (`id`, `username`, `password`, `email`, `loginkey`, `moderator`, `rank`, `color`, `head`, `face`, `body`, `feet`, `neck`, `hand`, `flag`, `photo`, `coins`, `registration`, `stamps`, `inventory`, `buddies`, `ignored`) VALUES
(1, 'Damen', '5f4dcc3b5aa765d61d8327deb882cf99', 'email@email.com', 'd8c78723ea1afd0338a3c8a20105903b', 0, 0, 0, 0, 0, 4034, 0, 0, 0, 0, 0, 0, '2012-12-01 17:46:35', '', '%4034', '', ''),
(2, 'Ruby', '5f4dcc3b5aa765d61d8327deb882cf99', 'email@email.com', '4ec105a12921e5c7a83622ea0a0a1237', 1, 1, 5, 413, 0, 0, 0, 0, 0, 0, 0, 0, '2012-12-01 17:46:42', '', '%4039%413%5', '', '');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

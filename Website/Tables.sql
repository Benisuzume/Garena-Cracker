CREATE TABLE IF NOT EXISTS `garenacracker_accounts` (
  `username` varchar(16) NOT NULL,
  `password` char(32) NOT NULL,
  `expiry_date` datetime NOT NULL,
  `max_users` tinyint(1) NOT NULL,
  `email` varchar(64) NOT NULL,
  `mobile` char(10) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `garenacracker_accounts` (`username`, `password`, `expiry_date`, `max_users`, `email`, `mobile`) VALUES
('finalygamer1', '04fd22b150f68b29a2c54dcdc6315d9b', '2026-12-31 23:59:59', 1, 'elenamtvmtv@gmail.com', '9308303887'),
('finalygamer2', '04fd22b150f68b29a2c54dcdc6315d9b', '2026-12-31 23:59:59', 1, 'elenamtvmtv@gmail.com', '9308303887'),
('finalygamer3', '04fd22b150f68b29a2c54dcdc6315d9b', '2026-12-31 23:59:59', 1, 'elenamtvmtv@gmail.com', '9308303887');

CREATE TABLE IF NOT EXISTS `garenacracker_onlines` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `username` varchar(16) NOT NULL,
  `machine_id` char(32) NOT NULL,
  `last_seen` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

CREATE TABLE IF NOT EXISTS `garenacracker_program` (
  `id` tinyint(1) NOT NULL,
  `version` decimal(2,1) NOT NULL,
  `release_date` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `garenacracker_program` (`id`, `version`, `release_date`) VALUES
(1, '1.0', '1395-08-01');
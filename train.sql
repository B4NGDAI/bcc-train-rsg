CREATE TABLE IF NOT EXISTS `train` (
	`trainid` INT(11) NOT NULL AUTO_INCREMENT,
	`charidentifier` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`trainModel` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`fuel` INT(11) NOT NULL,
	`condition` INT(11) NOT NULL,
    PRIMARY KEY(trainid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
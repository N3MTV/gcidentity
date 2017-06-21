-- Ajoute des champs poour gcIdentity
ALTER TABLE `users`
	ADD COLUMN `nom` varchar(128) NOT NULL DEFAULT '' ,
	ADD COLUMN `prenom` varchar(128) NOT NULL DEFAULT '' ,
	ADD COLUMN `dateNaissance` date DEFAULT '0000-01-01' ,
	ADD COLUMN `sexe` varchar(1) NOT NULL DEFAULT 'f' ,
	ADD COLUMN `taille` int(10) unsigned NOT NULL DEFAULT '0' ;
DROP SCHEMA IF EXISTS `MunfulettoDB`;
CREATE SCHEMA IF NOT EXISTS `MunfulettoDB`;
USE MunfulettoDB;


/*La tabella Utenti specifica le utenze, distinte tra Cuoco, Addetto, Responsabile, Cliente e Fattorino, ognuno caratterizzato da una email e 
da una password memorizzata come digest di SHA-256, un nome ed un cognome*/
CREATE TABLE IF NOT EXISTS Utenti (
	`Email` VARCHAR(64) primary key,
    `Password` CHAR(64) NOT NULL,
    `Tipo` VARCHAR(12) NOT NULL,
    check(Tipo in ('Cuoco', 'Addetto','Responsabile', 'Cliente', 'Fattorino')),
	`Nome` VARCHAR(64) NOT NULL,
	`Cognome` VARCHAR(64) NOT NULL
);


/*La tabella Clienti specifica le caratteristiche di un Cliente registrato, cioè un riferimento alla email di Utenti e la sua data di nascita*/
CREATE TABLE IF NOT EXISTS Clienti (
	`Ref_Email` VARCHAR(64) primary key references Utenti(Email),
    `Data di nascita` DATE NOT NULL
);



/*La tabella Prodotti specifica i vari prodotti disponibili, ad ognuno è associato un id/codice univoco, un nome, un prezzo ed una categoria di 
appartenenza*/
CREATE TABLE IF NOT EXISTS Prodotti (
	`id_prodotto` INT auto_increment primary key,
	`Nome_prodotto` VARCHAR(64) NOT NULL,
    `Prezzo` DECIMAL(10,2) NOT NULL,
    `Categoria` VARCHAR(10) NOT NULL,
    check(Categoria in ('panino','contorno', 'bibita', 'extra'))
);



/*La tabella Ordini specifica gli ordini effettuati dai clienti ed i suoi attributi, quali un id univoco, il codice ritiro (fornito al cliente al momento 
del pagamento dell'ordine) che rappresenta il digest SHA-256 della parola "ORDER-id", l'email del cliente che ha effettuato l'ordine, il numero eventuale di carta con cui si è pagato, la data dell'ordine,
lo stato dell'ordine, suddiviso in "da lavorare","in lavorazione","al banco","completato","domicilio","in consegna","consegnato", ed eventuale
indirizzo di spedizione per ordini da consegnare a domicilio*/
CREATE TABLE IF NOT EXISTS Ordini (
	`id_Ordine` INT auto_increment primary key,
	`Codice_Ritiro` VARCHAR(64) NOT NULL,
	`Email_Ordine` VARCHAR(64) NOT NULL,
    `Numero_Carta` CHAR(16),
    `Data` DATE NOT NULL,
    `Stato` VARCHAR(32) NOT NULL,
    check(Stato in ('da lavorare','in lavorazione', 'al banco', 'completato','domicilio','in consegna', 'consegnato')),
    `Indirizzo di spedizione` VARCHAR(64),
    `Note` VARCHAR(64) 
);


/*La tabella Dettagli_Ordini specifica più nel dettaglio le informazioni riguardanti i vari ordini, comprendendo un id, un numero di ordine con riferimento
al numero di ordine di Ordini, un codice prodotto con riferimento a id di Prodotti ed infine, delle opzionali note per l'ordine*/
CREATE TABLE IF NOT EXISTS Dettagli_Ordini (
	`id` INT auto_increment primary key,
    `Ref_Ordine` INT references Ordini(id_Ordine),
    `Ref_Prodotto` INT references Prodotti(id_prodotto)
);


/*La tabella Tempistica_Ordini specifica gli istanti di tempo in cui un ordine identificato con un numero di ordine in riferimento a Ordini,
cambia il proprio stato, tra quelli possibili. Ad ogni record sarà associato un id ed un timestamp. La tabella verrà utilizzata a 
fini statistici per il calcolo delle tempistiche medie delle operazioni sugli ordini*/
CREATE TABLE IF NOT EXISTS Tempistica_Ordini(
	`Ref_Ordine` INT references Ordini(id_Ordine),
    `Stato` VARCHAR(32) NOT NULL,
     check(Stato in ('da lavorare','in lavorazione', 'al banco', 'completato','domicilio','in consegna', 'consegnato')),
	`Timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     primary key (`Ref_Ordine`,`Stato`)
);






/*POPOLAZIONE DEL DB*/

/*Utenti*/
insert into Utenti values 
('mario.rossi@gmail.com','1729ec9149d3d2af04ee1838ce459779c1aa95cc73056d21dc25595b6ef97fa0','Cuoco','Mario','Rossi'),
('carlo.bianchi@yahoo.com','183bfe8cb6071dfbd18566dd4a8e3c023655c32faeb23fcf3f2bb619192774ce','Addetto','Carlo','Bianchi'),
('ilenia.munfuletto@gmail.com','f490f8a773722db6aac81ff0a59e3ae4faf490efb8c31432bc848a51e39370ca','Responsabile','Ilenia','Munfuletto'),
('vincenzo.fardella@gmail.com','57b964e6e581f68c6784e1bdf6417456a150fbb6721165600e71d3815f7ae095','Cliente','Vincenzo','Fardella'),
('federica.purpuri@gmail.com','2008d8607765a2b1c97dc787291b1c3f4528fa1737f13d0d08d92095d1229fc9','Fattorino','Federica','Purpuri'),
('rosario.piro@outlook.it','5ae4e2152f48a668a76159afbfeef252413730622a0d4abc68ea7bca1cc889ae','Cuoco','Rosario','Piro'),

('isabella.turano@outlook.it','78949be0ab24e5ee7db025c79e5200c7c586bcd3b75a204031a201a6932900c3','Addetto','Isabella','Turano'),
('salvatore.benigno@hotmail.it','90f8650a4b84968dae63482807e92ab22e834901f4463b5cab1a361583340d71','Responsabile','Salvatore','Benigno'),
('mattia.acireale@aruba.it','09d3e402698e3be58c0b3ff22fb0ace673be853cf297d21613334d1059ff3d7c','Cliente','Mattia','Acireale'),
('saverio.brignano@libero.it','772752852ce3543b9ec26da5ce747bc783e81b58e4c97268fd4ca78efa5448b7','Fattorino','Saverio','Brignano'),
('antonio.fazio@live.it','200a385b3027531d0338920a97e9fa9fae496e6b290e231574a180c997bf1716','Cliente','Antonio','Fazio');



/*Clienti*/
insert into Clienti values
('vincenzo.fardella@gmail.com','1996-06-21'),
('mattia.acireale@aruba.it','1997-02-12'),
('antonio.fazio@live.it','1990-11-05');




/*Prodotti*/
insert into Prodotti values
(1,'Classico',3.50,'panino'),
(2,'Topolino',2.50,'panino'),
(3,'San Daniele',4.00,'panino'),
(4,'Chicken',4.50,'panino'),
(5,'Vegetariano',5.00,'panino'),
(6,'Messicano',4.50,'panino'),
(7,'Hot Dog',2.50,'panino'),
(8,'Vegano',8.00,'panino'),
(9,'Pistacchioso',7.00,'panino'),
(10,'Studente',5.00,'panino'),
(11,'Acqua',1.00,'bibita'),
(12,'Acqua Frizzante',1.00,'bibita'),
(13,'Coca-Cola',2.00,'bibita'),
(14,'Birra',3.00,'bibita'),
(15,'Patatine',2.50,'contorno'),
(16,'Lattuga',3.00,'contorno'),
(17,'Chicken Nuggets',5.00,'contorno'),
(18,'Pancake Nutella',4.50,'extra'),
(19,'Waffle Nutella',4.50,'extra'),
(20,'Crepes Nutella',4.00,'extra'),
(21,'Cannolo',3.50,'extra');




/*Ordini*/
insert into Ordini values
(1,'c1d05a837876d68892cc978153fac336b25eb84ec265c67a9560c793a2da1d4e','vincenzo.fardella@gmail.com' ,'5333124156782502','2024-04-18','consegnato','Via Saverio Latteri,5','topolino senza salsa'),
(2,'f2569d3017a21fa0b1d91939d35560a9d1a68f5940a32b80b66a9015e27698ab', 'marco.cascio@outlook.it', '3463889012638771', '2024-04-18', 'da lavorare', 'Viale delle Scienze,Ed.6','hot dog con doppia senape'),
(3,'b526b84ccb1648f1fcb4851d224eec3543a6430586b5bcefa1924585f3d81ada', 'luca.rizzo@hotmail.it', NULL, '2024-04-18', 'al banco', NULL,'aggiungere smarties al waffle');



/*Dettagli Ordini*/
insert into Dettagli_Ordini values
(1,1,9),
(2,1,2),
(3,1,13),
(4,2,7),
(5,2,12),
(6,3,19),
(7,3,14);


/*Tempistica Ordini*/
insert into Tempistica_Ordini values
(1,'da lavorare',current_timestamp),
(1,'in lavorazione',addtime(current_timestamp, '00:05:00')),
(1,'domicilio',addtime(current_timestamp, '00:15:00')),
(1,'in consegna',addtime(current_timestamp,'00:17:00')),
(1,'consegnato',addtime(current_timestamp, '00:29:00')),
(2,'da lavorare',current_timestamp),
(3,'da lavorare',current_timestamp),
(3,'in lavorazione',addtime(current_timestamp, '00:04:00')),
(3,'al banco',addtime(current_timestamp, '00:34:00')),
(3,'completato',addtime(current_timestamp, '00:40:00'));






1. Kreirati bazu podataka koju cete imenovati Vašim brojem dosijea. Fajlove baze smjestiti na sljedece lokacije:
? Data fajl -> D:\DBMS\Data
? Log fajl -> D:\DBMS\Log
2. U bazi podataka kreirati sljedece tabele:
a. Klijenti
? JMBG, polje za unos 13 karaktera (obavezan unos i jedinstvena vrijednost),
? Ime, polje za unos 30 karaktera (obavezan unos),
? Prezime, polje za unos 30 karaktera (obavezan unos),
? Adresa, polje za unos 100 karaktera (obavezan unos),
? Telefon, polje za unos 20 karaktera (obavezan unos),
? Email, polje za unos 50 karaktera (jedinstvena vrijednost),
? Kompanija, polje za unos 50 karaktera.
b. Krediti
? Datum, polje za unos datuma (obavezan unos),
? Namjena, polje za unos 50 karaktera (obavezan unos),
? Iznos, polje za decimalnog broja (obavezan unos),
? BrojRata, polje za unos cijelog broja (obavezan unos),
? Osiguran, polje za unos bit vrijednosti (obavezan unos),
? Opis, polje za unos dužeg niza karaktera.
c. Otplate
? Datum, polje za unos datuma (obavezan unos)
? Iznos, polje za unos decimalnog broja (obavezan unos),
? Rata, polje za unos cijelog broja (obavezan unos),
? Opis, polje za unos dužeg niza karaktera.
Napomena: Klijent može uzeti više kredita, dok se kredit veže iskljucivo za jednog klijenta. Svaki kredit može imati više otplata
 (otplata rata).
*/

CREATE DATABASE testnaa ON PRIMARY
(
Name='ispitData.mdf',
FILENAME='C:\BP2\Data\ispit_data.mdf',
SIZE=100 MB,
MAXSIZE=UNLIMITED,
FILEGROWTH=20%
)
LOG ON
(
Name='ispitLog.ldf',
FILENAME='C:\BP2\Log\ispit_log.ldf',
SIZE=100 MB,
MAXSIZE=UNLIMITED,
FILEGROWTH=20%
)

USE testnaa
GO


CREATE TABLE Klijenti
(
KlijentID INT NOT NULL CONSTRAINT PK_KlijentID PRIMARY KEY(KlijentID) IDENTITY(1,1),
JMBG NVARCHAR(13) NOT NULL CONSTRAINT UQ_JMBG UNIQUE,
Ime NVARCHAR(30) NOT NULL,
Prezime NVARCHAR(30) NOT NULL,
Adresa NVARCHAR(100) NOT NULL,
Telefon NVARCHAR(20) NOT NULL,
Email NVARCHAR(50) NOT NULL CONSTRAINT UQ_Email UNIQUE,
Kompanija NVARCHAR(50) NULL
)

CREATE TABLE Krediti
(
KreditID INT NOT NULL CONSTRAINT PK_KreditID PRIMARY KEY(KreditID) IDENTITY(1,1),
KlijentID INT NOT NULL CONSTRAINT FK_KlijentID FOREIGN KEY(KlijentID) REFERENCES Klijenti(KlijentID),
Datum DATETIME NOT NULL,
Namjena NVARCHAR(50) NOT NULL,
Iznos DECIMAL(18,2) NOT NULL,
BrojRata INT NOT NULL,
Osiguran BIT NOT NULL,
Opis nvarchar(max)
)

CREATE TABLE Otplate
(
OtplataID INT NOT NULL CONSTRAINT PK_OtplataID PRIMARY KEY(OtplataID) IDENTITY(1,1),
KreditID INT NOT NULL CONSTRAINT FK_KreditDI FOREIGN KEY(KreditID) REFERENCES Krediti(KreditID),
Datum DATETIME NOT NULL,
Iznos DECIMAL(18,2) NOT NULL,
Rata INT NOT NULL,
Opis NVARCHAR(MAX)
)

-- import podataka
/*
3. Koristeci AdventureWorks2014 bazu podataka, importovati 10 kupaca u tabelu Klijenti i to sljedece kolone:
a. Zadnjih 13 karaktera kolone rowguid (Crticu '-' zamijeniti brojem 1)-> JMBG,
b. FirstName (Person) -> Ime,
c. LastName (Person) -> Prezime,
d. AddressLine1 (Address) -> Adresa,
e. PhoneNumber (PersonPhone) -> Telefon,
f. EmailAddress (EmailAddress) -> Email,
g. 'FIT' -> Kompanija
Takoder, u tabelu Krediti unijeti minimalno tri zapisa sa proizvoljnim podacima.
*/


INSERT INTO Klijenti(JMBG,Ime,Prezime,Adresa,Telefon,Email,Kompanija)
SELECT TOP 10 RIGHT(REPLACE(C.rowguid,'-','1'),13),PP.FirstName,PP.LastName,A.AddressLine1,PPP.PhoneNumber,EA.EmailAddress,'FIT'
FROM AdventureWorks2014.Person.Person AS PP INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA
	ON PP.BusinessEntityID=EA.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.PersonPhone AS PPP
	ON PP.BusinessEntityID=PPP.BusinessEntityID
INNER JOIN AdventureWorks2014.Sales.Customer AS C
	ON PP.BusinessEntityID=C.PersonID
INNER JOIN AdventureWorks2014.Person.BusinessEntityAddress AS BEA
	ON PP.BusinessEntityID=BEA.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.Address AS A
	ON BEA.AddressID=A.AddressID

SELECT * FROM Klijenti

--krediti

INSERT INTO Krediti(KlijentID,Datum,Namjena,Iznos,BrojRata,Osiguran,Opis)
VALUES
(1,SYSDATETIME(),'ONAKO',550,4,1,'bezveze opis'),
(5,SYSDATETIME(),'za kucu',250000,15,0,'kratak opis 2'),
(4,SYSDATETIME(),'za auto',2550,10,1,'bezveze opis 3')

select * from Krediti

--procedura za upis
/*
4. Kreirati stored proceduru koja ce na osnovu proslijedenih parametara služiti za unos podataka u tabelu Otplate.
 Proceduru pohraniti pod nazivom usp_Otplate_Insert. Obavezno testirati ispravnost kreirane procedure (unijeti minimalno 5 zapisa sa 
 proizvoljnim podacima).
*/

GO
CREATE PROCEDURE usp_Otplate_Insert
(
@KreditID INT,
@Datum DATE,
@Iznos DECIMAL,
@Rata INT,
@Opis NVARCHAR(MAX)
)
AS
BEGIN
	INSERT INTO Otplate(KreditID,Datum,Iznos,Rata,Opis)
	VALUES(@KreditID,@Datum,@Iznos,@Rata,@Opis)
END


EXEC usp_Otplate_Insert 1,'2019-06-13',20,1,'Prva rata'

EXEC usp_Otplate_Insert 1,'2017-09-25',20,2,'druga rata'

EXEC usp_Otplate_Insert 1,'2019-05-10',150,3,'Prva rata'

EXEC usp_Otplate_Insert 1,'2018-01-01',522,3,'Prva rata'

EXEC usp_Otplate_Insert 1,'2017-06-13',450,2,'treca rata'

/*
5. Kreirati view (pogled) nad podacima koji ce prikazivati sljedeca polja: jmbg, ime i prezime, adresa, telefon i email klijenta,
 zatim datum, namjenu i iznos kredita, te ukupan broj otplacenih rata i ukupan otplaceni iznos.
  View pohranite pod nazivom view_Krediti_Otplate.
*/

GO
CREATE VIEW view_Krediti_Otplate 
AS
	SELECT K.JMBG,K.Ime+' '+K.Prezime AS 'Ime i prezime',K.Adresa,K.Telefon,K.Email,KRED.Datum,KRED.Namjena,
	       KRED.Iznos,SUM(O.Rata) AS 'Ukupan broj rata',SUM(O.Iznos) AS 'Ukupan broj otplata'
	FROM Klijenti AS K INNER JOIN Krediti AS KRED
		ON K.KlijentID=KRED.KlijentID
	INNER JOIN Otplate AS O 
		ON KRED.KreditID=O.KreditID
	GROUP BY K.JMBG,K.Ime+' '+K.Prezime,K.Adresa,K.Telefon,K.Email,KRED.Datum,KRED.Namjena,KRED.Iznos	 


SELECT * FROM view_Krediti_Otplate
GO

/*6. Kreirati stored proceduru koja ce na osnovu proslijedenog parametra @JMBG prikazivati podatke o otplati kredita.
 Kao izvor podataka koristiti prethodno kreirani view. Proceduru pohraniti pod nazivom usp_Krediti_Otplate_SelectByJMBG. Obavezno testirati ispravnost kreirane procedure.
*/

CREATE PROCEDURE usp_Krediti_Otplate_SelectByJMBG
(
@JMBG NVARCHAR(13)
)
AS
BEGIN
	SELECT *
	FROM view_Krediti_Otplate
	WHERE JMBG LIKE @JMBG
END


EXEC usp_Krediti_Otplate_SelectByJMBG '1FCEEC2800540'

-- posto je ovo i jedini zapis unutar viewa uzeo sam taj JMBG i radi


/*
7. Kreirati proceduru koja ce služiti za izmjenu podataka o otplati kredita. Proceduru pohraniti pod nazivom usp_Otplate_Update.
 Obavezno testirati ispravnost kreirane procedure.
*/

GO
CREATE PROCEDURE usp_Otplate_Update
(
@KreditID INT,
@Datum DATE,
@Iznos DECIMAL,
@Rata INT,
@Opis NVARCHAR(MAX)
)
AS
BEGIN
	UPDATE Otplate
	SET Datum=@Datum,Iznos=@Iznos,Rata=@Rata,Opis=@Opis
	WHERE KreditID LIKE @KreditID
END

SELECT * FROM Otplate

EXEC usp_Otplate_Update 1,'2019-06-14',11,1,'Update opis'


/*
8. Kreirati stored proceduru koja ce služiti za brisanje kredita zajedno sa svim otplatama.
 Proceduru pohranite pod nazivom usp_Krediti_Delete. Obavezno testirati ispravnost kreirane procedure.
*/

GO
CREATE PROCEDURE usp_Otplate_Delete
(
@KreditID INT
)
AS
BEGIN
	DELETE FROM Krediti
	WHERE KreditID =(SELECT KreditID FROM Otplate WHERE KreditID=@KreditID)
	
	DELETE FROM Otplate
	WHERE KreditID=KreditID
END

SELECT * FROM Krediti

EXEC usp_Otplate_Delete 3
GO 

--9 TRIGGER
/*
9. Kreirati trigger koji ce sprijeciti brisanje zapisa u tabeli Otplate.
 Trigger pohranite pod nazivom tr_Otplate_IO_Delete. Obavezno testirati ispravnost kreiranog triggera.
*/

CREATE TRIGGER t_Otplate_IO_Delete
ON Otplate
FOR DELETE
AS
BEGIN
SELECT 'Ne mozes obrisat zapise iz tabele Otplate !'
ROLLBACK TRANSACTION
END

DELETE  FROM Otplate
 
-- BACKUP BAZE 
/*
10. Uraditi full backup Vaše baze podataka na lokaciju D:\DBMS\Backup.
*/

backup database novaBaza2
to disk ='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\novaBaza2.bak'

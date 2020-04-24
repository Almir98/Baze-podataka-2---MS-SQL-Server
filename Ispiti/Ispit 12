CREATE DATABASE Julski2017 ON
(
NAME='Julski2017.mdf',
FILENAME='C:\BP2\Data\Julski_data.mdf',
SIZE=200 MB,
MAXSIZE=UNLIMITED,
FILEGROWTH=15%
)
LOG ON
(
NAME='Julski2017.ndf',
FILENAME='C:\BP2\Log\Julski.ndf',
SIZE=200 MB,
MAXSIZE=UNLIMITED,
FILEGROWTH=15%
)
GO

USE Julski2017

--1

CREATE TABLE Proizvodi
(
ProizvodID INT NOT NULL CONSTRAINT PK_ProizvodID PRIMARY KEY(ProizvodID) IDENTITY(1,1),
Sifra NVARCHAR(25) NOT NULL CONSTRAINT UQ_Sifra UNIQUE,
Naziv NVARCHAR(50) NOT NULL,
Kategorija NVARCHAR(50) NOT NULL,
Cijena DECIMAL(10,2) NOT NULL
)

CREATE TABLE Narudzbe
(
NarudzbaID INT CONSTRAINT PK_NarudzbaID PRIMARY KEY(NarudzbaID),
BrojNarudzbe NVARCHAR(25) NOT NULL CONSTRAINT UQ_BrojNarudzbe UNIQUE,
Datum DATETIME NOT NULL,
Ukupno DECIMAL(10,2) NOT NULL
)

CREATE TABLE StavkeNarudzbe
(
ProizvodID INT CONSTRAINT FK_Stavke_ProizvodID FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
NarudzbaID INT CONSTRAINT FK_Stavke_NarudzbaID FOREIGN KEY(NarudzbaID) REFERENCES Narudzbe(NarudzbaID),
PRIMARY KEY(ProizvodID,NarudzbaID),
Kolicina INT NOT NULL,
Cijena DECIMAL(10,2) NOT NULL,
Popust DECIMAL(10,2) NOT NULL,
Iznos DECIMAL(10,2) NOT NULL
)

--2

SET IDENTITY_INSERT Proizvodi ON

INSERT INTO Proizvodi(ProizvodID,Sifra,Naziv,Kategorija,Cijena)
SELECT DISTINCT PP.ProductID,PP.ProductNumber,PP.Name,PC.Name,PP.ListPrice
FROM AdventureWorks2014.Production.Product AS PP INNER JOIN AdventureWorks2014.Production.ProductSubcategory AS PPS
	ON PP.ProductSubcategoryID=PPS.ProductSubcategoryID
INNER JOIN AdventureWorks2014.Production.ProductCategory AS PC
	ON PPS.ProductCategoryID=PC.ProductCategoryID
INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail AS SOD
	ON PP.ProductID=SOD.ProductID
INNER JOIN AdventureWorks2014.Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID =SOH.SalesOrderID
WHERE YEAR(SOH.OrderDate)=2014

SET IDENTITY_INSERT  Proizvodi OFF

--b

INSERT INTO Narudzbe(NarudzbaID,BrojNarudzbe,Datum,Ukupno)
SELECT SOH.SalesOrderID,SOH.SalesOrderNumber,SOH.OrderDate,SOH.TotalDue
FROM AdventureWorks2014.Sales.SalesOrderHeader AS SOH
WHERE YEAR(SOH.OrderDate)=2014

--c

INSERT INTO StavkeNarudzbe(ProizvodID,NarudzbaID,Kolicina,Cijena,Popust,Iznos)
SELECT SOD.ProductID,SOD.SalesOrderID,SOD.OrderQty,SOD.UnitPrice,SOD.UnitPriceDiscount,SOD.LineTotal
FROM AdventureWorks2014.Sales.SalesOrderDetail AS SOD INNER JOIN AdventureWorks2014.Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID=SOH.SalesOrderID
WHERE YEAR(SOH.OrderDate)=2014


CREATE TABLE Skladista
(
SkladisteID INT NOT NULL CONSTRAINT PK_SkladistaID PRIMARY KEY(SkladisteID),
Naziv NVARCHAR(100) NOT NULL
)


CREATE TABLE ProizvodiSkladista
(
ProizvodID INT CONSTRAINT FK_ProizvodSkladiste_ProizvodID FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
SkladisteID INT CONSTRAINT FK_ProizvodSkladiste_SkladistaID FOREIGN KEY(SkladisteID) REFERENCES Skladista(SkladisteID),
CONSTRAINT PK_ProizvodiSkladista PRIMARY KEY(ProizvodID,SkladisteID),
Kolicina INT DEFAULT 0 
)

--5

INSERT INTO Skladista(SkladisteID,Naziv)
VALUES(1,'Skladiste1'),
(2,'Skladiste2'),
(3,'Skladiste3')


--6

GO
CREATE PROCEDURE izmjena
(
@ProizvodID INT,
@SkladisteID INT,
@Kolicina INT
)
AS
BEGIN
	UPDATE ProizvodiSkladista
	SET Kolicina+=@Kolicina
	WHERE ProizvodID=@ProizvodID AND SkladisteID=@SkladisteID
END

SELECT *  from Proizvodi

EXEC izmjena 877,1,100

SELECT * FROM ProizvodiSkladista

--7

CREATE NONCLUSTERED INDEX IX_Sifra_Naziv
ON Proizvodi(Sifra,Naziv)
go

select Sifra,Naziv
from Proizvodi

--8

GO
CREATE TRIGGER zabranaBrisanja
on Proizvodi
INSTEAD OF DELETE
AS
BEGIN
	print' ne mozes brisat'
	ROLLBACK TRANSACTION
END

SELECT * FROM Proizvodi

DELETE FROM Proizvodi
WHERE ProizvodID=707


--8

/*
9.	Kreirati view koji prikazuje sljedece kolone: šifru, naziv i cijenu proizvoda, 
ukupnu prodanu kolicinu i ukupnu zaradu od prodaje
*/

GO
CREATE VIEW pregled 
AS
SELECT P.Sifra,P.Naziv,P.Cijena,SUM(SN.Kolicina) AS 'Ukupna kol',SUM(N.Ukupno) AS 'Ukupna suma'
FROM Proizvodi AS P INNER JOIN StavkeNarudzbe AS SN
	ON P.ProizvodID=SN.ProizvodID
INNER JOIN Narudzbe AS N
	ON SN.NarudzbaID=N.NarudzbaID
GROUP BY P.Sifra,P.Naziv,P.Cijena

select * from pregled

--10


/*
10.	Kreirati uskladištenu proceduru koja ce za unesenu šifru proizvoda prikazivati ukupnu prodanu
kolicinu i ukupnu zaradu. Ukoliko se ne unese šifra proizvoda procedura treba da prikaže prodaju 
svih proizovda. U proceduri koristiti prethodno kreirani view.	
*/

GO
CREATE PROCEDURE prikaz
(
@Sifra nvarchar(25)=null
)
AS
BEGIN
	SELECT SUM([Ukupna kol]),SUM([Ukupna suma])
	FROM pregled
	WHERE (Sifra LIKE @Sifra) OR (@Sifra IS NULL) 
END

SELECT * FROM pregled

EXEC prikaz 'HL-U509-R'
GO


/*
11.	U svojoj bazi podataka kreirati novog korisnika za login student te mu dodijeliti odgovarajucu 
permisiju kako bi mogao izvršavati prethodno kreiranu proceduru.
*/

CREATE LOGIN studen 
WITH PASSWoRD='student123'
go

CREATE USER Niho FOR LOGIN studen

/*
12.	Napraviti full i diferencijalni backup baze podataka na lokaciji D:\BP2\Backup	 
*/

BACKUP DATABASE Julski2017 
TO DISK='C:\BP2\Backup'
GO

BACKUP DATABASE Julski2017 
TO DISK='C:\BP2\Backup'
WITH DIFFERENTIAL
GO

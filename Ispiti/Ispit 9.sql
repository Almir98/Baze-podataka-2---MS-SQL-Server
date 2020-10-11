CREATE DATABASE int2017
go

use int2017
go

CREATE TABLE Proizvodi
(
ProizvodID INT NOT NULL CONSTRAINT PK_ProizvodID PRIMARY KEY(ProizvodID) IDENTITY(1,1),
Sifra NVARCHAR(25) NOT NULL CONSTRAINT UQ_Sifra UNIQUE,
Naziv NVARCHAR(50) NOT NULL,
Kategorija NVARCHAR(50) NOT NULL,
Cijena DECIMAL(15,2) NOT NULL
)

CREATE TABLE Narudzbe
(
NarudzbaID INT NOT NULL CONSTRAINT PK_NarudzbaID PRIMARY KEY(NarudzbaID),
BrojNarudzbe NVARCHAR(25) NOT NULL CONSTRAINT UQ_BrojNarudzbe UNIQUE,
Datum DATETIME NOT NULL,
Ukupno DECIMAL(15,2) NOT NULL
)

CREATE TABLE StavkeNarudzbe
(
ProizvodID INT NOT NULL CONSTRAINT FK_StavkeNarudzbe_ProizvodID FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
NarudzbaID INT NOT NULL CONSTRAINT FK_StavkeNarudzbe_NarudzbaID FOREIGN KEY(NarudzbaID) REFERENCES Narudzbe(NarudzbaID),
Kolicina INT NOT NULL,
Cijena DECIMAL(15,2) NOT NULL,
Popust DECIMAL(15,2) NOT NULL,
Iznos DECIMAL(15,2) NOT NULL,
)


ALTER TABLE StavkeNarudzbe
DROP CONSTRAINT FK_StavkeNarudzbe_ProizvodID

ALTER TABLE StavkeNarudzbe
WITH CHECK ADD CONSTRAINT FK_StavkeNarudzbe_ProizvodID FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID)
GO

--3 insertovanje zapisa

/*
3.	Iz baze podataka AdventureWorks2014 u svoju bazu podataka prebaciti sljedece podatke:
a)	U tabelu Proizvodi dodati sve proizvode koji su prodavani u 2014. godini
i.	ProductNumber -> Sifra
ii.	Name -> Naziv
iii.	ProductCategory (Name) -> Kategorija
iv.	ListPrice -> Cijena
b)	U tabelu Narudzbe dodati sve narudžbe obavljene u 2014. godini
i.	SalesOrderNumber -> BrojNarudzbe
ii.	OrderDate - > Datum
iii.	TotalDue -> Ukupno
c)	U tabelu StavkeNarudzbe prebaciti sve podatke o detaljima narudžbi uradenih u 2014. godini
i.	OrderQty -> Kolicina
ii.	UnitPrice -> Cijena
iii.	UnitPriceDiscount -> Popust
iv.	LineTotal -> Iznos 
	Napomena: Zadržati identifikatore zapisa!	
*/


/*
a)	U tabelu Proizvodi dodati sve proizvode koji su prodavani u 2014. godini
i.	ProductNumber -> Sifra
ii.	Name -> Naziv
iii.	ProductCategory (Name) -> Kategorija
iv.	ListPrice -> Cijena
*/


SET IDENTITY_INSERT Proizvodi On

INSERT INTO Proizvodi(ProizvodID,Sifra,Naziv,Kategorija,Cijena)
SELECT DISTINCT P.ProductID,P.ProductNumber,P.Name,PC.Name,P.ListPrice
FROM AdventureWorks2014.Production.Product AS P INNER JOIN AdventureWorks2014.Production.ProductSubcategory AS PPS
	ON P.ProductSubcategoryID=PPS.ProductSubcategoryID
INNER JOIN AdventureWorks2014.Production.ProductCategory AS PC
	ON PPS.ProductCategoryID=PC.ProductCategoryID
INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail AS SOD 
	ON P.ProductID=SOD.ProductID
INNER JOIN AdventureWorks2014.Sales.SalesOrderHeader AS SOH
	ON SOH.SalesOrderID=SOD.SalesOrderID
WHERE YEAR(SOH.OrderDate)=2014

SET IDENTITY_INSERT Proizvodi OFF

--b

/*
b)	U tabelu Narudzbe dodati sve narudžbe obavljene u 2014. godini
i.	SalesOrderNumber -> BrojNarudzbe
ii.	OrderDate - > Datum
iii.	TotalDue -> Ukupno
*/

INSERT INTO Narudzbe(NarudzbaID,BrojNarudzbe,Datum,Ukupno)
SELECT DISTINCT SOH.SalesOrderID,SOH.SalesOrderNumber,SOH.OrderDate,SOH.TotalDue
FROM AdventureWorks2014.Sales.SalesOrderHeader AS SOH
WHERE YEAR(SOH.OrderDate)=2014


--c

/*
c)	U tabelu StavkeNarudzbe prebaciti sve podatke o detaljima narudžbi uradenih u 2014. godini
i.	OrderQty -> Kolicina
ii.	UnitPrice -> Cijena
iii.	UnitPriceDiscount -> Popust
iv.	LineTotal -> Iznos 
*/

INSERT INTO StavkeNarudzbe
SELECT SOD.ProductID,SOH.SalesOrderID,SOD.OrderQty,SOD.UnitPrice,SOD.UnitPriceDiscount,SOD.LineTotal
FROM AdventureWorks2014.Sales.SalesOrderHeader AS SOH INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
WHERE YEAR(SOH.OrderDate)=2014


--4

/*
4.	U svojoj bazi podataka kreirati novu tabelu Skladista sa poljima SkladisteID i Naziv, 
a zatim je povezati sa tabelom Proizvodi u relaciji više prema više. Za svaki proizvod na 
skladištu je potrebno cuvati kolicinu (cjelobrojna vrijednost).	 
*/


CREATE TABLE Skladista
(
SkladistaID INT NOT NULL CONSTRAINT PK_SkladistaID PRIMARY KEY(SkladistaID) IDENTITY(1,1),
Naziv NVARCHAR(50)NOT NULL 
)

CREATE TABLE SkladistaProizvodi
(
SkladistaID INT CONSTRAINT FK_SkladistaProizvodi_SkladistaID FOREIGN KEY(SkladistaID) REFERENCES Skladista(SkladistaID),
ProizvodID INT NOT NULL CONSTRAINT FK_SKladistaProizvodi_ProizvodID FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
Kolicina INT DEFAULT 0
)

/*
5.	U tabelu Skladista  dodati tri skladišta proizvoljno, a zatim za sve proizvode na svim skladištima postaviti kolicinu na 0 komada.
*/
INSERT INTO Skladista
VALUES ('Skladiste1'),
	   ('Skladiste2'),
	   ('Skladiste3')

/*
6.	Kreirati uskladištenu proceduru koja vrši izmjenu stanja skladišta (kolicina). 
Kao parametre proceduri proslijediti identifikatore proizvoda i skladišta, te kolicinu.
*/


GO
CREATE PROCEDURE izmjena
(
@ProizvodID INT,
@SkladisteID INT,
@Kolicina INT 
)
AS
BEGIN
	UPDATE SkladistaProizvodi
	SET Kolicina+=@Kolicina
	WHERE ProizvodID=@ProizvodID AND SkladistaID=@SkladisteID 
END

/*
7.	Nad tabelom Proizvodi kreirati non-clustered indeks nad poljima Sifra i Naziv, 
a zatim napisati proizvoljni upit koji u potpunosti iskorištava kreirani indeks. 
Upit obavezno mora sadržavati filtriranje podataka.
*/

CREATE NONCLUSTERED INDEX IX_INDEKS
ON Proizvodi(Sifra,Naziv)

select Sifra,Naziv
from Proizvodi


/*
8.	Kreirati trigger koji ce sprijeciti brisanje zapisa u tabeli Proizvodi.	
*/

GO
CREATE TRIGGER zabranaBrisanja
on Proizvodi
INSTEAD OF DELETE
AS
BEGIN
	print' ne mozes brisat'
	ROLLBACK TRANSACTION
END

DELETE  FROM Proizvodi

--9

/*
9.	Kreirati view koji prikazuje sljedece kolone: šifru, naziv i cijenu proizvoda, 
ukupnu prodanu kolicinu i ukupnu zaradu od prodaje
*/

GO
CREATE VIEW pregled
AS
	SELECT P.Sifra,P.Naziv,P.Cijena,SUM(SN.Kolicina) AS 'Ukupna kolicina',SUM(N.Ukupno) AS 'Zarada'
	FROM Proizvodi AS P INNER JOIN StavkeNarudzbe AS SN
		ON P.ProizvodID=SN.ProizvodID
	INNER JOIN Narudzbe AS N
		ON SN.NarudzbaID=N.NarudzbaID
GROUP BY P.Sifra,P.Naziv,P.Cijena


SELECT * FROM pregled

--10

/*
10.	Kreirati uskladištenu proceduru koja ce za unesenu šifru proizvoda prikazivati ukupnu prodanu
kolicinu i ukupnu zaradu. Ukoliko se ne unese šifra proizvoda procedura treba da prikaže prodaju 
svih proizovda. U proceduri koristiti prethodno kreirani view.	
*/

GO
CREATE PROCEDURE vicemo
(
@sifra nvarchar(25)=null
)
as
begin
	SELECT P.[Ukupna kolicina],P.Zarada
	FROM pregled AS P 
	WHERE (P.Sifra LIKE @sifra) OR @sifra IS NULL 
end

EXEC vicemo 'CA-1098'

--11

/*
11.	U svojoj bazi podataka kreirati novog korisnika za login student te mu dodijeliti odgovarajucu 
permisiju kako bi mogao izvršavati prethodno kreiranu proceduru.
*/

-- kreiranje logina i usera

create login student with password = 'neki'

create user noviUser for login student


/*
12.	Napraviti full i diferencijalni backup baze podataka na lokaciji D:\BP2\Backup	 
*/

backup database test 
to disk = 'C:\DB_Backup\IB160111_9_full.bak'

backup database test 
to disk = 'C:\DB_Backup\IB160111_9_diff.bak'
with differential

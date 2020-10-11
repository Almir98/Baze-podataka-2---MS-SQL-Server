    
/*1. Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. 
U postupku kreiranja u obzir uzeti samo DEFAULT postavke.
Unutar svoje baze podataka kreirati tabelu sa sljedecom strukturom:

a) Proizvodi:
I. ProizvodID, automatski generatpr vrijednosti i primarni kljuc
II. Sifra, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
III. Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
IV. Cijena, polje za unos decimalnog broja (obavezan unos)

b) Skladista
I. SkladisteID, automatski generator vrijednosti i primarni kljuc
II. Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
III. Oznaka, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
IV. Lokacija, polje za unos 50 UNICODE karaktera (obavezan unos)


c) SkladisteProizvodi
I) Stanje, polje za unos decimalnih brojeva (obavezan unos)
Napomena: Na jednom skladištu može biti uskladišteno više proizvoda, dok isti proizvod može biti
uskladišten na više razlicitih skladišta. 
Onemoguciti da se isti proizvod na skladištu može pojaviti više puta.
10 bodova*/


CREATE DATABASE testna
go

use testna
go

CREATE TABLE PROIZVODI
(
ProizvodID INT NOT NULL CONSTRAINT PK_ProizvodID PRIMARY KEY(ProizvodID) IDENTITY(1,1),
Sifra NVARCHAR(10) NOT NULL CONSTRAINT UQ_Sifra UNIQUE,
Naziv NVARCHAR(50) NOT NULL,
Cijena DECIMAL(15,2) NOT NULL
)

CREATE TABLE Skladista
(
SkladisteID INT NOT NULL CONSTRAINT PK_SkladisteID PRIMARY KEY(SkladisteID) IDENTITY(1,1),
Naziv NVARCHAR(50) NOT NULL,
Oznaka NVARCHAR(10) NOT NULL CONSTRAINT UQ_Oznaka UNIQUE,
Lokacije NVARCHAR(50) NOT NULL
)


CREATE TABLE SkladisteProizvodi
(
ProizvodID INT CONSTRAINT FK_SkladisteProizvodi_ProizvodID FOREIGN KEY(ProizvodID) REFERENCES PROIZVODI(ProizvodID),
SkladisteID INT CONSTRAINT FK_SkladisteProizvodi_SkladisteID FOREIGN KEY(SkladisteID) REFERENCES Skladista(SkladisteID),
Stanje decimal(15,2) not null
)

alter table SkladisteProizvodi
DROP CONSTRAINT FK_SkladisteProizvodi_SkladisteID

ALTER TABLE SkladisteProizvodi
WITH CHECK ADD CONSTRAINT FK_SkladisteProizvodi_SkladisteID FOREIGN KEY(SkladisteID) REFERENCES Skladista(SkladisteID)
GO

/*2. Popunjavanje tabela podacima
a) Putem INSERT komande u tabelu Skladista dodati minimalno 3 skladišta.
c) Putem INSERT i SELECT komandi u tabelu SkladisteProizvodi za sva dodana skladista
importovati sve proizvode tako da stanje bude 100
10 bodova*/

/*2a)*/

INSERT INTO Skladista
VALUES ('Skladiste1','sk1','Bugojno'),
('Skladiste2','sk2','Mostar'),
('Skladiste3','sk3','Sarajevo')

/*2b)
b) Koristeci bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati
10 najprodavanijih bicikala (kategorija proizvoda 'Bikes' i to sljedece kolone:
I. Broj proizvoda (ProductNumber) - > Sifra,
II. Naziv bicikla (Name) -> Naziv,
III. Cijena po komadu (ListPrice) -> Cijena,
*/

INSERT INTO PROIZVODI(Sifra,Naziv,Cijena)
SELECT TOP 10 P.ProductNumber,P.Name,P.ListPrice
FROM AdventureWorks2014.Production.Product AS P INNER JOIN AdventureWorks2014.Production.ProductSubcategory AS PPS
	ON P.ProductSubcategoryID=PPS.ProductSubcategoryID
INNER JOIN AdventureWorks2014.Production.ProductCategory AS PPC
	ON PPS.ProductCategoryID=PPC.ProductCategoryID
INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail AS SOD
	ON P.ProductID=SOD.ProductID
WHERE PPC.Name LIKE '%Bikes%'
GROUP BY P.ProductNumber,P.Name,P.ListPrice 
ORDER BY SUM(SOD.OrderQty) DESC


/*2c)
c) Putem INSERT i SELECT komandi u tabelu SkladisteProizvodi za sva dodana skladista
importovati sve proizvode tako da stanje bude 100
*/


INSERT INTO SkladisteProizvodi(ProizvodID, SkladisteID, Stanje)
SELECT TOP 100 ProizvodID, 1, 100
FROM PROIZVODI

INSERT INTO SkladisteProizvodi(ProizvodID, SkladisteID, Stanje)
SELECT TOP 100 ProizvodID, 2, 100
FROM PROIZVODI

INSERT INTO SkladisteProizvodi(ProizvodID, SkladisteID, Stanje)
SELECT TOP 100 ProizvodID, 3, 100
FROM PROIZVODI


/*3. Kreirati uskladištenu proceduru koja ce vršiti povecanje stanja skladišta 
za odredeni proizvod na odabranom skladištu. Provjeriti ispravnost procedure
10 bodova*/

GO
CREATE PROCEDURE povecanje
(
@SkladisteID INT,
@ProizvodID INT,
@Stanje INT
)
AS
BEGIN
	UPDATE SkladisteProizvodi
	SET Stanje+=@Stanje
	WHERE ProizvodID=@ProizvodID AND SkladisteID=@SkladisteID
END

EXEC povecanje 1,1,1000


/*4. Kreiranje indeksa u bazi podataka nad tabelama
a) Non-clustered indeks nad tabelom Proizvodi. Potrebno je indeksirati Sifru i Naziv. Takoder,
potrebno je ukljuciti kolonu Cijena
b) Napisati proizvoljni upit nad tabelom Proizvodi koji u potpunosti iskorištava indeks iz
prethodnog koraka
c) Uradite disable indeksa iz koraka a)
5 bodova*/

/*4a)*/

CREATE NONCLUSTERED INDEX IX_Sifra_Naziv
on PROIZVODI(Sifra,Naziv)
INCLUDE (Cijena)


/*4b)*/
select Sifra,Naziv,Cijena from PROIZVODI


/*4c)*/

ALTER INDEX IX_Sifra_Naziv
ON PROIZVODI
DISABLE
GO


/*5. Kreirati view sa sljedecom definicijom. 
Objekat treba da prikazuje sifru, naziv i cijenu proizvoda,
oznaku, naziv i lokaciju skladišta, te stanje na skladištu.
10 bodova*/

CREATE VIEW pogled
AS
	SELECT p.Sifra,p.Naziv,p.Cijena,s.Oznaka,s.Lokacije,sk.Stanje
	FROM PROIZVODI as p inner join SkladisteProizvodi as sk
		on p.ProizvodID=sk.ProizvodID
	inner join Skladista as s
		on sk.SkladisteID=s.SkladisteID

select * from pogled


/*6. Kreirati uskladištenu proceduru koja ce na osnovu unesene šifre proizvoda 
prikazati ukupno stanje zaliha na svim skladištima. 
U rezultatu prikazati sifru, naziv i cijenu proizvoda te ukupno stanje zaliha.
U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane procedure.
10 bodova */

GO
CREATE PROCEDURE pregled
(
@Sifra nvarchar(10)
)
AS
BEGIN
	SELECT p.Sifra,p.Naziv,p.Cijena,SUM(p.Stanje) AS 'Ukupno stanje'
	FROM pogled AS p 
	WHERE p.Sifra LIKE @Sifra
	GROUP BY p.Sifra,p.Naziv,p.Cijena
END

EXEC pregled 'BK-M68B-38'

/*7. Kreirati uskladištenu proceduru koja ce vršiti upis novih proizvoda, 
te kao stanje zaliha za uneseni proizvod postaviti na 0 za sva skladišta. 
Provjeriti ispravnost kreirane procedure.
10 bodova*/

go
CREATE PROCEDURE upisuj
(
@Sifra nvarchar(10),
@naziv nvarchar(50),
@cijena decimal(15,2)
)
AS
BEGIN
	INSERT INTO PROIZVODI
	values(@Sifra,@naziv,@cijena)
END

/*8. Kreirati uskladištenu proceduru koja ce za unesenu šifru proizvoda vršiti brisanje proizvoda
ukljucujuci stanje na svim skladištima. Provjeriti ispravnost procedure.
10 bodova
*/

GO
CREATE PROCEDURE brisi
(
@sifra nvarchar(15)
)
as
begin
	delete from SkladisteProizvodi
	where ProizvodID=( select ProizvodID FROM PROIZVODI WHERE Sifra=@sifra)

	delete from PROIZVODI
	where Sifra like @sifra
end

select * from PROIZVODI

exec brisi 'BK-M68B-38'


CREATE DATABASE ispit1
GO

USE ispit1
GO

CREATE TABLE Otkupljivaci
(
OtkupljivacID INT CONSTRAINT PK_OtkupljivacID PRIMARY KEY(OtkupljivacID),
Ime NVARCHAR(50) NOT NULL,
Prezime NVARCHAR(50) NOT NULL,
DatumRodjenja DATETIME NOT NULL DEFAULT SYSDATETIME(),
JMBG NVARCHAR(13) NOT NULL,
Spol NVARCHAR(1) NOT NULL,
Grad NVARCHAR(50) NOT NULL,
Adresa NVARCHAR(100) NOT NULL,
Email NVARCHAR(100) NOT NULL CONSTRAINT UQ_Email UNIQUE,
Aktivan BIT NOT NULL DEFAULT 1
)

CREATE TABLE Proizvodi
(
ProizvodID INT CONSTRAINT PK_ProizvodID PRIMARY KEY(ProizvodID),
Naziv NVARCHAR(50) NOT NULL,
Sorta NVARCHAR(50) NOT NULL,
OtkupnaCijena DECIMAL(10,2) NOT NULL,
Opis NVARCHAR(MAX) 
) 

CREATE TABLE OtkupProizvoda
(
ProizvodID INT CONSTRAINT FK_OtkupProizvoda_ProizvodID FOREIGN KEY(ProizvodID)REFERENCES Proizvodi(ProizvodID),
OtkupljivacID INT CONSTRAINT FK_OtkupProizvoda_OtkupljivacID FOREIGN KEY(OtkupljivacID) REFERENCES Otkupljivaci(OtkupljivacID),
Datum DATETIME NOT NULL DEFAULT SYSDATETIME(),
CONSTRAINT PK_Proizvod_Otkupljivac PRIMARY KEY(ProizvodID,OtkupljivacID,Datum),
Kolicina DECIMAL(10,2) NOT NULL,
BrojGajbica INT NOT NULL
)

--2

INSERT INTO Otkupljivaci(OtkupljivacID,Ime,Prezime,DatumRodjenja,JMBG,Spol,Grad,Adresa,Email,Aktivan)
SELECT TOP 5 E.EmployeeID,E.FirstName,E.LastName,E.BirthDate,
			LEFT(CONCAT(REVERSE(E.BirthDate),DAY(E.BirthDate),MONTH(E.BirthDate),RIGHT(E.HomePhone,4)),13),		-- JMBG bila greska
			IIF(E.TitleOfCourtesy='Ms' OR E.TitleOfCourtesy='Mrs','Z','M'),
			E.City,	-- GRAD
			REPLACE(E.Address,' ','-'),	-- ADRESA
			LOWER(E.FirstName+'_'+E.LastName+'@edu.fit.ba'),	-- EMAIL
			1
FROM NORTHWND.dbo.Employees AS E
ORDER BY E.BirthDate DESC

INSERT INTO Proizvodi(ProizvodID,Naziv,Sorta,OtkupnaCijena,Opis)
SELECT P.ProductID,P.ProductName,C.CategoryName,P.UnitPrice,C.Description
FROM NORTHWND.dbo.Products AS P INNER JOIN NORTHWND.dbo.Categories AS C
	ON P.CategoryID=C.CategoryID

INSERT INTO OtkupProizvoda(ProizvodID,OtkupljivacID,Datum,Kolicina,BrojGajbica)
SELECT DISTINCT OD.ProductID,O.OrderID,O.OrderDate,OD.Quantity *8 ,OD.Quantity
FROM NORTHWND.dbo.[Order Details] AS OD INNER JOIN NORTHWND.dbo.Orders AS O
	ON OD.OrderID=O.OrderID 
-- NECE NESTO

SELECT OD.ProductID as 'ProizvodID',O.OrderID AS 'OtkupljivacID',O.OrderDate AS 'Datum',OD.Quantity*8 AS 'Uvecana kolicina',
	  OD.Quantity as 'Broj gajbica'
INTO otkupljivaci_nova
FROM NORTHWND.dbo.Orders as O INNER JOIN NORTHWND.dbo.[Order Details] AS OD
	ON O.OrderID=OD.OrderID 
INNER JOIN IB170044.dbo.Otkupljivaci as otk
	on O.EmployeeID=otk.OtkupljivacID


--3 izmjena strukture baze

ALTER TABLE Proizvodi
ADD TipProizvoda NVARCHAR(50) 

SELECT * FROM Proizvodi

UPDATE Proizvodi
SET TipProizvoda='Voce'
WHERE ProizvodID%2=0

--4

SELECT * FROM Otkupljivaci

UPDATE Otkupljivaci
SET Aktivan=0
WHERE Grad!='London' AND YEAR(DatumRodjenja)>=1960 

--5

SELECT * FROM Proizvodi

UPDATE Proizvodi
SET OtkupnaCijena+=5.45
WHERE Sorta LIKE '%/%'


--6

SELECT O.Ime+' '+O.Prezime,P.Naziv,SUM(OP.Kolicina) AS 'Kolicina',SUM(OP.BrojGajbica)AS 'Broj gajbica'
FROM Otkupljivaci AS O INNER JOIN OtkupProizvoda AS OP 
	ON O.OtkupljivacID=OP.OtkupljivacID
INNER JOIN Proizvodi AS P
	ON OP.ProizvodID=P.ProizvodID
GROUP BY O.Ime,O.Prezime,P.Naziv

--7

select * from Proizvodi

SELECT TOP 10 P.Naziv,CONVERT(VARCHAR,ROUND(SUM(P.OtkupnaCijena*OP.Kolicina),2))+' KM' AS 'ukupna otkupna',SUM(OP.Kolicina) AS 'Ukupna kolicina'
FROM Proizvodi AS P INNER JOIN OtkupProizvoda AS OP
	ON OP.ProizvodID=P.ProizvodID
WHERE OP.Datum between '1996-12-24' and '1997-08-16' 
GROUP BY P.Naziv
HAVING SUM(OP.Kolicina)>1000
ORDER BY [ukupna otkupna] DESC

--8

SELECT P.Naziv,ISNULL(P.TipProizvoda,'Nije definisan'),P.Sorta,COUNT(OP.OtkupljivacID) AS 'Ukupno narudzi'
FROM Proizvodi AS P INNER JOIN OtkupProizvoda AS OP
	ON P.ProizvodID=OP.ProizvodID
INNER JOIN Otkupljivaci AS O
	ON OP.OtkupljivacID=O.OtkupljivacID
WHERE MONTH(OP.Datum)=8 AND YEAR(OP.Datum)=1997 AND O.Spol LIKE 'Z' AND O.Aktivan=1 
GROUP BY P.Naziv,P.TipProizvoda,P.Sorta

--9

SELECT *  from Otkupljivaci

DELETE FROM Otkupljivaci
where Grad like 'Seattle'

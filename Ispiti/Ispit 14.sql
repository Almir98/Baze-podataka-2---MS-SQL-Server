CREATE DATABaSE JULSKI
go


use JULSKI

CREATE TABLE Zaposlenici
(
ZaposlenikID INT NOT NULL CONSTRAINT PK_ZaposlenikID PRIMARY KEY(ZaposlenikID),
Ime NVARCHAR(50) NOT NULL,
Prezime NVARCHAR(50) NOT NULL,
Spol NVARCHAR(10) NOT NULL,
JMBG NVARCHAR(13) NOT NULL,
DatumRodjenja DATETIME DEFAULT SYSDATETIME(),
Adresa NVARCHAR(100) NOT NULL,
Email NVARCHAR(100) NOT NULL CONSTRAINT UQ_Email UNIQUE,
KorisnickoIme NVARCHAR(60) NOT NULL,
Lozinka NVARCHAR(30) NOT NULL
)

CREATE TABLE Artikli
(
ArtikalID INT NOT NULL CONSTRAINT PK_ArtikalID PRIMARY KEY(ArtikalID),
Naziv NVARCHAR(50) NOT NULL,
Cijena DECIMAL(10,2) NOT NULL,
StanjeNaSkladistu INT NOT NULL
)

CREATE TABLE Prodaja
(
ZaposlenikID INT CONSTRAINT FK_Prodaja_ZaposlenikID FOREIGN KEY(ZaposlenikID) REFERENCES Zaposlenici(ZaposlenikID),
ArtikalID INT CONSTRAINT FK_Prodaja_ArtikalID FOREIGN KEY(ArtikalID) REFERENCES Artikli(ArtikalID),
Datum DATETIME DEFAULT SYSDATETIME(),
CONSTRAINT PK_Prodaja_ZA PRIMARY KEY(ZaposlenikID,ArtikalID,Datum),
Kolicina DECIMAL(10,2) NOT NULL 
)

INSERT INTO Zaposlenici(ZaposlenikID,Ime,Prezime,Spol,JMBG,DatumRodjenja,Adresa,Email,KorisnickoIme,Lozinka)
SELECT E.EmployeeID,E.FirstName,E.LastName,
       IIF(E.TitleOfCourtesy='Ms' OR E.TitleOfCourtesy='Mrs','Z','M'),
	   CONCAT(YEAR(E.BirthDate),MONTH(E.BirthDate),DAY(E.BirthDate)),
	   E.BirthDate,
	   CONCAT(E.Country,E.City,E.Address),
	   LOWER(E.FirstName+'.'+E.LastName+'@poslovna.ba'),
	   UPPER(E.FirstName+'.'+E.LastName),
	   REVERSE(REPLACE(SUBSTRING(E.Notes,15,6)+LEFT(E.Extension,2)+CONVERT(NVARCHAR,DAY(E.BirthDate))+CONVERT(NVARCHAR,DAY(E.HireDate)),' ','#'))
FROM NORTHWND.dbo.Employees as E
WHERE DATEDIFF(YEAR,E.BirthDate,GETDATE())>60 AND (E.TitleOfCourtesy='Mrs.' or E.TitleOfCourtesy='Ms.'or E.TitleOfCourtesy='Mr.')

--b

INSERT INTO Artikli(ArtikalID,Naziv,Cijena,StanjeNaSkladistu)
SELECT DISTINCT P.ProductID,P.ProductName,P.UnitPrice,P.UnitsInStock
FROM NORTHWND.dbo.Products as P INNER JOIN NORTHWND.dbo.[Order Details] as OD
	ON P.ProductID=OD.ProductID
INNER JOIN NORTHWND.dbo.Orders as O
	ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=1997 AND (MONTH(O.OrderDate)=8 OR MONTH(O.OrderDate)=9)
ORDER BY P.ProductName ASC


INSERT INTO Prodaja(ZaposlenikID,ArtikalID,Datum,Kolicina)
SELECT Z.ZaposlenikID,OD.ProductID,O.OrderDate,SUM(OD.Quantity)
FROM NORTHWND.dbo.[Order Details] as OD INNER JOIN NORTHWND.dbo.Orders AS O
	ON OD.OrderID=O.OrderID
INNER JOIN Zaposlenici AS Z 
	ON Z.ZaposlenikID=O.EmployeeID
WHERE YEAR(O.OrderDate)=1997 AND (MONTH(O.OrderDate)=8 OR MONTH(O.OrderDate)=9)
GROUP BY Z.ZaposlenikID,OD.ProductID,O.OrderDate


--3

ALTER TABLE Artikli
ADD Kategorija NVARCHAR(50)
GO

--c

UPDATE Artikli
SET Kategorija='Hrana'
WHERE ArtikalID%3=0
GO


--4

UPDATE Zaposlenici
SET KorisnickoIme=Ime+'_'+substring(CONVERT(nvarchar,year(DatumRodjenja)),2,2)+'_'+Prezime

--5

SELECT A.Naziv,A.StanjeNaSkladistu,P.Kolicina,P.Kolicina-A.StanjeNaSkladistu AS 'Potrebno narucit'
FROM Artikli AS A INNER JOIN Prodaja AS P
	ON A.ArtikalID=P.ArtikalID
INNER JOIN Zaposlenici AS Z
	ON P.ZaposlenikID=Z.ZaposlenikID
where P.Kolicina>A.StanjeNaSkladistu


--6

SELECT Z.Ime+Z.Prezime AS 'Ime i prezime',A.Naziv,ISNULL(A.Kategorija,'N/A'),
       CONVERT(NVARCHAR,ROUND(SUM(P.Kolicina),2))+' .kom' AS 'Ukupna kolicina',
	   CONVERT(NVARCHAR,ROUND(sum(P.Kolicina*A.Cijena),2))+' KM' as 'Ukupna zarada'
FROM Zaposlenici AS Z INNER JOIN Prodaja as P
	ON Z.ZaposlenikID=P.ZaposlenikID
INNER JOIN Artikli AS A
	ON P.ArtikalID=A.ArtikalID
inner join NORTHWND.dbo.Employees as E
	ON E.EmployeeID=Z.ZaposlenikID
WHERE E.Country LIKE 'USA'
GROUP BY Z.Ime,Z.Prezime,A.Naziv,A.Kategorija


--7

SELECT Z.Ime+Z.Prezime AS 'Ime i prezime',A.Naziv,P.Datum,
       CONVERT(NVARCHAR,ROUND(SUM(P.Kolicina),2))+' .kom' AS 'Ukupna kolicina',
	   CONVERT(NVARCHAR,ROUND(sum(P.Kolicina*A.Cijena),2))+' KM' as 'Ukupna zarada'
FROM Zaposlenici AS Z INNER JOIN Prodaja as P
	ON Z.ZaposlenikID=P.ZaposlenikID
INNER JOIN Artikli AS A
	ON P.ArtikalID=A.ArtikalID
inner join NORTHWND.dbo.Employees as E
	ON E.EmployeeID=Z.ZaposlenikID
WHERE Z.Spol='Z' AND A.Kategorija IS NULL AND (A.Naziv LIKE 'C%' OR A.Naziv LIKE 'G%') AND (P.Datum BETWEEN '1997-08-22' AND '1997-09-22') 
GROUP BY Z.Ime,Z.Prezime,A.Naziv,P.Datum


--8


SELECT Z.Ime+' '+Z.Prezime AS 'Ime i prezime',
	   CONCAT(DAY(Z.DatumRodjenja),'.',MONTH(Z.DatumRodjenja) 'Datum rodjenja','.',YEAR(Z.DatumRodjenja)),
	   Z.Spol,COUNT(P.Kolicina) AS 'Ukupno narucio'
FROM Zaposlenici AS Z INNER JOIN Prodaja AS P
	ON Z.ZaposlenikID=P.ZaposlenikID
INNER JOIN Artikli AS A
	ON P.ArtikalID=A.ArtikalID
WHERE MONTH(P.Datum)=8 AND YEAR(P.Datum)=1997
group by Z.Ime,Z.Prezime,Z.DatumRodjenja,Z.Spol

--9

DELETE FROM Prodaja
WHERE ZaposlenikID=(SELECT A.ZaposlenikID FROM Zaposlenici AS A WHERE ZaposlenikID=A.ZaposlenikID AND A.Adresa LIKE'%London%' )


DELETE FROM Zaposlenici
WHERE Adresa LIKE'%London%'		


select * from Zaposlenici

select * from Prodaja

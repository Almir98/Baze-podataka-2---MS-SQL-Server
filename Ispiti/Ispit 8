

CREATE DATABASE juni
go

use juni

CREATE TABLE Otkupljivaci
(
OtkupljivacID INT NOT NULL CONSTRAINT PK_OtkupljvacID PRIMARY KEY(OtkupljivacID),
Ime nvarchar(50) not null,
Prezime nvarchar(50) not null,
DatumRodjenja datetime default sysdatetime(),
JMBG NVARCHAR(13) NOT NULL,
Spol NVARCHAR(1) NOT NULL,
Grad Nvarchar(50) not null,
Adresa nvarchar(100) not null,
Email nvarchar(100) constraint UQ_Email UNIQUE,
Aktivan BIT DEFAULT 1
)

CREATE TABLE Proizvodi
(
ProizvodID INT NOT NULL CONSTRAINT PK_ProizvodID PRIMARY KEY(ProizvodID),
Naziv nvarchar(50) not null,
Sorta nvarchar(50) not null,
OtkupnaCijena decimal(10,2) not null,
Opis nvarchar(max)
)

create table OtkupProizvoda
(
OtkupljivacID INT CONSTRAINT FK_OtkupProizvoda_OtkupljvacID foreign KEY(OtkupljivacID) references Otkupljivaci(OtkupljivacID),
ProizvodID INT CONSTRAINT FK_OtkupProizvoda_ProizvodID foreign KEY(OtkupljivacID) references Proizvodi(ProizvodID),
Datum datetime not null default sysdatetime(),
Kolicina decimal not null,
BrojGajbica int not null,
constraint PK_glavni primary key(OtkupljivacID,ProizvodID,Datum,Kolicina)
)

--2


INSERT INTO Otkupljivaci(OtkupljivacID,Ime,Prezime,DatumRodjenja,JMBG,Spol,Grad,Adresa,Email,Aktivan)
SELECT TOP 5 E.EmployeeID,E.FirstName,E.LastName,E.BirthDate,
       LEFT(CONCAT(REVERSE(E.BirthDate),DAY(E.BirthDate),MONTH(E.BirthDate),RIGHT(E.HomePhone,4)),13),
	   IIF(E.TitleOfCourtesy='Ms%' OR E.TitleOfCourtesy='Mrs%','Z','M'),
	   E.City,
	   REPLACE(E.Address,' ','_'),
	   LOWER(E.FirstName+E.LastName+'@edu.fit.ba'),
	   1
FROM NORTHWND.dbo.Employees as E
ORDER BY E.BirthDate DESC


--b

INSERT INTO Proizvodi(ProizvodID,Naziv,Sorta,OtkupnaCijena,Opis)
SELECT P.ProductID,P.ProductName,C.CategoryName,P.UnitPrice,C.Description
FROM NORTHWND.dbo.Products as P INNER JOIN NORTHWND.dbo.Categories as C
	ON P.CategoryID=C.CategoryID

--c

INSERT INTO OtkupProizvoda(OtkupljivacID,ProizvodID,Datum,Kolicina,BrojGajbica)
SELECT OTK.OtkupljivacID,OD.ProductID,O.OrderDate,OD.Quantity*8,OD.Quantity
FROM NORTHWND.dbo.Orders as O inner join NORTHWND.dbo.[Order Details] AS OD
	on O.OrderID=OD.OrderID
	INNER JOIN Otkupljivaci AS OTK
		ON O.EmployeeID=OTK.OtkupljivacID


--3

ALTER TABLE Otkupljivaci
alter column Adresa nvarchar(50) null


alter table Proizvodi
add TipProizvoda nvarchar(50)

Update Proizvodi
SET TipProizvoda='Voce'
WHERE ProizvodID%2=0

Update Proizvodi
SET TipProizvoda=NULL
WHERE ProizvodID%2!=0

SELECT * FROM Proizvodi

--4

select * from Otkupljivaci

 UPDATE Otkupljivaci
 SET Aktivan=0
 WHERE Grad NOT LIKE 'London' AND YEAR(DatumRodjenja)>=1960


 --5

 UPDATE Proizvodi
 set OtkupnaCijena+=5.45
 WHERE Sorta like '%/%'

 --6

SELECT O.Ime+' '+O.Prezime AS 'Ime i prezime',P.Naziv,SUM(OP.Kolicina) AS 'Kolicina',SUM(OP.BrojGajbica) as 'Broj gajbica'
FROM Otkupljivaci AS O INNER JOIN OtkupProizvoda AS OP
	ON O.OtkupljivacID=OP.OtkupljivacID INNER JOIN Proizvodi AS P
		ON OP.ProizvodID=P.ProizvodID
GROUP BY O.Ime,O.Prezime,P.Naziv
ORDER BY Naziv ASC,Kolicina desc


--7

select top 10 P.Naziv,CONVERT(VARCHAR,ROUND(SUM(P.OtkupnaCijena*OP.Kolicina),2))+' KM' AS 'Ukupna otkupna',
              SUM(OP.Kolicina) AS 'Ukupno otkupljivan'
from Proizvodi as P INNER JOIN OtkupProizvoda AS OP
	ON P.ProizvodID=OP.ProizvodID
WHERE OP.Datum BETWEEN '1996-12-24' AND '1997-08-16'
group by P.Naziv
HAVING SUM(OP.Kolicina)>1000
ORDER BY [Ukupna otkupna] desc

--8

SELECT P.Naziv,ISNULL(P.TipProizvoda,'N/A') as 'Tip proizvoda',P.Sorta,COUNT(OP.OtkupljivacID) AS 'Broj otkupljivanja'
FROM Proizvodi AS P INNER JOIN OtkupProizvoda AS OP
	ON P.ProizvodID=OP.ProizvodID
GROUP BY P.Naziv,P.TipProizvoda,P.Sorta


--9

SELECT P.Naziv,ISNULL(P.TipProizvoda,'N/A') as 'Tip proizvoda',P.Sorta,COUNT(OP.OtkupljivacID) AS 'Broj otkupljivanja'
FROM Proizvodi AS P INNER JOIN OtkupProizvoda AS OP
	ON P.ProizvodID=OP.ProizvodID 
	INNER JOIN Otkupljivaci AS O
		ON OP.OtkupljivacID=O.OtkupljivacID
WHERE Aktivan=1 AND MONTH(OP.Datum)=8 AND YEAR(OP.Datum)=1997 AND O.Spol LIKE 'Z'
GROUP BY P.Naziv,P.TipProizvoda,P.Sorta

--10


select * from OtkupProizvoda

delete from OtkupProizvoda
where OtkupljivacID=(select O.OtkupljivacID from Otkupljivaci as O WHERE O.Grad LIKE 'Seattle' and OtkupljivacID=O.OtkupljivacID)

DELETE FROM Otkupljivaci
WHERE Grad LIKE 'Seattle'


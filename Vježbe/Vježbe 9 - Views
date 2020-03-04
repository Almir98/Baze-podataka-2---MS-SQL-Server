-- POGLEDI je naslonjen na tabele,predstavlja se kao da je virtualna dinamicka tabela,
-- brisanjem kolone iz stvarne tabele se odrazi nad pogledom jer je on zavisan od tabele odnosno te kolone
-- svrha mu je da se olaksa sam prikaz podataka

 USE AdventureWorks2014
 GO 

CREATE VIEW HumanResources.view_Employees AS
SELECT P.BusinessEntityID,P.FirstName,P.LastName
FROM AdventureWorks2014.HumanResources.Employee AS E INNER JOIN AdventureWorks2014.Person.Person AS P
	ON E.BusinessEntityID=P.BusinessEntityID

 CREATE TABLE Uposlenik
 (
 UposlenikID INT,
 NacionalniID NVARCHAR(15) NOT NULL,
 LoginID NVARCHAR(256) NOT NULL,
 RadnoMjeston NVARCHAR(50) NOT NULL
 )

 CREATE TABLE Osoba
 (
 OsobaID INT,
 VrstaUposlenika NVARCHAR(2) NOT NULL,
 Prezime NVARCHAR(50) NOT NULL,
 Ime NVARCHAR(50) NOT NULL
 )

 INSERT INTO Uposlenik
 SELECT E.BusinessEntityID,E.NationalIDNumber,E.LoginID,E.JobTitle
 FROM HumanResources.Employee AS E
 WHERE JobTitle LIKE '%Man%'

 INSERT INTO Osoba
 SELECT P.BusinessEntityID,P.PersonType,P.LastName,P.FirstName
 FROM Person.Person AS P
 WHERE P.PersonType LIKE 'EM'


 USE NORTHWND
 GO

 CREATE VIEW view_Employee AS
 SELECT E.LastName+E.FirstName as 'ime i prezime',T.TerritoryDescription
 FROM Employees AS E INNER JOIN EmployeeTerritories AS ET
	ON E.EmployeeID=ET.EmployeeID
INNER JOIN Territories AS T
	ON ET.TerritoryID=T.TerritoryID
WHERE DATEDIFF(YEAR,E.BirthDate,GETDATE())>30		 


CREATE VIEW view_Categories AS
SELECT s.CompanyName AS 'Ime dobavljaca',s.Country,s.City,c.CategoryName
FROM Categories AS C INNER JOIN Products AS P
	ON C.CategoryID=P.CategoryID
INNER JOIN Suppliers AS S
	ON P.SupplierID=S.SupplierID
WHERE P.UnitsInStock>30




--

CREATE TABLE UposelnikZDK
(
UposlenikID INT NOT NULL,
Nacionalni NVARCHAR(15) NOT NULL,
LoginID NVARCHAR(256) NOT NULL,
RadnoMjesto NVARCHAR(50) NOT NULL,
Kanton SMALLINT NOT NULL CONSTRAINT CK_Kanton_K1 CHECK (Kanton=1) --???
CONSTRAINT PK_Kantoni_K1 PRIMARY KEY(UposlenikID,Kanton)
)

CREATE TABLE UposelnikHNK
(
UposlenikID INT NOT NULL,
Nacionalni NVARCHAR(15) NOT NULL,
LoginID NVARCHAR(256) NOT NULL,
RadnoMjesto NVARCHAR(50) NOT NULL,
Kanton SMALLINT NOT NULL CONSTRAINT CK_Kanton_K2 CHECK (Kanton=2) --???
CONSTRAINT PK_Kantoni_K2 PRIMARY KEY(UposlenikID,Kanton)
)

USE AdventureWorks2014
GO

CREATE VIEW dbo.view_part_UposlenikKantoni WITH SCHEMABINDING AS
SELECT UposlenikID,NacionalniID,LoginID,RadnoMjesto,Kanton
FROM dbo.UposlenikHNK
UNION ALL
SELECT UposlenikID,NacionalniID,LoginID,RadnoMjesto,Kanton
FROM dbo.UposlenikZDK

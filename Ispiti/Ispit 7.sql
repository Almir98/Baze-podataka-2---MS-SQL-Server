CREATE DATABASE PROBA
 USE PROBA
 GO

 CREATE TABLE Studenti
 (
 StudentID INT NOT NULL CONSTRAINT PK_StudentID PRIMARY KEY(StudentID) IDENTITY(1,1),
 BrojDosijea nvarchar(10) NOT NULL CONSTRAINT UQ_BrojDosijea UNIQUE,
 Ime NVARCHAR(40) NOT NULL,
 Prezime NVARCHAR(40) NOT NULL,
 GodinaStudija int not null,
 NacinStudiranja NVARCHAR(10) NOT NULL DEFAULT 'Redovan',
 Email NVARCHAR(50) NULL
 )

 CREATE TABLE Predmeti
 (
 PredmetID INT NOT NULL CONSTRAINT PK_PredmetID PRIMARY KEY(PredmetID) IDENTITY(1,1),
 Naziv NVARCHAR(100) NOT NULL,
 Oznaka NVARCHAR(10) NOT NULL CONSTRAINT UQ_Oznaka UNIQUE
 )

 CREATE TABLE Ocjene
 (
 StudentID INT NOT NULL CONSTRAINT FK_Ocjene_StudentID FOREIGN KEY(StudentID) REFERENCES Studenti(StudentID),
 PredmetID INT NOT NULL CONSTRAINT FK_Ocjene_PredmetID FOREIGN KEY(PredmetID) REFERENCES Predmeti(PredmetID),
 CONSTRAINT Ocjene_pK PRIMARY KEY(StudentID,PredmetID), 
Ocjena int not null,
Bodovi decimal(18,2) not null,
DatumPolaganja DATETIME NOT NULL
 )

 INSERT INTO Predmeti(Naziv,Oznaka)
 VALUES('BAZE 2','BP2'),
 ('ALOGORITMI 2','ASP'),
 ('ENGELSKI','EJ')

 --B

 INSERT INTO Studenti(BrojDosijea,Ime,Prezime,GodinaStudija,Email)
 SELECT TOP 10 C.AccountNumber,PP.FirstName,PP.LastName,2,EA.EmailAddress
 FROM AdventureWorks2014.Person.Person AS PP INNER JOIN AdventureWorks2014.Sales.Customer AS C
	ON PP.BusinessEntityID=C.PersonID
INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA
	ON PP.BusinessEntityID=EA.BusinessEntityID


--3

GO
CREATE PROCEDURE upisuje
(
@StudentID INT,
@PredmetID INT,
@Ocjena INT,
@Bodovi DECIMAL(10,2),
@Datum DATE
)
AS
BEGIN
	INSERT INTO Ocjene(StudentID,PredmetID,Ocjena,Bodovi,DatumPolaganja)
	VALUES (@StudentID,@PredmetID,@Ocjena,@Bodovi,@Datum)
END

EXEC upisuje 1,1,5,54,'2019-12-24'
EXEC upisuje 2,2,10,99,'2019-1-2'

EXEC upisuje 5,3,7,74,'2016-06-05'

EXEC upisuje 8,3,8,77,'2015-04-04'

EXEC upisuje 6,1,5,18,'2019-1-1'

--4
/*
procedure unijeti minimalno 5 zapisa u tabelu Ocjene.
4. Takoder, u svoju bazu podataka putem Import/Export alata prebaciti sljedece tabele sa podacima:
 CreditCard, PersonCreditCard i Person koje se nalaze u AdventureWorks2014 bazi podataka.
*/
-- URADJENO

--5
--a
CREATE NONCLUSTERED INDEX IX_Ime_Prezime
ON Person.Person(FirstName,LastName)
INCLUDE(Title)
go

--b
SELECT FirstName,LastName,Title
FROM Person.Person


--c
ALTER INDEX IX_Ime_Prezime
ON Person.Person
DISABLE

--d
CREATE CLUSTERED INDEX IX_KARTICA
ON Sales.CreditCard(CreditCardID)
go

--e
CREATE NONCLUSTERED INDEX IX_Card_number
ON Sales.CreditCard(CardNumber)
INCLUDE(ExpMonth,ExpYear)
GO


--6 neki pogled nestooooo

CREATE VIEW pogled
AS
SELECT P.FirstName,P.LastName,CC.CardNumber,CC.CardType
from Person.Person as P
  inner join Sales.PersonCreditCard as PC
  on P.BusinessEntityID = PC.BusinessEntityID
  inner join Sales.CreditCard as CC
  on PC.CreditCardID=CC.CreditCardID
where P.Title is null and CC.CardType = 'Vista' 

SELECT * FROM pogled



BACKUP DATABASE PROBA
TO DISK='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\PROBA_.bak'
WITH differential
GO

--
--LOGINI I USERI

CREATE LOGIN studentt
WITH PASSWORD='Stundet123'
go
	
CREATE USER Almir FOR LOGIN studentt

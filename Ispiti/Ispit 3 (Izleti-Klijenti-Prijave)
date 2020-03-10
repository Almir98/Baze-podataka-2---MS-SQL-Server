CREATE DATABASE izleti
go

USE izleti

CREATE TABLE Klijenti
(
KlijentID INT NOT NULL CONSTRAINT PK_KlijentID PRIMARY KEY(KlijentID) IDENTITY(1,1),
Ime NVARCHAR(50) NOT NULL,
Prezime NVARCHAR(50) NOT NULL,
Drzava NVARCHAR(50) NOT NULL,
Grad NVARCHAR(50) NOT NULL,
Email NVARCHAR(50) NOT NULL,
Telefon NVARCHAR(50) NOT NULL
)

CREATE TABLE Izleti
(
IzletID INT NOT NULL CONSTRAINT PK_IzletID PRIMARY KEY(IzletID) IDENTITY(1,1),
Sifra NVARCHAR(10) NOT NULL,
Naziv nvarchar(100) not null,
DatumPolaska datetime not null,
DatumPovratka datetime not null,
Cijena decimal(10,2) not null,
Opis NVARCHAR(MAX) NULL
)

CREATE TABLE Prijave
(
KlijentID INT CONSTRAINT FK_Prijave_KlijentID FOREIGN KEY(KlijentID) REFERENCES Klijenti(KlijentID),
IzletID INT NOT NULL CONSTRAINT FK_Prijave_IzletID FOREIGN KEY(IzletID) REFERENCES Izleti(IzletID),
Datum datetime not null,
BrojOdraslih int not null,
BrojDjece int not null
)

--2

INSERT INTO Klijenti(Ime,Prezime,Drzava,Grad,Email,Telefon)
SELECT PP.FirstName,PP.LastName,CR.Name,A.City,EA.EmailAddress,Phone.PhoneNumber
FROM AdventureWorks2014.Person.Person AS PP
INNER JOIN AdventureWorks2014.Person.BusinessEntityAddress AS BEA
	ON PP.BusinessEntityID=BEA.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.Address AS A
	ON BEA.AddressID=A.AddressID
INNER JOIN AdventureWorks2014.Person.StateProvince AS SP
	ON A.StateProvinceID=SP.StateProvinceID
INNER JOIN AdventureWorks2014.Person.CountryRegion AS CR
	ON SP.CountryRegionCode=CR.CountryRegionCode
INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA
	ON PP.BusinessEntityID=EA.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.PersonPhone AS Phone
	on PP.BusinessEntityID=Phone.BusinessEntityID

--b

INSERT INTO Izleti(Sifra,Naziv,DatumPolaska,DatumPovratka,Cijena,Opis)
VALUES ('izlet1','Makarska1','2019-12-12','2020-01-01',550,'bezveze opis'),
('izlet2','Tucepi2','2009-05-24','2010-06-01',2250,'bezveze opis2'),
('izlet3','kuca3','2018-08-08','2018-08-28',1250,'test opis 3')


--3

GO
CREATE PROCEDURE dodaji
(
@KlijentID INT,
@IzletID INT, 
@BrojOdraslih INT,
@BrojDjece INT
)
AS
BEGIN
	INSERT INTO Prijave(KlijentID,IzletID,Datum,BrojOdraslih,BrojDjece)
	VALUES(@KlijentID,@IzletID,SYSDATETIME(),@BrojOdraslih,@BrojDjece)
END

EXEC dodaji 


exec dodaji 3,3,20,5
exec dodaji 3,1,15,15
exec dodaji 1,1,10,20
exec dodaji 1,2,5,30
exec dodaji 1,3,30,0
exec dodaji 5,1,20,25
exec dodaji 15,3,2,20
exec dodaji 13,2,23,0
exec dodaji 10,1,50,50
exec dodaji 6,2,3,50

-- izlete od 1 do 3 jer sam unio samo toliko

--4

CREATE UNIQUE NONCLUSTERED INDEX IX_KEmail
ON Klijenti(Email)
GO

--5

UPDATE Izleti
SET Cijena=Cijena-(Cijena*0.1)
WHERE (SELECT COUNT(P.IzletID) FROM Prijave AS P WHERE P.IzletID=IzletID)>3


--6

GO
CREATE VIEW pogled
AS
	SELECT I.Sifra,I.Naziv,FORMAT(I.DatumPolaska,'dd.MM.yyyy') AS 'Datum polaska',
	CONCAT(DAY(I.DatumPovratka),'.',MONTH(I.DatumPovratka),'.',YEAR(I.DatumPovratka))  as 'Datum Povratka',
	COUNT(P.KlijentID) AS 'Ukupno prijava',
	SUM(P.BrojOdraslih+P.BrojDjece) AS 'Ukupno putnika',
    SUM(P.BrojDjece) as'Ukupno djece',SUM(P.BrojOdraslih) as 'Ukupno odraslih'
	FROM Izleti AS I INNER JOIN Prijave AS P
		ON I.IzletID=P.IzletID
	GROUP BY I.Sifra,I.Naziv,I.DatumPolaska,I.DatumPovratka


--7

GO
CREATE PROCEDURE prikaz
(
@Sifra NVARCHAR(10)
)
AS
BEGIN
	SELECT I.Naziv,SUM(I.Cijena*P.BrojOdraslih) AS 'Zarada od odraslih',SUM(I.Cijena*P.BrojDjece)*0.5 AS 'Zarada od djece',
	       SUM(I.Cijena*P.BrojOdraslih+(I.Cijena*P.BrojDjece*0.5)) AS 'Ukupna zarada'
	FROM Izleti AS I INNER JOIN Prijave AS P
		ON I.IzletID=P.IzletID
		GROUP BY I.Naziv
END

EXEC prikaz 'izlet1'

--8

--...




--9

SELECT * FROM Klijenti

DELETE FROM Klijenti
WHERE KlijentID != (SELECT KlijentID FROM Prijave)
GO

--10

BACKUP DATABASE izleti
TO DISK='C:\BP2\Backup\izleti.back'

BACKUP DATABASE izleti
TO DISK='C:\BP2\Backup\izletiDIFF.back'
with differential

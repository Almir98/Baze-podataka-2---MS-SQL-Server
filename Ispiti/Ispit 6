CREATE DATABASE ispit
go

use ispit
go

CREATE TABLE Autori
(
AutorID NVARCHAR(11) NOT NULL CONSTRAINT PK_AutorID PRIMARY key(AutorID),
Prezime nvarchar(40) not null,
Ime nvarchar(40) not null,
Telefon nvarchar(20) default null,
DatumKreiranjaZapisa datetime not null default sysdatetime(),
DatumModifikovanjaZapisa datetime null
)

create table Izdavaci
(
IzdavacID nvarchar(4) not null constraint PK_IzdavacID primary key(IzdavacID),
Naziv nvarchar(100) not null constraint UQ_Naziv unique,
Biljeske nvarchar(1000) default 'Lorem ipsum',
datumkreiranjazapisa datetime not null default sysdatetime(),
datummodifikovanjazapisa datetime default null
)

create table Naslovi
(
NaslovID NVARCHAR(6) NOT NULL CONSTRAINT PK_NaslovID PRIMARY KEY(NaslovID),
IzdavacID NVARCHAR(4) CONSTRAINT FK_Naslov_IzdavacID FOREIGN KEY(IzdavacID) REFERENCES Izdavaci(IzdavacID), 
Naslov nvarchar(100) not null,
Cijena money,
DatumIzdavanja datetime not null default sysdatetime(),
DatumKreiranjaZapisa datetime not null default sysdatetime(),
DatumModifikovanjaZapisa datetime null
)

Create table NasloviAutori
(
AutorID NVARCHAR(11) CONSTRAINT FK_NasloviAutori_AutorID FOREIGN KEY (AutorID) REFERENCES Autori(AutorID),
NaslovID NVARCHAR(6) CONSTRAINT FK_naslovi_Autori_NaslovID FOREIGN KEY(NaslovID) REFERENCES Naslovi(NaslovID),
CONSTRAINT PK_NasloviAutori PRIMARY KEY(AutorID,NaslovID),
DatumKreiranjaZapisa datetime not null default sysdatetime(),
DatumModifikovanjaZapisa datetime null
)

--2

insert into Autori(AutorID,Prezime,Ime,Telefon)
SELECT A.au_id,A.au_fname,A.au_lname,A.phone
FROM (SELECT * FROM pubs.dbo.authors) as A
ORDER BY NEWID()

DELETE FROM Autori


INSERT INTO Izdavaci(IzdavacID,Naziv,Biljeske)
SELECT P.pub_id,P.pub_name,(SELECT SUBSTRING(PIN.pr_info,1,100) FROM pubs.dbo.pub_info as PIN WHERE PIN.pub_id=P.pub_id)
FROM pubs.dbo.publishers as P


INSERT INTO Naslovi(NaslovID,IzdavacID,Naslov,	Cijena)
SELECT T.title_id,T.pub_id,T.title,T.price
FROM (SELECT * FROM pubs.dbo.titles ) as T

INSERT INTO NasloviAutori(AutorID,NaslovID)
SELECT TA.au_id,TA.title_id
FROM (SELECT * FROM pubs.dbo.titleauthor) as TA

--3

create table Gradovi
(
GradID INT NOT NULL CONSTRAINT PK_GradID PRIMARY KEY(GradID) IDENTITY(5,5),
Naziv NVARCHAR(100) CONSTRAINT UQ_NazivG UNIQUE,
DatumKreiranjaZapisa datetime not null default sysdatetime(),
DatumModifikovanjaZapisa datetime null
)

INSERT INTO Gradovi(Naziv)
SELECT DISTINCT A.city
FROM (SELECT * FROM pubs.dbo.authors) as A


ALTER TABLE Autori
ADD GradID INT CONSTRAINT FK_A_GradID FOREIGN KEY(GradID) REFERENCES Gradovi(GradID)


--2d

GO
CREATE PROCEDURE izmjena
AS
BEGIN
	UPDATE TOP (10) Autori
	SET GradID=(SELECT GradID FROM Gradovi WHERE Naziv LIKE 'San Francisco')
END

GO
CREATE PROCEDURE izvrsi
AS
BEGIN
	UPDATE Autori
	SET GradID=(SELECT GradID FROM Gradovi WHERE Naziv LIKE 'Berkeley')
	WHERE GradID IS NULL
END


SELECT * FROM Autori

--3

CREATE VIEW pregled
AS
	SELECT A.Ime+' '+A.Prezime AS 'Ime i prezime',G.Naziv,N.Naslov,N.Cijena,I.Naziv AS 'ime izdavaca',I.Biljeske
	FROM Autori as A INNER JOIN Gradovi AS G
		ON A.GradID=G.GradID
    INNER JOIN NasloviAutori AS NA
		ON NA.AutorID=A.AutorID
	INNER JOIN Naslovi AS N
		ON NA.NaslovID=N.NaslovID
	INNER JOIN Izdavaci AS I
		ON I.IzdavacID=N.IzdavacID
	WHERE N.Cijena IS NOT NULL AND N.Cijena>10 AND I.Naziv LIKE '%&%' AND G.Naziv LIKE 'San Francisco'


SELECT * FROM pregled


--4

ALTER TABLE Autori
ADD Email NVARCHAR(100) DEFAULT NULL
GO

CREATE PROCEDURE novimejl
AS
BEGIN
	UPDATE Autori
	SET Email=Ime+'.'+Prezime+'@edu.fit.ba'
	WHERE GradID =(SELECT GradID FROM Gradovi WHERE Naziv LIKE 'San Francisco')
end

exec novimejl


CREATE PROCEDURE novimejl2
AS
BEGIN
	UPDATE Autori
	SET Email=Prezime+'.'+Ime+'@edu.fit.ba'
	WHERE GradID =(SELECT GradID FROM Gradovi WHERE Naziv LIKE 'Berkeley')
end

exec novimejl2


--6

SELECT PP.FirstName,PP.LastName,ISNULL(PP.Title,'N/A') as 'Titula',EA.EmailAddress,PPP.PhoneNumber,
       PP.FirstName+'.'+PP.LastName AS 'Username',
	   REPLACE(LEFT(NEWID(),16),'-','7') AS 'Password'
INTO #privremena
FROM AdventureWorks2014.Person.Person AS PP	INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA
	ON PP.BusinessEntityID=EA.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.PersonPhone AS PPP
	ON PPP.BusinessEntityID=PP.BusinessEntityID
LEFT JOIN AdventureWorks2014.Sales.PersonCreditCard AS PCC
	ON PP.BusinessEntityID=PCC.BusinessEntityID
LEFT JOIN AdventureWorks2014.Sales.CreditCard AS CC
	ON PCC.CreditCardID=CC.CreditCardID	 
ORDER BY PP.FirstName,PP.LastName

select * from #privremena



--7

CREATE NONCLUSTERED INDEX IX_ime 
ON #privremena(FirstName,LastName)
go

SELECT FirstName,LastName
FROM #privremena


--8

create procedure brisanje
as
begin
	delete from #privremena
	where CardNumber is null
end

--9

BACKUP DATABASE tihak
to DISK='tihak.bak'
go


drop table #privremena

--10

GO
CREATE PROCEDURE brisisve
as
begin
	ALTER TABLE Autori
	DROP CONSTRAINT FK_A_GradID

	ALTER TABLE NasloviAutori
	DROP CONSTRAINT FK_NasloviAutori_AutorID

	ALTER TABLE NasloviAutori
	DROP CONSTRAINT FK_naslovi_Autori_NaslovID
	

	DELETE FROM Naslovi
	DELETE FROM Gradovi
	DELETE FROM NasloviAutori
	DELETE FROM Naslovi
	DELETE FROM Izdavaci
END


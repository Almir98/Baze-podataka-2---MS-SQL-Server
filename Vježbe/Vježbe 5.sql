--1
CREATE DATABASE test

USE test
--2
CREATE TABLE Autori(
AutorID varchar(11) CONSTRAINT PK_AutorID PRIMARY KEY (AutorID),
Prezime varchar(40) NOT NULL,
Ime varchar(20) NOT NULL,
Telefon varchar(11) NOT NULL,
Adresa varchar(11) NULL,
Grad varchar(20) NULL,
Drzava varchar(2) NULL,
PostanskiBroj varchar(5) NULL,
StanjeUgovora bit NULL)

--3
INSERT INTO Autori
SELECT *
FROM pubs.dbo.authors AS A
WHERE A.au_id LIKE '[123]%' AND A.contract=1

--4
INSERT INTO Autori
SELECT A.au_id, A.au_lname, A.au_fname, A.phone, A.address, NULL, NULL,NULL,1
FROM pubs.dbo.authors AS A
WHERE A.address LIKE '3_1%' AND A.contract=1

--5
DELETE FROM Autori
WHERE Telefon LIKE '[47]0%'

--6
UPDATE Autori
SET Grad='Bugojno', Drzava='bh', PostanskiBroj='70230'
WHERE Grad IS NULL AND Drzava IS NULL AND PostanskiBroj IS NULL

--7
DELETE FROM Autori

INSERT INTO Autori
SELECT *
FROM pubs.dbo.authors

--8
CREATE TABLE Djelo(
DjeloID varchar(6) CONSTRAINT PK_DjeloID PRIMARY KEY (DjeloID),
NazivDjela varchar(80) NOT NULL,
Zanr varchar(12) NOT NULL,
IzdavacID varchar(4) NULL,
Cijena money NULL,
Dobit money NULL,
Klasifikacija int NULL,
GodisnjaProdaja int NULL,
Biljeska varchar(200) NULL,
DatumIzdavanja date NOT NULL,
VrijemeIzdavanja time NOT NULL)

--9
INSERT INTO Djelo
SELECT T.title_id,T.title,T.type,T.pub_id,T.price,T.advance,T.royalty,T.ytd_sales,T.notes,LEFT(pubdate,12), RIGHT(pubdate,7)
FROM pubs.dbo.titles AS T
WHERE T.price IS NULL

--10

--a
INSERT INTO Djelo
SELECT T.title_id,T.title,T.type,T.pub_id,T.price-T.price*0.2,T.advance,T.royalty,T.ytd_sales,T.notes,LEFT(pubdate,12), RIGHT(pubdate,7)
FROM pubs.dbo.titles AS T
WHERE T.price>=15

--b
INSERT INTO Djelo
SELECT T.title_id,T.title,T.type,T.pub_id,T.price-T.price*0.15,T.advance,T.royalty,T.ytd_sales,T.notes,LEFT(pubdate,12), RIGHT(pubdate,7)
FROM pubs.dbo.titles AS T
WHERE T.price<15

--11
UPDATE Djelo
SET Cijena=10, Dobit=1000, Klasifikacija=15, GodisnjaProdaja=5000,Biljeska='Neka biljeska'
WHERE Zanr='UNDECIDED'

--12
DELETE FROM Djelo
WHERE Cijena IS NULL OR Cijena<5

--13
DELETE FROM Djelo

INSERT INTO Djelo
SELECT T.title_id,T.title,T.type,T.pub_id,T.price-T.price*0.2,T.advance,T.royalty,T.ytd_sales,T.notes,LEFT(pubdate,12), RIGHT(pubdate,7)
FROM pubs.dbo.titles AS T

--14
CREATE TABLE AutorDjelo(
AutorID varchar(11) NOT NULL,
DjeloID varchar(6) NOT NULL,
RedBrAutora tinyint NULL,
UdioAutPrava int NULL,
ISBN varchar(25) NULL,
CONSTRAINT PK_AutorID_DjeloID PRIMARY KEY(AutorID, DjeloID),
CONSTRAINT FK_AutorID FOREIGN KEY(AutorID) REFERENCES Autori(AutorID),
CONSTRAINT FK_DjeloID FOREIGN KEY(DjeloID) REFERENCES Djelo(DjeloID)
)

--15
ALTER TABLE AutorDjelo
DROP CONSTRAINT FK_AutorID

ALTER TABLE AutorDjelo
DROP CONSTRAINT FK_DjeloID

ALTER TABLE AutorDjelo
WITH CHECK ADD CONSTRAINT FK_AutorID FOREIGN KEY(AutorID)
REFERENCES Autori(AutorID)

ALTER TABLE AutorDjelo
WITH CHECK ADD CONSTRAINT FK_DjeloID FOREIGN KEY(DjeloID)
REFERENCES Djelo(DjeloID)

--16
INSERT INTO AutorDjelo
SELECT TA.au_id,TA.title_id,TA.au_ord,TA.royaltyper, CONCAT('ISBN ',RIGHT(TA.title_id,4),' ',TA.au_id) 
FROM pubs.dbo.titleauthor AS TA


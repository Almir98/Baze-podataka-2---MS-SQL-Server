/*Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u obzir uzeti
samo DEFAULT postavke*/

CREATE DATABASE IB170044
GO

/*Unutar svoje baze podataka kreirati tabele sa sljedecom strukturom:
a) Klijenti
i. KlijentID, automatski generator vrijednosti i primarni kljuc
ii. Ime, polje za unos 30 UNICODE karaktera (obavezan unos)
iii. Prezime, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. Telefon, polje za unos 20 UNICODE karaktera (obavezan unos)
v. Mail, polje za unos 50 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
vi. BrojRacuna, polje za unos 15 UNICODE karaktera (obavezan unos)
vii. KorisnickoIme, polje za unos 20 UNICODE karaktera (obavezan unos)
viii. Lozinka, polje za unos 20 UNICODE karaktera (obavezan unos)

b) Transakcije
i. TransakcijaID, automatski generator vrijednosti i primarni kljuc
ii. Datum, polje za unos datuma i vremena (obavezan unos)
iii. TipTransakcije, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. PosiljalacID, referenca na tabelu Klijenti (obavezan unos)
v. PrimalacID, referenca na tabelu Klijenti (obavezan unos)
vi. Svrha, polje za unos 50 UNICODE karaktera (obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos)*/

CREATE TABLE Klijenti
(
KlijentID INT NOT NULL CONSTRAINT PK_KlijentID PRIMARY KEY(KlijentID) IDENTITY(1,1),
Ime NVARCHAR(30) NOT NULL,
Prezime NVARCHAR(30) NOT NULL,
Telefon NVARCHAR(20) NOT NULL,
Mail NVARCHAR(50) NOT NULL CONSTRAINT UQ_Email UNIQUE,
BrojRacuna NVARCHAR(15) NOT NULL,
KorisnickoIme NVARCHAR(20) NOT NULL,
Lozinka NVARCHAR(20) NOT NULL
)

CREATE TABLE Transakcije
(
TransakcijaID INT NOT NULL CONSTRAINT PK_TransakcijaID PRIMARY KEY(TransakcijaID) IDENTITY(1,1),
Datum DATETIME NOT NULL,
TipTranskacije NVARCHAR(30) NOT NULL,
PosiljalacID INT NOT NULL CONSTRAINT FK_PosiljalacID FOREIGN KEY(PosiljalacID) REFERENCES IB170044.dbo.Klijenti(KlijentID),
PrimalacID INT NOT NULL CONSTRAINT FK_PrimalacID FOREIGN KEY(PrimalacID) REFERENCES IB170044.dbo.Klijenti(KlijentID),
Svrha NVARCHAR(50) NOT NULL,
Iznos DECIMAL(18,5) NOT NULL
)

/*
2.
Popunjavanje tabela podacima:
a) Koristeci bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 10 kupaca
u tabelu Klijenti. Ime, prezime, telefon, mail i broj racuna (AccountNumber) preuzeti od kupca,
korisnicko ime generisati na osnovu imena i prezimena u formatu ime.prezime, a lozinku generisati na
osnovu polja PasswordHash, i to uzeti samo zadnjih 8 karaktera.
b) Putem jedne INSERT komande u tabelu Transakcije dodati minimalno 10 transakcija.
*/

INSERT INTO Klijenti
SELECT TOP 10 PP.FirstName,PP.LastName,PPP.PhoneNumber,EA.EmailAddress,CC.CardNumber,PP.FirstName+'.'++PP.LastName,RIGHT(PAS.PasswordHash,8)
FROM AdventureWorks2014.Person.Person AS PP INNER JOIN AdventureWorks2014.Sales.Customer AS C
	ON PP.BusinessEntityID=C.CustomerID
INNER JOIN AdventureWorks2014.Person.PersonPhone AS PPP 
	ON PP.BusinessEntityID=PPP.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA 
	ON PP.BusinessEntityID=EA.BusinessEntityID
INNER JOIN AdventureWorks2014.Sales.PersonCreditCard AS PCC
	ON PP.BusinessEntityID=PCC.BusinessEntityID
INNER JOIN AdventureWorks2014.Sales.CreditCard AS CC
	ON PCC.CreditCardID=CC.CreditCardID
INNER JOIN AdventureWorks2014.Person.Password AS PAS
	ON PP.BusinessEntityID=PAS.BusinessEntityID

select * from Klijenti

--b

INSERT INTO Transakcije
VALUES
(SYSDATETIME(),'Tip1',1,2,'Plata',250),
(SYSDATETIME(),'Tip2',2,3,'Plata',754),
(SYSDATETIME(),'Tip3',3,4,'Plata',1111),
(SYSDATETIME(),'Tip4',4,5,'Clanarina',200),
(SYSDATETIME(),'Tip5',5,6,'Plata',2500.55),
(SYSDATETIME(),'Tip6',6,7,'Uplata studija',255.78),
(SYSDATETIME(),'Tip7',7,8,'Plata',600),
(SYSDATETIME(),'Tip8',8,9,'Uplata studija',980),
(SYSDATETIME(),'Tip9',9,10,'Plata',1650.55),
(SYSDATETIME(),'Tip10',10,1,'Plata',1400.10)

/*3.
Kreiranje indeksa u bazi podataka nada tabelama:
a) Non-clustered indeks nad tabelom Klijenti. Potrebno je indeksirati Ime i Prezime. Takoder, potrebno je
ukljuciti kolonu BrojRacuna.
b) Napisati proizvoljni upit nad tabelom Klijenti koji u potpunosti iskorištava indeks iz prethodnog koraka.
Upit obavezno mora imati filter.
c) Uraditi disable indeksa iz koraka a)*/


CREATE NONCLUSTERED INDEX IX_Ime_Prezime
ON Klijenti(Ime,Prezime) 
INCLUDE(BrojRacuna)

--b
SELECT Ime,Prezime,BrojRacuna
FROM Klijenti

--c
ALTER INDEX IX_Ime_Prezime
ON Klijenti
DISABLE

/*4.
Kreirati uskladištenu proceduru koja ce vršiti upis novih klijenata. Kao parametre proslijediti sva polja. Provjeriti
ispravnost kreirane procedure.
*/

GO
CREATE PROCEDURE KlijentiUpis
(
@Ime NVARCHAR(30),
@Prezime NVARCHAR(30),
@Telefon NVARCHAR(20),
@Mail NVARCHAR(50),
@BrojRacuna NVARCHAR(15),
@KorisnickoIme NVARCHAR(20),
@Lozinka NVARCHAR(20)
)
AS
BEGIN
	INSERT INTO Klijenti
	VALUES(@Ime,@Prezime,@Telefon,@Mail,@BrojRacuna,@KorisnickoIme,@Lozinka)
END


EXEC KlijentiUpis 'Almir','Tihak','061777452','almir.tihak@edu.fit.ba',123456,'almir.tihak','testSifra'
GO

SELECT * FROM Klijenti
GO

/*5. Kreirati view sa sljedecom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije, ime i
prezime pošiljaoca (spojeno), broj racuna pošiljaoca, ime i prezime primaoca (spojeno), broj racuna primaoca,
svrhu i iznos transakcije.*/

GO
CREATE VIEW Transakcije_view
AS
	SELECT T.Datum,T.TipTranskacije,K.Ime+' '+K.Prezime AS 'Ime i prezime posiljaoca',K.BrojRacuna AS 'Broj racuna posiljaoca',
	KK.Ime+' '++KK.Prezime AS 'Ime i prezime primaoca',KK.BrojRacuna AS 'Broj racuna primaoca',T.Svrha as 'Svrha',T.Iznos
	FROM Transakcije AS T INNER JOIN Klijenti AS K
		ON T.PosiljalacID=K.KlijentID
	INNER JOIN Klijenti AS KK
		ON T.PrimalacID=KK.KlijentID

select * from Transakcije_view
go

/*6. Kreirati uskladištenu proceduru koja ce na osnovu unesenog broja racuna pošiljaoca prikazivati sve transakcije
koje su provedene sa racuna klijenta. U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane
procedure.*/

CREATE PROCEDURE pregled_viewa
(
@BrojRacunaPosiljaoca  NVARCHAR(15)
)
AS
BEGIN
	SELECT *
	FROM Transakcije_view AS T
	WHERE T.[Broj racuna posiljaoca]=@BrojRacunaPosiljaoca
END

SELECT * FROM Transakcije_view
GO

EXEC pregled_viewa 55555614148317
GO

/*7. Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama. U rezultatu upita
prikazati samo dvije kolone: kalendarska godina i ukupan iznos transakcija u godini.*/

SELECT SUM(T.Iznos) AS 'Ukupno transakcija',DATEPART(YEAR,Datum) AS 'Godina'
FROM Transakcije AS T
GROUP BY DATEPART(YEAR,Datum)
ORDER BY DATEPART(YEAR,Datum) ASC

/*8. Kreirati uskladištenu proceduru koje ce vršiti brisanje klijenta ukljucujuci sve njegove transakcije, bilo da je za
transakciju vezan kao pošiljalac ili kao primalac. Provjeriti ispravnost kreirane procedure.*/

GO
CREATE PROCEDURE brisanje_klijenta
(
@KlijentID INT
)
AS
BEGIN
	DELETE FROM Transakcije
	WHERE PrimalacID=@KlijentID OR PosiljalacID=@KlijentID

	DELETE FROM Klijenti
	WHERE KlijentID=@KlijentID
END

--brisanje
EXEC brisanje_klijenta 2
GO

/*9. Kreirati uskladištenu proceduru koja ce na osnovu unesenog broja racuna ili prezimena pošiljaoca vršiti pretragu
nad prethodno kreiranim view-om (zadatak 5). Testirati ispravnost procedure u sljedecim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraca sve zapise)
b) Postavljena je vrijednost parametra broj racuna,
c) Postavljena je vrijednost parametra prezime,
d) Postavljene su vrijednosti oba parametra.*/

GO
CREATE PROCEDURE pretraga_nad_view
(
@BrojRacuna NVARCHAR(15)=NULL,
@Prezime NVARCHAR(30)=NULL
)
AS
BEGIN	
	--REGEX = ime + razmak + prezime i nista poslije prezimena
	DECLARE @regexPrezime NVARCHAR(30)='% ' + @Prezime;

	SELECT *
	FROM Transakcije_view AS T
	WHERE (T.[Ime i prezime posiljaoca] LIKE @regexPrezime OR @Prezime IS NULL) AND
		  (T.[Broj racuna posiljaoca]=@BrojRacuna OR @BrojRacuna IS NULL)
END

SELECT * FROM Transakcije_view
GO

EXEC pretraga_nad_view 'Adams'
GO

DROP procedure pretraga_nad_view
GO

/*10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:
a) C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup*/

--FULL BACKUP
BACKUP DATABASE IB170044
TO DISK=''

--DIFERENCIJALNI
BACKUP DATABASE IB170044
TO DISK=''
WITH DIFFERENTIAL

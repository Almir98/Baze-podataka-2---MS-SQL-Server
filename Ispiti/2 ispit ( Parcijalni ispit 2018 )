CREATE DATABASE parcijala
go

use parcijala
go

/*
1. Iz baze podataka AdventureWorks2014 je potrebno, putem podupita, importovati odredeni broj zapise u tabelu
Korisnici (koja ce biti kreirana u run-time procesu). Kolone koje su vam potrebne, nalaze se u više tabela.
a) Lista potrebnih kolona je: Title, LastName, FirstName, EmailAddress, PhoneNumber, CardNumber
o U koloni Title je potrebno sve NULL vrijednosti zamijeniti sa N/A
b) Takoder, potrebno je da kreirate dvije dodatne kolone prilikom import procedure:
o Kolona UserName koja se sastoji od spojenih FirstName i LastName (tacka se nalazi izmedu)
o Kolona Password se generiše tako što: LastName okrenemo reverzno i od drugog slova
uzmemo naredna cetiri. Sa kolonom FirstName uraditi isto, ali od drugog slova uzeti naredna
dva. Iz kolone rowguid (tabela Person) od desetog znaka uzeti narednih šest.
o Dobivene tri stringa spojiti u jedan.
c) Jedini uslov podupita jeste da se ukljuce one osobe koje imaju kreditnu karticu.
*/


SELECT ISNULL(P.Title,'N/A') as 'Naslov' ,P.FirstName,P.LastName,PP.PhoneNumber,EA.EmailAddress,CC.CreditCardID,
	   P.FirstName+'.'+P.LastName AS 'UserName',
	   SUBSTRING(REVERSE(P.LastName),2,4)+SUBSTRING(REVERSE(P.FirstName),2,2)+SUBSTRING(CAST(P.rowguid AS nvarchar(50)),10,6) AS 'Lozinka'
INTO Korisnici
FROM AdventureWorks2014.Person.Person AS P INNER JOIN AdventureWorks2014.Person.PersonPhone AS PP
	ON P.BusinessEntityID=PP.BusinessEntityID
INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA 
	ON P.BusinessEntityID=EA.BusinessEntityID
INNER JOIN AdventureWorks2014.Sales.PersonCreditCard AS PCC
	ON P.BusinessEntityID=PCC.BusinessEntityID
INNER JOIN AdventureWorks2014.Sales.CreditCard AS CC
	ON PCC.CreditCardID=CC.CreditCardID

/*
1a. Iz tabele Korisnici prikazati sve zapise gdje podaci iz kolone PhoneNumber u svome sadržaju nemaju
zagrade () i Title nije N/A 10 bodova
1b. U koloni Title, podatak Ms modifikovati u Ms. Izmjena se odnosi na sve zapise bez ogranicenja
5 bodova
1c. Obrisati sve korisnike sa titulom N/A 5 bodov
*/

select * from Korisnici

select *
from Korisnici
where Naslov NOT LIKE 'N/%' AND PhoneNumber NOT LIKE '%(%)%'


--1b

UPDATE Korisnici
SET Naslov='Ms'
WHERE Naslov='Ms.'			

--1c


delete from Korisnici
where Naslov like 'N/A'		-- !!!!!!


/*
2. Za svakog zaposlenika, iz baze podataka AdventureWorks2014 vaš upit treba da vrati sljedece kolone i podatke:
a) LastName i FirstName spojeno (potreban je i alias)
b) Kolone JobTitle, Gender i HireDate
c) U obzir dolaze samo zaposlenici ženskog posla
d) Naziv zaposlenja u svome imenu treba da sadrži rijec „Technician” (na bilo kojoj poziciji) ili rijec
„Network” na pocetku naziva.
*/


SELECT PP.FirstName+' '+PP.LastName AS 'Ime i prezime',E.JobTitle,E.Gender,E.HireDate 
FROM AdventureWorks2014.Person.Person AS PP	INNER JOIN AdventureWorks2014.HumanResources.Employee AS E
	ON PP.BusinessEntityID=E.BusinessEntityID
WHERE E.Gender LIKE 'F' AND (E.JobTitle LIKE '%Technician%' or E.JobTitle LIKE 'Network%')


/*3. Iz tabele Korisnici, koju ste kreirali u prvom zadatku, upitom prebrojati i prikazati koliko ukupno ima pojedinih titula.*/

SELECT Naslov,COUNT(Naslov) AS 'Ukupno titula'
FROM Korisnici
GROUP BY Naslov


/*
4. Za svakog zaposlenika iz baze podataka AdventureWorks2014, vaš upit treba da generiše sljedece kolone:
Email, Lozinku i trenutnu starost uposlenika.
a) Kolona Email se sastoji od spojenog imena i prezimena (odvojeno tackom) i nastavka @edu.fit.ba (sve
su mala slova).
b) Kolona Lozinka se generiše tako što spojite NationalIDNumber i LastName, od dobijenog stringa
preskocite prva dva znaka i uzmite narednih 8. Unutar stringa, karakter 1 zamijenite sa karakterom @
c) Generisati trenutnu starost uposlenika
d) Izlaz sortirati od najstarijeg prema najmladem uposleniku
*/

SELECT LOWER(PP.FirstName+'.'+PP.LastName)+'@edu.fit.ba' AS 'Email',
	   REPLACE(SUBSTRING(E.NationalIDNumber+PP.LastName,2,8),1,'@') AS 'Lozinka',		--REPLACE(kolona,sta mjenjamo,'sa cim mjenjamo')
	   DATEDIFF(YEAR,E.BirthDate,GETDATE()) AS 'Godina'									--DATEDIFF(u sta hocemo,manji datum,veci datum)
FROM AdventureWorks2014.Person.Person AS PP INNER JOIN AdventureWorks2014.HumanResources.Employee AS E
	ON PP.BusinessEntityID=E.BusinessEntityID

/*
5. Napisati upit koji za svaki proizvod, iz baze podataka AdventureWorks2014, ispisuje sljedece podatke: Naziv
(kategorije, podkategorije i proizvoda), boju proizvoda, standardnu cijenu, stvarnu cijenu, velicinu, potreban broj
dana za proizvodnju, pocetak/kraj prodaje i kolicinu svakog proizvoda na stanju. Generisati novu kolonu koja
prikazuje ukupan broj dana prodaje za svaki proizvod. Uslovi su:
a) Potreban broj dana za proizvodnju je veci od nula dana
b) Proizvod je još uvijek u prodaji
c) Ukupan broj dana prodaje je veci od pet dana
d) Proizvod mora imati definisani boju
e) Kolicina na stanju treba imati poznatu vrijednost
f) Izlaz sortirati prema ukupnom broj dana prodaje (opadajuci) i kolicini na stanju (opadajuci).
*/

SELECT PP.Name 'Ime proizvoda',PC.Name AS 'Ime kategorije',PS.Name AS 'Ime podkategorije',PP.Color,PP.ListPrice,PP.StandardCost AS 'Standardna cijena',
	   PP.Size,PP.DaysToManufacture 'Dana proizvodnje',PIN.Quantity AS 'Kolicina',DATEDIFF(DAY,PP.SellStartDate,PP.SellEndDate)	AS 'Razlika pocetka prodaje'
FROM AdventureWorks2014.Production.Product AS PP INNER JOIN AdventureWorks2014.Production.ProductSubcategory as PS
	ON PP.ProductSubcategoryID=PS.ProductSubcategoryID 
INNER JOIN AdventureWorks2014.Production.ProductCategory AS PC
	ON PS.ProductCategoryID=PC.ProductCategoryID
INNER JOIN AdventureWorks2014.Production.ProductInventory AS PIN
	ON PP.ProductID=PIN.ProductID
WHERE PP.DaysToManufacture > 0 AND GETDATE()>PP.SellEndDate AND DATEDIFF(DAY,PP.SellStartDate,PP.SellEndDate)>5
	AND PIN.Quantity IS NOT NULL AND PP.Size IS NOT NULL
ORDER BY PIN.Quantity DESC,[Razlika pocetka prodaje] DESC


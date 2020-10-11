USE NORTHWND
GO



CREATE PROCEDURE proc_dobavljac
(
@CompanyName NVARCHAR(40)=NULL,
@Adress NVARCHAR(60)=NULL,
@CIty NVARCHAR(15)=NULL,
@ProductName NVARCHAR(40)=NULL,
@UnitPrice MONEY=NULL
)
AS
BEGIN
	SELECT S.CompanyName,S.Address,S.City,p.ProductName,P.UnitPrice
	FROM Products AS P INNER JOIN Suppliers AS S
		ON P.SupplierID=S.SupplierID
	WHERE @CompanyName=S.ContactName OR
		  @CIty=S.City OR
		  @ProductName=P.ProductName OR
		  @UnitPrice=P.UnitPrice
END

ALTER AUTHORIZATION ON DATABASE :: -- NAZIVBAZE to sa

EXEC proc_dobavljac @City='Manchester'


--

use pubs
go

CREATE PROCEDURE proc_autori
(
@ImePrezime NVARCHAR(40)=NULL,
@Grad NVARCHAR(40)=NULL,
@Naslov NVARCHAR(40)=NULL,
@Vrsta NVARCHAR(40)=NULL,
@Cijena MONEY=NULL,
@decimalni_ostatak DECIMAL(8,2)=NULL
)
AS
BEGIN
	SELECT A.au_lname+A.au_lname AS 'ime i prezime',a.city,T.title,T.type,t.price
	FROM pubs.dbo.titles as T inner join pubs.dbo.titleauthor as TA
		ON T.title_id=TA.title_id
	INNER JOIN pubs.dbo.authors as A 
		ON TA.au_id=A.au_id
	WHERE @ImePrezime=A.au_lname+A.au_fname	OR
		  @Grad=A.city OR
		  @Vrsta=T.title OR
		  @Vrsta=T.type OR
		  @Cijena=T.price OR
		  T.price - FLOOR(T.price)=@decimalni_ostatak
END

-- FLOOR funkcija zaokruzuje


USE NORTHWND
GO

go
CREATE PROCEDURE proc_nortwind
(
@ImePrezime NVARCHAR(40)=NULL,
@Grad NVARCHAR(40)=NULL,
@NazivKompanije NVARCHAR(40)=NULL,
@broj_dana_razlike INT
)
AS
BEGIN
	SELECT E.FirstName+E.LastName,C.City,C.CompanyName
	FROM Customers AS C INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN Employees AS E
		ON O.EmployeeID=E.EmployeeID		
	WHERE DATEDIFF(DAY,O.OrderDate,O.ShippedDate)>10 AND
		  (
		  @ImePrezime=E.FirstName+E.LastName OR
		  @Grad=C.City OR
		  @NazivKompanije=C.CompanyName OR
	      DATEDIFF(DAY,O.OrderDate,O.ShippedDate) =@broj_dana_razlike
		  )
END

-- kada imamo onaj parametar kome hocemo da inicijalno postavimo vrijednost postavi se gore u definiciji 
-- kad imamo neku konkretnu vrijdnost gore onda dole u where mora da imamo AND jer smo tako gore postavili
--pa da bude neki drugi uslovi i to sto smo incijalno u () postavili


CREATE DATABASE aaa
go

use aaa
go

CREATE TABLE Proizvod
(
ProizvodID INT NOT NULL CONSTRAINT PK_ProizvodID PRIMARY KEY(ProizvodID) IDENTITY(1,1),
NazivProizvoda NVARCHAR(255) NOT NULL,
Cijena INT NOT NULL
)

CREATE TABLE PracenjePromjena
(
PromjenaID INT NOT NULL CONSTRAINT PK_PromjenaID PRIMARY KEY(PromjenaID) IDENTITY(1,1),
ProizvodID INT NOT NULL,
NazivProizvoda VARCHAR(255) NOT NULL,
Cijena INT NOT NULL,
DatumPromjene DATETIME NOT NULL, 
Operacija CHAR(3) NOT NULL CHECK(Operacija='INS' OR Operacija='DEL')
)
-- CHECK RADI da moze poprimitni jednu od zadatih vrijdnosti tj u ovom slucaju ili INS ILI DEL


GO
CREATE TRIGGER  nesto
ON Proizvod
AFTER INSERT,DELETE 
AS
BEGIN
	INSERT INTO Proizvod
	SELECT I.ProizvodID,I.NazivProizvoda,I.Cijena,GETDATE(),'INS'
	FROM inserted AS I
	UNION ALL
	SELECT D.ProizvodID,D.NazivProizvoda,D.Cijena,GETDATE(),'DEL'
	FROM deleted AS D
END


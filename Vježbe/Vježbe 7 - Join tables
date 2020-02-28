USE NORTHWND
GO

--1--

SELECT P.ProductName,OD.UnitPrice,O.OrderID
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID=O.OrderID

--2--

/*
U bazi Northwind_RADNA se nalazi tabela Products. Kreirati upit kojim ce se dati pregled ukupne novcane vrijednosti proizvoda,
 ukupnog stanja proizvoda na skladištu i ukupnog broja narucenih jedinica za dobavljaca (supplier) Pavlova, Ltd.
*/

SELECT SUM(P.UnitPrice) AS UkupnaCijena,SUM(P.UnitsInStock) AS NaStanju,SUM(P.UnitsOnOrder) as Naruceno,CompanyName
FROM Products AS P
LEFT JOIN Suppliers AS S
ON P.SupplierID=P.SupplierID
WHERE S.CompanyName LIKE 'Pav%'
GROUP BY s.CompanyName

--3--

/*
U bazi Northwind_RADNA se nalaze tabele Employees i Orders. Kreirati upit kojim ce se dati pregled svih uposlenika koji se nalaze 
na funkciji Sales Manager i ukupna vrijednost i ukupan broj transakcija u kojima je roba isporucena u Njemacku. U upit ukljuciti polja
 prezime i ime uposlenika, te mjesto stanovanja. Vrijednost transakcije se nalazi u polju Freight. Opis radnog mjesta se nalazi u polju
  Title. Naziv države u koju je roba isporucena se nalazi u polju Ship Country.*/

SELECT Title	--TEST
FROM Employees

SELECT E.FirstName,E.LastName,SUM(O.Freight) AS UkupnaSuma,O.ShipCountry,e.Title,E.Address
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
WHERE O.ShipCountry='Germany' AND e.Title='Sales Manager'
GROUP BY E.FirstName,E.LastName,O.ShipCountry,E.Address,E.Title

--4--

/*U bazi Northwind_RADNA se nalazi tabela Customers.
KREIRATI upit gdje ce se dobit prikaz svih kupaca sa osnovnim podacima i gdje je razlika dana manje od 15
*/

 SELECT c.ContactName, DATEDIFF(day,o.ShippedDate,o.RequiredDate) as [Razlika Dana]
 FROM Customers AS c
 INNER JOIN Orders AS o
 ON c.CustomerID= o.CustomerID
 ORDER BY c.ContactName ASC,[Razlika Dana] DESC

 --5--
 /*
 U bazi Northwind_RADNA se nalaze tabele Customers, Orders i Order Details . Kreirati upit koji ce dati pregled ukupnih vrijednosti i
  ukupnih narucenih kolicina kupaca koji su iz Austrije, pri cemu su narudžbu (OrderDate) izvršili prije 01.07.1997. U upit ukljuciti
   polje CompanyName, te potrebna agregatna polja koja ce se kreirati na osnovu polja UnitPrice i Quantity iz tabele Order Details*/

 
 SELECT c.CompanyName,SUM(OD.UnitPrice) AS UkupnaVrijednost,COUNT(OD.Quantity) AS [Ukupna kolicina],O.ShipCountry
 FROM Customers AS C
 INNER JOIN Orders AS O
 ON C.CustomerID=O.CustomerID
 INNER JOIN [Order Details] AS OD
 ON O.OrderID=OD.OrderID
 WHERE o.ShipCountry='Austria' AND o.OrderDate<'01/07/1997'
 GROUP BY c.CompanyName,o.ShipCountry

 --6--

 /*U bazi Northwind_RADNA se nalaze tabele Employees, EmployeesTerritories i Territories. 
 Kreirati upit kojim ce se dati pregled broja uposlenika po regijama evidentiranim u tabeli Territories*/

 SELECT COUNT(E.EmployeeID) AS [Ukupno radnika]
 FROM Employees AS E
 INNER JOIN EmployeeTerritories AS ET
 ON E.EmployeeID=ET.EmployeeID
 INNER JOIN Territories AS T
 ON ET.TerritoryID=T.TerritoryID


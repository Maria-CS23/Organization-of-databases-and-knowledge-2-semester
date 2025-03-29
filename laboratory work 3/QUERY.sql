-- Формування запитів із використанням багатотабличних дій
SELECT 
    O.OrderID,
    O.OrderDate,
    O.CompletionDate,
    O.OrderAmount,
    C.Type AS ClientType,
    (SELECT I.FullName FROM Individual I WHERE I.ClientID = O.ClientID) AS ClientName,
    (SELECT L.CompanyName FROM LegalEntity L WHERE L.ClientID = O.ClientID) AS CompanyName,
    P.Manufacturer,
    P.Model,
    P.Price
FROM Orders O
JOIN OrderLine OL ON O.OrderID = OL.OrderID
JOIN Phone P ON OL.PhoneID = P.PhoneID
JOIN Client C ON O.ClientID = C.ClientID;


SELECT 
    I.FullName AS ClientName,
    I.PhoneNumber AS ClientPhone,
    I.Address AS ClientAddress,
    I.Email AS ClientEmail
FROM Individual I

UNION

SELECT 
    L.CompanyName AS ClientName,
    L.PhoneNumber AS ClientPhone,
    L.Address AS ClientAddress,
    L.Email AS ClientEmail
FROM LegalEntity L;


SELECT 
    O.OrderID,
    O.OrderDate,
    P.Model,
    P.Price
FROM Orders O
JOIN OrderLine OL ON O.OrderID = OL.OrderID
JOIN Phone P ON OL.PhoneID = P.PhoneID
WHERE P.Price > (SELECT AVG(Price) FROM Phone);


SELECT 
    L.CompanyName AS ClientName,
    O.OrderDate,
    P.Model AS PhoneModel,
    P.Price
FROM Orders O
JOIN OrderLine OL ON O.OrderID = OL.OrderID
JOIN Phone P ON OL.PhoneID = P.PhoneID
JOIN LegalEntity L ON O.ClientID = L.ClientID
WHERE P.Price > 24000 AND O.OrderID IN (SELECT OrderID FROM OrderLine WHERE PhoneID = P.PhoneID);


SELECT 
    P.Manufacturer,
    P.Model,
    P.Price,
    (SELECT SUM(OL.Quantity) 
     FROM OrderLine OL 
     WHERE OL.PhoneID = P.PhoneID) AS TotalOrdered
FROM Phone P
WHERE EXISTS (SELECT 1 FROM OrderLine OL WHERE OL.PhoneID = P.PhoneID);



















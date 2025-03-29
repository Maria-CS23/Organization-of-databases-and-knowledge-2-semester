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


-- Формування запитів із каскадними діями
DELETE FROM Client WHERE ClientID = 1;

DELETE FROM Orders WHERE OrderID = 3;

DELETE FROM Phone WHERE PhoneID = 1;

UPDATE OrderLine SET Quantity = 5 WHERE LineID = 2;

UPDATE Phone SET Price = 45990 WHERE PhoneID = 7;

UPDATE Phone SET Model = 'Redmi Note 13' WHERE PhoneID = 5;


-- Формування запитів із використанням сортування даних (ORDER BY)
SELECT * FROM Client
ORDER BY RegistrationDate DESC;

SELECT * FROM Phone
ORDER BY Price ASC;

SELECT * FROM Orders
ORDER BY OrderDate ASC;

SELECT * FROM Orders
WHERE OrderAmount > 1000
ORDER BY OrderAmount DESC;

SELECT * FROM LegalEntity
ORDER BY CompanyName ASC;

SELECT * FROM Individual
ORDER BY FullName ASC;


-- Використання булевих та реляційних операторів
SELECT C.ClientID, C.Type, C.RegistrationDate
FROM Client C
WHERE C.RegistrationDate > '2022-08-15'
AND (EXISTS (SELECT 1 FROM Individual I WHERE I.ClientID = C.ClientID) OR EXISTS (SELECT 1 FROM LegalEntity L WHERE L.ClientID = C.ClientID));

SELECT PhoneID, Manufacturer, Model, Price, Availability
FROM Phone
WHERE Price > 67900 AND Availability = 'В наявності';

SELECT o.OrderID, o.OrderDate, o.CompletionDate, o.OrderAmount
FROM Orders o
WHERE o.CompletionDate > '2025-02-28' AND o.OrderAmount >= 19000;

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Manufacturer <> 'Xiaomi';

SELECT Orders.OrderID, Client.Type, Orders.OrderAmount, Phone.Manufacturer, Phone.Model
FROM Orders
JOIN Client ON Orders.ClientID = Client.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID
WHERE Client.Type = 'Юридична особа' AND Orders.OrderAmount > 195800;


-- Розширене використання оператора JOIN у складних запитах
SELECT o.OrderID, o.OrderDate, c.ClientID, i.FullName, l.CompanyName, p.Manufacturer, p.Model, ol.Quantity, p.Specifications, p.Price
FROM Orders o
INNER JOIN Client c ON o.ClientID = c.ClientID
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity l ON c.ClientID = l.ClientID
INNER JOIN OrderLine ol ON o.OrderID = ol.OrderID
INNER JOIN Phone p ON ol.PhoneID = p.PhoneID;

SELECT c.ClientID, i.FullName, l.CompanyName, o.OrderID, o.OrderDate
FROM Client c
FULL JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity l ON c.ClientID = l.ClientID;

SELECT c.ClientID, i.FullName, l.CompanyName, p.Manufacturer, p.Model, ol.Quantity
FROM Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity l ON c.ClientID = l.ClientID
LEFT JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN OrderLine ol ON o.OrderID = ol.OrderID
LEFT JOIN Phone p ON ol.PhoneID = p.PhoneID;

SELECT ol.OrderID, p.PhoneID, p.Manufacturer, p.Model, p.Availability, ol.Quantity
FROM OrderLine ol
LEFT JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Orders o ON ol.OrderID = o.OrderID;

SELECT c.ClientID, 
       i.FullName AS IndividualName, 
       l.CompanyName AS LegalEntityName, 
       SUM(o.OrderAmount) AS TotalSpent
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity l ON c.ClientID = l.ClientID
GROUP BY c.ClientID, i.FullName, l.CompanyName
ORDER BY TotalSpent DESC;
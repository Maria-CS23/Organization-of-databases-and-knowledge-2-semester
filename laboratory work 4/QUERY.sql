-- ����������� ������ 2
-- ���������� ������ �� ������������� ���� ������ (WHERE)
SELECT ClientID, Type, RegistrationDate FROM Client
WHERE RegistrationDate > '2024-05-01';

SELECT OrderID, ClientID, OrderDate, OrderAmount FROM Orders
WHERE OrderAmount > 55000;

SELECT PhoneID, Manufacturer, Model, Price FROM Phone
WHERE Manufacturer = 'Xiaomi';

SELECT PhoneID, Manufacturer, Model, Price FROM Phone
WHERE Price < 9000;

SELECT PhoneID, Manufacturer, Model, Availability FROM Phone
WHERE Availability = '���� � ��������';

-- ������������ ������� ��������� � ������������ WHERE
SELECT PhoneID, Manufacturer, Model, Price, Availability
FROM Phone
WHERE Availability = '� ��������' AND Price < 24000;

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE NOT (Manufacturer = 'Samsung' OR Manufacturer = 'Apple')
AND Price > 20000;

SELECT OrderID, ClientID, OrderAmount
FROM Orders
WHERE OrderAmount > 15000 AND OrderAmount < 25000
AND ClientID IN (SELECT ClientID FROM Client WHERE RegistrationDate < '2024-10-13');

SELECT ClientID
FROM Orders
WHERE OrderAmount > 67000
AND ClientID NOT IN (SELECT ClientID FROM Orders WHERE OrderAmount < 16000);

SELECT ClientID, FullName, Address
FROM Individual
WHERE ClientID NOT IN (SELECT ClientID FROM Orders);

-- ������������ ��������� LIKE ��� ������ ������� � �����
SELECT ClientID, FullName
FROM Individual
WHERE FullName LIKE '%������%';

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Model LIKE 'Redmi%';

SELECT ClientID, FullName, Address
FROM Individual
WHERE Address LIKE '%�������%';

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Model LIKE '%Pro%';

SELECT ClientID, Type, RegistrationDate
FROM Client
WHERE RegistrationDate = '2024-11-22';

-- ������������ ��������� JOIN ��� ��������� ��������������� ������
SELECT LegalEntity.CompanyName, LegalEntity.Address, Client.Type
FROM Client
JOIN LegalEntity ON Client.ClientID = LegalEntity.ClientID;

SELECT Individual.FullName, Phone.Model, OrderLine.Quantity
FROM Individual
JOIN Orders ON Individual.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID;

SELECT Client.ClientID, Client.Type, Orders.OrderID, Orders.OrderDate, Orders.OrderAmount
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID;

SELECT OrderLine.OrderID, Phone.Manufacturer, Phone.Model, Phone.Price
FROM OrderLine
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID;

SELECT LegalEntity.CompanyName, Phone.Model, OrderLine.Quantity
FROM LegalEntity
JOIN Client ON LegalEntity.ClientID = Client.ClientID
JOIN Orders ON Client.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID;

-- ��������� ������������ ��������� JOIN � �������� �������
SELECT c.ClientID, c.Type, c.RegistrationDate, o.OrderID, o.OrderDate
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID;

SELECT o.OrderID, o.OrderDate, c.ClientID, c.Type
FROM Orders o
RIGHT JOIN Client c ON o.ClientID = c.ClientID;

SELECT c.ClientID, c.Type, p.PhoneID, p.Manufacturer, p.Model
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN OrderLine ol ON o.OrderID = ol.OrderID
LEFT JOIN Phone p ON ol.PhoneID = p.PhoneID;

SELECT le.CompanyName, o.OrderID, o.OrderDate
FROM LegalEntity le
FULL JOIN Orders o ON le.ClientID = o.ClientID;

SELECT c.ClientID, c.Type, o.OrderID, o.OrderDate, p.PhoneID, p.Model, p.Availability
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
RIGHT JOIN OrderLine ol ON o.OrderID = ol.OrderID
RIGHT JOIN Phone p ON ol.PhoneID = p.PhoneID;

-- ������ � ���������� �������� (SUBQUERY) ��� ��������� ������� ������
SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Manufacturer = 'OnePlus'
);

SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID NOT IN (
    SELECT o.ClientID
    FROM Orders o
);

SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    WHERE ol.Quantity > 4
);

SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Specifications LIKE '%256GB%'
);

SELECT o.OrderID, o.OrderDate, o.OrderAmount
FROM Orders o
WHERE o.OrderID IN (
    SELECT ol.OrderID
    FROM OrderLine ol
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Price > 74000
);

-- ������������ ��������� GROUP BY �� ����� HAVING � ������� � JOIN
SELECT p.Model, SUM(ol.Quantity) AS TotalSold
FROM OrderLine ol
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY p.Model
HAVING SUM(ol.Quantity) > 23;

SELECT le.CompanyName, SUM(o.OrderAmount) AS TotalOrderSum
FROM LegalEntity le
JOIN Orders o ON le.ClientID = o.ClientID
GROUP BY le.CompanyName
HAVING SUM(o.OrderAmount) > 89000;

SELECT c.ClientID, COUNT(o.OrderID) AS TotalOrders
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
GROUP BY c.ClientID
HAVING COUNT(o.OrderID) > 1;

SELECT p.Manufacturer, p.Model, SUM(ol.Quantity) AS TotalSold
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
GROUP BY p.Manufacturer, p.Model
HAVING SUM(ol.Quantity) > 17;

SELECT p.Manufacturer, SUM(ol.Quantity) AS TotalOrdered
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
GROUP BY p.Manufacturer
HAVING SUM(ol.Quantity) > 34;

-- ���������� �������� ��������������� ������
SELECT p.PhoneID, p.Model, p.Price, COUNT(ol.OrderID) AS OrderCount
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
GROUP BY p.PhoneID, p.Model, p.Price
HAVING COUNT(ol.OrderID) > 1
AND p.Price = (SELECT MAX(Price) FROM Phone);

SELECT p.PhoneID, p.Model
FROM Phone p
WHERE p.PhoneID IN (
    SELECT ol.PhoneID
    FROM OrderLine ol
    JOIN Orders o ON ol.OrderID = o.OrderID
    WHERE o.ClientID IN (
        SELECT c.ClientID
        FROM Client c
        WHERE c.RegistrationDate BETWEEN '2023-01-01' AND '2023-12-31'
    )
);

SELECT c.ClientID, c.Type
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Specifications LIKE '%512GB%'
    GROUP BY o.ClientID
    HAVING SUM(ol.Quantity * p.Price) > 38000
);

SELECT c.ClientID, c.Type, p.Model, p.Price
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Price = (
    SELECT MAX(Price) FROM Phone
);

SELECT p.Manufacturer, p.Model
FROM Phone p
WHERE p.PhoneID NOT IN (
    SELECT DISTINCT ol.PhoneID
    FROM OrderLine ol
    JOIN Orders o ON ol.OrderID = o.OrderID
    JOIN Client c ON o.ClientID = c.ClientID
    JOIN Individual i ON c.ClientID = i.ClientID
)
AND p.PhoneID IN (
    SELECT DISTINCT ol.PhoneID
    FROM OrderLine ol
);

-- �������� ���� ���������� (WHERE) �� ����������� �ᒺ������ ������� (JOIN)
SELECT Client.ClientID, Client.Type, Orders.OrderID, Orders.OrderDate, OrderLine.Quantity, Phone.Manufacturer, Phone.Model
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID
WHERE Phone.PhoneID = 31;

SELECT i.FullName, o.OrderID, p.Model, p.Price
FROM Individual i
JOIN Client c ON i.ClientID = c.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Price BETWEEN 35000 AND 76000;

SELECT c.ClientID, le.CompanyName, o.OrderID, p.Manufacturer, p.Model, p.Price
FROM Orders o
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
JOIN Client c ON o.ClientID = c.ClientID
JOIN LegalEntity le ON c.ClientID = le.ClientID
WHERE p.Manufacturer = 'Samsung' AND p.Price <= 30000;

SELECT c.ClientID, c.Type, i.FullName
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN OrderLine ol ON o.OrderID = ol.OrderID
LEFT JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Individual i ON c.ClientID = i.ClientID
WHERE o.OrderID IS NULL;

SELECT o.OrderID, o.OrderDate, o.OrderAmount, i.FullName, p.Model
FROM Orders o
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
JOIN Client c ON o.ClientID = c.ClientID
JOIN Individual i ON c.ClientID = i.ClientID
WHERE i.Address = '�����, ���. ������������, 15';

-- �������� 14
SELECT l.CompanyName, p.Model, SUM(p.Price * ol.Quantity) AS TotalSpent
FROM LegalEntity l
JOIN Orders o ON l.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Model = 'Galaxy A53'
GROUP BY l.CompanyName, p.Model;

SELECT p.Manufacturer, p.Model, SUM(ol.Quantity) AS TotalQuantitySold
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
WHERE p.Price > 34000
GROUP BY p.Manufacturer, p.Model
HAVING SUM(ol.Quantity) > 9;

SELECT c.ClientID, SUM(p.Price * ol.Quantity) AS TotalSpent
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Price BETWEEN 20000 AND 40000
GROUP BY c.ClientID;

SELECT l.CompanyName, SUM(ol.Quantity) AS TotalPhonesOrdered
FROM LegalEntity l
JOIN Orders o ON l.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
GROUP BY l.CompanyName;

SELECT DISTINCT l.CompanyName
FROM LegalEntity l
JOIN Orders o ON l.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Model = 'Galaxy S23';

-- ����������� ������ 3
-- ���������� ������ �� ������������� ��������������� ��
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


-- ���������� ������ �� ���������� ����
DELETE FROM Client WHERE ClientID = 1;

DELETE FROM Orders WHERE OrderID = 3;

DELETE FROM Phone WHERE PhoneID = 1;

UPDATE OrderLine SET Quantity = 5 WHERE LineID = 2;

UPDATE Phone SET Price = 45990 WHERE PhoneID = 7;

UPDATE Phone SET Model = 'Redmi Note 13' WHERE PhoneID = 5;


-- ���������� ������ �� ������������� ���������� ����� (ORDER BY)
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


-- ������������ ������� �� ���������� ���������
SELECT C.ClientID, C.Type, C.RegistrationDate
FROM Client C
WHERE C.RegistrationDate > '2022-08-15'
AND (EXISTS (SELECT 1 FROM Individual I WHERE I.ClientID = C.ClientID) OR EXISTS (SELECT 1 FROM LegalEntity L WHERE L.ClientID = C.ClientID));

SELECT PhoneID, Manufacturer, Model, Price, Availability
FROM Phone
WHERE Price > 67900 AND Availability = '� ��������';

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
WHERE Client.Type = '�������� �����' AND Orders.OrderAmount > 195800;


-- ��������� ������������ ��������� JOIN � �������� �������
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

-- ������������ ��������� GROUP BY �� ����� HAVING � ������� � JOIN
SELECT p.Manufacturer, p.Model, SUM(ol.Quantity) AS TotalSold
FROM OrderLine ol
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY p.Manufacturer, p.Model
HAVING SUM(ol.Quantity) > 12;

SELECT le.CompanyName, COUNT(o.OrderID) AS OrderCount
FROM Orders o
JOIN LegalEntity le ON o.ClientID = le.ClientID
GROUP BY le.CompanyName
HAVING COUNT(o.OrderID) >= 2;

SELECT p.Manufacturer, SUM(ol.Quantity) AS TotalSold
FROM OrderLine ol
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY p.Manufacturer
HAVING SUM(ol.Quantity) > 45;

SELECT p.Manufacturer, p.Model, p.Price, COUNT(ol.LineID) AS OrderCount
FROM OrderLine ol
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY p.Manufacturer, p.Model, p.Price
HAVING p.Price > 55000;

SELECT YEAR(o.OrderDate) AS OrderYear, 
       MONTH(o.OrderDate) AS OrderMonth, 
       AVG(ol.Quantity) AS AvgPhonesPerOrder
FROM Orders o
JOIN OrderLine ol ON o.OrderID = ol.OrderID
WHERE YEAR(o.OrderDate) = 2025
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
HAVING AVG(ol.Quantity) > 2;

-- �������� 12
SELECT i.FullName, i.Address, SUM(ol.Quantity) AS TotalPhonesOrdered
FROM Individual i
JOIN Client c ON i.ClientID = c.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
GROUP BY i.FullName, i.Address;


SELECT p.Manufacturer, p.Model, p.Price, p.Availability
FROM Phone p
WHERE p.Availability = '� ��������';

SELECT c.ClientID,
    CASE 
        WHEN i.ClientID IS NOT NULL THEN i.FullName
        ELSE le.CompanyName 
    END AS ClientName,
    o.OrderID,
    o.OrderDate,
    o.CompletionDate,
    o.OrderAmount
FROM Orders o
JOIN Client c ON o.ClientID = c.ClientID
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID;

SELECT le.CompanyName, p.Model, SUM(ol.Quantity) AS TotalQuantityOrdered
FROM LegalEntity le
JOIN Client c ON le.ClientID = c.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY le.CompanyName, p.Model;
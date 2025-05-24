-- Завдання 3
CREATE VIEW vClientNames AS
SELECT 
    i.ClientID,
    i.FullName AS Name
FROM Individual i

UNION

SELECT 
    l.ClientID,
    l.CompanyName AS Name
FROM LegalEntity l;


-- Завдання 4
SELECT ClientID, Name FROM vClientNames;

-- Завдання 5
CREATE VIEW vPremiumPhones AS
SELECT *
FROM Phone
WHERE Price > 20000;


SELECT * FROM vPremiumPhones;


-- Завдання 6
UPDATE vPremiumPhones
SET Price = 30000.00
WHERE PhoneID = 1;

SELECT * FROM Phone WHERE PhoneID = 1;


-- Завдання 7

CREATE VIEW vClientOrders AS
SELECT 
    c.ClientID, 
    CASE 
        WHEN i.FullName IS NOT NULL THEN i.FullName
        WHEN le.CompanyName IS NOT NULL THEN le.CompanyName
        ELSE 'Невідомий клієнт'
    END AS ClientName,
    o.OrderID, 
    o.OrderDate,
    o.OrderAmount,
    o.OrderStatus
FROM Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
JOIN Orders o ON c.ClientID = o.ClientID;


SELECT * FROM vClientOrders;


-- Завдання 8

CREATE VIEW vClientOrderCounts AS
SELECT 
    c.ClientID, 
    CASE 
        WHEN i.FullName IS NOT NULL THEN i.FullName
        WHEN le.CompanyName IS NOT NULL THEN le.CompanyName
        ELSE 'Невідомий клієнт'
    END AS ClientName,
    COUNT(o.OrderID) AS OrderCount
FROM Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
LEFT JOIN Orders o ON c.ClientID = o.ClientID
GROUP BY c.ClientID, i.FullName, le.CompanyName;


SELECT * FROM vClientOrderCounts;


-- Завдання 9

-- Завдання 10

-- Завдання 11

-- Завдання 12

-- Завдання 13

-- Завдання 14

-- Завдання 15

-- Завдання 16

-- Завдання 17
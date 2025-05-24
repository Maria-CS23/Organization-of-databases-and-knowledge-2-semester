-- �������� 3
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


-- �������� 4
SELECT ClientID, Name FROM vClientNames;

-- �������� 5
CREATE VIEW vPremiumPhones AS
SELECT *
FROM Phone
WHERE Price > 20000;


SELECT * FROM vPremiumPhones;


-- �������� 6
UPDATE vPremiumPhones
SET Price = 30000.00
WHERE PhoneID = 1;

SELECT * FROM Phone WHERE PhoneID = 1;


-- �������� 7

CREATE VIEW vClientOrders AS
SELECT 
    c.ClientID, 
    CASE 
        WHEN i.FullName IS NOT NULL THEN i.FullName
        WHEN le.CompanyName IS NOT NULL THEN le.CompanyName
        ELSE '�������� �볺��'
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


-- �������� 8

CREATE VIEW vClientOrderCounts AS
SELECT 
    c.ClientID, 
    CASE 
        WHEN i.FullName IS NOT NULL THEN i.FullName
        WHEN le.CompanyName IS NOT NULL THEN le.CompanyName
        ELSE '�������� �볺��'
    END AS ClientName,
    COUNT(o.OrderID) AS OrderCount
FROM Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
LEFT JOIN Orders o ON c.ClientID = o.ClientID
GROUP BY c.ClientID, i.FullName, le.CompanyName;


SELECT * FROM vClientOrderCounts;


-- �������� 9

-- �������� 10

-- �������� 11

-- �������� 12

-- �������� 13

-- �������� 14

-- �������� 15

-- �������� 16

-- �������� 17
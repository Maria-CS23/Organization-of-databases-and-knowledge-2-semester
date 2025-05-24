-- �������� 3
CREATE VIEW vClientNames AS
SELECT 
    ClientID, 
    FullName
FROM Individual;


-- �������� 4
SELECT ClientID, FullName FROM vClientNames;


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

CREATE VIEW vVIPClients AS
SELECT ClientID, ClientName, OrderCount
FROM vClientOrderCounts
WHERE OrderCount > 3;


SELECT * FROM vVIPClients;


-- �������� 10

ALTER VIEW vClientOrders AS
SELECT 
    c.ClientID, 
    c.Type AS ClientType,
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


-- �������� 11

DROP VIEW vVIPClients;

-- �������� 12

CREATE VIEW vOrderSummary AS
SELECT 
    OrderID, 
    OrderAmount AS TotalCost, 
    OrderDate AS PurchaseDate,
    OrderStatus AS Status
FROM Orders;


SELECT * FROM vOrderSummary;


-- �������� 13

CREATE VIEW vPhonePriceWithTax AS
SELECT 
    PhoneID,
    Manufacturer,
    Model,
    Price AS BasePrice,
    Price * 1.15 AS PriceWithTax
FROM Phone;


SELECT * FROM vPhonePriceWithTax;


-- �������� 14

CREATE VIEW vExpensivePhones AS
SELECT *
FROM Phone
WHERE Price > 800
WITH CHECK OPTION;


INSERT INTO vExpensivePhones (PhoneID, Manufacturer, Model, Specifications, Price, Availability) 
VALUES (11, 'Xiaomi', 'Redmi 10', '64GB, Carbon Gray', 600, N'� ��������');


-- �������� 15

CREATE VIEW vEncryptedPhoneList
WITH ENCRYPTION
AS
SELECT PhoneID, Manufacturer, Model, Price
FROM Phone;


SELECT * FROM vEncryptedPhoneList;

sp_helptext 'vEncryptedPhoneList';


-- �������� 16

CREATE VIEW vRestrictedPayments AS
SELECT 
    PaymentID,
    PaymentDate,
    PaymentStatus
FROM Payment;


GRANT SELECT ON vRestrictedPayments TO ReadOnlyUser;
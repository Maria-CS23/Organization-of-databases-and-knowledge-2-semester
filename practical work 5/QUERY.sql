-- кількість записів в кожній таблиці
SELECT 'Client' AS TableName, COUNT(*) AS RecordCount FROM Client
UNION ALL
SELECT 'Phone', COUNT(*) FROM Phone
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderLine', COUNT(*) FROM OrderLine
UNION ALL
SELECT 'Individual', COUNT(*) FROM Individual
UNION ALL
SELECT 'LegalEntity', COUNT(*) FROM LegalEntity;

-- Завдання 3
SELECT * FROM Client
WHERE RegistrationDate > '2022-01-01'
ORDER BY RegistrationDate;

-- Завдання 4
SELECT o.OrderID, c.Type, o.OrderAmount 
FROM Orders o
JOIN Client c ON o.ClientID = c.ClientID
WHERE o.OrderDate >= '2024-01-01'
ORDER BY o.OrderAmount DESC;

SELECT OrderID, ClientID, OrderAmount
FROM Orders
WHERE OrderAmount > 1000
ORDER BY OrderAmount DESC;

SELECT i.FullName, o.OrderID, o.OrderAmount
FROM Individual i
JOIN Orders o ON i.ClientID = o.ClientID
ORDER BY o.OrderAmount DESC;

-- Завдання 5
CREATE CLUSTERED INDEX IX_Client_RegistrationDate ON Client(RegistrationDate);

-- Завдання 6
CREATE NONCLUSTERED INDEX IX_Orders_AmountDate ON Orders(OrderAmount, OrderDate);

-- Завдання 7
CREATE UNIQUE INDEX IX_Individual_Email_Unique ON Individual(Email);

-- Завдання 8
SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 157;

CREATE NONCLUSTERED INDEX IX_Orders_ClientID_Include
ON Orders(ClientID)
INCLUDE(OrderID, OrderAmount, OrderDate);

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 157;
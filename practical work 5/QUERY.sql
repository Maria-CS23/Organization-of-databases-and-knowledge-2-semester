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


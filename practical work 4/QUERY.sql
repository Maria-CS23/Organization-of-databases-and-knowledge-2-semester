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

--  запити з використанням інших агрегатних функцій
SELECT SUM(OrderAmount) AS TotalRevenue FROM Orders;

SELECT AVG(Price) AS AveragePhonePrice FROM Phone;

SELECT MAX(Price) AS MaxPrice, MIN(Price) AS MinPrice FROM Phone;

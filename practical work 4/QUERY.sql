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

-- 3 запити з використанням віконних функцій
SELECT ClientID, OrderAmount,
    SUM(OrderAmount) OVER (PARTITION BY ClientID) AS TotalPerClient
FROM Orders;

SELECT ClientID, OrderID, OrderDate,
    ROW_NUMBER() OVER (PARTITION BY ClientID ORDER BY OrderDate) AS OrderNum
FROM Orders;

SELECT Manufacturer, Model, Specifications, Price,
    LAG(Price) OVER (PARTITION BY Manufacturer ORDER BY Model) AS PreviousModelPrice
FROM Phone;
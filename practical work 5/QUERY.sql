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

-- Завдання 9
CREATE NONCLUSTERED INDEX IX_Phone_Filtered_Availability
ON Phone(Availability)
WHERE Availability = 'В наявності';

-- Завдання 10
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    ips.index_type_desc,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE i.name IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC;

-- Завдання 11
ALTER INDEX IX_Client_RegistrationDate ON Client REORGANIZE;

-- Завдання 12
ALTER INDEX IX_Client_RegistrationDate ON Client REBUILD;

-- Завдання 13
CREATE NONCLUSTERED INDEX IX_Client_Type ON Client(Type);

DROP INDEX IX_Client_Type ON Client;

-- Завдання 14
SELECT * FROM LegalEntity WHERE TaxID = '2934567891';

CREATE UNIQUE INDEX IX_LegalEntity_TaxID ON LegalEntity(TaxID);

SELECT * FROM LegalEntity WHERE TaxID = '2934567891';

-- Завдання 15
SELECT * FROM Orders WHERE OrderAmount > 5000 ORDER BY OrderDate;

-- Завдання 16
SELECT
 DB_NAME() AS [База_даних],
 OBJECT_NAME(i.[object_id]) AS [Таблиця],
 i.name AS [Індекс],
 i.type_desc AS [Тип_індексу],
 i.is_unique AS [Унікальний],
 ps.avg_fragmentation_in_percent AS [Фрагментація_у_%],
 ps.page_count AS [Кількість_сторінок]
FROM
 sys.indexes AS i
INNER JOIN
 sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
 ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE
 i.type > 0 AND i.is_hypothetical = 0
ORDER BY
 ps.avg_fragmentation_in_percent DESC;
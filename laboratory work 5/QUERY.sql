-- Завдання 3
SET STATISTICS TIME ON;
GO

SELECT DeliveryID, DeliveryStatus, DeliveryMethod FROM Delivery WHERE DeliveryStatus = N'Доставлено' AND DeliveryMethod = N'Нова Пошта';

SELECT Email FROM Individual WHERE Email = N'oleksii.melnyk264@example.com';

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 101;

SELECT PhoneID, Manufacturer, Model FROM Phone WHERE Availability = N'В наявності';



CREATE NONCLUSTERED INDEX IX_Delivery_StatusMethod ON Delivery(DeliveryStatus, DeliveryMethod);

CREATE UNIQUE INDEX IX_Individual_Email_Unique ON Individual(Email);

CREATE NONCLUSTERED INDEX IX_Orders_ClientID_Include
ON Orders(ClientID)
INCLUDE(OrderID, OrderAmount, OrderDate);

CREATE NONCLUSTERED INDEX IX_Phone_Filtered_Availability
ON Phone(Availability)
WHERE Availability = 'В наявності';


SELECT DeliveryID, DeliveryStatus, DeliveryMethod FROM Delivery WHERE DeliveryStatus = N'Доставлено' AND DeliveryMethod = N'Нова Пошта';

SELECT Email FROM Individual WHERE Email = N'oleksii.melnyk264@example.com';

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 101;

SELECT PhoneID, Manufacturer, Model FROM Phone WHERE Availability = N'В наявності';

-- Завдання 4
SELECT d.DeliveryID, d.DeliveryMethod, d.DeliveryStatus, o.OrderDate
FROM Delivery d
JOIN Orders o ON d.OrderID = o.OrderID
WHERE d.DeliveryStatus = N'Доставлено' AND d.DeliveryMethod = N'Укрпошта';

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Availability = N'В наявності' AND Price > 20000;

SELECT c.ClientID, i.FullName, o.OrderAmount
FROM Client c
JOIN Individual i ON c.ClientID = i.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
WHERE o.OrderAmount > 5000;


-- Завдання 5
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


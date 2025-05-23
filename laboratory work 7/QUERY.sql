-- ����������� ������ 4
-- �������� 3

SELECT PhoneID, Manufacturer, Model, Price, dbo.GetDiscountedPrice(Price, 10) AS DiscountedPrice
FROM Phone;

SELECT ClientID, Type, dbo.GetClientInfo(ClientID) AS ClientInfo
FROM Client;

SELECT OrderID, OrderDate, CompletionDate, dbo.GetOrderStatus(CompletionDate) AS Status
FROM Orders;

-- �������� 4

SELECT * FROM dbo.GetOrderTotalAmount();

SELECT * FROM dbo.GetPhonesMoreExpensiveThan(45000.00);

SELECT * FROM dbo.GetOrdersByClient(122);

-- �������� 5

SELECT * FROM dbo.GetAvailablePhonesBelowPrice(23000.00);

SELECT * FROM dbo.GetAvailablePhonesWithCategory();

SELECT c.ClientID, c.Type, fc.TotalOrders
FROM Client c
JOIN dbo.GetFrequentClients() fc ON c.ClientID = fc.ClientID;

-- �������� 6

SELECT * FROM dbo.GetTop3Clients();

SELECT * FROM dbo.GetPhoneSalesByManufacturer();

SELECT * FROM dbo.GetPhonesWithoutOrders();

SELECT dbo.GetDaysSinceLastOrder(182) AS DaysSinceLastOrder;

SELECT * FROM dbo.GetPhoneByMonth();

-- �������� 9

SELECT TOP 3 
    c.ClientID,
    c.Type,
    SUM(o.OrderAmount) AS TotalSpent
FROM Orders o
JOIN Client c ON o.ClientID = c.ClientID
GROUP BY c.ClientID, c.Type
ORDER BY TotalSpent DESC;


SELECT 
    p.Manufacturer,
    SUM(ol.Quantity) AS TotalSold
FROM OrderLine ol
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY p.Manufacturer;


SELECT p.PhoneID, p.Model
FROM Phone p
LEFT JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
WHERE ol.PhoneID IS NULL;


SELECT 
    c.ClientID,
    DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder
FROM Orders o
JOIN Client c ON o.ClientID = c.ClientID
GROUP BY c.ClientID;


SELECT 
    FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
    p.PhoneID,
    p.Manufacturer,
    p.Model,
    SUM(ol.Quantity) AS TotalSold
FROM Orders o
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM'), p.PhoneID, p.Manufacturer, p.Model
ORDER BY YearMonth DESC, TotalSold DESC;

-- ����������� ������ 5
-- �������� 3
SET STATISTICS TIME ON;
GO

SELECT DeliveryID, DeliveryStatus, DeliveryMethod FROM Delivery WHERE DeliveryStatus = N'����������' AND DeliveryMethod = N'���� �����';

SELECT Email FROM Individual WHERE Email = N'oleksii.melnyk264@example.com';

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 101;

SELECT PhoneID, Manufacturer, Model FROM Phone WHERE Availability = N'� ��������';



CREATE NONCLUSTERED INDEX IX_Delivery_StatusMethod ON Delivery(DeliveryStatus, DeliveryMethod);

CREATE UNIQUE INDEX IX_Individual_Email_Unique ON Individual(Email);

CREATE NONCLUSTERED INDEX IX_Orders_ClientID_Include
ON Orders(ClientID)
INCLUDE(OrderID, OrderAmount, OrderDate);

CREATE NONCLUSTERED INDEX IX_Phone_Filtered_Availability
ON Phone(Availability)
WHERE Availability = '� ��������';


SELECT DeliveryID, DeliveryStatus, DeliveryMethod FROM Delivery WHERE DeliveryStatus = N'����������' AND DeliveryMethod = N'���� �����';

SELECT Email FROM Individual WHERE Email = N'oleksii.melnyk264@example.com';

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 101;

SELECT PhoneID, Manufacturer, Model FROM Phone WHERE Availability = N'� ��������';

-- �������� 4
SELECT d.DeliveryID, d.DeliveryMethod, d.DeliveryStatus, o.OrderDate
FROM Delivery d
JOIN Orders o ON d.OrderID = o.OrderID
WHERE d.DeliveryStatus = N'����������' AND d.DeliveryMethod = N'��������';

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Availability = N'� ��������' AND Price > 20000;

SELECT c.ClientID, i.FullName, o.OrderAmount
FROM Client c
JOIN Individual i ON c.ClientID = i.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
WHERE o.OrderAmount > 5000;


-- �������� 5
SELECT
 DB_NAME() AS [����_�����],
 OBJECT_NAME(i.[object_id]) AS [�������],
 i.name AS [������],
 i.type_desc AS [���_�������],
 i.is_unique AS [���������],
 ps.avg_fragmentation_in_percent AS [������������_�_%],
 ps.page_count AS [ʳ������_�������]
FROM
 sys.indexes AS i
INNER JOIN
 sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
 ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE
 i.type > 0 AND i.is_hypothetical = 0
ORDER BY
 ps.avg_fragmentation_in_percent DESC;
-- Завдання 3

SELECT PhoneID, Manufacturer, Model, Price, dbo.GetDiscountedPrice(Price, 10) AS DiscountedPrice
FROM Phone;

SELECT ClientID, Type, dbo.GetClientInfo(ClientID) AS ClientInfo
FROM Client;

SELECT OrderID, OrderDate, CompletionDate, dbo.GetOrderStatus(CompletionDate) AS Status
FROM Orders;

-- Завдання 4

SELECT * FROM dbo.GetOrderTotalAmount();

SELECT * FROM dbo.GetPhonesMoreExpensiveThan(45000.00);

SELECT * FROM dbo.GetOrdersByClient(122);

-- Завдання 5

SELECT * FROM dbo.GetAvailablePhonesBelowPrice(23000.00);

SELECT * FROM dbo.GetAvailablePhonesWithCategory();

SELECT c.ClientID, c.Type, fc.TotalOrders
FROM Client c
JOIN dbo.GetFrequentClients() fc ON c.ClientID = fc.ClientID;

-- Завдання 6

SELECT * FROM dbo.GetTop3Clients();

SELECT * FROM dbo.GetPhoneSalesByManufacturer();

SELECT * FROM dbo.GetPhonesWithoutOrders();

SELECT dbo.GetDaysSinceLastOrder(182) AS DaysSinceLastOrder;

SELECT * FROM dbo.GetPhoneByMonth();

-- Завдання 9

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
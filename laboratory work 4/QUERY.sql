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
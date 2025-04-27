-- Завдання 6
EXEC sp_help 'Phone';


EXEC sp_helpindex 'Orders';


EXEC sp_columns 'Client';

-- Завдання 7

CREATE PROCEDURE ##GetAvailablePhones
AS
BEGIN
    SELECT PhoneID, Manufacturer, Model, Price
    FROM Phone
    WHERE Availability = N'В наявності';
END;
GO


EXEC ##GetAvailablePhones;


CREATE PROCEDURE ##GetOrdersReport
AS
BEGIN
    SELECT OrderID, ClientID, OrderDate, OrderAmount
    FROM Orders
    WHERE OrderDate > DATEADD(DAY, -30, GETDATE());
END;
GO

EXEC ##GetOrdersReport;


CREATE PROCEDURE ##GetDelivered
AS
BEGIN
    SELECT DeliveryID, DeliveryStatus, DeliveryMethod
    FROM Delivery
    WHERE DeliveryStatus = N'Доставлено';
END;
GO

EXEC ##GetDelivered;
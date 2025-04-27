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

-- Завдання 8

CREATE PROCEDURE #FindPhonesByManufacturer
    @Manufacturer NVARCHAR(50)
AS
BEGIN
    SELECT PhoneID, Manufacturer, Model, Price
    FROM Phone
    WHERE Manufacturer = @Manufacturer;
END;

EXEC #FindPhonesByManufacturer @Manufacturer = 'Apple';


CREATE PROCEDURE #AddIndividualClient
    @FullName NVARCHAR(100),
    @Address NVARCHAR(200),
    @PhoneNumber VARCHAR(20),
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @NewClientID INT;

    SELECT @NewClientID = ISNULL(MAX(ClientID), 0) + 1 FROM Client;

    INSERT INTO Client (ClientID, Type, RegistrationDate)
    VALUES (@NewClientID, N'Фізична особа', GETDATE());

    INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber, Email)
    VALUES (@NewClientID, @FullName, @Address, @PhoneNumber, @Email);

    PRINT 'Додано клієнта ClientID = ' + CAST(@NewClientID AS NVARCHAR);
END;
GO

EXEC #AddIndividualClient 
    @FullName = 'Гриценко Ірина Миколаївна',
    @Address = 'Харків, вул. Карла Маркса, 5',
    @PhoneNumber = '380689785432',
    @Email = 'grytsenko399@example.com';



CREATE PROCEDURE #UpdateOrderStatus
    @OrderID INT,
    @NewStatus NVARCHAR(50)
AS
BEGIN
    UPDATE Orders
    SET OrderStatus = @NewStatus
    WHERE OrderID = @OrderID;

    PRINT 'Статус замовлення оновлено';
END;
GO

EXEC #UpdateOrderStatus 
    @OrderID = 132,
    @NewStatus = 'В дорозі';


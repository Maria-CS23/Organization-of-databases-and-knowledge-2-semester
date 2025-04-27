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


-- Завдання 9

CREATE PROCEDURE CreateNewOrder
    @ClientID INT,
    @OrderDate DATE,
    @OrderAmount DECIMAL(10,2),
    @OrderStatus NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Orders (OrderID, ClientID, OrderDate, OrderAmount, OrderStatus)
        VALUES (
            (SELECT ISNULL(MAX(OrderID),0) + 1 FROM Orders),
            @ClientID,
            @OrderDate,
            @OrderAmount,
            @OrderStatus
        );

        COMMIT TRANSACTION;
        PRINT 'Замовлення створено';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Сталася помилка';
    END CATCH
END;
GO

EXEC CreateNewOrder @ClientID = 355, @OrderDate = '2025-04-28', @OrderAmount = 30000, @OrderStatus = N'В обробці';


CREATE PROCEDURE UpdateOrderAndDeliveryStatus
    @OrderID INT,
    @NewOrderStatus NVARCHAR(50),
    @NewDeliveryStatus NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Orders
        SET OrderStatus = @NewOrderStatus
        WHERE OrderID = @OrderID;

        UPDATE Delivery
        SET DeliveryStatus = @NewDeliveryStatus
        WHERE OrderID = @OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC UpdateOrderAndDeliveryStatus @OrderID = 1217, @NewOrderStatus = N'В дорозі', @NewDeliveryStatus = N'В дорозі';

-- Завдання 10

CREATE PROCEDURE InsertPhones
    @NumberOfRows INT
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @Manufacturer NVARCHAR(50);
    DECLARE @Model NVARCHAR(50);
    DECLARE @PhoneID INT;

    DECLARE @Manufacturers TABLE (Manufacturer NVARCHAR(50));
    INSERT INTO @Manufacturers (Manufacturer)
    VALUES ('Apple'), ('Samsung'), ('Xiaomi'), ('OnePlus'), ('Google'), ('Huawei');

    DECLARE @Models TABLE (Model NVARCHAR(50));
    INSERT INTO @Models (Model)
    VALUES ('iPhone 14'), ('Galaxy S23'), ('Mi 13'), ('OnePlus 11'), ('Pixel 7'), ('P60 Pro');

    WHILE @Counter <= @NumberOfRows
    BEGIN
        SET @PhoneID = (SELECT ISNULL(MAX(PhoneID), 0) + 1 FROM Phone);
        
        SELECT @Manufacturer = Manufacturer FROM @Manufacturers ORDER BY NEWID();
        SELECT @Model = Model FROM @Models ORDER BY NEWID();

        INSERT INTO Phone (PhoneID, Manufacturer, Model, Specifications, Price, Availability)
        VALUES (
            @PhoneID,
            @Manufacturer,
            @Model,
            '128GB, Phantom White',
            ROUND(1500 + (RAND() * 30000), 2),
            N'В наявності'
        );

        SET @Counter += 1;
    END
END;
GO

EXEC InsertPhones @NumberOfRows = 4;

-- Завдання 11
CREATE SEQUENCE Seq_ClientID
    START WITH 21104
    INCREMENT BY 1;
GO

CREATE PROCEDURE InsertClient
    @Type NVARCHAR(20),
    @RegistrationDate DATE
AS
BEGIN
    DECLARE @NewClientID INT;

    BEGIN TRY
        SET @NewClientID = NEXT VALUE FOR Seq_ClientID;

        INSERT INTO Client (ClientID, Type, RegistrationDate)
        VALUES (@NewClientID, @Type, @RegistrationDate);

        SELECT @NewClientID AS NewClientID;
    END TRY
    BEGIN CATCH
        SELECT NULL AS NewClientID;
    END CATCH
END;
GO

EXEC InsertClient @Type = N'Фізична особа', @RegistrationDate = '2025-04-29';
-- Завдання 3

CREATE TRIGGER TR_UpdateInventory_AfterInsert
ON OrderLine
AFTER INSERT
AS
BEGIN
    UPDATE Inventory
    SET StockQuantity = StockQuantity - i.Quantity
    FROM Inventory
    JOIN inserted i ON Inventory.PhoneID = i.PhoneID;
    
    UPDATE Phone
    SET Availability = 
        CASE 
            WHEN inv.StockQuantity > 10 THEN 'В наявності'
            WHEN inv.StockQuantity > 0 THEN 'Закінчується'
            ELSE 'Немає у наявності'
        END
    FROM Phone p
    JOIN Inventory inv ON p.PhoneID = inv.PhoneID
    JOIN inserted i ON p.PhoneID = i.PhoneID;
    
    PRINT 'Інвентар успішно оновлено після додавання замовлення';
END;



CREATE TRIGGER TR_CheckOrderBeforeInsert
ON Orders
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ClientID INT, @OrderAmount DECIMAL(10,2), @OrderStatus NVARCHAR(50);
    
    SELECT @ClientID = ClientID, @OrderAmount = OrderAmount, @OrderStatus = OrderStatus
    FROM inserted;
    
    IF NOT EXISTS (SELECT 1 FROM Client WHERE ClientID = @ClientID)
    BEGIN
        RAISERROR('Клієнт із таким ID не існує!', 16, 1);
        RETURN;
    END
    
    IF @OrderAmount <= 0
    BEGIN
        RAISERROR('Сума замовлення має бути позитивною!', 16, 1);
        RETURN;
    END
    
    INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus)
    SELECT OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus
    FROM inserted;
    
    PRINT 'Замовлення успішно додано після перевірки';
END;


CREATE TRIGGER TR_InsteadOfDeleteInventory
ON Inventory
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted
        WHERE StockQuantity > 0
    )
    BEGIN
        RAISERROR ('Неможливо видалити телефон зі складу, поки кількість більша за 0', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Inventory
        WHERE InventoryID IN (SELECT InventoryID FROM deleted);
    END
END;


CREATE TRIGGER TR_AfterUpdate_PaymentStatus
ON Payment
AFTER UPDATE
AS
BEGIN
    UPDATE Payment
    SET PaymentDate = CAST(GETDATE() AS DATE)
    FROM Payment p
    JOIN inserted i ON p.PaymentID = i.PaymentID
    JOIN deleted d ON d.PaymentID = i.PaymentID
    WHERE i.PaymentStatus = N'Оплачено' AND d.PaymentStatus <> N'Оплачено';
END;



-- Завдання 4

CREATE TABLE DatabaseChangesLog (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EventDate DATETIME NOT NULL DEFAULT GETDATE(),
	LoginName NVARCHAR(100) NOT NULL,
	EventType NVARCHAR(100) NOT NULL,
	ObjectName NVARCHAR(100) NOT NULL,
	SQLCommand NVARCHAR(MAX) NOT NULL
);


CREATE TRIGGER TR_LogDatabaseChanges
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA();
    
    INSERT INTO DatabaseChangesLog (LoginName, EventType, ObjectName, SQLCommand)
    VALUES (
        SYSTEM_USER,
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
    );
    
    PRINT 'Зміна структури бази даних зафіксована у журналі';
END;



-- Завдання 5

CREATE TABLE UserLoginLog (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	LoginDate DATETIME NOT NULL DEFAULT GETDATE(),
	LoginName NVARCHAR(100) NOT NULL,
	HostName NVARCHAR(100) NOT NULL,
	AppName NVARCHAR(100) NOT NULL
);

SELECT * FROM DatabaseChangesLog;

USE master;
GO

CREATE TRIGGER TR_LogUserLogin
ON ALL SERVER
FOR LOGON
AS
BEGIN
    IF ORIGINAL_LOGIN() IN ('sa', 'NT AUTHORITY\SYSTEM') RETURN;

    BEGIN TRY
        EXECUTE AS LOGIN = ORIGINAL_LOGIN();

        INSERT INTO Phone.dbo.UserLoginLog (LoginName, HostName, AppName)
        VALUES (
            ORIGINAL_LOGIN(),
            HOST_NAME(),
            APP_NAME()
        );

        REVERT;
    END TRY
    BEGIN CATCH

    END CATCH
END;

SELECT * FROM UserLoginLog;



-- Завдання 6

CREATE TRIGGER TR_UpdateOrderAmount
ON OrderLine
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @affectedOrders TABLE (OrderID INT);
    
    INSERT INTO @affectedOrders(OrderID)
    SELECT DISTINCT OrderID FROM inserted
    UNION
    SELECT DISTINCT OrderID FROM deleted;
    
    UPDATE O
    SET OrderAmount = (
        SELECT SUM(OL.Quantity * P.Price)
        FROM OrderLine OL
        JOIN Phone P ON OL.PhoneID = P.PhoneID
        WHERE OL.OrderID = O.OrderID
    )
    FROM Orders O
    JOIN @affectedOrders A ON O.OrderID = A.OrderID;
END;





CREATE TRIGGER TR_CheckDeliveryAddress
ON Delivery
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted WHERE LEN(DeliveryAddress) < 10
    )
    BEGIN
        RAISERROR('Адреса доставки повинна містити не менше 10 символів', 16, 1);
        ROLLBACK;
        RETURN;
    END

    INSERT INTO Delivery (
        DeliveryID, OrderID, DeliveryAddress,
        DeliveryMethod, DeliveryStatus,
        DispatchDate, DeliveryDate
    )
    SELECT
        DeliveryID, OrderID, DeliveryAddress,
        DeliveryMethod, DeliveryStatus,
        DispatchDate, DeliveryDate
    FROM inserted;
END;





CREATE TRIGGER TR_RestoreInventory_OnCancel
ON Orders
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.OrderID = d.OrderID
        WHERE i.OrderStatus = N'Скасовано' AND d.OrderStatus <> N'Скасовано'
    )
    BEGIN
        UPDATE inv
        SET StockQuantity = inv.StockQuantity + ol.Quantity
        FROM Inventory inv
        JOIN OrderLine ol ON inv.PhoneID = ol.PhoneID
        JOIN inserted i ON ol.OrderID = i.OrderID
        WHERE i.OrderStatus = N'Скасовано';
    END
END;





CREATE TRIGGER TR_ValidateContactInfo_Individual
ON Individual
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE 
            (PhoneNumber NOT LIKE '+380%' AND PhoneNumber NOT LIKE '0%') OR
            (Email IS NOT NULL AND Email NOT LIKE '%_@__%.__%')
    )
    BEGIN
        RAISERROR(N'Невірний формат номеру телефону або email (Individual)', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER TR_ValidateContactInfo_LegalEntity
ON LegalEntity
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE 
            (PhoneNumber NOT LIKE '+380%' AND PhoneNumber NOT LIKE '0%') OR
            (Email IS NOT NULL AND Email NOT LIKE '%_@__%.__%')
    )
    BEGIN
        RAISERROR(N'Невірний формат номеру телефону або email (LegalEntity)', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (4, 'Фізична особа', GETDATE());
INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber, Email)
VALUES (4, N'Сергієнко Дмитро Сергійович', N'Львів', '123456', 'wrongmail');

INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (5, 'Фізична особа', GETDATE());
INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber, Email)
VALUES (5, N'Руденко Марина Олегівна', N'Львів, вул. Франка, 5', '+380501112233', 'marina.rudenko314@example.com');

SELECT * FROM Individual;
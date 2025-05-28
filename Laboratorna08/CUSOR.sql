-- Завдання 3
BEGIN TRAN;
UPDATE Phone SET Price = Price * 0.9 WHERE Manufacturer = 'Samsung';

UPDATE Inventory SET StockQuantity = StockQuantity - 254 WHERE PhoneID = 144;

IF (SELECT COUNT(*) FROM Phone WHERE Price > 500000) = 0
    ROLLBACK;
ELSE
    COMMIT;

SELECT * FROM Inventory;
SELECT * FROM Phone WHERE Manufacturer = 'Samsung';


-- Завдання 4
BEGIN TRAN;

UPDATE Orders SET OrderStatus = 'В дорозі' WHERE OrderID = 1000;

IF @@ERROR <> 0
    ROLLBACK;
ELSE
    COMMIT;


-- Завдання 5
BEGIN TRAN;
BEGIN TRY
    UPDATE Phone SET Manufacturer = NULL WHERE PhoneID = 1;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Помилка під час оновлення: ' + ERROR_MESSAGE();
END CATCH;


-- Завдання 6
DECLARE @i INT = 1;
DECLARE @ID INT = 51;
DECLARE @ClientID INT;
DECLARE @phoneID INT, @phonePrice DECIMAL(10,2);
DECLARE @quantity INT;
DECLARE @orderAmount DECIMAL(10,2);

BEGIN TRAN;

WHILE @i <= 10000
BEGIN
	SET @ClientID = 1 + ABS(CHECKSUM(NEWID())) % 451;
	SELECT TOP 1 @phoneID = PhoneID, @phonePrice = Price FROM Phone WHERE Availability = N'В наявності' ORDER BY NEWID();
	SET @quantity = 1 + ABS(CHECKSUM(NEWID())) % 10;
	SET @orderAmount = @phonePrice * @quantity;

    INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus)
    VALUES (@ID, @ClientID, GETDATE(), NULL, @orderAmount, 'Замовлення оформлено');

    INSERT INTO OrderLine (OrderID, PhoneID, Quantity)
    VALUES (@ID, @PhoneID, @quantity);

    INSERT INTO Payment (PaymentID, OrderID, PaymentDate, PaymentMethod, PaymentStatus)
    VALUES (@ID, @ID, GETDATE(), 'Карта', 'Оплачено');

    INSERT INTO Delivery (DeliveryID, OrderID, DeliveryAddress, DeliveryMethod, DeliveryStatus, DispatchDate, DeliveryDate)
    VALUES (@ID, @ID, 'Адреса', 'Нова Пошта', 'В обробці', NULL, NULL);

    SET @i = @i + 1;
    SET @ID = @ID + 1;
END

COMMIT;

SELECT * FROM Orders;
SELECT * FROM OrderLine;
SELECT * FROM Payment;
SELECT * FROM Delivery;


-- Завдання 7
CREATE OR ALTER PROCEDURE UpdateInventoryStock
    @PhoneID INT,
    @AdditionalStock INT
AS
BEGIN
    PRINT 'Початок виконання: ' + CAST(GETDATE() AS NVARCHAR);

    BEGIN TRAN;
    UPDATE Inventory
    SET StockQuantity = StockQuantity + @AdditionalStock, LastRestockDate = GETDATE()
    WHERE PhoneID = @PhoneID;
    COMMIT;

    PRINT 'Кінець виконання: ' + CAST(GETDATE() AS NVARCHAR);
END;


SELECT * FROM Inventory WHERE PhoneID = 138;

EXEC UpdateInventoryStock @PhoneID = 138, @AdditionalStock = 459;

SELECT * FROM Inventory WHERE PhoneID = 138;



-- Завдання 8
DECLARE @StartTime DATETIME = GETDATE();

SELECT 
    c.ClientID,
    CASE 
        WHEN c.Type = N'Фізична особа' THEN i.FullName
        WHEN c.Type = N'Юридична особа' THEN le.CompanyName
    END AS ClientName,
    o.OrderID, o.OrderDate, o.OrderAmount, o.OrderStatus, 
    p.Manufacturer, p.Model,
    ol.Quantity, 
    pm.PaymentMethod, pm.PaymentStatus, 
    d.DeliveryMethod, d.DeliveryStatus
FROM 
    Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Payment pm ON o.OrderID = pm.OrderID
LEFT JOIN Delivery d ON o.OrderID = d.OrderID
WHERE 
    o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
    AND p.Price > 15000
ORDER BY 
    o.OrderDate DESC, p.Price DESC;

DECLARE @EndTime DATETIME = GETDATE();
PRINT 'Час виконання (без індексу): ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS NVARCHAR) + ' мс';


-- Завдання 9
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate_ClientID ON Orders(OrderDate, ClientID);
CREATE NONCLUSTERED INDEX IX_Phone_Price_PhoneID ON Phone(Price, PhoneID);
CREATE NONCLUSTERED INDEX IX_OrderLine_OrderID_PhoneID ON OrderLine(OrderID, PhoneID);


DECLARE @StartTime2 DATETIME = GETDATE();

SELECT 
    c.ClientID,
    CASE 
        WHEN c.Type = N'Фізична особа' THEN i.FullName
        WHEN c.Type = N'Юридична особа' THEN le.CompanyName
    END AS ClientName,
    o.OrderID, o.OrderDate, o.OrderAmount, o.OrderStatus, 
    p.Manufacturer, p.Model,
    ol.Quantity, 
    pm.PaymentMethod, pm.PaymentStatus, 
    d.DeliveryMethod, d.DeliveryStatus
FROM 
    Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Payment pm ON o.OrderID = pm.OrderID
LEFT JOIN Delivery d ON o.OrderID = d.OrderID
WHERE 
    o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
    AND p.Price > 15000
ORDER BY 
    o.OrderDate DESC, p.Price DESC;


DECLARE @EndTime2 DATETIME = GETDATE();
PRINT 'Час виконання (з індексом): ' + CAST(DATEDIFF(MILLISECOND, @StartTime2, @EndTime2) AS NVARCHAR) + ' мс';


-- Завдання 10
CREATE TABLE #TempResults (
    ClientID INT,
    ClientName NVARCHAR(100),
    OrderID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2),
    OrderStatus NVARCHAR(50),
    Manufacturer NVARCHAR(50),
    Model NVARCHAR(50),
    Quantity INT,
    PaymentMethod NVARCHAR(50),
    PaymentStatus NVARCHAR(50),
    DeliveryMethod NVARCHAR(50),
    DeliveryStatus NVARCHAR(50)
);



DECLARE @ClientID INT, @ClientName NVARCHAR(100), @OrderID INT, @OrderDate DATE,
        @OrderAmount DECIMAL(10,2), @OrderStatus NVARCHAR(50), @Manufacturer NVARCHAR(50),
        @Model NVARCHAR(50), @Quantity INT, @PaymentMethod NVARCHAR(50),
        @PaymentStatus NVARCHAR(50), @DeliveryMethod NVARCHAR(50), @DeliveryStatus NVARCHAR(50);


DECLARE complex_cursor CURSOR FOR
SELECT 
    c.ClientID,
    CASE 
        WHEN c.Type = N'Фізична особа' THEN i.FullName
        WHEN c.Type = N'Юридична особа' THEN le.CompanyName
    END,
    o.OrderID, o.OrderDate, o.OrderAmount, o.OrderStatus, 
    p.Manufacturer, p.Model,
    ol.Quantity, 
    pm.PaymentMethod, pm.PaymentStatus, 
    d.DeliveryMethod, d.DeliveryStatus
FROM 
    Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Payment pm ON o.OrderID = pm.OrderID
LEFT JOIN Delivery d ON o.OrderID = d.OrderID
WHERE 
    o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
    AND p.Price > 15000
ORDER BY 
    o.OrderDate DESC, p.Price DESC;


DECLARE @StartTime3 DATETIME = GETDATE();

OPEN complex_cursor;
FETCH NEXT FROM complex_cursor INTO @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, @OrderStatus,
                                   @Manufacturer, @Model, @Quantity, @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus;

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #TempResults VALUES (
        @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, 
        @OrderStatus, @Manufacturer, @Model, @Quantity, 
        @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus
    );

    FETCH NEXT FROM complex_cursor INTO @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, @OrderStatus,
                                       @Manufacturer, @Model, @Quantity, @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus;
END

CLOSE complex_cursor;
DEALLOCATE complex_cursor;

SELECT * FROM #TempResults;

DECLARE @EndTime3 DATETIME = GETDATE();
PRINT 'Час виконання (Cursor1): ' + CAST(DATEDIFF(MILLISECOND, @StartTime3, @EndTime3) AS NVARCHAR) + ' мс';


TRUNCATE TABLE #TempResults;



-- Завдання 11

DECLARE @ClientID INT, @ClientName NVARCHAR(100), @OrderID INT, @OrderDate DATE,
        @OrderAmount DECIMAL(10,2), @OrderStatus NVARCHAR(50), @Manufacturer NVARCHAR(50),
        @Model NVARCHAR(50), @Quantity INT, @PaymentMethod NVARCHAR(50),
        @PaymentStatus NVARCHAR(50), @DeliveryMethod NVARCHAR(50), @DeliveryStatus NVARCHAR(50);

DECLARE complex_cursor CURSOR FOR
SELECT 
    c.ClientID,
    CASE 
        WHEN c.Type = N'Фізична особа' THEN i.FullName
        WHEN c.Type = N'Юридична особа' THEN le.CompanyName
    END,
    o.OrderID, o.OrderDate, o.OrderAmount, o.OrderStatus, 
    p.Manufacturer, p.Model,
    ol.Quantity, 
    pm.PaymentMethod, pm.PaymentStatus, 
    d.DeliveryMethod, d.DeliveryStatus
FROM 
    Client c
LEFT JOIN Individual i ON c.ClientID = i.ClientID
LEFT JOIN LegalEntity le ON c.ClientID = le.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Payment pm ON o.OrderID = pm.OrderID
LEFT JOIN Delivery d ON o.OrderID = d.OrderID
WHERE 
    o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
    AND p.Price > 15000
ORDER BY 
    o.OrderDate DESC, p.Price DESC;

DECLARE @StartTime4 DATETIME = GETDATE();

OPEN complex_cursor;
FETCH NEXT FROM complex_cursor INTO @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, @OrderStatus,
                                   @Manufacturer, @Model, @Quantity, @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus;
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #TempResults VALUES (
        @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, 
        @OrderStatus, @Manufacturer, @Model, @Quantity, 
        @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus
    );

    FETCH NEXT FROM complex_cursor INTO @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, @OrderStatus,
                                       @Manufacturer, @Model, @Quantity, @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus;
END
CLOSE complex_cursor;

SELECT * FROM #TempResults;

DECLARE @EndTime4 DATETIME = GETDATE();
PRINT 'Час виконання (Cursor2 запуск 1): ' + CAST(DATEDIFF(MILLISECOND, @StartTime4, @EndTime4) AS NVARCHAR) + ' мс';

TRUNCATE TABLE #TempResults;

DECLARE @StartTime5 DATETIME = GETDATE();

OPEN complex_cursor;
FETCH NEXT FROM complex_cursor INTO @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, @OrderStatus,
                                   @Manufacturer, @Model, @Quantity, @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus;
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #TempResults VALUES (
        @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, 
        @OrderStatus, @Manufacturer, @Model, @Quantity, 
        @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus
    );

    FETCH NEXT FROM complex_cursor INTO @ClientID, @ClientName, @OrderID, @OrderDate, @OrderAmount, @OrderStatus,
                                       @Manufacturer, @Model, @Quantity, @PaymentMethod, @PaymentStatus, @DeliveryMethod, @DeliveryStatus;
END
CLOSE complex_cursor;
DEALLOCATE complex_cursor;

SELECT * FROM #TempResults;

DECLARE @EndTime5 DATETIME = GETDATE();
PRINT 'Час виконання (Cursor2 запуск 2): ' + CAST(DATEDIFF(MILLISECOND, @StartTime5, @EndTime5) AS NVARCHAR) + ' мс';

DROP TABLE #TempResults;
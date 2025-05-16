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
SET STATISTICS TIME ON;

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
    AND p.Price > 500
ORDER BY 
    o.OrderDate DESC, p.Price DESC;


SET STATISTICS TIME OFF;
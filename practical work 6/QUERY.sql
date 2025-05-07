-- Завдання 3
BEGIN TRAN;

INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus)
VALUES (51, 15, GETDATE(), NULL, 15000.00, 'В обробці');

INSERT INTO OrderLine (OrderID, PhoneID, Quantity)
VALUES (51, 19, 1);

INSERT INTO Payment (PaymentID, OrderID, PaymentDate, PaymentMethod, PaymentStatus)
VALUES (51, 51, GETDATE(), 'Карта', 'Оплачено');

COMMIT;


-- Завдання 4
BEGIN TRAN;

UPDATE Phone SET Price = Price - 500 WHERE PhoneID = 200;

IF (SELECT COUNT(*) FROM Phone WHERE PhoneID = 200) = 0
    ROLLBACK;
ELSE
    COMMIT;


-- Завдання 5
BEGIN TRAN;

UPDATE LegalEntity SET CompanyName = 'Нові Технології', PhoneNumber = '+380993456789' WHERE ClientID = 1208;

IF @@ERROR <> 0
    ROLLBACK;
ELSE
    COMMIT;


-- Завдання 6
BEGIN TRAN;

UPDATE Orders SET OrderStatus = 'В обробці' WHERE OrderID = 23;

SAVE TRANSACTION point1;

UPDATE Phone SET Price = Price - 1000 WHERE PhoneID = 89;

ROLLBACK TRANSACTION point1;

COMMIT;



-- Завдання 7
BEGIN TRAN;

BEGIN TRY
    UPDATE LegalEntity SET TaxID = '1234567104' WHERE ClientID = 2;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Помилка під час оновлення юридичної особи: ' + ERROR_MESSAGE();
END CATCH;


-- Завдання 8
BEGIN TRAN;

DECLARE @OldPrice DECIMAL(10,2);
SELECT @OldPrice = Price FROM Phone WHERE PhoneID = 43;

UPDATE Phone SET Price = Price + 780 WHERE PhoneID = 43;


INSERT INTO ChangeLog (LogID, TableName, RowID, FieldName, OldValue, NewValue)
VALUES (1, 'Phone', 43, 'Price', CAST(@OldPrice AS NVARCHAR(255)), CAST((@OldPrice + 780) AS NVARCHAR(255)));

COMMIT;


SELECT * FROM ChangeLog;



-- Завдання 9
BEGIN TRAN;

BEGIN TRY
    INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus)
    VALUES (52, 78, GETDATE(), NULL, 12000, 'В обробці');

    INSERT INTO OrderLine (OrderID, PhoneID, Quantity)
    VALUES (52, 31, 2);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Помилка: ' + ERROR_MESSAGE();
END CATCH;


SELECT * FROM Orders WHERE OrderID = 52;
SELECT * FROM OrderLine WHERE OrderID = 52;


-- Завдання 10
BEGIN TRAN;

BEGIN TRY
    INSERT INTO Client (ClientID, Type, RegistrationDate)
    VALUES (118, 'Фізична особа', GETDATE());

    INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber, Email)
    VALUES (118, N'Іван Петренко', N'м. Київ, вул. Шевченка, 10', '380501234567', 'ivan.petrenko@gmail.com');

    INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus)
    VALUES (54, 118, GETDATE(), NULL, 15900, 'В дорозі');

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Помилка: ' + ERROR_MESSAGE();
END CATCH;


-- Завдання 11
BEGIN TRAN;

BEGIN TRY
    INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount, OrderStatus)
    VALUES (57, 67, GETDATE(), NULL, 23000.99, 'Очікує оплату');

    INSERT INTO OrderLine (OrderID, PhoneID, Quantity)
    VALUES (57, 31, 2);

    UPDATE Inventory SET StockQuantity = StockQuantity - 2 WHERE PhoneID = 31 AND WarehouseLocation = 'Склад 3';

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Помилка: ' + ERROR_MESSAGE();
END CATCH;

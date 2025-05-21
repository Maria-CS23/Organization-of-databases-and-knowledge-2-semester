-- Завдання 3
BEGIN TRANSACTION;
    
    DECLARE @ClientID INT = 156;
    DECLARE @OrderID INT = 1;
    DECLARE @PhoneID INT = 7;
    DECLARE @Quantity INT = 2;
    
    INSERT INTO Orders (OrderID, ClientID, OrderDate, OrderAmount, OrderStatus)
    VALUES (@OrderID, @ClientID, GETDATE(), 0, 'Замовлення оформлено');
    
    INSERT INTO OrderLine (OrderID, PhoneID, Quantity)
    VALUES (@OrderID, @PhoneID, @Quantity);
    
    UPDATE Inventory
    SET StockQuantity = StockQuantity - @Quantity
    WHERE PhoneID = @PhoneID;
    
    UPDATE Orders
    SET OrderAmount = (
        SELECT SUM(OL.Quantity * P.Price) 
        FROM OrderLine OL
        JOIN Phone P ON OL.PhoneID = P.PhoneID
        WHERE OL.OrderID = @OrderID
    )
    WHERE OrderID = @OrderID;
    
    IF EXISTS (SELECT 1 FROM Inventory WHERE PhoneID = @PhoneID AND StockQuantity < 0)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Недостатньо товару на складі. Транзакцію скасовано';
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'Замовлення успішно створено';
    END



SELECT * FROM Orders;
SELECT * FROM OrderLine;
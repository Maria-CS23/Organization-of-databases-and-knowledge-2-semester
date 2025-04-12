-- Завдання 3

CREATE FUNCTION dbo.GetDiscountedPrice(@Price DECIMAL(10,2), @DiscountPercent INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Price - (@Price * @DiscountPercent / 100.0)
END


CREATE FUNCTION dbo.GetClientInfo(@ClientID INT)
RETURNS NVARCHAR(300)
AS
BEGIN
    DECLARE @Info NVARCHAR(300)

    IF EXISTS (SELECT 1 FROM Individual WHERE ClientID = @ClientID)
        SELECT @Info = 'Фіз. особа: ' + FullName + ', ' + PhoneNumber 
        FROM Individual WHERE ClientID = @ClientID
    ELSE
        SELECT @Info = 'Юр. особа: ' + CompanyName + ', ' + PhoneNumber 
        FROM LegalEntity WHERE ClientID = @ClientID

    RETURN @Info
END

CREATE FUNCTION dbo.GetOrderStatus(@CompletionDate DATE)
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN CASE 
        WHEN @CompletionDate IS NULL THEN 'Очікує'
        ELSE 'Виконано'
    END
END

-- Завдання 4

CREATE FUNCTION dbo.GetOrderTotalAmount()
RETURNS TABLE
AS
RETURN (
    SELECT 
        ol.OrderID,
        SUM(p.Price * ol.Quantity) AS TotalAmount
    FROM OrderLine ol
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    GROUP BY ol.OrderID
);


CREATE FUNCTION dbo.GetPhonesMoreExpensiveThan(@MinPrice DECIMAL(10,2))
RETURNS TABLE
AS
RETURN (
    SELECT 
        PhoneID,
        Manufacturer,
        Model,
        Price
    FROM Phone
    WHERE Price > @MinPrice
);


CREATE FUNCTION dbo.GetOrdersByClient(@ClientID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.CompletionDate,
        o.OrderAmount
    FROM Orders o
    WHERE o.ClientID = @ClientID
);

-- Завдання 5

CREATE FUNCTION dbo.GetAvailablePhonesBelowPrice(@MaxPrice DECIMAL(10,2))
RETURNS @Result TABLE (
    PhoneID INT,
    Manufacturer NVARCHAR(50),
    Model NVARCHAR(50),
    Price DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @Result
    SELECT PhoneID, Manufacturer, Model, Price
    FROM Phone
    WHERE Price < @MaxPrice AND Availability = 'В наявності'

    RETURN
END


CREATE FUNCTION dbo.GetAvailablePhonesWithCategory()
RETURNS @Result TABLE (
    PhoneID INT, Manufacturer NVARCHAR(50),
    Model NVARCHAR(50), Price DECIMAL(10,2),
    Category NVARCHAR(20)
)
AS
BEGIN
    INSERT INTO @Result
    SELECT 
        PhoneID, Manufacturer, Model, Price,
        CASE 
            WHEN Price >= 15000 THEN 'Дорогий'
            ELSE 'Бюджетний'
        END AS Category
    FROM Phone
    WHERE Availability = 'В наявності'

    RETURN
END


CREATE FUNCTION dbo.GetFrequentClients()
RETURNS @Result TABLE (
    ClientID INT,
    TotalOrders INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT 
        ClientID,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY ClientID
    HAVING COUNT(*) > 1

    RETURN
END


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

-- Завдання 6

CREATE FUNCTION dbo.GetTop3Clients()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 3 
        c.ClientID,
        CASE 
            WHEN i.FullName IS NOT NULL THEN i.FullName
            WHEN l.CompanyName IS NOT NULL THEN l.CompanyName
            ELSE 'Unknown'
        END AS ClientName,
        c.Type,
        SUM(o.OrderAmount) AS TotalAmount
    FROM Client c
    JOIN Orders o ON c.ClientID = o.ClientID
    LEFT JOIN Individual i ON c.ClientID = i.ClientID
    LEFT JOIN LegalEntity l ON c.ClientID = l.ClientID
    GROUP BY c.ClientID, i.FullName, l.CompanyName, c.Type
    ORDER BY TotalAmount DESC
);


CREATE FUNCTION dbo.GetPhoneSalesByManufacturer()
RETURNS TABLE
AS
RETURN (
    SELECT 
        p.Manufacturer,
        SUM(ol.Quantity) AS TotalSold
    FROM Phone p
    JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
    GROUP BY p.Manufacturer 
);


CREATE FUNCTION dbo.GetPhonesWithoutOrders()
RETURNS TABLE
AS
RETURN (
    SELECT p.PhoneID, p.Manufacturer, p.Model
    FROM Phone p
    LEFT JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
    WHERE ol.PhoneID IS NULL
);


CREATE FUNCTION dbo.GetDaysSinceLastOrder(@ClientID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Days INT;
    SELECT @Days = DATEDIFF(DAY, MAX(OrderDate), GETDATE())
    FROM Orders
    WHERE ClientID = @ClientID;

    RETURN @Days;
END;


CREATE FUNCTION dbo.GetPhoneByMonth()
RETURNS @Result TABLE (
    YearMonth NVARCHAR(7),
    PhoneID INT,
    Manufacturer NVARCHAR(50),
    Model NVARCHAR(50),
    TotalSold INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT 
        FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
        p.PhoneID,
        p.Manufacturer,
        p.Model,
        SUM(ol.Quantity) AS TotalSold
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM'), p.PhoneID, p.Manufacturer, p.Model

    RETURN;
END;
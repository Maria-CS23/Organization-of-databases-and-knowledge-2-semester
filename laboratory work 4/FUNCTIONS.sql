-- �������� 3

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
        SELECT @Info = 'Գ�. �����: ' + FullName + ', ' + PhoneNumber 
        FROM Individual WHERE ClientID = @ClientID
    ELSE
        SELECT @Info = '��. �����: ' + CompanyName + ', ' + PhoneNumber 
        FROM LegalEntity WHERE ClientID = @ClientID

    RETURN @Info
END

CREATE FUNCTION dbo.GetOrderStatus(@CompletionDate DATE)
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN CASE 
        WHEN @CompletionDate IS NULL THEN '�����'
        ELSE '��������'
    END
END

-- �������� 4

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

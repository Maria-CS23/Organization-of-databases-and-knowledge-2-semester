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


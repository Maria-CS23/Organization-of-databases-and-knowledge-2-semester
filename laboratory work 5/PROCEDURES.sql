-- �������� 6
EXEC sp_help 'Phone';


EXEC sp_helpindex 'Orders';


EXEC sp_columns 'Client';

-- �������� 7

CREATE PROCEDURE ##GetAvailablePhones
AS
BEGIN
    SELECT PhoneID, Manufacturer, Model, Price
    FROM Phone
    WHERE Availability = N'� ��������';
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
    WHERE DeliveryStatus = N'����������';
END;
GO

EXEC ##GetDelivered;

-- �������� 8

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
    VALUES (@NewClientID, N'Գ����� �����', GETDATE());

    INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber, Email)
    VALUES (@NewClientID, @FullName, @Address, @PhoneNumber, @Email);

    PRINT '������ �볺��� ClientID = ' + CAST(@NewClientID AS NVARCHAR);
END;
GO

EXEC #AddIndividualClient 
    @FullName = '�������� ����� ���������',
    @Address = '�����, ���. ����� ������, 5',
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

    PRINT '������ ���������� ��������';
END;
GO

EXEC #UpdateOrderStatus 
    @OrderID = 132,
    @NewStatus = '� �����';


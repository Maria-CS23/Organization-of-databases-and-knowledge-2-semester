-- Завдання 3
SET STATISTICS TIME ON;
GO

SELECT DeliveryID, DeliveryStatus, DeliveryMethod FROM Delivery WHERE DeliveryStatus = N'Доставлено' AND DeliveryMethod = N'Нова Пошта';

SELECT Email FROM Individual WHERE Email = N'oleksii.melnyk264@example.com';

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 101;

SELECT PhoneID, Manufacturer, Model FROM Phone WHERE Availability = N'В наявності';



CREATE NONCLUSTERED INDEX IX_Delivery_StatusMethod ON Delivery(DeliveryStatus, DeliveryMethod);

CREATE UNIQUE INDEX IX_Individual_Email_Unique ON Individual(Email);

CREATE NONCLUSTERED INDEX IX_Orders_ClientID_Include
ON Orders(ClientID)
INCLUDE(OrderID, OrderAmount, OrderDate);

CREATE NONCLUSTERED INDEX IX_Phone_Filtered_Availability
ON Phone(Availability)
WHERE Availability = 'В наявності';


SELECT DeliveryID, DeliveryStatus, DeliveryMethod FROM Delivery WHERE DeliveryStatus = N'Доставлено' AND DeliveryMethod = N'Нова Пошта';

SELECT Email FROM Individual WHERE Email = N'oleksii.melnyk264@example.com';

SELECT OrderID, OrderAmount, OrderDate FROM Orders WHERE ClientID = 101;

SELECT PhoneID, Manufacturer, Model FROM Phone WHERE Availability = N'В наявності';

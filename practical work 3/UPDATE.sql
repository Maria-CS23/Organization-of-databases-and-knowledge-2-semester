UPDATE Phone
SET Price = 34000
WHERE PhoneID = 1;

UPDATE Phone
SET Availability = 'Немає в наявності'
WHERE PhoneID = 2;

UPDATE Orders
SET CompletionDate = '2024-03-10'
WHERE OrderID = 1;

UPDATE Individual
SET Address = 'Київ, вул. Лесі Українки, 15'
WHERE ClientID = 1;

DELETE FROM OrderLine
WHERE LineID = 1;

DELETE FROM Orders
WHERE OrderID = 1;

DELETE FROM LegalEntity
WHERE ClientID = 2;

DELETE FROM Client
WHERE ClientID = 2;

DELETE FROM OrderLine;
DELETE FROM Orders;
DELETE FROM Individual;
DELETE FROM LegalEntity;
DELETE FROM Client;
DELETE FROM Phone;
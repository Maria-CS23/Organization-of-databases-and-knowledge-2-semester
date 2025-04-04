SELECT * FROM Orders WHERE OrderAmount > 15000;
SELECT * FROM Phone WHERE Price < 28000;

SELECT * FROM Phone WHERE Price > 52000 AND Availability = 'В наявності';

SELECT * FROM Phone WHERE Specifications LIKE '%512GB%';

SELECT Phone.Model, Orders.OrderID, Orders.OrderDate, Individual.FullName
FROM Phone
INNER JOIN OrderLine ON Phone.PhoneID = OrderLine.PhoneID
INNER JOIN Orders ON OrderLine.OrderID = Orders.OrderID
INNER JOIN Individual ON Orders.ClientID = Individual.ClientID;

SELECT Client.ClientID, Client.Type, Orders.OrderID, Orders.OrderAmount
FROM Client
LEFT JOIN Orders ON Client.ClientID = Orders.ClientID;

SELECT Phone.PhoneID, Phone.Model, Phone.Manufacturer
FROM Phone
WHERE Phone.PhoneID NOT IN (
    SELECT OrderLine.PhoneID
    FROM OrderLine
);

SELECT Client.ClientID, Client.Type, SUM(Orders.OrderAmount) AS TotalOrderAmount
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID
GROUP BY Client.ClientID, Client.Type
HAVING SUM(Orders.OrderAmount) > 45000;

SELECT Client.ClientID, Client.Type, COUNT(DISTINCT Phone.Model) AS NumberOfModelsOrdered, SUM(Orders.OrderAmount) AS TotalAmount
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID
GROUP BY Client.ClientID, Client.Type
HAVING COUNT(DISTINCT Phone.Model) > 1
AND SUM(Orders.OrderAmount) > (SELECT AVG(OrderAmount) FROM Orders);

SELECT Client.ClientID, Client.Type, Orders.OrderID, Orders.OrderAmount, Phone.Model
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID
WHERE Phone.Model = 'iPhone 14' AND Orders.OrderAmount > 26000;

SELECT * FROM Client;

SELECT * FROM Individual;

SELECT * FROM LegalEntity;

SELECT * FROM Phone;

SELECT * FROM Orders;

SELECT * FROM OrderLine;
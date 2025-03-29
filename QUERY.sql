-- Формування запитів із застосуванням умов відбору (WHERE)
SELECT ClientID, Type, RegistrationDate FROM Client
WHERE RegistrationDate > '2024-05-01';

SELECT OrderID, ClientID, OrderDate, OrderAmount FROM Orders
WHERE OrderAmount > 55000;

SELECT PhoneID, Manufacturer, Model, Price FROM Phone
WHERE Manufacturer = 'Xiaomi';

SELECT PhoneID, Manufacturer, Model, Price FROM Phone
WHERE Price < 9000;

SELECT PhoneID, Manufacturer, Model, Availability FROM Phone
WHERE Availability = 'Немає в наявності';

-- Застосування логічних операторів у конструкціях WHERE
SELECT PhoneID, Manufacturer, Model, Price, Availability
FROM Phone
WHERE Availability = 'В наявності' AND Price < 24000;

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE NOT (Manufacturer = 'Samsung' OR Manufacturer = 'Apple')
AND Price > 20000;

SELECT OrderID, ClientID, OrderAmount
FROM Orders
WHERE OrderAmount > 15000 AND OrderAmount < 25000
AND ClientID IN (SELECT ClientID FROM Client WHERE RegistrationDate < '2024-10-13');

SELECT ClientID
FROM Orders
WHERE OrderAmount > 67000
AND ClientID NOT IN (SELECT ClientID FROM Orders WHERE OrderAmount < 16000);

SELECT ClientID, FullName, Address
FROM Individual
WHERE ClientID NOT IN (SELECT ClientID FROM Orders);

-- Використання оператора LIKE для пошуку шаблонів у даних
SELECT ClientID, FullName
FROM Individual
WHERE FullName LIKE '%Марина%';

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Model LIKE 'Redmi%';

SELECT ClientID, FullName, Address
FROM Individual
WHERE Address LIKE '%Черкаси%';

SELECT PhoneID, Manufacturer, Model, Price
FROM Phone
WHERE Model LIKE '%Pro%';

SELECT ClientID, Type, RegistrationDate
FROM Client
WHERE RegistrationDate = '2024-11-22';

-- Застосування оператора JOIN для виконання багатотабличних запитів
SELECT LegalEntity.CompanyName, LegalEntity.Address, Client.Type
FROM Client
JOIN LegalEntity ON Client.ClientID = LegalEntity.ClientID;

SELECT Individual.FullName, Phone.Model, OrderLine.Quantity
FROM Individual
JOIN Orders ON Individual.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID;

SELECT Client.ClientID, Client.Type, Orders.OrderID, Orders.OrderDate, Orders.OrderAmount
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID;

SELECT OrderLine.OrderID, Phone.Manufacturer, Phone.Model, Phone.Price
FROM OrderLine
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID;

SELECT LegalEntity.CompanyName, Phone.Model, OrderLine.Quantity
FROM LegalEntity
JOIN Client ON LegalEntity.ClientID = Client.ClientID
JOIN Orders ON Client.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID;

-- Розширене використання оператора JOIN у складних запитах
SELECT c.ClientID, c.Type, c.RegistrationDate, o.OrderID, o.OrderDate
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID;

SELECT o.OrderID, o.OrderDate, c.ClientID, c.Type
FROM Orders o
RIGHT JOIN Client c ON o.ClientID = c.ClientID;

SELECT c.ClientID, c.Type, p.PhoneID, p.Manufacturer, p.Model
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN OrderLine ol ON o.OrderID = ol.OrderID
LEFT JOIN Phone p ON ol.PhoneID = p.PhoneID;

SELECT le.CompanyName, o.OrderID, o.OrderDate
FROM LegalEntity le
FULL JOIN Orders o ON le.ClientID = o.ClientID;

SELECT c.ClientID, c.Type, o.OrderID, o.OrderDate, p.PhoneID, p.Model, p.Availability
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
RIGHT JOIN OrderLine ol ON o.OrderID = ol.OrderID
RIGHT JOIN Phone p ON ol.PhoneID = p.PhoneID;

-- Робота з вкладеними запитами (SUBQUERY) для реалізації складної вибірки
SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Manufacturer = 'OnePlus'
);

SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID NOT IN (
    SELECT o.ClientID
    FROM Orders o
);

SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    WHERE ol.Quantity > 4
);

SELECT c.ClientID, c.Type, c.RegistrationDate
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Specifications LIKE '%256GB%'
);

SELECT o.OrderID, o.OrderDate, o.OrderAmount
FROM Orders o
WHERE o.OrderID IN (
    SELECT ol.OrderID
    FROM OrderLine ol
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Price > 74000
);

-- Застосування оператора GROUP BY та умови HAVING у поєднанні з JOIN
SELECT p.Model, SUM(ol.Quantity) AS TotalSold
FROM OrderLine ol
JOIN Phone p ON ol.PhoneID = p.PhoneID
GROUP BY p.Model
HAVING SUM(ol.Quantity) > 23;

SELECT le.CompanyName, SUM(o.OrderAmount) AS TotalOrderSum
FROM LegalEntity le
JOIN Orders o ON le.ClientID = o.ClientID
GROUP BY le.CompanyName
HAVING SUM(o.OrderAmount) > 89000;

SELECT c.ClientID, COUNT(o.OrderID) AS TotalOrders
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
GROUP BY c.ClientID
HAVING COUNT(o.OrderID) > 1;

SELECT p.Manufacturer, p.Model, SUM(ol.Quantity) AS TotalSold
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
GROUP BY p.Manufacturer, p.Model
HAVING SUM(ol.Quantity) > 17;

SELECT p.Manufacturer, SUM(ol.Quantity) AS TotalOrdered
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
GROUP BY p.Manufacturer
HAVING SUM(ol.Quantity) > 34;

-- Формування складних багатотабличних запитів
SELECT p.PhoneID, p.Model, p.Price, COUNT(ol.OrderID) AS OrderCount
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
GROUP BY p.PhoneID, p.Model, p.Price
HAVING COUNT(ol.OrderID) > 1
AND p.Price = (SELECT MAX(Price) FROM Phone);

SELECT p.PhoneID, p.Model
FROM Phone p
WHERE p.PhoneID IN (
    SELECT ol.PhoneID
    FROM OrderLine ol
    JOIN Orders o ON ol.OrderID = o.OrderID
    WHERE o.ClientID IN (
        SELECT c.ClientID
        FROM Client c
        WHERE c.RegistrationDate BETWEEN '2023-01-01' AND '2023-12-31'
    )
);

SELECT c.ClientID, c.Type
FROM Client c
WHERE c.ClientID IN (
    SELECT o.ClientID
    FROM Orders o
    JOIN OrderLine ol ON o.OrderID = ol.OrderID
    JOIN Phone p ON ol.PhoneID = p.PhoneID
    WHERE p.Specifications LIKE '%512GB%'
    GROUP BY o.ClientID
    HAVING SUM(ol.Quantity * p.Price) > 38000
);

SELECT c.ClientID, c.Type, p.Model, p.Price
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Price = (
    SELECT MAX(Price) FROM Phone
);

SELECT p.Manufacturer, p.Model
FROM Phone p
WHERE p.PhoneID NOT IN (
    SELECT DISTINCT ol.PhoneID
    FROM OrderLine ol
    JOIN Orders o ON ol.OrderID = o.OrderID
    JOIN Client c ON o.ClientID = c.ClientID
    JOIN Individual i ON c.ClientID = i.ClientID
)
AND p.PhoneID IN (
    SELECT DISTINCT ol.PhoneID
    FROM OrderLine ol
);

-- Поєднання умов фільтрації (WHERE) із операторами об’єднання таблиць (JOIN)
SELECT Client.ClientID, Client.Type, Orders.OrderID, Orders.OrderDate, OrderLine.Quantity, Phone.Manufacturer, Phone.Model
FROM Client
JOIN Orders ON Client.ClientID = Orders.ClientID
JOIN OrderLine ON Orders.OrderID = OrderLine.OrderID
JOIN Phone ON OrderLine.PhoneID = Phone.PhoneID
WHERE Phone.PhoneID = 31;

SELECT i.FullName, o.OrderID, p.Model, p.Price
FROM Individual i
JOIN Client c ON i.ClientID = c.ClientID
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Price BETWEEN 35000 AND 76000;

SELECT c.ClientID, le.CompanyName, o.OrderID, p.Manufacturer, p.Model, p.Price
FROM Orders o
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
JOIN Client c ON o.ClientID = c.ClientID
JOIN LegalEntity le ON c.ClientID = le.ClientID
WHERE p.Manufacturer = 'Samsung' AND p.Price <= 30000;

SELECT c.ClientID, c.Type, i.FullName
FROM Client c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
LEFT JOIN OrderLine ol ON o.OrderID = ol.OrderID
LEFT JOIN Phone p ON ol.PhoneID = p.PhoneID
LEFT JOIN Individual i ON c.ClientID = i.ClientID
WHERE o.OrderID IS NULL;

SELECT o.OrderID, o.OrderDate, o.OrderAmount, i.FullName, p.Model
FROM Orders o
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
JOIN Client c ON o.ClientID = c.ClientID
JOIN Individual i ON c.ClientID = i.ClientID
WHERE i.Address = 'Одеса, вул. Дерибасівська, 15';

-- Завдання 14
SELECT l.CompanyName, p.Model, SUM(p.Price * ol.Quantity) AS TotalSpent
FROM LegalEntity l
JOIN Orders o ON l.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Model = 'Galaxy A53'
GROUP BY l.CompanyName, p.Model;

SELECT p.Manufacturer, p.Model, SUM(ol.Quantity) AS TotalQuantitySold
FROM Phone p
JOIN OrderLine ol ON p.PhoneID = ol.PhoneID
WHERE p.Price > 34000
GROUP BY p.Manufacturer, p.Model
HAVING SUM(ol.Quantity) > 9;

SELECT c.ClientID, SUM(p.Price * ol.Quantity) AS TotalSpent
FROM Client c
JOIN Orders o ON c.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Price BETWEEN 20000 AND 40000
GROUP BY c.ClientID;

SELECT l.CompanyName, SUM(ol.Quantity) AS TotalPhonesOrdered
FROM LegalEntity l
JOIN Orders o ON l.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
GROUP BY l.CompanyName;

SELECT DISTINCT l.CompanyName
FROM LegalEntity l
JOIN Orders o ON l.ClientID = o.ClientID
JOIN OrderLine ol ON o.OrderID = ol.OrderID
JOIN Phone p ON ol.PhoneID = p.PhoneID
WHERE p.Model = 'Galaxy S23';
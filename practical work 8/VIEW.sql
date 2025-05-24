-- Завдання 3
CREATE VIEW vClientNames AS
SELECT 
    i.ClientID,
    i.FullName AS Name
FROM Individual i

UNION

SELECT 
    l.ClientID,
    l.CompanyName AS Name
FROM LegalEntity l;


-- Завдання 4
SELECT ClientID, Name FROM vClientNames;

-- Завдання 5
CREATE VIEW vPremiumPhones AS
SELECT *
FROM Phone
WHERE Price > 20000;


SELECT * FROM vPremiumPhones;

-- Завдання 6



-- Завдання 7



-- Завдання 8

-- Завдання 9

-- Завдання 10

-- Завдання 11

-- Завдання 12

-- Завдання 13

-- Завдання 14

-- Завдання 15

-- Завдання 16

-- Завдання 17
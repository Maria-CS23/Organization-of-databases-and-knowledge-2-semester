-- �������� 3
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


-- �������� 4
SELECT ClientID, Name FROM vClientNames;

-- �������� 5
CREATE VIEW vPremiumPhones AS
SELECT *
FROM Phone
WHERE Price > 20000;


SELECT * FROM vPremiumPhones;

-- �������� 6



-- �������� 7



-- �������� 8

-- �������� 9

-- �������� 10

-- �������� 11

-- �������� 12

-- �������� 13

-- �������� 14

-- �������� 15

-- �������� 16

-- �������� 17
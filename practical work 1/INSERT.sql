INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (1, 'Фізична особа', '2024-01-15');
INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (2, 'Юридична особа', '2024-02-20');
INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (3, 'Фізична особа', '2024-05-01');

INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber) 
VALUES (1, 'Іваненко Іван Іванович', 'Київ, вул. Хрещатик, 10', 380501234567);

INSERT INTO LegalEntity (ClientID, CompanyName, PhoneNumber, Address, TaxID) 
VALUES (2, 'ТОВ "МобілТех"', 380444567890, 'Львів, вул. Замкова, 12', 1234567890);

INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber) 
VALUES (3, 'Петренко Олег Васильович', 'Одеса, вул. Дерибасівська, 15', 380671094537);

INSERT INTO Phone (PhoneID, Manufacturer, Model, Specifications, Price, Availability) 
VALUES (1, 'Apple', 'iPhone 14', '128GB, Black', 35000, 'В наявності');
INSERT INTO Phone (PhoneID, Manufacturer, Model, Specifications, Price, Availability) 
VALUES (2, 'Samsung', 'Galaxy S23', '256GB, Silver', 30000, 'В наявності');
INSERT INTO Phone (PhoneID, Manufacturer, Model, Specifications, Price, Availability) 
VALUES (3, 'Xiaomi', 'Redmi Note 12', '64GB, Blue', 15000, 'В наявності');

INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount) 
VALUES (1, 1, '2024-03-01', NULL, 35000);
INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount) 
VALUES (2, 3, '2024-03-05', '2024-03-10', 15000);

INSERT INTO OrderLine (LineID, OrderID, PhoneID, Quantity) 
VALUES (1, 1, 1, 1);
INSERT INTO OrderLine (LineID, OrderID, PhoneID, Quantity) 
VALUES (2, 2, 3, 1);
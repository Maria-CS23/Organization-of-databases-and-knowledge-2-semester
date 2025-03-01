INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (1, 'Фізична особа', '2024-01-15');
INSERT INTO Client (ClientID, Type, RegistrationDate) VALUES (2, 'Юридична особа', '2024-02-20');

INSERT INTO Individual (ClientID, FullName, Address, PhoneNumber) 
VALUES (1, 'Іваненко Іван Іванович', 'Київ, вул. Хрещатик, 10', 380501234567);

INSERT INTO LegalEntity (ClientID, CompanyName, PhoneNumber, Address, TaxID) 
VALUES (2, 'ТОВ "МобілТех"', 380444567890, 'Львів, вул. Замкова, 12', 1234567890);

INSERT INTO Phone (PhoneID, Manufacturer, Model, Specifications, Price, Availability) 
VALUES (1, 'Apple', 'iPhone 14', '128GB, Black', 35000, 'В наявності');
INSERT INTO Phone (PhoneID, Manufacturer, Model, Specifications, Price, Availability) 
VALUES (2, 'Samsung', 'Galaxy S23', '256GB, Silver', 30000, 'В наявності');

INSERT INTO Orders (OrderID, ClientID, OrderDate, CompletionDate, OrderAmount) 
VALUES (1, 1, '2024-03-01', NULL, 35000);

INSERT INTO OrderLine (LineID, OrderID, PhoneID, Quantity) 
VALUES (1, 1, 1, 1);

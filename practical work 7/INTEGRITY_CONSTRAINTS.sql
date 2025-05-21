-- Завдання 4
-- 1. PRIMARY KEY
ALTER TABLE Client ADD CONSTRAINT PK_Client PRIMARY KEY (ClientID);

-- 2. FOREIGN KEY
ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Client FOREIGN KEY (ClientID) REFERENCES Client(ClientID);

-- 3. UNIQUE
ALTER TABLE Individual ADD CONSTRAINT UQ_Individual_PhoneNumber UNIQUE (PhoneNumber);

-- 4. CHECK
ALTER TABLE Phone ADD CONSTRAINT CHK_Phone_Price CHECK (Price > 0);

-- 5. DEFAULT
ALTER TABLE Orders ADD CONSTRAINT DF_Orders_Status DEFAULT 'Замовлення оформлено' FOR OrderStatus;

-- 6. NOT NULL
ALTER TABLE LegalEntity ALTER COLUMN CompanyName NVARCHAR(100) NOT NULL;


-- Завдання 6

ALTER TABLE Inventory ADD CONSTRAINT CHK_StockQuantity_NonNegative CHECK (StockQuantity >= 0);

INSERT INTO Inventory (InventoryID, PhoneID, StockQuantity, LastRestockDate, WarehouseLocation)
VALUES (1, 1, 20, '2025-05-20', 'Склад 1');

INSERT INTO Inventory (InventoryID, PhoneID, StockQuantity, LastRestockDate, WarehouseLocation)
VALUES (2, 1, -5, '2025-05-21', 'Склад 2');




BEGIN TRANSACTION;

UPDATE Inventory SET StockQuantity = -10 WHERE InventoryID = 1;

UPDATE Inventory SET StockQuantity = 114 WHERE InventoryID = 1;

COMMIT;


-- Завдання 7
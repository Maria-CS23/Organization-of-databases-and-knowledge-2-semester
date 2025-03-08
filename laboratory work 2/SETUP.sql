CREATE TABLE Client (
    ClientID INT PRIMARY KEY,
    Type VARCHAR(20) NOT NULL,
    RegistrationDate DATE NOT NULL
);

CREATE TABLE Phone (
    PhoneID INT PRIMARY KEY,
    Manufacturer VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Specifications VARCHAR(200)NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Availability VARCHAR(20) NOT NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    OrderDate DATE NOT NULL,
    CompletionDate DATE NULL,
    OrderAmount INT NOT NULL,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE OrderLine (
    LineID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    PhoneID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PhoneID) REFERENCES Phone(PhoneID)
);

CREATE TABLE Individual (
    ClientID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    PhoneNumber BIGINT NOT NULL,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE LegalEntity (
    ClientID INT PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    PhoneNumber BIGINT NOT NULL,
    Address VARCHAR(200) NOT NULL,
    TaxID INT NOT NULL UNIQUE,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);


ALTER TABLE Phone ADD WarrantyPeriod INT NOT NULL DEFAULT 12;

ALTER TABLE Orders ALTER COLUMN OrderAmount DECIMAL(10,2);

ALTER TABLE Client ADD Email VARCHAR(100) NULL;
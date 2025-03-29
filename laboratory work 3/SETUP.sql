CREATE TABLE Client (
    ClientID INT PRIMARY KEY,
    Type NVARCHAR(20) NOT NULL,
    RegistrationDate DATE NOT NULL
);

CREATE TABLE Phone (
    PhoneID INT PRIMARY KEY,
    Manufacturer NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Specifications NVARCHAR(200)NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Availability NVARCHAR(20) NOT NULL
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
    FullName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    PhoneNumber BIGINT NOT NULL,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE LegalEntity (
    ClientID INT PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    PhoneNumber BIGINT NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    TaxID INT NOT NULL UNIQUE,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

ALTER TABLE Orders ALTER COLUMN OrderAmount DECIMAL(10,2);

ALTER TABLE Individual ADD Email NVARCHAR(100) NULL;

ALTER TABLE LegalEntity ADD Email NVARCHAR(100) NULL;

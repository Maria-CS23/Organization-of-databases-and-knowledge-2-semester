CREATE TABLE Client (
    ClientID INT,
    Type NVARCHAR(20) NOT NULL,
    RegistrationDate DATE NOT NULL
);

CREATE TABLE Phone (
    PhoneID INT,
    Manufacturer NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Specifications NVARCHAR(200)NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Availability NVARCHAR(20) NOT NULL
);

CREATE TABLE Orders (
    OrderID INT,
    ClientID INT NOT NULL,
    OrderDate DATE NOT NULL,
    CompletionDate DATE NULL,
    OrderAmount INT NOT NULL
);

CREATE TABLE OrderLine (
    LineID INT,
    OrderID INT NOT NULL,
    PhoneID INT NOT NULL,
    Quantity INT NOT NULL
);

CREATE TABLE Individual (
    ClientID INT,
    FullName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);

CREATE TABLE LegalEntity (
    ClientID INT,
    CompanyName NVARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    TaxID VARCHAR(20) NOT NULL
);


ALTER TABLE Orders ALTER COLUMN OrderAmount DECIMAL(10,2);

ALTER TABLE Individual ADD Email NVARCHAR(100) NULL;

ALTER TABLE LegalEntity ADD Email NVARCHAR(100) NULL;
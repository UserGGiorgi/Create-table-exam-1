create table Brands (
BrandId integer primary key,
Name varchar(50) not null unique
);

create table Manufacturers(
ManufacturerId integer primary key ,
Name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Employees(
EmployeeId INTEGER PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Position VARCHAR(50) NOT NULL
);

Create Table Owners(
OwnerId Integer Primary Key,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL
);

Create Table ScreenResolution(
ResolutionId Integer PRIMARY KEY,
Resolution VARCHAR(20) NOT NULL UNIQUE
);

Create Table MatrixTypes(
MatrixTypesId Integer PRIMARY KEY,
TypeName VARCHAR(20) NOT NULL UNIQUE
);

Create Table SmartphoneModels(
ModelId INTEGER PRIMARY KEY,
ModelName VARCHAR(50) NOT NULL UNIQUE,
BrandId INTEGER Not Null,
ManufacturerId Integer Not Null,
Foreign key (BrandId) REFERENCES Brands(BrandId),
FOREIGN KEY (ManufacturerId) REFERENCES Manufacturers(ManufacturerId)
);

CREATE TABLE Smartphones (
    SmartphoneId INTEGER PRIMARY KEY,
    ModelId INTEGER NOT NULL,
    OwnerId INTEGER NOT NULL,
    RAM INTEGER NOT NULL CHECK (RAM > 0),
    ROM INTEGER NOT NULL CHECK (ROM > 0),
    YearOfManufacture INTEGER NOT NULL CHECK (YearOfManufacture BETWEEN 2000 AND 2100),
    IMEI1 VARCHAR(15) NOT NULL UNIQUE,
    IMEI2 VARCHAR(15),
    MalfunctionDescription TEXT NOT NULL,
    ReceiptNo INTEGER NOT NULL,
    EmployeeId INTEGER NOT NULL,
    FOREIGN KEY (ModelId) REFERENCES SmartphoneModels(ModelId),
    FOREIGN KEY (OwnerId) REFERENCES Owners(OwnerId),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);

CREATE TABLE Repairs (
    RepairId INTEGER PRIMARY KEY,
    ReceiptNo INTEGER NOT NULL UNIQUE,
    MalfunctionDescription TEXT NOT NULL,
    RepairState VARCHAR(50) NOT NULL CHECK (RepairState IN ('Repairable', 'Unrepairable', 'Accepted for diagnostics', 'On diagnostics', 'Under repair', 'Ready to be returned', 'Returned')),
    AmountToPay DECIMAL(10, 2) NOT NULL CHECK (AmountToPay >= 0),
    DiagnosticEmployeeId INTEGER NOT NULL,
    RepairEmployeeId INTEGER,
    SmartphoneId INTEGER NOT NULL,
    FOREIGN KEY (DiagnosticEmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (RepairEmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (SmartphoneId) REFERENCES Smartphones(SmartphoneId)
);
CREATE TABLE Receipts (
    ReceiptId INTEGER PRIMARY KEY,
    ReceiptNo INTEGER NOT NULL UNIQUE,
    IssueDate DATE NOT NULL
);
CREATE TABLE RepairStatusHistory (
    StatusHistoryId INTEGER PRIMARY KEY,
    RepairId INTEGER NOT NULL,
    Status VARCHAR(50) NOT NULL CHECK (Status IN ('Repairable', 'Unrepairable', 'Accepted for diagnostics', 'On diagnostics', 'Under repair', 'Ready to be returned', 'Returned')),
    StatusChangeDate DATE NOT NULL,
    FOREIGN KEY (RepairId) REFERENCES Repairs(RepairId)
);
CREATE TABLE RepairCosts (
    RepairCostId INTEGER PRIMARY KEY,
    RepairId INTEGER NOT NULL,
    CostDescription VARCHAR(100) NOT NULL,
    CostAmount DECIMAL(10, 2) NOT NULL CHECK (CostAmount > 0),
    FOREIGN KEY (RepairId) REFERENCES Repairs(RepairId)
);
CREATE TABLE RepairParts (
    RepairPartId INTEGER PRIMARY KEY,
    RepairId INTEGER NOT NULL,
    PartName VARCHAR(50) NOT NULL,
    PartCost DECIMAL(10, 2) NOT NULL CHECK (PartCost > 0),
    PartQuantity INTEGER NOT NULL CHECK (PartQuantity > 0),
    FOREIGN KEY (RepairId) REFERENCES Repairs(RepairId)
);
CREATE TABLE RepairWarranties (
    WarrantyId INTEGER PRIMARY KEY,
    RepairId INTEGER NOT NULL,
    WarrantyPeriod INTEGER NOT NULL CHECK (WarrantyPeriod > 0),
    WarrantyStartDate DATE NOT NULL,
    FOREIGN KEY (RepairId) REFERENCES Repairs(RepairId)
);
CREATE TABLE Payments (
    PaymentId INTEGER PRIMARY KEY,
    RepairId INTEGER NOT NULL,
    PaymentAmount DECIMAL(10, 2) NOT NULL CHECK (PaymentAmount >= 0),
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (RepairId) REFERENCES Repairs(RepairId)
);
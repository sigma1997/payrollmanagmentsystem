CREATE DATABASE PayrollManagementSystem;
GO

USE PayrollManagementSystem;
GO

CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Department NVARCHAR(50),
    Designation NVARCHAR(50),
    DateOfJoining DATE,
    Status NVARCHAR(10) CHECK (Status IN ('Active', 'Inactive')),
    BankAccountNumber NVARCHAR(20),
    Email NVARCHAR(100),
    Phone NVARCHAR(15)
);

CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID),
    Date DATE NOT NULL,
    CheckIn TIME,
    CheckOut TIME,
    WorkHours FLOAT
);

CREATE TABLE Salary (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID),
    BasicSalary DECIMAL(10,2) NOT NULL,
    HRA DECIMAL(10,2),
    OtherAllowances DECIMAL(10,2),
    Deductions DECIMAL(10,2),
    GrossSalary DECIMAL(10,2),
    NetSalary DECIMAL(10,2)
);
CREATE TABLE Payroll (
    PayrollID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID),
    PayPeriod DATE NOT NULL,
    NetPay DECIMAL(10,2),
    PaymentDate DATE NOT NULL
);
CREATE TABLE Tax (
    TaxID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID),
    TaxableIncome DECIMAL(10,2),
    TaxRate FLOAT,
    TaxAmount DECIMAL(10,2)
);
CREATE PROCEDURE CalculateGrossSalary
    @EmployeeID INT
AS
BEGIN
    DECLARE @BasicSalary DECIMAL(10,2), @HRA DECIMAL(10,2), @OtherAllowances DECIMAL(10,2), @GrossSalary DECIMAL(10,2);

    SELECT @BasicSalary = BasicSalary, @HRA = HRA, @OtherAllowances = OtherAllowances
    FROM Salary
    WHERE EmployeeID = @EmployeeID;

    SET @GrossSalary = @BasicSalary + @HRA + @OtherAllowances;

    UPDATE Salary
    SET GrossSalary = @GrossSalary
    WHERE EmployeeID = @EmployeeID;
END;


CREATE PROCEDURE GeneratePayroll
    @EmployeeID INT,
    @PayPeriod DATE
AS
BEGIN
    DECLARE @GrossSalary DECIMAL(10,2), @Deductions DECIMAL(10,2), @NetSalary DECIMAL(10,2);

    SELECT @GrossSalary = GrossSalary, @Deductions = Deductions
    FROM Salary
    WHERE EmployeeID = @EmployeeID;

    SET @NetSalary = @GrossSalary - @Deductions;

    INSERT INTO Payroll (EmployeeID, PayPeriod, NetPay, PaymentDate)
    VALUES (@EmployeeID, @PayPeriod, @NetSalary, GETDATE());
END;

CREATE VIEW PayrollSummary AS
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    s.GrossSalary,
    s.NetSalary,
    p.PayPeriod,
    p.PaymentDate
FROM Employee e
JOIN Salary s ON e.EmployeeID = s.EmployeeID
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;

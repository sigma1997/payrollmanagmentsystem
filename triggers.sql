--Trigger for Auto-Calculating Work Hours
--Automatically calculate work hours when CheckOut is updated.

CREATE TRIGGER CalculateWorkHours
ON Attendance
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE CheckOut IS NOT NULL)
    BEGIN
        UPDATE Attendance
        SET WorkHours = DATEDIFF(MINUTE, CheckIn, CheckOut) / 60.0
        WHERE AttendanceID IN (SELECT AttendanceID FROM inserted);
    END;
END;

--Trigger for Audit Logs
--Track changes to employee records.

CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    ChangedColumn NVARCHAR(50),
    OldValue NVARCHAR(255),
    NewValue NVARCHAR(255),
    ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER AuditEmployeeChanges
ON Employee
AFTER UPDATE
AS
BEGIN
    DECLARE @EmployeeID INT;
    SELECT @EmployeeID = EmployeeID FROM inserted;

    INSERT INTO AuditLog (EmployeeID, ChangedColumn, OldValue, NewValue)
    SELECT 
        i.EmployeeID,
        c.name AS ChangedColumn,
        d.value AS OldValue,
        i.value AS NewValue
    FROM
        (SELECT * FROM inserted FOR JSON AUTO) i
    FULL OUTER JOIN
        (SELECT * FROM deleted FOR JSON AUTO) d
    ON i.EmployeeID = d.EmployeeID
    JOIN sys.columns c
    ON c.object_id = OBJECT_ID('Employee');
END;

 --Create Reports
---Salary Report
---Generate a report of employees' salaries.

SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    s.BasicSalary,
    s.HRA,
    s.OtherAllowances,
    s.Deductions,
    s.GrossSalary,
    s.NetSalary
FROM Employee e
JOIN Salary s ON e.EmployeeID = s.EmployeeID;

--Attendance Report
---Summarize attendance by employee.

SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    COUNT(a.AttendanceID) AS DaysPresent,
    SUM(a.WorkHours) AS TotalWorkHours
FROM Employee e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

--Payroll Report
---Summarize payroll details for a specific period.

SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    p.PayPeriod,
    p.NetPay,
    p.PaymentDate
FROM Employee e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE p.PayPeriod = '2024-12-01';




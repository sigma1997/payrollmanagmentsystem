--Step 1: Insert Sample Data
Below is a script to populate your database tables with realistic sample data.

INSERT INTO Employee (FirstName, LastName, Department, Designation, DateOfJoining, Status, BankAccountNumber, Email, Phone)
VALUES 
('John', 'Doe', 'IT', 'Software Engineer', '2022-01-15', 'Active', '123456789', 'john.doe@example.com', '9876543210'),
('Jane', 'Smith', 'HR', 'HR Manager', '2021-06-10', 'Active', '987654321', 'jane.smith@example.com', '9123456780'),
('Alice', 'Brown', 'Finance', 'Accountant', '2020-11-20', 'Active', '654321987', 'alice.brown@example.com', '8987654321');

---2. Salary Table

INSERT INTO Salary (EmployeeID, BasicSalary, HRA, OtherAllowances, Deductions)
VALUES 
(1, 60000, 15000, 5000, 2000),
(2, 80000, 20000, 10000, 3000),
(3, 50000, 12000, 4000, 1500);

--- Attendance Table
INSERT INTO Attendance (EmployeeID, Date, CheckIn, CheckOut)
VALUES 
(1, '2024-12-01', '09:00:00', '17:00:00'),
(1, '2024-12-02', '09:15:00', '17:30:00'),
(2, '2024-12-01', '09:00:00', '17:00:00'),
(3, '2024-12-01', '09:10:00', '16:50:00');
----4. Payroll Table

INSERT INTO Payroll (EmployeeID, PayPeriod, NetPay, PaymentDate)
VALUES 
(1, '2024-12-01', 68000, '2024-12-05'),
(2, '2024-12-01', 97000, '2024-12-05'),
(3, '2024-12-01', 55400, '2024-12-05');

----5. Tax Table
INSERT INTO Tax (EmployeeID, TaxableIncome, TaxRate, TaxAmount)
VALUES 
(1, 68000, 0.1, 6800),
(2, 97000, 0.12, 11640),
(3, 55400, 0.08, 4432);

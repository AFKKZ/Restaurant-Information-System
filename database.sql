-- Create fresh database
CREATE DATABASE KTPHAM
GO
USE KTPHAM
GO

-- Drop tables if they exist (in correct order due to dependencies)
IF OBJECT_ID('PaymentLog', 'U') IS NOT NULL DROP TABLE PaymentLog;
IF OBJECT_ID('OrderDetail', 'U') IS NOT NULL DROP TABLE OrderDetail;
IF OBJECT_ID('OrderLog', 'U') IS NOT NULL DROP TABLE OrderLog;
IF OBJECT_ID('MenuItem', 'U') IS NOT NULL DROP TABLE MenuItem;
IF OBJECT_ID('RestaurantTable', 'U') IS NOT NULL DROP TABLE RestaurantTable;
IF OBJECT_ID('Employee', 'U') IS NOT NULL DROP TABLE Employee;

-- Create Employee table
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50) NOT NULL
);

-- Create MenuItem table
CREATE TABLE MenuItem (
    DishID INT IDENTITY(1,1) PRIMARY KEY,
    DishName NVARCHAR(100) NOT NULL,
    Size NVARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    DishType NVARCHAR(50) NOT NULL,
    StarRating INT,
    TotalSold INT DEFAULT 0
);

-- Create RestaurantTable table
CREATE TABLE RestaurantTable (
    TableID INT IDENTITY(1,1) PRIMARY KEY,
    TableNumber NVARCHAR(10) NOT NULL,
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Available', 'Occupied', 'Reserved'))
);

-- Create OrderLog table
CREATE TABLE OrderLog (
    OrderID NVARCHAR(8) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TableID INT,
    Status NVARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TableID) REFERENCES RestaurantTable(TableID)
);

-- Create OrderDetail table
CREATE TABLE OrderDetail (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID NVARCHAR(8) NOT NULL,
    DishID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (OrderID) REFERENCES OrderLog(OrderID),
    FOREIGN KEY (DishID) REFERENCES MenuItem(DishID)
);

-- Create PaymentLog table
CREATE TABLE PaymentLog (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID NVARCHAR(8) NOT NULL,
    PaymentStatus NVARCHAR(50) NOT NULL,
    PaymentDate DATETIME DEFAULT NULL,
    FOREIGN KEY (OrderID) REFERENCES OrderLog(OrderID)
);

-- Create Reservation table
CREATE TABLE Reservation (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    TableID INT NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL,
    ReservationDateTime DATETIME NOT NULL,
    NumberOfGuests INT NOT NULL,
    SpecialRequests NVARCHAR(255),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Confirmed', -- 'Confirmed', 'Cancelled', 'Completed'
    FOREIGN KEY (TableID) REFERENCES RestaurantTable(TableID)
);

-- Insert initial data into Employee
INSERT INTO Employee (EmployeeName, Position)
VALUES
('HTH', 'Manager'),
('Fishie', 'Sous Chef'),
('MOnke', 'Head Chef'),
('Heo', 'Station Chef'),
('Eli', 'Station Chef'),
('Nguyen', 'Station Chef'),
('Megaxayda', 'Station Chef'),
('ThangVoDich', 'Station Chef'),
('Khoa', 'Waiter'),
('HieuThuHai', 'Waiter');

-- Insert initial data into MenuItem
INSERT INTO MenuItem (DishName, Size, Price, DishType, StarRating, TotalSold)
VALUES
-- Beverages
('Espresso', 'Small', 2.50, 'Beverage', 4, 45),
('Cappuccino', 'Medium', 4.00, 'Beverage', 5, 78),
('Latte', 'Medium', 4.50, 'Beverage', 4, 65),
('Green Tea', 'Small', 2.00, 'Beverage', 3, 32),
('Iced Lemon Tea', 'Large', 3.50, 'Beverage', 4, 89),
-- Desserts
('Cheesecake', 'Slice', 4.00, 'Dessert', 5, 92),
('Chocolate Cake', 'Slice', 3.50, 'Dessert', 4, 76),
('Apple Pie', 'Slice', 3.00, 'Dessert', 3, 45),
('Tiramisu', 'Slice', 4.50, 'Dessert', 5, 88),
('Brownie', 'Slice', 2.50, 'Dessert', 4, 67),
-- Main Courses
('Spaghetti Meatballs', 'Medium', 7.50, 'Main Course', 4, 95),
('Grilled Chicken Salad', 'Medium', 9.00, 'Main Course', 3, 56),
('BBQ Ribs', 'Large', 15.00, 'Main Course', 5, 78),
('Vegetarian Pizza', 'Medium', 10.00, 'Main Course', 4, 45),
('Beef Steak', 'Large', 18.50, 'Main Course', 5, 102),
('Fried Rice', 'Large', 9.50, 'Main Course', 4, 123),
('Pork Chop Rice', 'Medium', 9.00, 'Main Course', 4, 87),
('Pho', 'Medium', 8.50, 'Main Course', 5, 145),
-- Side Dishes
('French Fries', 'Small', 3.00, 'Side Dish', 4, 156),
('Garlic Bread', 'Small', 2.50, 'Side Dish', 3, 78),
('Onion Rings', 'Medium', 4.00, 'Side Dish', 4, 67),
('Dimsum', 'Small', 4.69, 'Side Dish', 5, 89),
('Mashed Potatoes', 'Medium', 3.50, 'Side Dish', 4, 54);

-- Insert initial data into RestaurantTable
INSERT INTO RestaurantTable (TableNumber, Status)
VALUES
('T1', 'Available'),
('T2', 'Available'),
('T3', 'Occupied'),
('T4', 'Reserved'),
('T5', 'Available'),
('T6', 'Occupied'),
('T7', 'Available'),
('T8', 'Available'),
('T9', 'Available'),
('T10', 'Reserved');

-- Insert initial data into OrderLog
INSERT INTO OrderLog (OrderID, EmployeeID, OrderDate, TableID, Status)
VALUES
('ORDR0001', 1, GETDATE(), 3, 'Pending'),
('ORDR0002', 2, GETDATE(), 6, 'In Progress'),
('ORDR0003', 3, GETDATE(), 7, 'Completed');

-- Insert initial data into OrderDetail
INSERT INTO OrderDetail (OrderID, DishID, Quantity)
VALUES
-- For Order ORDR0001
('ORDR0001', 11, 2),  -- 2 Spaghetti Meatballs
('ORDR0001', 19, 1),  -- 1 French Fries
('ORDR0001', 1, 2),   -- 2 Espresso

-- For Order ORDR0002
('ORDR0002', 15, 1),  -- 1 Beef Steak
('ORDR0002', 20, 2),  -- 2 Garlic Bread
('ORDR0002', 5, 2),   -- 2 Iced Lemon Tea

-- For Order ORDR0003
('ORDR0003', 16, 2),  -- 2 Fried Rice
('ORDR0003', 22, 1),  -- 1 Dimsum
('ORDR0003', 4, 3);   -- 3 Green Tea

-- Insert initial data into PaymentLog
INSERT INTO PaymentLog (OrderID, PaymentStatus, PaymentDate)
VALUES
('ORDR0001', 'Pending', GETDATE()),
('ORDR0002', 'Pending', NULL),
('ORDR0003', 'Paid', GETDATE());

-- Insert sample reservations
INSERT INTO Reservation (TableID, CustomerName, ContactNumber, ReservationDateTime, NumberOfGuests, Status)
VALUES 
(4, 'John Doe', '0123456789', DATEADD(DAY, 1, GETDATE()), 4, 'Confirmed'),
(10, 'Jane Smith', '9876543210', DATEADD(DAY, 2, GETDATE()), 6, 'Confirmed');
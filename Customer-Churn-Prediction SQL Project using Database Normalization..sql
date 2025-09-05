-- Project Name: Customer-Churn-Prediction SQL Project using Database Normalization.

/*
Database Normalization
Instead of storing everything in one big table First, split the dataset into Normalized tables.
1NF (Remove repeating groups):
We separate Customer Info, Services, Contract & Billing, and Churn into different tables.
*/

-- Create Customer Table
CREATE TABLE Customers (
    customerID VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    SeniorCitizen TINYINT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT
);

-- Create Services Table
CREATE TABLE Services (
    serviceID INT AUTO_INCREMENT PRIMARY KEY,
    customerID VARCHAR(20),
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

-- Create Contracts Table
CREATE TABLE Contracts (
    contractID INT AUTO_INCREMENT PRIMARY KEY,
    customerID VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

-- Create Churn Table
CREATE TABLE ChurnStatus (
    churnID INT AUTO_INCREMENT PRIMARY KEY,
    customerID VARCHAR(20),
    Churn VARCHAR(5),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

-- This is 3NF Normalized (Customer → Services → Contracts → Churn).

/*
Database Normalization & Denormalization

Normalization: Organizing data into multiple related tables to remove redundancy and anomalies.
Denormalization: Combining tables back into one (for faster query performance at cost of redundancy).

MySQL Implementation
Step A: Create Normalized Tables
*/

-- Customers Table
CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10)
);

-- Plans Table
CREATE TABLE Plans (
    PlanID VARCHAR(10) PRIMARY KEY,
    PlanType VARCHAR(20),
    MonthlyCharges DECIMAL(10,2)
);

-- CustomerPlans Table (Bridge table)
CREATE TABLE CustomerPlans (
    CustomerID VARCHAR(10),
    PlanID VARCHAR(10),
    ChurnStatus VARCHAR(10),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PlanID) REFERENCES Plans(PlanID)
);

-- Step B: Insert Sample Data

INSERT INTO Customers VALUES 
('C001', 'John Smith', 29, 'Male'),
('C002', 'Mary Jones', 35, 'Female');

INSERT INTO Plans VALUES 
('P01', 'Premium', 80),
('P02', 'Basic', 40);

INSERT INTO CustomerPlans VALUES 
('C001', 'P01', 'Yes'),
('C002', 'P02', 'No'),
('C001', 'P02', 'Yes');

-- Step C: Query Normalized Data

-- Joining normalized tables to see churn data
SELECT c.CustomerName, c.Age, c.Gender,
       p.PlanType, p.MonthlyCharges, cp.ChurnStatus
FROM Customers c
JOIN CustomerPlans cp ON c.CustomerID = cp.CustomerID
JOIN Plans p ON cp.PlanID = p.PlanID;

-- Step D: Denormalized Table

CREATE TABLE Denormalized_Churn AS
SELECT c.CustomerID, c.CustomerName, c.Age, c.Gender,
       p.PlanType, p.MonthlyCharges, cp.ChurnStatus
FROM Customers c
JOIN CustomerPlans cp ON c.CustomerID = cp.CustomerID
JOIN Plans p ON cp.PlanID = p.PlanID;

-- Now you have both Normalized and Denormalized structures in SQL.

-- Define Entity Relationship (ER) Model

-- Entity: Object (Customer, Services, Contracts, Churn).
-- Attribute: Property (e.g., gender, tenure).
-- Relationship: How entities are connected (Customer → Services, Customer → Contracts, Customer → Churn).

-- SQL Implementation of ER Model

-- Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    location VARCHAR(100),
    tenure INT
);

-- Services Table
CREATE TABLE Services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    phone_service BOOLEAN,
    internet_service VARCHAR(50),
    streaming_service BOOLEAN,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Contracts Table
CREATE TABLE Contracts (
    contract_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    contract_type VARCHAR(50),
    payment_method VARCHAR(50),
    monthly_charges DECIMAL(10,2),
    total_charges DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Churn Table
CREATE TABLE Churn (
    churn_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    churn_status VARCHAR(10),
    churn_reason VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Shows strong database design using ER model.
-- Demonstrates normalization (no redundant data).

-- Difference between Entity, Attribute, Relationship
-- Entity: Customer
-- Attribute: Customer Name, Gender, Tenure
-- Relationship: Customer subscribes to Services

-- Relationship, Relationship Sets, Relationship Degree
-- Relationship: Links between entities (Customer–Contract).
-- Relationship Set: All such relations (all customer contracts).
-- Degree: Number of entities in relation (binary = 2 entities).

-- SQL Example (Foreign Key relationship):
-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    Tenure INT
);

-- Contracts Table
CREATE TABLE Contracts (
    ContractID INT PRIMARY KEY,
    ContractType VARCHAR(50),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Here, CustomerID in Contracts table establishes the relationship between Customers and Contracts.

-- SQL Example (View all relationships):
-- List all Customer–Contract relationships
SELECT c.CustomerName, c.Gender, ct.ContractType
FROM Customers c
JOIN Contracts ct ON c.CustomerID = ct.CustomerID;

-- This table of results = Relationship Set.


-- Relationship Degree
-- Degree = Number of entities involved in a relationship.
-- Unary (1 entity) → Example: Customer refers another customer.
-- Binary (2 entities) → Example: Customer–Contract.
-- Ternary (3 entities) → Example: Customer–Contract–Service.

-- SQL Example (Binary Relationship):
-- Binary relationship: Customer (1) ↔ Contract (2)
SELECT c.CustomerName, ct.ContractType
FROM Customers c
JOIN Contracts ct ON c.CustomerID = ct.CustomerID;

-- SQL Example (Ternary Relationship):

-- Suppose we add Services table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(50),
    ContractID INT,
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID)
);

-- Now Customer (1) ↔ Contract (2) ↔ Service (3)
SELECT c.CustomerName, ct.ContractType, s.ServiceName
FROM Customers c
JOIN Contracts ct ON c.CustomerID = ct.CustomerID
JOIN Services s ON ct.ContractID = s.ContractID;

-- Now the degree of relationship is 3 (ternary).

/*
Mapping Cardinalities
One-to-One: Each customer has one churn status.
One-to-Many: One customer can have many services.
Many-to-Many: Customers and payment methods (if multiple allowed).

1. One-to-One Mapping
Each customer has exactly one churn status (Yes/No).

📌 Design:

Customer table → customer details.
Churn table → churn info (one record per customer).
*/

-- Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    Tenure INT
);

-- Churn table (One-to-One with Customer)
CREATE TABLE Churn (
    CustomerID INT PRIMARY KEY,
    ChurnStatus ENUM('Yes', 'No'),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Get churn status for each customer

SELECT c.CustomerName, c.Gender, c.Tenure, ch.ChurnStatus
FROM Customer c
JOIN Churn ch ON c.CustomerID = ch.CustomerID;

/*
2. One-to-Many Mapping
One customer can subscribe to many services.

📌 Design:

Customer table → stores customer info.
Service table → stores customer services (Internet, Phone, TV, etc.).
*/

-- Service table (One-to-Many with Customer)
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ServiceName VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Get all services of a customer
SELECT c.CustomerName, s.ServiceName
FROM Customer c
JOIN Service s ON c.CustomerID = s.CustomerID
WHERE c.CustomerName = 'John Doe';

/*
3. Many-to-Many Mapping
Customers can use multiple payment methods, and one payment method can belong to many customers.

📌 Design:

Customer table.
PaymentMethod table → stores available payment methods.
CustomerPayment (junction table) → resolves many-to-many relationship.
*/

-- PaymentMethod table
CREATE TABLE PaymentMethod (
    PaymentMethodID INT PRIMARY KEY AUTO_INCREMENT,
    MethodName VARCHAR(50)
);

-- Junction table (Many-to-Many)
CREATE TABLE CustomerPayment (
    CustomerID INT,
    PaymentMethodID INT,
    PRIMARY KEY (CustomerID, PaymentMethodID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);

-- Find all customers and their payment methods
SELECT c.CustomerName, pm.MethodName
FROM Customer c
JOIN CustomerPayment cp ON c.CustomerID = cp.CustomerID
JOIN PaymentMethod pm ON cp.PaymentMethodID = pm.PaymentMethodID;

/*
One-to-One (Customer–ChurnStatus): Each customer has one churn status.
One-to-Many (Customer–Services): A customer can subscribe to many services.
Many-to-Many (Customer–PaymentMethods): Customers can have multiple payment methods.
*/

/*
Cardinality Notations in ER Diagram
In ER modeling, Cardinality Notation tells us how 
many instances of one entity relate to another.
We’ll apply them to your Customer Churn Prediction Project.

1. (1,1) → One-to-One Relationship
📌 Example in Project:
Each Customer has one Churn Status (Yes or No).

ERD Notation:
Customer (1,1) → ChurnStatus (1,1)

SQL Implementation
*/

-- Customer Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    Tenure INT
);

-- Churn Status Table (One-to-One with Customer)
CREATE TABLE ChurnStatus (
    CustomerID INT PRIMARY KEY,
    ChurnFlag VARCHAR(3) CHECK (ChurnFlag IN ('Yes','No')),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- each Customer has only one churn status.

/*
2. (1,N) → One-to-Many Relationship
📌 Example in Project:
One Customer can subscribe to many Services (Internet, Phone, Streaming).

ERD Notation:
Customer (1,1) → Service (1,N)

SQL Implementation
*/

-- Services Table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(50)
);

-- Customer Services (One customer can have many services)
CREATE TABLE CustomerServices (
    CustomerServiceID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ServiceID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- one customer can have many services.

/*
3. (M,N) → Many-to-Many Relationship
📌 Example in Project:
Customers can have multiple Contracts, and each Contract can apply to multiple Customers (family plan, shared accounts).

ERD Notation:
Customer (M,N) ↔ Contract (M,N)

✅ SQL Implementation
*/

-- Contracts Table
CREATE TABLE Contracts (
    ContractID INT PRIMARY KEY,
    ContractType VARCHAR(50),
    DurationMonths INT
);

-- Junction Table for Many-to-Many
CREATE TABLE CustomerContracts (
    CustomerID INT,
    ContractID INT,
    PRIMARY KEY (CustomerID, ContractID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID)
);

-- Here, many customers can share a contract, and many contracts can belong to multiple customers.
























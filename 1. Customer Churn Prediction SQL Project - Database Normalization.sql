-- create three tables: Customers, Subscriptions, and Transactions.

create database data_normalization_db;

use data_normalization_db;

create table customer_table(
customer_id int primary key,
customer_name varchar(50),
customer_email_id varchar(50),
customer_joindate date);

create table subscription_table(
subcription_id int primary key,
subcription_type varchar(50),
customer_id int,
start_date date,
end_date date,
monthly_charges decimal(10,3),
foreign key (customer_id) references customer_table(customer_id));

create table transaction_table(
transaction_id int primary key,
transaction_date date,
transaction_type varchar(50),
customer_id int,
amount decimal(10,2),
foreign key (customer_id) references customer_table(customer_id)
);

-- Data Insertion

insert into customer_table values
(1, 'Deepika', 'deepikaseraph.77@gmail.com', '2025-09-02'),
(2, 'rani', 'rani.77@gmail.com', '2025-09-04');

select * from customer_table;

insert into subscription_table values
(101, 'Basic', 1, '2023-01-15', '2024-01-14', 29.99),
(102, 'Premium', 2, '2023-02-10', '2024-02-09', 49.99 );

select * from subscription_table;

insert into transaction_table values
(1001, '2023-01-15', 'Payment', 1, 29.99),
(1002, '2023-02-10', 'Payment', 2, 49.99);

select * from transaction_table;
























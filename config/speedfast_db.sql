-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS speedfast_db;
USE speedfast_db;

-- =========================
-- CUSTOMERS
-- =========================
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    address TEXT,
    contact_no VARCHAR(20),
    email VARCHAR(100),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- SERVICES
-- =========================
CREATE TABLE IF NOT EXISTS services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100),
    monthly_rate DECIMAL(10,2),
    description TEXT
);

-- =========================
-- ACCOUNTS
-- =========================
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    account_number VARCHAR(50) UNIQUE,
    start_date DATE,
    status ENUM('Active','Disconnected','Suspended') DEFAULT 'Active',

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- BILLING SCHEDULES
-- =========================
CREATE TABLE IF NOT EXISTS billing_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    billing_day INT NOT NULL,

    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- BILLS
-- =========================
CREATE TABLE IF NOT EXISTS bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    bill_date DATE,
    due_date DATE,
    amount_due DECIMAL(10,2),
    status ENUM('Unpaid','Partially Paid','Paid') DEFAULT 'Unpaid',

    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    amount_paid DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    processed_by INT,

    FOREIGN KEY (bill_id) REFERENCES bills(bill_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- USERS
-- =========================
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255),
    role ENUM('Admin','Cashier')
);

-- =========================
-- AUDIT LOGS
-- =========================
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action TEXT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =========================
-- SAMPLE DATA
-- =========================
INSERT INTO services (service_name, monthly_rate, description) VALUES
('Postpaid Plan 999', 999.00, 'Mobile Postpaid Plan'),
('Fiber Internet 1499', 1499.00, 'Home Fiber Internet');

INSERT INTO users (full_name, username, password, role) VALUES
('System Admin', 'admin', MD5('admin123'), 'Admin'),
('Cashier One', 'cashier', MD5('cashier123'), 'Cashier');
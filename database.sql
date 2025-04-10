-- Create database
CREATE DATABASE IF NOT EXISTS property_app;
USE property_app;

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Properties table
CREATE TABLE properties (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    location VARCHAR(255) NOT NULL,
    status ENUM('available', 'unavailable') DEFAULT 'available',
    video_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Property images table
CREATE TABLE property_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reservations table
CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    total_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payments table
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT NOT NULL,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('paystack', 'paypal', 'crypto') NOT NULL,
    transaction_id VARCHAR(255) NOT NULL,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (property_id) REFERENCES properties(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Admins table
CREATE TABLE admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default admin user (password: admin123)
INSERT INTO admins (name, email, password_hash) VALUES 
('Admin User', 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Insert sample properties
INSERT INTO properties (title, description, price, location, status) VALUES
('Luxury Beach Villa', 'Beautiful beachfront villa with stunning ocean views', 299.99, 'Miami Beach, FL', 'available'),
('Mountain Cabin', 'Cozy cabin in the mountains perfect for winter getaways', 149.99, 'Aspen, CO', 'available'),
('City Apartment', 'Modern apartment in the heart of downtown', 199.99, 'New York, NY', 'available'),
('Lake House', 'Peaceful lake house with private dock', 179.99, 'Lake Tahoe, CA', 'available'),
('Desert Oasis', 'Unique desert property with pool', 159.99, 'Phoenix, AZ', 'available');

-- Insert sample property images
INSERT INTO property_images (property_id, image_url) VALUES
(1, 'uploads/villa1.jpg'),
(1, 'uploads/villa2.jpg'),
(2, 'uploads/cabin1.jpg'),
(2, 'uploads/cabin2.jpg'),
(3, 'uploads/apartment1.jpg'),
(3, 'uploads/apartment2.jpg'),
(4, 'uploads/lake1.jpg'),
(4, 'uploads/lake2.jpg'),
(5, 'uploads/desert1.jpg'),
(5, 'uploads/desert2.jpg');

-- Insert sample users
INSERT INTO users (name, email, password_hash, phone_number, is_verified) VALUES
('John Doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567890', TRUE),
('Jane Smith', 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1987654321', TRUE),
('Bob Wilson', 'bob@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1122334455', TRUE);

-- Insert sample reservations
INSERT INTO reservations (property_id, user_id, check_in, check_out, status, total_price) VALUES
(1, 1, '2024-01-15', '2024-01-20', 'confirmed', 1499.95),
(2, 2, '2024-02-01', '2024-02-05', 'confirmed', 599.96),
(3, 3, '2024-01-10', '2024-01-12', 'completed', 399.98),
(4, 1, '2024-03-01', '2024-03-05', 'pending', 719.96),
(5, 2, '2024-02-15', '2024-02-18', 'confirmed', 479.97);

-- Insert sample payments
INSERT INTO payments (reservation_id, user_id, property_id, amount, payment_method, transaction_id, status) VALUES
(1, 1, 1, 1499.95, 'paypal', 'PAY-1234567890', 'completed'),
(2, 2, 2, 599.96, 'paystack', 'PSK-1234567890', 'completed'),
(3, 3, 3, 399.98, 'crypto', 'CRY-1234567890', 'completed'),
(4, 1, 4, 719.96, 'paypal', 'PAY-0987654321', 'pending'),
(5, 2, 5, 479.97, 'paystack', 'PSK-0987654321', 'completed');

-- Create indexes for better performance
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_property_status ON properties(status);
CREATE INDEX idx_reservation_dates ON reservations(check_in, check_out);
CREATE INDEX idx_payment_status ON payments(status);
CREATE INDEX idx_admin_email ON admins(email);

-- Create views for common queries
CREATE VIEW vw_available_properties AS
SELECT p.*, COUNT(pi.id) as image_count
FROM properties p
LEFT JOIN property_images pi ON p.id = pi.property_id
WHERE p.status = 'available'
GROUP BY p.id;

CREATE VIEW vw_reservation_details AS
SELECT r.*, 
       p.title as property_title,
       p.price as property_price,
       u.name as user_name,
       u.email as user_email
FROM reservations r
JOIN properties p ON r.property_id = p.id
JOIN users u ON r.user_id = u.id;

CREATE VIEW vw_payment_details AS
SELECT py.*,
       p.title as property_title,
       u.name as user_name,
       u.email as user_email,
       r.check_in,
       r.check_out
FROM payments py
JOIN properties p ON py.property_id = p.id
JOIN users u ON py.user_id = u.id
JOIN reservations r ON py.reservation_id = r.id;


CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin','staff','viewer') DEFAULT 'staff',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE items_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    supplier VARCHAR(255),
    batch_number VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    expiry_date DATE NOT NULL,
    low_stock_threshold INT DEFAULT 10,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_item_batch ON items_inventory (item_id, batch_number);


CREATE TABLE low_stock (
    low_stock_id INT AUTO_INCREMENT PRIMARY KEY,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL,
    threshold INT NOT NULL,
    status VARCHAR(50) DEFAULT 'Low Batch',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inventory_id) REFERENCES items_inventory(id)
);


CREATE TABLE expiring_soon (
    expiring_id INT AUTO_INCREMENT PRIMARY KEY,
    inventory_id INT NOT NULL,
    expiry_date DATE NOT NULL,
    days_left INT NOT NULL,
    status VARCHAR(50) DEFAULT 'Expiring Soon',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inventory_id) REFERENCES items_inventory(id)
);


CREATE TABLE activity_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action ENUM('create','update','delete') NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id INT NOT NULL,
    description TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE expired_items (
    expired_id INT AUTO_INCREMENT PRIMARY KEY,
    inventory_id INT NOT NULL,
    expiry_date DATE NOT NULL,
    days_left INT NOT NULL,
    status VARCHAR(50) DEFAULT 'Expired',

    CONSTRAINT fk_expired_inventory
        FOREIGN KEY (inventory_id) REFERENCES items_inventory(id)
        ON DELETE CASCADE
);


ALTER TABLE low_stock 
ADD UNIQUE KEY unique_inventory (inventory_id);

ALTER TABLE expiring_soon 
ADD UNIQUE KEY unique_inventory (inventory_id);

ALTER TABLE expired_items
ADD UNIQUE KEY unique_inventory (inventory_id);

ALTER TABLE activity_logs
ADD CONSTRAINT fk_activity_logs
FOREIGN KEY (item_id) REFERENCES items_inventory(id)
ON DELETE CASCADE;

ALTER TABLE inventory
DROP FOREIGN KEY fk_inventory_product,
ADD CONSTRAINT fk_inventory_product
FOREIGN KEY (product_id) REFERENCES products(id)
ON DELETE CASCADE;



SELECT 
    CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'your_table_name'
  AND CONSTRAINT_TYPE = 'FOREIGN KEY';



DELIMITER $$

CREATE TRIGGER trg_low_stock_update
AFTER UPDATE ON items_inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity <= NEW.low_stock_threshold THEN
        
        INSERT INTO low_stock (inventory_id, quantity, threshold, status)
        VALUES (NEW.id, NEW.quantity, NEW.low_stock_threshold, 'Low Batch')
        ON DUPLICATE KEY UPDATE
            quantity = NEW.quantity,
            threshold = NEW.low_stock_threshold,
            status = 'Low Batch';

    ELSE
        DELETE FROM low_stock WHERE inventory_id = NEW.id;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_low_stock_insert
AFTER INSERT ON items_inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity <= NEW.low_stock_threshold THEN
        
        INSERT INTO low_stock (inventory_id, quantity, threshold, status)
        VALUES (NEW.id, NEW.quantity, NEW.low_stock_threshold, 'Low Batch')
        ON DUPLICATE KEY UPDATE
            quantity = NEW.quantity,
            threshold = NEW.low_stock_threshold,
            status = 'Low Batch';

    END IF;
END$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER trg_expiring_soon_insert
AFTER INSERT ON items_inventory
FOR EACH ROW
BEGIN
    DECLARE days_left INT;

    SET days_left = DATEDIFF(NEW.expiry_date, CURDATE());

    IF days_left BETWEEN 1 AND 60 THEN
        INSERT INTO expiring_soon (inventory_id, expiry_date, days_left, status)
        VALUES (NEW.id, NEW.expiry_date, days_left, 'Expiring Soon')
        ON DUPLICATE KEY UPDATE
            expiry_date = NEW.expiry_date,
            days_left = days_left,
            status = 'Expiring Soon';
    ELSE
        DELETE FROM expiring_soon WHERE inventory_id = NEW.id;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

DELIMITER $$

CREATE TRIGGER trg_expiring_soon_update
AFTER UPDATE ON items_inventory
FOR EACH ROW
BEGIN
    DECLARE days_left INT;

    SET days_left = DATEDIFF(NEW.expiry_date, CURDATE());

    IF days_left BETWEEN 1 AND 60 THEN
        INSERT INTO expiring_soon (inventory_id, expiry_date, days_left, status)
        VALUES (NEW.id, NEW.expiry_date, days_left, 'Expiring Soon')
        ON DUPLICATE KEY UPDATE
            expiry_date = NEW.expiry_date,
            days_left = days_left,
            status = 'Expiring Soon';
    ELSE
        DELETE FROM expiring_soon WHERE inventory_id = NEW.id;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_expired_items_before_insert
BEFORE INSERT ON items_inventory
FOR EACH ROW
BEGIN
    DECLARE days_left INT;

    SET days_left = DATEDIFF(NEW.expiry_date, CURDATE());

    IF days_left < 0 THEN
        INSERT INTO expired_items (inventory_id, expiry_date, days_left, status)
        VALUES (NEW.id, NEW.expiry_date, days_left, 'Expired')
        ON DUPLICATE KEY UPDATE
            expiry_date = NEW.expiry_date,
            days_left = days_left,
            status = 'Expired';
    ELSE
        DELETE FROM expired_items WHERE inventory_id = NEW.id;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_expired_items_before_update
BEFORE UPDATE ON items_inventory
FOR EACH ROW
BEGIN
    DECLARE days_left INT;

    SET days_left = DATEDIFF(NEW.expiry_date, CURDATE());

    IF days_left < 0 THEN
        INSERT INTO expired_items (inventory_id, expiry_date, days_left, status)
        VALUES (NEW.id, NEW.expiry_date, days_left, 'Expired')
        ON DUPLICATE KEY UPDATE
            expiry_date = NEW.expiry_date,
            days_left = days_left,
            status = 'Expired';
    ELSE
        DELETE FROM expired_items WHERE inventory_id = NEW.id;
    END IF;
END$$

DELIMITER ;

CREATE TRIGGER after_item_insert
AFTER INSERT ON items_inventory
FOR EACH ROW
INSERT INTO activity_logs (action, item_id,name)
VALUES (
  'insert',
  NEW.id,
  NEW.name
);

DELETE FROM items_inventory
WHERE expiry_date < CURDATE();


INSERT INTO items_inventory 
(item_id, name, category, supplier, batch_number, quantity, expiry_date, low_stock_threshold)
VALUES
(1, 'Paracetamol 500mg', 'Medicine', 'MedLife Pharma', 'PCM-2025-01', 200, '2025-12-01', 50),
(1, 'Paracetamol 500mg', 'Medicine', 'MedLife Pharma', 'PCM-2024-11', 40, '2024-11-20', 50),

(2, 'Ibuprofen 200mg', 'Medicine', 'HealWell Labs', 'IBU-2025-03', 150, '2025-03-15', 40),
(2, 'Ibuprofen 200mg', 'Medicine', 'HealWell Labs', 'IBU-2024-09', 30, '2024-09-10', 40),

(3, 'Amoxicillin 250mg', 'Antibiotic', 'BioCare Pharma', 'AMX-2025-02', 120, '2025-02-28', 30),

(4, 'Vitamin C 500mg', 'Supplement', 'NutriCare', 'VTC-2024-08', 25, '2024-08-15', 20),
(4, 'Vitamin C 500mg', 'Supplement', 'NutriCare', 'VTC-2025-01', 180, '2025-01-10', 20),

(5, 'Surgical Gloves (Medium)', 'Consumable', 'SafeHands Ltd', 'GLV-M-2026-01', 500, '2026-01-01', 100),

(6, 'Syringe 5ml', 'Consumable', 'HealthEquip Co.', 'SYR-2028-01', 300, '2028-01-01', 100),

(7, 'Alcohol Swabs', 'Consumable', 'CleanMed Supplies', 'ALC-2026-04', 800, '2026-04-01', 200),

(8, 'Insulin Pen', 'Medical Device', 'PharmaTech', 'INS-2025-06', 60, '2025-06-30', 20),

(9, 'Face Masks (N95)', 'Consumable', 'AirSafe Industries', 'N95-2027-02', 1000, '2027-02-01', 300),

(10, 'Hand Sanitizer 500ml', 'Hygiene', 'PureClean', 'SAN-2025-09', 250, '2025-09-15', 50),

(11, 'Cough Syrup 100ml', 'Medicine', 'MedLife Pharma', 'COF-2024-12', 45, '2024-12-01', 30),

(12, 'Antacid Tablets', 'Medicine', 'DigestWell', 'ANT-2025-04', 180, '2025-04-20', 40),

(13, 'Zinc Tablets 50mg', 'Supplement', 'NutriCare', 'ZNC-2025-10', 90, '2025-10-01', 20),

(14, 'Surgical Tape', 'Consumable', 'SafeHands Ltd', 'TAP-2027-03', 400, '2027-03-01', 100),

(15, 'Gauze Pads', 'Consumable', 'HealthEquip Co.', 'GAU-2026-07', 600, '2026-07-01', 150),

(16, 'Antiseptic Solution 250ml', 'Hygiene', 'PureClean', 'ANT-2025-11', 140, '2025-11-10', 30);


UPDATE items_inventory
SET quantity = 5
WHERE id = 1;


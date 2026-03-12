-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 12, 2026 at 02:43 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `medi`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity log`
--

CREATE TABLE `activity log` (
  `User` int(11) NOT NULL,
  `Category` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `Category ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expiry_alert`
--

CREATE TABLE `expiry_alert` (
  `request_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `requested_by` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` enum('Pending','Approved','Rejected','Issued') DEFAULT 'Pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expiry_alert`
--

INSERT INTO `expiry_alert` (`request_id`, `item_id`, `requested_by`, `quantity`, `status`, `request_date`) VALUES
(1, 1, 5, 20, 'Pending', '2024-11-20 07:50:00'),
(2, 2, 6, 10, 'Approved', '2024-11-20 09:15:00'),
(3, 7, 7, 15, 'Rejected', '2024-11-21 10:05:00'),
(4, 9, 8, 5, 'Pending', '2024-11-21 13:40:00'),
(5, 5, 5, 8, 'Approved', '2024-11-22 08:10:00');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `dispense_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `dispensed_by` int(11) NOT NULL,
  `dispensed_to` varchar(100) DEFAULT NULL,
  `dispense_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`dispense_id`, `item_id`, `quantity`, `dispensed_by`, `dispensed_to`, `dispense_date`) VALUES
(1, 1, 10, 4, '5', '2024-11-20 09:45:00'),
(2, 2, 5, 4, '6', '2024-11-20 10:10:00'),
(3, 3, 2, 4, '7', '2024-11-21 11:30:00'),
(4, 5, 3, 4, '8', '2024-11-21 14:05:00'),
(5, 7, 8, 4, '5', '2024-11-22 08:55:00');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `PRICE` varchar(100) DEFAULT NULL,
  `Quantity` varchar(100) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`item_id`, `item_name`, `category`, `description`, `PRICE`, `Quantity`, `expiry_date`) VALUES
(1, 'Paracetamol 500mg', 'Medicine', 'Batch B001 - HealthPlus Pharma', '5.99', '120', '2026-05-12'),
(2, 'Ibuprofen 400mg', 'Medicine', 'Batch B002 - MediCore Labs', '6.40', '75', '2025-09-18'),
(3, 'Amoxicillin 250mg', 'Medicine', 'Batch B003 - Wellness Pharma', '12.50', '8', '2025-04-20'),
(4, 'Metformin 500mg', 'Medicine', 'Batch B004 - GlucoMed', '10.25', '0', '2025-03-18'),
(5, 'Cough Syrup DX', 'Medicine', 'Batch B005 - CarePlus', '7.75', '25', '2025-11-10'),
(6, 'Insulin Injection', 'Medicine', 'Batch B006 - LifeCare Biotech', '45.00', '15', '2025-07-15'),
(7, 'Aspirin 300mg', 'Medicine', 'Batch B007 - PharmaPlus', '4.99', '90', '2026-08-12'),
(8, 'Azithromycin 500mg', 'Medicine', 'Batch B008 - MediCore Labs', '18.50', '12', '2025-06-01'),
(9, 'Omeprazole 20mg', 'Medicine', 'Batch B009 - PharmaPlus', '15.00', '48', '2026-07-07'),
(10, 'Lisinopril 10mg', 'Medicine', 'Batch B010 - HealthPlus Pharma', '11.40', '17', '2026-02-02');

-- --------------------------------------------------------

--
-- Table structure for table `low_stock_alert`
--

CREATE TABLE `low_stock_alert` (
  `Low stock alert` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `received_by` int(11) NOT NULL,
  `received_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `low_stock_alert`
--

INSERT INTO `low_stock_alert` (`Low stock alert`, `item_id`, `quantity`, `received_by`, `received_date`) VALUES
(1, 1, 50, 2, '2024-11-19 15:20:00'),
(2, 3, 20, 2, '2024-11-19 15:45:00'),
(3, 7, 40, 2, '2024-11-20 09:00:00'),
(4, 9, 30, 2, '2024-11-20 09:30:00'),
(5, 10, 10, 2, '2024-11-21 11:10:00');

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `stock_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`stock_id`, `item_id`, `quantity`, `last_updated`) VALUES
(1, 1, 120, '2024-11-20 08:00:00'),
(2, 2, 75, '2024-11-20 08:00:00'),
(3, 3, 8, '2024-11-20 08:00:00'),
(4, 4, 0, '2024-11-20 08:00:00'),
(5, 5, 25, '2024-11-20 08:00:00'),
(6, 6, 15, '2024-11-20 08:00:00'),
(7, 7, 90, '2024-11-20 08:00:00'),
(8, 8, 12, '2024-11-20 08:00:00'),
(9, 9, 48, '2024-11-20 08:00:00'),
(10, 10, 17, '2024-11-20 08:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `Role ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_request`
--

CREATE TABLE `stock_request` (
  `stock_out_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `issued_to` int(11) NOT NULL,
  `issued_by` int(11) NOT NULL,
  `issued_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_request`
--

INSERT INTO `stock_request` (`stock_out_id`, `item_id`, `quantity`, `issued_to`, `issued_by`, `issued_date`) VALUES
(1, 1, 10, 5, 4, '2024-11-20 09:50:00'),
(2, 2, 5, 6, 4, '2024-11-20 10:15:00'),
(3, 3, 2, 7, 4, '2024-11-21 11:35:00'),
(4, 5, 3, 8, 4, '2024-11-21 14:10:00'),
(5, 7, 8, 5, 4, '2024-11-22 09:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(25) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'Alice Morgan', 'alice.morgan@example.com', 'hash_9f2ab1', 'Administrator', '2024-11-12 09:15:22'),
(2, 'Brian Osei', 'brian.osei@example.com', 'hash_7cd3e8', 'Inventory Officer', '2024-11-13 10:44:11'),
(3, 'Cynthia Ward', 'cynthia.ward@example.com', 'hash_4be9f2', 'Ward Manager', '2024-11-14 08:22:55'),
(4, 'Daniel Kibet', 'daniel.kibet@example.com', 'hash_8ac4d1', 'Pharmacy Staff', '2024-11-15 14:05:37'),
(5, 'Emily Stone', 'emily.stone@example.com', 'hash_6db2f7', 'Ward staff 1', '2024-11-16 16:19:03'),
(6, 'Felix Kamau', 'felix.kamau@example.com', 'hash_3af9c4', 'Ward staff 2', '2024-11-17 11:33:48'),
(7, 'Grace Ndlovu', 'grace.ndlovu@example.com', 'hash_5ce7a2', 'Ward staff 3', '2024-11-18 12:27:19'),
(8, 'Henry Patel', 'henry.patel@example.com', 'hash_2bd8e1', 'Ward staff 4', '2024-11-19 09:51:44');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `expiry_alert`
--
ALTER TABLE `expiry_alert`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `fk_wardreq_item` (`item_id`),
  ADD KEY `fk_wardreq_user` (`requested_by`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`dispense_id`),
  ADD KEY `fk_dispense_item` (`item_id`),
  ADD KEY `fk_dispense_user` (`dispensed_by`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `low_stock_alert`
--
ALTER TABLE `low_stock_alert`
  ADD PRIMARY KEY (`Low stock alert`),
  ADD KEY `fk_stockin_item` (`item_id`),
  ADD KEY `fk_stockin_user` (`received_by`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`stock_id`),
  ADD KEY `fk_stock_item` (`item_id`);

--
-- Indexes for table `stock_request`
--
ALTER TABLE `stock_request`
  ADD PRIMARY KEY (`stock_out_id`),
  ADD KEY `fk_stockout_item` (`item_id`),
  ADD KEY `fk_stockout_issued_to` (`issued_to`),
  ADD KEY `fk_stockout_issued_by` (`issued_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `expiry_alert`
--
ALTER TABLE `expiry_alert`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `dispense_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `low_stock_alert`
--
ALTER TABLE `low_stock_alert`
  MODIFY `Low stock alert` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `stock_request`
--
ALTER TABLE `stock_request`
  MODIFY `stock_out_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `expiry_alert`
--
ALTER TABLE `expiry_alert`
  ADD CONSTRAINT `fk_wardreq_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_wardreq_user` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `fk_dispense_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dispense_user` FOREIGN KEY (`dispensed_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `low_stock_alert`
--
ALTER TABLE `low_stock_alert`
  ADD CONSTRAINT `fk_stockin_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stockin_user` FOREIGN KEY (`received_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `fk_stock_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stock_request`
--
ALTER TABLE `stock_request`
  ADD CONSTRAINT `fk_stockout_issued_by` FOREIGN KEY (`issued_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stockout_issued_to` FOREIGN KEY (`issued_to`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stockout_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

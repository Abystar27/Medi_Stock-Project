CREATE TABLE `activity log` (
  `User` int(11) NOT NULL,
  `Category` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `categories` (
  `Category ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `expiry_alert` (
  `request_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `requested_by` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` enum('Pending','Approved','Rejected','Issued') DEFAULT 'Pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `inventory` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `batch_no` varchar(100) DEFAULT NULL,
  `supplier` varchar(200) DEFAULT NULL,
  `PRICE` varchar(100) DEFAULT NULL,
  `Quantity` varchar(100) DEFAULT NULL,
  `expiry_date` DATE DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `low_stock_alert` (
  `Low stock alert` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `received_by` int(11) NOT NULL,
  `received_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `report` (
  `stock_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `roles` (
  `Role ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stock_request` (
  `stock_out_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `issued_to` int(11) NOT NULL,
  `issued_by` int(11) NOT NULL,
  `issued_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(25) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `expiry_alert`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `fk_wardreq_item` (`item_id`),
  ADD KEY `fk_wardreq_user` (`requested_by`);

-- ALTER TABLE `inventory`
--   ADD PRIMARY KEY (`dispense_id`),
--   ADD KEY `fk_dispense_item` (`item_id`),
--   ADD KEY `fk_dispense_user` (`dispensed_by`);

--
-- Indexes for table `items`
--
ALTER TABLE `inventory`
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
-- ALTER TABLE `inventory`
--   MODIFY `dispense_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `inventory`
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
-- --
-- ALTER TABLE `inventory`
--   ADD CONSTRAINT `fk_dispense_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
--   ADD CONSTRAINT `fk_dispense_user` FOREIGN KEY (`dispensed_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

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

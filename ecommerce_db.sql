-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 12, 2025 at 07:57 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `address` varchar(255) NOT NULL,
  `total_amount` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `order_date`, `address`, `total_amount`) VALUES
(36, 2, '2025-02-10 08:26:45', 'S56, Pimpri-Chinchwad, India', 400),
(37, 3, '2025-02-10 08:30:09', 'S56, Pimpri-Chinchwad, India', 100),
(38, 3, '2025-02-10 08:37:52', 'S56, Pimpri-Chinchwad, India', 150),
(39, 3, '2025-02-10 10:03:08', 'S56, Pimpri-Chinchwad, India', 100),
(40, 3, '2025-02-10 10:34:11', 'S56, Pimpri-Chinchwad, India', 400),
(46, 3, '2025-02-11 01:47:05', '123 Main Street', 350),
(47, 3, '2025-02-11 02:33:40', 'S56, Pimpri-Chinchwad, India', 250),
(48, 3, '2025-02-11 05:31:06', '1600 Amphitheatre Pkwy, Mountain View, United States', 300),
(49, 3, '2025-02-11 05:52:16', 'Failed to get address.', 650),
(50, 3, '2025-02-11 06:37:28', 'S56, Pimpri-Chinchwad, India', 200),
(51, 3, '2025-02-11 08:05:35', 'S56, Pimpri-Chinchwad, India', 100),
(52, 3, '2025-02-11 10:36:06', 'S56, Pimpri-Chinchwad, India', 450),
(53, 3, '2025-02-11 10:37:40', 'S56, Pimpri-Chinchwad, India', 100),
(54, 3, '2025-02-11 10:53:55', 'S56, Pimpri-Chinchwad, India', 300),
(55, 3, '2025-02-12 01:32:24', '1600 Amphitheatre Pkwy, Mountain View, United States', 100),
(56, 3, '2025-02-12 02:09:14', '1600 Amphitheatre Pkwy, Mountain View, United States', 200),
(57, 3, '2025-02-12 02:18:21', 'HR9X+QXJ, Pune, India', 150),
(58, 7, '2025-02-12 06:46:28', '1600 Amphitheatre Pkwy, Mountain View, United States', 200),
(59, 7, '2025-02-12 06:52:39', '1600 Amphitheatre Pkwy, Mountain View, United States', 600);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 36, 4, 2, 150),
(2, 36, 3, 1, 100),
(3, 37, 3, 1, 100),
(4, 38, 4, 1, 150),
(5, 39, 3, 1, 100),
(6, 40, 3, 4, 100),
(7, 46, 3, 2, 100),
(8, 46, 4, 1, 150),
(9, 47, 4, 1, 150),
(10, 47, 3, 1, 100),
(11, 48, 3, 3, 100),
(12, 49, 4, 3, 150),
(13, 49, 3, 2, 100),
(14, 50, 3, 2, 100),
(15, 51, 3, 1, 100),
(16, 52, 4, 3, 150),
(17, 53, 3, 1, 100),
(18, 54, 4, 2, 150),
(19, 55, 3, 1, 100),
(20, 56, 3, 2, 100),
(21, 57, 4, 1, 150),
(22, 58, 3, 2, 100),
(23, 59, 3, 3, 100),
(24, 59, 4, 2, 150);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `image`, `stock`) VALUES
(3, 'Dress', 100.00, 'https://i.postimg.cc/GpsBYs5b/Dress.jpg', 80),
(4, 'Sandal', 150.00, 'https://i.postimg.cc/4dHNjkgZ/Sandal.jpg', 87);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`) VALUES
(1, 'Vaishnavi', 'vaish@example.com', '123'),
(2, 'nik', 'nik33@gmail.com', '$2y$10$qpUMlkzSweTcGPFkd07L0e2pt.YKWStoYnCe1ntMRn3cW8h1woSb.'),
(3, 'omm', 'omm33@gmail.com', '$2y$10$92lTMJCxbTSC5d1FCsfTpuB2aJ.jWUnRQgxIR.qehLzFwagAb7b5m'),
(4, 'Sonali', 'sonali123@gmail.com', '$2y$10$qfBAK5lqaHldI6KbENuz0uHFZsvV2xebEWV.xsIxagnSpMdmJXjNG'),
(5, 'rahul', 'rahul55@gmail.com', '$2y$10$tGKYuca..ImiM7nCvPeEdO5w6u9ZH9KDogMdIX1Vxx0k04imzqOJi'),
(6, 'geeta', 'getta23@gmail.com', '$2y$10$6MkEqSOAqzUatmMU0mwwP.PV2ZtoYXQvFndIaxExEa21F.P3eAg3W'),
(7, 'Abhay', 'abhay33@gmail.com', '$2y$10$lBiZuwz1GrbuX23KzMxBx.0jnudlwzCG92X06bCTMlkWmShQHI0Ju');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

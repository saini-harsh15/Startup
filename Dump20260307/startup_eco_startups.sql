-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: startup_eco
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `startups`
--

DROP TABLE IF EXISTS `startups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `startups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `equity_offered` double DEFAULT NULL,
  `founding_date` datetime(6) DEFAULT NULL,
  `funding_ask` double DEFAULT NULL,
  `government_id` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `registration_number` varchar(255) DEFAULT NULL,
  `public_key` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_startup_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `startups`
--

LOCK TABLES `startups` WRITE;
/*!40000 ALTER TABLE `startups` DISABLE KEYS */;
INSERT INTO `startups` VALUES (1,'This is good','startup001@gmail.com',11.9,'2003-03-11 18:30:00.000000',101000,'GOV-ID-12345','Gaming','Startup 1','$2a$10$yQ/j9wir5KS8EDXIql4tROxEYOYnAUU5CeLb22Ad2XDikdLZEAbNu','4567',NULL),(2,'Test','startup002@gmail.com',3.8,'2023-12-11 18:30:00.000000',53000,'123456','SaaS','Pharma Swift','$2a$10$sFcVH4U5wFliYBxWCIVSheUQ48t10uLUZj1c1q1Vmv.fls5IOCMhe','1234',NULL),(3,'This is a good Startup','harshsaini2462@gmail.com',13,'2003-12-11 18:30:00.000000',50000,'GOV-ID-12345','Finance','Startup 2','$2a$10$1fP/QsR7N3kdb2nCtXfIZu5mC9VczdF9wo8pCe.cPjGRlrBpcMj96','TECH-001',NULL);
/*!40000 ALTER TABLE `startups` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-07  9:48:48

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
-- Table structure for table `investment_requests`
--

DROP TABLE IF EXISTS `investment_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investment_requests` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expected_roi` double DEFAULT NULL,
  `funding_stage` varchar(255) NOT NULL,
  `horizon` int DEFAULT NULL,
  `message` varchar(2000) DEFAULT NULL,
  `investor_id` bigint NOT NULL,
  `startup_id` bigint NOT NULL,
  `status` enum('ACCEPTED','PENDING','REJECTED') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKp487k813lt50yw3931okn57w6` (`investor_id`),
  KEY `FKh2o4ldv7veojgkl2mb4yuqo8y` (`startup_id`),
  CONSTRAINT `FKh2o4ldv7veojgkl2mb4yuqo8y` FOREIGN KEY (`startup_id`) REFERENCES `startups` (`id`),
  CONSTRAINT `FKp487k813lt50yw3931okn57w6` FOREIGN KEY (`investor_id`) REFERENCES `investors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investment_requests`
--

LOCK TABLES `investment_requests` WRITE;
/*!40000 ALTER TABLE `investment_requests` DISABLE KEYS */;
INSERT INTO `investment_requests` VALUES (1,16000,'2026-02-22 14:23:01.421749',9,'Pre-Series A',12,'Test',2,1,'ACCEPTED'),(2,18000,'2026-02-22 15:13:58.037566',11,'Series A',9,'Test',2,1,'ACCEPTED'),(3,24000,'2026-02-22 17:05:17.397666',13,'Series A',8,'Harsh Saini',2,1,'ACCEPTED'),(4,10000,'2026-02-22 17:05:53.370708',8,'Seed',11,'Test',2,1,'ACCEPTED'),(5,100000,'2026-02-22 17:57:58.040833',12,'Growth',7,'Test',2,1,'ACCEPTED'),(6,23000,'2026-02-23 12:57:00.326853',16,'Growth',13,'Test\r\n',2,1,'ACCEPTED'),(7,100000,'2026-02-23 13:06:39.544613',1,'Pre-Series A',10,'Testing ',4,1,'ACCEPTED'),(8,100000,'2026-02-23 14:50:12.597022',11,'Seed',13,'Test',4,1,'ACCEPTED'),(9,15000,'2026-02-23 15:12:36.945701',11,'Pre-Series A',17,'Test',4,1,'REJECTED'),(10,23000,'2026-02-24 13:23:25.699402',14,'Series A',12,'I am intrested',2,1,'ACCEPTED'),(11,500000,'2026-03-03 07:19:29.589976',12,'Series A',10,'I am Genuine',2,1,'ACCEPTED'),(12,17000,'2026-03-03 14:25:40.119251',9,'Pre-Series A',6,'This is good',2,1,'ACCEPTED');
/*!40000 ALTER TABLE `investment_requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-07  9:48:47

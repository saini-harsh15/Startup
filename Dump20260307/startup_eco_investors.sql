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
-- Table structure for table `investors`
--

DROP TABLE IF EXISTS `investors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bio` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `investment_firm` varchar(255) DEFAULT NULL,
  `investment_preferences` varchar(255) DEFAULT NULL,
  `investor_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `funding_stages` varchar(255) DEFAULT NULL,
  `investment_range_usd` varchar(255) DEFAULT NULL,
  `investor_type` varchar(255) DEFAULT NULL,
  `linkedin` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `notable_investments` varchar(255) DEFAULT NULL,
  `preferred_domains` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `public_key` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_investor_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investors`
--

LOCK TABLES `investors` WRITE;
/*!40000 ALTER TABLE `investors` DISABLE KEYS */;
INSERT INTO `investors` VALUES (2,'I am a genuine investor with intrests in AI and EdTEch companies.','investor001@gmail.com','Venture Capital Partners','AI','Investor 1 ','$2a$10$HeFtH6P2F6eBoVU75vBWEuUrfyXB7/LDMki.0QovhcL8SUTYjGbr2',NULL,NULL,'Private Equity',NULL,NULL,NULL,NULL,NULL,NULL),(4,'I am a genuine investor','investor002@gmail.com','Doritech Consultancy','AI','Investor 2','$2a$10$PzUZ0HZq7DZ3HY1csyU.fOMPukkavR6GFgZVitPBk0xyBukMyk34q','Seed','1000000-5000000','Private Equity','https://www.linkedin.com/in/harsh-saini-42a690263/','USA',NULL,'EdTech','https://mergersandinquisitions.com/venture-capital-partner/',NULL);
/*!40000 ALTER TABLE `investors` ENABLE KEYS */;
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

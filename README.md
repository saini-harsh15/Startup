# StartupEcosystem – AI-Powered Startup–Investor Matchmaking Platform

## Overview

StartupEcosystem is a full-stack web application designed to connect startups with potential investors through an AI-driven matchmaking system. The platform enables startups and investors to create profiles, interact securely, and discover relevant opportunities based on shared interests, funding stages, and business domains.

This project was developed as a Final Year Project using Java, Spring Boot, Spring Security, MySQL, and RESTful APIs.

---

## Features

### Authentication & Authorization

* Role-based authentication for:

  * Startups
  * Investors
* Secure login and signup flow
* Password encryption using Spring Security
* Protected API endpoints with authorization rules

### Startup Features

* Create and manage startup profiles
* Add startup details and funding information
* View matched investors
* Messaging and networking support

### Investor Features

* Create investor profiles
* Explore startups based on interests and domains
* View matchmaking recommendations
* Connect with startups

### Backend Features

* RESTful API architecture
* Pagination using Spring Data JPA (`Pageable`)
* Structured exception handling
* Clean layered architecture:

  * Controller Layer
  * Service Layer
  * Repository Layer
* MySQL relational database design

---

## Tech Stack

### Backend

* Java
* Spring Boot
* Spring Security
* Spring Data JPA
* Hibernate
* REST APIs

### Database

* MySQL

### Tools & Technologies

* Git & GitHub
* Postman
* Maven
* Docker (Learning & Integration)

---

## Project Architecture

```text
Client Request
      ↓
DispatcherServlet
      ↓
Controller Layer
      ↓
Service Layer
      ↓
Repository Layer
      ↓
MySQL Database
```

---

## Database Design

The project uses a relational database schema designed for:

* User Management
* Role Management
* Startup Profiles
* Investor Profiles
* Matchmaking Records
* Messaging Functionality

Relationships were implemented using JPA entity mappings.

---

## API Modules

### Authentication APIs

* User Registration
* User Login
* Role-based Access

### Startup APIs

* Create Startup Profile
* Update Startup Details
* Fetch Startup Data

### Investor APIs

* Create Investor Profile
* Browse Startups
* Fetch Investor Details

### Matchmaking APIs

* Match Startups with Investors
* Recommendation Handling

---

## Security Implementation

* Spring Security-based authentication and authorization
* Password hashing using BCrypt
* Protected endpoints using role-based access control
* Secure request handling

---

## Learning Outcomes

Through this project, I gained hands-on experience with:

* Backend development using Spring Boot
* REST API design principles
* Authentication & authorization
* Database schema design
* Pagination and performance optimization
* Exception handling and debugging
* MVC architecture in Spring Boot
* Real-time messaging using WebSockets
* Team collaboration and project development workflow

---

## Future Improvements

* JWT-based authentication
* AI-powered recommendation engine integration
* Cloud deployment (AWS/Railway/Render)
* Dockerized deployment
* Admin dashboard and analytics

---

## Installation & Setup

### Clone Repository

```bash
git clone <your-repository-url>
```

### Navigate to Project

```bash
cd StartupEcosystem
```

### Configure Database

Update the `application.properties` file:

```properties
spring.datasource.url=YOUR_DATABASE_URL
spring.datasource.username=YOUR_USERNAME
spring.datasource.password=YOUR_PASSWORD
```

### Run the Application

```bash
mvn spring-boot:run
```

---

## Author

### Harsh Saini

Java Backend Developer

* GitHub: [https://github.com/saini-harsh15](https://github.com/saini-harsh15)
* LinkedIn: [https://www.linkedin.com/in/harshsaini15/](https://www.linkedin.com/in/harshsaini15/)

---

## Status

Project under active development.

# ---- Stage 1: Build ----
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -q
COPY src ./src
RUN mvn clean package -DskipTests -q

# ---- Stage 2: Run ----
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.war app.war
EXPOSE 10000
ENTRYPOINT ["java", \
  "-Dspring.profiles.active=prod", \
  "-Dserver.address=0.0.0.0", \
  "-Dserver.port=10000", \
  "-jar", "app.war"]
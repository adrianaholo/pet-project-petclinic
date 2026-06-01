FROM maven:3.9.12-eclipse-temurin-17 AS build
WORKDIR /app

# копіюємо тільки pom спочатку (для кешу залежностей)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# копіюємо весь код
COPY src ./src

# збираємо jar
RUN mvn clean package -DskipTests

# ===== Runtime stage =====
FROM eclipse-temurin:17-jdk

WORKDIR /app

# копіюємо зібраний jar з build stage
COPY --from=build /app/target/*.jar app.jar

# порт Spring Boot
EXPOSE 8080

# JVM оптимізації для контейнера
ENV JAVA_OPTS=""

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]


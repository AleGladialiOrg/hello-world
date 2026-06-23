# ETAPA 1: Construcción (Build)
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src

# Se compila el JAR ignorando las pruebas para acelerar (deben ser testeado localmente para ahorrar minutos de instancias)
RUN mvn clean package -DskipTests

# ETAPA 2: Ejecución (Runtime - Imagen mínima)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Solo se copia el JAR compilado desde la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Configuración de memoria para el contenedor
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75.0 -XX:+UseContainerSupport"

# Ejecución
ENTRYPOINT ["java", "-jar", "app.jar"]

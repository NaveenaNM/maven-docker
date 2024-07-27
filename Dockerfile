# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Maven wrapper and pom.xml
COPY .mvn/ .mvn
COPY mvnw mvnw
COPY mvnw.cmd mvnw.cmd
COPY pom.xml pom.xml

# Copy the rest of the application code
COPY src/ src/

# Make the mvnw script executable
RUN chmod +x mvnw

# Package the application using the Maven wrapper
RUN ./mvnw package

# Run the jar file
CMD ["java", "-jar", "target/my-java-app-1.0-SNAPSHOT.jar"]


# Use the official Maven image with Java 11 as the base image
FROM maven:3.8.1-openjdk-11 as builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml file to the working directory
COPY pom.xml .

# Download project dependencies
RUN mvn dependency:go-offline

# Copy the source code to the working directory
COPY src/ /app/src/

# Build the project
RUN mvn package

# Start a new stage for the final image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file and dependencies from the builder stage
COPY --from=builder /app/target/hello-java-1.0-SNAPSHOT.jar /app/

# Expose the port the application will run on
EXPOSE 8080

# Set the entrypoint to run the application
ENTRYPOINT ["java", "-jar", "/app/hello-java-1.0-SNAPSHOT.jar"]

#Version: v1
#Stage-1
FROM ubuntu AS builder

WORKDIR /spring_app

COPY . .

EXPOSE 9090

RUN apt-get update && apt-get install -y openjdk-17-jdk maven

RUN mvn clean package

#Stage-2
FROM openjdk:17-jdk-alpine

WORKDIR /spring_app

COPY --from=builder /spring_app/target/*.jar spring_app.jar

CMD ["java", "-jar", "spring_app.jar"]

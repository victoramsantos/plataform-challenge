FROM openjdk:8-jre-slim

RUN mkdir runner
WORKDIR /runner

COPY ./app/build/libs/app.jar /runner/app.jar

EXPOSE 8080
CMD ["java", "-jar", "/runner/app.jar"]
FROM openjdk:8-jdk-alpine
RUN addgroup -S testgroup && adduser -S testuser -G testgroup
RUN mkdir logs
RUN touch logs/fbittest.log
RUN touch logs/file.log
RUN chmod 777 logs logs/fbittest.log logs/file.log
USER testuser:testgroup
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

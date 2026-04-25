# Étape 1 : Construction avec Maven
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package

# Étape 2 : Déploiement sur Tomcat
FROM tomcat:10.0-jdk11
WORKDIR /usr/local/tomcat/webapps/
COPY --from=build /app/target/*.war ./ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]

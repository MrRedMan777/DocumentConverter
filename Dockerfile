<<<<<<< HEAD
"# Etape 1 : Construction avec Maven"
"FROM maven:3.8.4-openjdk-11 AS build"
"WORKDIR /app"
"COPY pom.xml ."
"RUN mvn dependency:go-offline"
"COPY src ./src"
"RUN mvn clean package"
""
"# Etape 2 : Deployment sur Tomcat"
"FROM tomcat:10.0-jdk11"
"WORKDIR /usr/local/tomcat/webapps/"
"COPY --from=build /app/target/*.war ./ROOT.war"
"EXPOSE 8080"
"CMD [\"catalina.sh\", \"run\"]"
=======
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["sh","-c","java -jar app.jar"]
>>>>>>> 3f4404ef3a845e0ac5c04333deae8505429c8d82

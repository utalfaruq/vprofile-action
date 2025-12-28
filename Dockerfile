#FROM openjdk:11 AS BUILD_IMAGE
#RUN apt update && apt install maven -y
#COPY ./ vprofile-project
#RUN cd vprofile-project &&  mvn install 

#FROM tomcat:9-jre11
#LABEL "Project"="Vprofile"
#LABEL "Author"="Imran"
#RUN rm -rf /usr/local/tomcat/webapps/*
#COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

#EXPOSE 8080
#CMD ["catalina.sh", "run"]


# =========================
# Stage 1: Build the app
# =========================
FROM eclipse-temurin:11-jdk AS build

RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests


# =========================
# Stage 2: Run the app
# =========================
FROM tomcat:9.0-jre11-temurin

LABEL Project="Vprofile"
LABEL Author="Imran"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
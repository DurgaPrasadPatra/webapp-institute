
FROM tomcat:9-jdk17-temurin

# Remove Tomcat's default web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR produced by Maven into Tomcat
# This assumes the build produces exactly one WAR file
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat listens on port 8080 inside the container
EXPOSE 8080

# Start Tomcat in the foreground
CMD ["catalina.sh", "run"]

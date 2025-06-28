FROM jenkins/jenkins:2.504.2-jdk17

USER root

# Install Amazon Corretto 21
ENV JAVA_HOME=/opt/amazon-corretto-21
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN curl -L -o corretto21.tar.gz https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz \
    && mkdir -p /opt/amazon-corretto-21 \
    && tar -xzf corretto21.tar.gz -C /opt/amazon-corretto-21 --strip-components=1 \
    && rm corretto21.tar.gz

# Copy plugin list and install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt --latest

# Disable setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Add Groovy script to configure security and admin user
COPY init.groovy.d/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy

USER jenkins

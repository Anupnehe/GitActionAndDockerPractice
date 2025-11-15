FROM maven:3.9.6-eclipse-temurin-17

WORKDIR /app

# Copy code and build artifacts
COPY pom.xml .
COPY src ./src

# Optional: pre-build dependencies
RUN mvn clean install -DskipTests=true

# Install Chrome + ChromeDriver
RUN apt-get update && apt-get install -y wget unzip xvfb gnupg && rm -rf /var/lib/apt/lists/*
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

RUN DRIVER_VERSION=$(wget -qO- https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE) && \
    wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver

# Set environment for headless Chrome
ENV DISPLAY=:99
ENV JAVA_TOOL_OPTIONS="-Dwebdriver.chrome.driver=/usr/local/bin/chromedriver"

# Run tests
CMD ["mvn", "test", "-Dsurefire.suiteXmlFiles=testng.xml"]

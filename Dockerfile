# ---------------------------
# Stage 1: Build Maven project
# ---------------------------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy Maven files
COPY pom.xml .
COPY src ./src

# Build project and skip tests (tests will run later in runtime)
RUN mvn clean install -DskipTests=true

# ---------------------------
# Stage 2: Runtime (Run tests)
# ---------------------------
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    gnupg \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

# Install matching ChromeDriver
RUN DRIVER_VERSION=$(wget -qO- https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE) && \
    wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver

# Copy Maven build artifacts from builder stage
COPY --from=builder /app /app

# Set environment for headless Chrome
ENV DISPLAY=:99
ENV JAVA_TOOL_OPTIONS="-Dwebdriver.chrome.driver=/usr/local/bin/chromedriver"

# Default command to run TestNG tests via Maven
CMD ["mvn", "test", "-Dsurefire.suiteXmlFiles=testng.xml"]

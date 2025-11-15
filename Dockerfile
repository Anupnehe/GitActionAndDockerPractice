# ===========================
#  STAGE 1: Build with Maven
# ===========================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Download dependencies + run tests
RUN mvn clean install -DskipTests=true


# =================================
#  STAGE 2: Runtime with Selenium
# ===============================
FROM eclipse-temurin:17-jdk

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    gnupg \
    --no-install-recommends

# Add Google Chrome repo
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# Install Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Download matching ChromeDriver
RUN DRIVER_VERSION=$(wget -qO- https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE) && \
    wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver

# Set working directory
WORKDIR /app

# Copy built project from builder stage
COPY --from=builder /app/target ./target

# Default command to run TestNG tests
CMD ["java", "-cp", "target/test-classes:target/classes:target/dependency/*", "org.testng.TestNG", "testng.xml"]

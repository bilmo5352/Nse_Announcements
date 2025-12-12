# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for Chrome and Selenium
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Slim down Chrome for containers
RUN google-chrome-stable --version
ENV CHROME_BIN=/usr/bin/google-chrome-stable
ENV DISPLAY=:99

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies (includes webdriver-manager for matching ChromeDriver)
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .
COPY start.sh .

# Make startup script executable
RUN chmod +x start.sh

# Expose port (Railway typically uses 8080)
EXPOSE 8080

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py

# Run the application with Gunicorn using startup script
CMD ["./start.sh"]


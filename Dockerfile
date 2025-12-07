# Use a slim Python base image
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Install system deps needed by reportlab & fonts
RUN apt-get update && apt-get install -y \
    build-essential \
    libfreetype6-dev \
    libffi-dev \
    libjpeg62-turbo-dev \
    liblcms2-dev \
    libopenjp2-7-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for better build caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Streamlit configuration: allow external access
ENV STREAMLIT_SERVER_PORT=8501 \
    STREAMLIT_SERVER_ADDRESS=0.0.0.0 \
    STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

# Expose the Streamlit port
EXPOSE 8501

# Default command: run Streamlit app
CMD ["streamlit", "run", "streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]

# Use a lightweight and secure base image to reduce attack surface
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY app.py requirements.txt /app/

# Install dependencies securely without keeping cache
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 80
EXPOSE 80

# Run the application
CMD ["python", "app.py"]
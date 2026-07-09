

# ------------ Stage 1: Builder ------------

FROM python:3.12-slim AS builder


# Create application directory
WORKDIR /app

#COPY dependency file
COPY requirements.txt .

#Install dependencies into a separate directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ------------ Stage 2: Runtime -------------

FROM python:3.12-slim


# Create a non-root user
RUN useradd -m appuser

#SET working directory
WORKDIR /app

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY . .

# Change ownership of application files
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Application port
EXPOSE 5000

# Start Flask application
CMD ["python", "app.py"]


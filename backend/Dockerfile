FROM python:3.11-slim

WORKDIR /app

ENV PYTHONTONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Security Best Practice: Run as a non-root user
RUN useradd -u 1001 appuser && chown -R appuser /app
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
# Builder Stage
FROM python:3.11-slim AS builder
WORKDIR /app

# Install requirements 
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 2) Runtime Stage
FROM python:3.11-slim AS runtime
WORKDIR /app

# Using non-root user
ARG UID=10001
RUN adduser --disabled-password --gecos "" \
    --home "/nonexistent" --shell "/sbin/nologin" \
    --no-create-home --uid "${UID}" appuser

# Copy **only** what we need from the builder:
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/gunicorn

# App code
COPY --chown=appuser:appuser . .

USER appuser
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.main:app"]

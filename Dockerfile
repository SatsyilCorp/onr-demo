# ==============================================================================
# Enterprise Hardened Multi-Stage Dockerfile
# Baseline: DoD Impact Level 5 (IL5) / FedRAMP High
# Non-root execution (USER 10001:10001) with minimal attack surface
# ==============================================================================

# Stage 1: Build & Dependency Isolation
FROM python:3.11-slim AS builder

WORKDIR /build

# Install build dependencies securely
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml .
RUN pip install --no-cache-dir --upgrade pip build && \
    pip install --no-cache-dir .

# Stage 2: Hardened Runtime Container
FROM python:3.11-slim AS runtime

# Create dedicated non-root service account
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /sbin/nologin -d /app appuser

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application source code
COPY src/ /app/src/
COPY pyproject.toml /app/

# Set strict permissions and ownership
RUN chown -R appuser:appgroup /app && \
    chmod -R 750 /app

# Switch to non-root user
USER 10001:10001

EXPOSE 8000

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8000

# Health check probe for container orchestrator
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/healthz')" || exit 1

ENTRYPOINT ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]

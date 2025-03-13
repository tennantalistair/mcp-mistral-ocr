# Build stage
FROM python:3.11-slim AS builder

# Install UV
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml .
COPY src/ src/

# Create venv and install dependencies
RUN uv venv
RUN uv pip install --no-cache-dir .

# Final stage
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy virtual environment and source files
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src /app/src

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH="/app/src"

# Create directory for OCR files
RUN mkdir -p /data/ocr

# Set default OCR_DIR
ENV OCR_DIR=/data/ocr

# Run the MCP server
CMD ["python", "-m", "mcp_mistral_ocr.main"]

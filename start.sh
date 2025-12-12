#!/bin/sh
# Startup script for Railway deployment
# Railway sets PORT environment variable automatically
# Reduce workers/threads for memory; increase timeout for slow scrapes
PORT=${PORT:-8080}
exec gunicorn app:app --workers 1 --threads 2 --bind 0.0.0.0:$PORT --timeout 120


#!/bin/bash
set -e

echo ">>> Applying migrations (with retry)..."
for i in 1 2 3 4 5; do
  python manage.py migrate --noinput && break
  echo ">>> Migrate failed, retry $i/5 in 5s..."
  sleep 5
done

echo ">>> Seeding reference data..."
python manage.py seed_reference_data || true

echo ">>> Bootstrapping admin..."
python manage.py bootstrap_admin || true

echo ">>> Collecting static files..."
python manage.py collectstatic --noinput

echo ">>> Starting Gunicorn..."
exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3 --timeout 90

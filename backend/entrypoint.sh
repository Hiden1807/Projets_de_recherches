#!/bin/bash
set -e

echo ">>> Applying migrations..."
python manage.py migrate --noinput

echo ">>> Seeding reference data..."
python manage.py seed_reference_data || true

echo ">>> Bootstrapping admin..."
python manage.py bootstrap_admin || true

echo ">>> Collecting static files..."
python manage.py collectstatic --noinput

echo ">>> Starting Gunicorn..."
exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3 --timeout 90

#!/usr/bin/env python
"""
Script to wait for database connection before starting Django.
"""
import os
import sys
import time
import psycopg2
from psycopg2 import OperationalError

def wait_for_db():
    """Wait for database to be available."""
    # Debug: Print environment variables
    print(f"POSTGRES_HOST: {os.getenv('POSTGRES_HOST', 'NOT_SET')}")
    print(f"POSTGRES_PORT: {os.getenv('POSTGRES_PORT', 'NOT_SET')}")
    print(f"POSTGRES_USER: {os.getenv('POSTGRES_USER', 'NOT_SET')}")
    print(f"POSTGRES_DB: {os.getenv('POSTGRES_DB', 'NOT_SET')}")
    
    # Try to get database URL from Railway
    database_url = os.getenv('DATABASE_URL')
    if database_url:
        print(f"Using DATABASE_URL: {database_url[:20]}...")
        try:
            conn = psycopg2.connect(database_url)
            conn.close()
            print("Database is ready!")
            return True
        except Exception as e:
            print(f"Database URL connection failed: {e}")
    
    # Fallback to individual environment variables
    db_config = {
        'host': os.getenv('POSTGRES_HOST', 'localhost'),
        'port': os.getenv('POSTGRES_PORT', '5432'),
        'user': os.getenv('POSTGRES_USER', 'postgres'),
        'password': os.getenv('POSTGRES_PASSWORD', ''),
        'dbname': os.getenv('POSTGRES_DB', 'railway')
    }
    
    print("Waiting for database connection...")
    max_attempts = 30
    attempt = 0
    
    while attempt < max_attempts:
        try:
            conn = psycopg2.connect(**db_config)
            conn.close()
            print("Database is ready!")
            return True
        except OperationalError as e:
            attempt += 1
            print(f"Database unavailable, waiting... (attempt {attempt}/{max_attempts})")
            print(f"Error: {e}")
            time.sleep(2)
    
    print("Database connection failed after maximum attempts")
    return False

if __name__ == "__main__":
    if not wait_for_db():
        sys.exit(1)

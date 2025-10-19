#!/usr/bin/env python
"""
Script to wait for database connection before starting Django.
"""
import os
import sys
import time

def wait_for_db():
    """Wait for database to be available."""
    print("Skipping database wait - Railway will handle database connection")
    print("Proceeding with application startup...")
    return True

if __name__ == "__main__":
    if not wait_for_db():
        sys.exit(1)

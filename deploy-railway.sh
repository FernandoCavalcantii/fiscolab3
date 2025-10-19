#!/bin/bash

# Railway Deploy Script for Fiscolab3
# This script helps you deploy the application to Railway

echo "🚀 Starting Railway deployment process..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI is not installed. Please install it first:"
    echo "   npm install -g @railway/cli"
    echo "   or visit: https://docs.railway.app/develop/cli"
    exit 1
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please login to Railway first:"
    echo "   railway login"
    exit 1
fi

echo "✅ Railway CLI is ready"

# Create new Railway project (if not exists)
echo "📦 Creating Railway project..."
railway login
railway init

# Add PostgreSQL service
echo "🗄️ Adding PostgreSQL database..."
railway add postgresql

# Set environment variables
echo "🔧 Setting environment variables..."
railway variables set DJANGO_SETTINGS_MODULE=config.settings_production
railway variables set DJANGO_DEBUG=False
railway variables set DJANGO_SECRET_KEY=$(openssl rand -base64 32)

# Deploy the application
echo "🚀 Deploying to Railway..."
railway up

echo "✅ Deployment completed!"
echo "🌐 Your application should be available at the Railway URL"
echo "📊 Check the Railway dashboard for logs and monitoring"

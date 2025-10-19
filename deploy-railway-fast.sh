#!/bin/bash

# Fast Railway Deploy Script for Fiscolab3
# This script uses optimized build to avoid timeouts

echo "🚀 Starting FAST Railway deployment process..."

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

# Set environment variables for fast build
echo "🔧 Setting environment variables..."
railway variables set DJANGO_SETTINGS_MODULE=config.settings_production
railway variables set DJANGO_DEBUG=False
railway variables set DJANGO_SECRET_KEY=$(openssl rand -base64 32)

# Set build timeout to maximum
railway variables set RAILWAY_BUILD_TIMEOUT=1800

# Deploy the application with optimized build
echo "🚀 Deploying to Railway with optimized build..."
echo "⏱️  This build uses minimal dependencies to avoid timeout"
echo "📦 Heavy ML dependencies will be installed at runtime"

railway up

echo "✅ Deployment completed!"
echo "🌐 Your application should be available at the Railway URL"
echo "📊 Check the Railway dashboard for logs and monitoring"
echo "⚠️  Note: First startup may take longer due to ML dependency installation"

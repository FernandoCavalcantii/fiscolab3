#!/bin/bash

# Railway Deploy Script for Fiscolab3
echo "🚀 Starting Railway deployment process..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Please install it:"
    echo "   npm install -g @railway/cli"
    exit 1
fi

echo "✅ Railway CLI is ready"

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please login to Railway first:"
    echo "   railway login"
    exit 1
fi

echo "✅ Logged in to Railway"

# Link to project if not already linked
if ! railway status &> /dev/null; then
    echo "📦 Linking to Railway project..."
    railway link
fi

echo "✅ Project linked"

# Set environment variables
echo "🔧 Setting environment variables..."

# Set Django settings
railway variables set DJANGO_SETTINGS_MODULE=config.settings_production
railway variables set DJANGO_DEBUG=False

# Generate and set secret key if not exists
if ! railway variables | grep -q "DJANGO_SECRET_KEY"; then
    SECRET_KEY=$(openssl rand -base64 32)
    railway variables set DJANGO_SECRET_KEY="$SECRET_KEY"
    echo "✅ DJANGO_SECRET_KEY set"
else
    echo "✅ DJANGO_SECRET_KEY already exists"
fi

# Set other required variables
railway variables set ALLOWED_HOSTS="*"
railway variables set CORS_ALLOW_ALL_ORIGINS=True

echo "✅ Environment variables configured"

# Deploy the application
echo "🚀 Deploying to Railway..."
echo "⏱️  This may take a few minutes..."

railway up

echo "✅ Deployment completed!"
echo "🌐 Your application should be available at the Railway URL"
echo "📊 Check the Railway dashboard for logs and monitoring"
echo ""
echo "🔍 To check deployment status:"
echo "   railway logs"
echo "   railway status"
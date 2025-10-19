#!/bin/bash

# Development Docker Script for Fiscolab3
echo "🚀 Starting development environment with Docker Compose..."

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null && ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Use docker compose (newer) or docker-compose (older)
if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    echo "❌ Neither 'docker compose' nor 'docker-compose' is available."
    exit 1
fi

echo "✅ Using: $COMPOSE_CMD"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ Created .env file from .env.example"
        echo "📝 Please edit .env file with your configuration"
    else
        echo "❌ No .env.example file found. Please create .env file manually."
        exit 1
    fi
fi

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  up       - Start all services"
    echo "  down     - Stop all services"
    echo "  build    - Build all services"
    echo "  logs     - Show logs"
    echo "  frontend - Start only frontend"
    echo "  backend  - Start only backend and database"
    echo "  clean    - Clean up containers and volumes"
    echo "  help     - Show this help"
}

# Parse command
case "${1:-up}" in
    "up")
        echo "🚀 Starting all services..."
        $COMPOSE_CMD up -d
        echo "✅ Services started!"
        echo "🌐 Frontend: http://localhost:3000"
        echo "🌐 Backend: http://localhost:8000"
        echo "📊 Database: localhost:5432"
        ;;
    "down")
        echo "🛑 Stopping all services..."
        $COMPOSE_CMD down
        echo "✅ Services stopped!"
        ;;
    "build")
        echo "🔨 Building all services..."
        $COMPOSE_CMD build
        echo "✅ Build completed!"
        ;;
    "logs")
        echo "📋 Showing logs..."
        $COMPOSE_CMD logs -f
        ;;
    "frontend")
        echo "🚀 Starting frontend only..."
        $COMPOSE_CMD up -d postgres django
        echo "⏳ Waiting for backend to be ready..."
        sleep 10
        $COMPOSE_CMD up frontend
        ;;
    "backend")
        echo "🚀 Starting backend and database..."
        $COMPOSE_CMD up -d postgres django
        echo "✅ Backend services started!"
        echo "🌐 Backend: http://localhost:8000"
        echo "📊 Database: localhost:5432"
        ;;
    "clean")
        echo "🧹 Cleaning up..."
        $COMPOSE_CMD down -v --remove-orphans
        docker system prune -f
        echo "✅ Cleanup completed!"
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        show_help
        exit 1
        ;;
esac

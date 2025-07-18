#!/bin/bash

# Initialize Jeffrey environment for a service
# This script replaces the Kubernetes init container functionality

SERVICE_NAME=$1

if [ -z "$SERVICE_NAME" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

echo "Initializing Jeffrey environment for service: $SERVICE_NAME"

# Create the service directory
SERVICE_DIR="/tmp/jeffrey/$SERVICE_NAME"
mkdir -p "$SERVICE_DIR"

# Create the .env file with Jeffrey-specific environment variables
cat > "$SERVICE_DIR/.env" << EOF
# Jeffrey Environment Configuration for $SERVICE_NAME
# This file is created by init-jeffrey-env.sh

# Set the Jeffrey profile directory
export JEFFREY_PROFILE_DIR="/tmp/jeffrey/$SERVICE_NAME"

# Ensure the profile directory exists
mkdir -p "\$JEFFREY_PROFILE_DIR"

# Service-specific configuration
export SERVICE_NAME="$SERVICE_NAME"
export JAVA_OPTS="\$JAVA_OPTS -Djeffrey.profile.dir=\$JEFFREY_PROFILE_DIR"

echo "Jeffrey environment initialized for $SERVICE_NAME"
echo "Profile directory: \$JEFFREY_PROFILE_DIR"
EOF

# Make the .env file readable
chmod 644 "$SERVICE_DIR/.env"

# Create additional directories that might be needed
mkdir -p "/tmp/jeffrey/$SERVICE_NAME/profiles"
mkdir -p "/tmp/jeffrey/$SERVICE_NAME/recordings"

# Create the main Jeffrey directories if they don't exist
mkdir -p "/tmp/jeffrey/.jeffrey"
mkdir -p "/tmp/jeffrey/.jeffrey/recordings"

echo "Jeffrey environment setup completed for $SERVICE_NAME"
echo "Created directories:"
echo "  - $SERVICE_DIR"
echo "  - $SERVICE_DIR/profiles"
echo "  - $SERVICE_DIR/recordings"
echo "  - /tmp/jeffrey/.jeffrey"
echo "  - /tmp/jeffrey/.jeffrey/recordings"

# List the contents for verification
echo "Environment file contents:"
cat "$SERVICE_DIR/.env"

exit 0
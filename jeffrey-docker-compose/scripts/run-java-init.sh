#!/bin/bash

# Wrapper script to run InitContainerScript.java directly
# This script replaces the bash-only init-jeffrey-env.sh with the Java-based initialization

SERVICE_NAME=$1

if [ -z "$SERVICE_NAME" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

echo "Initializing Jeffrey environment for service: $SERVICE_NAME using Java init script"

# Create the service directory structure
SERVICE_DIR="/tmp/jeffrey/$SERVICE_NAME"
mkdir -p "$SERVICE_DIR"

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "Java is not available in the container. Falling back to bash script."
    exec /init-jeffrey-env.sh "$SERVICE_NAME"
fi

echo "Running InitContainerScript.java directly..."

# Run the Java source file directly (Java 11+ feature)
cd /scripts
java InitContainerScript.java "$SERVICE_DIR"

if [ $? -eq 0 ]; then
    echo "Java init script completed successfully for $SERVICE_NAME"
else
    echo "Java init script failed. Falling back to bash script."
    exec /init-jeffrey-env.sh "$SERVICE_NAME"
fi

echo "Jeffrey environment setup completed for $SERVICE_NAME"

# List the contents for verification
echo "Service directory structure:"
find "$SERVICE_DIR" -type f -name "*.env" -exec echo "Environment file: {}" \; -exec cat {} \;

exit 0
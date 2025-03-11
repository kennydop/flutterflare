#!/bin/bash

# Define the environment (default to dev if not specified)
ENVIRONMENT=${1:-dev}

echo "Running build script for $ENVIRONMENT environment..."

# Run the build script
./build.sh $ENVIRONMENT

# Shift to remove the environment parameter, leaving any additional args
shift
ADDITIONAL_ARGS="$@"

# Launch the app with the specified environment
echo "Starting Flutter app in $ENVIRONMENT environment..."

if [ "$ENVIRONMENT" = "dev" ]; then
  flutter run --flavor dev $ADDITIONAL_ARGS
elif [ "$ENVIRONMENT" = "staging" ]; then
  flutter run --flavor staging $ADDITIONAL_ARGS
elif [ "$ENVIRONMENT" = "prod" ]; then
  flutter run --flavor prod $ADDITIONAL_ARGS
else
  echo "Unknown environment: $ENVIRONMENT"
  exit 1
fi 
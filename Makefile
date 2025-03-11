.PHONY: run-dev run-staging run-prod clean

# Default target
all: run-dev

# Run the app in dev environment
run-dev:
	@echo "Running build script for dev environment..."
	@./build.sh dev
	@echo "Starting app in dev environment..."
	@flutter run --flavor dev

# Run the app in staging environment
run-staging:
	@echo "Running build script for staging environment..."
	@./build.sh staging
	@echo "Starting app in staging environment..."
	@flutter run --flavor staging

# Run the app in production environment
run-prod:
	@echo "Running build script for prod environment..."
	@./build.sh prod
	@echo "Starting app in production environment..."
	@flutter run --flavor prod

# Clean the project
clean:
	@echo "Cleaning project..."
	@flutter clean
	@rm -rf build/
	@rm -rf .dart_tool/
	@echo "Project cleaned" 
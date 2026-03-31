#!/usr/bin/env bash

# Initialization script for the project
# This script creates the initial directory structure and sets up the environment

set -euo pipefail

echo "Initializing project structure..."

mkdir -p data/raw
mkdir -p data/processed
mkdir -p scripts
mkdir -p results
mkdir -p logs
mkdir -p config
mkdir -p envs

echo "Project structure created successfully"

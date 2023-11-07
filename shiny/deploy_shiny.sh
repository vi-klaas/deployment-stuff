#!/bin/bash

# Usage
# ./deploy_shiny.sh app_name git_repo_name [test|prod]

APP_NAME="$1"
GIT_REPO="$2"
DEPLOY_TYPE="$3"

if [ "$DEPLOY_TYPE" == "prod" ]; then
    APP_DIR="/srv/shiny/apps"
    GIT_BRANCH="main"
elif [ "$DEPLOY_TYPE" == "test" ]; then
    APP_DIR="/srv/shiny/apps-test"
    GIT_BRANCH="develop" # or any other branch you use for testing
else
    echo "Error: Deployment type must be either 'test' or 'prod'."
    exit 1
fi

# Check if the application directory exists, if not, clone the repo
if [ ! -d "$APP_DIR/$APP_NAME" ]; then
    git clone "$GIT_REPO" "$APP_DIR/$APP_NAME"
else
    # If the directory exists, pull the latest changes
    cd "$APP_DIR/$APP_NAME" || exit
    git pull origin "$GIT_BRANCH"
fi

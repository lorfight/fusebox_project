#!/bin/bash

# ENTRYPOINT ["/bin/bash", "./run.sh", "echo $ENVIRONMENT", "echo $TEST_IDS", "echo $MAX_EXECUTION_TIME", "echo $AZURE_TAG_NAME", "echo $BUILD_URL", "echo $TESTING_TYPE", "echo $AZ_DEVOPS_CONNECTOR_URL", "echo $AZ_DEVOPS_CONNECTOR_TOKEN"]

conda init bash
echo "conda activate fusebox" >> ~/.bashrc

# Get the environment variables from args
ENVIRONMENT=$(env | grep ENVIRONMENT | cut -d "=" -f 2)
TEST_IDS=$(env | grep TEST_IDS | cut -d "=" -f 2)
MAX_EXECUTION_TIME=$(env | grep MAX_EXECUTION_TIME | cut -d "=" -f 2)
AZURE_TAG_NAME=$(env | grep AZURE_TAG_NAME | cut -d "=" -f 2)
BUILD_URL=$(env | grep BUILD_URL | cut -d "=" -f 2)
TESTING_TYPE=$(env | grep TESTING_TYPE | cut -d "=" -f 2)
TESTING_ROLE=$(env | grep TESTING_ROLE | cut -d "=" -f 2)
TEST_EXECUTION_TYPE=$(env | grep TEST_EXECUTION_TYPE | cut -d "=" -f 2)
AZ_DEVOPS_CONNECTOR_URL=$(env | grep AZ_DEVOPS_CONNECTOR_URL | cut -d "=" -f 2)
AZ_DEVOPS_CONNECTOR_TOKEN=$(env | grep AZ_DEVOPS_CONNECTOR_TOKEN | cut -d "=" -f 2)

# Print the environment variables
echo "ENVIRONMENT: $ENVIRONMENT"
echo "TEST_IDS: $TEST_IDS"
echo "MAX_EXECUTION_TIME: $MAX_EXECUTION_TIME"
echo "AZURE_TAG_NAME: $AZURE_TAG_NAME"
echo "BUILD_URL: $BUILD_URL"
echo "TESTING_TYPE: $TESTING_TYPE"
echo "TESTING_ROLE: $TESTING_ROLE"
echo "TEST_EXECUTION_TYPE: $TEST_EXECUTION_TYPE"
echo "AZ_DEVOPS_CONNECTOR_URL: $AZ_DEVOPS_CONNECTOR_URL"

if [ -z "$AZ_DEVOPS_CONNECTOR_TOKEN" ]; then
    echo "AZ_DEVOPS_CONNECTOR_TOKEN is empty or not set. Please set the AZ_DEVOPS_CONNECTOR_TOKEN environment variable."
    exit 1
fi

# Run the tests
echo "python runner.py -e "$ENVIRONMENT" --test-ids "$TEST_IDS" --max-execution-time "$MAX_EXECUTION_TIME" --azure-tag-name "$AZURE_TAG_NAME" --execution-url "$BUILD_URL" --testing-type "$TESTING_TYPE" --test-execution-type "$TEST_EXECUTION_TYPE" --azure-devops-connector-url "$AZ_DEVOPS_CONNECTOR_URL""
python runner.py -e "$ENVIRONMENT" --test-ids "$TEST_IDS" --max-execution-time "$MAX_EXECUTION_TIME" --azure-tag-name "$AZURE_TAG_NAME" --execution-url "$BUILD_URL" --testing-type "$TESTING_TYPE" --testing-role "$TESTING_ROLE" --test-execution-type "$TEST_EXECUTION_TYPE" --azure-devops-connector-url "$AZ_DEVOPS_CONNECTOR_URL" --azure-devops-connector-token "$AZ_DEVOPS_CONNECTOR_TOKEN"
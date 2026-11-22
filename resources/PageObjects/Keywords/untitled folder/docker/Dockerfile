FROM docker.io/library/fusebox-automation-testing-base:latest

USER root

# Define the environment variables
ENV ENVIRONMENT="dev"
ENV TEST_IDS="*"
ENV MAX_EXECUTION_TIME=120
ENV AZURE_TAG_NAME="latest"
ENV BUILD_URL=""
ENV TESTING_TYPE=""
ENV TESTING_ROLE=""
ENV TEST_EXECUTION_TYPE=""
ENV AZ_DEVOPS_CONNECTOR_URL=""
ENV AZ_DEVOPS_CONNECTOR_TOKEN=""

COPY . /app

WORKDIR /app

SHELL ["/bin/bash", "--login", "-c"]

RUN conda init bash \
    && echo "conda activate fusebox" >> ~/.bashrc \
    && chmod +x run.sh  \
    && printenv

ENTRYPOINT ["/bin/bash", "-c", "./run.sh"]
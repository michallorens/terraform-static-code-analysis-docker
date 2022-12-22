FROM python:3.9 as installation

ENV TFLINT_VERSION=v0.43.0
ENV TFSEC_VERSION=v1.28.1

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

FROM python:3.9-slim

RUN useradd --create-home --shell /bin/bash user && \
    apt-get update && \
    apt-get install --yes git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=installation /usr/local/bin/tfsec /usr/local/bin/tfsec
COPY --from=installation /usr/local/bin/tflint /usr/local/bin/tflint

WORKDIR /home/user
USER user

COPY requirements.txt .
RUN pip install --no-cache --requirement requirements.txt

HEALTHCHECK NONE

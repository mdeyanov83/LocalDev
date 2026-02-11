# Use Microsoft base devcontainer image
ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu
FROM ${BASE_IMAGE}
LABEL maintainer="Martin Deyanov <your.email@example.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:/opt/venv/bin:$PATH"

# Switch to root (if necessary, not necessary with Microsoft base:ubuntu image - root by default)
# USER root

# Install system packages and clean up in single layer
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    # Core utilities
    curl wget git unzip zip gnupg2 software-properties-common \
    lsb-release sudo ca-certificates iputils-ping \
    # Java 17
    openjdk-17-jdk \
    # Python ecosystem
    python3 python3-pip python3-venv \
    # C/C++ Build tools
    build-essential gdb cmake valgrind clang \
    # SQLite Database
    sqlite3 libsqlite3-dev \
    # Additional useful tools
    htop tree nano jq socat xz-utils bash-completion \
    # Cleanup in same layer
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Docker CLI
RUN install -d /etc/apt/keyrings -m 0755 \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y docker-ce-cli \
    && groupadd -f docker \
    && usermod -aG docker vscode \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y gh \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Node.js and TypeScript, clean up in same layer
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g typescript ts-node @types/node nodemon http-server\
    && rm -rf /var/lib/apt/lists/* \
    && npm cache clean --force \
    && apt-get clean

# Create virtual environment and set proper ownership
# Setting ownership on an empty venv avoids heavy recursive I/O after packages installation
RUN python3 -m venv /opt/venv \
   && chown -R vscode:vscode /opt/venv

# Switch to vscode user before installing packages
USER vscode

# Install Python packages
RUN /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
    && /opt/venv/bin/pip install --no-cache-dir \
	# Data Science stack
        numpy pandas scipy matplotlib scikit-learn \
	# Jupyter ecosystem
        jupyter ipython notebook jupyterlab\
	# Web frameworks (system-wide venv)
        requests beautifulsoup4 \
    # Web frameworks (more suitable for project specific venv)
        flask django fastapi uvicorn websockets httpx \
	# Development Tools
        black pylint mypy pytest pytest-cov \
	# Utilities (system-wide venv)
        tqdm pip-tools pillow \
    # Utilities (more suitable for project specific venv)
        python-dotenv \
    && /opt/venv/bin/pip cache purge

WORKDIR /workspaces/LocalDev

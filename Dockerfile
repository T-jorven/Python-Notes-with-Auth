# Use an official Python base image
FROM python:3.12

# Set environment variables to prevent pyenv from asking interactive questions
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies for pyenv
RUN apt-get update && apt-get install -y \
    curl \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl

# Install pyenv
RUN curl https://pyenv.run | bash

# Set up environment variables for pyenv
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

RUN pip install flask flask-sqlalchemy

# Install pyenv-virtualenv
RUN [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ] || git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv

# Initialize pyenv in shell
RUN echo 'eval "$(pyenv init --path)"' >> /root/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> /root/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc

# Install Python with pyenv
RUN pyenv install 3.12.1
RUN pyenv global 3.12.1

# Create a virtual environment
RUN pyenv virtualenv 3.12.1 flask-env

# Activate the virtual environment and install Flask
RUN /bin/bash -c "source ~/.bashrc && pyenv activate flask-env && pip install flask"

# Set the working directory inside the container
WORKDIR /app

# Copy project files into the container
COPY . /app

# Expose Flask's default port
EXPOSE 5000

# Default command to start the container
CMD ["bash"]

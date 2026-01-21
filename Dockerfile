# Use Mambaforge (includes conda + mamba + Python)
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# Create a working directory
WORKDIR /workspace

COPY requirements.txt .
pip install -r requirements.txt

# Download and extract code
RUN curl -L https://github.com/manuel-rhdt/ml-pws/archive/refs/heads/gpu.tar.gz | tar xz

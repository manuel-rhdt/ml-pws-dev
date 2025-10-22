# Use Mambaforge (includes conda + mamba + Python)
FROM condaforge/mambaforge:latest

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/opt/conda/bin:$PATH
ENV PYTHONUNBUFFERED=1

# Create a working directory
WORKDIR /workspace

# Install base packages, neovim, and Python libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget build-essential neovim ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a new environment and install Python + dependencies
RUN mamba create -y -n pyenv python=3.12

# Install Python packages inside the environment
RUN /bin/bash -c "source activate pyenv && \
    mamba install -y flax jax jaxlib lightning matplotlib numpy polars scipy pytorch torchsde tqdm && \
    pip install clu"
    
RUN useradd --create-home --shell /bin/bash reinhardt
USER reinhardt
WORKDIR /home/reinhardt

    
# Activate environment by default
SHELL ["bash", "--login", "-c"]

# Default command: open bash with the env activated
CMD ["bash", "--login"]

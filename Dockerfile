# Use Mambaforge (includes conda + mamba + Python)
FROM condaforge/mambaforge:latest

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH /opt/conda/bin:$PATH
ENV PYTHONUNBUFFERED=1

# Create a working directory
WORKDIR /workspace

# Install base packages, neovim, and Python libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget build-essential neovim ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a new environment and install Python + dependencies
RUN mamba create -y -n pyenv python=3.11 && \
    echo "conda activate pyenv" >> ~/.bashrc

# Install Python packages inside the environment
RUN /bin/bash -c "source activate pyenv && \
    mamba install -y flax jax jaxlib lightning matplotlib numpy polars scipy pytorch tqdm && \
    pip install clu"

# Neovim configuration optimized for Python
RUN mkdir -p ~/.config/nvim

# Install vim-plug (plugin manager)
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Add a minimal Python-optimized Neovim config
RUN echo 'call plug#begin("~/.vim/plugged")' >> ~/.config/nvim/init.vim && \
    echo 'Plug "neovim/nvim-lspconfig"' >> ~/.config/nvim/init.vim && \
    echo 'Plug "nvim-treesitter/nvim-treesitter", {"do": ":TSUpdate"}' >> ~/.config/nvim/init.vim && \
    echo 'Plug "psf/black", {"branch": "stable"}' >> ~/.config/nvim/init.vim && \
    echo 'call plug#end()' >> ~/.config/nvim/init.vim && \
    echo 'set number' >> ~/.config/nvim/init.vim && \
    echo 'set expandtab shiftwidth=4 tabstop=4' >> ~/.config/nvim/init.vim && \
    echo 'syntax on' >> ~/.config/nvim/init.vim && \
    echo 'filetype plugin indent on' >> ~/.config/nvim/init.vim && \
    echo 'lua << EOF' >> ~/.config/nvim/init.vim && \
    echo 'require("lspconfig").pyright.setup{}' >> ~/.config/nvim/init.vim && \
    echo 'EOF' >> ~/.config/nvim/init.vim && \
    nvim --headless +PlugInstall +qall

# Install Python LSP server (Pyright) for Neovim
RUN /bin/bash -c "source activate pyenv && pip install 'python-lsp-server[all]' pyright black isort flake8"

# Activate environment by default
SHELL ["bash", "--login", "-c"]

# Default command: open bash with the env activated
CMD ["bash", "--login"]

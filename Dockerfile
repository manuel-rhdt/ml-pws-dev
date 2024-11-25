FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

ENV PATH="/opt/conda/bin:$PATH"

COPY requirements.txt .

RUN /opt/conda/bin/conda install -y python=3.12 numpy ipython && \
    /opt/conda/bin/python -m pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu && \
    /opt/conda/bin/python -m pip install --no-cache-dir -r requirements.txt && \
    /opt/conda/bin/conda clean -ya


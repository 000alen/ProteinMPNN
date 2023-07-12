FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu18.04

RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

RUN apt-get update && apt-get install -y wget libxml2 cuda-minimal-build-11-3 libcusparse-dev-11-3 libcublas-dev-11-3 libcusolver-dev-11-3 git

# ? NOTE: This is to install mamba, which is a faster version of conda. Yet we still
# ? need to install conda to install mamba. This is a bit of a hack, but it works.
RUN wget -P /tmp \
    "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

COPY environment.yml /opt/ProteinMPNN/environment.yml

RUN conda install -c conda-forge mamba
RUN mamba env create --file /opt/ProteinMPNN/environment.yml 

COPY ca_model_weights /opt/ProteinMPNN/ca_model_weights
COPY colab_notebooks /opt/ProteinMPNN/colab_notebooks

COPY examples /opt/ProteinMPNN/examples
RUN chmod +x /opt/ProteinMPNN/examples/*

COPY helper_scripts /opt/ProteinMPNN/helper_scripts
COPY inputs /opt/ProteinMPNN/inputs
COPY outputs /opt/ProteinMPNN/outputs
COPY soluble_model_weights /opt/ProteinMPNN/soluble_model_weights
COPY training /opt/ProteinMPNN/training
COPY vanilla_model_weights /opt/ProteinMPNN/vanilla_model_weights

COPY protein_mpnn_run.py /opt/ProteinMPNN/
COPY protein_mpnn_utils.py /opt/ProteinMPNN/

# WORKDIR /opt/ProteinMPNN

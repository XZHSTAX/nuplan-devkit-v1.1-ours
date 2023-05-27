FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install -y curl gnupg2 software-properties-common default-jdk

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

COPY bazel-release.pub.gpg .
RUN apt-key add bazel-release.pub.gpg \
    && curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - \
    && curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu20.04/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list \
    && add-apt-repository "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" \
    && apt-get update \
    && apt-get install -y \
    bazel \
    file \
    zip \
    nvidia-container-toolkit \
    software-properties-common \
    awscli \
    && rm -rf /var/lib/apt/lists/*

# Download miniconda and install silently.
ENV PATH /opt/conda/bin:$PATH
# RUN curl -fsSLo Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
#     bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
#     rm Miniconda3-latest-Linux-x86_64.sh && \
#     conda clean -a -y
RUN curl -fsSLo Miniconda3-latest-Linux-x86_64.sh https://mirrors.bfsu.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm Miniconda3-latest-Linux-x86_64.sh  \
    && conda clean -a -y

# Setup working environment
ARG NUPLAN_HOME=/nuplan_devkit
WORKDIR $NUPLAN_HOME

COPY requirements.txt requirements_torch.txt requirements_submission.txt environment.yml /nuplan_devkit/
# RUN PIP_EXISTS_ACTION=w conda env create -f $NUPLAN_HOME/environment.yml
RUN conda config --add channels https://mirrors.bfsu.edu.cn/anaconda/pkgs/main/ \
    && conda config --add channels https://mirrors.bfsu.edu.cn/anaconda/cloud/conda-forge/ \
    && conda config --set show_channel_urls yes \
    && conda clean -i \
    && conda create -n nuplan python=3.9 \
    && /opt/conda/envs/nuplan/bin/pip install -r requirements.txt -i https://mirrors.bfsu.edu.cn/pypi/web/simple \
    && /opt/conda/envs/nuplan/bin/pip install -r requirements_torch.txt \
    && /opt/conda/envs/nuplan/bin/pip install -r requirements_submission.txt
RUN mkdir -p $NUPLAN_HOME/nuplan

COPY setup.py $NUPLAN_HOME
COPY nuplan $NUPLAN_HOME/nuplan
COPY my_fabulous_model.ckpt $NUPLAN_HOME
SHELL ["conda", "run", "-n", "nuplan", "/bin/bash", "-c"]

RUN bash -c "pip install -e ."

ENV NUPLAN_MAPS_ROOT=/data/sets/nuplan/maps \
    NUPLAN_DATA_ROOT=/data/sets/nuplan \
    NUPLAN_EXP_ROOT=/data/exp/nuplan

RUN bash -c 'mkdir -p {$NUPLAN_MAPS_ROOT,$NUPLAN_DATA_ROOT,$NUPLAN_EXP_ROOT}'

ARG NUPLAN_DATA_ROOT_S3_URL
ARG NUPLAN_MAPS_ROOT_S3_URL
ARG NUPLAN_SERVER_S3_ROOT_URL
ARG S3_TOKEN_DIR
ARG NUPLAN_DATA_STORE

ENV NUPLAN_DATA_ROOT $NUPLAN_DATA_ROOT
ENV NUPLAN_MAPS_ROOT $NUPLAN_MAPS_ROOT
ENV NUPLAN_DB_FILES  /data/sets/nuplan/nuplan-v1.1/mini
ENV NUPLAN_MAP_VERSION "nuplan-maps-v1.0"
ENV NUPLAN_DATA_STORE $NUPLAN_DATA_STORE
ENV NUPLAN_S3_PROFILE "default"
ENV NUPLAN_DATA_ROOT_S3_URL $NUPLAN_DATA_ROOT_S3_URL
ENV NUPLAN_MAPS_ROOT_S3_URL $NUPLAN_MAPS_ROOT_S3_URL
ENV NUPLAN_SERVER_S3_ROOT_URL $NUPLAN_SERVER_S3_ROOT_URL
ENV S3_TOKEN_DIR $S3_TOKEN_DIR

RUN bash -c 'mkdir -p $NUPLAN_DB_FILES'

CMD ["/nuplan_devkit/nuplan/entrypoint_simulation.sh"]

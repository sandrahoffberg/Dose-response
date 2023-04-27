# hash:sha256:1f50d92de93a1f4a3b5146d85f8c1afccb46e169741929abeae309650f4f95b1
FROM registry.apps.codeocean.com/codeocean/py-r:python3.10-R4.2.2-IRkernel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

ARG GIT_ASKPASS
ARG GIT_ACCESS_TOKEN
COPY git-askpass /

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
        0xAD2323F17326AE31401037733E05EBFF05441C52 \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y 'deb http://deb.codeocean.com/rstudio-server-bionic/ ubuntu main' \
    && apt-get purge -y --autoremove software-properties-common \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential=12.9ubuntu3 \
        libgit2-dev=1.1.0+dfsg.1-4.1build1 \
        libssl-dev=3.0.2-0ubuntu1.8 \
        pkg-config=0.29.2-1ubuntu3 \
    && rm -rf /var/lib/apt/lists/*

RUN conda install -y \
        jupyterlab==3.6.3 \
        numpy==1.24.2 \
        pandas==2.0.0 \
    && conda clean -ya

RUN Rscript -e 'remotes::install_version("drda")'

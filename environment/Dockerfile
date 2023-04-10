# hash:sha256:13f137b6d67444836989a27df056dd0b17e840fcc31504cb9ad93d6f4be78551
FROM registry.apps.codeocean.com/codeocean/mambaforge3:22.11.1-4-ubuntu22.04

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
        r-base=4.1.2-1ubuntu2 \
    && rm -rf /var/lib/apt/lists/*

RUN conda install -y \
        numpy==1.24.2 \
        pandas==2.0.0 \
    && conda clean -ya

RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> $(Rscript -e 'cat(R.home())')/etc/Rprofile.site \
    && echo 'options(Ncpus = parallel::detectCores())' >> $(Rscript -e 'cat(R.home())')/etc/Rprofile.site \
    && Rscript -e 'options(warn=2); install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("drda", "2.0.3")'

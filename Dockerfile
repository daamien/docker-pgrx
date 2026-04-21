FROM rust:1-slim-trixie 

# Build Arguments
ARG UID=1000
ARG GID=1000
ARG PGRX_VERSION=0.18.0

# Create the postgres user with the given uid/gid
# If you're not using Docker Desktop and your UID / GID is not 1000 then
# you'll get permission errors with volumes.
#
# You can fix that by rebuilding the image locally with:
#
# docker build --build-arg UID=`id -u` --build-arg GID=`id- g`  .
#
RUN groupadd -g "${GID}" pgrx \
 && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" pgrx

RUN apt-get update && apt-get install -y \
    bison \
    build-essential \
    flex \
    gettext-base \
    libclang-dev \
    pkg-config \
    libreadline6-dev \
    libssl-dev \
    libicu-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    libxml2-utils \
    xsltproc \
    ccache \
    hx \
    vim \
    gosu \
 && rm -rf /var/lib/apt/lists/*

USER pgrx

ENV USER=pgrx
ENV PG_VERSION=pg18 
ENV PATH="${PATH}:/usr/local/cargo/bin/:~pgrx/.cargo/bin"

RUN rustup default stable && \ 
    rustup component add clippy && \
    cargo install --locked --version ${PGRX_VERSION} cargo-pgrx && \
    cargo pgrx init --pg18=download

WORKDIR /pgrx
VOLUME /pgrx


# Switch back to root so the entrypoint can call usermod
USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

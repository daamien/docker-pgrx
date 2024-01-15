FROM rust:1                                                                                             

# Build Arguments
ARG UID=1000
ARG GID=1000
ARG PGRX_VERSION=0.11.0

# Create the postgres user with the given uid/gid
# If you're not using Docker Desktop and your UID / GID is not 1000 then
# you'll get permission errors with volumes.
#
# You can fix that by rebuilding the image locally with:
#
# docker build --build-arg UID=`id -u` --build-arg GID=`id- g`  .
#
RUN groupadd -g "${GID}" postgres \                                                                                  
 && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" postgres

# nfpm repo
RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' \
    | tee /etc/apt/sources.list.d/goreleaser.list

RUN apt-get update && apt-get install -y \
    gettext-base \
    libclang-dev \
    nfpm \
    postgresql-server-dev-all

USER postgres

# This is required by `cargo pgrx test`
ENV USER=postgres

ENV PATH="${PATH}:/usr/local/cargo/bin/:~postgres/.cargo/bin"
                                                                                                        
RUN rustup component add clippy && \
    cargo install --locked --version 0.11.0 cargo-pgrx && \                                                                       
    cargo pgrx init

WORKDIR /pgrx
VOLUME /pgrx

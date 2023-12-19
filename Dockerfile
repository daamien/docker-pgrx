FROM rust:1                                                                                             

RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' \
    | tee /etc/apt/sources.list.d/goreleaser.list

RUN apt-get update && apt-get install -y \
    gettext-base \
    libclang-dev \
    nfpm \
    postgresql-server-dev-all

RUN adduser --disabled-password postgres                                                                

USER postgres

ENV USER=postgres

ENV PATH="${PATH}:/usr/local/cargo/bin/:~postgres/.cargo/bin"
                                                                                                        
RUN rustup component add clippy && \
    cargo install --locked --version 0.11.0 cargo-pgrx && \                                                                       
    cargo pgrx init

WORKDIR /pgrx
VOLUME /pgrx


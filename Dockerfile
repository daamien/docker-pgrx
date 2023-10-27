FROM rust:1                                                                                             

RUN apt-get update && apt-get install -y \
    libclang-dev

RUN adduser --disabled-password postgres                                                                

USER postgres

ENV USER=postgres

ENV PATH="${PATH}:/usr/local/cargo/bin/:~postgres/.cargo/bin"
                                                                                                        
RUN rustup component add clippy && \
    cargo install --locked --version 0.11.0 cargo-pgrx && \                                                                       
    cargo pgrx init

WORKDIR /pgrx
VOLUME /pgrx


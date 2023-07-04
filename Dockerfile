FROM rust:1                                                                                             
                                                                                                        
RUN apt-get update && apt-get install -y \                                                              
    libclang-dev                                                                                        
                                                                                                        
RUN adduser --disabled-password postgres                                                                
                                                                                                        
USER postgres                                                                                           
                                                                                                        
ENV PATH="${PATH}:/usr/local/cargo/bin/:~postgres/.cargo/bin"                                           
                                                                                                        
RUN cargo install cargo-pgrx && \                                                                       
    cargo pgrx init

WORKDIR /pgrx
VOLUME /pgrx


FROM rust:1.61-slim-buster as builder

RUN apt-get update && \
    apt-get install -y libssl-dev pkg-config ca-certificates build-essential make perl gcc libc6-dev

RUN cargo install mdbook --no-default-features --features search --vers "^0.4" --locked
RUN cargo install mdbook-admonish 
RUN cargo install mdbook-linkcheck 
RUN cargo install mdbook-plantuml


FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y default-jre && \
    apt-get install -y graphviz && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin /usr/local/bin

ADD https://github.com/plantuml/plantuml/releases/download/v1.2022.5/plantuml-1.2022.5.jar /usr/local/plantuml/bin/plantuml.jar
ADD plantuml /usr/local/plantuml/bin/

ENV PATH=/usr/local/plantuml/bin:$PATH



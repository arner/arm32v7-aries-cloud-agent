FROM arm32v7/ubuntu:18.04 as build

ENV PYTHONUNBUFFERED 0

ARG uid=1000

RUN apt-get update \
 && apt-get install -qq \
    build-essential \
    pkg-config \
    cmake \
    libssl-dev \
    libsqlite3-dev \
    libzmq3-dev \
    libncursesw5-dev \
    python3-pip \
    curl \
    git \
    libzmq3-dev \
    libffi-dev \
    libsodium-dev

RUN useradd -m -u $uid indy
USER indy
WORKDIR /home/indy

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH /home/indy/.cargo/bin:$PATH

RUN git clone https://github.com/hyperledger/indy-sdk.git \
 && cd indy-sdk \
 && git checkout v1.11.1

RUN cd indy-sdk/libindy && cargo build --release --features sodium_static
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/home/indy/indy-sdk/libindy/target/release

RUN pip3 install --user aries-cloudagent indy-sdk

FROM arm32v7/ubuntu:18.04 as aca-image
ARG uid=1000

RUN apt-get update \
 && apt-get install -qq \
    python3

RUN useradd -m -u $uid indy
USER indy
WORKDIR /home/indy

ENV PATH /home/indy/.local/bin:$PATH

COPY --from=build /home/indy/.local /home/indy/.local
COPY --from=build /home/indy/indy-sdk/libindy/target/release /usr/local/lib

ENTRYPOINT ["aca-py"]

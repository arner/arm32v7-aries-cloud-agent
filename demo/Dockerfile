FROM agent

USER root
RUN apt-get update \
 && apt-get install -qq \
    git \
    python3-pip \
    libzmq3-dev \
    libffi-dev \
    libsodium-dev

USER indy

RUN git clone https://github.com/hyperledger/aries-cloudagent-python.git \
 && cd aries-cloudagent-python \
 && git checkout 0.3.1

WORKDIR /home/indy/aries-cloudagent-python/demo

RUN pip3 install --user -r requirements.txt
RUN pip3 install prompt_toolkit pygments python3-indy

ENTRYPOINT ["python3"]

FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt-get update;
RUN apt-get install -y gpg sudo wget curl git vim net-tools pip;
RUN apt-get install -y iproute2 curl build-essential cmake libssl-dev openssl file git pkg-config libdbus-1-dev libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev checkinstall unzip llvm wabt;
RUN apt-get install -y protobuf-compiler capnproto
RUN curl https://sh.rustup.rs -sSf > /root/rustup.sh;
RUN chmod +x /root/rustup.sh
RUN /root/rustup.sh -y;
RUN git clone --recursive https://gitlab.com/veilid/veilid.git /root/veilid;
RUN git -C /root/veilid checkout v0.4.4;
RUN source /root/.cargo/env && cd /root/veilid/veilid-server && cargo build --package veilid-server;
RUN source /root/.cargo/env && cd /root/veilid/veilid-server && cargo build --package veilid-cli;
RUN mkdir /etc/veilid-server;
RUN /root/veilid/target/debug/veilid-server --dump-config > /etc/veilid-server/veilid-server.conf;
RUN sed -i 's/detect_address_changes:.*$/detect_address_changes: true/' /etc/veilid-server/veilid-server.conf;
CMD ["/root/veilid/target/debug/veilid-server", "--config-file=/etc/veilid-server/veilid-server.conf"]

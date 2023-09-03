# Veilid Server Build Docker Image

Builds a docker image for compiling a Veilid Server from source

## Setup
- Install Docker (https://www.docker.com/)
- Clone this repository: `git clone https://github.com/archwisp/VeilidServerBuildDockerImage`
- Build the Docker image: `docker compose build --no-cache`
- Create a directory for node storage: `mkdir /tmp/veilid-sever`
- Run `veilid-server` in a container: `docker run -it -d --name veilid-sever-1 -p 127.0.0.1:5959:5959 -v /tmp/veilid-sever/server-1:/root/.local/share/veilid veilid-docker-veilid-server /root/veilid/target/debug/veilid-server`

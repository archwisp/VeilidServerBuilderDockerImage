# Veilid Server Build Docker Image
This repository builds a docker image for compiling a Veilid Server from source. Once the image is built, numerous servers can be started in their own containers from the pre-compiled binary that is built into the image. I created this as a way to test multiple Veilid server nodes from one machine.

## FOR DEVELOPMENT PURPOSES ONLY
The image built here runs `veilid-server` as root. This is meant to serve as a quick and dirty way to spin up nodes. Do not, under any circumstances, use this to run production nodes.

## Setup
- Install Docker (https://www.docker.com/)
- Clone this repository: `git clone https://github.com/archwisp/VeilidServerBuildDockerImage`
- Change into the repository directory: `cd VeilidServerBuildDockerImage`
- Build the Docker image (takes 5-6 minutes on an M1 Mac): `docker compose build --no-cache`
- Create a directory for node storage: `mkdir /tmp/veilid-sever`
- Run `veilid-server-1` in a container: `docker run -it -d --name veilid-server-1 -p 127.0.0.1:5959:5959 -v /tmp/veilid-sever/server-1:/root/.local/share/veilid veilid-docker-veilid-server`
- Run `veilid-server-2` in a container: `docker run -it -d --name veilid-server-2 -p 127.0.0.1:6060:5959 -v /tmp/veilid-sever/server-2:/root/.local/share/veilid veilid-docker-veilid-server`

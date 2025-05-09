# Veilid Server Docker 
This project builds a Docker image based on Ubuntu 24.04 that compiles `veilid-server` from source. Building the image takes about 5-6 minutes on an M1 Mac.

Once the image is built, numerous servers can be instantly started in their own containers. I created this as a way to easily test multiple Veilid Server nodes from one machine.

## FOR DEVELOPMENT PURPOSES ONLY
The image built by this respository runs `veilid-server` as root. It is meant to serve as a quick and dirty way to spin up nodes. Do not, under any circumstances, use this to run production nodes.

## Build The Image
- Install Docker (https://www.docker.com/)
- Clone this repository: `git clone https://github.com/archwisp/VeilidServerDocker`
- Change into the repository directory: `cd VeilidServerDocker`
- Build the Docker image (takes 5-6 minutes on an M1 Mac): `docker build . -t archwisp/veilid-server:v0.4.4 --no-cache`

Once the image is built, you should see it with the `docker images` command:

```
$ docker images
REPOSITORY                                     TAG       IMAGE ID       CREATED         SIZE
archwisp/veilid-server                      v0.4.4     6062b0659c12   25 minutes ago   9.11GB
```

## Run The Containers

Running the containers using the `-v` or `--volume` parameter allows the server storage to be persisted on your Docker host. If you need to delete a container for some reason, you can spin the server back up using the same stored data.

- Create a directory for persistent node 1 storage: 
    - `mkdir /tmp/veilid-sever-1`
- Create a directory for persistent node 2 storage: 
    - `mkdir /tmp/veilid-sever-2`
- Run `veilid-server-1` in a container: 
    - `docker run -it -d --name veilid-server-1 -v /tmp/veilid-sever/server-1:/root/.local/share/veilid archwisp/veilid-server:v0.4.4`
- Run `veilid-server-2` in a container: 
    - `docker run -it -d --name veilid-server-2 -v /tmp/veilid-sever/server-2:/root/.local/share/veilid archwisp/veilid-server:v0.4.4`

Once the containers have been lauched, you should see them running with the `docker ps` command:

```
$ docker ps
CONTAINER ID   IMAGE                                          COMMAND                  CREATED         STATUS         PORTS     NAMES
b4a2cc4ace0e   archwisp/veilid-server:v0.4.4                  "/root/veilid/target…"   3 seconds ago   Up 3 seconds             veilid-server-2
e9b876043d39   archwisp/veilid-server:v0.4.4                  "/root/veilid/target…"   5 minutes ago   Up 5 minutes             veilid-server-1
```

You can interact with the container through a bash shell using the `docker exec` command:

```
$ docker exec -it veilid-server-1 /bin/bash
root@e9b876043d39:/# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  4 03:36 pts/0    00:00:21 /root/veilid/target/debug/veilid-server --config-file=/etc/veilid/veilid-server.yml
root        33     0  0 03:42 pts/1    00:00:00 /bin/bash
root        45    33  0 03:43 pts/1    00:00:00 ps -ef

root@e9b876043d39:/# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:5959          0.0.0.0:*               LISTEN      1/veilid-server
tcp        0      0 0.0.0.0:5150            0.0.0.0:*               LISTEN      1/veilid-server
tcp6       0      0 :::5150                 :::*                    LISTEN      1/veilid-server
```

And you can view the server `stdout` by using the `docker logs` command:

```
$ docker logs veilid-server-1
17:01:43  INFO corectx: Veilid API starting up
17:01:43  INFO crypto: Node Id: VLD0:qMyt7A4mWoT-eWi2xqm3H92pG-n9SZsKiHNhNKxIDq0
17:01:43  INFO corectx: Veilid API startup complete
17:01:43  INFO veilid_server::server: Auto-attach to the Veilid network
17:01:43  INFO net: UDP: searching for free port starting with 5150 on [0.0.0.0, ::]
17:01:43  INFO net: WS: searching for free port starting with 5150 on [0.0.0.0, ::]
17:01:43  INFO net: TCP: searching for free port starting with 5150 on [0.0.0.0, ::]
17:01:43  INFO rtab: [PublicInternet] changed network: outbound EnumSet()->EnumSet(UDP | TCP | WS | WSS)
17:01:43  INFO rtab: [PublicInternet] changed network: inbound EnumSet()->EnumSet(UDP | TCP | WS)
17:01:43  INFO rtab: [PublicInternet] changed network: address types EnumSet()->EnumSet(IPV6 | IPV4)
17:01:43  INFO rtab: [PublicInternet] changed network: capabilities []->[ROUT, SGNL, RLAY, DIAL, DHTV, DHTW, APPM]
17:01:43  INFO rtab: [LocalNetwork] added dial info:
    Direct:udp|[fe80::20ca:28ff:fe31:ab58]:5150
    Direct:udp|10.244.0.32:5150
    Direct:tcp|[fe80::20ca:28ff:fe31:ab58]:5150
    Direct:tcp|10.244.0.32:5150
    Direct:ws|[fe80::20ca:28ff:fe31:ab58]:5150/ws
    Direct:ws|10.244.0.32:5150/ws
17:01:43  INFO rtab: [LocalNetwork] changed network: outbound EnumSet()->EnumSet(UDP | TCP | WS | WSS)
17:01:43  INFO rtab: [LocalNetwork] changed network: inbound EnumSet()->EnumSet(UDP | TCP | WS)
17:01:43  INFO rtab: [LocalNetwork] changed network: address types EnumSet()->EnumSet(IPV6 | IPV4)
17:01:43  INFO rtab: [PublicInternet] changed network: capabilities []->[RLAY, DHTV, DHTW, APPM]
17:01:43  INFO rtab: [LocalNetwork] changed network class: Invalid->InboundCapable
17:01:43  INFO net: network started
17:01:43  WARN rtab: bootstrap server is not responding
17:01:43  WARN rtab: bootstrap server is not responding
17:01:44  INFO rtab: bootstrap of VLD0 successful via VLD0:m5OY1uhPTq2VWhpYJASmzATsKTC7eZBQmyNs6tRJMmA
```

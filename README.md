# Veilid Server Build Docker Image
This project builds a Docker image based on Ubuntu 23.04 that compiles `veiled-server` from source. Building the image takes about 5-6 minutes on an M1 Mac.

Once the image is built, numerous servers can be instantly started in their own containers. I created this as a way to easily test multiple Veilid Server nodes from one machine.

## FOR DEVELOPMENT PURPOSES ONLY
The image built by this respository runs `veilid-server` as root. It is meant to serve as a quick and dirty way to spin up nodes. Do not, under any circumstances, use this to run production nodes.

## Build The Image
- Install Docker (https://www.docker.com/)
- Clone this repository: `git clone https://github.com/archwisp/VeilidServerBuildDockerImage`
- Change into the repository directory: `cd VeilidServerBuildDockerImage`
- Build the Docker image (takes 5-6 minutes on an M1 Mac): `docker compose build --no-cache`

Once the image is built, you should see it with the `docker images` command:

```
$ docker images
REPOSITORY                                     TAG       IMAGE ID       CREATED         SIZE
veilidserverbuilderdockerimage-veilid-server   latest    fe70366f734f   5 minutes ago   8.64GB
```

## Run The Containers

Running the containers using the `-v` or `--volume` parameter allows the server storage to be persisted on your Docker host. If you need to delete a container for some reason, you can spin the server back up using the same stored data.

- Create a directory for persistent node storage: `mkdir /tmp/veilid-sever`
- Run `veilid-server-1` in a container: `docker run -it -d --name veilid-server-1 -v /tmp/veilid-sever/server-1:/root/.local/share/veilid veilidserverbuilderdockerimage-veilid-server`
- Run `veilid-server-2` in a container: `docker run -it -d --name veilid-server-2 -v /tmp/veilid-sever/server-2:/root/.local/share/veilid veilidserverbuilderdockerimage-veilid-server`

Once the containers have been lauched, you should see them running with the `docker ps` command:

```
$ docker ps
CONTAINER ID   IMAGE                                          COMMAND                  CREATED         STATUS         PORTS     NAMES
b4a2cc4ace0e   veilidserverbuilderdockerimage-veilid-server   "/root/veilid/target…"   3 seconds ago   Up 3 seconds             veilid-server-2
e9b876043d39   veilidserverbuilderdockerimage-veilid-server   "/root/veilid/target…"   5 minutes ago   Up 5 minutes             veilid-server-1
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
2023-09-04T03:36:17.577143Z  INFO api_startup:new_with_config_callback:new_common:startup: veilid_core::core_context: Veilid API starting up
2023-09-04T03:36:17.577284Z  INFO api_startup:new_with_config_callback:new_common:startup: veilid_core::core_context: init api tracing
2023-09-04T03:36:17.624044Z  INFO api_startup:new_with_config_callback:new_common:startup: veilid_core::veilid_config: Node Id: VLD0:bl-zMw7buCgpIWLr887Ejqm-KYjq1fMBwFQB_Wm8bk4
2023-09-04T03:36:17.810633Z  INFO api_startup:new_with_config_callback:new_common:startup: veilid_core::core_context: Veilid API startup complete
2023-09-04T03:36:17.811079Z  INFO veilid_server::server: Auto-attach to the Veilid network
2023-09-04T03:36:17.814572Z  INFO veilid_core::network_manager::native::start_protocols: UDP: starting listeners on port 5150 at [0.0.0.0, ::]
2023-09-04T03:36:17.815061Z  INFO veilid_core::network_manager::native::start_protocols: WS: starting listener on port 5150 at [0.0.0.0, ::]
2023-09-04T03:36:17.815449Z  INFO veilid_core::network_manager::native::start_protocols: TCP: starting listener on port 5150 at [0.0.0.0, ::]
2023-09-04T03:36:17.815670Z  INFO veilid_core::routing_table::routing_domain_editor: LocalNetwork Dial Info: [VLD0:bl-zMw7buCgpIWLr887Ejqm-KYjq1fMBwFQB_Wm8bk4]@udp|172.17.0.2:5150
2023-09-04T03:36:17.815754Z  INFO veilid_core::routing_table::routing_domain_editor: LocalNetwork Dial Info: [VLD0:bl-zMw7buCgpIWLr887Ejqm-KYjq1fMBwFQB_Wm8bk4]@ws|172.17.0.2:5150/ws
2023-09-04T03:36:17.815807Z  INFO veilid_core::routing_table::routing_domain_editor: LocalNetwork Dial Info: [VLD0:bl-zMw7buCgpIWLr887Ejqm-KYjq1fMBwFQB_Wm8bk4]@tcp|172.17.0.2:5150
2023-09-04T03:36:17.815858Z  INFO veilid_core::network_manager::native: network started
2023-09-04T03:37:09.103188Z  INFO veilid_core::routing_table::tasks::relay_management: Inbound relay node selected: VLD0:Z2-4_moidNTvrdZt_bl83DujmC2ymSkNGR7el4kyXa0
```




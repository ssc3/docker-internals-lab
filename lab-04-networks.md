### Lab 4: Docker Bridges

#### The Default Bridge Network (`Docker0`):

1. First, let's examine the linux bridge that Docker provides by default. We will use the `brctl` tool to get information about the default Docker linux bridge, `docker0`:

    ```bash
    $ brctl show docker0
    ```

2. Start some named containers and check again:

    ```bash
    $ docker container run --name=u1 -dt ubuntu:14.04
    $ docker container run --name=u2 -dt ubuntu:14.04
    $ brctl show docker0
    ```

You should see two new virtual ethernet (veth) connections to the bridge, one for each container. `veth` connections are a linux feature for creating an access point to a sandboxed network namespace.

3. The `docker network inspect` command yields network information about what containers are connected to the specified network. The default network is always called `bridge`, so run:

    ```bash
    $ docker network inspect bridge
    ```

and find the IP of your container `u1`.

4. Connect to container `u2` of your containers using `docker container exec -it u2 /bin/bash`.

5. From inside `u2`, try pinging container `u1` by the IP address you found in the previous step, then try pinging `u1` by container name, `ping u1` - notice the lookup works with the IP, but not with the container name in this case.
    
6. Run `ip a` to see some information about what the network connection looks like from inside the container. Find the `eth0` entry, and confirm that the MAC address and IP assigned are the same (Docker always assigns MAC and IP pairs in this way, to avoid collisions).

7. Finally, back on the host, run `docker container inspect u2`, and look for the `NetworkSettings` key to see what this connection looks like from outside the container's network namespace.

#### Defining Custom Bridge Networks

In the last step, we investigated the default bridge network. Now let's try making our own. User defined bridge networks work exactly the same as the default one, but provide DNS lookup by container name, and are firewalled from other networks by default.

1. Create a bridge network by using the `bridge` driver with `docker network create`:

    ```bash
    $ docker network create --driver bridge my_bridge
    ```

2. Examine what networks are available on your host:

    ```bash
    $ docker network ls
    ```

    You should see `my_bridge` and `bridge`, the two bridge networks, as well as `none` and `host` - these are two other default networks that provide no network stack or connect to the host's network stack, respectively.

3. Launch a container connected to your new network via the `--network` flag:

    ```bash
    $ docker container run --name=u3 --network=my_bridge -dt ubuntu:14.04
    ```

4. Use the `inspect` command to investigate the network settings of this container:

    ```bash
    $ docker container inspect u3
    ```

    `my_bridge` should be listed under the `Networks` key.

5. Launch another container, this time interactively:

    ```bash
    $ docker container run --name=u4 --network=my_bridge -it ubuntu:14.04
    ```

6. From inside container `u4`, ping `u3` by name: `ping u3`. Recall this didn't work on the default bridge network between `u1` and `u2`. DNS lookup by container name is only enabled for explicitly created networks.

7. Finally, try pinging `u1` by IP or container name as you did in the previous step, this time from container `u4`. `u1` (and `u2`) are not reachable from `u4` (or `u3`), since they reside on different networks. All Docker networks are firewalled from each other by default.

8. Exit container `u4` by pressing `CTRL+P,Q`. This will ensure that the container remains running.

#### Communicating Between Containers

1. Recall your container `u2` is currently plugged in only to the default `bridge` network. Confirm this using `docker container inspect u2`. Connect `u2` to the `my_bridge` network:

    ```bash
    $ docker network connect my_bridge u2
    ```

2. Check that you can ping the `u3` and `u4` containers from `u2`:

    ```bash
    $ docker container exec u2 ping u3
    $ docker container exec u2 ping u4
    ```

3. Check that you can ping the `u2` and `u4` container from `u3`:

    ```bash
    $ docker container exec u3 ping u2
    $ docker container exec u3 ping u4
    ```

4. Note `u1` still can't reach `u3` and `u4`:

    ```bash
    $ docker container exec u1 ping u3
    $ docker container exec u1 ping u4
    ```

#### Conclusion

In this exercise, you explored the bridge networking type. The key take away is that **containers on separate networks are firewalled from each other by default**. This should be leveraged as much as possible to harden your applications. If two containers don't need to talk to each other, put them on separate networks.

You also explored a number of API objects:

 - `docker network ls` lists all networks on the host
 - `docker network inspect <network name>` gives more detailed info about the named network
 - `docker network create --driver <driver> <network name>` creates a new network using the specified driver. So far, we've only seen the `bridge` driver, for creating a linux bridge based network.
 - `docker network connect <network name> <container name or id>` connects the specified container to the specified network after the container is running. The `--network` flag in `docker container run` achieves the same result at container launch.
 - `docker container inspect <container name or id>` yields, among other things, information about the networks the specified container is connected to.

### See you in lab five!

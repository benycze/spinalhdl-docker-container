# SpinalHDL Compiler Docker

This repository contains a prepared build script of SpinalHDL compiler for the Docker tool. This is useful if you don't want to deal with dependencies in your Linux distribution (or in Windows).

The only thing you need is to install the [Docker](https://www.docker.com/) or [Podman](https://podman.io/) (use the Podman tool because it is much better ;)).

The image  contains:

* Elementary developement tools (git, gcc, make ...)
* [SpinalHDL compiler](https://github.com/SpinalHDL/SpinalHDL)
* [SpinalHDL templates](https://github.com/SpinalHDL/SpinalTemplateSbt)
* [SpianlHDL workshop](https://github.com/SpinalHDL/SpinalWorkshop.git)

## How to build the image

The image is then built quite easily (the following example is for docker but you can use the same command using the [podman](https://podman.io/) tool):

```bash
./build-image.sh
```

## How to run the image (just a console)

The following command can be used to runt the image and mount the local working directory.

```bash
docker run --rm -t -i --mount=type=bind,source=/home/user/spinal-work,destination=/spinal-work localhost/spinal-compiler  bash
```

This command will do the following:

* Starts the container from the localhost/spinal-compiler image
* Mounts the local /home/user/spinal-work directory into /spinal-work directory inside the image
* Starts the container and attach the console

In a case that you want to run the image using a normal account:

```bash
docker run --user=$USER --rm -t -i --mount=type=bind,source=/home/user/spinal-work,destination=/spinal-work localhost/spinal-compiler bash
```

## How to run the X11 App Inside docker image

The image also contains the gtkwave and other X11 apps that might be useful for the developement.
Basically you need export your local XAuthority variable and X11 socket from
your system into the container (detailed explemention [here](https://blog.artis3nal.com/2020-09-13-container-gui-app-pgmodeler/)).

Check your environment for these variables:
* XAUTHORITY (if not defined run the `export XAUTHORITY=$(xauth info | grep "Authority file" | awk '{ print $3 }')` command)
* DISPLAY (this should be defined :-))

After that, run the following command with docker:

 ```bash
docker run --rm -t -i -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix:ro -v $XAUTHORITY:$XAUTHORITY:ro --user=$USER --mount=type=bind,source=/home/user/spinal-work,destination=/spinal-work localhost/spinal-compiler /bin/bash
 ```

You should be fine to run the graphic app from the container image (you can check it using the `gvim`).
The example of image start script is inside the `run-example` folder.

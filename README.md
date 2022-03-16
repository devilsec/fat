# fat

This is just a Dockerfile for the [firmware-analysis-toolkit](https://github.com/attify/firmware-analysis-toolkit) which only seems to work on Ubuntu.

## Building the Image and Running the Firmware
1. Clone the repository
```
$ git clone https://github.com/sadeli413/fat.git
$ cd fat 
```
2. Build the image for the firmware-analysis-toolkit.
```
$ docker build . -t fat
```
3. Download example firmware
```
$ wget https://www.downloads.netgear.com/files/GDC/WNAP320/WNAP320%20Firmware%20Version%202.0.3.zip
```
4. Run the image. In order for the networking to work, it needs to be run as privileged on the host.
```
$ docker run --privileged --rm -v $PWD:/work -w /work -it --net=host fat
```
5. When you're in the container, extract the firmware image.
```
# unzip WNAP320\ Firmware\ Version\ 2.0.3.zip
# tar -xvf WNAP320_V2.0.3_firmware.tar
# binwalk -e rootfs.squashfs --run-as=root
```
6. Run the firmware-analysis-toolkit
```
# cd /root/firmware-analysis-toolkit
# ./fat.py /work/rootfs.squashfs
```

It should give you an IP address (probably `192.168.0.100`) on a new interface (probably `tap1`)

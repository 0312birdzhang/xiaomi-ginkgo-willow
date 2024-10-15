```
./build.sh -b workdir

./build/prepare-fake-ota.sh out/device_ginkgo.tar.xz ota

./build/system-image-from-ota.sh ota/ubuntu_command out

```
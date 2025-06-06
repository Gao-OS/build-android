# Android build environement with `nix`

Use `devenv` to manage all the requirements of the Android build.

### Setup

```shell
# set ccache size
ccache -M 100G
# enable cache compression
ccache -o compression= true
```

Initizlize the LineageOS source repo

```shell
test -d android/lineage || mkdir -p android/lineage

repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --git-lfs --no-clone-bundle
repo sync
```

Prepare the device-specific code

```shell
cd android/lineage
source build/envsetup.sh
breakfast "<device-code>"
```

Extract proprietary blobs

```shell
test -d android/system_dump || mkdir -p android/system_dump
cd android/system_dump
```

We need to extract from prebuild LineageOS zip file

Download from device page, they are payload-base OTAs

Then get dump tools

```shell
# Download from `https://github.com/ssut/payload-dumper-go`
# or
git clone https://github.com/LineageOS/android_prebuilts_extract-tools android/prebuilts/extract-tools
git clone https://github.com/LineageOS/android_tools_extract-utils android/tools/extract-utils
git clone https://github.com/LineageOS/android_system_update_engine android/system/update_engine
```

Extract zip file

```shell
unzip lineage-*.zip
```

Extract `payload.bin`

```shell
./android/prebuilts/extract-tools/linux-x86/bin/ota_extractor --payload path/to/payload.bin
```

Mount

```shell
mkdir system/
sudo mount -o ro system.img system/
sudo mount -o ro vendor.img system/vendor/
sudo mount -o ro odm.img system/odm/
sudo mount -o ro product.img system/product/
sudo mount -o ro system_ext.img system/system_ext/
```

Move to the root directory of the sources of your device and run extract-files.sh or extract-files.py as follows:

```shell
./extract-files.sh ~/android/system_dump/
# Or, for the Python script:
./extract-files.py ~/android/system_dump/
```

This will tell extract-files script to extract the proprietary blobs from the mounted system dump rather than a connected device.

Once it is done, unmount the system dump and remove the now unnecessary files:

```shell
sudo umount -R android/system_dump/system/
rm -rf android/system_dump/
```


### Build

Start build

```shell
croot
brunch felix
```

Install the build

Assuming the build completed without errors (it will be obvious when it finishes), 
type the following in the terminal window the build ran in:

```shell
cd $OUT
```

There you’ll find all the files that were created. The two files of more interest are:

- `vendor_boot.img`, which is the LineageOS recovery image.
- `lineage-22.2-20250604-UNOFFICIAL-felix.zip`, which is the LineageOS installer package.

{ config, lib, pkgs, ... }:

{
  mobile.device.name = "kindle-touch";
  mobile.device.identity = {
    name = "kindle-touch";
    manufacturer = "Amazon";
  };

  mobile.hardware = {
    soc = "freescale-mx508";
    eink = {
      enableEinkTheme = true;
    };
    ram = 256;
    screen = {
      width = 600; height = 800;
    };
  };

  mobile.boot.stage-1 = {
    kernel.package = pkgs.callPackage ./kernel { };
  };
  
  mobile.kernel.structuredConfig = [
    (helpers: with helpers; {
      TOUCHSCREEN_ZFORCE = option yes;
      INPUT = option yes;
      INPUT_TOUCHSCREEN = option yes;
    })
  ];

  boot.kernelParams = [
    # These are pulled from firmware
    "consoleblank=0"
    "rootwait"
    "ip=off"
    "root=/dev/mmcblk0p1"
    "quiet"
    "eink=fslepdc" 
    "video=mxcepdcfb:E60,bpp=8,x_mem=2M"
  ];

  # Serial console on ttyS0, using the serial headphone adapter.
  mobile.boot.serialConsole = "ttymxc0,115200";

  mobile.system.type = "u-boot";

  mobile.usb.mode = "gadgetfs";

  # Commonly re-used values, Nexus 4 (debug)
  # (These identifiers have well-known default udev rules.)
  mobile.usb.idVendor = "18d1";
  mobile.usb.idProduct = "d002";

  mobile.usb.gadgetfs.functions = {
    rndis = "rndis.usb0";
    mass_storage = "mass_storage.0";
    adb = "ffs.adb";
  };

  #mobile.boot.stage-1.bootConfig = {
  #  # Used by target-disk-mode to share the internal drive
  #  storage.internal = "/dev/disk/by-path/platform-1c11000.mmc";
  #};

  #mobile.device.firmware = pkgs.callPackage ./firmware {};

  # Supports rebooting into generation kernel through kexec.
  mobile.quirks.supportsStage-0 = true;

  #mobile.quirks.fdt-forward = {
  #  props = [
  #    ["/soc/mmc@1c10000/wifi@1" "local-mac-address"]
  #  ];
  #};
}

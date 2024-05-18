{ config, lib, pkgs, ... }:

{
  mobile.device.name = "google-marlin";
  mobile.device.identity = {
    name = "Google Pixel 4a (5G)";
    manufacturer = "Google";
  };

  mobile.hardware = {
    soc = "qualcomm-sm7250";
    ram = 1024 * 6;
    screen = {
      width = 1080; height = 2340;
    };
  };

  mobile.boot.stage-1 = {
    kernel.package = pkgs.callPackage ./kernel { };
  };

  #mobile.device.firmware = pkgs.callPackage ./firmware {};
  #mobile.device.enableFirmware = false;

  mobile.system.android.device_name = "marlin";
  mobile.system.android = {
    # This device has an A/B partition scheme
    ab_partitions = true;

    bootimg.flash = {
      offset_base = "0x00268ef0";
      offset_kernel = "0x00008000";
      offset_ramdisk = "0xffd9773c";
      offset_second = "0xffd97110";
      offset_tags = "0xffd97110";
      pagesize = "4096";
    };
  };

  mobile.system.vendor.partition = "/dev/disk/by-partlabel/vendor_a";

  # For use with the "Nexus-style" UART cable, add the following kernel parameter.
  mobile.boot.serialConsole = "ttyHSL0,115200n8";

  mobile.usb.mode = "android_usb";
  # Google
  mobile.usb.idVendor = "18D1";
  # "Pixel" rndis+adb
  mobile.usb.idProduct = "4EE4";

  mobile.system.type = "android";

  mobile.quirks.qualcomm.wcnss-wlan.enable = true;
  mobile.quirks.wifi.disableMacAddressRandomization = true;
}
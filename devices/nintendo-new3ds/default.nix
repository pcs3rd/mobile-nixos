{ config, lib, pkgs, ... }:

# New Nintendo 3DS (KTR)
# SoC:  Nintendo CTR — ARM11 MPCore, 4× ARMv6K @ 804 MHz
# RAM:  256 MB
# Boot: Luma3DS CFW → firm_linux_loader.firm → Linux
#
# Prerequisites: a hacked 3DS with Luma3DS installed.
# See https://3ds.hacks.guide

{
  mobile.device.name = "nintendo-new3ds";
  mobile.device.identity = {
    name = "New Nintendo 3DS";
    manufacturer = "Nintendo";
  };
  mobile.device.supportLevel = "best-effort";

  mobile.hardware = {
    # CTR is the unified SoC codename (covers Old/New 3DS family).
    # The hardware-nintendo.nix module sets system.system from this.
    soc = "nintendo-ctr";

    # 256 MB on New 3DS (Old 3DS has 128 MB; use nintendo-old3ds for that).
    ram = 1024 * 0 + 256;

    screen = {
      # Top LCD: 800×240 landscape (stereoscopic IPS).
      # Linux sees it as a single 800×240 framebuffer via FB_SIMPLE.
      width  = 800;
      height = 240;
    };
  };

  mobile.system.type = "nintendo-firm";

  mobile.boot.stage-1 = {
    kernel.package = pkgs.callPackage ./kernel { };

    # The SD card is accessed via VirtIO-blk over PXI (arm9linuxfw).
    # With the virtio-mmio and virtio-blk options built-in to the kernel
    # (see config.arm), no extra modules are needed for storage.
    # Add any additional modules you need here.
    kernel.additionalModules = [ ];

    # Boot from the first VirtIO block device partition 2.
    # Adjust vda2 to match your SD card partition layout.
    bootConfig = {
      storage.internal = "/dev/vda";
    };
  };

  boot.kernelParams = lib.mkAfter [
    # VirtIO MMIO transport (registers provided by mach-ctr to the ARM11)
    "virtio_mmio.device=0x1000@0x10160000:0x4a"
    # Framebuffer console on the top LCD
    "console=tty0"
    # Root on VirtIO block device partition 2
    "root=/dev/vda2"
    "rootfstype=ext4"
    "rootwait"
  ];

  # No separate firmware package — arm9linuxfw is bundled in the
  # nintendo-firm system type output.
  mobile.device.firmware = lib.mkDefault null;
}

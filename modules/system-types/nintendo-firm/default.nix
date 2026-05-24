{ config, pkgs, lib, ... }:

# System type: nintendo-firm
#
# Describes the Nintendo 3DS boot chain:
#   Luma3DS CFW (on-device) → firm_linux_loader.firm → Linux
#
# The build output is an SD card skeleton whose contents the user copies to
# the root of their microSD card.  Layout:
#
#   luma/payloads/firm_linux_loader.firm   ← Luma3DS chainload entry
#   3ds/linux/Image                        ← uncompressed ARM11 kernel
#   3ds/linux/initramfs.cpio.gz            ← mobile-nixos stage-1
#   3ds/linux/arm9linuxfw.bin              ← ARM9 virtio-storage firmware
#
# firm_linux_loader reads kernel + initramfs + arm9fw from the SD card,
# loads them into memory, and jumps to the kernel entry point.
#
# References:
#   https://github.com/linux-3ds/firm_linux_loader/wiki
#   https://github.com/samueldr/linux-3ds.nix

let
  inherit (lib) mkIf mkOption types;
  enabled    = config.mobile.system.type == "nintendo-firm";
  deviceName = config.mobile.device.name;

  inherit (config.mobile.outputs) recovery stage-0;

  kernel      = stage-0.mobile.boot.stage-1.kernel.package;
  kernel_file = "${kernel}/Image";

  # The initramfs produced by mobile-nixos stage-1
  initramfs = stage-0.mobile.outputs.initrd;

  # Overlay packages (added via overlay/overlay.nix)
  firmLoader = pkgs.firm-linux-loader;
  arm9fw     = pkgs.arm9linuxfw;

  # Build the FIRM payload — bundles arm9 + arm11 ELFs into Nintendo's
  # FIRM container format using firmtool.
  firmPayload = pkgs.runCommand "${deviceName}-firm_linux_loader.firm" {
    nativeBuildInputs = [ pkgs.firmtool ];
  } ''
    firmtool build $out \
      -D ${firmLoader}/arm9/firm_linux_loader_arm9.elf \
         ${firmLoader}/arm11/firm_linux_loader_arm11.elf \
      -C NDMA XDMA \
      -i
  '';

  # SD card skeleton — copy these files to the root of your microSD.
  sdcardSkeleton = pkgs.runCommand "${deviceName}-sdcard-skeleton" {} ''
    mkdir -p $out/luma/payloads
    mkdir -p $out/3ds/linux

    cp ${firmPayload}              $out/luma/payloads/firm_linux_loader.firm
    cp ${kernel_file}              $out/3ds/linux/Image
    cp ${initramfs}                $out/3ds/linux/initramfs.cpio.gz
    cp ${arm9fw}/arm9linuxfw.bin   $out/3ds/linux/arm9linuxfw.bin
  '';
in
{
  options.mobile.outputs.nintendo-firm = {
    sdcard-skeleton = mkOption {
      type        = types.package;
      description = "SD card skeleton for the nintendo-firm system type. Copy its contents to the root of your microSD card.";
      visible     = false;
    };
  };

  config = lib.mkMerge [
    # Register this system type so the system-types.nix enum accepts it.
    { mobile.system.types = [ "nintendo-firm" ]; }

    (mkIf enabled {
      mobile.outputs = {
        default = sdcardSkeleton;
        nintendo-firm.sdcard-skeleton = sdcardSkeleton;
      };

      # firm_linux_loader loads the initramfs from the SD card externally,
      # so it does not need to be embedded in the kernel image.
      mobile.boot.stage-1.compression = lib.mkDefault "gzip";
    })
  ];
}

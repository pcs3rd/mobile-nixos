{ config, lib, pkgs, ... }:

# Nintendo CTR SoC platform for mobile-nixos.
#
# CTR is the internal codename for the Nintendo 3DS SoC family.
# It covers all retail variants:
#   Old 3DS / Old 3DS XL / Old 2DS  — 2× ARM11 @ 268/536 MHz, 128 MB RAM
#   New 3DS / New 3DS XL / New 2DS XL — 4× ARM11 @ 804 MHz, 256 MB RAM
#
# The kernel config option is CONFIG_ARCH_CTR (see arch/arm/mach-ctr/).
# ARM architecture: ARMv6K (CPU_V6K).  NixOS system string: "armv6l-linux".

let
  inherit (lib) mkIf mkOption types;
  cfg = config.mobile.hardware.socs;
in
{
  options.mobile.hardware.socs = {
    nintendo-ctr.enable = mkOption {
      type    = types.bool;
      default = false;
      description = "Enable when the SoC is Nintendo CTR (3DS family — ARMv6K ARM11 MPCore).";
    };
  };

  config = mkIf cfg.nintendo-ctr.enable {
    mobile.system.system = "armv6l-linux";

    # The nintendo-firm system type handles packaging for this platform.
    # It is set by the device's default.nix; we do not force it here so
    # that future devices on this SoC (e.g. nintendo-old3ds) can also use it.

    mobile.kernel.structuredConfig = [
      (helpers: with helpers; {
        # Ensure the CTR machine support is selected.
        ARCH_CTR = lib.mkDefault yes;
        # VirtIO MMIO — needed for arm9linuxfw virtio-blk transport.
        VIRTIO      = lib.mkDefault yes;
        VIRTIO_MMIO = lib.mkDefault yes;
      })
    ];
  };
}

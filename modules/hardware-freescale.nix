{ config, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkOption types;
  cfg = config.mobile.hardware.socs;
in
{
  options.mobile = {
    hardware.socs.freescale-mx508.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is Mediatek MX508";
    };
  };

  config = mkMerge [
    {
      mobile = mkIf cfg.freescale-mx508.enable {
        system.system = "armv7l-linux";
        quirks.fb-refresher.enable = true;
        kernel.structuredConfig = [
          (helpers: with helpers; {
            ARCH_MX5 = option yes;
            ARCH_MX50 = option yes; 
          })
        ];
      };
    }

    #(mkIf anyFreescale {
    #  mobile.kernel.structuredConfig = [
    #    (helpers: with helpers; {
    #      ARCH_MEDIATEK = lib.mkDefault yes;
    #    })
    #  ];
    #})
  ];
}

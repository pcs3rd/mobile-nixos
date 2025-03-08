{ config, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkOption types;
  cfg = config.mobile.hardware.socs;
in
{
  options.mobile.hardware.socs = {
    hardware.socs.freescale-MX508.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable when SOC is i.MX508";
    };
  };

  config = {
    mobile.system.system = mkMerge [
      {
        mobile = mkIf cfg.freescale-MX508.enable {
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
    ];
  };
}

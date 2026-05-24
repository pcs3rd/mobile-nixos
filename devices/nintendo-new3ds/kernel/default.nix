{
  mobile-nixos,
  fetchFromGitHub,
  lib,
  ...
}:

mobile-nixos.kernel-builder {
  version = "5.11.0-rc1";
  configfile = ./config.arm;

  src = fetchFromGitHub {
    owner = "linux-3ds";
    repo  = "linux";
    rev   = "7071ec29fd3ebd55d00a70cb6482e98d4702c5f2";
    # Run `nix-build` once; nix will error with the correct hash to paste here.
    hash  = lib.fakeHash;
  };

  # firm_linux_loader expects a raw uncompressed Image, not zImage/uImage.
  isCompressed = false;

  # No Qualcomm or Exynos DT blobs.
  isQcdt     = false;
  isExynosDT = false;

  # 5.11-rc1 may emit -Werror with a newer host GCC than it was written for.
  enableRemovingWerror = true;
}

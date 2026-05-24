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
    "owner" = "linux-3ds";
    "repo" = "firm_linux_loader";
    "rev" = "ecb0f0d5a8d8aaafaf5edca279098b52ecfa71a0";
    "hash" = "sha256-ONStwFJmRm3RJedvSKNMh8fcDvH+cO+l0ppaKa44S7Q=";
  };

  # firm_linux_loader expects a raw uncompressed Image, not zImage/uImage.
  isCompressed = false;

  # No Qualcomm or Exynos DT blobs.
  isQcdt     = false;
  isExynosDT = false;

  # 5.11-rc1 may emit -Werror with a newer host GCC than it was written for.
  enableRemovingWerror = true;
}

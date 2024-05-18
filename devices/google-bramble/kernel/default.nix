{ mobile-nixos
, fetchFromGitHub
, ...
}:

mobile-nixos.kernel-builder {
  version = "4.10.294";
  configfile = ./config.aarch64;

  src = fetchFromGitHub {
    owner = "LineageOS";
    repo = "android_kernel_google_redbull";
    rev = "53a4ea8a262fb7e12c30c8077bc1e0f17d6139ed";  #  branch Lineage-21
    sha256 = "";
  };
  isModular = true;
}

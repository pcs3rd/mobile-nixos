{
  mobile-nixos
, fetchurl
, fetchgit
, ...
}:

mobile-nixos.kernel-builder {
  version = "6.13.6";
  configfile = ./config.armel;
  src = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.13.6.tar.xz";
    hash = "";
  };

  #patches = [
  #  ./patch.patch
  #];

  # Install *only* the desired FDTs
  #postInstall = ''
  #  echo ":: Installing FDTs"
  #  mkdir -p "$out/dtbs/allwinner"
  #  cp -v $buildRoot/arch/arm64/boot/dts/allwinner/sun50i-a64-pinetab.dtb $out/dtbs/allwinner/
  #'';

  isCompressed = false;
}

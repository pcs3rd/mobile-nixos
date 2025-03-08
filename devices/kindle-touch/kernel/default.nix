{
  mobile-nixos
, fetchFromGit
, ...
}:

mobile-nixos.kernel-builder {
  version = "6.12";
  configfile = ./config.armel;
  src = fetchFromGit {
    url = "https://git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git";
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

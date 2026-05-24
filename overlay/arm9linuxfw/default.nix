{ lib, stdenv, fetchFromGitHub, pkgsCross }:

# arm9linuxfw — bare-metal ARM9 firmware for the Nintendo 3DS.
# Runs on the ARM9 security processor (not Linux).
# Implements a VirtIO block device over the PXI bus so the ARM11 Linux
# kernel can access the SD card via the ARM9's SDMMC controller.
#
# Without this firmware loaded by firm_linux_loader, Linux has no storage.
# Source: https://github.com/linux-3ds/arm9linuxfw

let
  # ARM9 in the 3DS is an ARM946E-S (ARMv5TE) — bare-metal, no Linux libc.
  cross = pkgsCross.arm-embedded;
in
stdenv.mkDerivation {
  pname   = "arm9linuxfw";
  version = "unstable-2024";

  src = fetchFromGitHub {
    owner = "linux-3ds";
    repo  = "arm9linuxfw";
    rev   = "206978444c04c65d1fc9e5a841196f7bd1623926";
    # Replace with real hash after first `nix-build` error:
    hash  = lib.fakeHash;
  };

  nativeBuildInputs = [ cross.buildPackages.gcc cross.buildPackages.binutils ];

  makeFlags = [
    "CROSS_COMPILE=${cross.stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    # arm9linuxfw.bin is a raw binary; the first byte is the entry point.
    cp arm9linuxfw.bin $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "ARM9 firmware implementing VirtIO-over-PXI storage for Nintendo 3DS Linux";
    homepage    = "https://github.com/linux-3ds/arm9linuxfw";
    license     = licenses.gpl2Only;
  };
}

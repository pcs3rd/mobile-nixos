{ lib, stdenv, fetchFromGitHub, pkgsCross }:

# firm_linux_loader — FIRM payload that boots Linux on the Nintendo 3DS.
# Luma3DS chainloads this from /luma/payloads/firm_linux_loader.firm.
# It reads the kernel, initramfs, and arm9fw from the SD card, then jumps
# to the Linux entry point on the ARM11 cores.
#
# The build produces two ELF files:
#   arm9/firm_linux_loader_arm9.elf   — ARM9 (ARMv5TE) stub
#   arm11/firm_linux_loader_arm11.elf — ARM11 (ARMv6K MPCore) main loader
#
# These are assembled into a .firm container by firmtool (see system type).
# Source: https://github.com/linux-3ds/firm_linux_loader

let
  # bare-metal ARM cross compiler (no Linux libc)
  cross = pkgsCross.arm-embedded;
in
stdenv.mkDerivation {
  pname   = "firm-linux-loader";
  version = "unstable-2024";

  src = fetchFromGitHub {
    owner = "linux-3ds";
    repo  = "firm_linux_loader";
    rev   = "ecb0f0d5a8d8aaafaf5edca279098b52ecfa71a0";
    # Replace with real hash after first `nix-build` error:
    hash  = lib.fakeHash;
  };

  nativeBuildInputs = [ cross.buildPackages.gcc cross.buildPackages.binutils ];

  makeFlags = [
    "CC=${cross.stdenv.cc.targetPrefix}gcc"
    "OBJCOPY=${cross.stdenv.cc.targetPrefix}objcopy"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/arm9 $out/arm11
    cp arm9/firm_linux_loader_arm9.elf   $out/arm9/
    cp arm11/firm_linux_loader_arm11.elf $out/arm11/
    runHook postInstall
  '';

  meta = with lib; {
    description = "FIRM Linux Loader — boots Linux on the Nintendo 3DS";
    homepage    = "https://github.com/linux-3ds/firm_linux_loader";
    license     = licenses.gpl2Only;
  };
}

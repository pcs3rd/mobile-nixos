let
  sha256 = "sha256:0rmbq6jr21fvcspxshaiwmm5a1z66pykjm2f5imww9nhxn6dfgzv";
  rev = "6143fc5eeb9c4f00163267708e26191d1e918932";
in
builtins.trace "(Using pinned Nixpkgs at ${rev})"
import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
})

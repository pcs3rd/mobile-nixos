let
  sha256 = "";
  rev = "6143fc5eeb9c4f00163267708e26191d1e918932";
in
builtins.trace "(Using pinned Nixpkgs at ${rev})"
import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
})

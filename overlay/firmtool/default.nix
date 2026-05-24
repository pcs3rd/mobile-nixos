{ lib, python3, fetchFromGitHub }:

# firmtool — builds Nintendo FIRM container files.
# Used by firm_linux_loader's Makefile to assemble the final .firm payload.
# Source: https://github.com/TuxSH/firmtool

python3.pkgs.buildPythonApplication {
  pname   = "firmtool";
  version = "unstable-2021";

  pyproject = true;

  src = fetchFromGitHub {
    "owner": "TuxSH",
    "repo": "firmtool",
    "rev": "fdc7085c2394d87ce5dbdfecdf51423e1e7b00a1",
    "hash": "sha256-7fvMeHbbkOEIutLiZt+zU8ZNBgrX6WRq66NIOyDgRV0="
  };

  build-system = [ python3.pkgs.setuptools ];

  # firmtool has no runtime dependencies beyond Python stdlib.
  propagatedBuildInputs = [];

  meta = with lib; {
    description = "Tool for building Nintendo FIRM container files";
    homepage    = "https://github.com/TuxSH/firmtool";
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}

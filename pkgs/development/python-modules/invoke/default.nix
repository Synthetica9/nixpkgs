{ lib
, bash
, buildPythonPackage
, fetchFromPyPI
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.4.1";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "de3f23bfe669e3db1085789fd859eb8ca8e0c5d9c20811e2407fa042e8a5e15d";
  };

  patchPhase = ''
    sed -e 's|/bin/bash|${bash}/bin/bash|g' -i invoke/config.py
  '';

  # errors with vendored libs
  doCheck = false;

  meta = {
    description = "Pythonic task execution";
    license = lib.licenses.bsd2;
  };
}

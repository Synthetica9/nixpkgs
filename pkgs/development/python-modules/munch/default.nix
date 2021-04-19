{ lib
, buildPythonPackage
, fetchFromPyPI
, six
, pbr
}:

buildPythonPackage rec {
  pname = "munch";
  version = "2.5.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2";
  };

  propagatedBuildInputs = [ six pbr ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A dot-accessible dictionary (a la JavaScript objects)";
    license = licenses.mit;
    homepage = "https://github.com/Infinidat/munch";
  };

}

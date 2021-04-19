{ lib, buildPythonPackage, fetchFromPyPI }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.1.4";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "1d1003ae3c6115ec9b587d29dd136860a81a23c7626b682e2b5b12c9fd30e4ea";
  };

  doCheck = false; # something about yajl

  meta = with lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}

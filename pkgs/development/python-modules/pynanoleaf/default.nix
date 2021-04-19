{ lib, buildPythonPackage, fetchFromPyPI, isPy3k, requests }:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.1.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "sha256-BiLJgsey7kIIeN5+CKKnrTB2bSKMNEbeMLwGi2LRLcg=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  # pynanoleaf does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "pynanoleaf"
  ];

  meta = with lib; {
    homepage = "https://github.com/Oro/pynanoleaf";
    description = "A Python3 wrapper for the Nanoleaf API, capable of controlling both Nanoleaf Aurora and Nanoleaf Canvas";
    license = licenses.mit;
    maintainers = with maintainers; [ oro ];
  };
}

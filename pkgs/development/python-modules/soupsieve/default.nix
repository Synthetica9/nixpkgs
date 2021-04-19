{ lib
, buildPythonPackage
, fetchFromPyPI
, pytest
, beautifulsoup4
, isPy3k
, backports_functools_lru_cache
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.0.1";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest beautifulsoup4 ];

  propagatedBuildInputs = lib.optional (!isPy3k) backports_functools_lru_cache;

  # Circular test dependency on beautifulsoup4
  doCheck = false;

  meta = {
    description = "A CSS4 selector implementation for Beautiful Soup";
    license = lib.licenses.mit;
    homepage = "https://github.com/facelessuser/soupsieve";
  };

}

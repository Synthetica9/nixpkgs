{ lib, buildPythonPackage, fetchFromPyPI
, isPyPy, isPy3k, unittest2
}:

buildPythonPackage rec {
  pname = "funcsigs";
  version = "1.0.2";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "0l4g5818ffyfmfs1a924811azhjj8ax9xd1cffr1mzd3ycn0zfx7";
  };

  buildInputs = [ unittest2 ];

  # https://github.com/testing-cabal/funcsigs/issues/10
  patches = lib.optional (isPyPy && isPy3k) [ ./fix-pypy3-tests.patch ];

  meta = with lib; {
    description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
    homepage = "https://github.com/aliles/funcsigs";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}

{ lib
, buildPythonPackage
, fetchFromPyPI
, isPy27
, funcsigs
, six
, pbr
, python
, pytest
}:

buildPythonPackage rec {
  pname = "mock";
  version = "4.0.3";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc";
  };

  propagatedBuildInputs = [ six pbr ] ++ lib.optionals isPy27 [ funcsigs ];

  # On PyPy for Python 2.7 in particular, Mock's tests have a known failure.
  # Mock upstream has a decoration to disable the failing test and make
  # everything pass, but it is not yet released. The commit:
  # https://github.com/testing-cabal/mock/commit/73bfd51b7185#diff-354f30a63fb0907d4ad57269548329e3L12
  #doCheck = !(python.isPyPy && python.isPy27);
  doCheck = false; # Infinite recursion pytest

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "Mock objects for Python";
    homepage = "http://python-mock.sourceforge.net/";
    license = licenses.bsd2;
  };

}

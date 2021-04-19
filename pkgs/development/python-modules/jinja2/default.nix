{ lib, stdenv
, buildPythonPackage
, isPy3k
, fetchFromPyPI
, pytest
, markupsafe
, setuptools
}:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.11.3";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ markupsafe setuptools ];

  # Multiple tests run out of stack space on 32bit systems with python2.
  # See https://github.com/pallets/jinja/issues/1158
  doCheck = !stdenv.is32bit || isPy3k;

  checkPhase = ''
    pytest -v tests
  '';

  meta = with lib; {
    homepage = "http://jinja.pocoo.org/";
    description = "Stand-alone template engine";
    license = licenses.bsd3;
    longDescription = ''
      Jinja2 is a template engine written in pure Python. It provides a
      Django inspired non-XML syntax but supports inline expressions and
      an optional sandboxed environment.
    '';
    maintainers = with maintainers; [ pierron sjourdois ];
  };
}

{ lib
, buildPythonPackage
, fetchFromPyPI
, nose
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.10.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests toolz/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}

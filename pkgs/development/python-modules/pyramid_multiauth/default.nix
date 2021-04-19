{ lib
, buildPythonPackage
, fetchFromPyPI
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_multiauth";
  version = "0.9.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "0lprqjyg3zcji6033p1l3s4nigjigc5423wgivkfhz46vq0jmniy";
  };

  propagatedBuildInputs = [ pyramid ];

  meta = with lib; {
    description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
    homepage = "https://github.com/mozilla-services/pyramid_multiauth";
    license = licenses.mpl20;
    maintainers = with maintainers; [];
  };
}

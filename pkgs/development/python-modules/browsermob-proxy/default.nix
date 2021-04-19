{ lib
, buildPythonPackage
, fetchFromPyPI
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "browsermob-proxy";
  version = "0.8.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "1bxvmghm834gsfz3pm69772wzhh15p8ci526b25dpk3z4315nd7v";
  };

  propagatedBuildInputs = [ (requests.override { urllib3 = urllib3.override {
    pyopenssl = null;
    cryptography = null;
  };}) ];

  meta = {
    description = "A library for interacting with Browsermob Proxy";
    homepage = "http://oss.theautomatedtester.co.uk/browsermob-proxy-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}

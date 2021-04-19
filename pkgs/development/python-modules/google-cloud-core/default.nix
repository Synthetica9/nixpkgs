{ lib
, buildPythonPackage
, fetchFromPyPI
, pythonOlder
, pytestCheckHook
, python
, google-api-core
, grpcio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.6.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "sha256-xquxhSdUU3n8gu/E3nXOmjdyzK0vxkWtrOWTugl8uwI=";
  };

  propagatedBuildInputs = [ google-api-core ];

  checkInputs = [ mock pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud" ];

  meta = with lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

{ lib, buildPythonPackage, fetchFromPyPI }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.12";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59";
  };

  meta = with lib; {
    homepage = "https://github.com/benediktschmitt/py-filelock";
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}

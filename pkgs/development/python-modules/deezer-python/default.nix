{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, tornado
, poetry-core
, pytestCheckHook
, pytest-cov
, pytest-vcr
}:

buildPythonPackage rec {
  pname = "deezer-python";
  version = "2.2.3";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i626rahsa9p1y4zv5jb66ppwb6klqhwbv01q3nd1hylq2dqg11v";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-vcr
  ];

  propagatedBuildInputs = [
    requests
    tornado
  ];

  meta = with lib; {
    description = "A friendly Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}

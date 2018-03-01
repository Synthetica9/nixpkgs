{ lib
, buildPythonPackage
, jupyterhub
, globus-sdk
, mwoauth
, codecov
, flake8
, pyjwt
, pytest
, pytestcov
, pytest-tornado
, requests-mock
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "oauthenticator";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb0b2564e46db28350693bc3e6457333c4ee21af5066ac743730e3f3173ea7ed";
  };

  checkPhase = ''
    py.test oauthenticator/tests
  '';

  # No tests in archive
  doCheck = false;
   
  checkInputs = [  globus-sdk mwoauth codecov flake8 pytest
    pytestcov pytest-tornado requests-mock pyjwt ];
  
  propagatedBuildInputs = [ jupyterhub ];

  disabled = pythonOlder "3.4";

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers, including GitHub, Bitbucket, and more.";
    homepage =  https://github.com/jupyterhub/oauthenticator;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}

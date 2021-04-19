{ lib, buildPythonPackage, fetchFromPyPI, fetchpatch, isPy27
, mock, pytest, sybil, zope_component, twisted }:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.15.0";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "409f77cfbdad822d12a8ce5c4aa8fb4d0bb38073f4a5444fede3702716a2cec2";
  };

  checkInputs = [ pytest mock sybil zope_component twisted ];

  doCheck = !isPy27;
  checkPhase = ''
    # django is too much hasle to setup at the moment
    pytest -W ignore::DeprecationWarning \
      --ignore=testfixtures/tests/test_django \
      -k 'not (log_then_patch or our_wrap_dealing_with_mock_patch or patch_with_dict)' \
      testfixtures/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/Simplistix/testfixtures";
    description = "A collection of helpers and mock objects for unit tests and doc tests";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}

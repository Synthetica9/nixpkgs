{ stdenv
, buildPythonPackage
, fetchPypi
, click
, pyyaml
}:

buildPythonPackage rec{
  version = "1.12.4";
  pname = "panflute";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15cvli3hqvai8fwccqginb0hh19a417xphd53x882n4b69jxq1aw";
  };

  propagatedBuildInputs = [ click pyyaml ];

  meta = with stdenv.lib; {
    description = "A Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };

}

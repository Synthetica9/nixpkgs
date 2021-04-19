{ buildPythonPackage, fetchFromPyPI, lib, sqlalchemy, nose }:

buildPythonPackage rec {
  pname = "sqlsoup";
  version = "0.9.1";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "1mj00fhxj75ac3i8xk9jmm7hvcjz9p4x2r3yndcwsgb659rvgbrg";
  };

  propagatedBuildInputs = [ sqlalchemy ];
  checkInputs = [ nose ];

  meta = with lib; {
    description = "A one step database access tool, built on the SQLAlchemy ORM";
    homepage = "https://bitbucket.org/zzzeek/sqlsoup";
    license = licenses.mit;
    maintainers = [ maintainers.globin ];
  };
}

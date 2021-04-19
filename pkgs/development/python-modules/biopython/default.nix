{ lib
, buildPythonPackage
, fetchFromPyPI
, numpy
, isPy3k
}:

buildPythonPackage rec {
  pname = "biopython";
  version = "1.78";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "1ee0a0b6c2376680fea6642d5080baa419fd73df104a62d58a8baf7a8bbe4564";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ numpy ];
  # Checks try to write to $HOME, which does not work with nix
  doCheck = false;
  meta = {
    description = "Python library for bioinformatics";
    longDescription = ''
      Biopython is a set of freely available tools for biological computation
      written in Python by an international team of developers. It is a
      distributed collaborative effort to develop Python libraries and
      applications which address the needs of current and future work in
      bioinformatics.
    '';
    homepage = "https://biopython.org/wiki/Documentation";
    maintainers = with lib.maintainers; [ luispedro ];
    license = lib.licenses.bsd3;
  };
}

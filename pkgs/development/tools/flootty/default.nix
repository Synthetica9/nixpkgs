{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "Flootty";
  version = "3.2.2";

  src = python3Packages.fetchFromPyPI {
    inherit pname version;
    sha256 = "0gfl143ly81pmmrcml91yr0ypvwrs5q4s1sfdc0l2qkqpy233ih7";
  };

  meta = with lib; {
    description = "A collaborative terminal. In practice, it's similar to a shared screen or tmux session";
    homepage = "https://floobits.com/help/flootty";
    license = licenses.asl20;
    maintainers = with maintainers; [ sellout ];
  };
}

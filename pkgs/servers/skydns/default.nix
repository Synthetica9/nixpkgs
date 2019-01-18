{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "skydns-${version}";
  version = "2.5.3a";
  rev = "${version}";
  

  src = fetchFromGitHub {
    inherit rev;
    owner = "skynetservices";
    repo = "skydns";
    sha256 = "0i1iaif79cwnwm7pc8nxfa261cgl4zhm3p2a5a3smhy1ibgccpq7";
  };

  goDeps = ./deps.nix;

  meta = {
    license = stdenv.lib.licenses.mit;
  };
}

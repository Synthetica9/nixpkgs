{stdenv, fetchurl, ocaml, lablgtk, findlib, libGLU_combined, freeglut, camlp4 } :

stdenv.mkDerivation rec {
  pname = "lablgl";
  version = "1.05";

  src = fetchurl {
    url = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/dist/lablgl-${version}.tar.gz";
    sha256 = "0qabydd219i4ak7hxgc67496qnnscpnydya2m4ijn3cpbgih7zyq";
  };

  buildInputs = [ocaml findlib lablgtk freeglut camlp4];
  propagatedBuildInputs = [ libGLU_combined ];

  patches = [ ./Makefile.config.patch ./META.patch ];

  preConfigure = ''
    substituteInPlace Makefile.config \
      --subst-var-by BINDIR $out/bin \
      --subst-var-by INSTALLDIR $out/lib/ocaml/${ocaml.version}/site-lib/lablgl \
      --subst-var-by DLLDIR $out/lib/ocaml/${ocaml.version}/site-lib/lablgl \
      --subst-var-by TKINCLUDES "" \
      --subst-var-by XINCLUDES ""
  '';

  createFindlibDestdir = true;

  buildFlags = "lib libopt glut glutopt";

  postInstall = ''
    cp ./META $out/lib/ocaml/${ocaml.version}/site-lib/lablgl
  '';

  meta = with stdenv.lib; {
    homepage = http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html;
    description = "OpenGL bindings for ocaml";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub vbgl ];
    broken = stdenv.isDarwin;
  };
}

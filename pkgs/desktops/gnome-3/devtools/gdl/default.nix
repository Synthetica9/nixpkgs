{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, gnome3, intltool }:

stdenv.mkDerivation rec {
  name = "gdl-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "f3ad03f9a34f751f52464e22d962c0dec8ff867b7b7b37fe24907f3dcd54c079";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gdl"; attrPath = "gnome3.gdl"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 gtk3 intltool ];

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

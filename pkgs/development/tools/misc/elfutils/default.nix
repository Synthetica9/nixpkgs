{ lib, stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext, xz, setupDebugInfoDirs }:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  name = "elfutils-${version}";
  version = "0.170";

  src = fetchurl {
    url = "https://sourceware.org/elfutils/ftp/${version}/${name}.tar.bz2";
    sha256 = "0rp0r54z44is49c594qy7hr211nhb00aa5y7z74vsybbaxslg10z";
  };

  patches = [
    ./debug-info-from-env.patch

    /* For gcc8. Fixes -Werror=packed-not-aligned errors.
    incorporated in upstream, so can probably be removed at next update */
    (fetchurl {
      url = http://git.openembedded.org/openembedded-core/plain/meta/recipes-devtools/elfutils/files/0001-Ensure-that-packed-structs-follow-the-gcc-memory-lay.patch?id=49aae1d75ff1c6a9643c30a8cc5776a2ffa83dd3;
      sha256 = "11sg2dn3vjvgq2fb9n8pgw1ajvs3gliks7djg1794wxlfg0rvifb";
    })
  ];

  hardeningDisable = [ "format" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ];
  buildInputs = [ zlib bzip2 xz ];

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  configureFlags =
    [ "--program-prefix=eu-" # prevent collisions with binutils
      "--enable-deterministic-archives"
    ];

  enableParallelBuilding = true;

  crossAttrs = {

    /* Having bzip2 will harm, because anything using elfutils
       as buildInput cross-building, will not be able to run 'bzip2' */
    propagatedBuildInputs = [ zlib.crossDrv ];

    # This program does not cross-build fine. So I only cross-build some parts
    # I need for the linux perf tool.
    # On the awful cross-building:
    # http://comments.gmane.org/gmane.comp.sysutils.elfutils.devel/2005
    #
    # I wrote this testing for the nanonote.
    buildPhase = ''
      pushd libebl
      make
      popd
      pushd libelf
      make
      popd
      pushd libdwfl
      make
      popd
      pushd libdw
      make
      popd
    '';

    installPhase = ''
      pushd libelf
      make install
      popd
      pushd libdwfl
      make install
      popd
      pushd libdw
      make install
      popd
      cp version.h $out/include
    '';
  };

  meta = {
    homepage = https://sourceware.org/elfutils/;
    description = "A set of utilities to handle ELF objects";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.eelco ];
  };
}

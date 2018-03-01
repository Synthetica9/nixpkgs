{ fetchurl, stdenv, jre, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  name = "jmeter-${version}";
  version = "4.0";
  src = fetchurl {
    url = "http://archive.apache.org/dist/jmeter/binaries/apache-${name}.tgz";
    sha256 = "1dvngvi6j8qb6nmf5a3gpi5wxck4xisj41qkrj8sjwb1f8jq6nw4";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out

    rm bin/*.bat bin/*.cmd

    cp -R * $out/

    substituteInPlace $out/bin/create-rmi-keystore.sh --replace \
      "keytool -genkey" \
      "${jre}/lib/openjdk/jre/bin/keytool -genkey"

    # Prefix some scripts with jmeter to avoid clobbering the namespace
    for i in heapdump.sh mirror-server mirror-server.sh shutdown.sh stoptest.sh create-rmi-keystore.sh; do
      mv $out/bin/$i $out/bin/jmeter-$i
      wrapProgram $out/bin/jmeter-$i \
        --prefix PATH : "${jre}/bin"
    done

    wrapProgram $out/bin/jmeter --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/jmeter.sh --set JAVA_HOME "${jre}"
  '';

  doInstallCheck = true;

  checkInputs = [ coreutils ];

  installCheckPhase = ''
    $out/bin/jmeter --version 2>&1 | grep -q "${version}"
    $out/bin/jmeter-heapdump.sh > /dev/null
    $out/bin/jmeter-shutdown.sh > /dev/null
    $out/bin/jmeter-stoptest.sh > /dev/null
    timeout --kill=1s 1s $out/bin/jmeter-mirror-server.sh || test "$?" = "124"
  '';

  meta = with stdenv.lib; {
    description = "A 100% pure Java desktop application designed to load test functional behavior and measure performance";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.garbas ];
    priority = 1;
    platforms = platforms.unix;
  };
}

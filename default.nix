with import <nixpkgs> { };

releaseTools.mvnBuild rec {
  name = "micro-benchmark";

  src = if lib.inNixShell then null else ./.;
  
  buildInputs = [
    openjdk8
    makeWrapper
    maven
    gnuplot
  ];

  doTest = false;

  doTestCompile = false;

  mvnJar = ''
    mvn package -Dmaven.repo.local=$M2_REPO
  '';

  mvnAssembly = ''
    true
  '';

  mvnRelease = ''
    mkdir -p $out/share/java $out/bin
    cp target/*.jar $out/share/java/${name}.jar
    makeWrapper ${openjdk8.out}/bin/java $out/bin/${name} \
      --add-flags "-jar $out/share/java/${name}.jar"
  '';
}

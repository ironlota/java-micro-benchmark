with import <nixpkgs> { };

lib.overrideDerivation (import ./.) (attrs: {
  shellHook   = ''
    export GCPRED_JAVA_HOME="$HOME/Projects/research/GC-Predictor-OpenJDK8/sources/openjdk8/build/linux-x86_64-normal-server-release/images/j2sdk-image"
    export PATH="$PATH:$GCPRED_JAVA_HOME/bin"
  '';
  buildInputs = attrs.buildInputs ++ [ ];
})

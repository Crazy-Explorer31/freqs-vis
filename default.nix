{
  pkgs ? import <nixpkgs> {},
  srcDir ? ./.,
  subdir ? "",
}: let
  theSource = srcDir;

  pythonPackage = pkgs.python313Packages.buildPythonPackage {
    pname = "freqs-vis";
    version = "1.0.0";

    src = ./.;
    format = "setuptools";

    nativeBuildInputs = [
      pkgs.python313Packages.setuptools
      pkgs.python313Packages.wheel
    ];

    propagatedBuildInputs = with pkgs.python313Packages; [
      librosa
      matplotlib
      seaborn
    ];

    meta = {
      description = "Audio's frequences visualization tool";
      license = pkgs.lib.licenses.mit;
    };
  };

  pythonEnv = pkgs.python313.buildEnv.override {
    extraLibs = [pythonPackage];
    ignoreCollisions = true;
  };
in
  pkgs.stdenv.mkDerivation rec {
    name = "freqs-vis";

    dontUnpack = true;

    buildInputs = [pythonEnv];

    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/${name} <<EOF
      #!${pkgs.bash}/bin/bash
      exec ${pythonEnv}/bin/python -m src.main "\$@"
      EOF
      chmod +x $out/bin/${name}
    '';

    meta = with pkgs.lib; {
      description = "Audio frequencies visualization tool";
      license = licenses.mit;
      mainProgram = name;
    };
  }

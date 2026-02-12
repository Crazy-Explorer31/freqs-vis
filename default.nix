{pkgs ? import <nixpkgs> {}}: let
  pythonPackage = pkgs.python313Packages.buildPythonPackage {
    pname = "freqs-vis";
    version = "1.0.0";

    src = ./.;
    format = "setuptools";

    nativeBuildInputs = with pkgs.python313Packages; [
      setuptools
      wheel
    ];

    propagatedBuildInputs = with pkgs.python313Packages; [
      librosa
      matplotlib
      seaborn
    ];
  };
  pythonEnv = pkgs.python313.buildEnv.override {
    extraLibs = [pythonPackage];
    ignoreCollisions = true;
  };
in
  pythonPackage.overrideAttrs (old: {
    buildInputs = [pythonEnv];
    postInstall =
      (old.postInstall or "")
      + ''
        mkdir -p $out/bin
        cat > $out/bin/freqs-vis <<EOF
        #!${pkgs.bash}/bin/bash
        exec ${pythonPackage}/bin/python -m src.main "\$@"
        EOF
        chmod +x $out/bin/freqs-vis
      '';
  })

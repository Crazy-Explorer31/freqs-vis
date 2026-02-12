{pkgs ? import <nixpkgs> {}}:
pkgs.python313Packages.buildPythonPackage {
  pname = "freqs-vis";
  version = "1.0.0";

  src = ./.;
  format = "other";

  dontBuild = true;

  propagatedBuildInputs = with pkgs.python313Packages; [
    librosa
    matplotlib
    seaborn
  ];

  installPhase = ''
    mkdir -p $out/${pkgs.python313.sitePackages}
    cp -r src $out/${pkgs.python313.sitePackages}/

    mkdir -p $out/bin
    cat > $out/bin/freqs-vis <<EOF
    #!${pkgs.python313}/bin/python
    from src.main import main
    import sys
    sys.exit(main())
    EOF
    chmod +x $out/bin/freqs-vis
  '';

  meta = with pkgs.lib; {
    description = "Audio frequencies visualization tool";
    license = licenses.mit;
    mainProgram = "freqs-vis";
  };
}

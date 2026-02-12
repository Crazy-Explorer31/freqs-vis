{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  pname = "freqs-vis";
  version = "1.0.0";

  src = ./.;

  dontUnpack = true;

  buildInputs = with pkgs; [
    python313
    python313Packages.numpy
    python313Packages.librosa
    python313Packages.matplotlib
    python313Packages.seaborn
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/python3.13/site-packages

    # Копируем исходники
    cp -r $src/src $out/lib/python3.13/site-packages/

    # Создаем враппер
    cat > $out/bin/freqs-vis <<EOF
    #!${pkgs.bash}/bin/bash
    export PYTHONPATH=$out/lib/python3.13/site-packages:\$PYTHONPATH
    exec ${pkgs.python313}/bin/python -m src.main "\$@"
    EOF
    chmod +x $out/bin/freqs-vis
  '';

  meta = with pkgs.lib; {
    description = "Audio frequencies visualization tool";
    license = licenses.mit;
    mainProgram = "freqs-vis";
  };
}

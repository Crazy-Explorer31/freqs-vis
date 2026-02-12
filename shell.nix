{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python313Packages.librosa
    python313Packages.matplotlib
    python313Packages.seaborn
  ];
}

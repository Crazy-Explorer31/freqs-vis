{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        freqs-vis = pkgs.callPackage ./default.nix {};
        development-shell = pkgs.callPackage ./shell.nix {};
      in rec {
        apps = {
          default = flake-utils.lib.mkApp {
            drv = freqs-vis;
          };
        };

        packages = {
          default = freqs-vis;
        };

        devShells = {
          default = development-shell;
        };
      }
    );
}

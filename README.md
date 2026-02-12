# freqs-vis

Fast polynomial multiplication using FFT algorithm.

## Usage

### From shell

```bash
# Build (stores a `result/` directory with `freqs-vis` executable and `libfft.so` library)
nix build github:Crazy-Explorer31/freqs-vis

# Run directly (runs `freqs-vis` executable in a current shell)
nix run github:Crazy-Explorer31/freqs-vis

# Development shell (gives access to `xcowsay` utility)
nix develop github:Crazy-Explorer31/freqs-vis
```

### Add to your system
Change your `flake.nix` like this:
```nix
{
  inputs = {
    # ADD INPUT
    freqs-vis.url = "github:Crazy-Explorer31/freqs-vis";
  };

  outputs = { self, nixpkgs, freqs-vis, ... }: { # SPECIFY IN ARGUMENTS
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          environment.systemPackages = with pkgs; [
            # ADD PACKAGE
            freqs-vis.packages.${system}.default
          ];
        }
      ];
    };
  };
}
```

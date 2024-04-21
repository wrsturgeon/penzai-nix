# [DeepMind](https://www.deepmind.com)'s [`penzai`](https://github.com/google-deepmind/penzai), built with [Nix](https://github.com/nixos/nix).

Please note that I don't own either of the above!
This is merely a reproducible method to build existing software.
If this works fantastically, all credit goes to DeepMind.
If it doesn't, it's probably my fault, so please open an issue or a PR!

The real repository for `penzai` (also linked in the title above) is [google-deepmind/penzai](https://github.com/google-deepmind/penzai).

## Use

This build system works with all Python versions, so all you need to do is hand it the package set you're using.
Note that, since it works with all Python versions, there is no `packages.${system}.default` attribute;
instead, there's `lib.with-pypkgs`, which takes a package-set argument.

For example, here's a simple `flake.nix`:
```nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    penzai.url = "github:wrsturgeon/penzai-nix";
  };
  outputs =
    { flake-utils, nixpkgs, penzai, self }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in {
        devShells.default = pkgs.mkShell {
          packages = [
            (pkgs.python311.withPackages (pypkgs: [
              # ... some Python dependencies ...
              (penzai.lib.with-pypkgs pypkgs)
              # ... more Python dependencies ...
            ]))
          ];
        };
      }
    );
}
```

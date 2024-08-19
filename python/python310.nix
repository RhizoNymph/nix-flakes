{
  description = "Python 3.10 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base.url = "github:rhizonymph/nix-flakes?dir=.&file=base-dev.nix";
  };

  outputs = { self, nixpkgs, flake-utils, base }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        baseEnv = base.devShell.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = baseEnv.buildInputs ++ (with pkgs; [
            python310
            python310Packages.pip
            python310Packages.venv
            poetry
          ]);

          shellHook = baseEnv.shellHook + ''
          '';
        };
      });
}

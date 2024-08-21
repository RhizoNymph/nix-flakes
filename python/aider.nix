{
  description = "Aider";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base.url = "github:rhizonymph/nix-flakes?dir=python&file=python310.nix";
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
            aider-chat
          ]);

          shellHook = baseEnv.shellHook + ''
          '';
        };
      });
}

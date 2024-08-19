{
  description = "Rust nightly development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    base.url = "github:rhizonymph/nix-flakes?dir=.&file=base-dev.nix";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, base }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        baseEnv = base.devShell.${system};
      in
      { 
        devShell = pkgs.mkShell {
          buildInputs = baseEnv.buildInputs ++ [
            (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
            pkgs.rust-analyzer
            pkgs.cargo-edit
          ];

          shellHook = baseEnv.shellHook + ''
          '';
        };
      });
}

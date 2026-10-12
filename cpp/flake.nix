{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          dprint # Markdown
          alejandra # Nix code formatter
          nixd # Nix language server
          taplo # TOML toolkit
          gcc
          gnumake
          lldb
          clang-tools
        ];
        shellHook = ''
          echo "uwu"
        '';
      };
    });
}

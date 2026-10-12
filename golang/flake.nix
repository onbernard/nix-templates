{
  description = "Golang flake template";

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
      packages.default = pkgs.buildGoModule {
        pname = "app"; # Match the module name in go.mod
        version = "0.1.0";
        src = ./.;
        # null while there are no dependencies; then set to pkgs.lib.fakeHash
        # and copy the real hash from the build error
        vendorHash = null;
        meta.mainProgram = "app";
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          dprint # Markdown
          alejandra # Nix code formatter
          nixd # Nix language server
          taplo # TOML toolkit
          go
          gopls # Go language server
          gotools # goimports, ...
          go-tools # staticcheck
          golangci-lint # Linter
          delve # Debugger
        ];
        env = {
          # Use the Go from nixpkgs instead of downloading the one go.mod asks for
          GOTOOLCHAIN = "local";
        };
      };
    });
}

{
  description = "Zig template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    zig-overlay,
    zls,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [zig-overlay.overlays.default];
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            dprint # Markdown
            alejandra # Nix code formatter
            nixd # Nix language server
            taplo # TOML toolkit
            # pkgs.zls
            # pkgs.zig
            zls.inputs.zig-flake.packages.${system}.nightly # Zig matching zls master
            zls.packages.${system}.zls
            # zig-overlay.packages.${system}.master # Latest version
            pkgs.lldb # Debugger
          ];
        };
      }
    );
}

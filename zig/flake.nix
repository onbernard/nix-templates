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

  outputs = inputs @ {self, ...}:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [zig-overlay.overlays.default];
          };
        in {
          devShell = pkgs.mkShell {
            packages = [
              # pkgs.zls
              # pkgs.zig
              zls.inputs.zig-overlay.packages.${system}.default
              zls.packages.${system}.zls
              # zig-overlay.packages.${system}.master # Latest version
            ];
          };
        }
      );
}

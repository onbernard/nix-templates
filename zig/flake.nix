{
  description = "Zig template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:
  with inputs;
  let
    allSystems = [ "x86_64-linux" "aarch64-linux" "x86-64-darwin" "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
      inherit system;
      pkgs = import nixpkgs {
        inherit system; 
        overlays = [ zig-overlay.overlays.default ];
      };
    });
  in
  {
    devShell = forAllSystems ({ pkgs, system }:
      pkgs.mkShell {
        buildInputs = [
          pkgs.gcc
          pkgs.zigpkgs.master
          zls.packages.${system}.zls
        ];
      });
  };
}

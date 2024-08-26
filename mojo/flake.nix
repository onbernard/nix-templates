{
  description = "Mojo template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rules_mojo.url = "github:TraceMachina/rules_mojo";
  };

  outputs = inputs@{ self, nixpkgs, rules_mojo, ... }:
  let
    allSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86-64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
      inherit system;
      pkgs = import nixpkgs {
        inherit system; 
        overlays = [
        ];
      };
    });
  in
  {
    devShell = forAllSystems ({ pkgs, system }:
      pkgs.mkShell {
        buildInputs = [
          rules_mojo.packages.${system}.mojo
        ];
        shellHook = ''
          mojo --version
        '';
      });
  };
}

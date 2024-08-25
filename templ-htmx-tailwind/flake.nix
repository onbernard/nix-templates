{
  description = "Skeleton project in Go with templ htmx, tailwind and air";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    templ.url = "github:a-h/templ";
  };

  outputs = inputs@{ self, nixpkgs, templ, ... }:
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
          templ.overlays.default
        ];
      };
    });
  in
  {
    devShell = forAllSystems ({ pkgs, system }:
      pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          gopls
          gotools
          go-tools
          air
          templ.packages.${system}.templ
          tailwindcss
        ];
      });
  };
}

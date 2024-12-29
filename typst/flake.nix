{
  description = "Typst flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";    
  };

  outputs = inputs@{ self, ... }:
  with inputs;
  {
    devShells.x86_64-linux.default = 
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; overlays = []; };
    in
    pkgs.mkShell {
      buildInputs = with pkgs; [
        typst        
        atkinson-hyperlegible
        atkinson-monolegible
        font-awesome
      ];
      shellHook = ''
        export TYPST_FONT_PATHS="/home/$USER/.nix-profile/share/fonts:${pkgs.font-awesome}"
      '';
    };
  };
}

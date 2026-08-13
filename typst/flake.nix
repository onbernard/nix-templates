{
  description = "Typst template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          dprint # Markdown formatter
          alejandra # Nix formatter
          nixd # Nix language server
          taplo # TOML toolkit
          typst
          atkinson-hyperlegible
          atkinson-monolegible
          font-awesome
        ];
        shellHook = ''
          export TYPST_FONT_PATHS="${pkgs.atkinson-hyperlegible}/share/fonts:${pkgs.atkinson-monolegible}/share/fonts:${pkgs.font-awesome}/share/fonts"
        '';
      };
    });
}

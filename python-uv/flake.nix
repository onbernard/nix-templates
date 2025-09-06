{
  description = "Python project with uv template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {self, ...}:
    with inputs;
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlay = [];
        };
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            dprint # Markdown
            alejandra # Nix code formatter
            nixd # Nix language server
            taplo # TOML toolkit
            pyright # Python type checker
            ruff # Python linter
            black # Python code formatter
          ];
          shellHook = ''
            uv sync && source .venv/bin/activate
          '';
        };
      });
}

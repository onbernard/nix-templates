{
  description = "Skeleton project in Python with fastapi, htmx and tailwind";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, ... }:
  with inputs;
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; overlays = []; };
  in
  {
    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [ rye tailwindcss ];
      shellHook = ''
        rye sync && source .venv/bin/activate
      '';
    };
  });
}

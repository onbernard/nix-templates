{
  description = "Skeleton project in Python with fastapi, htmx and tailwind";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
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
    packages = forAllSystems ({ pkgs, system}: 
    {
      devserver = pkgs.writeScriptBin "devserver" ''
        tailwindcss -i tailwindcss/styles/app.css -o static/css/app.css
        DEBUG="." uvicorn my_project:app --reload
      '';
    });

    devShell = forAllSystems ({ pkgs, system }:
      pkgs.mkShell {
        buildInputs = with pkgs; [
          rye
          tailwindcss
        ];
        shellHook = ''
          rye sync && source .venv/bin/activate
        '';
      });
  };
}

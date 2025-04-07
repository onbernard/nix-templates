{
  description = "Typst template";

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
      packages = with pkgs; [
        typst        
        atkinson-hyperlegible
        atkinson-monolegible
        font-awesome
        (pkgs.writeShellScriptBin "startTypstWatch" ''
          if [ "$#" -eq 0 ]; then
            echo "Usage: $0 file1.typ file2.typ ..."
            exit 1
          fi
          > pids.txt
          for file in "$@"; do
            typst watch "$file" &
            echo $! >> pids.txt
          done
        '')
        (pkgs.writeShellScriptBin "stopTypstWatch" ''
          cat pids.txt | xargs kill
          rm pids.txt
        '')
      ];
      shellHook = ''
        export TYPST_FONT_PATHS="/home/$USER/.nix-profile/share/fonts:${pkgs.font-awesome}"
      '';
    };
  };
}

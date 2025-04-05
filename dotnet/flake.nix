{
  description = "Dotnet flake";

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
            (with dotnetCorePackages;
              combinePackages [
                sdk_8_0
                dotnet_8.aspnetcore
                dotnet_8.runtime
              ])
            nuget-to-nix
            nuget-to-json
          ];
          shellHook = ''
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
          '';
        };
      });
}

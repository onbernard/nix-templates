{
  description = "ADS template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, ... }:
  with inputs;
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; overlay = [];};
    
    pyads = pkgs.python3Packages.pyads;
    gccLib = pkgs.gcc-unwrapped.lib;
    pythonEnv = pkgs.python3.withPackages (ps: with ps; [ pyads ]);

    ads-proxy = pkgs.rustPlatform.buildRustPackage {
      pname = "ads-proxy";
      version = "0.9.7";
      src = pkgs.fetchFromGitHub {
        owner = "fengyc";
        repo = "ads-proxy";
        rev = "v0.9.7";
        hash = "sha256-JsjFmx63qChv1vHhFhaU7hN/KoNX5jZ0x9sBce7voeU=";
      };
      useFetchCargoVendor = true;
      cargoHash = "sha256-ARCFBiRysrnepUalnrIGNg3HlyMtLbdvZn4Qnx7VMUo=";
    };


  in
  {
    packages = {
      AdsRouterConsoleApp = AdsRouterConsoleApp;
      ads-proxy = ads-proxy;
    };

    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [
        ads-proxy
        adslib
        pythonEnv
        gccLib
        haproxy
      ];
      shellHook = ''
        export LD_LIBRARY_PATH=${gccLib}/lib:$LD_LIBRARY_PATH
      '';
    };
  });
}

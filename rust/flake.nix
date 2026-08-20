{
  description = "Rust template";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}:
    with inputs;
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            rust-overlay.overlays.default
            (final: prev: {
              rustToolchain = final.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
            })
          ];
        };
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            # (pkgs.rustPlatform.buildRustPackage {
            #   pname = ""; # Copy from cargo.toml
            #   version = ""; # Copy from cargo.toml
            #   src = pkgs.fetchFromGitHub {
            #     owner = "";
            #     repo = "";
            #     rev = ""; # branch
            #     hash = "";
            #   };
            #   cargoHash = "";
            # })
            rustToolchain
            cargo-bloat
            cargo-edit
            cargo-outdated
            cargo-udeps
            cargo-watch
            stdenv.cc.cc.lib
            lldb
            # ...
            dprint # Markdown
            alejandra # Nix formatter
            nixd # Nix language server
            taplo # TOML toolkit
          ];
          env = {
            RUST_BACKTRACE = "1";
            RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc];
          };
        };
      });
}

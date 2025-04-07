{
  description = "Collection of nix templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {...}: {
    templates = {
      templ-htmx-tailwind = {
        path = ./templ-htmx-tailwind;
        description = "Skeleton project in Go setup with templ, htmx, tailwind and air";
        welcomeText = ''
          # Skeleton project in Go setup with templ, htmx, tailwind and air
        '';
      };
      fastapi-htmx-tailwind = {
        path = ./fastapi-htmx-tailwind;
        description = "Skeleton project in Pythn setup with fastapi, tailwind and htmx";
      };
      mojo = {
        path = ./mojo;
        description = "Mojo template";
      };
      zig = {
        path = ./zig;
        description = "Zig template";
      };
      python-rye = {
        path = ./python-rye;
        description = "Python with rye template";
        welcomeText = ''
          # Getting started
          - Run `nix develop`
          - Run `rye init && rye sync`
        '';
      };
      python-uv = {
        path = ./python-uv;
        description = "Python with uv template";
        welcomeText = ''
          # Getting started
          - Run `nix develop`
          - Run `uv init && uv sync`
        '';
      };
      basic-template = {
        path = ./basic-template;
        description = "A basic template";
      };
      rust = {
        path = ./rust;
        description = "Rust template";
      };
      typst = {
        path = ./typst;
        description = "Typst template";
      };
      dotnet = {
        path = ./dotnet;
        description = "Dotnet template";
      };
      ads = {
        path = ./ads;
        description = "ADS template";
      };
    };
  };
}

{
  description = "Collection of nix templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, ... }:
    with inputs;
    {
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
      };
    };
}

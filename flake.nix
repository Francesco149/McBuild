{
  description = "McBuild development nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # TODO: would be cool to make an open compatible alternative to libbass if it doesn't exist
          config.allowUnfree = true;
          config.allowBroken = true;
          overlays = [
            (import ./custom-packages.nix)
          ];
        };
      in {
        # use nix-shell or nix develop to access this shell
        devShell = with pkgs;
          mkShell {
              buildInputs = [
                nixpkgs-fmt
                ninja
                meson
                pkg-config
                cmake
                miniz
                glew
                freetype
                xorg.libX11
                libjpeg
                xorg.libXi
                libbass
                libbass_fx
              ];
            };
      }
    );
}

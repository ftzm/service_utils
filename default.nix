{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation}:

let
  configurator = import ./k8s/default.nix {};
  utility_make = import ./make/default.nix {configurator=configurator;};
in
  utility_make

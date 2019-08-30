{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation}:

let
  configurator = import ./k8s/default.nix {};
  utility_make = import ./make/default.nix {configurator=configurator;};
  printer = pkgs.writeScriptBin "print-utils-make" ''
    echo ${utility_make}/utils.mk
  '';
in
  utility_make

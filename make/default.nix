{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation, configurator}:

let
  a = 1;
in
  mkDerivation {
    name = "utility_make";
    src = ./src;
    phases = "unpackPhase buildPhase";
    version = "0.1";
    buildInputs = [ ];
    buildPhase = ''
      mkdir $out
      cp -r $src/* $out
      substituteInPlace $out/utils.mk --replace mkService ${configurator}/mkService
      substituteInPlace $out/utils.mk --replace getKey ${configurator}/getKey
    '';
  }

{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation}:

let
  dhall_yaml_bins = import ./dhall_yaml_bins.nix {};
  dhall_bin = import ./dhall_bin.nix {};
  dhall_repo = import ./dhall_repo.nix {};
  dhall_kubernetes = import ./dhall_kubernetes.nix {};
  dhall_prelude = "${dhall_repo}/Prelude/package.dhall";
  dk_types = "${dhall_kubernetes}/types.dhall";
  dk_defaults = "${dhall_kubernetes}/defaults.dhall";
  dk_1_17 = "${dhall_kubernetes}/1.17/package.dhall";
in
  mkDerivation {
    name = "configurator";
    src = ./src;
    phases = "unpackPhase buildPhase";
    version = "0.1";
    buildInputs = [ pkgs.makeWrapper ];
    buildPhase = ''
      mkdir $out
      cp -r $src/* $out

      wrapProgram $out/mkService \
        --set DHALL_KUBERNETES ${dk_1_17} \
        --set DHALL_KUBERNETES_TYPES ${dk_types} \
        --set DHALL_KUBERNETES_DEFAULTS ${dk_defaults} \
        --set DHALL_PRELUDE ${dhall_prelude} \
        --set DHALL_YAML ${dhall_yaml_bins}/bin/dhall-to-yaml

      wrapProgram $out/getKey \
        --set DHALL ${dhall_bin}/bin/dhall
    '';
  }

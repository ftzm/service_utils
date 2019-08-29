{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation}:

let
  dhall_bins = import ./dhall_bins.nix {};
  dhall_repo = pkgs.fetchFromGitHub {
    owner = "dhall-lang";
    repo = "dhall-lang";
    rev = "68fa5fd7aecafd56da107922b7386cd10688ca95";
    sha256 = "0fkmi5zvdv93mpazzj7fl19lv2wnmyf0dm09id2xvabqvvqw3zvz";
  };
  dhall_prelude = "${dhall_repo}/Prelude/package.dhall";
  dhall_kubernetes = pkgs.fetchFromGitHub {
    owner = "dhall-lang";
    repo = "dhall-kubernetes";
    rev = "4ad58156b7fdbbb6da0543d8b314df899feca077";
    sha256 = "12fm70qbhcainxia388svsay2cfg9iksc6mss0nvhgxhpypgp8r0";
  };
  dk_types = "${dhall_kubernetes}/types.dhall";
  dk_defaults = "${dhall_kubernetes}/defaults.dhall";
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
        --set DHALL_KUBERNETES_TYPES ${dk_types} \
        --set DHALL_KUBERNETES_DEFAULTS ${dk_defaults} \
        --set DHALL_PRELUDE ${dhall_prelude} \
        --set DHALL_YAML ${dhall_bins}/bin/dhall-to-yaml
    '';
  }

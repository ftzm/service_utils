{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation}:

pkgs.fetchFromGitHub {
    owner = "dhall-lang";
    repo = "dhall-kubernetes";
    rev = "3c6d09a9409977cdde58a091d76a6d20509ca4b0";
    sha256 = "1r4awh770ghsrwabh5ddy3jpmrbigakk0h32542n1kh71w3cdq1h";
}

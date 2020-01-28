{ pkgs ? import <nixpkgs> { }, mkDerivation ? pkgs.stdenv.mkDerivation}:

pkgs.fetchFromGitHub {
  owner = "dhall-lang";
  repo = "dhall-lang";
  rev = "8cf71d94bd63710faae018aac0920b937b977b11";
  sha256 = "1z7gd35xs5n2n8ai9m7f00s78h6v77gqa3fqfs8nmpx31cxfip1q";
}

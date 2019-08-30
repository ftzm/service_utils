(import <nixpkgs> {}).stdenv.mkDerivation {
  name = "print";
  shellHook = ''
    echo ${import ./default.nix {}}/utils.mk
  '';
}

{ callPackage, ... } @ args:

callPackage ./generic-v3.nix ({
  version = "3.1.0";
  sha256 = "sha256-kWyPkR8grWCO2Sl9qMAd0albjuu0508m4DbBh6u+m2I=";
} // args)

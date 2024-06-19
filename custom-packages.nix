# nixpkgs overlay that adds my custom packages

self: super: with super; {

  self.maintainers = super.maintainers.override {
    lolisamurai = {
      email = "lolisamurai@animegirls.xyz";
      github = "Francesco149";
      githubId = 973793;
      name = "lolisamurai";
    };
  };

  libbassAll = callPackage ./libbass/default.nix { };
  libbass = self.libbassAll.bass;
  libbass_fx = self.libbassAll.bass_fx;
}

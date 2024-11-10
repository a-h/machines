# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, system, inputs }: {
  home-manager = inputs.home-manager.defaultPackage.${system};
  flakegap = inputs.flakegap.packages.${system}.default;
  goreplace = pkgs.callPackage ../custom-packages/goreplace.nix { };
}

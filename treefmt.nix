{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    black.enable = true;
    toml-sort.enable = true;
    mdformat.enable = true;
    yamlfmt.enable = true;
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };
  };
}

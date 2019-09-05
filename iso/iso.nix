{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../config/colors.nix
    ../config/git.nix
  ];
  environment.systemPackages = let
    os-config = (with import <nixpkgs> {}; writeShellScriptBin "os-config" ''
      cd ~
      git clone --depth 1 'https://github.com/isaacwhanson/starlight-os.git' starlight-os
      cd starlight-os
      make configure
    '');
    os-install = (with import <nixpkgs> {}; writeShellScriptBin "os-install" ''
      cd ~/starlight-os
      make install
    '');
    in [ pkgs.gnumake (os-config) (os-install) ];
}

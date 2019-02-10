{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../config/git.nix
  ];
  environment.systemPackages = with pkgs; [
    gnumake
    (with import <nixpkgs> {}; writeShellScriptBin "os-config" ''
      cd ~
      git clone --depth 1 'https://github.com/isaacwhanson/starlight-os.git' starlight-os
      cd starlight-os
      make configure
    '')
    (with import <nixpkgs> {}; writeShellScriptBin "os-install" ''
      cd ~/starlight-os
      make install
    '')
  ];
}

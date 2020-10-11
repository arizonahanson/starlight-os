{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../config/colors.nix
    ../config/git.nix
  ];
  environment.systemPackages =
    let
      os-config = (
        with import <nixpkgs> { }; writeShellScriptBin "os-config" ''
          git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git ~/starlight-os || exit 1
          cd ~/starlight-os || exit 1
          bash scripts/partition
          bash scripts/config
          echo "Edit the file '/mnt/etc/nixos/configuration.nix' then run 'os-install'."
        ''
      );
      os-install = (
        with import <nixpkgs> { }; writeShellScriptBin "os-install" ''
          nixos-install --no-root-passwd --root /mnt
        ''
      );
    in
    [ pkgs.gnumake (os-config) (os-install) ];
}

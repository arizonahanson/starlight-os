{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];
  options.starlight = {
    hostname = mkOption {
      type = types.str;
      description = ''
        hostname
      '';
    };
    logo = mkOption {
      type = types.str;
      default = "• ";
      description = ''
        Text logo
      '';
    };
    palette = {
      foreground = mkOption {
        type = types.str;
        default = "#c7c7c7";
        description = ''
          Foreground color
        '';
      };
      foreground-alt = mkOption {
        type = types.str;
        default = "#787878";
        description = ''
          Alternate foreground color
        '';
      };
      background = mkOption {
        type = types.str;
        default = "#212121";
        description = ''
          Background color
        '';
      };
      background-alt = mkOption {
        type = types.str;
        default = "#404040";
        description = ''
          Background color
        '';
      };
      color0 = mkOption {
        type = types.str;
        default = "#212121";
        description = ''
          color 0 (black)
        '';
      };
      color1 = mkOption {
        type = types.str;
        default = "#cc6666";
        description = ''
          color 1 (red)
        '';
      };
      color2 = mkOption {
        type = types.str;
        default = "#638f63";
        description = ''
          color 2 (green)
        '';
      };
      color3 = mkOption {
        type = types.str;
        default = "#8f7542";
        description = ''
          color 3 (brown)
        '';
      };
      color4 = mkOption {
        type = types.str;
        default = "#59748f";
        description = ''
          color 4 (blue)
        '';
      };
      color5 = mkOption {
        type = types.str;
        default = "#85678f";
        description = ''
          color 5 (magenta)
        '';
      };
      color6 = mkOption {
        type = types.str;
        default = "#5e8d87";
        description = ''
          color 6 (cyan)
        '';
      };
      color7 = mkOption {
        type = types.str;
        default = "#787878";
        description = ''
          color 7 (white)
        '';
      };
      color8 = mkOption {
        type = types.str;
        default = "#404040";
        description = ''
          color 8 (dark gray)
        '';
      };
      color9 = mkOption {
        type = types.str;
        default = "#de985f";
        description = ''
          color 9 (orange)
        '';
      };
      color10 = mkOption {
        type = types.str;
        default = "#85cc85";
        description = ''
          color 10 (bright green)
        '';
      };
      color11 = mkOption {
        type = types.str;
        default = "#f0c674";
        description = ''
          color 11 (yellow)
        '';
      };
      color12 = mkOption {
        type = types.str;
        default = "#8fadcc";
        description = ''
          color 12 (bright blue)
        '';
      };
      color13 = mkOption {
        type = types.str;
        default = "#b093ba";
        description = ''
          color 13 (bright magenta)
        '';
      };
      color14 = mkOption {
        type = types.str;
        default = "#8abeb7";
        description = ''
          color 14 (bright cyan)
        '';
      };
      color15 = mkOption {
        type = types.str;
        default = "#c7c7c7";
        description = ''
          color 15 (bright white)
        '';
      };
    };
  };
  config = mkMerge [
    {
  # latest kernel
  nixpkgs.config.allowUnfree = true;
  nix.autoOptimiseStore = true;
  networking.hostName = (config.starlight.hostname);
  environment.systemPackages = with pkgs; [
    gnumake bc
    psmisc pciutils
    tree ag
    zip unzip
    duperemove
    nox
    (with import <nixpkgs> {}; writeShellScriptBin "colorpanes" ''
      #!/usr/bin/env bash
      # Author: GekkoP
      # Source: http://linuxbbq.org/bbs/viewtopic.php?f=4&t=1656#p33189
      f=3 b=4
      for j in f b; do
        for i in {0..7}; do
            printf -v $j$i %b "\e[''${!j}''${i}m"
        done
      done
      d=$'\e[1m'
      t=$'\e[0m'
      v=$'\e[7m'
      cat << EOF
      $f0████$d▄$t  $f1████$d▄$t  $f2████$d▄$t  $f3████$d▄$t  $f4████$d▄$t  $f5████$d▄$t  $f6████$d▄$t  $f7████$d▄$t
      $f0████$d█$t  $f1████$d█$t  $f2████$d█$t  $f3████$d█$t  $f4████$d█$t  $f5████$d█$t  $f6████$d█$t  $f7████$d█$t
      $f0████$d█$t  $f1████$d█$t  $f2████$d█$t  $f3████$d█$t  $f4████$d█$t  $f5████$d█$t  $f6████$d█$t  $f7████$d█$t
      $d$f0 ▀▀▀▀  $d$f1 ▀▀▀▀   $f2▀▀▀▀   $f3▀▀▀▀   $f4▀▀▀▀   $f5▀▀▀▀   $f6▀▀▀▀   $f7▀▀▀▀$t
      EOF
    '')
  ];
  environment.variables = {
      EDITOR = "vim";
  };

  services.openssh.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile
  '';
  # btrfs auto-scrub
  services.btrfs.autoScrub.enable = true;
  boot = {
    # /tmp on tmpfs
    tmpOnTmpfs = true;
    kernelParams = [ "quiet" ];
    consoleLogLevel = 0;
    loader.grub.useOSProber = true;
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
    };
  };
  fileSystems = {
    "/".options = [ "compress=lzo" ];
    "/home".options = [ "compress=lzo" ];
  };

  # default user account
  users.users.admin = {
    isNormalUser = true;
    uid = 1000;
    description = "Administrator";
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$D85LJu3AY7$CSbcP8wY9qNgp6zA.PXAmZo6JMy4nHDldvfUDzom7XglfgRUPW6wnLJ1l0dRUQAy4SReAO85GEISAs6tZE6TV/";
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.mutableUsers = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
    }
  ];
}

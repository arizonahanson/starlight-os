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
  };
  config = mkMerge [{
    # btrfs auto-scrub
    #services.btrfs.autoScrub.enable = true;
    #nix.autoOptimiseStore = true;
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
    networking.hostName = (config.starlight.hostname);
    nixpkgs.config.allowUnfree = true;
    environment.pathsToLink = [ "/include" ];
    environment.systemPackages = with pkgs; [
      gnumake bc gcc
      psmisc pciutils
      tree ag fzf
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
    services.openssh.enable = true;
    services.journald.extraConfig = ''
      Storage=volatile
    '';
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
  }];
}

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./networking.nix
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];
  options.starlight = {
    localTime = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use local time (dual boot)
      '';
    };
    insertCursor = mkOption {
      type = types.int;
      default = 5;
      description = ''
        cursor code for insert mode
      '';
    };
    replaceCursor = mkOption {
      type = types.int;
      default = 3;
      description = ''
        cursor code for replace mode
      '';
    };
    commandCursor = mkOption {
      type = types.int;
      default = 1;
      description = ''
        cursor code for command mode
      '';
    };
  };
  config = {
    nix.autoOptimiseStore = true;
    nixpkgs.config.allowUnfree = true;
    boot = {
      tmpOnTmpfs = true;
      kernelParams = [ "quiet" ];
      consoleLogLevel = 0;
      kernel.sysctl = {
        "vm.max_map_count" = 262144;
      };
    };
    time.hardwareClockInLocalTime = config.starlight.localTime;
    fileSystems = {
      "/".options = [ "compress-force=zstd" ];
      "/home".options = [ "compress-force=zstd" ];
    };
    # default user account
    users = {
      users.starlight =
        let
          virtual = config.virtualisation.virtualbox.guest.enable;
        in
        {
          isNormalUser = true;
          uid = 1000;
          description = "Administrator";
          extraGroups = [ "wheel" ] ++ optional virtual "vboxsf";
          initialHashedPassword = "$6$D85LJu3AY7$CSbcP8wY9qNgp6zA.PXAmZo6JMy4nHDldvfUDzom7XglfgRUPW6wnLJ1l0dRUQAy4SReAO85GEISAs6tZE6TV/";
        };
      defaultUserShell = "/run/current-system/sw/bin/zsh";
      mutableUsers = true;
    };
    systemd = {
      tmpfiles.rules = [
        "d /run/cache/ 1771 - users"
        "d /var/config/ 1771 - users 8w"
        "e /var/tmp/ - - - 2w"
      ];
    };
    security.pam.makeHomeDir.skelDirectory = "/etc/skel";
    # more entropy
    services = {
      haveged.enable = true;
      journald.extraConfig = ''
        Storage=volatile
      '';
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
      };
    };
    # gnupg agent
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = !config.starlight.desktop;
      pinentryFlavor = if config.starlight.desktop then "gnome3" else "curses";
    };
    environment = {
      etc."skel/.config/nixpkgs/config.nix" = {
        text = ''
          { allowUnfree = true; }
        '';
      };
      variables = {
        XDG_CACHE_HOME = "/run/cache/$UID";
        XDG_CONFIG_HOME = "/var/config/$UID";
      };
      systemPackages = with pkgs; [
        ag
        bc
        binutils
        calc
        compsize
        duperemove
        fzf
        gcc
        gnumake
        gnupg
        ncdu
        nox
        pciutils
        psmisc
        shellcheck
        stow
        tree
        units
        unrar
        unzip
        zip
      ] ++ optional config.starlight.efi gptfdisk;
    };
    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you should.
    system.stateVersion = "20.09";
  };
}

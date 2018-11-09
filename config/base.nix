{ config, pkgs, ... }:

{
  imports = [
    ./vim.nix
    ./zsh.nix
    ./git.nix
  ];
  environment.systemPackages = with pkgs; [
    gnumake
    wget w3m
    psmisc
    tree ag
    ranger
    unzip
    python
    tmux
  ];

  # btrfs auto-scrub
  services.btrfs.autoScrub.enable = true;
  # /tmp on tmpfs
  boot.tmpOnTmpfs = true;

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
  system.stateVersion = "18.09"; # Did you read the comment?
}

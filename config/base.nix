{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnumake git
    wget
    vim
    zsh
    pstree
    tree
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.zsh.syntaxHighlighting = {
    enable = true;
    highlighters = [ "main" "brackets" "cursor" "root" "line" ];
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    uid = 1000;
    description = "Administrator";
    extraGroups = [ "wheel" ];
    shell = "/run/current-system/sw/bin/zsh";
    initialHashedPassword = "$6$D85LJu3AY7$CSbcP8wY9qNgp6zA.PXAmZo6JMy4nHDldvfUDzom7XglfgRUPW6wnLJ1l0dRUQAy4SReAO85GEISAs6tZE6TV/";
  };
  users.mutableUsers = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}

{ config, pkgs, ... }:

{
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  services.nixosManual.enable = true;
  services.nixosManual.showManual = true;
}

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wine
  ];
  boot.binfmtMiscRegistrations.DOSWin = {
    interpreter = "{pkgs.wine}/bin/wine";
    magicOrExtension = "MZ";
  };
}

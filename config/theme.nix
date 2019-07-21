{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment.variables = {
      GREP_COLORS="mt=100;97:sl=:cx=:fn=34:ln=01;30:bn=32:se=37";
    };
    environment.systemPackages = 
      let
        starlight-gtk-theme = with pkgs; stdenv.mkDerivation rec {
          name = "starlight-gtk-theme-v1.0";
          src = fetchFromGitHub {
            owner = "isaacwhanson";
            repo = "starlight-gtk-theme";
            rev = "v1.0";
            sha256 = "0pcrfdaw35s6yfq83f33rif4i5w3xpcarg7dhn2w45ip16b7ss9a";
          };
              
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/share/themes/starlight/
            cp -r . $out/share/themes/starlight/
          '';
        };
        starlight-icon-theme = with pkgs; stdenv.mkDerivation rec {
          name = "starlight-icon-theme-v1.0";
          src = fetchFromGitHub {
            owner = "isaacwhanson";
            repo = "starlight-icon-theme";
            rev = "v1.0";
            sha256 = "1bqydmzkialx95wf5s9vz3nqgmmajwacbwcrm3c98r1bddfyw3a7";
          };
              
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/share/icons/starlight/
            cp -r . $out/share/icons/starlight/
          '';
        };
      in
    with pkgs; [
      bibata-cursors gtk-engine-murrine
      (starlight-gtk-theme) (starlight-icon-theme)
    ];
  };
}


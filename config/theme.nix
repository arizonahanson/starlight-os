{ config, pkgs, ... }:

{
  environment.systemPackages = 
    let
      starlight-gtk-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-gtk-theme-v0.2";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-gtk-theme";
          rev = "v0.2";
          sha256 = "06di96x5maxmwn0f2ja3fbap8gnqrk4da5yb2aa0lc44j82axs10";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/themes/starlight/
          cp -r . $out/share/themes/starlight/
        '';
      };
      starlight-icon-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-icon-theme-v0.1";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-icon-theme";
          rev = "v0.1";
          sha256 = "049l802ka113rifw5hkv6a88jl25yaqcs1004vk31i96d6yvnl0w";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/icons/starlight/
          cp -r . $out/share/icons/starlight/
        '';
      };
    in
  with pkgs; [
    capitaine-cursors gtk-engine-murrine
    (starlight-gtk-theme) (starlight-icon-theme)
  ];
}


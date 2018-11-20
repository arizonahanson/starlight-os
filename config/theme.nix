{ config, pkgs, ... }:

{
  environment.systemPackages = 
    let
      starlight-gtk-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-gtk-theme-v0.3";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-gtk-theme";
          rev = "v0.3";
          sha256 = "18f412j8m1mr3w62q3gc1fx6s4b2426d6yc6qjpvvnn3fdf5a8zq";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/themes/starlight/
          cp -r . $out/share/themes/starlight/
        '';
      };
      starlight-icon-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-icon-theme-v0.2";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-icon-theme";
          rev = "v0.2";
          sha256 = "1d09zfpfsisc0ip81y278bvdjj1kf4hlrzgzyjxack3ki617y811";
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


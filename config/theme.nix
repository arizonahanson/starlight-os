{ config, pkgs, ... }:

{
  environment.systemPackages = 
    let
      starlight-gtk-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-gtk-theme-v0.8";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-gtk-theme";
          rev = "v0.8";
          sha256 = "1xq63vvg9h752l00zw80vxwq04d14aax02x5d6nhszbx4kh5kb0s";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/themes/starlight/
          cp -r . $out/share/themes/starlight/
        '';
      };
      starlight-icon-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-icon-theme-v0.4";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-icon-theme";
          rev = "v0.4";
          sha256 = "0bhgv3qwyky1rp2anp6j3xsjlwxgk3lvmfr803w2njgs07546aw5";
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


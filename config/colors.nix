{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    # system colors
    palette = {
      color00 = mkOption {
        type = types.str;
        default = "#101010";
        description = ''
          color 0 (black)
        '';
      };
      color01 = mkOption {
        type = types.str;
        default = "#CC7E7E";
        description = ''
          color 1 (red)
        '';
      };
      color02 = mkOption {
        type = types.str;
        default = "#72A460";
        description = ''
          color 2 (green)
        '';
      };
      color03 = mkOption {
        type = types.str;
        default = "#A38E4D";
        description = ''
          color 3 (amber)
        '';
      };
      color04 = mkOption {
        type = types.str;
        default = "#6CA1CE";
        description = ''
          color 4 (blue)
        '';
      };
      color05 = mkOption {
        type = types.str;
        default = "#C08CCB";
        description = ''
          color 5 (magenta)
        '';
      };
      color06 = mkOption {
        type = types.str;
        default = "#09ACA0";
        description = ''
          color 6 (cyan)
        '';
      };
      color07 = mkOption {
        type = types.str;
        default = "#808080";
        description = ''
          color 7 (medium gray)
        '';
      };
      color08 = mkOption {
        type = types.str;
        default = "#404040";
        description = ''
          color 8 (dark gray)
        '';
      };
      color09 = mkOption {
        type = types.str;
        default = "#C2976D";
        description = ''
          color 9 (orange)
        '';
      };
      color10 = mkOption {
        type = types.str;
        default = "#45AA7F";
        description = ''
          color 10 (aquamarine)
        '';
      };
      color11 = mkOption {
        type = types.str;
        default = "#B8B851";
        description = ''
          color 11 (yellow)
        '';
      };
      color12 = mkOption {
        type = types.str;
        default = "#9D96D4";
        description = ''
          color 12 (violet)
        '';
      };
      color13 = mkOption {
        type = types.str;
        default = "#D487B7";
        description = ''
          color 13 (rose)
        '';
      };
      color14 = mkOption {
        type = types.str;
        default = "#30A9BB";
        description = ''
          color 14 (azure)
        '';
      };
      color15 = mkOption {
        type = types.str;
        default = "#C0C0C0";
        description = ''
          color 15 (white)
        '';
      };
      cursor = mkOption {
        type = types.str;
        default = "#A0A0A0";
        description = ''
          Cursor color
        '';
      };
    };
    theme = {
      bg = mkOption {
        type = types.int;
        default = 0;
        description = ''
          color number for background
          default: 0
        '';
      };
      fg = mkOption {
        type = types.int;
        default = 15;
        description = ''
          color number for foreground
          default: 15
        '';
      };
      bg-alt = mkOption {
        type = types.int;
        default = 8;
        description = ''
          color number for background-alt
          default: 8
        '';
      };
      fg-alt = mkOption {
        type = types.int;
        default = 7;
        description = ''
          color number for foreground-alt
          default: 7
        '';
      };
      accent = mkOption {
        type = types.int;
        default = 14;
        description = ''
          color number for accent
          default: 14
        '';
      };
      error = mkOption {
        type = types.int;
        default = 1;
        description = ''
          color number for errors/unknown
          default: 1
        '';
      };
      warning = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for warnings
          default: 9
        '';
      };
      info = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for info
          default: 11
        '';
      };
      pattern = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for patterns
          default: 12
        '';
      };
      match = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for matches
          default: 9
        '';
      };
      substitution = mkOption {
        type = types.int;
        default = 7;
        description = ''
          color number for substitutions
          default: 7
        '';
      };
      select = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for selections
          default: 11
        '';
      };
      executable = mkOption {
        type = types.int;
        default = 2;
        description = ''
          color number for executable
          default: 2
        '';
      };
      function = mkOption {
        type = types.int;
        default = 10;
        description = ''
          color number for functions
          default: 10
        '';
      };
      keyword = mkOption {
        type = types.int;
        default = 6;
        description = ''
          color number for keywords
          default: 6
        '';
      };
      statement = mkOption {
        type = types.int;
        default = 14;
        description = ''
          color number for statements
          default: 14
        '';
      };
      type = mkOption {
        type = types.int;
        default = 4;
        description = ''
          color number for types
          default: 4
        '';
      };
      boolean = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for booleans
          default: 12
        '';
      };
      constant = mkOption {
        type = types.int;
        default = 13;
        description = ''
          color number for constants
          default: 13
        '';
      };
      character = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for characters
          default: 11
        '';
      };
      string = mkOption {
        type = types.int;
        default = 3;
        description = ''
          color number for strings
          default: 3
        '';
      };
      number = mkOption {
        type = types.int;
        default = 5;
        description = ''
          color number for numbers
          default: 5
        '';
      };
      path = mkOption {
        type = types.int;
        default = 4;
        description = ''
          color number for paths
          default: 4
        '';
      };
      socket = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for sockets
          default: 12
        '';
      };
      localBranch = mkOption {
        type = types.int;
        default = 4;
        description = ''
          color number for local branches
          default: 4
        '';
      };
      currentBranch = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for current branch
          default: 12
        '';
      };
      remoteBranch = mkOption {
        type = types.int;
        default = 5;
        description = ''
          color number for remote branches
          default: 5
        '';
      };
      staged = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for staged items
          default: 11
        '';
      };
      diff-add = mkOption {
        type = types.int;
        default = 2;
        description = ''
          color number for diff-add
          default: 2
        '';
      };
      diff-add-moved = mkOption {
        type = types.int;
        default = 10;
        description = ''
          color number for diff-add-moved
          default: 10
        '';
      };
      diff-change = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for diff-change
          default: 9
        '';
      };
      diff-remove-moved = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for diff-remove-moved
          default: 9
        '';
      };
      diff-remove = mkOption {
        type = types.int;
        default = 1;
        description = ''
          color number for diff-remove
          default: 1
        '';
      };
    };
  };
}

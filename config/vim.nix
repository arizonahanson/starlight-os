{ config, pkgs, ... }:

{
  environment = {
    etc."skel/.editorconfig" = {
      text = ''
        # editorconfig skeleton file
        root = true

        # default config
        [*]
        charset = utf-8
        end_of_line = lf
        indent_style = space
        indent_size = 2
        insert_final_newline = true
        trim_trailing_whitespace = true

        # Makefiles must use tabs
        [Makefile]
        indent_style = tab
      '';
    };
  };
}

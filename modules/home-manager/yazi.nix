{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "modified";
        sort_dir_first = true;
        sort_reverse = true;
        show_symlink = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };
  };
}

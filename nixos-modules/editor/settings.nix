{
  config,
  pkgs,
}: {
  git_panel.tree_view = true;
  preview_tabs.enabled = false;
  session.trust_all_worktrees = true;
  base_keymap = "VSCode";
  icon_theme = "Zed (Default)";
  ui_font_size = 16;
  buffer_font_size = 15;
  theme = {
    mode = "dark";
    light = "One Light";
    dark = "Gruvbox Dark";
  };
}

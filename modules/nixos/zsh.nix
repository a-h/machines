{ pkgs, ... }:
{
  # Default user shell is zsh.
  users.defaultUserShell = pkgs.zsh;

  # Root user does not have zsh themes in home directory.
  users.users.root.shell = pkgs.bash;

  systemd.tmpfiles.rules = [
    "f /home/adrian/.zprofile"
  ];
  programs.nix-index.enableZshIntegration = true;
  programs.zsh = {
    # Enable zsh as a shell, add it to the environment.
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "aws" "git" ];
    };
    shellInit = ''
      source ${../../custom.zsh-theme}
      export EDITOR='vim'
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
    '';
    shellAliases = {
      q = "exit";
      ls = "ls --color=tty -A";
    };
  };
}

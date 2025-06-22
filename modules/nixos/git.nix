{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gh
    difftastic
  ];
  programs.git = {
    enable = true;
    prompt.enable = true;
    config = {
      diff.external = "${pkgs.difftastic}/bin/difft --color auto --background dark --display inline";
      commit.gpgsign = true;
      gpg.program = "${pkgs.gnupg}/bin/gpg";
      pull.rebase = true;
      tag.gpgsign = true;
      user = {
        email = "adrianhesketh@hushmail.com";
        name = "Adrian Hesketh";
        signingkey = "22323123";
      };
      "crendential \"https://github.com\"" = {
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
      "credential \"https://gist.github.com\"" = {
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };
}

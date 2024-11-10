{ pkgs, ... }:
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    inetutils
    killall
    lm_sensors
    nixfmt-rfc-style
    p7zip
    usbutils
    air # Hot reload for Go.
    d2 # Diagramming
    goreplace
    neovim
    nerdfonts
    xc # Task executor.
    # Java development.
    jdk # Development.
    jre # Runtime.
    gradle # Build tool.
    jdt-language-server # Language server.
    maven
    aerc
    aha # Converts shell output to HTML.
    expect # Provides the unbuffer command used to force programs to pipe color: `unbuffer fd | aha -b -n` (https://joshbode.github.io/remark/ansi.html#5)
    bat
    silver-searcher
    asciinema
    astyle # Code formatter for C.
    aws-vault
    awscli2
    awslogs
    ccls # C LSP Server.
    cmake # Used by Raspberry Pi Pico SDK.
    cargo # Rust tooling.
    delve # Go debugger.
    direnv # Support loading environment files, and the use of https://marketplace.visualstudio.com/items?itemName=mkhl.direnv
    entr # Execute command when files change.
    fd # Find that respects .gitignore.
    flakegap # Transfer flakes across airgaps.
    fzf # Fuzzy search.
    gcc
    gcc-arm-embedded
    gifsicle
    git
    git-lfs
    unstable.gh
    gnupg
    go
    go-swagger
    gotools
    goreleaser
    graphviz
    html2text
    htop
    ibm-plex
    imagemagick
    jq
    lua5_4
    lua-language-server
    llvm # Used by Raspberry Pi Pico SDK.
    lynx
    mob
    minicom # Serial monitor.
    nil # Nix Language Server.
    nix # Specific version of Nix.
    ninja # Used by Raspberry Pi Pico SDK, build tool.
    nixpkgs-fmt
    nix-prefetch-git
    nmap
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodejs
    p7zip
    pass
    powerline
    podman
    ripgrep
    source-code-pro
    rustc # Rust compiler.
    rustfmt # Rust formatter.
    rust-analyzer # Rust language server.
    slides
    terraform-ls
    tflint
    tmate
    tmux
    tree
    unzip
    urlscan
    vscode-langservers-extracted
    wget
    xclip
    yaml-language-server
    yarn
    zip
  ];
}

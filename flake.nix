{
  description = "Andrei's tool set: one nix profile entry, same on the Mac and the Linux dev boxes";

  # Darwin uses the darwin-tested branch: nixpkgs unstable dropped x86_64-darwin
  # (26.11+), so 26.05 is the last release this Intel Mac can use. Linux tracks
  # the same release so both machines get the same package versions.
  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs-darwin, nixpkgs-linux }:
    let
      systems = {
        x86_64-darwin = nixpkgs-darwin;
        aarch64-darwin = nixpkgs-darwin;
        x86_64-linux = nixpkgs-linux;
        aarch64-linux = nixpkgs-linux;
      };

      env = system: nixpkgs:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          common = with pkgs; [
            # core
            git gh tmux vim starship less jq
            ripgrep fd fzf htop
            # GNU userland, so the Mac behaves like Linux
            coreutils gnugrep gnused gawk findutils diffutils gnutar gzip gnumake
            # network / crypto
            curl openssh rsync openssl
            # languages / misc
            python3 cargo rustc mdcat miller
            awscli2
          ];

          darwin = with pkgs; [
            alacritty
            nerd-fonts.jetbrains-mono
            ssm-session-manager-plugin
            opentofu
          ];

          linux = with pkgs; [ ];
        in
        pkgs.buildEnv {
          name = "dotfiles-env";
          paths = common ++ (if pkgs.stdenv.isDarwin then darwin else linux);
          extraOutputsToInstall = [ "man" ];
        };
    in
    {
      packages = builtins.mapAttrs (system: nixpkgs: { default = env system nixpkgs; }) systems;
    };
}

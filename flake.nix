{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    tmux-sessionizer = {
      url = "github:SoxPopuli/tmux-sessionizer";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      tmux-sessionizer,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages.default = pkgs.buildEnv {
          name = "packages";
          paths =
            (with pkgs; [
              bat
              carapace
              carapace-bridge
              cloc
              direnv
              fd
              fzf
              jless
              just
              nixd
              nixfmt
              nvimpager
              pnpm
              ripgrep
              tmux
              zoxide
            ])
            ++ [ tmux-sessionizer.outputs.packages.${system}.default ];
          pathsToLink = [
            "/share"
            "/bin"
          ];
        };
      }
    );
}

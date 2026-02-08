{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
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
          paths = with pkgs; [
            bat
            carapace
            carapace-bridge
            cloc
            direnv
            fd
            fzf
            jless
            nixd
            nixfmt
            nvimpager
            ripgrep
            tmux
            zoxide
            just
          ];
          pathsToLink = [
            "/share"
            "/bin"
          ];
        };
      }
    );
}

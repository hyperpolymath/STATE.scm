# SPDX-License-Identifier: PMPL-1.0 AND LicenseRef-Palimpsest-0.8
# flake.nix - Nix flake for STATE development
#
# Usage:
#   nix develop        # Enter development shell
#   nix build          # Build the package
#   nix run            # Run STATE REPL
#
# With direnv:
#   echo "use flake" > .envrc && direnv allow

{
  description = "STATE - Stateful Context Tracking Engine for AI Conversation Continuity";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core runtime
            guile_3_0

            # Development tools
            git
            just

            # Documentation
            asciidoctor

            # Visualization
            graphviz

            # Container tools
            podman
          ];

          shellHook = ''
            export GUILE_LOAD_PATH="$PWD/lib:$GUILE_LOAD_PATH"
            echo "STATE development environment"
            echo "Run 'just test' to verify installation"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "state-scm";
          version = "1.0.0";
          src = ./.;

          buildInputs = [ pkgs.guile_3_0 ];

          installPhase = ''
            mkdir -p $out/share/guile/site/3.0
            cp -r lib/* $out/share/guile/site/3.0/
            mkdir -p $out/share/state
            cp -r examples $out/share/state/
            cp STATE.scm $out/share/state/
          '';

          meta = with pkgs.lib; {
            description = "Stateful Context Tracking Engine for AI Conversation Continuity";
            homepage = "https://github.com/hyperpolymath/state.scm";
            license = licenses.mpl20;
            platforms = platforms.all;
          };
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "state-repl" ''
            export GUILE_LOAD_PATH="${self.packages.${system}.default}/share/guile/site/3.0:$GUILE_LOAD_PATH"
            exec ${pkgs.guile_3_0}/bin/guile -l ${self.packages.${system}.default}/share/guile/site/3.0/state.scm
          ''}";
        };
      }
    );
}

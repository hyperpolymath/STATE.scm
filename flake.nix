# SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
# Nix flake for STATE - reproducible development environment
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
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core
            guile_3_0

            # Optional: minikanren (if available in nixpkgs)
            # guile-minikanren

            # Documentation
            asciidoctor

            # Visualization
            graphviz

            # Build tools
            just
            git

            # Container tools
            podman
          ];

          shellHook = ''
            echo "STATE development environment"
            echo "Guile: $(guile --version | head -1)"
            echo ""
            echo "Available commands:"
            echo "  just          - Show available tasks"
            echo "  just test     - Run tests"
            echo "  just repl     - Start Guile REPL with STATE"
            echo "  just dot      - Generate GraphViz output"
            echo "  just mermaid  - Generate Mermaid output"
            echo ""
            export GUILE_LOAD_PATH="$PWD/lib:$GUILE_LOAD_PATH"
          '';
        };

        # Package
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "state";
          version = "2.0.0";
          src = ./.;

          buildInputs = [ pkgs.guile_3_0 ];

          installPhase = ''
            mkdir -p $out/share/guile/site/3.0
            cp -r lib/* $out/share/guile/site/3.0/
            cp STATE.scm $out/share/guile/site/3.0/

            mkdir -p $out/share/doc/state
            cp README.adoc USAGE.adoc $out/share/doc/state/

            mkdir -p $out/share/state/examples
            cp examples/* $out/share/state/examples/
          '';

          meta = with pkgs.lib; {
            description = "Stateful Context Tracking Engine for AI Conversation Continuity";
            homepage = "https://github.com/Hyperpolymath/STATE.scm";
            license = licenses.mit;  # Plus Palimpsest
            platforms = platforms.all;
          };
        };

        # Overlay for adding to other flakes
        overlays.default = final: prev: {
          state = self.packages.${system}.default;
        };
      }
    );
}

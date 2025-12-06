# SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
# Justfile for STATE project
# https://just.systems/

# Default recipe - show available commands
default:
    @just --list

# Run all tests
test:
    guile -L lib -c '(use-modules (state)) (display "Modules loaded: ") (display (state-modules-loaded)) (newline)'

# Run tests with verbose output
test-verbose:
    guile -L lib -c '(use-modules (state-core) (state-kanren) (state-graph) (state-history)) (display "All modules loaded successfully\n")'

# Load REPL with STATE modules
repl:
    guile -L lib -l lib/state.scm

# Generate GraphViz DOT from example
dot:
    guile -L lib -c '(use-modules (state) (state-graph)) (load "examples/example-state.scm") (display (generate-dot state))'

# Generate Mermaid from example
mermaid:
    guile -L lib -c '(use-modules (state) (state-graph)) (load "examples/example-state.scm") (display (generate-mermaid state))'

# Show velocity report from example
velocity:
    guile -L lib -c '(use-modules (state) (state-history)) (load "examples/example-state.scm") (velocity-report state)'

# Show progress report from example
progress:
    guile -L lib -c '(use-modules (state) (state-history)) (load "examples/example-state.scm") (progress-report state)'

# Check if minikanren is available
check-minikanren:
    guile -L lib -c '(use-modules (state-kanren)) (display (if (minikanren-available?) "minikanren: available\n" "minikanren: using fallback\n"))'

# Lint Scheme files (basic syntax check)
lint:
    @for f in lib/*.scm STATE.scm examples/*.scm; do \
        echo "Checking $f..."; \
        guile -c "(load \"$f\")" 2>&1 || exit 1; \
    done
    @echo "All files OK"

# Build documentation (requires asciidoctor)
docs:
    asciidoctor README.adoc -o docs/README.html
    asciidoctor USAGE.adoc -o docs/USAGE.html

# Clean generated files
clean:
    rm -rf docs/*.html
    rm -f *.dot *.mmd

# Format check (placeholder - Scheme doesn't have standard formatter)
fmt-check:
    @echo "No standard Scheme formatter configured"

# Build container image
container:
    podman build -t state:latest .

# Run in container
container-run:
    podman run -it --rm -v $(pwd):/workspace:Z state:latest

# Create a new snapshot from example state
snapshot:
    guile -L lib -c '(use-modules (state) (state-history)) (load "examples/example-state.scm") (display (create-snapshot state)) (newline)'

# Show all blocked projects
blocked:
    guile -L lib -c '(use-modules (state) (state-core)) (load "examples/example-state.scm") (for-each (lambda (p) (display (cdr (assoc (quote name) p))) (newline)) (get-blocked-projects state))'

# Show critical path for a project (usage: just critical-path ProjectName)
critical-path project:
    guile -L lib -c '(use-modules (state) (state-graph)) (load "examples/example-state.scm") (display (find-critical-path "{{project}}" state)) (newline)'

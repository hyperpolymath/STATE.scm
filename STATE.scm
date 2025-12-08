;;; ==================================================
;;; STATE.scm — AI Conversation Checkpoint File
;;; ==================================================
;;;
;;; SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
;;; Copyright (c) 2025 Jonathan D.A. Jewell
;;;
;;; STATEFUL CONTEXT TRACKING ENGINE
;;; Version: 2.0
;;;
;;; CRITICAL: Download this file at end of each session!
;;; At start of next conversation, upload it.
;;; Do NOT rely on ephemeral storage to persist.
;;;
;;; For query functions, load the library:
;;;   (add-to-load-path "/path/to/STATE.scm/lib")
;;;   (use-modules (state))
;;;
;;; ==================================================

(define state
  '((metadata
      (format-version . "2.0")
      (schema-version . "2025-12-08")
      (created-at . "2025-12-01T10:00:00Z")
      (last-updated . "2025-12-08T12:00:00Z")
      (generator . "Claude/STATE-system"))

    (user
      (name . "Jonathan D.A. Jewell")
      (roles . ("Project Lead" "Architect"))
      (preferences
        (languages-preferred . ("Guile Scheme" "Rust" "Elixir"))
        (languages-avoid . ())
        (tools-preferred . ("Guix" "Nix" "Podman" "Just" "GitLab"))
        (values . ("FOSS" "reproducibility" "formal-verification" "homoiconicity"))))

    (session
      (conversation-id . "2025-12-08-STATE-STATUS")
      (started-at . "2025-12-08T12:00:00Z")
      (messages-used . 0)
      (messages-remaining . 100)
      (token-limit-reached . #f))

    ;;; ==================================================
    ;;; CURRENT POSITION
    ;;; ==================================================
    ;;; Phase 2 (Smart Queries) is COMPLETE.
    ;;; Phase 3 (Automation) is the active development target.
    ;;; The core Guile library is functional with:
    ;;;   - Modular architecture (state-core, state-kanren, state-graph, state-history)
    ;;;   - minikanren-style relational queries (with fallback)
    ;;;   - GraphViz DOT and Mermaid diagram generation
    ;;;   - Velocity tracking and completion estimation
    ;;; Manual download/upload workflow works but automation is needed.
    ;;; ==================================================

    (focus
      (current-project . "STATE.scm")
      (current-phase . "Phase 3 - Automation")
      (deadline . #f)
      (blocking-projects . ()))

    (projects
      ;; --------------------------------------------------
      ;; STATE.scm - This Project
      ;; --------------------------------------------------
      ((name . "STATE.scm")
       (status . "in-progress")
       (completion . 65)
       (category . "infrastructure")
       (phase . "phase-3-automation")
       (dependencies . ())
       (blockers . ("Elixir service not started"
                    "Echomesh integration design pending"
                    "No automated export mechanism yet"))
       (next . ("Design Elixir/Phoenix REST API for STATE management"
                "Implement automatic state capture hooks"
                "Add diff tracking between STATE versions"
                "Create periodic export scheduler"))
       (chat-reference . "2025-12-08-STATE-STATUS")
       (notes . "Core library complete. Automation is next priority."))

      ;; --------------------------------------------------
      ;; Phase 1: Foundation (COMPLETE)
      ;; --------------------------------------------------
      ((name . "STATE Phase 1 - Foundation")
       (status . "complete")
       (completion . 100)
       (category . "infrastructure")
       (phase . "foundation")
       (dependencies . ())
       (blockers . ())
       (next . ())
       (chat-reference . #f)
       (notes . "Core STATE.scm structure, project metadata, session checkpointing"))

      ;; --------------------------------------------------
      ;; Phase 2: Smart Queries (COMPLETE)
      ;; --------------------------------------------------
      ((name . "STATE Phase 2 - Smart Queries")
       (status . "complete")
       (completion . 100)
       (category . "infrastructure")
       (phase . "smart-queries")
       (dependencies . ("STATE Phase 1 - Foundation"))
       (blockers . ())
       (next . ())
       (chat-reference . #f)
       (notes . "Modular lib/, minikanren, GraphViz, Mermaid, velocity tracking"))

      ;; --------------------------------------------------
      ;; Phase 3: Automation (IN PROGRESS)
      ;; --------------------------------------------------
      ((name . "STATE Phase 3 - Automation")
       (status . "in-progress")
       (completion . 0)
       (category . "infrastructure")
       (phase . "automation")
       (dependencies . ("STATE Phase 2 - Smart Queries"))
       (blockers . ("Echomesh dependency not ready"
                    "Elixir service architecture not defined"))
       (next . ("Design Elixir/Phoenix service API"
                "Implement Echomesh integration"
                "Build periodic auto-export system"
                "Add change diff tracking"))
       (chat-reference . #f)
       (notes . "Transform manual workflow into automated system"))

      ;; --------------------------------------------------
      ;; Phase 4: Full Integration (FUTURE)
      ;; --------------------------------------------------
      ((name . "STATE Phase 4 - Integration")
       (status . "blocked")
       (completion . 0)
       (category . "infrastructure")
       (phase . "integration")
       (dependencies . ("STATE Phase 3 - Automation" "UPM"))
       (blockers . ("Waiting for Phase 3 completion"
                    "UPM not available yet"))
       (next . ("UPM integration design"
                "Git hooks for auto-update"
                "Team collaboration features"
                "Real-time sync protocol"))
       (chat-reference . #f)
       (notes . "Full ecosystem integration with UPM and team features"))

      ;; --------------------------------------------------
      ;; External Dependencies
      ;; --------------------------------------------------
      ((name . "Echomesh")
       (status . "blocked")
       (completion . 0)
       (category . "ai")
       (phase . "external-dependency")
       (dependencies . ())
       (blockers . ("External project - not under our control"))
       (next . ("Monitor Echomesh development"))
       (chat-reference . #f)
       (notes . "Conversation persistence system - will enable automatic STATE capture"))

      ((name . "UPM")
       (status . "blocked")
       (completion . 0)
       (category . "infrastructure")
       (phase . "external-dependency")
       (dependencies . ())
       (blockers . ("External project - not under our control"))
       (next . ("Monitor UPM development"))
       (chat-reference . #f)
       (notes . "Universal Project Manager - future integration target")))

    ;;; ==================================================
    ;;; CRITICAL NEXT ACTIONS (Route to MVP v1)
    ;;; ==================================================
    ;;; MVP v1.0 = Phase 2 Complete + Documentation + Packaging
    ;;; Current: Phase 2 is complete, so MVP v1.0 is essentially READY
    ;;; Next milestone: v2.0 = Phase 3 Automation features
    ;;; ==================================================

    (critical-next
      ("Finalize v2.0 release notes and tag release"
       "Design Elixir/Phoenix REST API specification"
       "Create automated STATE export CLI tool"
       "Write integration tests for lib/ modules"
       "Document minikanren fallback limitations"))

    ;;; ==================================================
    ;;; KNOWN ISSUES
    ;;; ==================================================

    (issues
      ((id . "ISSUE-001")
       (severity . "medium")
       (title . "History velocity requires 2+ snapshots")
       (description . "Velocity calculation returns #f when < 2 snapshots exist")
       (workaround . "Manually create initial snapshots")
       (status . "documented"))

      ((id . "ISSUE-002")
       (severity . "low")
       (title . "Deep dependency chains slow to calculate")
       (description . "Recursive dependency resolution may be slow for large graphs")
       (workaround . "Limit dependency depth in complex projects")
       (status . "documented"))

      ((id . "ISSUE-003")
       (severity . "low")
       (title . "minikanren fallback has limited unification")
       (description . "Built-in fallback doesn't support full unification semantics")
       (workaround . "Install full minikanren for advanced queries")
       (status . "documented"))

      ((id . "ISSUE-004")
       (severity . "high")
       (title . "No automated export mechanism")
       (description . "Users must manually download STATE.scm at end of session")
       (workaround . "Discipline - always download before closing conversation")
       (status . "planned-for-phase-3"))

      ((id . "ISSUE-005")
       (severity . "medium")
       (title . "No diff tracking between versions")
       (description . "Cannot see what changed between STATE.scm versions")
       (workaround . "Use git diff on STATE.scm files")
       (status . "planned-for-phase-3")))

    ;;; ==================================================
    ;;; QUESTIONS FOR USER
    ;;; ==================================================

    (questions
      ((id . "Q-001")
       (priority . "high")
       (question . "Should the Elixir service be standalone or integrated with Echomesh?")
       (context . "Affects architecture decisions for Phase 3")
       (options . ("Standalone Phoenix app"
                   "Echomesh plugin/extension"
                   "Library that works with both")))

      ((id . "Q-002")
       (priority . "medium")
       (question . "What export formats should be supported beyond .scm?")
       (context . "JSON, YAML, or EDN for interoperability")
       (options . ("JSON for web tools"
                   "YAML for humans"
                   "EDN for Clojure ecosystem"
                   "All of the above")))

      ((id . "Q-003")
       (priority . "medium")
       (question . "Should STATE support team/multi-user scenarios in Phase 4?")
       (context . "Affects schema design - need user attribution per change")
       (options . ("Single-user only (simpler)"
                   "Multi-user with merge conflicts"
                   "Multi-user with CRDT-style merging")))

      ((id . "Q-004")
       (priority . "low")
       (question . "Git hooks: pre-commit or post-commit update?")
       (context . "Pre-commit could block on errors; post-commit is async")
       (options . ("Pre-commit (blocking)"
                   "Post-commit (async)"
                   "Both as options")))

      ((id . "Q-005")
       (priority . "high")
       (question . "What is the minimum Guile version to support?")
       (context . "Guile 3.0 is current, but 2.2 is still common")
       (options . ("Guile 3.0+ only"
                   "Guile 2.2+ with compatibility shims"))))

    ;;; ==================================================
    ;;; LONG-TERM ROADMAP
    ;;; ==================================================

    (roadmap
      ((phase . "3.0 - Automation")
       (status . "next")
       (goals . ("Elixir/Phoenix service for STATE management"
                 "Echomesh integration for automatic state capture"
                 "Periodic auto-exports"
                 "Change diff tracking"
                 "CLI tool for STATE operations")))

      ((phase . "4.0 - Integration")
       (status . "future")
       (goals . ("UPM (Universal Project Manager) integration"
                 "Git hooks for auto-update on commits"
                 "Team collaboration features"
                 "Real-time sync across sessions")))

      ((phase . "5.0 - Intelligence")
       (status . "vision")
       (goals . ("AI-assisted project prioritization"
                 "Automatic blocker detection"
                 "Predictive completion estimates"
                 "Cross-project dependency optimization"
                 "Natural language query interface")))

      ((phase . "6.0 - Ecosystem")
       (status . "vision")
       (goals . ("Plugin architecture for custom modules"
                 "Community project templates"
                 "Integration with major project management tools"
                 "Federation for distributed teams"))))

    (history
      ;; Completion snapshots for velocity tracking
      (snapshots
        ((timestamp . "2025-12-06T10:00:00Z")
         (projects
           ((name . "STATE.scm") (completion . 55))
           ((name . "STATE Phase 1 - Foundation") (completion . 100))
           ((name . "STATE Phase 2 - Smart Queries") (completion . 90))
           ((name . "STATE Phase 3 - Automation") (completion . 0))
           ((name . "STATE Phase 4 - Integration") (completion . 0))))

        ((timestamp . "2025-12-08T12:00:00Z")
         (projects
           ((name . "STATE.scm") (completion . 65))
           ((name . "STATE Phase 1 - Foundation") (completion . 100))
           ((name . "STATE Phase 2 - Smart Queries") (completion . 100))
           ((name . "STATE Phase 3 - Automation") (completion . 0))
           ((name . "STATE Phase 4 - Integration") (completion . 0))))))

    (files-created-this-session
      ())

    (files-modified-this-session
      ("STATE.scm"))

    (context-notes . "Phase 2 complete. v2.0 released. Focus shifting to Phase 3 automation. Key decisions needed: Elixir service architecture, export formats, multi-user support.")))

;;; ==================================================
;;; QUICK REFERENCE
;;; ==================================================
;;;
;;; Load the library for full functionality:
;;;
;;;   (add-to-load-path "/path/to/STATE.scm/lib")
;;;   (use-modules (state))
;;;
;;; Core queries:
;;;   (get-current-focus state)      ; Current project name
;;;   (get-blocked-projects state)   ; All blocked projects
;;;   (get-critical-next state)      ; Priority actions
;;;   (should-checkpoint? state)     ; Need to save?
;;;
;;; minikanren queries:
;;;   (run* (q) (statuso q "blocked" state))  ; All blocked
;;;   (run* (q) (dependso "ProjectA" q state)) ; Dependencies
;;;
;;; Visualization:
;;;   (generate-dot state)           ; GraphViz DOT output
;;;   (generate-mermaid state)       ; Mermaid diagram
;;;
;;; Time estimation:
;;;   (project-velocity "Project" state)       ; %/day
;;;   (estimate-completion-date "Project" state) ; ISO date
;;;   (velocity-report state)        ; Print velocity report
;;;   (progress-report state)        ; Print progress report
;;;
;;; History management:
;;;   (create-snapshot state)        ; Create new snapshot
;;;   (add-snapshot-to-history snapshot state) ; Add to history
;;;
;;; ==================================================
;;; END STATE.scm
;;; ==================================================

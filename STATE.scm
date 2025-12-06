;;; ==================================================
;;; STATE.scm — AI Conversation Checkpoint File
;;; ==================================================
;;;
;;; STATEFUL CONTEXT TRACKING ENGINE
;;; Version: 1.0
;;;
;;; CRITICAL: Download this file at end of each session!
;;; At start of next conversation, upload it.
;;; Do NOT rely on ephemeral storage to persist.
;;;
;;; ==================================================

(define state
  '((metadata
      (format-version . "1.0")
      (schema-version . "2025-12-06")
      (created-at . "TIMESTAMP")
      (last-updated . "TIMESTAMP")
      (generator . "Claude/STATE-system"))

    (user
      (name . "YOUR NAME")
      (roles . ("role1" "role2"))
      (preferences
        (languages-preferred . ("Rust" "Elixir" "Haskell"))
        (languages-avoid . ())
        (tools-preferred . ("GitLab" "Podman" "Guix"))
        (values . ("FOSS" "reproducibility" "formal-verification"))))

    (session
      (conversation-id . "CONVERSATION-UUID")
      (started-at . "TIMESTAMP")
      (messages-used . 0)
      (messages-remaining . 100)
      (token-limit-reached . #f))

    (focus
      (current-project . "PROJECT-NAME")
      (current-phase . "phase-description")
      (deadline . #f)
      (blocking-projects . ()))

    (projects
      ;; Project template - copy and modify as needed
      ;;
      ;; Status values:
      ;;   in-progress  - actively being worked on
      ;;   blocked      - waiting on dependency or external factor
      ;;   paused       - intentionally on hold
      ;;   complete     - finished
      ;;   abandoned    - no longer pursuing
      ;;
      ;; Category values:
      ;;   language              - programming language design/implementation
      ;;   ai                    - artificial intelligence projects
      ;;   formal-verification   - proofs, type systems, verification
      ;;   standards             - specifications, protocols, formats
      ;;   infrastructure        - tooling, devops, services
      ;;   education             - courses, curricula, teaching materials

      ((name . "Example Project")
       (status . "in-progress")
       (completion . 0)
       (category . "infrastructure")
       (phase . "planning")
       (dependencies . ())
       (blockers . ())
       (next . ("Define requirements" "Create initial design"))
       (chat-reference . #f)
       (notes . "")))

    (critical-next
      ;; Top 3-5 immediate actions across all projects
      ;; These should be the most time-sensitive or impactful
      ("Action 1 description"
       "Action 2 description"
       "Action 3 description"))

    (files-created-this-session
      ;; Paths to files created during current conversation
      ())

    (files-modified-this-session
      ;; Paths to files modified during current conversation
      ())

    (context-notes . "Additional context for next session")))

;;; ==================================================
;;; ACCESSOR FUNCTIONS
;;; ==================================================
;;;
;;; These functions help extract data from the state structure.
;;; Load this file in Guile REPL: (load "STATE.scm")

(define (get-section state section-name)
  "Get a top-level section from state by name."
  (let ((section (assoc section-name (cdr state))))
    (if section (cdr section) #f)))

(define (get-user-name state)
  "Extract user name from state."
  (let ((user (get-section state 'user)))
    (if user
        (cdr (assoc 'name user))
        #f)))

(define (get-current-focus state)
  "Get the current project focus."
  (let ((focus (get-section state 'focus)))
    (if focus
        (cdr (assoc 'current-project focus))
        #f)))

(define (get-all-projects state)
  "Get the list of all projects."
  (get-section state 'projects))

(define (get-project-by-name state name)
  "Find a project by its name."
  (let ((projects (get-all-projects state)))
    (if projects
        (find (lambda (p)
                (equal? (cdr (assoc 'name p)) name))
              projects)
        #f)))

(define (get-blocked-projects state)
  "Get all projects with status 'blocked'."
  (let ((projects (get-all-projects state)))
    (if projects
        (filter (lambda (p)
                  (equal? (cdr (assoc 'status p)) "blocked"))
                projects)
        '())))

(define (get-in-progress-projects state)
  "Get all projects with status 'in-progress'."
  (let ((projects (get-all-projects state)))
    (if projects
        (filter (lambda (p)
                  (equal? (cdr (assoc 'status p)) "in-progress"))
                projects)
        '())))

(define (get-critical-next state)
  "Get the list of critical next actions."
  (get-section state 'critical-next))

(define (get-session-info state)
  "Get session metadata."
  (get-section state 'session))

(define (messages-remaining? state)
  "Check how many messages remain in session."
  (let ((session (get-session-info state)))
    (if session
        (cdr (assoc 'messages-remaining session))
        #f)))

;;; ==================================================
;;; QUERY HELPERS
;;; ==================================================

(define (projects-blocking project-name state)
  "Find all projects that depend on the given project."
  (let ((projects (get-all-projects state)))
    (if projects
        (filter (lambda (p)
                  (member project-name
                          (cdr (assoc 'dependencies p))))
                projects)
        '())))

(define (project-completion state name)
  "Get completion percentage for a project."
  (let ((project (get-project-by-name state name)))
    (if project
        (cdr (assoc 'completion project))
        #f)))

(define (total-completion state)
  "Calculate average completion across all in-progress projects."
  (let ((projects (get-in-progress-projects state)))
    (if (null? projects)
        0
        (/ (apply + (map (lambda (p)
                           (cdr (assoc 'completion p)))
                         projects))
           (length projects)))))

;;; ==================================================
;;; DISPLAY HELPERS
;;; ==================================================

(define (display-focus state)
  "Display current focus information."
  (let ((focus (get-section state 'focus)))
    (when focus
      (display "Current Focus: ")
      (display (cdr (assoc 'current-project focus)))
      (newline)
      (display "Phase: ")
      (display (cdr (assoc 'current-phase focus)))
      (newline)
      (let ((deadline (cdr (assoc 'deadline focus))))
        (when deadline
          (display "Deadline: ")
          (display deadline)
          (newline))))))

(define (display-critical-next state)
  "Display critical next actions."
  (let ((actions (get-critical-next state)))
    (display "Critical Next Actions:\n")
    (for-each (lambda (action)
                (display "  - ")
                (display action)
                (newline))
              actions)))

(define (display-project-summary state)
  "Display summary of all projects."
  (let ((projects (get-all-projects state)))
    (display "Project Summary:\n")
    (display "================\n")
    (for-each (lambda (p)
                (display (cdr (assoc 'name p)))
                (display " [")
                (display (cdr (assoc 'status p)))
                (display "] ")
                (display (cdr (assoc 'completion p)))
                (display "%\n"))
              projects)))

;;; ==================================================
;;; END STATE.scm
;;; ==================================================

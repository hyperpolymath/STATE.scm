;;; ==================================================
;;; state-queries.scm — minikanren-style Query System
;;; ==================================================
;;;
;;; Relational queries for STATE.scm
;;; Enables declarative, constraint-based queries over project state
;;;
;;; Usage:
;;;   (load "STATE.scm")
;;;   (load "state-queries.scm")
;;;   (run* (q) (blocked-project q state))
;;;
;;; ==================================================

;;; --------------------------------------------------
;;; Core minikanren primitives (simplified)
;;; --------------------------------------------------
;;;
;;; This is a minimal implementation of minikanren concepts.
;;; For full minikanren, use the Guile minikanren library:
;;;   https://github.com/miniKanren/miniKanren
;;;
;;; These primitives enable relational programming patterns
;;; without requiring the full minikanren dependency.

(define (succeed s) (list s))
(define (fail s) '())

(define (== x y)
  "Unification goal: succeeds if x equals y."
  (lambda (s)
    (if (equal? x y)
        (succeed s)
        (fail s))))

(define (disj g1 g2)
  "Disjunction (OR): either g1 or g2 succeeds."
  (lambda (s)
    (append (g1 s) (g2 s))))

(define (conj g1 g2)
  "Conjunction (AND): both g1 and g2 must succeed."
  (lambda (s)
    (apply append (map g2 (g1 s)))))

(define-syntax conde
  (syntax-rules ()
    "Conditional with multiple clauses (like cond but relational)."
    ((_ (g0 g ...) ...)
     (disj (conj g0 (conj g ...)) ...))))

(define-syntax run*
  (syntax-rules ()
    "Run a query and return all results."
    ((_ (q) g ...)
     (map (lambda (s) (walk q s))
          ((conj g ...) '())))))

(define (walk v s)
  "Walk a term to its value in substitution s."
  (let ((a (assoc v s)))
    (if a (walk (cdr a) s) v)))

;;; --------------------------------------------------
;;; STATE Query Goals
;;; --------------------------------------------------

(define (project-exists name state)
  "Goal: project with given name exists in state."
  (lambda (s)
    (if (get-project-by-name state name)
        (succeed s)
        (fail s))))

(define (project-status name status state)
  "Goal: project has the given status."
  (lambda (s)
    (let ((project (get-project-by-name state name)))
      (if (and project
               (equal? (cdr (assoc 'status project)) status))
          (succeed s)
          (fail s)))))

(define (project-blocked name state)
  "Goal: project is blocked."
  (project-status name "blocked" state))

(define (project-in-progress name state)
  "Goal: project is in-progress."
  (project-status name "in-progress" state))

(define (project-complete name state)
  "Goal: project is complete."
  (project-status name "complete" state))

(define (project-depends-on dependent dependency state)
  "Goal: 'dependent' project depends on 'dependency' project."
  (lambda (s)
    (let ((project (get-project-by-name state dependent)))
      (if (and project
               (member dependency
                       (cdr (assoc 'dependencies project))))
          (succeed s)
          (fail s)))))

(define (project-completion>= name threshold state)
  "Goal: project completion is >= threshold."
  (lambda (s)
    (let ((project (get-project-by-name state name)))
      (if (and project
               (>= (cdr (assoc 'completion project)) threshold))
          (succeed s)
          (fail s)))))

(define (project-has-blocker name blocker state)
  "Goal: project has a specific blocker."
  (lambda (s)
    (let ((project (get-project-by-name state name)))
      (if (and project
               (member blocker
                       (cdr (assoc 'blockers project))))
          (succeed s)
          (fail s)))))

;;; --------------------------------------------------
;;; High-Level Query Functions
;;; --------------------------------------------------

(define (query-focus state)
  "What's the current focus project?"
  (get-current-focus state))

(define (query-blocked-projects state)
  "List all blocked projects with their blockers."
  (let ((projects (get-blocked-projects state)))
    (map (lambda (p)
           (cons (cdr (assoc 'name p))
                 (cdr (assoc 'blockers p))))
         projects)))

(define (query-by-status status state)
  "Get all projects with given status."
  (let ((projects (get-all-projects state)))
    (filter (lambda (p)
              (equal? (cdr (assoc 'status p)) status))
            projects)))

(define (query-by-category category state)
  "Get all projects in given category."
  (let ((projects (get-all-projects state)))
    (filter (lambda (p)
              (equal? (cdr (assoc 'category p)) category))
            projects)))

(define (query-by-completion-range min-pct max-pct state)
  "Get projects with completion between min and max percent."
  (let ((projects (get-all-projects state)))
    (filter (lambda (p)
              (let ((completion (cdr (assoc 'completion p))))
                (and (>= completion min-pct)
                     (<= completion max-pct))))
            projects)))

(define (query-nearly-complete state)
  "Get projects that are >= 80% complete."
  (query-by-completion-range 80 100 state))

(define (query-just-started state)
  "Get projects that are <= 20% complete."
  (query-by-completion-range 0 20 state))

(define (query-dependencies project-name state)
  "Get all dependencies of a project."
  (let ((project (get-project-by-name state project-name)))
    (if project
        (cdr (assoc 'dependencies project))
        '())))

(define (query-dependents project-name state)
  "Get all projects that depend on this project."
  (let ((projects (get-all-projects state)))
    (filter (lambda (p)
              (member project-name
                      (cdr (assoc 'dependencies p))))
            projects)))

(define (query-next-actions project-name state)
  "Get next actions for a specific project."
  (let ((project (get-project-by-name state project-name)))
    (if project
        (cdr (assoc 'next project))
        '())))

(define (query-all-next-actions state)
  "Get next actions across all in-progress projects."
  (let ((projects (get-in-progress-projects state)))
    (apply append
           (map (lambda (p)
                  (map (lambda (action)
                         (cons (cdr (assoc 'name p)) action))
                       (cdr (assoc 'next p))))
                projects))))

;;; --------------------------------------------------
;;; Dependency Graph Analysis
;;; --------------------------------------------------

(define (build-dependency-graph state)
  "Build an adjacency list representation of project dependencies."
  (let ((projects (get-all-projects state)))
    (map (lambda (p)
           (cons (cdr (assoc 'name p))
                 (cdr (assoc 'dependencies p))))
         projects)))

(define (transitive-dependencies project-name state visited)
  "Find all transitive dependencies of a project (DFS)."
  (if (member project-name visited)
      '()  ; Avoid cycles
      (let* ((deps (query-dependencies project-name state))
             (new-visited (cons project-name visited)))
        (if (null? deps)
            '()
            (append deps
                    (apply append
                           (map (lambda (dep)
                                  (transitive-dependencies dep state new-visited))
                                deps)))))))

(define (transitive-dependents project-name state visited)
  "Find all projects transitively depending on this project."
  (if (member project-name visited)
      '()  ; Avoid cycles
      (let* ((dependents (map (lambda (p) (cdr (assoc 'name p)))
                              (query-dependents project-name state)))
             (new-visited (cons project-name visited)))
        (if (null? dependents)
            '()
            (append dependents
                    (apply append
                           (map (lambda (dep)
                                  (transitive-dependents dep state new-visited))
                                dependents)))))))

(define (critical-path-to project-name state)
  "Calculate the critical path (longest dependency chain) to complete a project."
  (let ((deps (transitive-dependencies project-name state '())))
    (cons project-name
          (remove-duplicates deps))))

(define (remove-duplicates lst)
  "Remove duplicate elements from a list."
  (if (null? lst)
      '()
      (cons (car lst)
            (remove-duplicates
             (filter (lambda (x) (not (equal? x (car lst))))
                     (cdr lst))))))

(define (blocking-impact project-name state)
  "Calculate how many projects are blocked if this project isn't done."
  (length (transitive-dependents project-name state '())))

(define (priority-score project-name state)
  "Calculate priority score based on:
   - Number of dependents (higher = more critical)
   - Current completion (higher = closer to done)
   - Has deadline? (yes = more urgent)"
  (let* ((project (get-project-by-name state project-name))
         (dependents (blocking-impact project-name state))
         (completion (if project (cdr (assoc 'completion project)) 0))
         (focus (get-section state 'focus))
         (has-deadline (and focus (cdr (assoc 'deadline focus)))))
    (+ (* dependents 10)           ; 10 points per dependent
       (quotient completion 10)    ; 1 point per 10% completion
       (if has-deadline 20 0))))   ; 20 points if has deadline

(define (prioritized-projects state)
  "Return all in-progress projects sorted by priority."
  (let ((projects (get-in-progress-projects state)))
    (sort projects
          (lambda (a b)
            (> (priority-score (cdr (assoc 'name a)) state)
               (priority-score (cdr (assoc 'name b)) state))))))

;;; --------------------------------------------------
;;; Session Analysis
;;; --------------------------------------------------

(define (session-health state)
  "Analyze session health and return status."
  (let* ((session (get-session-info state))
         (remaining (if session
                        (cdr (assoc 'messages-remaining session))
                        100))
         (limit-reached (if session
                            (cdr (assoc 'token-limit-reached session))
                            #f)))
    (cond
      (limit-reached 'critical)
      ((< remaining 10) 'low)
      ((< remaining 30) 'moderate)
      (else 'healthy))))

(define (should-checkpoint? state)
  "Returns #t if a checkpoint should be created now."
  (let ((health (session-health state)))
    (or (eq? health 'critical)
        (eq? health 'low))))

;;; --------------------------------------------------
;;; Report Generation
;;; --------------------------------------------------

(define (generate-status-report state)
  "Generate a comprehensive status report."
  (display "=== STATE Status Report ===\n\n")

  ;; User info
  (display "User: ")
  (display (get-user-name state))
  (newline)
  (newline)

  ;; Current focus
  (display-focus state)
  (newline)

  ;; Session health
  (display "Session Health: ")
  (display (session-health state))
  (newline)
  (newline)

  ;; Project summary by status
  (display "Projects by Status:\n")
  (display "-------------------\n")
  (for-each
   (lambda (status)
     (let ((projects (query-by-status status state)))
       (when (not (null? projects))
         (display (string-append "  " status ": "
                                 (number->string (length projects))
                                 "\n")))))
   '("in-progress" "blocked" "paused" "complete" "abandoned"))
  (newline)

  ;; Critical next actions
  (display-critical-next state)
  (newline)

  ;; Blocked projects
  (let ((blocked (query-blocked-projects state)))
    (when (not (null? blocked))
      (display "Blocked Projects:\n")
      (for-each
       (lambda (b)
         (display (string-append "  - " (car b) ": "
                                 (if (null? (cdr b))
                                     "no blockers listed"
                                     (car (cdr b)))
                                 "\n")))
       blocked)))

  (display "\n=== End Report ===\n"))

;;; ==================================================
;;; END state-queries.scm
;;; ==================================================

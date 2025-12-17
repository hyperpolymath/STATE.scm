;;; SPDX-License-Identifier: MIT OR AGPL-3.0-or-later
;;; guix.scm — Guix package definition for STATE
;;;
;;; This file defines STATE as a Guix package.
;;;
;;; Build with:
;;;   guix build -f guix.scm
;;;
;;; Install to profile:
;;;   guix package -f guix.scm
;;;
;;; Enter development environment:
;;;   guix shell -D -f guix.scm

(use-modules (guix packages)
             (guix gexp)
             (guix git-download)
             (guix build-system guile)
             ((guix licenses) #:prefix license:)
             (gnu packages guile))

(package
  (name "guile-state")
  (version "2.0.0")
  (source (local-file "." "state-checkout"
                      #:recursive? #t
                      #:select? (lambda (file stat)
                                  (not (string-contains file ".git")))))
  (build-system guile-build-system)
  (arguments
   '(#:source-directory "lib"
     #:compile-flags '("--r6rs" "-W2")))
  (native-inputs
   (list guile-3.0))
  (propagated-inputs
   (list guile-3.0))
  (home-page "https://github.com/hyperpolymath/STATE.scm")
  (synopsis "Stateful Context Tracking Engine for AI Conversation Continuity")
  (description
   "STATE is a checkpoint/restore system for AI conversations that persists
project context, decisions, and next actions across multiple Claude
conversations.  It uses Guile Scheme with minikanren-style relational
queries for analyzing project dependencies and estimating completion times.")
  (license (list license:expat        ; MIT
                 license:agpl3+)))    ; AGPL-3.0-or-later

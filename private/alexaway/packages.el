;;; packages.el --- alexaway layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: alexaway <alexaway@lab>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `alexaway-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `alexaway/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `alexaway/pre-init-PACKAGE' and/or
;;   `alexaway/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst alexaway-packages
  '(
    org
    cal-china-x
    )
  "The list of Lisp packages required by the alexaway layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun alexaway/init-org()
  (use-package org
                                        ;:defer t
    :init
    (progn
      (setq org-agenda-files (quote("~/.emacs.d/private/alexaway/KILL.org"
                                    "~/.emacs.d/private/alexaway/refile.org"
                                    "~/.emacs.d/private/alexaway/diary.org")))

                                        ;key bindings
      (global-set-key (kbd "<f12>") 'org-agenda)
      (global-set-key (kbd "C-c c") 'org-capture)
      (global-set-key (kbd "<f11>") 'org-clock-goto)
      (global-set-key (kbd "<f9> I") 'bh/punch-in)
      (global-set-key (kbd "<f9> O") 'bh/punch-out)
      (global-set-key (kbd "<f8>") 'calendar)
      (global-set-key "\C-cb" 'org-iswitchb)
                                        ;todo keywords 
      (setq org-todo-keywords
            (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                    (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
      (setq org-todo-keyword-faces
            (quote (("TODO" :foreground "red" :weight bold)
                    ("NEXT" :foreground "blue" :weight bold)
                    ("DONE" :foreground "forest green" :weight bold)
                    ("WAITING" :foreground "orange" :weight bold)
                    ("HOLD" :foreground "magenta" :weight bold)
                    ("CANCELLED" :foreground "forest green" :weight bold)
                    ("MEETING" :foreground "forest green" :weight bold)
                    ("PHONE" :foreground "forest green" :weight bold))
                   )
            )
                                        ;fast todo selection
      (setq org-use-fast-todo-selection t)
      (setq org-treat-S-cursor-todo-selection-as-state-change nil)
                                        ;todo state trigger
      (setq org-todo-state-tags-triggers
            (quote (("CANCELLED" ("CANCELLED" . t))
                    ("WAITING" ("WAITING" . t))
                    ("HOLD" ("WAITING") ("HOLD" . t))
                    (done ("WAITING") ("HOLD"))
                    ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                    ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                    ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

      (setq org-directory "~/.emacs.d/private/alexaway")
      (setq org-default-notes-file "~/.emacs.d/private/alexaway/refile.org")
      ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
      (setq org-capture-templates
            (quote (("t" "todo" entry (file "~/.emacs.d/private/alexaway/refile.org")
                     "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                    ("r" "respond" entry (file "~/.emacs.d/private/alexaway/refile.org")
                     "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                    ("n" "note" entry (file "~/.emacs.d/private/alexaway/refile.org")
                     "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                    ("j" "Journal" entry (file+datetree "~/.emacs.d/private/alexaway/diary.org")
                     "* %?\n%U\n" :clock-in t :clock-resume t)
                    ("w" "org-protocol" entry (file "~/.emacs.d/private/alexaway/refile.org")
                     "* TODO Review %c\n%U\n" :immediate-finish t)
                    ("m" "Meeting" entry (file "~/.emacs.d/private/alexaway/refile.org")
                     "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                    ("p" "Phone call" entry (file "~/.emacs.d/private/alexaway/refile.org")
                     "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                    ("h" "Habit" entry (file "~/.emacs.d/private/alexaway/KILL.org")
                     "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
      ;; Remove empty LOGBOOK drawers on clock out
      (defun bh/remove-empty-drawer-on-clock-out ()
        (interactive)
        (save-excursion
          (beginning-of-line 0)
          (org-remove-empty-drawer-at "LOGBOOK" (point))))

      (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

      ;;;;;Refile 
                                        ; Targets include this file and any file contributing to the agenda - up to 9 levels deep
      (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                       (org-agenda-files :maxlevel . 9))))

                                        ; Use full outline paths for refile targets - we file directly with IDO
      (setq org-refile-use-outline-path t)

                                        ; Targets complete directly with IDO
      (setq org-outline-path-complete-in-steps nil)

                                        ; Allow refile to create parent tasks with confirmation
      (setq org-refile-allow-creating-parent-nodes (quote confirm))

                                        ; Use IDO for both buffer and file completion and ido-everywhere to t
      (setq org-completion-use-ido t)
      (setq ido-everywhere t)
      (setq ido-max-directory-size 100000)
      (ido-mode (quote both))
                                        ; Use the current window when visiting files and buffers with ido
      (setq ido-default-file-method 'selected-window)
      (setq ido-default-buffer-method 'selected-window)
                                        ; Use the current window for indirect buffer display
      (setq org-indirect-buffer-display 'current-window)

      ;;;; Refile settings
                                        ; Exclude DONE state tasks from refile targets
      (defun bh/verify-refile-target ()
        "Exclude todo keywords with a done state from refile targets"
        (not (member (nth 2 (org-heading-components)) org-done-keywords)))

      (setq org-refile-target-verify-function 'bh/verify-refile-target)


      ;;customize the Agenda view
      ;; Do not dim blocked tasks
      (setq org-agenda-dim-blocked-tasks nil)

      ;; Compact the block agenda view
      (setq org-agenda-compact-blocks t)

      ;; Custom agenda command definitions
      (setq org-agenda-custom-commands
            (quote (("N" "Notes" tags "NOTE"
                     ((org-agenda-overriding-header "Notes")
                      (org-tags-match-list-sublevels t)))
                    ("h" "Habits" tags-todo "STYLE=\"habit\""
                     ((org-agenda-overriding-header "Habits")
                      (org-agenda-sorting-strategy
                       '(todo-state-down effort-up category-keep))))
                    (" " "Agenda"
                     ((agenda "" nil)
                      (tags "REFILE"
                            ((org-agenda-overriding-header "Tasks to Refile")
                             (org-tags-match-list-sublevels nil)))
                      (tags-todo "-CANCELLED/!"
                                 ((org-agenda-overriding-header "Stuck Projects")
                                  (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-HOLD-CANCELLED/!"
                                 ((org-agenda-overriding-header "Projects")
                                  (org-agenda-skip-function 'bh/skip-non-projects)
                                  (org-tags-match-list-sublevels 'indented)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-CANCELLED/!NEXT"
                                 ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                                  (org-tags-match-list-sublevels t)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(todo-state-down effort-up category-keep))))
                      (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                                 ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-non-project-tasks)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                                 ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-project-tasks)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-CANCELLED+WAITING|HOLD/!"
                                 ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-non-tasks)
                                  (org-tags-match-list-sublevels nil)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                      (tags "-REFILE/"
                            ((org-agenda-overriding-header "Tasks to Archive")
                             (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                             (org-tags-match-list-sublevels nil))))
                     nil))))

      (defun bh/org-auto-exclude-function (tag)
        "Automatic task exclusion in the agenda with / RET"
        (and (cond
              ((string= tag "hold")
               t)
              ((string= tag "farm")
               t))
             (concat "-" tag)))

      (setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)





      ;;
      ;; Resume clocking task when emacs is restarted
      (org-clock-persistence-insinuate)
      ;;
      ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
      (setq org-clock-history-length 23)
      ;; Resume clocking task on clock-in if the clock is open
      (setq org-clock-in-resume t)
      ;; Change tasks to NEXT when clocking in
      (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
      ;; Separate drawers for clocking and logs
      (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
      ;; Save clock data and state changes and notes in the LOGBOOK drawer
      (setq org-clock-into-drawer t)
      ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
      (setq org-clock-out-remove-zero-time-clocks t)
      ;; Clock out when moving task to a done state
      (setq org-clock-out-when-done t)
      ;; Save the running clock and all clock history when exiting Emacs, load it on startup
      (setq org-clock-persist t)
      ;; Do not prompt to resume an active clock
      (setq org-clock-persist-query-resume nil)
      ;; Enable auto clock resolution for finding open clocks
      (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
      ;; Include current clocking task in clock reports
      (setq org-clock-report-include-clocking-task t)

      (setq bh/keep-clock-running nil)

      (defun bh/clock-in-to-next (kw)
        "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
        (when (not (and (boundp 'org-capture-mode) org-capture-mode))
          (cond
           ((and (member (org-get-todo-state) (list "TODO"))
                 (bh/is-task-p))
            "NEXT")
           ((and (member (org-get-todo-state) (list "NEXT"))
                 (bh/is-project-p))
            "TODO"))))

      (defun bh/find-project-task ()
        "Move point to the parent (project) task if any"
        (save-restriction
          (widen)
          (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
            (while (org-up-heading-safe)
              (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
                (setq parent-task (point))))
            (goto-char parent-task)
            parent-task)))

      (defun bh/punch-in (arg)
        "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
        (interactive "p")
        (setq bh/keep-clock-running t)
        (if (equal major-mode 'org-agenda-mode)
            ;;
            ;; We're in the agenda
            ;;
            (let* ((marker (org-get-at-bol 'org-hd-marker))
                   (tags (org-with-point-at marker (org-get-tags-at))))
              (if (and (eq arg 4) tags)
                  (org-agenda-clock-in '(16))
                (bh/clock-in-organization-task-as-default)))
          ;;
          ;; We are not in the agenda
          ;;
          (save-restriction
            (widen)
                                        ; Find the tags on the current task
            (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
                (org-clock-in '(16))
              (bh/clock-in-organization-task-as-default)))))

      (defun bh/punch-out ()
        (interactive)
        (setq bh/keep-clock-running nil)
        (when (org-clock-is-active)
          (org-clock-out))
        (org-agenda-remove-restriction-lock))

      (defun bh/clock-in-default-task ()
        (save-excursion
          (org-with-point-at org-clock-default-task
            (org-clock-in))))

      (defun bh/clock-in-parent-task ()
        "Move point to the parent (project) task if any and clock in"
        (let ((parent-task))
          (save-excursion
            (save-restriction
              (widen)
              (while (and (not parent-task) (org-up-heading-safe))
                (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
                  (setq parent-task (point))))
              (if parent-task
                  (org-with-point-at parent-task
                    (org-clock-in))
                (when bh/keep-clock-running
                  (bh/clock-in-default-task)))))))

      (defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

      (defun bh/clock-in-organization-task-as-default ()
        (interactive)
        (org-with-point-at (org-id-find bh/organization-task-id 'marker)
          (org-clock-in '(16))))

      (defun bh/clock-out-maybe ()
        (when (and bh/keep-clock-running
                   (not org-clock-clocking-in)
                   (marker-buffer org-clock-default-task)
                   (not org-clock-resolving-clocks-due-to-idleness))
          (bh/clock-in-parent-task)))

      (add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

      (require 'org-id)
      (defun bh/clock-in-task-by-id (id)
        "Clock in a task by id"
        (org-with-point-at (org-id-find id 'marker)
          (org-clock-in nil)))

      (defun bh/clock-in-last-task (arg)
        "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
        (interactive "p")
        (let ((clock-in-to-task
               (cond
                ((eq arg 4) org-clock-default-task)
                ((and (org-clock-is-active)
                      (equal org-clock-default-task (cadr org-clock-history)))
                 (caddr org-clock-history))
                ((org-clock-is-active) (cadr org-clock-history))
                ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
                (t (car org-clock-history)))))
          (widen)
          (org-with-point-at clock-in-to-task
            (org-clock-in nil))))

      (defun bh/is-project-p ()
        "Any task with a todo keyword subtask"
        (save-restriction
          (widen)
          (let ((has-subtask)
                (subtree-end (save-excursion (org-end-of-subtree t)))
                (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
            (save-excursion
              (forward-line 1)
              (while (and (not has-subtask)
                          (< (point) subtree-end)
                          (re-search-forward "^\*+ " subtree-end t))
                (when (member (org-get-todo-state) org-todo-keywords-1)
                  (setq has-subtask t))))
            (and is-a-task has-subtask))))

      (defun bh/is-project-subtree-p ()
        "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
        (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                                    (point))))
          (save-excursion
            (bh/find-project-task)
            (if (equal (point) task)
                nil
              t))))

      (defun bh/is-task-p ()
        "Any task with a todo keyword and no subtask"
        (save-restriction
          (widen)
          (let ((has-subtask)
                (subtree-end (save-excursion (org-end-of-subtree t)))
                (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
            (save-excursion
              (forward-line 1)
              (while (and (not has-subtask)
                          (< (point) subtree-end)
                          (re-search-forward "^\*+ " subtree-end t))
                (when (member (org-get-todo-state) org-todo-keywords-1)
                  (setq has-subtask t))))
            (and is-a-task (not has-subtask)))))

      (defun bh/is-subproject-p ()
        "Any task which is a subtask of another project"
        (let ((is-subproject)
              (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
          (save-excursion
            (while (and (not is-subproject) (org-up-heading-safe))
              (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
                (setq is-subproject t))))
          (and is-a-task is-subproject)))

      (defun bh/list-sublevels-for-projects-indented ()
        "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
        (if (marker-buffer org-agenda-restrict-begin)
            (setq org-tags-match-list-sublevels 'indented)
          (setq org-tags-match-list-sublevels nil))
        nil)

      (defun bh/list-sublevels-for-projects ()
        "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
        (if (marker-buffer org-agenda-restrict-begin)
            (setq org-tags-match-list-sublevels t)
          (setq org-tags-match-list-sublevels nil))
        nil)

      (defvar bh/hide-scheduled-and-waiting-next-tasks t)

      (defun bh/toggle-next-task-display ()
        (interactive)
        (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
        (when  (equal major-mode 'org-agenda-mode)
          (org-agenda-redo))
        (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

      (defun bh/skip-stuck-projects ()
        "Skip trees that are not stuck projects"
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (if (bh/is-project-p)
                (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                       (has-next ))
                  (save-excursion
                    (forward-line 1)
                    (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                      (unless (member "WAITING" (org-get-tags-at))
                        (setq has-next t))))
                  (if has-next
                      nil
                    next-headline)) ; a stuck project, has subtasks but no next task
              nil))))

      (defun bh/skip-non-stuck-projects ()
        "Skip trees that are not stuck projects"
        ;; (bh/list-sublevels-for-projects-indented)
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (if (bh/is-project-p)
                (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                       (has-next ))
                  (save-excursion
                    (forward-line 1)
                    (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                      (unless (member "WAITING" (org-get-tags-at))
                        (setq has-next t))))
                  (if has-next
                      next-headline
                    nil)) ; a stuck project, has subtasks but no next task
              next-headline))))

      (defun bh/skip-non-projects ()
        "Skip trees that are not projects"
        ;; (bh/list-sublevels-for-projects-indented)
        (if (save-excursion (bh/skip-non-stuck-projects))
            (save-restriction
              (widen)
              (let ((subtree-end (save-excursion (org-end-of-subtree t))))
                (cond
                 ((bh/is-project-p)
                  nil)
                 ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
                  nil)
                 (t
                  subtree-end))))
          (save-excursion (org-end-of-subtree t))))

      (defun bh/skip-non-tasks ()
        "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (cond
             ((bh/is-task-p)
              nil)
             (t
              next-headline)))))

      (defun bh/skip-project-trees-and-habits ()
        "Skip trees that are projects"
        (save-restriction
          (widen)
          (let ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              subtree-end)
             ((org-is-habit-p)
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-projects-and-habits-and-single-tasks ()
        "Skip trees that are projects, tasks that are habits, single non-project tasks"
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (cond
             ((org-is-habit-p)
              next-headline)
             ((and bh/hide-scheduled-and-waiting-next-tasks
                   (member "WAITING" (org-get-tags-at)))
              next-headline)
             ((bh/is-project-p)
              next-headline)
             ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
              next-headline)
             (t
              nil)))))

      (defun bh/skip-project-tasks-maybe ()
        "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
        (save-restriction
          (widen)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (next-headline (save-excursion (or (outline-next-heading) (point-max))))
                 (limit-to-project (marker-buffer org-agenda-restrict-begin)))
            (cond
             ((bh/is-project-p)
              next-headline)
             ((org-is-habit-p)
              subtree-end)
             ((and (not limit-to-project)
                   (bh/is-project-subtree-p))
              subtree-end)
             ((and limit-to-project
                   (bh/is-project-subtree-p)
                   (member (org-get-todo-state) (list "NEXT")))
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-project-tasks ()
        "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
        (save-restriction
          (widen)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              subtree-end)
             ((org-is-habit-p)
              subtree-end)
             ((bh/is-project-subtree-p)
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-non-project-tasks ()
        "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
        (save-restriction
          (widen)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (cond
             ((bh/is-project-p)
              next-headline)
             ((org-is-habit-p)
              subtree-end)
             ((and (bh/is-project-subtree-p)
                   (member (org-get-todo-state) (list "NEXT")))
              subtree-end)
             ((not (bh/is-project-subtree-p))
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-projects-and-habits ()
        "Skip trees that are projects and tasks that are habits"
        (save-restriction
          (widen)
          (let ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              subtree-end)
             ((org-is-habit-p)
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-non-subprojects ()
        "Skip trees that are not projects"
        (let ((next-headline (save-excursion (outline-next-heading))))
          (if (bh/is-subproject-p)
              nil
            next-headline)))
      
      (require 'org-crypt)
                                        ; Encrypt all entries before saving
      (org-crypt-use-before-save-magic)
      (setq org-tags-exclude-from-inheritance (quote ("crypt")))
                                        ; GPG key to use for encryption
      (setq org-crypt-key "F0B66B40")

      (defun my-org-screenshot ()
        "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
        (interactive)
        (org-display-inline-images)
        (setq filename
              (concat
               (make-temp-name
                (concat (file-name-nondirectory (buffer-file-name))
                        "_imgs/"
                        (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
        (unless (file-exists-p (file-name-directory filename))
          (make-directory (file-name-directory filename)))
                                        ; take screenshot
        (if (eq system-type 'darwin)
            (progn
              (call-process-shell-command "screencapture" nil nil nil nil " -s " (concat
                                                                                  "\"" filename "\"" ))
              (call-process-shell-command "convert" nil nil nil nil (concat "\"" filename "\" -resize  \"50%\"" ) (concat "\"" filename "\"" ))
              ))
        (if (eq system-type 'gnu/linux)
            (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
        (if (file-exists-p filename)
            (insert (concat "[[file:" filename "]]")))
        (org-display-inline-images)
        )

      (global-set-key (kbd "C-c s c") 'my-org-screenshot)


                                        ;允许自动换行
      (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

                                        ; Enable habit tracking (and a bunch of other modules)
      (setq org-modules (quote (org-bbdb
                                org-bibtex
                                org-crypt
                                org-gnus
                                org-id
                                org-info
                                org-jsinfo
                                org-habit
                                org-inlinetask
                                org-irc
                                org-mew
                                org-mhe
                                org-protocol
                                org-rmail
                                org-vm
                                org-wl
                                org-w3m)))

                                        ; position the habit graph on the agenda to the right of the default
      (setq org-habit-graph-column 50)

      (setq org-pretty-entities t)


      
      )
    )
  )

(defun alexaway/init-cal-china-x()
  (use-package cal-china-x
    :init
    (progn
      (setq mark-holidays-in-calendar t)
      ;(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
      (setq holiday-alexaway-holidays
            '(;;公历节日
              (holiday-fixed 1 1 "元旦")
              (holiday-fixed 2 14 "情人节")
              (holiday-fixed 3 8 "妇女节")
              (holiday-fixed 3 14 "白色情人节")
              (holiday-fixed 4 1 "愚人节")
              (holiday-fixed 5 1 "劳动节")
              (holiday-float 5 0 2 "母亲节")
              (holiday-fixed 6 1 "儿童节")
              (holiday-float 6 0 3 "父亲节")
              (holiday-fixed 9 10 "教师节")
              (holiday-fixed 10 1 "国庆节")
              (holiday-fixed 12 25 "圣诞节")
              ;; 农历节日
              (holiday-lunar 1 1 "春节" 0)
              (holiday-lunar 1 2 "春节" 0)
              (holiday-lunar 1 3 "春节" 0)
              (holiday-lunar 1 15 "元宵节" 0)
              (holiday-solar-term "清明" "清明节")
              (holiday-lunar 5 5 "端午节" 0)
              (holiday-lunar 8 15 "中秋节" 0)
              ;; 生日 -- 家人,朋友
              (holiday-fixed 8 11 "亲爱的生日")
              (holiday-lunar 6 29 "老妈生日")
              (holiday-lunar 9 29 "老爸生日")
              (holiday-lunar 12 9 "陈都生日")
              (holiday-lunar 12 19 "姜友友生日")
              (holiday-fixed 2 8 "杜兴逸生日")
              (holiday-fixed 11 14 "孙硕生日")
              (holiday-fixed 4 20 "贾晓楠生日")
              (holiday-fixed 4 9 "郑世鹏生日")
              (holiday-fixed 5 25 "于京洋生日")
              (holiday-fixed 3 10 "张天雨生日")
              (holiday-fixed 11 8 "刘可生日")
              (holiday-fixed 7 26 "吉晓飞生日")
              (holiday-fixed 5 10 "张元嘉生日")
              ))
      (setq calendar-holidays holiday-alexaway-holidays)
      (setq calendar-mark-holidays-flag t)

      )

    )
  )

;;; packages.el ends here

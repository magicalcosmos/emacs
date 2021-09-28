(use-package magit
  :ensure t
  :bind ("C-M-;" . magit-status)
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(bl/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gm"   '(:ignore t :which-key "merge")
  "gmm"  'magit-merge
  "gme"  'magit-merge-editmsg
  "gmn"  'magit-merge-nocommit
  "gmi"  'magit-merge-into
  "gms"  'magit-merge-squash
  "gmp"  'magit-merge-preview
  "gr"  'magit-rebase)
  (use-package forge
:disabled)
(use-package magit-todos
:defer t)
(use-package git-link
:ensure t
:commands git-link
:config
(setq git-link-open-in-browser t)
(bl/leader-key-def
      "gL"  'git-link))

(use-package git-gutter-fringe)

(use-package git-gutter
:ensure t
:diminish
:hook ((text-mode . git-gutter-mode)
       (prog-mode . git-gutter-mode))
:config
(setq git-gutter:update-interval 2)
(unless bl/is-termux
  (require 'git-gutter-fringe)
  (set-face-foreground 'git-gutter-fr:added "LightGreen")
  (fringe-helper-define 'git-gutter-fr:added nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
  (fringe-helper-define 'git-gutter-fr:modified nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
  (fringe-helper-define 'git-gutter-fr:deleted nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"))

;; These characters are used in terminal mode
(setq git-gutter:modified-sign "≡")
(setq git-gutter:added-sign "≡")
(setq git-gutter:deleted-sign "≡")
(set-face-foreground 'git-gutter:added "LightGreen")
(set-face-foreground 'git-gutter:modified "LightGoldenrod")
(set-face-foreground 'git-gutter:deleted "LightCoral"))


(provide 'init-magit)

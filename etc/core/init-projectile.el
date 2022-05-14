(defun bl/switch-project-action ()
  "Switch to a workspace with the project name and start `magit-status'."
  ;; TODO: Switch to EXWM workspace 1?
  (persp-switch (projectile-project-name))
  (magit-status))
(use-package ripgrep
  :ensure t)

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :init
  (projectile-mode +1)
  (when (file-directory-p "~/workspace/web")
    (setq projectile-project-search-path '("~/workspace/web")))
  (setq projectile-switch-project-action #'bl/switch-project-action))


(use-package counsel-projectile
  :ensure t
  :disabled
  :after projectile
  :config
  (counsel-projectile-mode))

(bl/leader-key-def
  "pf"  'counsel-projectile-find-file
  "ps"  'counsel-projectile-switch-project
  "pF"  'consult-ripgrep
  "pp"  'counsel-projectile-find-file
  "pc"  'projectile-compile-project
  "pd"  'projectile-dired)

;; Built-in project package
(require 'project)
;(global-set-key (kbd "C-x p f") #'project-find-file)
(global-set-key (kbd "C-x p f") #'project-or-external-find-file)

(bl/ctrl-c-keys
 "pp" 'counsel-projectile-switch-project
 "pf" 'counsel-projectile-find-file
 "pg" 'counsel-projectile-find-file-dwim
 "pd" 'counsel-projectile-find-dir
 "pb" 'counsel-projectile-switch-to-buffer
 "psg" 'counsel-projectile-grep
 "pss" 'counsel-projectile-ag
 "psr" 'counsel-projectile-rg
 "psSPC" 'counsel-projectile
 "psi" 'counsel-projectile-git-grep
 "p0c" 'counsel-projectile-org-capture
 "p0a" 'counsel-projectile-org-agenda)

(provide 'init-projectile)

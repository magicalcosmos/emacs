(defun bl/switch-project-action ()
  "Switch to a workspace with the project name and start `magit-status'."
  ;; TODO: Switch to EXWM workspace 1?
  (persp-switch (projectile-project-name))
  (magit-status))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind ("C-M-p" . projectile-find-file)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
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
  "pf"  'projectile-find-file
  "ps"  'projectile-switch-project
  "pF"  'consult-ripgrep
  "pp"  'projectile-find-file
  "pc"  'projectile-compile-project
  "pd"  'projectile-dired)

;; Built-in project package
(require 'project)
;(global-set-key (kbd "C-x p f") #'project-find-file)
(global-set-key (kbd "C-x p f") #'project-or-external-find-file)


(provide 'init-projectile)

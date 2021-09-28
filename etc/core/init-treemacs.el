

(use-package treemacs-projectile
:after (treemacs projectile)
:ensure t)

(use-package treemacs-icons-dired
:after (treemacs dired)
:ensure t
:config (treemacs-icons-dired-mode))

(use-package treemacs-magit
:after (treemacs magit)
:ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
:after (treemacs persp-mode) ;;or perspective vs. persp-mode
:ensure t
:config (treemacs-set-scope-type 'Perspectives))


(provide 'init-treemacs)

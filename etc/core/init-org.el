(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(use-package org
    :ensure t
    :pin org)

(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))


(provide 'init-org)

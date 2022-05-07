; Auctex stuff
 (setq TeX-auto-save t)
 (setq TeX-parse-self t)
 (setq-default TeX-master nil)
 (add-to-list 'org-latex-packages-alist '("" "listings" nil))
 (setq org-latex-listings t)
 (setq org-latex-listings-options '(("breaklines" "true")))

 (use-package auctex
   :ensure t)

 (add-hook 'LaTeX-mode-hook 'visual-line-mode)
 (add-hook 'LaTeX-mode-hook 'flyspell-mode)
 (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

 (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(provide 'init-latex)

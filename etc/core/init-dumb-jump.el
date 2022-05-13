(use-package dumb-jump
   :ensure t)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (defhydra dumb-jump-hydra (:color blue :columns 3)
  "Dumb Jump"
  ("j" dumb-jump-go "Go")
  ("o" dumb-jump-go-other-window "Other window")
  ("e" dumb-jump-go-prefer-external "Go external")
  ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
  ("i" dumb-jump-go-prompt "Prompt")
  ("l" dumb-jump-quick-look "Quick look")
  ("b" dumb-jump-back "Back"))

(setq xref-show-definitions-function #'xref-show-definitions-completing-read)
(setq dumb-jump-prefer-searcher 'ag)
(provide 'init-dumb-jump)

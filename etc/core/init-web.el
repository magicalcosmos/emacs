(use-package web-mode
  :ensure
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|jsx\\|vue\\)\\'"
  :config
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2))



  (provide 'init-web)

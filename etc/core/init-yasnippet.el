
(use-package yasnippet
:hook (prog-mode . yas-minor-mode)
:config
(use-package yasnippet-snippets
:after (yasnippet))
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        ))
    (yas-reload-all))
(use-package auto-yasnippet
  :bind
  (("C-c & w" . aya-create)
   ("C-c & y" . aya-expand))
  :config
  (setq aya-persist-snippets-dir (concat user-emacs-directory "snippets")))


  (provide 'init-yasnippet)

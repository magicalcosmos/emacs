;; lsp-mode
(setq lsp-log-io nil) ;; Don't log everything = speed
(setq lsp-keymap-prefix "C-c l")
(setq lsp-restart 'auto-restart)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover t)
(setq lsp-ui-sideline-show-code-actions t)

(use-package lsp-mode
  :ensure t
  :hook (
   (go-mode . lsp-deferred)
   (js-mode . lsp-deferred)
   (json-mode . lsp-deferred)
   (web-mode . lsp-deferred)
   (vue-mode . lsp-deferred)
   (html-mode . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration)
   )
  :commands (lsp lsp-deferred))


(use-package lsp-ui
  :after lsp-mode
  :hook(lsp-mode . lsp-ui-mode)
  :init(setq lsp-ui-doc-enable nil
             lsp-ui-doc-use-webkit nil
             lsp-ui-doc-delay 0
             lsp-ui-doc-include-signature t
             lsp-ui-doc-position 'at-point
             lsp-ui-sideline-enable t
             lsp-ui-sideline-show-hover nil
             lsp-ui-sideline-show-diagnostics nil
             lsp-ui-sideline-ignore-duplicate t)
  :config(setq lsp-ui-flycheck-enable t)
  :commands lsp-ui-mode)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
    (funcall (cdr my-pair)))))

(use-package prettier-js
  :ensure t)
(add-hook 'web-mode-hook #'(lambda ()
          (enable-minor-mode
          '("\\.vue?\\'" . prettier-js-mode))
          (enable-minor-mode
          '("\\.jsx?\\'" . prettier-js-mode))
          (enable-minor-mode
          '("\\.js?\\'" . prettier-js-mode))
          (enable-minor-mode
          '("\\.ts?\\'" . prettier-js-mode))
          (enable-minor-mode
          '("\\.tsx?\\'" . prettier-js-mode))))


(straight-use-package
 '(lsp-volar :type git :host github :repo "jadestrong/lsp-volar"))


(use-package lsp-volar
             :straight t)


(provide 'init-lsp)

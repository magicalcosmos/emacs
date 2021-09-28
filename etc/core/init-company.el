(use-package company
:ensure t
:config
(setq company-tooltip-align-annotations t)
(setq company-tooltip-limit 20)
(setq company-show-numbers t)
(setq company-idle-delay 0.2)
(setq company-minimum-prefix-length 3)

(global-company-mode t)
)


(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)
(use-package company-jedi
    :ensure t
    :config
    (add-hook 'python-mode-hook 'jedi:setup)
       )

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)


(provide 'init-company)

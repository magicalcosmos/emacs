(use-package multiple-cursors
  :ensure t
  :bind
  ("C-S-<mouse-1>" . mc/toggle-cursor-on-click))

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(provide 'init-multiple-cursors)

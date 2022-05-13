;;; init-minimap.el -- -*- lexical-binding: t; -*-
;;; Commentary:

;;;Code

(use-package minimap
  :defer t
  :config
  (setq minimap-window-location 'right
        minimap-update-delay 0
        minimap-width-fraction 0.09
        minimap-minimum-width 15)
  (pushnew! minimap-major-modes 'text-mode 'conf-mode))
(provide 'init-minimap)

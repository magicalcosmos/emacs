(use-package ivy-posframe
  :ensure t)
;; Different command can use different display function.
(setq ivy-posframe-display-functions-alist
   '((swiper          . ivy-posframe-display-at-window-center)
     (complete-symbol . ivy-posframe-display-at-window-center)
     (counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
     (counsel-find-file     . ivy-posframe-display-at-window-center)
     (fuzzy-finder-find-files-projectile     . ivy-posframe-display-at-window-center)
     (t               . ivy-posframe-display-at-window-center)))
 (ivy-posframe-mode 1)
 (setq ivy-posframe-height-alist '((swiper . 10)
                                   (t      . 10)))

(setq ivy-posframe-parameters
      '((left-fringe . 10)
        (right-fringe . 10)))

(provide 'init-ivy-posframe)

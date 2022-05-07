(use-package helm
  :init
   (require 'helm-config)
   (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
         helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
         helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
         helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
         helm-ff-file-name-history-use-recentf t
         helm-echo-input-in-header-line nil)
    ; (setq helm-autoresize-max-height 0)
    ; (setq helm-autoresize-min-height 20)
   (setq helm-buffers-fuzzy-matching nil
         helm-recentf-fuzzy-match    nil)
  :config
    (helm-mode 1) ;; Most of Emacs prompts become helm-enabled
    (helm-autoresize-mode 1) ;; Helm resizes according to the number of candidates
    ;(global-set-key (kbd "C-x b") 'helm-buffers-list) ;; List buffers ( Emacs way )
    ; (define-key evil-ex-map "b" 'helm-buffers-list) ;; List buffers ( Vim way )
    (global-set-key (kbd "C-x b") 'helm-mini) ;; List buffers ( Emacs way )
    (define-key evil-ex-map "b" 'helm-mini) ;; List buffers ( Vim way )
    (global-set-key (kbd "C-x r b") 'helm-bookmarks) ;; Bookmarks menu
    (global-set-key (kbd "C-x C-f") 'helm-find-files) ;; Finding files with Helm
    (global-set-key (kbd "M-c") 'helm-calcul-expression) ;; Use Helm for calculations
    (global-set-key (kbd "C-s") 'helm-occur)  ;; Replaces the default isearch keybinding
    (global-set-key (kbd "C-h a") 'helm-apropos)  ;; Helmized apropos interface
    (global-set-key (kbd "M-x") 'helm-M-x)  ;; Improved M-x menu
    (global-set-key (kbd "M-y") 'helm-show-kill-ring)  ;; Show kill ring, pick something to paste
  :ensure t)

; (setq helm-display-function 'helm-display-buffer-in-own-frame
;       helm-display-buffer-reuse-frame t
;       helm-use-undecorated-frame-option t)

; (use-package helm-ls-git
;              :ensure t)

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

(use-package helm-projectile
             :ensure t)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(global-set-key (kbd "M-p") #'helm-projectile-find-file)

(provide 'init-helm)

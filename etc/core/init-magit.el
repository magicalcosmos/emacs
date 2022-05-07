(use-package magit
  :ensure t
  :init (setq magit-diff-refine-hunk t)
  :bind ("C-M-;" . magit-status)
  :config
  (when (fboundp 'transient-append-suffix)
  ;; Add switch: --tags
  (transient-append-suffix 'magit-fetch
    "-p" '("-t" "Fetch all tags" ("-t" "--tags"))))

  ;; Exterminate Magit buffers
  (with-no-warnings
    (defun my-magit-kill-buffers (&rest _)
      "Restore window configuration and kill all Magit buffers."
      (interactive)
      (magit-restore-window-configuration)
      (let ((buffers (magit-mode-get-buffers)))
        (when (eq major-mode 'magit-status-mode)
          (mapc (lambda (buf)
                  (with-current-buffer buf
                    (if (and magit-this-process
                             (eq (process-status magit-this-process) 'run))
                        (bury-buffer buf)
                      (kill-buffer buf))))
                buffers))))
    (setq magit-bury-buffer-function #'my-magit-kill-buffers))

  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(bl/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gm"   '(:ignore t :which-key "merge")
  "gmm"  'magit-merge
  "gme"  'magit-merge-editmsg
  "gmn"  'magit-merge-nocommit
  "gmi"  'magit-merge-into
  "gms"  'magit-merge-squash
  "gmp"  'magit-merge-preview
  "gr"  'magit-rebase)
  (use-package forge
:disabled)

;; Show TODOs in magit
(use-package magit-todos
  :bind ("C-c t" . ivy-magit-todos)
  :init
  (setq magit-todos-nice (if (executable-find "nice") t nil))
  (let ((inhibit-message t))
    (magit-todos-mode 1))
  :config
  (transient-append-suffix 'magit-status-jump '(0 0 -1)
    '("T " "Todos" magit-todos-jump-to-todos)))


(use-package git-link
:ensure t
:commands git-link
:config
(setq git-link-open-in-browser t)
(bl/leader-key-def
      "gL"  'git-link))

(use-package git-gutter-fringe)

(use-package git-gutter
:ensure t
:diminish
:hook ((text-mode . git-gutter-mode)
       (prog-mode . git-gutter-mode))
:config
(setq git-gutter:update-interval 2)
(unless bl/is-termux
  (require 'git-gutter-fringe)
  (set-face-foreground 'git-gutter-fr:added "LightGreen")
  (fringe-helper-define 'git-gutter-fr:added nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
  (fringe-helper-define 'git-gutter-fr:modified nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
  (fringe-helper-define 'git-gutter-fr:deleted nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"))

;; These characters are used in terminal mode
(setq git-gutter:modified-sign "≡")
(setq git-gutter:added-sign "≡")
(setq git-gutter:deleted-sign "≡")
(set-face-foreground 'git-gutter:added "LightGreen")
(set-face-foreground 'git-gutter:modified "LightGoldenrod")
(set-face-foreground 'git-gutter:deleted "LightCoral"))


;; Display transient in child frame
(defcustom centaur-completion-style 'childframe
  "Completion display style."
  :group 'centaur
  :type '(choice (const :tag "Minibuffer" minibuffer)
                 (const :tag "Child Frame" childframe)))

(defun childframe-workable-p ()
  "Test whether childframe is workable."
 (eq centaur-completion-style 'childframe)
 (not (or noninteractive
          emacs-basic-display
          (not (display-graphic-p)))))

(when (childframe-workable-p)
  (use-package transient-posframe
    :diminish
    :custom-face
    (transient-posframe ((t (:inherit tooltip))))
    (transient-posframe-border ((t (:background ,(face-foreground 'font-lock-comment-face nil t)))))
    :hook (after-init . transient-posframe-mode)
    :init
    (setq transient-posframe-border-width 3
          transient-posframe-min-height nil
          transient-posframe-min-width 80
          transient-posframe-poshandler 'posframe-poshandler-frame-center
          transient-posframe-parameters '((left-fringe . 8)
                                          (right-fringe . 8)))
    :config
    (add-hook
     'after-load-theme-hook
     (lambda ()
       (custom-set-faces
        '(transient-posframe ((t (:inherit tooltip))))
        `(transient-posframe-border ((t (:background ,(face-foreground 'font-lock-comment-face nil t))))))))

    (with-no-warnings
      (defun my-transient-posframe--prettify-frame ()
        (with-current-buffer (get-buffer-create transient--buffer-name)
          (when posframe--frame
            (goto-char (point-min))
            (insert (propertize "\n" 'face '(:height 0.3)))
            (goto-char (point-max))
            (delete-char -3)          ; delete separate
            (insert (propertize "\n" 'face '(:height 0.5)))
            (posframe--set-frame-size posframe--frame nil nil nil nil))))
      (advice-add #'transient--show :after #'my-transient-posframe--prettify-frame))))

;; Walk through git revisions of a file
(use-package git-timemachine
  :custom-face
  (git-timemachine-minibuffer-author-face ((t (:inherit success))))
  (git-timemachine-minibuffer-detail-face ((t (:inherit warning))))
  :bind ("C-x g" . git-timemachine)
  :hook ((git-timemachine-mode . (lambda ()  "Display different colors in mode-line." (face-remap-add-relative 'mode-line 'custom-saved)))
         (before-revert . (lambda () (when (bound-and-true-p git-timemachine-mode) (user-error "Cannot revert the timemachine buffer"))))))

;; Pop up last commit information of current line
(use-package git-messenger
  :bind (:map vc-prefix-map
         ("p" . git-messenger:popup-message)
         :map git-messenger-map
         ("m" . git-messenger:copy-message))
  :init (setq git-messenger:show-detail t
              git-messenger:use-magit-popup t)
  :config
  (with-no-warnings
    (with-eval-after-load 'hydra
      (defhydra git-messenger-hydra (:color blue)
        ("s" git-messenger:popup-show "show")
        ("c" git-messenger:copy-commit-id "copy hash")
        ("m" git-messenger:copy-message "copy message")
        ("," (catch 'git-messenger-loop (git-messenger:show-parent)) "go parent")
        ("q" git-messenger:popup-close "quit")))

    (defun my-git-messenger:format-detail (vcs commit-id author message)
      (if (eq vcs 'git)
          (let ((date (git-messenger:commit-date commit-id))
                (colon (propertize ":" 'face 'font-lock-comment-face)))
            (concat
             (format "%s%s %s \n%s%s %s\n%s  %s %s \n"
                     (propertize "Commit" 'face 'font-lock-keyword-face) colon
                     (propertize (substring commit-id 0 8) 'face 'font-lock-comment-face)
                     (propertize "Author" 'face 'font-lock-keyword-face) colon
                     (propertize author 'face 'font-lock-string-face)
                     (propertize "Date" 'face 'font-lock-keyword-face) colon
                     (propertize date 'face 'font-lock-string-face))
             (propertize (make-string 38 ?─) 'face 'font-lock-comment-face)
             message
             (propertize "\nPress q to quit" 'face '(:inherit (font-lock-comment-face italic)))))
        (git-messenger:format-detail vcs commit-id author message)))

    (defun my-git-messenger:popup-message ()
      "Popup message with `posframe', `pos-tip', `lv' or `message', and dispatch actions with `hydra'."
      (interactive)
      (let* ((hydra-hint-display-type 'message)
             (vcs (git-messenger:find-vcs))
             (file (buffer-file-name (buffer-base-buffer)))
             (line (line-number-at-pos))
             (commit-info (git-messenger:commit-info-at-line vcs file line))
             (commit-id (car commit-info))
             (author (cdr commit-info))
             (msg (git-messenger:commit-message vcs commit-id))
             (popuped-message (if (git-messenger:show-detail-p commit-id)
                                  (my-git-messenger:format-detail vcs commit-id author msg)
                                (cl-case vcs
                                  (git msg)
                                  (svn (if (string= commit-id "-")
                                           msg
                                         (git-messenger:svn-message msg)))
                                  (hg msg)))))
        (setq git-messenger:vcs vcs
              git-messenger:last-message msg
              git-messenger:last-commit-id commit-id)
        (run-hook-with-args 'git-messenger:before-popup-hook popuped-message)
        (git-messenger-hydra/body)
        (cond ((and (fboundp 'posframe-workable-p) (posframe-workable-p))
               (let ((buffer-name "*git-messenger*"))
                 (posframe-show buffer-name
                                :string (concat (propertize "\n" 'face '(:height 0.3))
                                                popuped-message
                                                "\n"
                                                (propertize "\n" 'face '(:height 0.3)))
                                :left-fringe 8
                                :right-fringe 8
                                :width (round (* (frame-width) 0.62))
                                :height (round (* (frame-height) 0.62))
                                :internal-border-width 1
                                :internal-border-color (face-foreground 'font-lock-comment-face nil t)
                                :background-color (face-background 'tooltip nil t))
                 (unwind-protect
                     (push (read-event) unread-command-events)
                   (posframe-hide buffer-name))))
              ((and (fboundp 'pos-tip-show) (display-graphic-p))
               (pos-tip-show popuped-message))
              ((fboundp 'lv-message)
               (lv-message popuped-message)
               (unwind-protect
                   (push (read-event) unread-command-events)
                 (lv-delete-window)))
              (t (message "%s" popuped-message)))
        (run-hook-with-args 'git-messenger:after-popup-hook popuped-message)))
    (advice-add #'git-messenger:popup-close :override #'ignore)
    (advice-add #'git-messenger:popup-message :override #'my-git-messenger:popup-message)))

(provide 'init-magit)

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(setq package-enable-at-startup nil)

(use-package all-the-icons)
      (use-package doom-themes
      :ensure t
      :config
      ;; Global settings (defaults)
      (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
            doom-themes-enable-italic t) ; if nil, italics is universally disabled
      (load-theme 'doom-one t)

      ;; Enable flashing mode-line on errors
      (doom-themes-visual-bell-config)
      ;; Enable custom neotree theme (all-the-icons must be installed!)
      (doom-themes-neotree-config)
      ;; or for treemacs users
      (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
      (doom-themes-treemacs-config)
      ;; Corrects (and improves) org-mode's native fontification.
      (doom-themes-org-config))
      (use-package smart-mode-line
      :init
      (setq sml/no-confirm-load-theme t
      sml/theme 'respectful
    sml/mode-width 'right
  sml/name-width 60)
        (sml/setup))
  

  (setq rm-excluded-modes
    (mapconcat
      'identity
      ; These names must start with a space!
      '(" GitGutter" " MRev" " company"
      " Helm" " Undo-Tree" " Projectile.*" " Z" " Ind"
      " Org-Agenda.*" " ElDoc" " SP/s" " cider.*")
      "\\|"))
(use-package perspective
  :demand t
  :bind (("C-M-k" . persp-switch)
         ("C-M-n" . persp-next)
         ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-initial-frame-name "Main")
  :config
  ;; Running `persp-mode' multiple times resets the perspective list...
  (unless (equal persp-mode t)
    (persp-mode)))

(defun bl/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
  (add-to-list 'evil-emacs-state-modes mode)))
(defun bl/dont-arrow-me-bro ()
(interactive)
(message "Arrow keys are bad, you know?"))
        (use-package evil
          :init
          (setq evil-want-keybinding nil)
          (setq evil-want-integration t)
          (setq evil-want-C-u-scroll t)
          (setq evil-want-C-i-jump nil)
          (setq evil-respect-visual-line-mode t)
          :config
          (add-hook 'evil-mode-hook 'bl/evil-hook)
          (evil-mode 1)
          (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
          (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

          ;; Use visual line motions even outside of visual-line-mode buffers
          (evil-global-set-key 'motion "j" 'evil-next-visual-line)
          (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

          (unless bl/is-termux
            ;; Disable arrow keys in normal and visual modes
            (define-key evil-normal-state-map (kbd "<left>") 'bl/dont-arrow-me-bro)
            (define-key evil-normal-state-map (kbd "<right>") 'bl/dont-arrow-me-bro)
            (define-key evil-normal-state-map (kbd "<down>") 'bl/dont-arrow-me-bro)
            (define-key evil-normal-state-map (kbd "<up>") 'bl/dont-arrow-me-bro)
            (evil-global-set-key 'motion (kbd "<left>") 'bl/dont-arrow-me-bro)
            (evil-global-set-key 'motion (kbd "<right>") 'bl/dont-arrow-me-bro)
            (evil-global-set-key 'motion (kbd "<down>") 'bl/dont-arrow-me-bro)
            (evil-global-set-key 'motion (kbd "<up>") 'bl/dont-arrow-me-bro))

          (evil-set-initial-state 'messages-buffer-mode 'normal)
          (evil-set-initial-state 'dashboard-mode 'normal))
    (use-package evil-collection
      :after evil
      :custom
      (evil-collection-outline-bind-tab-p nil)
      :config
      (evil-collection-init))

(require 'org-tempo)

;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)

;; IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(use-package which-key 
:ensure t
:init (which-key-mode)
:diminish which-key-mode
:config
(setq which-key-idle-delay 0.3))

(use-package general
  :ensure t
  :config
  (general-evil-setup t)

  (general-create-definer bl/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer bl/ctrl-c-keys
    :prefix "C-c"))

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

(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-css-indent-offset 2)
  (use-package web-mode
    :ensure t
    :config
	   (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
	   (add-to-list 'auto-mode-alist '("\\.vue?\\'" . web-mode))
	   (setq web-mode-engines-alist
		 '(("django"    . "\\.html\\'")))
	   (setq web-mode-ac-sources-alist
	   '(("css" . (ac-source-css-property))
	   ("vue" . (ac-source-words-in-buffer ac-source-abbrev))
	 ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
(setq web-mode-enable-auto-closing t))
(setq web-mode-enable-auto-quoting t) ; this fixes the quote problem I mentioned

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
    :init(setq lsp-ui-doc-enable t
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
                                '("\\.tsx?\\'" . prettier-js-mode))))

(use-package counsel-etags
      :ensure t
      :bind (("C-]" . counsel-etags-grep-current-directory))
      :init
      (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                'counsel-etags-virtual-update-tags 'append 'local)))
      :config
      (setq counsel-etags-update-interval 60)
      (push "build" counsel-etags-ignore-directories))

    (use-package hydra
      :defer 1)

        (use-package ivy
          :diminish
          :bind (("C-s" . swiper)
                  :map ivy-minibuffer-map
                  ("TAB" . ivy-alt-done)
                  ("C-l" . ivy-alt-done)
                  ("C-j" . ivy-next-line)
                  ("C-k" . ivy-previous-line)
                  :map ivy-switch-buffer-map
                  ("C-k" . ivy-previous-line)
                  ("C-l" . ivy-done)
                  ("C-d" . ivy-switch-buffer-kill)
                  :map ivy-reverse-i-search-map
                  ("C-k" . ivy-previous-line)
                  ("C-d" . ivy-reverse-i-search-kill))
          :init
          (ivy-mode 1)
          :config
          (setq ivy-use-virtual-buffers t)
          (setq ivy-wrap t)
          (setq ivy-count-format "(%d/%d) ")
          (setq enable-recursive-minibuffers t)

          ;; Use different regex strategies per completion command
          (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist) ;; This doesn't seem to work...
          (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
          (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)

          ;; Set minibuffer height for different commands
          (setf (alist-get 'counsel-projectile-ag ivy-height-alist) 15)
          (setf (alist-get 'counsel-projectile-rg ivy-height-alist) 15)
          (setf (alist-get 'swiper ivy-height-alist) 15)
          (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))


    (use-package ivy-hydra
      :defer t
      :after hydra)

    (use-package all-the-icons-ivy-rich
      :ensure t
      :init (all-the-icons-ivy-rich-mode 1))

    (use-package ivy-rich
      :ensure t
      :init (ivy-rich-mode 1))
    ;; Whether display the colorful icons.
    ;; It respects `all-the-icons-color-icons'.
    (setq all-the-icons-ivy-rich-color-icon t)

    ;; The icon size
    (setq all-the-icons-ivy-rich-icon-size 1.0)

    ;; Whether support project root
    (setq all-the-icons-ivy-rich-project t)

    ;; Definitions for ivy-rich transformers.
    ;; See `ivy-rich-display-transformers-list' for details."
    all-the-icons-ivy-rich-display-transformers-list

    ;; Slow Rendering
    ;; If you experience a slow down in performance when rendering multiple icons simultaneously,
    ;; you can try setting the following variable
    (setq inhibit-compacting-font-caches t)
    ;; set icons
    (defun ivy-rich-switch-buffer-icon (candidate)
      (with-current-buffer
          (get-buffer candidate)
        (let ((icon (all-the-icons-icon-for-mode major-mode)))
          (if (symbolp icon)
              (all-the-icons-icon-for-mode 'fundamental-mode)
            icon))))
    (setq ivy-rich-display-transformers-list
          '(ivy-switch-buffer
            (:columns
              ((ivy-rich-switch-buffer-icon (:width 2))
              (ivy-rich-candidate (:width 30))
              (ivy-rich-switch-buffer-size (:width 7))
              (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
              (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
              (ivy-rich-switch-buffer-project (:width 15 :face success))
              (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
              :predicate
              (lambda (cand) (get-buffer cand)))))
(use-package ivy-xref
  :ensure t
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))
    ;; swiper
    (use-package swiper
    :ensure t
    :bind (
      ("C-r" . swiper-isearch)
      ("C-c C-r" . ivy-resume)
      ("C-c f" . counsel-recentf)
      ("C-c g" . counsel-git)
      ("C-c j" . counsel-git-grep)
      ("C-c k" . counsel-ag)
      ("M-x" . counsel-M-x)
      ("C-x C-f" . counsel-find-file))
    :config
    (progn
      (ivy-mode 1)
      (setq ivy-use-virtual-buffers t)
      (setq ivy-display-style 'fancy)
      (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
      ))
    (bl/leader-key-def
    "r"   '(ivy-resume :which-key "ivy resume")
    "f"   '(:ignore t :which-key "files")
    "ff"  '(counsel-find-file :which-key "open file")
    "C-f" 'counsel-find-file
    "fr"  '(counsel-recentf :which-key "recent files")
    "fR"  '(revert-buffer :which-key "revert file")
    "fj"  '(counsel-file-jump :which-key "jump to file"))

(use-package flycheck
  :ensure t
  :init
  (setq flycheck-emacs-lisp-load-path 'inherit)
  :config
  (global-flycheck-mode t))

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

(use-package all-the-icons-dired)
(use-package dired-rainbow
  :defer 2
  :config
  (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
  (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
  (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
  (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
  (dired-rainbow-define log "#c17d11" ("log"))
  (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
  (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
  (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
  (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
  (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
  (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
  (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
  (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
  (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))
  (use-package dired-single
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "p" 'dired-ranger-paste)

(global-set-key (kbd "C-x C-b") 'ibuffer)
    (setq ibuffer-saved-filter-groups
          (quote (("default"
                   ("dired" (mode . dired-mode))
                   ("org" (name . "^.*org$"))
                   ("magit" (mode . magit-mode))
                   ("IRC" (or (mode . circe-channel-mode) (mode . circe-server-mode)))
                   ("web" (or (mode . web-mode) (mode . js2-mode)))
                   ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
                   ("mu4e" (or

                            (mode . mu4e-compose-mode)
                            (name . "\*mu4e\*")
                            ))
                   ("programming" (or
                                   (mode . clojure-mode)
                                   (mode . clojurescript-mode)
                                   (mode . python-mode)
                                   (mode . c++-mode)))
                   ("emacs" (or
                             (name . "^\\*scratch\\*$")
                             (name . "^\\*Messages\\*$")))
                   ))))
    (add-hook 'ibuffer-mode-hook
              (lambda ()
                (ibuffer-auto-mode 1)
                (ibuffer-switch-to-saved-filter-groups "default")))

    ;; don't show these
                                            ;(add-to-list 'ibuffer-never-show-predicates "zowie")
    ;; Don't show filter groups if there are no buffers in that group
    (setq ibuffer-show-empty-filter-groups nil)

    ;; Don't ask for confirmation to delete marked buffers
    (setq ibuffer-expert t)
(use-package emmet-mode
:ensure t
:config
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
)

(use-package pdf-tools
  :ensure t
  :config
  ;; initialise
  (pdf-tools-install)
  ;; PDF Tools does not work well together with linum-mode
  (add-hook 'pdf-view-mode-hook (lambda() (nlinum-mode -1)))
  ;; open pdfs scaled to fit page
  ;; (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.1)
  )

(use-package exec-path-from-shell
:ensure t
:config
(exec-path-from-shell-initialize)
)

(use-package js2-mode
:ensure t
:ensure ac-js2
:init
(progn
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
))

(use-package js2-refactor
:ensure t
:config 
(progn
(js2r-add-keybindings-with-prefix "C-c C-m")
;; eg. extract function with `C-c C-m ef`.
(add-hook 'js2-mode-hook #'js2-refactor-mode)))
(use-package tern
:ensure tern
:ensure tern-auto-complete
:config
(progn
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . js2-mode))
;;(tern-ac-setup)
))

;;(use-package jade
;;:ensure t
;;)

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx$" . web-mode))


;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(use-package nvm
  :defer t)
(use-package typescript-mode
  :ensure
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(defun bl/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :ensure t
  :mode "\\.(j|t)sx?\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'bl/set-js-indentation)
  (add-hook 'json-mode-hook #'bl/set-js-indentation))



(use-package prettier-js
  :ensure t
  ;; :hook ((js2-mode . prettier-js-mode)
  ;;        (typescript-mode . prettier-js-mode))
  :config
  (setq prettier-js-show-errors nil))

(use-package deadgrep 
:ensure t)

(use-package rg
:ensure t
:commands rg)

;;  (use-package fzf :ensure t)
     ;;       (bl/leader-key-def
     ;;         "C-p" 'fzf)
(use-package fuzzy-finder
   :ensure t)
(bl/leader-key-def
       "C-p" 'fuzzy-finder-find-files-projectile)

(use-package all-the-icons 
:ensure t
:defer 0.5)

(use-package all-the-icons-ivy
:ensure t
  :after (all-the-icons ivy)
  :custom (all-the-icons-ivy-buffer-commands '(ivy-switch-buffer-other-window ivy-switch-buffer))
  :config
  (add-to-list 'all-the-icons-ivy-file-commands 'counsel-dired-jump)
  (add-to-list 'all-the-icons-ivy-file-commands 'counsel-find-library)
  (all-the-icons-ivy-setup))


(use-package all-the-icons-dired
:ensure t
)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package org 
      :ensure t
      :pin org)

    (setenv "BROWSER" "Chrome")
    (use-package org-bullets
      :ensure t
      :config
      (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
    (custom-set-variables
     '(org-directory "~/Sync/orgfiles")
     '(org-default-notes-file (concat org-directory "/notes.org"))
     '(org-export-html-postamble nil)
     '(org-hide-leading-stars t)
     '(org-startup-folded (quote overview))
     '(org-startup-indented t)
     '(org-confirm-babel-evaluate nil)
     '(org-src-fontify-natively t)
     )

    (setq org-file-apps
          (append '(
                    ("\\.pdf\\'" . "evince %s")
                    ("\\.x?html?\\'" . "/usr/bin/firefox %s")
                    ) org-file-apps ))

    (global-set-key "\C-ca" 'org-agenda)
    (setq org-agenda-start-on-weekday nil)
    (setq org-agenda-custom-commands
          '(("c" "Simple agenda view"
             ((agenda "")
              (alltodo "")))))

    (global-set-key (kbd "C-c c") 'org-capture)
  
    (setq org-agenda-files '("~/Sync/orgfiles"))
    (defadvice org-capture-finalize 
        (after delete-capture-frame activate)  
      "Advise capture-finalize to close the frame"  
      (if (equal "capture" (frame-parameter nil 'name))  
          (delete-frame)))

    (defadvice org-capture-destroy 
        (after delete-capture-frame activate)  
      "Advise capture-destroy to close the frame"  
      (if (equal "capture" (frame-parameter nil 'name))  
          (delete-frame)))  

    (use-package noflet
      :ensure t )
    (defun make-capture-frame ()
      "Create a new frame and run org-capture."
      (interactive)
      (make-frame '((name . "capture")))
      (select-frame-by-name "capture")
      (delete-other-windows)
      (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
        (org-capture)))
;; (require 'ox-beamer)
;; for inserting inactive dates
    (define-key org-mode-map (kbd "C-c >") (lambda () (interactive (org-time-stamp-inactive))))

    (use-package htmlize :ensure t)

(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifications))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(use-package default-text-scale
  :ensure t
  :defer 1
  :config
  (default-text-scale-mode))

(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1))

(defun bl/org-mode-visual-fill ()
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :ensure t
  :defer t
  :hook (org-mode . bl/org-mode-visual-fill))

(use-package expand-region
  :ensure t
  :bind (("M-[" . er/expand-region)
         ("C-(" . er/mark-outside-pairs)))

(use-package org-superstar
    :ensure t
    :after org
    :hook (org-mode . org-superstar-mode)
    :custom
    (org-superstar-remove-leading-stars t)
    (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))
;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; Get rid of the background on column views
(set-face-attribute 'org-column nil :background nil)
(set-face-attribute 'org-column-title nil :background nil)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("go" . "src go"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))

(defun bl/search-org-files ()
  (interactive)
  (counsel-rg "" "~/Notes" nil "Search Notes: "))

(use-package evil-org
  :ensure t
  :after org
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode)
         (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(bl/leader-key-def
  "o"   '(:ignore t :which-key "org mode")

  "oi"  '(:ignore t :which-key "insert")
  "oil" '(org-insert-link :which-key "insert link")

  "on"  '(org-toggle-narrow-to-subtree :which-key "toggle narrow")
   
  "os"  '(bl/counsel-rg-org-files :which-key "search notes")

  "oa"  '(org-agenda :which-key "status")
  "ot"  '(org-todo-list :which-key "todos")
  "oc"  '(org-capture t :which-key "capture")
  "ox"  '(org-export-dispatch t :which-key "export"))

(defun bl/switch-project-action ()
  "Switch to a workspace with the project name and start `magit-status'."
  ;; TODO: Switch to EXWM workspace 1?
  (persp-switch (projectile-project-name))
  (magit-status))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind ("C-M-p" . projectile-find-file)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/workspace/web")
    (setq projectile-project-search-path '("~/workspace/web")))
  (setq projectile-switch-project-action #'bl/switch-project-action))

(use-package counsel-projectile
  :ensure t
  :disabled
  :after projectile
  :config
  (counsel-projectile-mode))

(bl/leader-key-def
  "pf"  'projectile-find-file
  "ps"  'projectile-switch-project
  "pF"  'consult-ripgrep
  "pp"  'projectile-find-file
  "pc"  'projectile-compile-project
  "pd"  'projectile-dired)

(use-package dap-mode
  :ensure t
  :custom
  (lsp-enable-dap-auto-configure nil)
  :config
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-node)
  (dap-node-setup))

(use-package go-mode
  :ensure t
  :hook (go-mode . lsp-deferred))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked")
  (defun bl/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 1.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))

  (defun bl/markdown-mode-hook ()
    (bl/set-markdown-header-font-sizes))

  (add-hook 'markdown-mode-hook 'bl/markdown-mode-hook))

(use-package web-mode
  :ensure
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|jsx\\|vue\\)\\'"
  :config
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2))

;; 1. Start the server with `httpd-start'
;; 2. Use `impatient-mode' on any buffer
(use-package impatient-mode
  :ensure t)

(use-package skewer-mode
  :ensure t)

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :ensure
  :defer t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode))

(use-package vterm
  :ensure t
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package mpv
  :ensure t)
(use-package emms
  :ensure t
  :commands emms
  :config
  (require 'emms-setup)
  (emms-standard)
  (emms-default-players)
  (emms-mode-line-disable)
  (setq emms-source-file-default-directory "~/Music"))
  (bl/leader-key-def
    "a"  '(:ignore t :which-key "media")
    "ap" '(emms-pause :which-key "play / pause")
    "af" '(emms-play-file :which-key "play file"))

(use-package magit
    :ensure t
    :bind ("C-M-;" . magit-status)
    :commands (magit-status magit-get-current-branch)
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
  (use-package magit-todos
  :defer t)
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

(use-package auto-complete
:ensure t
:init
(progn
(ac-config-default)
(global-auto-complete-mode t)
))

(use-package command-log-mode
:ensure t)

(use-package drag-stuff
 :bind(("<M-up>" . drag-stuff-up)
 ("<M-down>" . drag-stuff-updown)))

(use-package ivy-posframe
    :ensure t)
  ;; Different command can use different display function.
  (setq ivy-posframe-display-functions-alist
    '((swiper          . ivy-posframe-display-at-window-center)
      (complete-symbol . ivy-posframe-display-at-window-center)
      (counsel-M-x     . ivy-posframe-display-at-window-center)
      (counsel-find-file     . ivy-posframe-display-at-window-center)
      (fuzzy-finder-find-files-projectile     . ivy-posframe-display-at-window-center)
      (t               . ivy-posframe-display-at-window-center)))
  (ivy-posframe-mode 1)
(setq ivy-posframe-height-alist '((swiper . 15)
                                  (t      . 15)))

(use-package wgrep
:ensure t
)
(use-package wgrep-ag
:ensure t
)
(require 'wgrep-ag)

(use-package better-shell
    :ensure t
    :bind (("C-\"" . better-shell-shell)
           ("C-:" . better-shell-remote-open)))

;; global key-binding settings for comment (jetbrains style)
(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "C-?") 'comment-or-uncomment-region) ; Acturally this is conflict with emacs quirks

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-expand-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-litter-directories            '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-width-is-initially-locked     t
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package dashboard
              :ensure t
              :config
              (dashboard-setup-startup-hook))

            (setq dashboard-items '(
                                    ;;(recents  . 5)
                                    ;;(bookmarks . 5)
                                    (agenda . 5)
                                    (projects . 5)
                                    ;;(registers . 5)
                                    ))
            (setq dashboard-set-heading-icons t)
            (setq dashboard-set-file-icons t)
            (setq dashboard-set-init-info t)
            ;;(setq dashboard-startup-banner "~/.emacs.d/emacs-logo.png")
            (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
            (setq dashboard-week-agenda t)
            ;;(setq dashboard-filter-agenda-entry dashboard-no-filter-agenda)
            ;;(setq dashboard-match-agenda-entry "~/Sync/orgfiles";; Content is not centered by default. To center, set
            (setq dashboard-center-content t)
            ;; To disable shortcut "jump" indicators for each section, set
            (setq dashboard-show-shortcuts nil)
          (dashboard-modify-heading-icons '((recents . "file-text")
                                            (bookmarks . "book")))
        (setq dashboard-set-navigator t)
      (setq dashboard-set-footer nil)
    (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (setq dashboard-org-agenda-categories '("Tasks" "Appointments"))
(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

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

;; Download Evil
(unless (package-installed-p 'evil)
(package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)

(require 'org-tempo)

(use-package try
:ensure t)

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

;; Built-in project package
(require 'project)
(global-set-key (kbd "C-x p f") #'project-find-file)

;; IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package company
:ensure t
:config
(setq company-idle-delay 0)
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

(use-package magit
      :ensure t
      :bind (
	     ("C-x g" . magit-status)))

(setq magit-status-margin
  '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18))
    (use-package git-gutter
    :ensure t
    :init
    (global-git-gutter-mode +1))

    (global-set-key (kbd "M-g M-g") 'hydra-git-gutter/body)


    (use-package git-timemachine
    :ensure t
    )
  (defhydra hydra-git-gutter (:body-pre (git-gutter-mode 1)
                              :hint nil)
    "
  Git gutter:
    _j_: next hunk        _s_tage hunk     _q_uit
    _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
    ^ ^                   _p_opup hunk
    _h_: first hunk
    _l_: last hunk        set start _R_evision
  "
    ("j" git-gutter:next-hunk)
    ("k" git-gutter:previous-hunk)
    ("h" (progn (goto-char (point-min))
                (git-gutter:next-hunk 1)))
    ("l" (progn (goto-char (point-min))
                (git-gutter:previous-hunk 1)))
    ("s" git-gutter:stage-hunk)
    ("r" git-gutter:revert-hunk)
    ("p" git-gutter:popup-hunk)
    ("R" git-gutter:set-start-revision)
    ("q" nil :color blue)
    ("Q" (progn (git-gutter-mode -1)
                ;; git-gutter-fringe doesn't seem to
                ;; clear the markup right away
                (sit-for 0.1)
                (git-gutter:clear))
         :color blue))

(setq lsp-log-io nil) ;; Don't log everything = speed
(setq lsp-keymap-prefix "C-c l")
(setq lsp-restart 'auto-restart)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover t)
(setq lsp-ui-sideline-show-code-actions t)

(use-package lsp-mode
  :ensure t
  :hook (
	 (web-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration)
	 )
  :commands lsp-deferred)


(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)


(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
(if (string-match (car my-pair) buffer-file-name)
	  (funcall (cdr my-pair)))))

(use-package prettier-js
  :ensure t)
(add-hook 'web-mode-hook #'(lambda ()
		 (enable-minor-mode
			'("\\.jsx?\\'" . prettier-js-mode))
		 (enable-minor-mode
			'("\\.tsx?\\'" . prettier-js-mode))))

(global-set-key (kbd "M-s e") 'iedit-mode)

;; json-mode
(use-package json-mode
  :ensure t)

(use-package counsel
:ensure t
  :bind
  (("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))




  (use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))


  (use-package swiper
  :ensure t
  :bind (("C-s" . swiper-isearch)
	 ("C-r" . swiper-isearch)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package yasnippet
      :ensure t
      :init
	(yas-global-mode 1))
(use-package auto-yasnippet
:ensure t)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

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

(use-package all-the-icons-dired)

(use-package dired
  :ensure nil
  :straight nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-hide-details-hide-symlink-targets nil
        delete-by-moving-to-trash t)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (dired-omit-mode 1)
              (dired-hide-details-mode 1)
              (unless (or dw/is-termux
                          (s-equals? "/gnu/store/" (expand-file-name default-directory)))
                (all-the-icons-dired-mode 1))
              (hl-line-mode 1)))

  (use-package dired-rainbow
    :ensure t
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
    :ensure t
    :defer t)

  (use-package dired-ranger
    :ensure t
    :defer t)

  (use-package dired-collapse
    :ensure t
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "p" 'dired-ranger-paste))

(use-package better-shell
    :ensure t
    :bind (("C-\"" . better-shell-shell)
           ("C-:" . better-shell-remote-open)))

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

(use-package deadgrep 
:ensure t)

(use-package rg
:ensure t
:commands rg)

(use-package fzf :ensure t)

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

    (setenv "BROWSER" "firefox")
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

    (setq org-agenda-files (list "~/Sync/orgfiles/gcal.org"
                                 "~/Sync/orgfiles/soe-cal.org"
                                 "~/Sync/orgfiles/i.org"
                                 "~/Sync/orgfiles/schedule.org"))
    (setq org-capture-templates
          '(("a" "Appointment" entry (file  "~/Sync/orgfiles/gcal.org" )
             "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
            ("l" "Link" entry (file+headline "~/Sync/orgfiles/links.org" "Links")
             "* %? %^L %^g \n%T" :prepend t)
            ("b" "Blog idea" entry (file+headline "~/Sync/orgfiles/i.org" "Blog Topics:")
             "* %?\n%T" :prepend t)
            ("t" "To Do Item" entry (file+headline "~/Sync/orgfiles/i.org" "To Do and Notes")
             "* TODO %?\n%u" :prepend t)
            ("m" "Mail To Do" entry (file+headline "~/Sync/orgfiles/i.org" "To Do and Notes")
             "* TODO %a\n %?" :prepend t)
            ("g" "GMail To Do" entry (file+headline "~/Sync/orgfiles/i.org" "To Do and Notes")
             "* TODO %^L\n %?" :prepend t)
            ("n" "Note" entry (file+headline "~/Sync/orgfiles/i.org" "Notes")
             "* %u %? " :prepend t)
            ))
  

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

(define-prefix-command 'z-map)
(global-set-key (kbd "C-z") 'z-map) ;; was C-1
(define-key z-map (kbd "k") 'compile)
(define-key z-map (kbd "c") 'hydra-multiple-cursors/body)
(define-key z-map (kbd "m") 'mu4e)
(define-key z-map (kbd "1") 'org-global-cycle)
(define-key z-map (kbd "a") 'org-agenda-show-agenda-and-todo)
(define-key z-map (kbd "g") 'counsel-ag)
(define-key z-map (kbd "2") 'make-frame-command)
(define-key z-map (kbd "0") 'delete-frame)
(define-key z-map (kbd "o") 'ace-window)

(define-key z-map (kbd "s") 'flyspell-correct-word-before-point)
(define-key z-map (kbd "i") 'z/load-iorg)
(define-key z-map (kbd "f") 'origami-toggle-node)
(define-key z-map (kbd "w") 'z/swap-windows)
(define-key z-map (kbd "*") 'calc)

(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifications))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

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

(use-package avy
  :ensure t
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))

(bl/leader-key-def
  "j"   '(:ignore t :which-key "jump")
  "jj"  '(avy-goto-char :which-key "jump to char")
  "jw"  '(avy-goto-word-0 :which-key "jump to word")
  "jl"  '(avy-goto-line :which-key "jump to line"))

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

(use-package winner
  :ensure
  :after evil
  :config
  (winner-mode)
  (define-key evil-window-map "u" 'winner-undo)
  (define-key evil-window-map "U" 'winner-redo))

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

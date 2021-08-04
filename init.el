;;;
;;;  Created by Brody Liao
;;;

;; Speed up startup
(setq auto-mode-case-fold nil)

(unless (or (daemonp) noninteractive)
  (let ((old-file-name-handler-alist file-name-handler-alist))
    ;; If `file-name-handler-alist' is nil, no 256 colors in TUI
    ;; @see https://emacs-china.org/t/spacemacs-centaur-emacs/3802/839
    (setq file-name-handler-alist
          (unless (display-graphic-p)
            '(("\\(?:\\.tzst\\|\\.zst\\|\\.dz\\|\\.txz\\|\\.xz\\|\\.lzma\\|\\.lz\\|\\.g?z\\|\\.\\(?:tgz\\|svgz\\|sifz\\)\\|\\.tbz2?\\|\\.bz2\\|\\.Z\\)\\(?:~\\|\\.~[-[:alnum:]:#@^._]+\\(?:~[[:digit:]]+\\)?~\\)?\\'" . jka-compr-handler))))
    (add-hook 'emacs-startup-hook
              (lambda ()
                "Recover file name handlers."
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist
                                           old-file-name-handler-alist)))))))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

(setq package-enable-at-startup nil)

(setq inhibit-startup-message nil)
(setq initial-buffer-choice  nil)
(setq inhibit-compacting-font-caches t)
;; Disable visible scrollbar
(scroll-bar-mode -1)

;; Dis able the toolbar
(tool-bar-mode -1) 

;; give some breathing room
(set-fringe-mode 10) 

;; Diable the menu bar
(menu-bar-mode -1) 

;; set up the visiable bell
(setq visible-bell t) 

;; yes to y, no to n
(fset 'yes-or-no-p 'y-or-n-p)

;; ESC Cancels All
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; set realtive numbers
(display-line-numbers-mode t)
;; set type of line numbering (global variable)
(setq display-line-numbers-type 'relative) 
;; activate line numbering in all buffers/modes
(global-display-line-numbers-mode)
;; Activate line numbering in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-hl-line-mode 1)

(delete-selection-mode t)

(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold most-positive-fixnum)

;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)
(setq large-file-warning-threshold nil)
(setq vc-follow-symlinks t)
(setq ad-redefinition-action 'accept)
(require 'subr-x)
(setq bl/is-termux
      (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))

(setq bl/is-guix-system (and (eq system-type 'gnu/linux)
                             (require 'f)
                             (string-equal (f-read "/etc/issue")
                                           "\nThis is the GNU system.  Welcome.\n")))
;; set font size
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Set font size 180 = 18pt
(set-face-attribute 'default nil :height 180)

(require 'package)
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
                         ("org" . "http://elpa.emacs-china.org/org/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))
(setq use-package-always-ensure t)

;; chords
(use-package use-package-chords
  :ensure t
  :disabled
  :config (key-chord-mode 1))

;; Diminish
(use-package diminish
  :ensure t)

;; restart emacs
(use-package restart-emacs)
(org-babel-load-file (expand-file-name "~/.emacs.d/my-init.org"))

;; user custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))

;; get system type
(defconst *is-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos)(eq system-type 'windows-nt)))

;; command key to meta for default
(when *is-mac*
   (setq mac-command-modifier 'meta
    mac-option-modifier 'none))

;; Tab Widths
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)
(auto-revert-mode t)

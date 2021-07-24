(setq package-enable-at-startup nil)
(display-line-numbers-mode t)
(setq display-line-numbers 'relative)


(setq inhibit-startup-message t)
(setq inhibit-compacting-font-caches t)
(scroll-bar-mode -1) ;; Disable visible scrollbar
(tool-bar-mode -1) ;; Dis able the toolbar
(set-fringe-mode 10) ;; give some breathing room
(menu-bar-mode -1) ;; Diable the menu bar
(setq visible-bell t) ;; set up the visiable bell
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "C-t") 'treemacs)
;; ESC Cancels All
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; Rebind C-u
(global-set-key (kbd "C-M-u") 'universal-argument)

;; set realtive numbers
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
;; Improve scrolling.
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1)
;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold most-positive-fixnum)

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))


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

;;(add-to-list 'package-archives
;;'("melpa" . "https://melpa.org/packages/"))
(require 'package)
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
                         ("org" . "http://elpa.emacs-china.org/org/")))

;; Mode line
(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

;; Displaying World Time
(setq display-time-world-list
  '(("Etc/UTC" "UTC")
    ("America/Los_Angeles" "Seattle")
    ("America/New_York" "New York")
    ("Europe/Athens" "Athens")
    ("Pacific/Auckland" "Auckland")
    ("Asia/Shanghai" "Shanghai")
    ("Asia/Kolkata" "Hyderabad")))
(setq display-time-world-time-format "%a, %d %b %I:%M %p %Z")

;; Tab Widths
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))
(setq use-package-always-ensure t)
(use-package use-package-chords
  :ensure t
  :disabled
  :config (key-chord-mode 1))
(use-package diminish
  :ensure t)
(use-package restart-emacs)
(org-babel-load-file (expand-file-name "~/.emacs.d/my-init.org"))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))
;; get system type
(defconst *is-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos)(eq system-type 'windows-nt)))

;; command key to meta for default
;;(when *is-mac*
;;    (setq mac-command-modifier 'meta
;;     mac-option-modifier 'none))

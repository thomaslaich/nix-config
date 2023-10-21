;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Thomas Laich"
      user-mail-address "thomaslaich@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-tokyo-night)

;; ;; If you intend to use org, it is recommended you change this!
;; (if IS-MAC
;;     (setq org-directory "~/Dropbox/Personales/org/")
;;   (setq org-directory "~/Secundario/Dropbox/Personales/org/"))
;;
;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type 'relative)


;; ;; Here are some additional functions/macros that could help you configure Doom:
;; ;;
;; ;; - `load!' for loading external *.el files relative to this one
;; ;; - `use-package' for configuring packages
;; ;; - `after!' for running code after a package has loaded
;; ;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;; ;;   looks when you load packages with `require' or `use-package'.
;; ;; - `map!' for binding new keys
;; ;;
;; ;; To get information about any of these functions/macros, move the cursor over
;; ;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; ;; This will open documentation for it, including demos of how they are used.
;; ;;
;; ;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; ;; they are implemented.
;;
;; ;; Paren pride!
;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;;
;; Fix typing the hash sign in OSX
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

;; (setq org-hide-emphasis-markers 'nil)
;; (setq org-startup-folded 'nil)
;;
;; (require 'org-drill)
;;
;; (add-hook 'enh-ruby-mode-hook 'rvm-activate-corresponding-ruby)
;; (add-hook 'ruby-mode-hook 'rvm-activate-corresponding-ruby)
;;
;; Smooth scrolling
;; Vertical Scroll
(setq scroll-step 1)
(setq scroll-margin 1)
(setq scroll-conservatively 101)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq auto-window-vscroll nil)
(setq fast-but-imprecise-scrolling nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
;; Horizontal Scroll
(setq hscroll-step 1)
(setq hscroll-margin 1)

;; (defun gonzalo/get-buffer-filename ()
;;   "Get the current buffer filename."
;;   (or (buffer-file-name) list-buffers-directory))
;;
;; (defun gonzalo/show-and-copy-buffer-filename ()
;;   "Show and copy the full path to the current file in the minibuffer."
;;   (interactive)
;;   (let ((file-name (gonzalo/get-buffer-filename)))
;;     (if file-name
;;         (message (kill-new file-name))
;;       (error "Buffer not visiting a file"))))
;;
;; (map! :map doom-leader-file-map "c" #'gonzalo/show-and-copy-buffer-filename)
;;
;; (setq inferior-lisp-program "clisp")
;;
;; (setq org-journal-encrypt-journal t)
;; (setq org-journal-file-format "%Y%m%d.org")
;;
;; (defun gonzalo/add-ticket-to-commit-message ()
;;   "When typing a commit, write the Jira ticket number at the start."
;;   (let ((branch-name (magit-get-current-branch)))
;;     (when (string-prefix-p "gquero/" branch-name)
;;       (insert "[")
;;       (insert (upcase (cadr (split-string branch-name "/"))))
;;       (insert "] "))))
;;
;; (add-hook 'git-commit-setup-hook #'gonzalo/add-ticket-to-commit-message)
;;
;; (defun gonzalo/elixir-add-pipe ()
;;   "Type an Elixir pipe command."
;;   (interactive)
;;   (end-of-line)
;;   (insert "\n|> ")
;;   (indent-according-to-mode))
;;
;; (map! :map alchemist-mode-map "M-RET" #'gonzalo/elixir-add-pipe)
;; (setq flycheck-elixir-credo-strict t)
;;
;; ;; Elixir - Testing Prefix
;; (map! :localleader
;;       :map alchemist-mode-map
;;       :prefix "t"
;;       "a" #'alchemist-mix-test
;;       "f" #'alchemist-mix-test-this-buffer
;;       "p" #'alchemist-mix-test-at-point)
;;
;; ;; Elixir - Mix Prefix
;; (map! :localleader
;;       :map alchemist-mode-map
;;       :prefix "m"
;;       "m" #'alchemist-mix
;;       "c" #'alchemist-mix-compile
;;       "r" #'alchemist-mix-rerun-last-task)
;;
;; ;; Elixir - REPL
;; (map! :localleader
;;       :map alchemist-mode-map
;;       "'" #'alchemist-iex-project-run)
;;
;; ;; Elixir - Eval Prefix
;; (map! :localleader
;;       :map alchemist-mode-map
;;       :prefix "e"
;;       "b" #'alchemist-iex-compile-this-buffer
;;       "r" #'alchemist-iex-reload-module)

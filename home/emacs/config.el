;; -*- lexical-binding: t; -*-

;;; GENERAL SETUP (MISC)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
;; (setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
;;       url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering)

;; Keep customization settings in a temporary file (thanks Ambrevar!)
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

;; use-package is added automatically by the nix emacs overlay
;; here we just make sure we don't have to keep typing `:ensure t`
(setq use-package-always-ensure t)

;; do not make unnecessary sounds
(setq ring-bell-function #'ignore)


;;; disable the default emacs startup screen (setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;;; disable some UI elements
(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room

;;; Line Numbers

(column-number-mode)
(setq display-line-numbers-type 'relative)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;;; FONTS AND THEMES

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 140)
(set-face-attribute 'variable-pitch nil :font "Ubuntu Nerd Font" :height 140)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 140)
;; Make commented text and keywords italics.
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)

(use-package nerd-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1))
(use-package minions
  :hook (doom-modeline-mode . minions-mode))

;; folding with origami
(use-package origami
  :hook (yaml-mode . origami-mode))

;; tranparency (doing nothing on MacOS :( )
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Hide minor modes from modeline (by adding :diminish to use-package)
(use-package diminish)

;; (load-theme 'catppuccin t)
;; (setq catppuccin-flavor 'macchiato)
;; (catppuccin-reload)
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  ;; (load-theme 'doom-nord-light	 t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package dashboard
  :ensure t 
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; (setq dashboard-startup-banner "./banner.txt") ;; use standard emacs logo as banner
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5)
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :custom 
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))


;; notifications
(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifications))

;; rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;; EVIL MODE

;;; Vim Bindings
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  :config
  (evil-mode)
  (evil-set-undo-system 'undo-redo))

;;; Vim bindings everywhere else
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-tutor)

;;; better escape
(use-package evil-escape
  :after evil
  :init
  (setq evil-escape-excluded-states '(normal visual)
        evil-escape-excluded-major-modes '(neotree-mode treemacs-mode vterm-mode))
  :config
  (setq-default evil-escape-delay 0.2)
  (setq-default evil-escape-key-sequence "jj")
  (evil-escape-mode))

;; commentary
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; multiple cursors

;; evil-multiedit
(use-package evil-multiedit
  :config
  (evil-multiedit-default-keybinds))


;; evil-mc
(use-package evil-mc
  :config
  evil-define-key ('(normal visual) 'global
                   "gzm" #'evil-mc-make-all-cursors
                   "gzu" #'evil-mc-undo-all-cursors
                   "gzz" #'+evil/mc-toggle-cursors
                   "gzc" #'+evil/mc-make-cursor-here
                   "gzn" #'evil-mc-make-and-goto-next-cursor
                   "gzp" #'evil-mc-make-and-goto-prev-cursor
                   "gzN" #'evil-mc-make-and-goto-last-cursor
                   "gzP" #'evil-mc-make-and-goto-first-cursor
                   (with-eval-after-load 'evil-mc
                     (evil-define-key '(normal visual) evil-mc-key-map
                       (kbd "C-n") #'evil-mc-make-and-goto-next-cursor
                       (kbd "C-N") #'evil-mc-make-and-goto-last-cursor
                       (kbd "C-p") #'evil-mc-make-and-goto-prev-cursor
                       (kbd "C-P") #'evil-mc-make-and-goto-first-cursor)))
  (global-evil-mc-mode 1))

;; editing config

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(setq-default indent-tabs-mode nil)

;;; KEYBINDINGS

;; disable right option key on mac to allow for emacs bindings
(setq ns-option-modifier 'meta
      mac-option-modifier 'meta
      ns-right-option-modifer nil
      mac-right-option-modifier nil)

;; By default Emacs requires you to hit ESC three times to close the minibuffer.
;; This is annoying, so we're going to change it to just once.
(global-set-key [escape] 'keyboard-escape-quit)

(use-package bind-key
  :config
  (add-to-list 'same-window-buffer-names "*Personal Keybindings*"))
(use-package buffer-move)

(use-package general
  :after evil
  :config
  (general-evil-setup))
  
;; set up 'SPC' as the leader key
(general-create-definer leader-def
  :states '(normal visual insert emacs)
  :keymaps 'override
  :prefix "SPC" ; set leader
  :global-prefix "M-SPC") ; access leader in insert mode (do we need this?)

;; set up ',' as the local leader key
(general-create-definer local-leader-def
  :states '(normal visual insert emacs)
  :keymaps 'override
  :prefix "," ; set leader
  :global-prefix "M-,") ; access leader in insert mode (do we need this?)

;; zoom keybindings
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; top-level keybindings
(leader-def
  "." 'find-file)
;; (leader-def
;;   "f c" '((lambda () (interactive) (find-file "~/.config/nixpkgs/home.nix")) :wk "Open [C]onfig"))

;; buffer keybindings
(leader-def
  "b" '(:ignore t :wk "[B]uffer")
  "b b" '(switch-to-buffer :wk "Switch Buffer")
  "b i" '(ibuffer :wk "Ibuffer")
  "b k" '(kill-current-buffer :wk "Kill Buffer")
  "b n" '(next-buffer :wk "Next Buffer")
  "b p" '(previous-buffer :wk "Previous Buffer")
  "b r" '(revert-buffer :wk "Revert Buffer"))

;; evaluate elisp keybindings
(leader-def
  "e" '(:ignore t :wk "[E]valuate")
  "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
  "e d" '(eval-defun :wk "Evaluate elisp in defun")
  "e e" '(eval-expression :wk "Evaluate elisp expression")
  "e l" '(eval-last-sexp :wk "Evaluate elisp in last sexp")
  "e r" '(eval-region :wk "Evaluate elisp in region"))

;; help keybindings
(leader-def
  "h" '(:ignore t :wk "[H]elp")
  "h a" '(apropos :wk "Apropos")
  "h c" '(describe-char :wk "Character")
  "h f" '(describe-function :wk "Function")
  "h k" '(describe-key :wk "Key")
  "h m" '(describe-mode :wk "Mode")
  "h p" '(describe-package :wk "Package")
  "h v" '(describe-variable :wk "Variable"))
  ;; need to add "h r r" for reloading config as well?

;; search
(leader-def
  "f" '(:ignore t :wk "[F]earch")
  "f f" '(consult-find :wk "Find Files")
  "f b" '(consult-buffer :wk "Find Buffer")
  "f /" '(consult-buffer :wk "Find Buffer")
  ;; TODO maybe add "f a" as in neovim?
  "f g" '(consult-ripgrep :wk "Find by Grep")
  "f h" '(consult-man :wk "Find Help")
  "f i" '(info :wk "Find Info")
  "f r" '(consult-recent-file :wk "Find Recent Files")
  "f m" '(consult-notmuch-tree :wk "Find Mail"))

;; Git
(leader-def
  "g" '(:ignore t :wk "[G]it")
  "g f" '(consult-git-grep :wk "Find in Git")
  ;; TODO maybe at "g c" and "g b" as in neovim?
  "g g" '(magit-status :wk "Magit"))


;; toggle keybindings
(leader-def
  "t" '(:ignore t :wk "[T]oggle")
  "t l" '(display-line-numbers-mode :wk "Toggle Line Numbers")
  "t t" '(global-visual-line-mode :wk "Toggle Truncate Lines")
  "t v" '(vterm-toggle :wk "Toggle Vterm"))

;; org keybindings
(leader-def
  "o" '(:ignore t :wk "[O]rg")
  "o a" '(org-agenda :wk "Agenda")
  "o f" '(cfw:open-org-calendar :wk "Calendar")
  "o c" '(org-capture :wk "Capture")
  "o l" '(org-store-link :wk "Link")
  "o r" '(org-refile :wk "Refile")
  "o t" '(org-todo :wk "Todo")
  "o n" '(notmuch :wk "Notmuch Mail")
  "o m" '(mu4e :wk "Mail")
  "o r" '(elfeed :wk "RSS Feeds"))

;; email bindings
(leader-def
  "m" '(:ignore t :wk "[M]ail")
  "m f" '(consult-notmuch-tree :wk "Find Mail")
  "m n" '(notmuch :wk "Notmuch Mail")
  "m m" '(mu4e :wk "Mail")
  "m c" '(mu4e-compose-new :wk "Compose Mail"))

;; dired keybindings
(leader-def
  "d" '(:ignore t :wk "[D]ired")
  "d d" '(dired :wk "Open Dired")
  "d j" '(dired-jump :wk "Jump to Current")
  "d p" '(peep-dired :wk "Peep Dired"))

;; Window motions vim mode
(global-set-key (kbd "C-h") 'evil-window-left)
(global-set-key (kbd "C-j") 'evil-window-down)
(global-set-key (kbd "C-k") 'evil-window-up)
(global-set-key (kbd "C-l") 'evil-window-right)

(leader-def
  "w" '(:ignore t :wk "[W]indows")

  ;; Window splits
  "w c" '(evil-window-delete :wk "Close Current Window")
  "w n" '(evil-window-new :wk "New Window")
  "w s" '(evil-window-split :wk "Split (Horizontally)")
  "w v" '(evil-window-vsplit :wk "Split Vertically")
  "w o" '(delete-other-windows :wk "Close Other Windows")
  "w =" '(balance-windows :wk "Balance Windows")
  "w |" '(evil-window-set-width :wk "Set Window Width")
  "w _" '(evil-window-set-height :wk "Set Window Height")

  ;; Window motions
  "w h" '(evil-window-left :wk "Move Left")
  "w j" '(evil-window-down :wk "Move Down")
  "w k" '(evil-window-up :wk "Move Up")
  "w l" '(evil-window-right :wk "Move Right")
  "w w" '(evil-window-next :wk "Next Window")

  ;; Move windows
  "w H" '(buf-move-left :wk "Buffer Move Left")
  "w J" '(buf-move-down :wk "Buffer Move Down")
  "w K" '(buf-move-up :wk "Buffer Move Up")
  "w L" '(buf-move-right :wk "Buffer Move Right"))

;; Code keybindings
(leader-def
"c" '(:ignore t :wk "[C]ode")
"c c" '(compile :wk "Compile"))

;; local leader shorts

(leader-def "p" '(projectile-command-map :wk "[P]rojects"))

;;; WHICH-KEY
(use-package which-key
  :init (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " → "))

;;; ORG MODE

;; enable table of contents
(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

;; org bullets
(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; evil org mode
(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


;; disable electric indent
(electric-indent-mode -1)

;; GTD setup

;; (setq org-capture-templates '(("t" "Todo [inbox]" entry
;;                                (file+headline "~/notes/org/gtd/inbox.org" "Tasks")
;;                                "* TODO %i%?")
;;                               ("T" "Tickler" entry
;;                                (file+headline "~/notes/org/gtd/tickler.org" "Tickler")
;;                                "* %i%? \n %U")
;;                               ("a" "Appointment" entry (file "~/notes/org/gtd/appointments.org") ; ,(concat org-directory "gtd/appointments.org"))
;;                                "* %?\n:PROPERTIES:\n:calendar-id:\tthomas.laich@gmail.com\n:END:\n:org-gcal:\n%^T--%^T\n:END:\n\n" :jump-to-captured t)))

;; (setq org-refile-targets '(("~/notes/org/gtd/gtd.org" :maxlevel . 3)
;;                            ("~/notes/org/gtd/someday.org" :level . 1)
;;                            ("~/notes/org/gtd/tickler.org" :maxlevel . 2)))

;; (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))


;; ORG GTD
(setq org-gtd-update-ack "3.0.0")
(use-package org-gtd :after org
  :init
  ;; Directories
  (setq org-agenda-files '("~/Dropbox/notes/gcal-appointments.org"))
  (setq org-gtd-directory "~/Dropbox/notes/org-gtd")
  :config
  (setq org-edna-use-inheritance t)
  (org-edna-mode)
  (leader-def
    "d" '(:ignore t :wk "Org GT[D]")
    "d c" '(org-gtd-capture :wk "Capture")
    "d e" '(org-gtd-engage :wk "Engage")
    "d p" '(org-gtd-process-inbox :wk "Process Inbox")
    "d n" '(org-gtd-show-all-next :wk "Show all next")
    "d s" '(org-gtd-review-stuck-projects :wk "Stuck Projects"))
  (define-key org-gtd-clarify-map (kbd "C-c c") #'org-gtd-organize)
  ;; set area of focus
  (setq org-gtd-areas-of-focus '("Home" "Health" "Family" "Career" "Social"))
  (setq org-gtd-organize-hooks '(org-gtd-set-area-of-focus org-set-tags-command))
  (org-gtd-mode t))

;; set area of focus and autosave org-gtd files when organizing (otherwise they frequently conflict with Beorg)
(setq auto-save-default nil) ;; disable by default
(add-hook 'org-mode-hook #'auto-save-mode) ;; enable in org-mode
(add-hook 'auto-save-hook #'org-save-all-org-buffers) ;; autosave org buffers

(use-package org-habit-stats
  :config
  (define-key org-mode-map (kbd "C-c h") 'org-habit-stats-view-habit-at-point)
  (define-key org-agenda-mode-map (kbd "H") 'org-habit-stats-view-habit-at-point-agenda))

;; ORG ROAM FOR ZETTELKASTEN
(use-package org-roam :after org
  :custom
  (org-roam-directory "~/Dropbox/notes/org-roam")
  :bind (("C-c n l" . org-roam)
         ("C-c n f" . org-roam-find-file)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-insert)
         ("C-c n I" . org-roam-insert-immediate))
  :config
  (org-roam-setup))

;; nice calendars
(use-package calfw)
(use-package calfw-org
  :after calfw)

;;; CREDENTIAL MANAGEMENT

;; commented for now as I'm using agenix now
;; I use 1password
;; (use-package auth-source-1password
;;   :config
;;   (auth-source-1password-enable))
;; (setq auth-source-debug t)

;; EMAIL & ORG SYNCHRONIZATION

(use-package mu4e
  :config
  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Maildir/gmail")
  
  ;; Further customization:
  (setq mu4e-html2text-command "w3m -T text/html" ; how to hanfle html-formatted emails
        mu4e-headers-auto-update t                ; avoid to type `g' to update
        mu4e-view-show-images t                   ; show images in the view buffer
        mu4e-compose-signature-auto-include nil   ; I don't want a message signature
        mu4e-use-fancy-chars t)                   ; allow fancy icons for mail threads
  
  (setq mu4e-inbox-folder "/inbox")
  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-sent-folder   "/Sent Mail")
  (setq mu4e-refile-folder "/All Mail")
  (setq mu4e-trash-folder  "/Trash")
  
  (setq user-full-name "Thomas Laich")
  (setq user-mail-address "thomaslaich@gmail.com")
  

  (setq mu4e-maildir-shortcuts
            '(("/inbox"     . ?i)
              ("/CatPrimary"   . ?p)
              ("/CatUpdates"   . ?u)
              ("/Starred"   . ?r)
              ("/All Mail"  . ?a)
              ("/Sent Mail" . ?s)
              ("/Drafts"    . ?d)
              ("/Trash"     . ?t)))
  
  ;; Display options
  (setq mu4e-view-show-images t)
  (setq mu4e-view-show-addresses 't)

  ;; Use mu4e for sending e-mail
  (setq mail-user-agent 'mu4e-user-agent
        message-send-mail-function 'smtpmail-send-it
        smtpmail-smtp-server "smtp.gmail.com"
        ;; only used for auth-source-1password
        smtpmail-smtp-user "thomaslaich@gmail.com"
        ;; smtpmail-smtp-service 465
        smtpmail-smtp-service 587
        smtpmail-stream-type 'starttls)

  ;; Some styling
  (add-to-list 'mu4e-header-info-custom
              '(:empty . (:name "Empty"
                          :shortname ""
                          :function (lambda (msg) "  "))))
  (setq mu4e-headers-fields '((:empty         .   10)
                              (:human-date    .   12)
                              (:flags         .    6)
                              (:mailing-list  .   10)
                              (:from          .   22)
                              (:subject       .   nil)))
  (setq mu4e-headers-unread-mark    '("u" . "📩 "))
  (setq mu4e-headers-draft-mark     '("D" . "🚧 "))
  (setq mu4e-headers-flagged-mark   '("F" . "🚩 "))
  (setq mu4e-headers-new-mark       '("N" . "✨ "))
  (setq mu4e-headers-passed-mark    '("P" . "↪ "))
  (setq mu4e-headers-replied-mark   '("R" . "↩ "))
  (setq mu4e-headers-seen-mark      '("S" . " "))
  (setq mu4e-headers-trashed-mark   '("T" . "🗑️"))
  (setq mu4e-headers-attach-mark    '("a" . "📎 "))
  (setq mu4e-headers-encrypted-mark '("x" . "🔑 ")))
(setq mu4e-headers-signed-mark    '("s" . "🔏 "))
(setq mu4e-headers-calendar-mark  '("c" . "📅 "))
(setq mu4e-headers-personal-mark '("p" . "👤 "))
(setq mu4e-headers-mailing-list-mark '("l" . "📧 "))

;; allow mu4e functions in org-mode
;; (use-package mu4e-dashboard)

;; TODO does this work?
;; alerts
(use-package mu4e-alert
  :config
  (mu4e-alert-set-default-style 'libnotify)
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications))

;; Notmuch 
;; TODO maybe remove this?
(use-package notmuch)
(use-package consult-notmuch
  :after
  notmuch)
(setq notmuch-search-oldest-first nil)


;; Google calendar sync
;; NOTE: I do not mix GTD calendar appointments with gcal appointments
;; On my phone everything is synched to apple calendar through beorg
(with-temp-buffer
  (insert-file-contents "~/.emacs.d/gcal-clientid")
  (setq org-gcal-client-id (replace-regexp-in-string "\n$" "" (buffer-string))))
(with-temp-buffer
  (insert-file-contents "~/.emacs.d/gcal-clientsecret")
  (setq org-gcal-client-secret (replace-regexp-in-string "\n$" "" (buffer-string))))

(use-package org-gcal
  :config
  (setq org-gcal-fetch-file-alist '(("thomaslaich@gmail.com" .  "~/Dropbox/notes/gcal-appointments.org")))
  (org-gcal-reload-client-id-secret))

;; enter pinentry password directly from emacs (no popup)
(setq epg-pinentry-mode 'loopback)
;; prevent logging in all the time
(setq-default plstore-cache-passphrase-for-symmetric-encryption t)

;;; COMPLETION (VERTICO&CONSULT)
;; NOTE: use Vertico&Consult instead of Ivy&Counsel because cool kids use consult/vertico/embark/corfu

;; Grepping using Consult
;; Example configuration for Consult
(use-package consult
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :custom
  ;; set consult project root
  (setq consult-project-function #'projectile-project-root)

  :config
  (setq consult-narrow-key "<") ;; "C-+"
  )
  

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim))        ;; good alternative: M-.
   ;; ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package vertico
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(savehist-mode)

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;;; TERMINAL EMULATION

(use-package vterm
  :commands vterm
  :config
  (setq shell-file-name (getenv "$SHELL")
        vterm-max-scrollback 5000))

(use-package vterm-toggle
  :after vterm
  ;; ;; :config
  ;; (setq vterm-toggle-fullscreen-p nil
  ;;       vterm-toggle-scope 'project
  ;;       vterm-toggle-cd-auto-create-buffer nil
  ;;       vterm-toggle-cd-auto-run-dired nil)
  )

;;; COPILOT

(use-package copilot)
(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;;; LANGUAGES

;;; LSP-MODE
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  :hook
  ;; C#
  (csharp-mode . lsp-deferred))

(use-package lsp-ui
  :after lsp-mode)

;; completion
;; (use-package company)
;; (add-hook 'after-init-hook 'global-company-mode)
;; (use-package company-box
;;   :hook (company-mode . company-box-mode))

;; cool kids use corfu, not company
(use-package corfu
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :init
  (global-corfu-mode))

;; Lispy (for emacs lisp)
;; TODO I get very strange behaviour with lispy sometimes, not sure I like it
;; Would love to have an LSP and formatting capabilities for emacs lisp :(
(use-package lispy
  :hook ((emacs-lisp-mode . lispy-mode)
         (scheme-mode . lispy-mode)))
(use-package lispyville
  :hook ((lispy-mode . lispyville-mode))
  :config
  (lispyville-set-key-theme '(operators c-w additional
                                        additional-movement slurp/barf-cp
                                        prettify)))

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))

;; Lua
(use-package lua-mode
  :mode "\\.lua\\'"
  :hook (lua-mode . lsp-deferred)
  :config
  (setq lua-indent-level 2))

;; Haskell
(use-package lsp-haskell)
(use-package haskell-mode
  :mode "\\.hs\\'"
  :hook (haskell-mode . lsp-deferred)
  :config
  (setq haskell-indentation-layout-offset 2
        haskell-indentation-left-offset 2
        haskell-indentation-starter-offset 2
        haskell-indentation-where-pre-offset 2
        haskell-indentation-where-post-offset 2))

;; C# LSP
;; note that csharp-mode is built-in for Emacs 29+
(add-hook 'csharp-mode-hook 'lsp-deferred)

;; TypeScript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

  ;; optionally
  (use-package lsp-ui :commands lsp-ui-mode)

  ;; optionally if you want to use debugger
  ;; (use-package dap-mode)
  ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

  ;; optional if you want which-key integration
  (use-package which-key
      :config
      (which-key-mode))

;;; PROJECTS AND GIT INTEGRATION

;; Projectile
(use-package projectile
  :init
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/repos/"))
  (setq projectile-switch-project-action #'projectile-dired)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


;; Projectile consult integration
(use-package consult-projectile)

;; Magit
(use-package magit
  :commands magit-status
  :bind (("C-x g" . magit-status)))

;; Git gutter
(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

;;; DIRED

(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file) ;; replace with dired-find-file once we install dired-open
  (evil-define-key 'normal peep-dired-mode-map (kbd "h") 'peep-dired-prev-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "l") 'peep-dired-next-file)
)


;; RSS feeds
(use-package elfeed
  :config
  (setq elfeed-feeds
        '(("https://planet.emacslife.com/atom.xml" coding emacs)
          ("https://hnrss.org/frontpage" coding hackernews)
          ("https://hnrss.org/jobs" hackernews jobs)
          ("https://hackernoon.com/feed" coding hackernoon)
          ("https://devblogs.microsoft.com/dotnet/feed/" coding dotnet)
          ("https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml" news)
          ("https://www.nzz.ch/startseite.rss" news))))

;;; Allow editing of age files directly
(use-package agenix)

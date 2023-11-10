;;; use-package is added automatically by the nix emacs overlay
;;; here we just make sure we don't have to keep typing `:ensure t`
(setq use-package-always-ensure t)

;;; GENERAL UI

;;; disable the default emacs startup screen (setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;;; disable some UI elements
(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room

;;; Line Numbers
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(setq display-line-numbers-type 'relative)


;;; FONTS AND THEMES
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 140)
;; (set-face-attribute 'variable-pitch nil :font "Ubuntu" :height 140)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 140)
;; Make commented text and keywords italics.
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)

(use-package doom-themes
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
  (setq evil-collection-mode-list '(dashboard dired ibuffer))
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

;;; move windows in Vim mode
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

;;; KEYBINDINGS

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

;; top-level stuff
(leader-def
  "a" 'org-agenda
  "c" 'org-capture)
;; buffer stuff
(leader-def
  "b" '(:ignore t :wk "[B]uffer")
  "bb" '(switch-to-buffer :wk "Switch [B]uffer")
  "bk" '(kill-current-buffer :wk "[K]ill Buffer")
  "bn" '(next-buffer :wk "[N]ext Buffer")
  "bp" '(previous-buffer :wk "[P]revious Buffer")
  "br" '(revert-buffer :wk "[R]evert Buffer"))

;;; WHICH-KEY
(use-package which-key
  :init (which-key-mode 1)
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

;;; TODO add vertico

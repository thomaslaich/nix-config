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


;;; KEYBINDINGS
;; (use-package bind-key
;;   :config
;;   (add-to-list 'same-window-buffer-names "*Personal Keybindings*"))
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

(general-create-definer window-def
  :prefix "C-w")


;; zoom keybindings
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; top-level keybindings
(leader-def
  "." 'find-file)

;; buffer keybindings
(leader-def
  "b" '(:ignore t :wk "[B]uffer")
  "b b" '(switch-to-buffer :wk "Switch [B]uffer")
  "b i" '(ibuffer :wk "[I]buffer")
  "b k" '(kill-current-buffer :wk "[K]ill Buffer")
  "b n" '(next-buffer :wk "[N]ext Buffer")
  "b p" '(previous-buffer :wk "[P]revious Buffer")
  "b r" '(revert-buffer :wk "[R]evert Buffer"))

;; evaluate elisp keybindings
(leader-def
  "e" '(:ignore t :wk "[E]valuate")
  "e b" '(eval-buffer :wk "Evaluate elisp in [b]uffer")
  "e d" '(eval-defun :wk "Evaluate elisp in [d]efun")
  "e e" '(eval-expression :wk "Evaluate elisp [e]xpression")
  "e l" '(eval-last-sexp :wk "Evaluate elisp in [l]ast sexp")
  "e r" '(eval-region :wk "Evaluate elisp in [r]egion"))

;; help keybindings
(leader-def
  "h" '(:ignore t :wk "[H]elp")
  "h a" '(apropos :wk "[A]propos")
  "h c" '(describe-char :wk "[C]haracter")
  "h f" '(describe-function :wk "[F]unction")
  "h k" '(describe-key :wk "[K]ey")
  "h m" '(describe-mode :wk "[M]ode")
  "h p" '(describe-package :wk "[P]ackage")
  "h v" '(describe-variable :wk "[V]ariable"))
  ;; need to add "h r r" for reloading config as well?

;; search
(leader-def
  "s" '(:ignore t :wk "[S]earch")
  "s f" '(consult-find :wk "[S]earch [F]iles")
  ;; TODO maybe add "s a" as in neovim?
  "s g" '(consult-ripgrep :wk "[S]earch by [G]rep")
  "s h" '(consult-man :wk "[S]earch [H]elp")
  "s i" '(info :wk "[S]earch [I]nfo")
  "s r" '(consult-recent-file :wk "[S]earch [R]ecent Files"))

;; Git
(leader-def
  "g" '(:ignore t :wk "[G]it")
  "g f" '(consult-git-grep :wk "[F]ind in Git")
  ;; TODO maybe at "g c" and "g b" as in neovim?
  "g s" '(magit-status :wk "Git [S]tatus"))


;; toggle keybindings
(leader-def
  "t" '(:ignore t :wk "[T]oggle")
  "t l" '(display-line-numbers-mode :wk "Toggle [L]ine Numbers")
  "t t" '(global-visual-line-mode :wk "Toggle [T]runcate Lines"))

;; org keybindings
(leader-def
  "o" '(:ignore t :wk "[O]rg")
  "o a" '(org-agenda :wk "[A]genda")
  "o c" '(org-capture :wk "[C]apture")
  "o l" '(org-store-link :wk "[L]ink")
  "o r" '(org-refile :wk "[R]efile")
  "o t" '(org-todo :wk "[T]odo"))

;; Window motions vim mode
(global-set-key (kbd "C-h") 'evil-windmove-left)
(global-set-key (kbd "C-j") 'evil-windmove-down)
(global-set-key (kbd "C-k") 'evil-windmove-up)
(global-set-key (kbd "C-l") 'evil-windmove-right)

; (window-def
;   "h" '(evil-window-left :wk "Move Horizontally Left")
;   "j" '(evil-window-down :wk "Move Horizontally Down")
;   "k" '(evil-window-up :wk "Move Horizontally Up")
;   "l" '(evil-window-right :wk "Move Horizontally Right")
; 
;   "c" '(evil-window-delete :wk "[C]lose Current Window")
;   "n" '(evil-window-new :wk "[N]ew Window")
;   "s" '(evil-window-split :wk "[S]plit (Horizontally)")
;   "v" '(evil-window-vsplit :wk "Split [V]ertically"))

(leader-def
  "w" '(:ignore t :wk "[W]indows")

  ;; Window splits
  "w c" '(evil-window-delete :wk "[C]lose Current Window")
  "w n" '(evil-window-new :wk "[N]ew Window")
  "w s" '(evil-window-split :wk "[S]plit (Horizontally)")
  "w v" '(evil-window-vsplit :wk "Split [V]ertically")

  ;; Window motions
  "w h" '(evil-window-left :wk "Move Horizontally Left")
  "w j" '(evil-window-down :wk "Move Horizontally Down")
  "w k" '(evil-window-up :wk "Move Horizontally Up")
  "w l" '(evil-window-right :wk "Move Horizontally Right")

  ;; Move windows
  "w H" '(buf-move-left :wk "Buffer Move Left")
  "w J" '(buf-move-down :wk "Buffer Move Down")
  "w K" '(buf-move-up :wk "Buffer Move Up")
  "w L" '(buf-move-right :wk "Buffer Move Right"))


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

;;; ORG MODE

;; enable table of contents
(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

;; org bullets
(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; disable electric indent
(electric-indent-mode -1)

;; source code block tab expansion
(use-package org-tempo)

;;; COMPLETION (VERTICO&CONSULT)
;; NOTE: use Vertico&Consult instead of Ivy&Counsel

(use-package vertico
  :init
  (vertico-mode)
  ;; TODO maybe we want to add one of these?
  
  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

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

;; Grepping using Consult
;; Example configuration for Consult
(use-package consult
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
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



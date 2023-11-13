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
(set-face-attribute 'variable-pitch nil :font "Ubuntu Nerd Font" :height 140)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 140)
;; Make commented text and keywords italics.
;; (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
;; (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)

(use-package nerd-icons)

(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm))

(setq catppuccin-flavor 'macchiato) ;; or 'latte, 'macchiato, or 'mocha
(catppuccin-reload)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; tranparency (doing nothing on MacOS :( )
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Hide minor modes from modeline (by adding :diminish to use-package)
(use-package diminish)

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
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit))
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
  "s" '(:ignore t :wk "[S]earch")
  "s f" '(consult-find :wk "Search Files")
  "s b" '(consult-buffer :wk "Search Buffer")
  "s /" '(consult-buffer :wk "Search Buffer")
  ;; TODO maybe add "s a" as in neovim?
  "s g" '(consult-ripgrep :wk "Search by [G]rep")
  "s h" '(consult-man :wk "Search Help")
  "s i" '(info :wk "Search Info")
  "s r" '(consult-recent-file :wk "Search Recent Files"))

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
  "o c" '(org-capture :wk "Capture")
  "o l" '(org-store-link :wk "Link")
  "o r" '(org-refile :wk "Refile")
  "o t" '(org-todo :wk "Todo"))

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

;; LSP only keybindings
(add-hook 'lsp-mode-hook
          (lambda ()
            (progn 
              (leader-def
                "l" '(:ignore t :wk "[L]SP")
                "l d" '(lsp-find-definition :wk "[D]efinition")
                "l r" '(lsp-find-references :wk "[R]eferences")
                "l i" '(lsp-organize-imports :wk "[I]mports")
                "l f" '(lsp-format-buffer :wk "[F]ormat Buffer")

                "c d" '(lsp-find-definition :wk "Definition")
                "c f" '(lsp-format-buffer :wk "Format Buffer")
                "c i" '(lsp-organize-imports :wk "Imports")
                "c r" '(lsp-find-references :wk "References")
                "c t" '(lsp-find-type-definition :wk "Type Definition"))

              (local-leader-def
                "d" `(lsp-find-definition :wk "Definition")
                "f" `(lsp-format-buffer :wk "Format Buffer"))
            ))
          )

;; local leader shorts

(leader-def "p" '(projectile-command-map :wk "[P]rojects"))

;; TODO not working
;; standardized
(define-key evil-motion-state-map (kbd "gd") 'lsp-find-declaration)

;; (global-set-key (kbd "g d") '(lsp-find-definition :wk "[D]efinition"))
;; (global-set-key "g D" '(lsp-find-declaration :wk "[D]eclaration"))
;; (global-set-key "g i" '(lsp-find-implementation :wk "[I]mplementation"))
;; (global-set-key "g r" '(lsp-find-references :wk "[R]eferences"))
;; (global-set-key (kbd "K") '(lsp-describe-thing-at-point :wk "[K]ind"))

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

;; disable electric indent
(electric-indent-mode -1)

;;; COMPLETION (VERTICO&CONSULT)
;; NOTE: use Vertico&Consult instead of Ivy&Counsel

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
  ;; (setq register-preview-delay 0.5
  ;;       register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  ;; (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  ;; (setq xref-show-xrefs-function #'consult-xref
  ;;       xref-show-definitions-function #'consult-xref)

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
  ;; (consult-customize
  ;;  consult-theme :preview-key '(:debounce 0.2 any)
  ;;  consult-ripgrep consult-git-grep consult-grep
  ;;  consult-bookmark consult-recent-file consult-xref
  ;;  consult--source-bookmark consult--source-file-register
  ;;  consult--source-recent-file consult--source-project-recent-file
  ;;  ;; :preview-key "M-."
  ;;  :preview-key '(:debounce 0.4 any))

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

;; completion
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)
(use-package company-box
  :hook (company-mode . company-box-mode))


;; Lispy (for emacs lisp)
(use-package lispy)
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

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

;; now part of evil-collection?
;; (use-package evil-magit
;;   :after magit)

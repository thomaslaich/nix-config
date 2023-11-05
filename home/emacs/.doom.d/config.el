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
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-tokyo-night)

;; ;; If you intend to use org, it is recommended you change this!
;; (if IS-MAC
;;     (setq org-directory "~/Dropbox/Personales/org/")
;;   (setq org-directory "~/Secundario/Dropbox/Personales/org/"))

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type 'relative)

;; Prevents some cases of Emacs flickering.
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Paren pride!
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

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


;;
;;; Keybinds

(map! (:after evil-org
       :map evil-org-mode-map
       :n "gk" (cmd! (if (org-on-heading-p)
                         (org-backward-element)
                       (evil-previous-visual-line)))
       :n "gj" (cmd! (if (org-on-heading-p)
                         (org-forward-element)
                       (evil-next-visual-line))))

      :o "o" #'evil-inner-symbol

      :leader
      "h L" #'global-keycast-mode
      (:prefix "f"
       "t" #'find-in-dotfiles
       "T" #'browse-dotfiles)
      (:prefix "n"
       "b" #'org-roam-buffer-toggle
       "d" #'org-roam-dailies-goto-today
       "D" #'org-roam-dailies-goto-date
       "e" (cmd! (find-file (doom-path org-directory "ledger/personal.gpg")))
       "i" #'org-roam-node-insert
       "r" #'org-roam-node-find
       "R" #'org-roam-capture))

(after! evil-escape
  (setq evil-escape-key-sequence "jj"))

;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;; TODO update this
;;; :lang org
(setq org-directory "~/notes/org"
      org-roam-directory org-directory
      org-roam-db-location (file-name-concat org-directory ".org-roam.db")
      org-roam-dailies-directory "journal/"
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory))

(after! org
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("t" "todo" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\n%i\n%a"
           :prepend t)
          ("d" "deadline" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\nDEADLINE: <%(org-read-date)>\n\n%i\n%a"
           :prepend t)
          ("s" "schedule" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\nSCHEDULED: <%(org-read-date)>\n\n%i\n%a"
           :prepend t)
          ("c" "check out later" entry (file+headline "todo.org" "Check out later")
           "* [ ] %?\n%i\n%a"
           :prepend t)
          ("l" "ledger" plain (file "ledger/personal.gpg")
           "%(+beancount/clone-transaction)"))))

(after! org-roam
  (setq org-roam-capture-templates
        `(("n" "note" plain
           ,(format "#+title: ${title}\n%%[%s/template/note.org]" org-roam-directory)
           :target (file "note/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("r" "thought" plain
           ,(format "#+title: ${title}\n%%[%s/template/thought.org]" org-roam-directory)
           :target (file "thought/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("t" "topic" plain
           ,(format "#+title: ${title}\n%%[%s/template/topic.org]" org-roam-directory)
           :target (file "topic/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("c" "contact" plain
           ,(format "#+title: ${title}\n%%[%s/template/contact.org]" org-roam-directory)
           :target (file "contact/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("p" "project" plain
           ,(format "#+title: ${title}\n%%[%s/template/project.org]" org-roam-directory)
           :target (file "project/%<%Y%m%d>-${slug}.org")
           :unnarrowed t)
          ("i" "invoice" plain
           ,(format "#+title: %%<%%Y%%m%%d>-${title}\n%%[%s/template/invoice.org]" org-roam-directory)
           :target (file "invoice/%<%Y%m%d>-${slug}.org")
           :unnarrowed t)
          ("f" "ref" plain
           ,(format "#+title: ${title}\n%%[%s/template/ref.org]" org-roam-directory)
           :target (file "ref/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("w" "works" plain
           ,(format "#+title: ${title}\n%%[%s/template/works.org]" org-roam-directory)
           :target (file "works/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("s" "secret" plain "#+title: ${title}\n\n"
           :target (file "secret/%<%Y%m%d%H%M%S>-${slug}.org.gpg")
           :unnarrowed t))
        ;; Use human readable dates for dailies titles
        org-roam-dailies-capture-templates
        `(("d" "default" plain ""
           :target (file+head "%<%Y-%m-%d>.org" ,(format "%%[%s/template/journal.org]" org-roam-directory))))))

(after! org-tree-slide
  ;; I use g{h,j,k} to traverse headings and TAB to toggle their visibility, and
  ;; leave C-left/C-right to .  I'll do a lot of movement because my
  ;; presentations tend not to be very linear.
  (setq org-tree-slide-skip-outline-level 2))

(after! org-roam
  ;; Offer completion for #tags and @areas separately from notes.
  (add-to-list 'org-roam-completion-functions #'org-roam-complete-tag-at-point)

  ;; Automatically update the slug in the filename when #+title: has changed.
  (add-hook 'org-roam-find-file-hook #'org-roam-update-slug-on-save-h)

  ;; Make the backlinks buffer easier to peruse by folding leaves by default.
  (add-hook 'org-roam-buffer-postrender-functions #'magit-section-show-level-2)

  ;; List dailies and zettels separately in the backlinks buffer.
  (advice-add #'org-roam-backlinks-section :override #'org-roam-grouped-backlinks-section)

  ;; Open in focused buffer, despite popups
  (advice-add #'org-roam-node-visit :around #'+popup-save-a)

  ;; Make sure tags in vertico are sorted by insertion order, instead of
  ;; arbitrarily (due to the use of group_concat in the underlying SQL query).
  (advice-add #'org-roam-node-list :filter-return #'org-roam-restore-insertion-order-for-tags-a)

  ;; Add ID, Type, Tags, and Aliases to top of backlinks buffer.
  (advice-add #'org-roam-buffer-set-header-line-format :after #'org-roam-add-preamble-a))


;;; :ui doom-dashboard
;; (setq fancy-splash-image (file-name-concat doom-user-dir "splash.png"))
;; Hide the menu for as minimalistic a startup screen as possible.
;; (setq +doom-dashboard-functions '(doom-dashboard-widget-banner))


;;; TODO figure out if I want this
;; ;;; :app everywhere
;; (after! emacs-everywhere
;;   ;; Easier to match with a bspwm rule:
;;   ;;   bspc rule -a 'Emacs:emacs-everywhere' state=floating sticky=on
;;   (setq emacs-everywhere-frame-name-format "emacs-anywhere")
;;
;;   ;; The modeline is not useful to me in the popup window. It looks much nicer
;;   ;; to hide it.
;;   (remove-hook 'emacs-everywhere-init-hooks #'hide-mode-line-mode)
;;
;;   ;; Semi-center it over the target window, rather than at the cursor position
;;   ;; (which could be anywhere).
;;   (defadvice! center-emacs-everywhere-in-origin-window (frame window-info)
;;     :override #'emacs-everywhere-set-frame-position
;;     (cl-destructuring-bind (x y width height)
;;         (emacs-everywhere-window-geometry window-info)
;;       (set-frame-position frame
;;                           (+ x (/ width 2) (- (/ width 2)))
;;                           (+ y (/ height 2))))))



;; ;;
;; ;;; Language customizations
;;
;; (use-package! agenix
;;   :mode ("\\.age\\'" . agenix-mode)
;;   :config
;;   (add-to-list 'agenix-key-files "~/.config/ssh/id_ed25519")
;;   (add-to-list 'agenix-key-files "/etc/ssh/host_ed25519")
;;   (dolist (file (doom-glob "~/.config/ssh/*/id_ed25519"))
;;     (add-to-list 'agenix-key-files file)))
;;
;; (define-generic-mode sxhkd-mode
;;   '(?#)
;;   '("alt" "Escape" "super" "bspc" "ctrl" "space" "shift") nil
;;   '("sxhkdrc") nil
;;   "Simple mode for sxhkdrc files.")

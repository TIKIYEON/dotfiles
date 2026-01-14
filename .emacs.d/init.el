;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

;; Usepackage
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; Dotnet paths and stuff
(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/.dotnet/tools")))
(add-to-list 'exec-path (expand-file-name "~/.dotnet/tools"))

;; UI Tweaks
(setq inhibit-startup-message t)
(setq visible-bell t)
(setq ring-bell-function 'ignore)
(scroll-bar-mode -1)    ; Disable visible scrollbar
(tool-bar-mode -1)      ; Disable toolbar
(tooltip-mode -1)       ; Disable tooltip
(set-fringe-mode 10)    ; Give some breathing room
(menu-bar-mode -1)      ; Disable menu bar

;; Set font
(set-face-attribute 'default nil :family "Adwaita Mono" :height 125 :weight 'semi-bold)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Adwaita Mono" :height 110))))
 '(variable-pitch ((t (:family "Adwaita Sans" :height 125)))))
(add-hook 'org-mode-hook 'variable-pitch-mode)

;;; Keybindings
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Switch buffer
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; Eglot things
(global-set-key (kbd "C-c a") 'eglot-code-actions)

;; Enable which-key
(which-key-mode 1)

;; Relative line numbers
(column-number-mode)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Automatch brackets
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)
;;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Set Theme
(load-theme 'modus-operandi-tinted t)

; Package
;; Enable vertico
(setq completion-styles '(basic substring partial-completion flex))
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)
;; Use `consult-completion-in-region' if Vertico is enabled.
;; Otherwise use the default `completion--in-region' function.
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))
(use-package vertico
	     :init
	     (vertico-mode)
	     :custom
	     ;; (vertico-scroll-margin 0) ;; Different scroll margin
	      (vertico-count 8) ;; Show more candidates
	     ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
	      (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
	     :bind (:map vertico-map
         		("?" . minibuffer-completion-help)
         		("M-RET" . minibuffer-force-complete-and-exit)
         		;("M-TAB" . minibuffer-complete)
         		;; Uncomment if you want to use TAB for completion
         		("TAB" . minibuffer-complete))
	     )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
	     :init
	     (savehist-mode))

;; A few more useful configurations...
(use-package emacs
	     :custom
	     ;; Support opening new minibuffers from inside existing minibuffers.
	     (enable-recursive-minibuffers t)
	     ;; Hide commands in M-x which do not work in the current mode.  Vertico
	     ;; commands are hidden in normal buffers. This setting is useful beyond
	     ;; Vertico.
	     (read-extended-command-predicate #'command-completion-default-include-p)
	     (tab-always-indent 'complete)
	     (text-mode-ispell-word-completion nil)
	     (read-extended-command-predicate #'command-completion-default-include-p)

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
	     (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
	     :custom
	     (completion-styles '(orderless basic))
	     (completion-category-defaults nil)
	     (completion-category-overrides '((file (styles partial-completion)))))

;; Marginelia
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

;; Embark
(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))


;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

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
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-marginalia-setup)
  (nerd-icons-completion-mode 1))

;; Corfu
;; TAB-only configuration
(use-package corfu
  :custom
  (corfu-auto t)               ;; Enable auto completion
  (corfu-preselect 'directory) ;; Select the first candidate, except for directories

  :init
  (global-corfu-mode)

  :config
  (keymap-set corfu-map "RET" `( menu-item "" nil :filter
                                 ,(lambda (&optional _)
                                    (and (derived-mode-p 'eshell-mode 'comint-mode)
                                         #'corfu-send)))))


(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icons-blend-background t)
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Languages
;; fsharp
(use-package fsharp-mode
  :mode "\\.fs[iylx]?\\'" ;;Explicitly defining file extensions
  :config
  (use-package eglot-fsharp
    :after eglot
    :config
    (add-to-list 'eglot-server-programs
                 '(fhsarp-mode . ("fsautocomplete" "--background-services-enabled")))))

(use-package haskell-mode
  :ensure t)

(use-package eglot
  :ensure t
  :config
  (add-hook 'fsharp-mode-hook 'eglot-ensure))

(use-package flymake
  :ensure nil
  :bind (:map global-map
              ("M-n" . #'flymake-goto-next-error)
              ("M-p" . #'flymake-goto-prev-error)))

;; Indent bars (with tree sitter)
(use-package indent-bars
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-no-descend-lists t)
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement if_statement with_statement while_statement)
                               (fsharp-mode function_definition module_definition)))
  (indent-bars-display-on-blank-lines nil)
  (indent-bars-color '("#C8E6C9" :blend 0.3))
  :hook ((python-mode yaml-mode fsharp-mode lisp-mode common.lisp-mode) . indent-bars-mode))

(use-package org-roam
  :ensure t
  :straight t
  :custom
  (org-roam-directory (file-truename "/home/tikki/Documents/CSnotes/roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-roam-ui
  :straight
    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
    :after org-roam
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; Org agenda things
(setq org-log-done t)
(setq org-agenda-files '("~/Documents/School/tasks.org"
                         "~/Documents/School/TA-s-corner/tasks.org"))
(global-set-key (kbd "C-c a") 'org-agenda)

(with-eval-after-load 'org
  (setq org-startup-indented t)
  (add-hook 'org-mode-hook #'visual-line-mode))

;; org superstar
 (use-package org-superstar
    :config
    (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

;; Futhark
(use-package futhark-mode)

;; OCaml
(add-to-list 'load-path "/home/tikki/.opam/default/share/emacs/site-lisp")
(require 'ocp-indent)
(use-package neocaml
  :vc (:url "https://github.com/bbatsov/neocaml" :rev :newest)
  ;; teach Eglot about neocaml
  (add-to-list 'eglot-server-programs '((neocaml-mode :language-id "ocaml") . ("ocamllsp")))
  (add-hook 'neocaml-mode-hook #'neocaml-repl-minor-mode)
)
;; this font-lock everything neocaml supports
(setq neocaml-use-prettify-symbols t)
;; this font-lock everything neocaml supports
(setq treesit-font-lock-level 4)

;; Eldoc-box
;;(require 'eldoc-box)
;(add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
(use-package eldoc-box
  :after eglot                      ;; ensure eglot is loaded first
                                        ;:hook (eglot-managed-mode . eldoc-box-hover-mode)   ;; enable hover mode in eglot buffer
  :bind (:map eglot-mode-map
              ("C-c C-e" . eldoc-box-help-at-point))) ;; bind in eglot buffers
(add-hook 'eldoc-box-buffer-setup-hook #'eldoc-box-prettify-ts-errors 0 t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-vc-selected-packages '((neocaml :url "https://github.com/bbatsov/neocaml"))))


(require 'package)
(setq package-check-signature nil)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("melpa" . "https://gitlab.com/d12frosted/elpa-mirror/raw/master/melpa/")
        ("org"   . "https://gitlab.com/d12frosted/elpa-mirror/raw/master/org/")
        ("gnu"   . "https://gitlab.com/d12frosted/elpa-mirror/raw/master/gnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package htmlize
  :commands (htmlize-buffer
	     htmlize-file
	     htmlize-many-files
	     htmlize-many-files-dired
	     htmlize-region))

(use-package markdown-mode)
(show-paren-mode)
(global-flycheck-mode)

(setq
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")

(use-package counsel
  :after ivy
  :config (counsel-mode))

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package lsp-mode
  :hook
  (rust-mode . lsp-deferred)
  (python-mode . lsp-deferred)
  (go-mode . lsp-deferred)
  :commands lsp
  :config
  (setq lsp-rust-rls-server-command "/home/mjones/.cargo/bin/rls")
  (setq lsp-log-io 1)
  (setq lsp-pyls-configuration-sources ["flake8"])
  (setq lsp-pyls-plugins-pylint-enabled nil)
  (setq lsp-pyls-plugins-mccabe-enabled nil)
  (add-hook 'go-mode-hook
	    (lambda ()
	      (setq tab-width 4)))
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
)
;; optionally
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (lsp-ui-sideline-toggle-symbols-info)
  (setq lsp-prefer-flymake nil))

(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)

(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (require 'dap-python)
  (require 'dap-ui)
  (dap-mode t)
  (dap-ui-mode t)
  ;; enables mouse hover support
  (dap-tooltip-mode t)
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (tooltip-mode t)
  )

(use-package yaml-mode
  :config
  (setq yaml-indent-offset 2))

(use-package rust-mode)

(use-package browse-at-remote
  :commands browse-at-remote
  :bind ("C-c g g" . browse-at-remote))

(use-package fill-column-indicator
  :config
  (setq-default fci-rule-column 80)
  (setq fci-rule-color (face-attribute 'highlight :background)))

;; (use-package helm
;;   :config
;;   (require 'helm)
;;   (require 'helm-config)
;;   (helm-mode t)

;;   (global-set-key (kbd "M-x") 'helm-M-x)
;;   (global-set-key (kbd "C-c f r") 'helm-recentf)
;;   (global-set-key (kbd "C-x C-f") 'helm-find-files)
;;   (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;;   (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
;;   (define-key helm-map (kbd "C-z")  'helm-select-action)

;;   (setq helm-ff-auto-update-initial-value t)
;;   (setq helm-mode-fuzzy-match t)
;;   (setq helm-completion-in-region-fuzzy-match t)
;;   (setq helm-split-window-in-side-p t))

;; (use-package helm-ag
;;   :bind ("C-c p" . helm-projectile-ag)
;;   :commands (helm-ag helm-projectile-ag)
;;   :init (setq helm-ag-insert-at-point 'symbol
;; 	      helm-ag-command-option "--path-to-ignore ~/.agignore"))

;; (use-package projectile
;;   :commands (projectile-find-file projectile-switch-project)
;;   :diminish projectile-mode
;;   :init
;;   (use-package helm-projectile
;;     :bind
;;     (("M-t" . helm-projectile-find-file)
;;      ("M-p" . helm-projectile-switch-project)))
;;   :config
;;   (setq projectile-switch-project-action #'projectile-commander)
;;   (projectile-global-mode)
;;   (helm-projectile-on))

(use-package projectile
  :config
  (use-package counsel-projectile
    :bind
    (("M-t" . counsel-projectile-find-file)
     ("M-p" . counsel-projectile-switch-project)
     ("C-c p" . counsel-projectile-ag))
    :config
    (counsel-projectile-mode))
  (setq projectile-switch-project-action #'projectile-commander)
  (setq projectile-enable-caching t)
;;  (setq projectile-indexing-method 'alien)
;;  (setq projectile-git-submodule-command nil)
  (projectile-mode))

(use-package magit
  :bind
  (("C-x g" . magit-status))
  :config
  (setq magit-repository-directories
      `(("~/ansible" . 1)
        ("~/ogs" . 1)
        ("~/projects" . 1)))
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(use-package forge
  :after magit)

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package undo-tree
   :init
   (undo-tree-mode))

(use-package which-key
   :config
   (which-key-mode)
   (which-key-setup-minibuffer))

(use-package wttrin
  :config
  (setq wttrin-default-cities '("Raleigh NC" "Madison MS")))

(setq inhibit-splash-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode)
(setq column-number-mode t)
(setq tab-width 4)

(use-package cyberpunk-theme
   :config
   (load-theme `cyberpunk t))

(setq custom-file "~/.emacs.d/generated.el")
(provide '.emacs)

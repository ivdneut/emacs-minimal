(require 'package)
(package-initialize)

(require 'undo-tree)
(global-undo-tree-mode 1)

(require 'org-tempo)

;;
;; Set custom key bindings.
;;
(global-set-key [home] 'back-to-indentation)
(global-set-key (kbd "C-z") 'undo) ;; set ctrl-z to undo, since the normal ctrl-z is useless
(global-set-key (kbd "C-S-z") 'redo) ;; set ctrl-shift-Z to redo
(global-set-key (kbd "C-f") 'isearch-forward) ;; Like most applications
(define-key isearch-mode-map [(control f)] 'isearch-repeat-forward) ;; Move all isearch features to ctrl-f
(global-set-key (kbd "C-s") 'save-buffer) ;; Like most applications
(global-set-key (kbd "C-v") 'yank) ;; It's annoying to accidentally paste with C-v and scroll down instead.
(global-set-key (kbd "C-|") 'split-window-right)
(global-set-key (kbd "C-=") 'split-window-below)
;; keypad 5 goes to beginning of file by default if numlock is off. Make it do nothing instead.
;; need both kp-5 and kp-begin setting because if emacs is running in terminal it inserts 5 in the text.
(global-set-key (kbd "<kp-5>") 'ignore)
(global-set-key (kbd "<kp-begin>") 'ignore)

;;
;; Unset some key bindings that just get in the way
;;
(global-unset-key (kbd "M-="))  ;; Toggles window between full screen and tiled to half in chromeos
(global-unset-key (kbd "M-]"))  ;; Moves window to right half of screen in chromeos
(global-unset-key (kbd "M-["))  ;; Moves window to left half of the screen in chromeos
(global-unset-key (kbd "C-b"))  ;; Interferes with tmux prefix key
;; C-/ comments lines in VSCode. Can't be rebound in Emacs, so just disable.
(with-eval-after-load 'undo-tree		   ;; undo-tree overrides the mapping, so wait until loaded
  (define-key undo-tree-map (kbd "C-/") #'ignore)) ;; Setting to nil doesn't work, need to explicitly ignore.

(delete-selection-mode 1) ;; Allow pasting to overwrite current selection
(setq scroll-conservatively 101) ;; Smooth scrolling
(setq scroll-step 1)
(setq scroll-margin 3)
(global-hl-line-mode 1)
(set-face-background hl-line-face "color-234")
(electric-pair-mode 1)

;; Install treesitter language grammars.
(setq treesit-extra-load-path '("~/.emacs.d/tree-sitter" "~/.config/emacs/tree-sitter"))
(setq treesit-load-name-override-list
      '((go "libtree-sitter-go" "tree_sitter_go"))) 
(setq treesit-font-lock-level 4)

;; Set repo URLs for languages that are not auto detected
(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))

(define-derived-mode asm-ts-mode asm-mode "Asm[TS]"
  "Major mode for editing Assembly code using tree-sitter."
  (when (treesit-ready-p 'asm)
    (treesit-parser-create 'asm)
    ;; Initialize tree-sitter settings
    (treesit-major-mode-setup)))

(add-to-list 'auto-mode-alist '("\\.s\\'" . asm-ts-mode))
(add-to-list 'auto-mode-alist '("\\.S\\'" . asm-ts-mode))
(add-to-list 'auto-mode-alist '("\\.asm\\'" . asm-ts-mode))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
(add-to-list 'auto-mode-alist '("\\.java\\'" . java-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.sh\\'" . bash-ts-mode))
(add-to-list 'auto-mode-alist '("\\.bash\\'" . bash-ts-mode))
(add-to-list 'auto-mode-alist '("bashrc" . bash-ts-mode))
(add-to-list 'auto-mode-alist '("bash_profile'" . bash-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.env\\'" . bash-ts-mode))
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-ts-mode))
(add-to-list 'auto-mode-alist '("\\.htm\\'" . html-ts-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-ts-mode))

;; Note: Emacs does not have a built-in 'perl-ts-mode' yet, 
;; so perl files will still rely on standard perl-mode.


(defun new-frame-setup (frame)
  (when (display-graphic-p frame)
    (message "window system")
    (tool-bar-mode -1)
    (load-theme 'modus-operandi t)
    (modify-frame-parameters frame
			     '((vertical-scroll-bars . right)))))

;; Run for already-existing frames
(mapc 'new-frame-setup(frame-list))
;; Run when a new frame is created
(add-hook 'after-make-frame-functions 'new-frame-setup)

;;
;; Set backup directory where backup files are supposed to endup.
;;
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/tmp/emacs-saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; (setq undo-tree-auto-save-history nil)
(setq undo-tree-history-directory-alist '(("." . "~/tmp/.emacs-saves/undo-tree-history")))

;;
;; Use shell-script-mode for .env files
;; Use lisp mode for the emacs config file
;;
(setq auto-mode-alist
	     (append auto-mode-alist
		      '(("\\.env\\'" . shell-script-mode)
		       ("emacs\\'" . lisp-mode))
		       ))

(require 'asm-mode)
(add-hook 'asm-mode-hook (lambda ()
                           ;; (setq indent-tabs-mode nil) ; use spaces to indent
                           (electric-indent-mode -1) ; indentation in asm-mode is annoying
                           (setq tab-stop-list (number-sequence 4 12 40 ))))
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'c++-ts-mode-hook 'eglot-ensure)

;;
;; Enable ido mode
;;
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(adoc-mode agda2-mode apache-mode ats2-mode auto-complete bazel
	       bison-mode bpftrace-mode caml clojure-mode cmake-mode
	       company csv-mode dart-mode dockerfile-mode dpkg-dev-el
	       elm-mode fountain-mode git-modes gitattributes-mode
	       gitconfig-mode gitignore-mode gitlab-ci-mode gnuplot
	       go-mode graphviz-dot-mode haskell-mode imenu-list
	       inform-mode jinja2-mode js2-mode kivy-mode kotlin-mode
	       lua-mode markdown-mode matlab-mode meson-mode
	       muttrc-mode nginx-mode olivetti paredit php-mode
	       pip-requirements po-mode pos-tip protobuf-mode
	       puppet-mode qml-mode racket-mode rust-mode scala-mode
	       sml-mode systemd undo-tree vala-mode web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(package-initialize)

(require 'undo-tree)
(global-undo-tree-mode 1)

(require 'org-tempo)

;;
;; Set custom key bindings.
;;
(global-set-key (kbd "C-z") 'undo) ;; set ctrl-z to undo, since the normal ctrl-z is useless
(global-set-key (kbd "C-S-z") 'redo) ;; set ctrl-shift-Z to redo
(global-set-key (kbd "C-f") 'isearch-forward) ;; Like most applications
(define-key isearch-mode-map [(control f)] 'isearch-repeat-forward) ;; Move all isearch features to ctrl-f
(global-set-key (kbd "C-s") 'save-buffer) ;; Like most applications
(global-set-key (kbd "C-v") 'yank) ;; It's annoying to accidentally paste with C-v and scroll down instead.
(global-set-key (kbd "C-|") 'split-window-right)
(global-set-key (kbd "C-=") 'split-window-below)

;;
;; Unset some key bindings that just get in the way
;;
(global-unset-key (kbd "M-="))  ;; Toggles window between full screen and tiled to half in chromeos
(global-unset-key (kbd "M-]"))  ;; Moves window to right half of screen in chromeos
(global-unset-key (kbd "M-["))  ;; Moves window to left half of the screen in chromeos
(global-unset-key (kbd "C-b"))  ;; Interferes with tmux prefix key

(delete-selection-mode 1) ;; Allow pasting to overwrite current selection
(setq scroll-conservatively 101) ;; Smooth scrolling
(setq scroll-step 1)
(setq scroll-margin 3)
(global-hl-line-mode 1)
(electric-pair-mode 1)

(when (display-graphic-p)
    (tool-bar-mode -1)
    (load-theme 'tango-dark t)
)

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

;;
;; Use shell-script-mode for .env files
;; Use lisp mode for the emacs config file
;;
(setq auto-mode-alist
	     (append auto-mode-alist
	     	     '(("\\.env\\'" . shell-script-mode)
		       ("emacs\\'" . lisp-mode))
		       ))

;;
;; Enable ido mode
;;
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

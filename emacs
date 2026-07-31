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

;;
;; Unset some key bindings that just get in the way
;;
(global-unset-key (kbd "M-="))  ;; Toogles window between full screen and tiled to half it previously was
(global-unset-key (kbd "M-]"))  ;; Moves window to right half of screen in chromeos
(global-unset-key (kbd "M-["))  ;; Moves window to left half of the screen in chromeos

(load-theme 'tango-dark t)
(if window-system (tool-bar-mode -1))

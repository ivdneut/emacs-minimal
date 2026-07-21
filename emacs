(require 'package)
(package-initialize)

(require 'undo-tree)
(global-undo-tree-mode 1)

;;
;; Set custom key bindings.
;;
(global-set-key (kbd "C-z") 'undo) ;; set ctrl-z to undo, since the normal ctrl-z is useless
(global-set-key (kbd "C-S-z") 'redo) ;; set ctrl-shift-Z to redo
(global-set-key (kbd "C-w") 'kill-buffer) ;; I use Ctrl-backspace or Delete key to delete a word.
(global-set-key (kbd "C-f") 'isearch-forward) ;; Like most applications
(global-set-key (kbd "C-s") 'save-buffer) ;; Like most applications

;;
;; Unset some key bindings that just get in the way
;;
(global-unset-key (kbd "M-="))  ;; Toogles window between full screen and tiled to half it previously was
(global-unset-key (kbd "M-]"))  ;; Moves window to right half of screen in chromeos
(global-unset-key (kbd "M-["))  ;; Moves window to left half of the screen in chromeos

(load-theme 'tango-dark t)
(tool-bar-mode -1)
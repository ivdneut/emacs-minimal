(require 'package)
(package-initialize)

(require 'undo-tree)
(global-undo-tree-mode 1)

;;
;; Set custom key bindings.
;;
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key (kbd "C-z") 'undo) ;; set ctrl-z to undo, since the normal ctrl-z is useless
(global-set-key (kbd "C-S-z") 'redo) ;; set ctrl-shift-Z to redo

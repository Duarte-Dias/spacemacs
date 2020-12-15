(set-face-attribute 'header-line nil
                    :weight 'light
                    :overline nil
                    :underline nil
                    :box nil
                    :box `(:line-width 1 :color "#444444" :style nil)
                    :inherit nil)
  (defun header-line-render (left right)
    (let* ((available-width (- (window-total-width) (length left) )))
      (format (format "%%s%%%ds" available-width) left right)))

  (setq-default header-line-format
                '((:eval
                   (header-line-render
                    (format-mode-line
                     (list
                      (cond ((and buffer-file-name (buffer-modified-p)) " [M] ")
                            (buffer-read-only                           " [RO] ")
                            (t                                          " "))
                      (propertize "%b" 'face '(:weight regular))
                      " (%m)"
                      (propertize " " 'display '(raise +0.25))
                      (propertize " " 'display '(raise -0.30))))
                    (format-mode-line
                     (list "%l:%c "))))))

 ;; (setq-default mode-line-format nil)

; set s-T to terminal
(exwm-input-set-key (kbd "s-t") 'spacemacs/default-pop-shell)

(exwm-input-set-key (kbd "s-r") #'counsel-linux-app)

(exwm-input-set-key (kbd "s-f") #'exwm-floating-toggle-floating)

(with-eval-after-load 'org
 (add-hook 'org-mode-hook 'visual-fill-column-mode)
 (add-hook 'org-mode-hook 'visual-line-mode)

 (setq org-startup-indented t)

 (setq org-image-actual-width nil)

 )

(require 'quelpa)
(let ((default-directory  "~/.emacs.d/.cache/quelpa/build/"))
  (normal-top-level-add-subdirs-to-load-path))
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

(defvar musicplayer-metadata "" "Currently playing song")
    (defvar musicplayer--update-metadata-every 2 "Fetch current song every x seconds")
    (defun musicplayer-update-metadata ()
      "Update `musicplayer--metadata` variable"
      (message "using yes using")
      (setq musicplayer-metadata
            (replace-regexp-in-string
             "\n$" ""
             (shell-command-to-string "playerctl metadata --format '{{artist}} - {{title}}'"))
            )
      )

(defvar musicplayer-metadata-timer nil "Timer for metadata updates")
(defun musicplayer-update-metadata-toggle ()
    "toggle metadata fetching song"
    (interactive)
    (if (null musicplayer-metadata-timer)
        (setq musicplayer-metadata-timer (run-with-timer 0 musicplayer--update-metadata-every 'musicplayer-update-metadata))
      (progn 
        (cancel-timer musicplayer-metadata-timer)
        (setq musicplayer-metadata-timer nil)
        (setq musicplayer-metadata "")
        )
      )
    )

(use-package mini-modeline
  :quelpa (mini-modeline :repo "kiennq/emacs-mini-modeline" :fetcher github)
  :config
  (setq display-time-default-load-average nil)
  (setq mini-modeline-r-format '("%e" mode-line-front-space
                                 musicplayer-metadata " "
                                 evil-mode-line-tag
                                 display-time-string
                                 " "
                                 fancy-battery-mode-line))
  (setq mini-modeline-right-padding 3) ;; need some space
  (mini-modeline-mode t)
  )
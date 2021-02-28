(spacemacs|disable-company org-mode)

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

(setq visual-fill-column-center-text t)
(with-eval-after-load 'org
 (add-hook 'org-mode-hook 'visual-fill-column-mode)
 (add-hook 'org-mode-hook 'visual-line-mode)

 (setq org-startup-indented t)

 (setq org-image-actual-width nil)
 (setq org-fontify-done-headline t)

 )

(defun my/gtd-view ()
  "Launch the gtd view, containing gtd.org, inbox.org and the agenda"
  (interactive)
  (progn
    (delete-other-windows)
    (find-file "~/org/gtd.org")
    (let (oldVal org-agenda-window-setup)
      (setq org-agenda-window-setup `current-window)
      (split-window-right-and-focus)
      (org-agenda-list)
      (setq org-agenda-window-setup oldVal)
      )
    (windmove-left)
    (split-window-below -10)
    (windmove-down)
    (find-file "~/org/inbox.org")
    (windmove-up)
    )
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

;; set s-T to terminal
(exwm-input-set-key (kbd "s-t") 'terminal-here)

(exwm-input-set-key (kbd "s-r") 'counsel-linux-app)

(exwm-input-set-key (kbd "s-f") 'exwm-floating-toggle-floating)
(exwm-input-set-key (kbd "s-w g") 'my/gtd-view)

(setq myposframe-params 
      '((parent-frame nil)
       (left-fringe . 8)
       (right-fringe . 8)
       ))

  (use-package ivy-posframe
    :ensure t
    :custom
    (ivy-posframe-parameters myposframe-params)
    (ivy-posframe-display-functions-alist 
     '((t . ivy-posframe-display-at-frame-center)))
    :config
    (ivy-posframe-mode 1)
    )
  (use-package which-key-posframe
    :ensure t
    :custom
    (which-key-posframe-parameters myposframe-params)
    :config
    (which-key-posframe-mode)
    )

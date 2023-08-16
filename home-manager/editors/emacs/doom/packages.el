;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
(disable-packages! evil-escape)
;;(unpin! lsp-mode)
;;(unpin! forge)





(package! info-colors)

;;(package! jieba :recipe (:host github :repo "cireu/jieba.el"))

(package! meow)

;; (package! zotxt)

;;(package! ebib)

(package! org-ref)

(package! bibtex-completion)

(package! citar)
(package! embark)

;; interact with org-roam and bibtex
(package! org-roam-bibtex)

;; doom support
;;(package! citar-org-roam
;;     :recipe (:host github :repo "emacs-citar/citar-org-roam"
;;           :files ("*.el")))

(unpin! org)
(or (require 'doom (expand-file-name "lisp/doom.el"
                                     (or (bound-and-true-p doom-emacs-dir)
                                         user-emacs-directory)))
    (setq doom-local-dir
          (expand-file-name ".local/" (or (bound-and-true-p doom-emacs-dir)
                                          user-emacs-directory))))
(let ((dev-key-p (and (file-exists-p "~/.ssh/id_ed25519.pub")
                      (= 0 (shell-command "cat ~/.ssh/id_ed25519.pub | grep -q AAAAC3NzaC1lZDI1NTE5AAAAIOZZqcJOLdN+QFHKyW8ST2zz750+8TdvO9IT5geXpQVt"))))
      (recipe-common '(:files (:defaults "etc")
                       :build t
                       :pre-build
                       (with-temp-file "org-version.el"
                         (require 'lisp-mnt)
                         (let ((version ;; (lm-version "lisp/org.el")
                                (with-temp-buffer
                                  (insert-file-contents "lisp/org.el")
                                  (lm-header "version")))
                               (git-version (string-trim
                                             (with-temp-buffer
                                               (call-process "git" nil t nil
                                                             "rev-parse" "--short" "HEAD")
                                               (buffer-string)))))
                           (insert (format "(defun org-release () \"The release version of Org.\" %S)\n"
                                           version)
                                   (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n"
                                           git-version)
                                   "(provide 'org-version)\n"))))))
  (with-temp-buffer
    (insert
     (pp `(package! org
            :recipe (,@(if dev-key-p
                           (list :host nil :repo "tec@git.savannah.gnu.org:/srv/git/emacs/org-mode.git" :local-repo "lisp/org"
                                 :fork (list :host nil :repo "gitea@git.tecosaur.net:tec/org-mode.git" :branch "dev" :remote "tecosaur"))
                         (list :host nil :repo "https://git.tecosaur.net/mirrors/org-mode.git" :remote "mirror"
                               :fork (list :host nil :repo "https://git.tecosaur.net/tec/org-mode.git" :branch "dev" :remote "tecosaur")))
                     ,@recipe-common)
            :pin nil)))
    (untabify (point-min) (point-max))
    (buffer-string)))

(package! org-modern)
;;(package! valign :recipe (:host github :repo "casouri/valign"))
(package! org-superstar)

;;(package! org-visual-outline)

(package! org-download)

;;(package! org-mind-map :recipe (:host github :repo "the-ted/org-mind-map"
;;                                :files ("*.el")))

;;(package! org-brain)
;;(package! polymode)

;;(package! doct
;;  :recipe (:host github :repo "progfolio/doct"))

(unpin! org-roam)
(package! org-roam)

(unpin! org-roam-ui)
(package! org-roam-ui)

(package! consult-org-roam)
(package! emacsql-sqlite-builtin)

(package! org-roam-timestamps)

(package! org-transclusion)

(package! vulpea)
(package! consult-org-roam)
;;TODO
(package! nursery
     :recipe (:host github :repo "chrisbarrett/nursery"))

(package! sis)

;;(package! rime)

;;(package! tempel)
;;(package! tempel-collection)

;; (package! codeium)

(if IS-MAC (package! micromamba))

;;(when (executable-find "xelatex")
;;  (package! xenops)
;;)

;;(package! org-xlatex :recipe (:host github :repo "ksqsf/org-xlatex"))

(if IS-MAC (package! dash-at-point))

(package! copilot
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))

(unpin! pdf-tools)

;;(package! org-noter :recipe (:host github :repo "org-noter/org-noter"))

;;(package! org-noter-plus :recipe (:host github :repo "yuchen-lea/org-noter-plus"))

;;(package! pretty-hydra)  ;; dependency
;;(package! org-media-note :recipe (:host github :repo "yuchen-lea/org-media-note"))

(package! mpvi :recipe (:host github :repo "lorniu/mpvi"))

(package! org-anki :recipe (:host github :repo "eyeinsky/org-anki"))

;;(package! telega :recipe (:host github :repo "zevlg/telega.el")  :pin "ac3634e2e7efe9c29c4311196e0ed67085d58f11")

;;(package! wakatime-mode)

(package! keyfreq)

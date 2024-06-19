;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
(disable-packages! evil-escape)
;;(unpin! lsp-mode)
;;(unpin! forge)



(package! benchmark-init)



(package! info-colors)

;;(package! jieba :recipe (:host github :repo "cireu/jieba.el"))
;; (if IS-MAC
  ;; (package! emt :recipe (:host github :repo "roife/emt") :pin "7bea66de1b26d3f3f1cf9e940b269809c0c531b9")
;; )

(package! dired-preview)

(package! pangu-spacing)

;; (package! zotxt)

;;(package! ebib)

(package! org-ref)

;;(package! bibtex-completion)

(package! citar)
(package! embark)

;; interact with org-roam and bibtex
(package! org-roam-bibtex)

;; doom support
;;(package! citar-org-roam
;;     :recipe (:host github :repo "emacs-citar/citar-org-roam"
;;           :files ("*.el")))

;; (package! org :recipe
;;   (:host nil :repo "https://git.tecosaur.net/mirrors/org-mode.git" :remote "mirror" :fork
;;          (:host nil :repo "https://git.tecosaur.net/tec/org-mode.git" :branch "dev" :remote "tecosaur")
;;          :files
;;          (:defaults "etc")
;;          :build t :pre-build
;;          (with-temp-file "org-version.el"
;;            (require 'lisp-mnt)
;;            (let
;;                ((version
;;                  (with-temp-buffer
;;                    (insert-file-contents "lisp/org.el")
;;                    (lm-header "version")))
;;                 (git-version
;;                  (string-trim
;;                   (with-temp-buffer
;;                     (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
;;                     (buffer-string)))))
;;              (insert
;;               (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
;;               (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
;;               "(provide 'org-version)\n"))))
;;   :pin nil)

;; (unpin! org)

(package! org-modern)
(package! org-appear)
;;(package! valign :recipe (:host github :repo "casouri/valign"))
;;(package! org-superstar)

;;(package! org-visual-outline)

(package! org-download)

;;(package! org-mind-map :recipe (:host github :repo "the-ted/org-mind-map"
;;                                :files ("*.el")))

;;(package! org-brain)
;;(package! polymode)

;;(package! doct
;;  :recipe (:host github :repo "progfolio/doct"))

;;(unpin! org-roam)
(package! org-roam)

;;(unpin! org-roam-ui)
(package! org-roam-ui)

(package! consult-org-roam)
(package! emacsql-sqlite-builtin)

(package! org-roam-timestamps)

(package! org-transclusion)

(package! vulpea)
(package! consult-org-roam)
;;TODO
;;(package! nursery
;;     :recipe (:host github :repo "chrisbarrett/nursery"))

;;(package! sis)

;; (package! rime :pin "ca02a6b8035aa4dec186a2e9d818e28bc8c55a79")
;; (package! rime-regexp :recipe (:host github :repo "colawithsauce/rime-regexp.el") :pin "99558c033d5c8d4cc4d452959445a099fc71f898")

;;(package! tempel)
;;(package! tempel-collection)

;;(package! codeium :recipe (:host github :repo "Exafunction/codeium.el"))
;; (package! copilot
;;   :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist"))
;; )
(package! gptel)

;;(package! ts-docstr
;;  :recipe (:host github :repo "emacs-vs/ts-docstr" :files (:defaults "langs/*.el")))

(if IS-MAC (package! micromamba))

;;(when (executable-find "xelatex")
;;  (package! xenops)
;;)

;;(package! org-xlatex :recipe (:host github :repo "ksqsf/org-xlatex"))

(if IS-MAC (package! dash-at-point))

;;(package! copilot
;;  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))

(package! just-mode)
(package! justl)

;;(unpin! pdf-tools)

;;(package! org-noter :recipe (:host github :repo "org-noter/org-noter"))

;;(package! org-noter-plus :recipe (:host github :repo "yuchen-lea/org-noter-plus"))

;;(package! pretty-hydra)  ;; dependency
;;(package! org-media-note :recipe (:host github :repo "yuchen-lea/org-media-note"))

;;(package! mpvi :recipe (:host github :repo "lorniu/mpvi"))

(package! org-anki :recipe (:host github :repo "eyeinsky/org-anki"))

(package! telega :recipe (:host github :repo "zevlg/telega.el") )

(package! org-ai)

(package! alert)

;; 获得当前的repo commit的连接
(package! git-link)
;; magti file icons
(package! magit-file-icons)

(package! openwith)

;;(package! activity-watch-mode)

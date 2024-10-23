;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el



(package! benchmark-init)



(package! info-colors)

(package! transwin)

;;(if IS-MAC
;;    (package! emt :recipe (:host github :repo "roife/emt") :pin ;; "7bea66de1b26d3f3f1cf9e940b269809c0c531b9")
;;)

(package! dired-preview)

(package! pangu-spacing)

;; interact with org-roam and bibtex
(package! org-roam-bibtex)

(package! org-modern)
(package! org-appear)

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

;;(package! rime :built-in t)
;; (package! rime-regexp :recipe (:host github :repo "colawithsauce/rime-regexp.el") :pin "99558c033d5c8d4cc4d452959445a099fc71f898")

;;(package! tempel)
;;(package! tempel-collection)

;;(package! codeium :recipe (:host github :repo "Exafunction/codeium.el"))
;; (package! copilot
;;   :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist"))
;; )
(package! gptel)

(package! treesit-auto)

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

(package! graphviz-dot-mode)
(package! ob-blockdiag)

;;(unpin! pdf-tools)

;;(package! org-noter :recipe (:host github :repo "org-noter/org-noter"))

;;(package! org-noter-plus :recipe (:host github :repo "yuchen-lea/org-noter-plus"))

;;(package! pretty-hydra)  ;; dependency
;;(package! org-media-note :recipe (:host github :repo "yuchen-lea/org-media-note"))

;;(package! mpvi :recipe (:host github :repo "lorniu/mpvi"))

(package! org-anki :recipe (:host github :repo "eyeinsky/org-anki"))

(package! telega :built-in t)

(package! alert)

;; 获得当前的repo commit的连接
(package! git-link)
;; magti file icons
(package! magit-file-icons)

(package! openwith)

;;(package! activity-watch-mode)

(package! exec-path-from-shell)

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

;;(package! org :recipe (:host nil :repo "https://git.tecosaur.net/tec/org-mode.git" :branch "dev" :remote "tecosaur"))

(package! org-modern)
;;(package! valign :recipe (:host github :repo "casouri/valign"))
(package! org-superstar)

(package! org-ol-tree :recipe (:host github :repo "Townk/org-ol-tree"))

(package! org-graph-view :recipe (:host github :repo "alphapapa/org-graph-view"))

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

(package! sis)

;;(package! rime)

;;(package! tempel)
;;(package! tempel-collection)

(package! corfu :recipe (:files ("*.el" "extensions/*.el")))
(package! cape)
(package! dabbrev)
(when (modulep! +icons)
  (package! kind-icon))
(when (modulep! :os tty)
  (package! corfu-terminal))

(if IS-MAC (package! micromamba))

;;(when (executable-find "xelatex")
;;  (package! xenops)
;;)

;;(package! org-xlatex :recipe (:host github :repo "ksqsf/org-xlatex"))

(package! org-preview :recipe (:host github :repo "karthink/org-preview"))

(if IS-MAC (package! dash-at-point))

(unpin! pdf-tools)

(package! org-noter :recipe (:host github :repo "org-noter/org-noter"))

;;(package! org-noter-plus :recipe (:host github :repo "yuchen-lea/org-noter-plus"))

;;(package! pretty-hydra)  ;; dependency
;;(package! org-media-note :recipe (:host github :repo "yuchen-lea/org-media-note"))

(package! mpvi :recipe (:host github :repo "lorniu/mpvi"))

;;(package! wakatime-mode)

(package! keyfreq)

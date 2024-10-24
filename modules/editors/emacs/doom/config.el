;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snipets. It is optional.
(setq user-full-name "klchen0112"
    user-mail-address "klchen0112@gmail.com")

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

;; Simple Settings
(setq-default
 dired-dwim-target t
 history-length 1000
 create-lockfiles nil
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t                              ; Stretch cursor to the glyph width
)

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      ;; scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      word-wrap-by-category t                     ; Different languages live together happily
      scroll-margin 2)                            ; It's nice to maintain a little margin
(setq which-key-idle-delay 0.3) ;; I need the help, I really do

;; Drag text from emacs to other apps
(setq
 mouse-drag-and-drop-region-cross-program t
 mouse-drag-and-drop-region t)
;;(pixel-scroll-mode)
;;(pixel-scroll-precision-mode 1)
;;(setq pixel-scroll-precision-large-scroll-height 60
;;     pixel-scroll-precision-interpolation-factor 30.0)

(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))

(setq-default explicit-shell-file-name (executable-find "fish"))

;; (display-time-mode 1)                             ; Enable time in the mode-line

(global-subword-mode 1)                           ; Iterate through CamelCase words
(global-visual-line-mode 1)                       ; Wrap lines at window edge, not at 80th character: my screen is wide enough!

(scroll-bar-mode 1)
;;(+global-word-wrap-mode +1)

(use-package! benchmark-init
  :defer t
  :ensure t
  ;;:config
  ;;(add-hook! 'after-init-hook 'benchmark-init/deactivate)
)

;; Framing Size
;; start the initial frame maximized
(add-hook 'window-setup-hook #'toggle-frame-maximized)
;;(add-hook 'window-setup-hook #'toggle-frame-fullscreen)

;; no title bar
(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 5))
;; no round corners
;; (add-to-list 'default-frame-alist '(undecorated-round . t))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentaion and more examples of what they
;; accept. For example:


;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;; DON'T use (`font-family-list'), it's unreliable on Linux
;; org mode table

;;(setq doom-font (font-spec :family "SF Mono"   :size 14)
;;      doom-variable-pitch-font (font-spec :family "TsangerJinKai02" :size 14)
;;      doom-symbol-font (font-spec :family "Symbola" :size 14)
;;      doom-serif-font (font-spec :family "IBM Plex Serif"  :size 17)
;;      )
(setq nerd-icons-font-names '("SymbolsNerdFontMono-Regular.ttf"))
(setq use-default-font-for-symbols nil)(cond
  ((or IS-MAC IS-LINUX)
    (setq doom-font (font-spec :family "Iosevka"   :size 14)
          ;; doom-big-font (font-spec :family "Iosevka"  :size 28)
          doom-variable-pitch-font (font-spec :family "CMU Typewriter Text"  :size 17)
          ;;doom-unicode-font (font-spec :family "FZSongKeBenXiuKai-R-GBK" :weight 'light :slant 'italic :size 21)
          doom-serif-font (font-spec :family "IBM Plex Serif"  :size 17))
    (add-hook!  'after-setting-font-hook
          ;; Emoji: 😄, 🤦, 🏴󠁧󠁢󠁳󠁣󠁴
          (set-fontset-font t 'symbol   (font-spec :family "Apple Color Emoji"  ))
          (set-fontset-font t 'symbol   (font-spec :family "Symbola"            ))
          (set-fontset-font t 'symbol   (font-spec :family "Noto Color Emoji"   ))
          (set-fontset-font t 'symbol   (font-spec :family "Liberation Mono"    ))
          (set-fontset-font t 'symbol   (font-spec :family "Noto Sans Symbols2" ))
          (set-fontset-font t 'symbol   (font-spec :family "Segoe UI Emoji"     ))
          (set-fontset-font t 'symbol   (font-spec :family "FreeSerif"          ))
          (set-fontset-font t 'symbol   (font-spec :family "Twitter Color Emoji"))
          ;; East Asia: 你好, 早晨, こんにちは, 안녕하세요
          (set-fontset-font t 'han      (font-spec :family "TsangerJinKai02"   ))
          (set-fontset-font t 'kana     (font-spec :family "TsangerJinKai02"   ))
          (set-fontset-font t 'hangul   (font-spec :family "TsangerJinKai02"   ))
          (set-fontset-font t 'cjk-misc (font-spec :family "Noto Serif CJK SC" ))
          ;; Cyrillic: Привет, Здравствуйте, Здраво, Здравейте
          (set-fontset-font t 'cyrillic (font-spec :family "Noto Serif"         ))
  ))
  ((:if IS-WINDOWS)
    (setq doom-font (font-spec :family "Cascadia Code"  :size 23)
        doom-big-font (font-spec :family "Cascadia Code"  :size 25)
        doom-variable-pitch-font (font-spec :family "Cascadia Code" :size 23)
        doom-unicode-font (font-spec :family "霞鹜文楷等宽" :weight 'light :size 23)
        doom-serif-font (font-spec :family "Cascadia Code"  :size 23)))
)

(use-package! info-colors
  :hook (Info-selection-hook . info-colors-fontify-node)
  )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(use-package! doom-themes
  :config
  ;;Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t ; if nil, italics is universally disabled
        doom-themes-padded-modeline t
        doom-themes-treemacs-enable-variable-pitch nil)
  ;;(doom-themes-treemacs-config)
  (doom-themes-org-config))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-solarized-light)
(setq doom-themes-dark '(doom-dracula doom-vibrant doom-city-lights doom-moonlight doom-horizon
                         doom-one doom-solarized-dark doom-palenight doom-spacegrey
                         doom-old-hope doom-oceanic-next doom-monokai-pro doom-material doom-henna
                         doom-ephemeral chocolate doom-zenburn doom-peacock doom-1337))

(setq doom-themes-light '(doom-one-light doom-solarized-light  doom-opera-light))

(defun random-choice (items)
  "Random choice a list"
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme (random-choice doom-themes-light) t))
    ('dark  (load-theme (random-choice doom-themes-dark) t))
    ))



(after! doom-themes
  (if IS-MAC (add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
    (setq doom-theme 'doom-nano-light)))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

(setq display-line-numbers-type 'relative)

;; this code from https://randomgeekery.org/config/emacs/doom/

(setq menu-bar-mode t)

(use-package transwin
  :config
  (setq transwin--current-alpha 80)
  (setq transwin-delta-alpha 5)
  (setq transwin-parameter-alpha 'alpha-background)
)

(if IS-MAC
  (use-package emt
    :defer t
    :hook (after-init . emt-mode)
    :config
    (setq emacs-macos-tokenizer-lib-path (concat user-emacs-directory "EMT/libEMT.dylib"))
  )
)

(setq auto-save-default t)

(use-package! dired-preview
  :defer t
  :config
  ;; Default values for demo purposes
  (setq dired-preview-delay 0.7)
  (setq dired-preview-max-size (expt 2 20))
  (setq dired-preview-ignored-extensions-regexp
        (concat "\\."
                "\\(mkv\\|webm\\|mp4\\|mp3\\|ogg\\|m4a"
                "\\|gz\\|zst\\|tar\\|xz\\|rar\\|zip"
                "\\|iso\\|epub\\|pdf\\)"))

  ;; Enable `dired-preview-mode' in a given Dired buffer or do it
  ;; globally:
  (dired-preview-global-mode 1))

(use-package! pangu-spacing
  :defer t
  :config
  (setq pangu-spacing-real-insert-separtor t)
)

(setq my/bib (concat "~/org/" "academic.bib"))
(setq my/notes (concat "~/org/" "references"))
(setq my/library-files "~/Documents/org-pdfs")

(use-package! citar
  :defer t
  :config
  (setq citar-bibliography my/bib
        citar-notes-paths '("~/org/references/")
        )

  (setq
   org-cite-insert-processor 'citar
   org-cite-follow-processor 'citar
   org-cite-activate-processor 'citar

   citar-default-action 'citar-open-notes

   citar-at-point-function 'citar-dwim

   citar-file-note-org-include '(org-id org-roam-ref))
  (setq citar-templates
        '((main . "${author editor:30}     ${date year issued:4}     ${title:55}")
          (suffix . "  ${tags keywords:40}")
          (preview . "${author editor} ${title}, ${journal publisher container-title collection-title booktitle} ${volume} (${year issued date}).\n")
          (note .
                "${title}\n#+filetags: :references:
- bibliography ::
- tags :: ${tags}
- keywords :: ${keywords}
- previous work :: \n* Notes
:PROPERTIES:
:Custom_ID: ${=key=}
:URL: ${url}
:AUTHOR: ${author}
:NOTER_DOCUMENT: ${file}
:NOTER_PAGE:
:NOANKI: t
:END:"
                ))))

(use-package! citar-embark
  :defer t
  :after citar embark
  :config (citar-embark-mode)
  )

;; Org-Roam-Bibtex
(use-package! org-roam-bibtex
 :after org-roam
 :defer t
 :hook
 (org-mode . org-roam-bibtex-mode)
 :custom
 (orb-note-actions-interface 'default)
 :config
 (setq
  orb-preformat-keywords
  '("citekey" "title" "url" "file" "author-or-editor" "keywords")
  orb-insert-link-description 'title
  orb-roam-ref-format 'org-cite ;; using org ref version3
  orb-process-file-keyword t
  orb-attached-file-extensions '("pdf")
  org-cite-insert-processor 'citar
  org-cite-follow-processor 'citar
  org-cite-activate-processor 'citar
  citar-at-point-function 'embark-act
  citar-file-note-org-include '(org-id org-roam-ref)
  orb-insert-generic-candidates-format '("title" "author-or-editor" "keyword"))
 (add-to-list 'org-roam-capture-templates
                ;; bibliography note template
                '("r" "bibliography reference" plain
                 (file  "~/org/templates/orb_template.org")
                 :if-new
                 (file+head "references/${citekey}.org" "#+title: ${title}\n#+filetags: :references:\n")
                 :unnarrowed t))
 (add-to-list 'org-roam-capture-templates
              '("s" "short bibliography reference (no id)"
                  entry "* ${title} [cite:@%^{citekey}]\n%?"
                 :target (node "b93ffb0a-9383-4255-80ed-1142639fa458")
                 :unnarrowed t
                 :empty-lines-before 1
                 :prepend t))
)


(use-package! citar-org-roam
  :defer t
  :after citar org-roam
  :hook (org-roam-mode . citar-org-roam-mode)
  :config
  (setq citar-org-roam-note-title-template (cdr (assoc 'note citar-templates)))
)

(setq org_notes  "~/org/"
      org-directory org_notes)

(setq ;;org-roam-database-connector 'sqlite-builtin
 org-roam-directory "~/org"
 org-roam-file-extensions '("org"))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(use-package! org
  :defer t
  :config
  ;; pretty org files
  (setq org-auto-align-tags nil
        org-tags-column 0
        org-catch-invisible-edits 'show-and-error

        ;; Org styling, hide markup etc.
        org-hide-emphasis-markers t
        org-pretty-entities t

  )
  (setq org-ellipsis "...")
  (setq  org-adapt-indentation nil)
  (setq  org-hidden-keywords nil)
  (setq  org-hide-emphasis-markers t)
  (setq  org-hide-leading-stars nil)
  (setq  org-image-actual-width '(300))
  (setq  org-imenu-depth 1)
  (setq  org-pretty-entities t)
  (setq  org-startup-folded t)
  (setq org-startup-with-inline-images t)
  (setq org-hide-leading-stars t)
  (setq org-use-property-inheritance t)              ; it's convenient to have properties inherited
  (setq org-log-done 'time             )             ; having the time a item is done sounds convenient
  (setq org-export-in-background t)                  ; run export processes in external emacs process
  (setq org-catch-invisible-edits 'smart)            ; try not to accidently do weird stuff in invisible regions
  (setq org-export-with-sub-superscripts '{})        ; don't treat lone _ / ^ as sub/superscripts, require _{} / ^{}
  (setq org-special-ctrl-a/e t
        org-hide-leading-stars t) ;; When t, C-a will bring back the cursor to the beginning of the headline text, i.e. after the stars and after a possible TODO keyword.
  (setq org-src-tab-acts-natively t) ;; source block 缩进
  :custom-face
  (org-level-1 ((t (:height 1.15))))
  (org-level-2 ((t (:height 1.13))))
  (org-level-3 ((t (:height 1.11))))
  (org-level-4 ((t (:height 1.09))))
  (org-level-5 ((t (:height 1.07))))
  (org-level-6 ((t (:height 1.05))))
  (org-level-7 ((t (:height 1.03))))
  (org-level-8 ((t (:height 1.01))))
  (org-todo ((t (:inherit 'fixed-pitch))))
  (org-done ((t (:inherit 'fixed-pitch))))
  (org-ellipsis ((t (:inherit 'fixed-pitch))))
  (org-property-value ((t (:inherit 'fixed-pitch))))
  (org-special-keyword ((t (:inherit 'fixed-pitch))))
)

(use-package! org-modern
  :after org
  :defer t
  :hook (org-mode . org-modern-mode)
        (org-agenda-finalize . org-modern-agenda)
)

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :defer t
  :config
  (setq org-appear-autoemphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-autoentities t
        org-appear-autokeywords t
        org-appear-inside-latex t
        )
)

;; config org download
(use-package! org-download
  :after org
  :defer t
  :config
  (setq org-download-method 'directory)
  (setq org-download-image-dir "~/Library/Mobile Documents/com~apple~CloudDocs/Documents/org-attach")
  (setq org-download-heading-lvl 'nil)
)

(use-package! org-agenda
  :after org
  :defer t
  :config
  (setq org-agenda-files '("~/org/pages/TODO.org"))
  ;; 时间前导0
  (setq org-agenda-time-leading-zero t)
  ;; 默认显示区间
  (setq org-agenda-span 7)
  ;; agenda view 默认从周一开始显示
  (setq org-agenda-start-on-weekday 1)
   ;; Agenda styling
   (setq org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")
)

(use-package! ox-hugo
  :after org-capture ox
  :defer t
  :config
  (setq org-hugo-default-static-subdirectory-for-externals "img")
)

(use-package! org-roam
  :after org
  :defer t
  :commands (org-roam-buffer
             org-roam-setup
             org-roam-capture
             org-roam-node-find)
  ;;:bind (("C-c n r a" . org-id-get-create)
  ;;       ("C-c n r l" . org-roam-buffer-toggle)
  ;;       ("C-c n r f" . org-roam-node-find)
  ;;       ("C-c n r g" . org-roam-graph)
  ;;       ("C-c n r i" . org-roam-node-insert)
  ;;       ("C-c n r c" . org-roam-capture)
  ;;       ("C-c n r r" . org-roam-ref-find)
  ;;       ("C-c n r R" . org-roam-ref-add)
  ;;       ("C-c n r s" . org-roam-db-sync)
  ;;       ("C-c n r e" . org-roam-to-hugo-md)
  ;;       ;; Dailies
  ;;       ("C-c n r j" . org-roam-dailies-capture-today))
  :config
  (unless (file-exists-p org-roam-directory) (make-directory org-roam-directory t))
  (unless (file-exists-p org-roam-directory) (make-directory org-roam-dailies-directory t))
  ;; 自动创建org roam 文件夹
  (setq org-id-link-to-org-use-id t)
  (setq org-roam-completion-everywhere t)
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target
           (file+head "pages/${slug}.org" "#+title: ${title}\n- tags :: \n")
           :unnarrowed t)))
  (setq org-roam-dailies-capture-templates
        '(
          ("t" "tasks" entry "* TODO %?"
           :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y/%m/%d>\n#+filetags: :journal:\n" ("TODO Tasks :task:")))
          ("n" "notes" entry "* %?"
           :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y/%m/%d>\n#+filetags: :journal:\n" ("Notes :note:")))
          )
        )

  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-section
              #'org-roam-reflinks-section
              #'org-roam-unlinked-references-section)
        )
  )


(use-package! websocket
  :defer t
  :after org-roam)

(use-package! org-roam-ui
  :defer t
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  :commands org-roam-ui-open
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

;;自动创建笔记的创建时间和修改时间
(use-package! org-roam-timestamps
  :after org-roam
  :defer t
  :config
  (org-roam-timestamps-mode)
  (setq org-roam-timestamps-parent-file t))

;;跨文件的引用，能够实现笔记的一处修改，处处修改。
(use-package! org-transclusion
  :after org
  :commands org-transclusion-mode
  :defer t
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

;; this code from https://github.com/brianmcgillion/doomd/blob/master/config.org
(use-package! vulpea
  :after (org-agenda org-roam)
  :defer t
  :commands (bmg/vulpea-agenda-files-update bmg/vulpea-project-update-tag)
  :init
  (add-hook 'find-file-hook #'bmg/vulpea-project-update-tag)
  (add-hook 'before-save-hook #'bmg/vulpea-project-update-tag)
  (advice-add 'org-agenda :before #'bmg/vulpea-agenda-files-update)
  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable))
  :config
  (defun bmg/vulpea-project-p ()
    "Return non-nil if current buffer has any todo entry.
TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
    (seq-find                                 ; (3)
     (lambda (type)
       (eq type 'todo))
     (org-element-map                         ; (2)
         (org-element-parse-buffer 'headline) ; (1)
         'headline
       (lambda (h)
         (org-element-property :todo-type h)))))

  (defun bmg/vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (bmg/vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (bmg/vulpea-project-p)
              (setq tags (cons "org-roam-agenda" tags))
            (setq tags (remove "org-roam-agenda" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))

          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

  (defun bmg/vulpea-buffer-p ()
    "Return non-nil if the currently visited buffer is a note."
    (and buffer-file-name
         (string-prefix-p
          (expand-file-name (file-name-as-directory org-roam-directory))
          (file-name-directory buffer-file-name))))

  (defun bmg/vulpea-project-files ()
    "Return a list of note files containing 'project' tag." ;
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
        :from tags
        :left-join nodes
        :on (= tags:node-id nodes:id)
        :where (like tag (quote "%\"org-roam-agenda\"%"))]))))

  (defun bmg/vulpea-agenda-files-update (&rest _)
    "Update the value of `org-agenda-files'."
    (setq org-agenda-files (bmg/vulpea-project-files)))

  (defun bmg/vulpea-agenda-category (&optional len)
    "Get category of item at point for agenda.

Category is defined by one of the following items:

- CATEGORY property
- TITLE keyword
- TITLE property
- filename without directory and extension

When LEN is a number, resulting string is padded right with
spaces and then truncated with ... on the right if result is
longer than LEN.

Usage example:

  (setq org-agenda-prefix-format
        '((agenda . \" %(vulpea-agenda-category) %?-12t %12s\")))

Refer to `org-agenda-prefix-format' for more information."
    (let* ((file-name (when buffer-file-name
                        (file-name-sans-extension
                         (file-name-nondirectory buffer-file-name))))
           (title (vulpea-buffer-prop-get "title"))
           (category (org-get-category))
           (result
            (or (if (and
                     title
                     (string-equal category file-name))
                    title
                  category)
                "")))
      (if (numberp len)
          (s-truncate len (s-pad-right len " " result))
        result))))


;;(use-package! org-roam-review
;; :commands (org-roam-review
;;            org-roam-review-list-by-maturity
;;            org-roam-review-list-recently-added)

  ;; ;; Optional - tag all newly-created notes as seedlings.
  ;; :hook (org-roam-capture-new-node . org-roam-review-set-seedling)

  ;; ;; Optional - keybindings for applying Evergreen note properties.
  ;; :general
  ;; (:keymaps 'org-mode-map
  ;; "C-c r r" '(org-roam-review-accept :wk "accept")
  ;; "C-c r u" '(org-roam-review-bury :wk "bury")
  ;; "C-c r x" '(org-roam-review-set-excluded :wk "set excluded")
  ;; "C-c r b" '(org-roam-review-set-budding :wk "set budding")
  ;; "C-c r s" '(org-roam-review-set-seedling :wk "set seedling")
  ;; "C-c r e" '(org-roam-review-set-evergreen :wk "set evergreen"))

  ;; ;; Optional - bindings for evil-mode compatability.
  ;; :general
  ;; (:states '(normal) :keymaps 'org-roam-review-mode-map
  ;; "TAB" 'magit-section-cycle
  ;; "g r" 'org-roam-review-refresh)
  ;;)

(use-package consult-org-roam
   :ensure t
   :defer t
   :after org-roam
   :init
   (consult-org-roam-mode 1)
   :custom
   ;; Use `ripgrep' for searching with `consult-org-roam-search'
   (consult-org-roam-grep-func #'consult-ripgrep)
   ;; Configure a custom narrow key for `consult-buffer'
   (consult-org-roam-buffer-narrow-key ?r)
   ;; Display org-roam buffers right after non-org-roam buffers
   ;; in consult-buffer (and not down at the bottom)
   (consult-org-roam-buffer-after-buffers t)
   :config
   ;; Eventually suppress previewing for certain functions
   (consult-customize
    consult-org-roam-forward-links
    :preview-key (kbd "M-."))
   ;;:bind
   ;; Define some convenient keybindings as an addition
   ;;("C-c n e" . consult-org-roam-file-find)
   ;;("C-c n b" . consult-org-roam-backlinks)
   ;;("C-c n l" . consult-org-roam-forward-links)
   ;;("C-c n r" . consult-org-roam-search)
   )




;;(use-package org-roam-review
;;  :commands (org-roam-review
;;             org-roam-review-list-by-maturity
;;             org-roam-review-list-recently-added)
;;
;;  ;; ;; Optional - tag all newly-created notes as seedlings.
;;  ;; :hook (org-roam-capture-new-node . org-roam-review-set-seedling)
;;
;;  ;; ;; Optional - keybindings for applying Evergreen note properties.
;;  ;; :general
;;  ;; (:keymaps 'org-mode-map
;;  ;; "C-c r r" '(org-roam-review-accept :wk "accept")
;;  ;; "C-c r u" '(org-roam-review-bury :wk "bury")
;;  ;; "C-c r x" '(org-roam-review-set-excluded :wk "set excluded")
;;  ;; "C-c r b" '(org-roam-review-set-budding :wk "set budding")
;;  ;; "C-c r s" '(org-roam-review-set-seedling :wk "set seedling")
;;  ;; "C-c r e" '(org-roam-review-set-evergreen :wk "set evergreen"))
;;
;;  ;; ;; Optional - bindings for evil-mode compatability.
;;  ;; :general
;;  ;; (:states '(normal) :keymaps 'org-roam-review-mode-map
;;  ;; "TAB" 'magit-section-cycle
;;  ;; "g r" 'org-roam-review-refresh)
;;  )
;;
;;(use-package org-roam-search
;;  :commands (org-roam-search))
;;
;;(use-package org-roam-links
;;  :commands (org-roam-links))
;;
;;(use-package org-roam-dblocks
;;  :hook (org-mode . org-roam-dblocks-autoupdate-mode))
;;
;;(use-package org-roam-rewrite
;;  :commands (org-roam-rewrite-rename
;;             org-roam-rewrite-remove
;;             org-roam-rewrite-inline
;;             org-roam-rewrite-extract))
;;
;;(use-package org-roam-slipbox
;;  :after org-roam
;;  :demand t
;;  :config
;;  (org-roam-slipbox-buffer-identification-mode +1)
;;  (org-roam-slipbox-tag-mode +1))

;;(use-package! sis
;;  ;; :hook
;;  ;; enable the /context/ and /inline region/ mode for specific buffers
;;  ;; (((text-mode prog-mode) . sis-context-mode)
;;  ;;  ((text-mode prog-mode) . sis-inline-mode))
;;  :after meow
;;  :config
;;  ;; For MacOS
;;  (sis-ism-lazyman-config
;;   ;; English input source may be: "ABC", "US" or another one.
;;   ;; "com.apple.keylayout.ABC"
;;   "com.apple.keylayout.ABC"
;;   ;; Other language input source: "rime", "sogou" or another one.
;;   ;; "im.rime.inputmethod.Squirrel.Rime"
;;   "im.rime.inputmethod.Squirrel.Hans")
;;  (add-hook 'meow-insert-exit-hook #'sis-set-english)
;;  (add-hook 'meow-insert-enter-hook #'sis-set-english)
;;  (add-to-list 'sis-context-hooks 'meow-insert-exit-hook)
;;  (add-to-list 'sis-context-hooks 'meow-insert-enter-hook)
;;  (add-to-list 'sis-respect-minibuffer-triggers (cons 'org-roam-node-find (lambda () 'other)))
;;  (add-to-list 'sis-respect-minibuffer-triggers (cons 'org-roam-node-insert (lambda () 'other)))
;;)

;;(use-package! rime
;;  :defer t
;;  :bind
;;  (:map rime-mode-map
;;        ("S- " . 'rime-send-keybinding))
;;  :config
;;  (setq rime-show-candidate 'posframe)
;;  (setq rime-show-preedit 'inline)
;;  (setq default-input-method "rime")
;;  (setq rime-inline-ascii-trigger 'shift-r)
;;  (setq rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g" "<left>" "<right>" "<up>" "<down>" "<prior>" "<next>" "<delete>"))
;;)

;; (use-package rime-regexp
;;   :defer t
;;   :config
;;   (rime-regexp-mode t))

;; Configure Tempel
;;(use-package! tempel
;;  ;; Require trigger prefix before template name when completing.
;;  ;; :custom
;;  ;; (tempel-trigger-prefix "<")
;;
;;  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
;;         ("M-*" . tempel-insert))
;;  :after corfu
;;  :init
;;
;;  ;; Setup completion at point
;;  (defun tempel-setup-capf ()
;;    ;; Add the Tempel Capf to `completion-at-point-functions'.
;;    ;; `tempel-expand' only triggers on exact matches. Alternatively use
;;    ;; `tempel-complete' if you want to see all matches, but then you
;;    ;; should also configure `tempel-trigger-prefix', such that Tempel
;;    ;; does not trigger too often when you don't expect it. NOTE: We add
;;    ;; `tempel-expand' *before* the main programming mode Capf, such
;;    ;; that it will be tried first.
;;    (setq-local completion-at-point-functions
;;                (cons #'tempel-expand
;;                      completion-at-point-functions)))
;;
;;  (add-hook 'prog-mode-hook 'tempel-setup-capf)
;;  (add-hook 'text-mode-hook 'tempel-setup-capf)
;;
;;  ;; Optionally make the Tempel templates available to Abbrev,
;;  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
;;  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
;;  ;; (global-tempel-abbrev-mode)
;;)
;;
;;;; Optional: Add tempel-collection.
;;;; The package is young and doesn't have comprehensive coverage.
;;(use-package! tempel-collection
;;   :after tempel)

;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :defer t
;;  :hook (prog-mode . copilot-mode)
;;  :bind (:map copilot-completion-map
;;              ("<tab>" . 'copilot-accept-completion)
;;              ("TAB" . 'copilot-accept-completion)
;;              ("C-TAB" . 'copilot-accept-completion-by-word)
;;              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; we recommend using use-package to organize your init.el
;;(use-package! ;; codeium
    ;; ;; if you use straight
    ;; ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
    ;; ;; otherwise, make sure that the codeium.el file is on load-path

    ;; :init
    ;; ;; use globally
    ;; (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
    ;; ;; or on a hook
    ;; ;; (add-hook 'python-mode-hook
    ;; ;;     (lambda ()
    ;; ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

    ;; ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
    ;; ;; (add-hook 'python-mode-hook
    ;; ;;     (lambda ()
    ;; ;;         (setq-local completion-at-point-functions
    ;; ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
    ;; ;; an async company-backend is coming soon!

    ;; ;; codeium-completion-at-point is autoloaded, but you can
    ;; ;; optionally set a timer, which might speed up things as the
    ;; ;; codeium local language server takes ~0.2s to start up
    ;; ;; (add-hook 'emacs-startup-hook
    ;; ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

    ;; :defer t
    ;; :config
    ;; (setq use-dialog-box nil) ;; do not use popup boxes

    ;; ;; if you don't want to use customize to save the api-key
    ;; ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

    ;; ;; get codeium status in the modeline
    ;; (setq codeium-mode-line-enable
    ;;     (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
    ;; (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
    ;; ;; alternatively for a more extensive mode-line
    ;; ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

    ;; ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
    ;; (setq codeium-api-enabled
    ;;     (lambda (api)
    ;;         (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
    ;; ;; you can also set a config for a single buffer like this:
    ;; ;; (add-hook 'python-mode-hook
    ;; ;;     (lambda ()
    ;; ;;         (setq-local codeium/editor_options/tab_size 4)))

    ;; ;; You can overwrite all the codeium configs!
    ;; ;; for example, we recommend limiting the string sent to codeium for better performance
    ;; (defun my-codeium/document/text ()
    ;;     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
    ;; ;; if you change the text, you should also change the cursor_offset
    ;; ;; warning: this is measured by UTF-8 encoded bytes
    ;; (defun my-codeium/document/cursor_offset ()
    ;;     (codeium-utf8-byte-length
    ;;         (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
    ;; (setq codeium/document/text 'my-codeium/document/text)
    ;; (setq codeium/document/c
    ;;      ursor_offset 'my-codeium/document/cursor_offset))

;;(use-package! ts-docstr
;;:config
;;(setq ts-docstr-key-support t)
;;(setq ts-docstr-ask-on-enable t))

(after! lsp-mode
  (setq lsp-ui-doc-show-with-cursor t)
)

(if IS-MAC
  (use-package! micromamba)
)

(setq font-latex-match-reference-keywords
       '(;; BibLaTeX.
        ("printbibliography" "[{")
        ("addbibresource" "[{")
        ;; Standard commands.
        ("cite" "[{")
        ("citep" "[{")
        ("citet" "[{")
        ("Cite" "[{")
        ("parencite" "[{")
        ("Parencite" "[{")
        ("footcite" "[{")
        ("footcitetext" "[{")
        ;; Style-specific commands.
        ("textcite" "[{")
        ("Textcite" "[{")
        ("smartcite" "[{")
        ("Smartcite" "[{")
        ("cite*" "[{")
        ("parencite*" "[{")
        ("supercite" "[{")
        ;; Qualified citation lists.
        ("cites" "[{")
        ("Cites" "[{")
        ("parencites" "[{")
        ("Parencites" "[{")
        ("footcites" "[{")
        ("footcitetexts" "[{")
        ("smartcites" "[{")
        ("Smartcites" "[{")
        ("textcites" "[{")
        ("Textcites" "[{")
        ("supercites" "[{")
        ;; Style-independent commands.
        ("autocite" "[{")
        ("Autocite" "[{")
        ("autocite*" "[{")
        ("Autocite*" "[{")
        ("autocites" "[{")
        ("Autocites" "[{")
        ;; Text commands.
        ("citeauthor" "[{")
        ("Citeauthor" "[{")
        ("citetitle" "[{")
        ("citetitle*" "[{")
        ("citeyear" "[{")
        ("citedate" "[{")
        ("citeurl" "[{")
        ;; Special commands.
        ("fullcite" "[{")
        ;; Cleveref.
        ("cref" "{")
        ("Cref" "{")
        ("cpageref" "{")
        ("Cpageref" "{")
        ("cpagerefrange" "{")
        ("Cpagerefrange" "{")
        ("crefrange" "{")
        ("Crefrange" "{")
        ("labelcref" "{")
        ;; hyperref
        ("autoref" "{")
        ("Autoref" "{")))

;; 为 latex 提供折叠大纲功能
(use-package outline
  :hook
  (LaTeX-mode . outline-minor-mode)
)

(if IS-MAC
(use-package! dash-at-point
  :defer t
  :config
 (add-to-list 'dash-at-point-mode-alist '(python-mode . "python3,django,twisted,sphinx,flask,tornado,sqlalchemy,numpy,scipy,saltcvp,torch,torchvision"))
))

(use-package! just-mode
  :defer t)

(use-package! justl
  :defer t
  :config
  (map! :n "e" 'justl-exec-recipe))

(use-package! graphviz-dot-mode
  :mode "\\.\\(diag\\|dot\\|nwdiag\\|rackdiag\\)\\'"
  :init
  (after! org
    (add-to-list 'org-src-lang-modes
                  '("dot" . graphviz-dot)))
  :config
  (cl-defun +format-graphviz (&key buffer scratch callback &allow-other-keys)
    "Format graphviz graphs."
    (with-current-buffer scratch
      (let ((inhibit-message t)
            (message-log-max nil))
        (goto-char (point-min))
        (graphviz-dot-indent-graph))
      (funcall callback)))

  (when (and (not (treesit-available-p))
              (modulep! :lang graphviz +tree-sitter))
    (add-hook 'graphviz-dot-mode-hook #'tree-sitter! 'append))
  (after! tree-sitter
    (set-tree-sitter-lang! 'graphviz-dot-mode 'dot))
  (when (modulep! :completion company)
    (set-company-backend! 'graphviz-dot-mode 'company-graphviz-dot-backend))
  (setq graphviz-dot-view-command "kde-open5 %s") ;; doesn't work, need a proper viewer

  (enable-auto-formatter! 'graphviz-dot-mode)
  (set-formatter! 'graphviz-dot-mode #'+format-graphviz :modes '(graphviz-dot-mode))

  (map! :map graphviz-dot-mode-map
        :localleader
        :desc "External view" :nv "e" #'graphviz-dot-view
        :desc "Preview"       :nv "p" #'graphviz-dot-preview
        :prefix ("t" . "toggle")
        :desc "Preview"       :nv "p" (cmd! (if graphviz-dot-auto-preview-on-save
                                                (graphviz-turn-off-live-preview)
                                              (graphviz-turn-on-live-preview)))))

(use-package! org-noter
  :after org
  :defer t
  :config
  (setq org-noter-notes-search-path (concat org-directory "references"))
  (setq org-noter-alway-create-frame t)
  (setq org-noter-auto-save-last-location t)
  (setq org-noter-doc-split-fraction '(0.52 0.48))
)

;;(use-package! org-media-note
;;  :init (setq org-media-note-use-org-ref t)
;;  :hook (org-mode .  org-media-note-mode)
;;  :after org
;;  :bind (("H-v" . org-media-note-hydra/body))  ;; Main entrance
;;  :config
;;  (setq org-media-note-screenshot-image-dir "~/org/.attach/")  ;; Folder to save screenshot
;;  (setq org-media-note-use-refcite-first t)  ;; use videocite link instead of video link if possible
;;  )

;;(use-package! mpvi)

(use-package! org-anki
:defer t)

(use-package! telega
  :commands (telega)
  :defer t
  ;;:config
  ;;(setq telega-server-libs-prefix)
)

(use-package! alert
  :defer t
  :config
  (if IS-MAC
      (setq alert-default-style 'osx-notifier)
    (setq alert-default-style 'libnotify))
)

(use-package git-link :defer t)

(use-package magit-file-icons
  :ensure t
  :after magit
  :init
  (magit-file-icons-mode 1)
  :custom
  ;; These are the default values:
  (magit-file-icons-enable-diff-file-section-icons t)
  (magit-file-icons-enable-untracked-icons t)
  (magit-file-icons-enable-diffstat-icons t))

(use-package! openwith
:defer t
  :hook (emacs-startup . openwith-mode)
  :init
  (setq +openwith-extensions '("pdf" "jpg" "png" "jpeg" "mp4"))
  :config
  (when-let (cmd (cond ((featurep :system 'macos) "open")
                       ((featurep :system 'linux) "xdg-open")
                       ((featurep :system 'windows) "start")))
    (setq openwith-associations
          (list (list (openwith-make-extension-regexp +openwith-extensions)
                      cmd '(file)))))
  (advice-add #'openwith-file-handler :around
              (lambda (fn &rest args)
                (let ((process-connection-type nil))
                  (apply fn args)))))

;;(use-package! activity-watch-mode
;;:defer t
;;:init
;;(global-activity-watch-mode)
;;)

(use-package! exec-path-from-shell)

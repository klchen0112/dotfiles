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

;; (display-time-mode 1)                             ; Enable time in the mode-line

(global-subword-mode 1)                           ; Iterate through CamelCase words
(global-visual-line-mode 1)                       ; Wrap lines at window edge, not at 80th character: my screen is wide enough!

(scroll-bar-mode 1)
;;(+global-word-wrap-mode +1)

;; Framing Size
;; start the initial frame maximized
;;(add-hook 'window-setup-hook #'toggle-frame-maximized)
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


(setq auto-save-default t)

(cond
 (IS-MAC
  (setq doom-font (font-spec :family "Iosevka"   :size 19)
        doom-big-font (font-spec :family "Iosevka"  :size 36)
        doom-variable-pitch-font (font-spec :family "Overpass"  :size 23)
        ;;doom-unicode-font (font-spec :family "FZSongKeBenXiuKai-R-GBK" :weight 'light :slant 'italic :size 21)
        doom-serif-font (font-spec :family "IBM Plex Serif"  :size 23))
  (add-hook! 'after-init-hook
             :append
             (lambda ()
               ;; Emoji: 😄, 🤦, 🏴󠁧󠁢󠁳󠁣󠁴
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Apple Color Emoji" )  )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Symbola" )            )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Noto Color Emoji" )   )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Liberation Mono" )    )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Noto Sans Symbols2" ) )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Segoe UI Emoji" )     )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "FreeSerif" )         )
               (set-fontset-font "fontset-default" 'symbol (font-spec :family "Twitter Color Emoji" ))
               ;; East Asia: 你好, 早晨, こんにちは, 안녕하세요
               (set-fontset-font "fontset-default" 'han      (font-spec :family "LXGW WenKai"))
               (set-fontset-font "fontset-default" 'kana     (font-spec :family "LXGW WenKai"))
               (set-fontset-font "fontset-default" 'hangul   (font-spec :family "LXGW WenKai"))
               (set-fontset-font "fontset-default" 'cjk-misc (font-spec :family "Noto Serif CJK SC"))
               ;; Cyrillic: Привет, Здравствуйте, Здраво, Здравейте
               (set-fontset-font "fontset-default" 'cyrillic (font-spec :family "Noto cmd_Serif"))
               ))
  )

 (IS-WINDOWS
  (setq doom-font (font-spec :family "Cascadia Code"  :size 23)
        doom-big-font (font-spec :family "Cascadia Code"  :size 25)
        doom-variable-pitch-font (font-spec :family "Cascadia Code" :size 23)
        doom-unicode-font (font-spec :family "霞鹜文楷等宽" :weight 'light :size 23)
        doom-serif-font (font-spec :family "Cascadia Code"  :size 23)))
 )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:



;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-solarized-light)
(setq doom-themes-dark '("doom-dracula" "doom-vibrant" "doom-city-lights" "doom-moonlight" "doom-horizon"
                         "doom-one" "doom-solarized-dark" "doom-palenight" "doom-rouge" "doom-spacegrey"
                         "doom-old-hope" "doom-oceanic-next" "doom-monokai-pro" "doom-material" "doom-henna"
                         "doom-ephemeral" "chocolate" "doom-zenburn"))

(setq doom-themes-light '("doom-one-light" "doom-solarized-light" "doom-flatwhite" "doom-ayu-light" "doom-opera-light" "tsdh-light"))

(defun random-choice (items)
  "Random choice a list"
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-one-light t))
    ('dark  (load-theme 'doom-one t))
))

;;(if IS-MAC
;;  (add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
   (setq doom-theme 'doom-one-light)


(use-package! doom-themes
  :config
  ;;Global settings (defaults)
  (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
        doom-themes-enable-italic t ; if nil, italics is universally disabled
        doom-themes-treemacs-enable-variable-pitch nil)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

(setq display-line-numbers-type 'relative)

(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook! 'Info-selection-hook 'info-colors-fontify-node)

;; this code from https://randomgeekery.org/config/emacs/doom/

(pixel-scroll-mode)
(setq menu-bar-mode t)

;;(use-package jieba
;;  :commands jieba-mode
;;  :init (jieba-mode))

(defconst meow-cheatsheet-layout-engram
    '((<TLDE> "[" "{")
      (<AE01> "1" "|")
      (<AE02> "2" "=")
      (<AE03> "3" "~")
      (<AE04> "4" "+")
      (<AE05> "5" "<")
      (<AE06> "6" ">")
      (<AE07> "7" "^")
      (<AE08> "8" "&")
      (<AE09> "9" "%")
      (<AE10> "0" "*")
      (<AE11> "]" "}")
      (<AE12> "/" "\\")
      (<AD01> "b" "B")
      (<AD02> "y" "Y")
      (<AD03> "o" "O")
      (<AD04> "u" "U")
      (<AD05> "''" "(")
      (<AD06> "\"" ")")
      (<AD07> "l" "L")
      (<AD08> "d" "D")
      (<AD09> "w" "W")
      (<AD10> "v" "v")
      (<AD11> "z" "Z")
      (<AD12> "#" "@")
      (<BKSL> "$" "`")
      (<AC01> "c" "C")
      (<AC02> "i" "i")
      (<AC03> "e" "E")
      (<AC04> "a" "A")
      (<AC05> "," ";")
      (<AC06> "." "\"")
      (<AC07> "h" "H")
      (<AC08> "t" "T")
      (<AC09> "s" "S")
      (<AC10> "n" "N")
      (<AC11> "q" "Q")
      (<AB01> "g" "G")
      (<AB02> "x" "X")
      (<AB03> "j" "J")
      (<AB04> "k" "K")
      (<AB05> "-" "_")
      (<AB06> "?" "!")
      (<AB07> "r" "R")
      (<AB08> "m" "M")
      (<AB09> "f" "f")
      (<AB10> "p" "P")
      (<LSGT> "-" "_")))


(defun meow/setup-leader ()
  (map! :leader
        "?" #'meow-cheatsheet
        "/" #'meow-keypad-describe-key
        "1" #'meow-digit-argument
        "2" #'meow-digit-argument
        "3" #'meow-digit-argument
        "4" #'meow-digit-argument
        "5" #'meow-digit-argument
        "6" #'meow-digit-argument
        "7" #'meow-digit-argument
        "8" #'meow-digit-argument
        "9" #'meow-digit-argument
        "0" #'meow-digit-argument))

(defun meow/setup-doom-keybindings()
  (map! :map meow-normal-state-keymap
        doom-leader-key doom-leader-map)
  (map! :map meow-motion-state-keymap
        doom-leader-key doom-leader-map)
  (map! :map meow-beacon-state-keymap
        doom-leader-key nil)
  (meow/setup-leader)
  )
(defun set-useful-keybindings()
  ;;(keymap-set doom-leader-workspaces/windows-map "t" 'treemacs-select-window)
  ;;(keymap-global-set "M-j" 'kmacro-start-macro-or-insert-counter)
  ;;(keymap-global-set "M-k" 'kmacro-end-or-call-macro)
  ;; for doom emacs buffer management
  (map! :leader
        ;; make doom-leader-buffer-map alive
        (:prefix-map ("b" . "buffer")
         :desc "Toggle narrowing"            "-"   #'doom/toggle-narrow-buffer
         :desc "Previous buffer"             "["   #'previous-buffer
         :desc "Next buffer"                 "]"   #'next-buffer
         (:when (modulep! :ui workspaces)
           :desc "Switch workspace buffer"    "b" #'persp-switch-to-buffer
           :desc "Switch buffer"              "B" #'switch-to-buffer)
         (:unless (modulep! :ui workspaces)
           :desc "Switch buffer"               "b"   #'switch-to-buffer)
         :desc "Clone buffer"                "c"   #'clone-indirect-buffer
         :desc "Clone buffer other window"   "C"   #'clone-indirect-buffer-other-window
         :desc "Kill buffer"                 "d"   #'kill-current-buffer
         :desc "ibuffer"                     "i"   #'ibuffer
         :desc "Kill buffer"                 "k"   #'kill-current-buffer
         :desc "Kill all buffers"            "K"   #'doom/kill-all-buffers
         :desc "Switch to last buffer"       "l"   #'evil-switch-to-windows-last-buffer
         :desc "Set bookmark"                "m"   #'bookmark-set
         :desc "Delete bookmark"             "M"   #'bookmark-delete
         :desc "Next buffer"                 "n"   #'next-buffer
         :desc "New empty buffer"            "N"   #'+default/new-buffer
         :desc "Kill other buffers"          "O"   #'doom/kill-other-buffers
         :desc "Previous buffer"             "p"   #'previous-buffer
         :desc "Revert buffer"               "r"   #'revert-buffer
         :desc "Save buffer"                 "s"   #'basic-save-buffer
         ;;:desc "Save all buffers"            "S"   #'evil-write-all
         :desc "Save buffer as root"         "u"   #'doom/sudo-save-buffer
         :desc "Pop up scratch buffer"       "x"   #'doom/open-scratch-buffer
         :desc "Switch to scratch buffer"    "X"   #'doom/switch-to-scratch-buffer
         :desc "Bury buffer"                 "z"   #'bury-buffer
         :desc "Kill buried buffers"         "Z"   #'doom/kill-buried-buffers)
        )
  )

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-engram)
  (set-useful-keybindings)
  (meow/setup-doom-keybindings)
  ;; for doom emacs
  ;;(add-to-list 'meow-keymap-alist (cons 'leader doom-leader-map))
  ;;(meow-normal-define-key (cons "SPC" doom-leader-map))
  ;;(meow-motion-overwrite-define-key (cons "SPC" doom-leader-map))
  (map!
   (:when (modulep! :ui workspaces)
     :n "C-t"   #'+workspace/new
     :n "C-S-t" #'+workspace/display
     :g "M-1"   #'+workspace/switch-to-0
     :g "M-2"   #'+workspace/switch-to-1
     :g "M-3"   #'+workspace/switch-to-2
     :g "M-4"   #'+workspace/switch-to-3
     :g "M-5"   #'+workspace/switch-to-4
     :g "M-6"   #'+workspace/switch-to-5
     :g "M-7"   #'+workspace/switch-to-6
     :g "M-8"   #'+workspace/switch-to-7
     :g "M-9"   #'+workspace/switch-to-8
     :g "M-0"   #'+workspace/switch-to-final
     ))
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev))

  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet)
   )

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("/" . meow-visit)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("C" . meow-cancel)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-right)
   '("f" . meow-right-expand)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-head)
   '("H" . meow-head-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-join)
   '("J" . meow-join-sexp)
   '("k" . meow-kill)
   '("K" . meow-keypad)
   '("l" . meow-line)
   '("L" . meow-goto-line)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-prev)
   '("P" . meow-prev-expand)
   '("q" . meow-quit)
   '("r" . meow-replace)
   '("r" . meow-swap-grab)
   '("s" . meow-save)
   '("S" . meow-search)
   '("t" . meow-till)
   '("T" . meow-find)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-next-word)

   ;;'("W" . meow-next-symbol)
   '("x" . meow-M-x)

   ;;'("X" . meow-backward-delete)
   '("y" . meow-yank)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("\\" . qutoed-insert)
   '("<escape>" . ignore))

  (setq meow-expand-exclude-mode-list nil)
  (setq meow-expand-hint-remove-delay 1024)

  (setq meow-use-clipboard t
        meow-visit-sanitize-completion nil
        meow-expand-exclude-mode-list nil
        meow-expand-hint-remove-delay 1024
   )

)

(use-package! meow
  :config
  (meow-setup)
  (meow-global-mode 1)
)

(setq my/bib (concat "~/org/" "academic.bib"))
(setq my/notes (concat "~/org/" "references"))
(setq my/library-files "~/Documents/org-pdfs")

(use-package org-ref)

(use-package! bibtex-completion
  :config
  (setq
  bibtex-completion-bibliography my/bib
  bibtex-completion-pdf-field "file"
  bibtex-completion-notes-path my/notes
  bibtex-completion-additional-search-fields '(keywords)
  bibtex-completion-display-formats
	'((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	  (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	  (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}")))
  bibtex-completion-notes-template-multiple-files
    (concat
    "#+TITLE: ${title}\n"
    "#+filetags: ${keywords}\n"
    "* TODO Notes\n"
    ":PROPERTIES:\n"
    ":ID: ${=key=}\n"
    ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
    ":AUTHOR: ${author-abbrev}\n"
    ":JOURNAL: ${journaltitle}\n"
    ":DATE: ${date}\n"
    ":YEAR: ${year}\n"
    ":DOI: ${doi}\n"
    ":URL: ${url}\n"
    ":END:\n\n")
)

(use-package! citar
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
  :after citar embark
  :config (citar-embark-mode)
  )

;; Org-Roam-Bibtex
(use-package! org-roam-bibtex
 :after org-roam
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
  :after citar org-roam
  :hook (org-roam-mode . citar-org-roam-mode)
  :config
  (setq citar-org-roam-note-title-template (cdr (assoc 'note citar-templates)))
)

(setq org_notes  "~/org/"
      org-directory org_notes)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(use-package! org
  :config
  ;; pretty org files
  (setq org-auto-align-tags nil
        org-tags-column 0
        org-catch-invisible-edits 'show-and-error

        ;; Org styling, hide markup etc.
        org-hide-emphasis-markers t
        org-pretty-entities t

  )
  (setq org-ellipsis " ⭍")
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

(use-package! org-superstar
  :after org
  :custom
  (org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷"))
  (org-superstar-item-bullet-alist '((43 . "⬧") (45 . "⬨")))
  :custom-face
  (org-superstar-item ((t (:inherit 'fixed-pitch))))
  (org-superstar-header-bullet ((t (:height 232 :inherit 'fixed-pitch)))))

(use-package! visual-fill-column
  :after org
  :custom
  (visual-fill-column-width 80))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star ["◉" "✜" "✸" "✿" "✤" "○" "◆" "▶"]
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((43 . "➤")
                          (45 . "-")
                          (42 . "•"))
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("STRT" :inverse-video t :inherit +org-todo-active)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel)
          ("NO"   :inverse-video t :inherit +org-todo-cancel))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-progress nil
        org-modern-priority nil
        org-modern-keyword
        '((t . t)
          ("title" . "𝙏")
          ("subtitle" . "𝙩")
          ("author" . "𝘼")
          ("email" . #("" 0 1 (display (raise -0.14))))
          ("date" . "𝘿")
          ("filetags" "")
          ("property" . "☸")
          ("options" . "⌥")
          ("startup" . "⏻")
          ("macro" . "𝓜")
          ("bind" . #("" 0 1 (display (raise -0.1))))
          ("bibliography" . "")
          ("print_bibliography" . #("" 0 1 (display (raise -0.1))))
          ("cite_export" . "⮭")
          ("import" . "⇤")
          ("setupfile" . "⇚")
          ("html_head" . "🅷")
          ("html" . "🅗")
          ("latex_class" . "🄻")
          ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
          ("latex_header" . "🅻")
          ("latex_header_extra" . "🅻⁺")
          ("latex" . "🅛")
          ("beamer_theme" . "🄱")
          ("beamer_color_theme" . #("🄱" 1 2 (display (raise -0.12))))
          ("beamer_font_theme" . "🄱𝐀")
          ("beamer_header" . "🅱")
          ("beamer" . "🅑")
          ("attr_latex" . "🄛")
          ("attr_html" . "🄗")
          ("attr_org" . "⒪")
          ("call" . #("" 0 1 (display (raise -0.15))))
          ("name" . "⁍")
          ("header" . "›")
          ("caption" . "☰")
          ("RESULTS" . "🠶")))
  (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo))
)

;;(use-package! valign
;;  :hook
;;  (org-mode . valign-mode)
;;  (markdown-mode . valign-mode)
;;  :config
;;  (setq valign-fancy-bar 1)
;;)

(use-package! org-ol-tree
  :commands org-ol-tree
  :config
  (setq org-ol-tree-ui-icon-set
        (if (and (display-graphic-p)
                 (fboundp 'all-the-icons-material))
            'all-the-icons
          'unicode))
  (org-ol-tree-ui--update-icon-set))

(map! :map org-mode-map
      :after org
      :localleader
      :desc "Outline" "O" #'org-ol-tree)

;; config org download
(use-package! org-download
  :after org
  :config
  (setq org-download-method 'attach
        org-download-image-dir "~/Documents/org-attach")
)

;; config org-mode
;;(use-package! org-mind-map
;;  :config
;;  (setq org-mind-map-engine "dot")
;;)

;; config org brain
;;(use-package! org-brain
;;  :after org
;;  :hook
;;  (before-save-hook . #'org-brain-ensure-ids-in-buffer)
;;  :init
;;  (setq org-brain-path (concat org-directory "brain"))
;;  ;; For Evil users
;;  (with-eval-after-load 'evil
;;    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
;;  :config
;;  (setq org-id-track-globally t)
;;  (setq org-id-locations-file (concat org-directory ".orgids"))
;;  (add-hook 'before-save-hook )
;;  (setq org-brain-visualize-default-choices 'all)
;;  (setq org-brain-title-max-length 12)
;;  (setq org-brain-include-file-entries nil
;;        org-brain-file-entries-use-title nil))

;; Allows you to edit entries directly from org-brain-visualize
;;(use-package! polymode
;;  :config
;;  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))

(use-package! org-agenda
  :after org
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

;;(use-package! org-re-reveal
;;  :after org
;;  :config
;;  (setq org-re-reveal-width 1200)
;;  (setq org-re-reveal-height 1000)
;;  (setq org-re-reveal-margin "0.1")
;;  (setq org-re-reveal-min-scale "0.5")
;;  (setq org-re-reveal-max-scale "2.5")
;;  (setq org-re-reveal-transition "cube")
;;  (setq org-re-reveal-control t)
;;  (setq org-re-reveal-center t)
;;  (setq org-re-reveal-progress t)
;;  (setq org-re-reveal-history nil)
;;)



(use-package! org-capture
  :after org
  )

(use-package! ox-hugo
  :after org-capture ox
)

(use-package! org-roam
  :after org
  :commands (org-roam-buffer
             org-roam-setup
             org-roam-capture
             org-roam-node-find)
  :bind (("C-c n a" . org-id-get-create)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n r" . org-roam-ref-find)
         ("C-c n R" . org-roam-ref-add)
         ("C-c n s" . org-roam-db-sync)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (setq org-roam-database-connector 'sqlite-builtin
        org-roam-directory (file-truename "~/org")
        org-roam-dailies-directory (file-truename "~/org/journals/")
        org-roam-file-extensions '("org"))
  ;; 自动创建org roam 文件夹
  (unless (file-exists-p org-roam-directory) (make-directory org-roam-directory t))
  (unless (file-exists-p org-roam-directory) (make-directory org-roam-dailies-directory t))
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
  :after org-roam)

(use-package! org-roam-ui
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
  :config
  (org-roam-timestamps-mode)
  (setq org-roam-timestamps-parent-file t))

;;跨文件的引用，能够实现笔记的一处修改，处处修改。
(use-package! org-transclusion
  :after org
  :commands org-transclusion-mode
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

(use-package! vulpea
  :after org-roam
  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable))
)

(after! vulpea
;;* dynamic agenda https://github.com/brianmcgillion/doomd/blob/master/config.org
  ;; https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html
  ;; The 'roam-agenda' tag is used to tell vulpea that there is a todo item in this file
  (add-to-list 'org-tags-exclude-from-inheritance "roam-agenda")

  (defun vulpea-buffer-p ()
    "Return non-nil if the currently visited buffer is a note."
    (and buffer-file-name
         (string-prefix-p
          (expand-file-name (file-name-as-directory org-roam-directory))
          (file-name-directory buffer-file-name))))

  (defun vulpea-project-p ()
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

  (defun vulpea-project-update-tag (&optional arg)
    "Update PROJECT tag in the current buffer."
    (interactive "P")
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-project-p)
              (setq tags (cons "roam-agenda" tags))
            (setq tags (remove "roam-agenda" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))

          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

  ;; https://systemcrafters.net/build-a-second-brain-in-emacs/5-org-roam-hacks/
  (defun my/org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun my/org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (my/org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun dynamic-agenda-files-advice (orig-val)
    (let ((roam-agenda-files (delete-dups (my/org-roam-list-notes-by-tag "roam-agenda"))))
      (cl-union orig-val roam-agenda-files :test #'equal)))

  (add-hook 'before-save-hook #'vulpea-project-update-tag)
  (advice-add 'org-agenda-files :filter-return #'dynamic-agenda-files-advice)
)

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

(use-package! sis
  ;; :hook
  ;; enable the /context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))
  :after meow
  :config
  ;; For MacOS
  (sis-ism-lazyman-config
   ;; English input source may be: "ABC", "US" or another one.
   ;; "com.apple.keylayout.ABC"
   "com.apple.keylayout.ABC"
   ;; Other language input source: "rime", "sogou" or another one.
   ;; "im.rime.inputmethod.Squirrel.Rime"
   "im.rime.inputmethod.Squirrel.Hans")
  (add-hook 'meow-insert-exit-hook #'sis-set-english)
  (add-hook 'meow-insert-enter-hook #'sis-set-english)
  (add-to-list 'sis-context-hooks 'meow-insert-exit-hook)
  (add-to-list 'sis-context-hooks 'meow-insert-enter-hook)
  (add-to-list 'sis-respect-minibuffer-triggers (cons 'org-roam-node-find (lambda () 'other)))
  (add-to-list 'sis-respect-minibuffer-triggers (cons 'org-roam-node-insert (lambda () 'other)))
)

;;(cond
;; (IS-MAC
;;  (use-package! rime
;;    :custom
;;    (rime-librime-root (expand-file-name "librime" doom-user-dir))
;;    (rime-show-candidate 'posframe)
;;    (rime-show-preedit 'inline)
;;    (rime-user-data-dir (expand-file-name "Rime" doom-user-dir))
;;    (rime-emacs-module-header-root
;;     "/opt/homebrew/opt/emacs-plus@29/include"
;;     ;;"/opt/homebrew/Cellar/emacs-plus@28/28.2/include"
;;     ;;"/opt/homebrew/Cellar/emacs-mac/emacs-28.2-mac-9.1/include"
;;     )
;;    :config
;;    (setq default-input-method "rime")
;;    (setq rime-inline-ascii-trigger 'shift-r)
;;    (setq rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g" "<left>" "<right>" "<up>" "<down>" "<prior>" "<next>" "<delete>"))
;;    (setq rime-disable-predicates
;;     '(meow-normal-mode-p
;;       meow-motion-mode-p
;;       meow-keypad-mode-p
;;       meow-beacon-mode-p
;;    ))
;;)))

(defvar +corfu-auto-delay 0.1
  "How long after point stands still will completion be called automatically,
in seconds.

Setting `corfu-auto-delay' directly may not work, as it needs to be set *before*
enabling `corfu-mode'.")
(defvar +corfu-auto-prefix 2
  "How many characters should be typed before auto-complete starts to kick in.

Setting `corfu-auto-prefix' directly may not work, as it needs to be set
*before* enabling `corfu-mode'.")
(defvar +corfu-want-multi-component t
  "Enables multiple component search, with pieces separated by spaces.

This allows search of non-contiguous unordered bits, for instance by typing
\"tear rip\" to match \"rip-and-tear\". Notice the space, it does not break
completion in this case.")
(defvar +corfu-icon-height 0.9
  "The height applied to the icons (it is passed to both svg-lib and kind-icon).

It may need tweaking for the completions to not become cropped at the end.
Note that changes are applied only after a cache reset, via
`kind-icon-reset-cache'.")

(defvar +corfu-ispell-completion-modes '(org-mode markdown-mode text-mode)
  "Modes to enable ispell completion in.

For completion in comments, see `+corfu-ispell-in-comments-and-strings'.")
(defvar +corfu-ispell-in-comments-and-strings t
  "Enable completion with ispell inside comments when in a `prog-mode'
derivative.")

;;
;;; Packages
(use-package! corfu
  :hook (doom-first-buffer . global-corfu-mode)
  :init
  ;; Auto-completion settings, must be set before calling `global-corfu-mode'.
  (setq corfu-auto t
        corfu-auto-delay +corfu-auto-delay
        corfu-auto-prefix +corfu-auto-prefix
        corfu-excluded-modes '(erc-mode
                               circe-mode
                               help-mode
                               gud-mode
                               vterm-mode))

  :config
  (when (and (modulep! :tools lsp) (not (modulep! :tools lsp +eglot)))
    (add-hook 'lsp-mode-hook (defun doom--add-lsp-capf ()
                               (add-to-list 'completion-at-point-functions (cape-capf-buster #'lsp-completion-at-point)))
              ;; Below is so that context specific completions in cape come first.
              :depth 1))
  (add-to-list 'completion-styles 'partial-completion t)
  (add-to-list 'completion-styles 'initials t)
  (setq corfu-cycle t
        corfu-separator (when +corfu-want-multi-component ?\s)
        corfu-preselect t
        corfu-count 16
        corfu-max-width 120
        corfu-preview-current 'insert
        corfu-quit-at-boundary (if +corfu-want-multi-component 'separator t)
        corfu-quit-no-match (if +corfu-want-multi-component 'separator t)
        ;; In the case of +tng, TAB should be smart regarding completion;
        ;; However, it should otherwise behave like normal, whatever normal was.
        tab-always-indent (if (modulep! +tng) 'complete tab-always-indent))
  ;; Only done with :tools vertico active due to orderless. Alternatively, we
  ;; could set it up here if it's not there.
  (when (and +corfu-want-multi-component (modulep! :completion vertico))
    (cond ((modulep! :tools lsp +eglot) (add-to-list 'completion-category-overrides '(eglot (styles orderless))))
          ((modulep! :tools lsp) (add-hook 'lsp-completion-mode-hook
                                           (defun doom--use-orderless-lsp-capf ()
                                             (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
                                                   '(orderless)))))))
  (map! (:unless (modulep! +tng)
          :desc "complete" "C-SPC" #'completion-at-point)
        (:map 'corfu-map
              (:when +corfu-want-multi-component
                :desc "insert separator" "C-SPC" #'corfu-insert-separator)
              (:when (modulep! :completion vertico)
                :desc "move to minibuffer" "s-<down>" #'corfu-move-to-minibuffer
                (:when (modulep! :editor evil)
                  :desc "move to minibuffer" "s-j" #'corfu-move-to-minibuffer))
              (:when (modulep! +tng)
                :desc "next" [tab] #'corfu-next
                :desc "previous" [backtab] #'corfu-previous
                :desc "next" "TAB" #'corfu-next
                :desc "previous" "S-TAB" #'corfu-previous))))

;; Taken from corfu's README.
;; TODO: extend this to other completion front-ends, mainly helm and ido, since
;; ivy is being considered for removal.
(when (modulep! :completion vertico)
  (defun corfu-move-to-minibuffer ()
    (interactive)
    (let ((completion-extra-properties corfu--extra)
          completion-cycle-threshold completion-cycling)
      (apply #'consult-completion-in-region completion-in-region--data))))

(use-package! cape
  :after corfu
  :commands (cape-dabbrev
             cape-file
             cape-history
             cape-keyword
             cape-tex
             cape-sgml
             cape-rfc1345
             cape-abbrev
             cape-dict
             cape-symbol
             cape-line)
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (when +corfu-ispell-in-comments-and-strings
    (defalias 'corfu--ispell-in-comments-and-strings
      (cape-super-capf (cape-capf-inside-comment #'cape-dict)
                       (cape-capf-inside-string #'cape-dict)))
    (add-hook 'prog-mode-hook
              (lambda ()
                (add-to-list 'completion-at-point-functions #'corfu--ispell-in-comments-and-strings t))))
  (dolist (sym +corfu-ispell-completion-modes)
    (add-hook (intern (concat (symbol-name sym) "-hook"))
              (lambda ()
                (add-to-list 'completion-at-point-functions #'cape-dict t))))
  (add-hook! '(TeX-mode-hook LaTeX-mode-hook org-mode-hook)
    (lambda ()
      (add-to-list 'completion-at-point-functions #'cape-tex t))
    :depth 2)
  (add-hook! '(html-mode-hook +web-react-mode-hook typescript-tsx-mode-hook org-mode-hook markdown-mode-hook)
    (lambda ()
      (add-to-list 'completion-at-point-functions #'cape-sgml t))
    :depth 2)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  :config
  ;; Enhances speed on large projects, for which many buffers may be open.
  (setq cape-dabbrev-check-other-buffers nil))

(use-package! kind-icon
  :commands kind-icon-margin-formatter
  :init
  (add-hook 'corfu-margin-formatters #'kind-icon-margin-formatter)
  :config
  (setq kind-icon-default-face 'corfu-default
        kind-icon-blend-background t
        kind-icon-blend-frac 0.2)
  (plist-put kind-icon-default-style :height +corfu-icon-height)
  (plist-put svg-lib-style-default :height +corfu-icon-height))

(use-package! corfu-terminal
  :when (modulep! :os tty)
  :hook (corfu-mode . corfu-terminal-mode))

(use-package! dabbrev
  :config
  (setq dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))

(setq read-extended-command-predicate
      #'command-completion-default-include-p)

;;
;;; Extensions
(use-package! corfu-history
  :after savehist
  :hook (corfu-mode . corfu-history-mode)
  :config
  (add-to-list 'savehist-additional-variables 'corfu-history))
(use-package! corfu-popupinfo
  :hook (corfu-mode . corfu-popupinfo-mode)
  :config
  (setq corfu-popupinfo-delay '(0.5 . 1.0))
  (map! (:map 'corfu-map
         :desc "scroll info up" "C-<up>" #'corfu-popupinfo-scroll-down
         :desc "scroll info down" "C-<down>" #'corfu-popupinfo-scroll-up
         :desc "scroll info up" "C-S-p" #'corfu-popupinfo-scroll-down
         :desc "scroll info down" "C-S-n" #'corfu-popupinfo-scroll-up
         :desc "toggle info" "C-h" #'corfu-popupinfo-toggle)
        (:map 'corfu-popupinfo-map
         :when (modulep! :editor evil)
         ;; Reversed because popupinfo assumes opposite of what feels intuitive
         ;; with evil.
         :desc "scroll info up" "C-S-k" #'corfu-popupinfo-scroll-down
         :desc "scroll info down" "C-S-j" #'corfu-popupinfo-scroll-up)))

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
;;;;  :after tempel)

;; we recommend using use-package to organize your init.el
;;(use-package! codeium
;;    ;; if you use straight
;;    ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
;;    ;; otherwise, make sure that the codeium.el file is on load-path
;;
;;    :init
;;    ;; use globally
;;    (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;    ;; or on a hook
;;    ;; (add-hook 'python-mode-hook
;;    ;;     (lambda ()
;;    ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))
;;
;;    ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;    ;; (add-hook 'python-mode-hook
;;    ;;     (lambda ()
;;    ;;         (setq-local completion-at-point-functions
;;    ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;    ;; an async company-backend is coming soon!
;;
;;    ;; codeium-completion-at-point is autoloaded, but you can
;;    ;; optionally set a timer, which might speed up things as the
;;    ;; codeium local language server takes ~0.2s to start up
;;    ;; (add-hook 'emacs-startup-hook
;;    ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))
;;
;;    :defer t
;;    :config
;;    (setq use-dialog-box nil) ;; do not use popup boxes
;;
;;    ;; if you don't want to use customize to save the api-key
;;    ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
;;
;;    ;; get codeium status in the modeline
;;    (setq codeium-mode-line-enable
;;        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;    (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;    ;; alternatively for a more extensive mode-line
;;    ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)
;;
;;    ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;    (setq codeium-api-enabled
;;        (lambda (api)
;;            (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;    ;; you can also set a config for a single buffer like this:
;;    ;; (add-hook 'python-mode-hook
;;    ;;     (lambda ()
;;    ;;         (setq-local codeium/editor_options/tab_size 4)))
;;
;;    ;; You can overwrite all the codeium configs!
;;    ;; for example, we recommend limiting the string sent to codeium for better performance
;;    (defun my-codeium/document/text ()
;;        (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;    ;; if you change the text, you should also change the cursor_offset
;;    ;; warning: this is measured by UTF-8 encoded bytes
;;    (defun my-codeium/document/cursor_offset ()
;;        (codeium-utf8-byte-length
;;            (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;    (setq codeium/document/text 'my-codeium/document/text)
;;    (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

(use-package! conda
;; :init
  ;;:hook
  ;;(find-file (lambda () (when (bound-and-true-p conda-project-env-path)  (conda-env-activate-for-buffer))))
  :custom
  (conda-anaconda-home "/opt/homebrew/Caskroom/miniconda")
  :config
  (conda-env-initialize-interactive-shells)
  (setq conda-env-autoactivate-mode t)
)

;;(use-package! xenops
;;    :after org
;;    :hook
;;    (org-mode . xenops-mode)
;;    (latex-mode . xenops-mode)
;;    (LaTex-mode . xenops-mode)
;;    :config
;;    (setq xenops-reveal-on-entry t
;;          ;;xenops-image-directory (expand-file-name "xenops/image" doom-cache-dir)
;;          xenops-math-latex-process 'xelatex)
;;)


;;(after! xenops
;;  (defun xenops-math-block-delimiter-lines-regexp ()
;;    "A regexp matching the start or end line of any block math element."
;;    (format "\\(%s\\)"
;;            (s-join "\\|"
;;                    (apply #'append (xenops-elements-get-for-types '(block-math table algorithm) :delimiters)))))
;;  (defun xenops-math-parse-element-at-point ()
;;    "Parse any math element at point."
;;    (or (xenops-math-parse-inline-element-at-point)
;;        (xenops-math-parse-block-element-at-point)
;;        (xenops-math-parse-table-at-point)
;;        (xenops-math-parse-algorithm-at-point)))
;;
;;  (defun xenops-math-parse-algorithm-at-point ()
;;    "Parse algorithm element at point."
;;    (xenops-parse-element-at-point 'algorithm))
;;
;;
;;  (add-to-list 'xenops-elements '(algorithm
;;                                  (:delimiters
;;                                   ("^[ 	]*\\\\begin{algorithm}"
;;                                    "^[ 	]*\\\\end{algorithm}"))
;;                                  (:parser . xenops-math-parse-algorithm-at-point)
;;                                  (:handlers . block-math)))
;;  )

;;(use-package org-xlatex
;;  :after org
  ;;:hook (org-mode . org-xlatex-mode)
;;)

;;(use-package! org-preview
  ;;:hook (org-mode . org-preview-mode)
;;)

;;(add-hook 'org-mode-hook #'org-latex-preview-auto-mode)

(if IS-MAC
(use-package! dash-at-point
  :config
 (add-to-list 'dash-at-point-mode-alist '(python-mode . "python3,django,twisted,sphinx,flask,tornado,sqlalchemy,numpy,scipy,saltcvp,torch,torchvision"))
))

(use-package! org-noter
  :after org
  :config
  (setq org-noter-notes-search-path (concat org-directory "references"))
  (setq org-noter-alway-create-frame t)
  (setq org-noter-auto-save-last-location t)
  (setq org-noter-doc-split-fraction '(0.52 0.48))
)


(after! org-noter
  (defun eli/org-noter-set-highlight (&rest _arg)
    "Highlight current org-noter note."
    (save-excursion
      (with-current-buffer (org-noter--session-notes-buffer org-noter--session)
        (remove-overlays (point-min) (point-max) 'org-noter-current-hl t)
        (goto-char (org-entry-beginning-position))
        (let* ((hl (org-element-context))
               (hl-begin (plist-get  (plist-get hl 'headline) :begin))
               (hl-end (1- (plist-get  (plist-get hl 'headline) :contents-begin)))
               (hl-ov (make-overlay hl-begin hl-end)))
          (overlay-put hl-ov 'face 'mindre-keyword)
          (overlay-put hl-ov 'org-noter-current-hl t))
        (org-cycle-hide-drawers 'all))))
  (advice-add #'org-noter--focus-notes-region
              :after #'eli/org-noter-set-highlight)
  (advice-add #'org-noter-insert-note
              :after #'eli/org-noter-set-highlight)


)

;;(use-package! org-noter-nov-overlay)

;;(use-package! org-noter-plus
;;  :commands (org-noter-plus--follow-nov-link)
;;  :config
;;  (setq org-noter-plus-image-dir "~/org/.attach/") ;; Directory to store images extracted from pdf files
;;)
;;
;;(after! nov
;;  (org-link-set-parameters "nov"
;;                           ;; Replace the default nov link to work better with org-noter
;;                           :follow 'org-noter-plus--follow-nov-link)
;;  )

;;(use-package! org-media-note
;;  :init (setq org-media-note-use-org-ref t)
;;  :hook (org-mode .  org-media-note-mode)
;;  :after org
;;  :bind (("H-v" . org-media-note-hydra/body))  ;; Main entrance
;;  :config
;;  (setq org-media-note-screenshot-image-dir "~/org/.attach/")  ;; Folder to save screenshot
;;  (setq org-media-note-use-refcite-first t)  ;; use videocite link instead of video link if possible
;;  )

(use-package! mpvi)

;;(use-package! wakatime-mode
;;  :config
;; (setq wakatime-cli-path       (cond (IS-MAC "~/.nix-profile/bin/wakatime-cli") (IS-WINDOWS "~/.wakatime/wakatime-cli")))
;;  (global-wakatime-mode)
;;)

(setq keyfreq-mode t
      keyfreq-autosave-mode t)

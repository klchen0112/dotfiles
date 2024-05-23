;;; init.el -*- lexical-binding: t; -*-
                                        ;   ;

;; This file controls what jDoom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; ?OTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).
(doom! :input
       ;;bidi              ; (tfel ot) thgir etirw uoy gnipleh
       ;;chinese
       ;;japanese
       layout            ; auie,ctsrnm is the superior home row

       :completion
       (corfu
        +icons ;; Display icons beside completion suggestions.
        +orderless
        +dabbrev ;; as a close-to-universal CAPF
        ) ; wait for doom merge
       ;;(company +childframe +tng)           ; the ultimate code completion backend
       ;;helm              ; the *other* search engine for love and life
       ;;ido               ; the other *other* search engine...
       ;;(ivy +fuzzy +prescient +childframe +icons)               ; a search engine for love and life
       (vertico +icons
                +childframe ;; not for yabai
                )         ; the search engine of the future

       :ui
       ;;deft              ; notational velocity for Emacs
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       doom-quit         ; DOOM quit-message prompts when you quit Emacs
       ;;(emoji +unicode)  ; 🙂
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       ;;hydra
       indent-guides     ; highlighted indent columns
       (ligatures
        +extra
        +fira ; fira font ligatures
        +hasklig ; HaskLig font ligatures
        +iosevka ; iosevka font ligatures
        +pragmata-pro ; Pragmata-Pro font ligatures
        )       ; ligatures and symbols to make your code pretty again
       ;;minimap           ; show a map of the code on the side
       modeline          ; snazzy, Atom-inspired modeline, plus API
       nav-flash         ; blink cursor line after big motions
       ;;neotree           ; a project drawer, like NERDTree for vim
       ophints           ; highlight the region an operation acts on
       (popup ; tame sudden yet inevitable temporary windows
        +all
        +defaults)          ;;
       ;;tabs              ; a tab bar for Emacs
       ;;(treemacs +lsp)       ; a project drawer, like neotree but cooler
       unicode           ; extended unicode support for various language
       (vc-gutter +pretty)         ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       (window-select +numbers)     ; visually switch windows
       workspaces        ; tab emulation, persistence & separate workspaces
       zen               ; distraction-free coding or writing

       :editor
       ;;(meow  +qwerty +override +leader)
       ;; (evil +everywhere); come to  dark side, we have cookies
       file-templates    ; auto-snippets for files
       fold              ; (nigh) universal code folding
       (format ; automated prettiness
        +onsave ; only-changes
        )
       ;;god               ; run Emacs commands without modifier keys
       ;;lispy             ; vim for lisp, for people who don't like vim
       ;;multiple-cursors  ; editing in many places at once
       ;;objed             ; text object editing for the innocent
       ;;parinfer          ; turn lisp into python, sort of
       rotate-text       ; cycle region at point between text candidates
       snippets          ; my elves. They type so I don't have to
       word-wrap         ; soft wrapping with language-aware indent

       :emacs
       (dired
        ;; +ranger           ; make bringing the goodness of ranger to dired
        +icons           ; making dired pretty [functional]
        +dirvish
        )
       electric          ; smarter, keyword-based electric-indent
       (ibuffer +icons)        ; interactive buffer management
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       eshell            ; the elisp shell that works everywhere
       ;;shell             ; simple shell REPL for Emacs
       ;;term              ; basic terminal emulator for Emacs
       ;;vterm             ; the best terminal emulation in Emacs

       :checkers
       (syntax +childframe)              ; tasing you for every semicolon you forget
       (spell) ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake every you make

       :tools
       ;;ansible
       biblio            ; Writes a PhD for you (citation needed)
       ;;collab ; buffers with friends
       debugger          ; FIXME stepping through code, to help you add bugs
       direnv
       (docker +lsp)
       editorconfig      ; let someone else argue about tabs vs spaces
       ;;ein               ; tame Jupyter notebooks with emacs
       (eval +overlay)     ; run code, run (also, repls)
       (lookup +dictionary +docsets +offline)             ; navigate your code and its documentation
       (lsp +peek)              ; M-x vscode
       (magit             ; a git porcelain for Emacs
        ;;+forge             ; interface with git forges
       )
       make              ; run make tasks from Emacs
       ;;pass              ; password manager for nerds
       pdf               ; pdf enhancements
       ;;prodigy           ; FIXME managing external services & code builders
       rgb               ; creating color strings
       taskrunner        ; taskrunner for all your projects
       tree-sitter
       ;;terraform         ; infrastructure as code
       ;;tmux              ; an API for interacting with tmux
       upload            ; map local to remote projects via ssh/ftp

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       ;;agda              ; types of types of types of types...
       ;;beancount         ; mind the GAAP
       (cc +lsp
           ;; C > C++ == 1
           ;;+tree-sitter
           )
       ;;(clojure +lsp)           ; java with a lisp
       ;;common-lisp       ; if you've seen one lisp, you've seen them all
       ;;coq               ; proofs-as-programs
       ;;crystal           ; ruby at the speed of c
       ;;csharp            ; unity, .NET, and mono shenanigans
       ;;data              ; config/data formats
       ;;(dart +flutter)   ; paint ui and not much else
       ;;dhall
       ;;elixir            ; erlang done right
       ;;elm               ; care for a cup of TEA?
       (emacs-lisp; drown in parentheses
        +ttree-sitter
        )
       ;;erlang            ; an elegant language for a more civilized age
       ;;ess               ; emacs speaks statistics
       ;;factor
       ;;faust             ; dsp, but you get to keep your soul
       ;;fortran           ; in FORTRAN, GOD is REAL (unless declared INTEGER)
       ;;fsharp            ; ML stands for Microsoft's Language
       ;;fstar             ; (dependent) types and (monadic) effects and Z3
       ;;gdscript          ; the language you waited for
       (go +lsp)         ; the hipster dialect
       ;;(graphql +lsp)    ; Give queries a REST
       ;;(haskell +lsp)    ; a language that's lazier than I am
       ;;hy                ; readability of scheme w/ speed of python
       ;;idris             ; a language you can depend on
       (json  +lsp)            ; At least it ain't XML
       ;;(java +lsp)       ; the poster child for carpal tunnel syndrome
       (javascript +lsp)        ; all(hope(abandon(ye(who(enter(here))))))
       ;;(julia +lsp ; a better, faster MATLAB
       ;;+tree-sitter
       ;;      )
       ;;kotlin            ; a better, slicker Java(Script)
       (latex             ; writing papers in Emacs has never been so fun
        +lsp
        +latexmk                    ; what else would you use?
        +cdlatex                    ; quick maths symbols
        +fold)                      ; fold the clutter away nicities
       ;;lean              ; for folks with too much to prove
       ;;ledger            ; be audit you can be
       (lua
           +lsp
           ;;+fennel +moonscript
           )              ; one-based indices? one-based indices
       (markdown
        +grip
        )          ; writing docs for people to ignore
       ;;nim               ; python + lisp at the speed of c
       (nix +lsp +tree-sitter)               ; I hereby declare "nix geht mehr!"
       ;;ocaml             ; an objective camel
       (org              ; organize your plain life in plain text
        ;;+brain
        ;;+contacts ; Insert org-mode links to items selected in various Mac apps.
        +dragndrop                  ; drag & drop files/images into org buffers
        ;;+gnuplot                    ; who doesn't like pretty pictures
        +hugo                     ; use Emacs for hugo blogging
        ;; +journal ;; use org roam dailyies
        +noter ;; enhanced pdf notetaking
        ;;+pretty                     ; yessss my pretties! (nice unicode symbols)
        ;;+jupyter                    ; ipython/jupyter support for babel
        +pandoc                     ; export-with-pandoc support
        ;;+pomodoro                 ; be fruitful with the tomato technique
        ;;+present                    ; using org-mode for presentations
        +roam2)                     ; wander around notes
       ;;php               ; perl's insecure younger brother
       ;;plantuml          ; diagrams for confusing people more
       ;;purescript        ; javascript, but functional
       (python +lsp
               +pyright
               +pyenv
               +cpython
               ;; (if (not IS-MAC) +conda)
               +poetry
               +tree-sitter
               )            ; beautiful is better than ugly
       ;;qt                ; the 'cutest' gui framework ever
       ;;racket            ; a DSL for DSLs
       ;;raku              ; the artist formerly known as perl6
       ;;rest              ; Emacs as a REST client
       ;;rst               ; ReST in peace
       ;;(ruby +rails)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       (rust +lsp)              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;scala             ; java, but good
       ;;(scheme +guile)   ; a fully conniving family of lisps
       (sh  +fish)               ; she sells {ba,z,fi}sh shells on the C xor
       ;;sml
       ;;solidity          ; do you need a blockchain? No.
       ;;swift             ; who asked for emoji variables?
       ;;terra             ; Earth and Moon in alignment for performance.
       ;;(web +lsp)              ; the tubes
       (yaml +lsp +tree-sitter)              ; JSON, but readable
       ;;zig               ; C, but simpler

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar
       ;;emms
       ;;everywhere           ; *leave* Emacs!? You must be joking
       ;;irc               ; how neckbeards socialize
       (rss +org)        ; emacs as an RSS reader
       ;;twitter           ; twitter client https://twitter.com/vnought

       :config
       literate
       (default +bindings +smartparens))

;;TODO remove add to list
;;(add-to-list 'load-path (concat doom-emacs-dir ".local/straight/repos/nursery/lisp"))

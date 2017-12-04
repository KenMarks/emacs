;;; Start server so we can use "Edit with Emacs from context menu."
(require 'server)
(or (server-running-p)
     (server-start))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start up items.
(setq inhibit-splash-screen t) ;; No splash screen on startup.
(setq initial-scratch-message "") ;; No initial scratch message.
(tool-bar-mode -1) ;; No tool bar.
(menu-bar-mode 1) ;; toggle menu bar.
(scroll-bar-mode -1);; want to use scroll bars?
(display-time-mode 1) ;; show time

;; emacs is maximized on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Set font.
(set-face-attribute 'default nil
		    ;;:family "DejaVu Sans Mono"
		    :family "Bitstream Vera Sans Mono"
		    :height 100
		    :width 'normal
		    :foundry "outline"
		    :slant 'normal
		    :weight 'normal)

;; more useful frame title, that shows either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;;Use C-TAB to switch buffers
(global-set-key [(control tab)] 'bury-buffer)

;; Restrict things to utf-8.
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load other packages.
(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
			 ("elpy" . "http://jorgenschaefer.github.io/packages/")
			 )
      )
(add-to-list 'package-archives
	     '("elpy" . "http://jorgenschaefer.github.io/packages/")
	     )

(defvar myPackages
  '(elpy ;; add the elpy package
    py-autopep8 ;; add autopep8 package
    flycheck ;; add flycheck package
    )
  )

(elpy-enable) ;; enable elpy

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fill column indicator
(require 'fill-column-indicator)
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda ()
			    (setq fci-rule-color "#DCDCCC")
			    (fci-mode 1)))
(setq fci-rule-column 70)
(setq fci-rule-width 1)
(setq fci-rule-color "#DCDCCC")
(global-fci-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turn on auto-dim-other-buffers-mode automatically.
(add-hook 'after-init-hook (lambda ()
  (when (fboundp 'auto-dim-other-buffers-mode)
    (auto-dim-other-buffers-mode t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Let's try helm.
(require 'helm-config)
(require 'helm)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode t)

;; Use helm-M-x mode.
(global-set-key (kbd "M-x") 'helm-M-x)
;; Use helm kill ring
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; Use helm to find files
(global-set-key (kbd "C-x C-f") 'helm-find-files)
;; Do not resize helm buffer based on number of candidates.
(helm-autoresize-mode 0)

;; Map menu key to helm-M-x
(when (string-equal system-type "windows-nt")
  (global-set-key (kbd "<apps>") 'helm-M-x))
;; For laptop typing, let's bind helm-M-x to F9
(global-set-key (kbd "<f9>") 'helm-M-x)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-text-fill mode for text files.
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 70)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set nicer colors in shells.
(setq ansi-color-for-comint-mode t)
(setq ansi-color-names-vector
  ["black" "red" "green" "orange" "PaleBlue" "magenta" "cyan" "white"])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set C-c C-d to duplicate a line.
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key "\C-c\C-d" 'duplicate-line)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For the calendar's sunrise/sunset option, input latitude and longitude
;; You can get lat-long data from the NWS. I'm usually in Pittsburgh.
(setq calendar-latitude 40.22)
(setq calendar-longitude -80.00)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
(require 'org)
(add-hook 'org-mode-hook 'my-org-mode-hook)
(defun my-org-mode-hook()
  (progn
    (turn-on-flyspell)
    ;; turn off this auto-fill-mode. i don't want it on my time sheet.
    ;;(auto-fill-mode 1)
    ))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; Open all text files in org mode. That way I can share notes in txt
;; files with folks who don't use org mode
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)
(setq org-support-shift-select nil)
;; I'd like to use C-Tab to switch buffers, even in org-mode.
(add-hook 'org-mode-hook (lambda () (local-set-key [(control tab)] 'bury-buffer)))
;; When opening Org files, show everything.
;; (setq org-startup-folded 'showeverything)
;; Nah, keep it folded.

;; Want emphasis to extend over multiple lines.
;; from https://emacs.stackexchange.com/questions/13820/inline-verbatim-and-code-with-quotes-in-org-mode
(setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,\"")
(org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

;; pandoc mode.
(add-hook 'markdown-mode-hook 'pandoc-mode)
;; Open all text files in org mode. That way I can share notes in txt
;; files with folks who don't use org mode or pandoc.
(add-to-list 'auto-mode-alist '("\\.txt$" . pandoc-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up recentf so I can get a list of recent files when I start
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 30)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Display settings
;;(setq display-time-12hr-format t)		 ; In 12 hour format
(display-time-mode -1)		 ; Display the time

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set path to place all those foo~ backup files that emacs create.
(setq backup-directory-alist `(("." . "C:/Users/kmarks/Documents/emacs_backups")))
;; Set the backup procedure to copying current file -- slow but safe.
(setq backup-by-copying t)
;; Set number of versions to keep & turn on version control.
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drive out the mouse when it's too near to the cursor.
(mouse-avoidance-mode 'animate)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add Emacs close confirmation
(setq kill-emacs-query-functions
     (cons (lambda () (yes-or-no-p "Really kill Emacs?"))
     kill-emacs-query-functions))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turn on font-lock mode for Emacs. This turns on syntax highlighting
;; for all major modes and turn on maximum decorations.
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; I don't want visual feedback on selections
(setq-default transient-mark-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Always end a file with a newline
(setq require-final-newline t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Stop at the end of the file, do not just add
;; lines as user tries to scroll down
(setq next-line-add-newlines nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Replace 'yes or no' queries to 'y or n'
(fset 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq column-number-mode t) ;;display column number
(setq line-number-mode t)   ;display line number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Some other formatting junk
(setq visible-bell t)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;hopefully this makes aspell work as a spellchecker
(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
(setq ispell-program-name "aspell")
;;(setq ispell-personal-dictionary "C:/Program Files (x86)/Aspell/dict")
;;(require 'ispell)
;;(global-set-key (kbd "<f7>") 'ispell)
;;(global-set-key (kbd "<f8>") 'ispell-word)

(global-set-key (kbd "C-<f8>") 'flyspell-mode) ; toggles flyspell-mode
;; Turn on flyspell mode for text documents.
(add-hook 'text-mode-hook 'flyspell-mode)
;; Turn on flyspell mode for program mode.
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
;; flyspell with helm interface.
(require 'flyspell-correct-helm)
(define-key flyspell-mode-map (kbd "<f7>") 'flyspell-correct-word-generic)
(define-key flyspell-mode-map (kbd "<f8>") 'flyspell-correct-previous-word-generic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo some previous changes
(require 'undo-tree)
(global-undo-tree-mode 1)
(global-set-key (kbd "<f11>") 'undo)
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "<f12>") 'redo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; I'd like to print emacs bufferes to ghostscript
(setenv "GS_LIB" "C:/Program Files/gs/g9.14/lib;C:/Program Files/gs/g9.14/fonts")
   (setq ps-lpr-command "C:/Program Files/gs/gs9.14/bin/gswin64c.exe")
   (setq ps-lpr-switches '("-q" "-dNOPAUSE" "-dBATCH" "-sDEVICE=mswinpr2"))
   (setq ps-printer-name t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTeX stuff.
;; AUCTEX
(require 'tex-site)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; RefTeX
(autoload 'reftex-mode    "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-plug-into-AUCTeX t)
(setq bib-cite-use-reftex-view-crossref t)

(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;j; Python stuff.
;; We can get Python to work under windows
;; use IPython
(setq
 python-shell-interpreter "C:\\Python27\\python.exe"
 python-shell-interpreter-args
 "-i C:\\Python27\\Scripts\\ipython.exe"
python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p nil)
(setq py-switch-buffers-on-execute-p nil)
;; don't split windows
(setq py-split-windows-on-execute-p nil)
;; try to automagically figure out indentation
(setq py-smart-indentation t)

;; Replace flymake with flycheck for real time checking..
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Setup jedi mode.
;;(add-hook 'python-mode-hook 'jedi:setup)
;;(setq jedi:complete-on-dot t)                 ; optional
;; Jedi not working nicely.
;; Try anaconda mode.
(add-hook 'python-mode-hook 'anaconda-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Autoload hide show mode for code folding.
;; someday i'll figure this out...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					; try to improve slow performance on windows.
(setq w32-get-true-file-attributes nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smart mode line
(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'respectful)
;;(setq powerline-arrow-shape 'curve)
;;(setq powerline-default-separator-dir '(right . left))
;;(setq sml/theme 'powerline)

(add-to-list 'sml/replacer-regexp-list  '("h:/time/" ":T:") t)
(add-to-list 'sml/replacer-regexp-list  '("h:/Documents/Survey/" ":S:") t)
(setq sml/mode-width 0)
(setq sml/name-width 15)
(setq sml/shorten-directory t)
(setq sml/shorten-modes t)
(sml/setup)
;; Turn off minor modes.
(require 'rich-minority)
(rich-minority-mode 1)
(setf rm-blacklist "")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; powerline
;;(require 'powerline)
;;(powerline-default-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; nyan-mode!!!!!!!!!!!!!!!!!!!!!!!!!
(require 'nyan-mode)
;;(nyan-toggle-wavy-trail)
;;(nyan-start-animation)
(nyan-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set all themes as safe.
(setq custom-safe-themes t)
;; Load theme here.
(load-theme 'zenburn t)
(setq sml/theme nil)
(set-face-attribute 'sml/modified nil
		    :foreground "Red"
		    :weight 'bold)
;;(load-theme 'labburn t)
;;(setq spacemacs-theme-org-height nil)
;(load-theme 'spacemacs-dark t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;I'd like to highlight the line where the cursor is
(global-hl-line-mode t)
;; To customize the background color
;; use M-x list-colors-display to see a list of colors.
;;(set-face-background 'hl-line "#3e4446")
(set-face-background 'hl-line "gray15")
;; you can change the color by replacing the ''#XXXXXX'' with
;; the appropriate hexadecimal RGB color code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Let's see if multiple-cursors is any good.
(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ace jump mode.
;;(require 'ace-jump-mode)
;;(define-key global-map (kbd "C-c j") 'ace-jump-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Try avy instead of ace jump mode.
(require 'avy)
(global-set-key (kbd "C-c j") 'avy-goto-word-or-subword-1)
;; tweak the prefix values.
(setq avy-keys
      (nconc (number-sequence ?a ?z)
	     (number-sequence ?A ?Z)
	     (number-sequence ?1 ?9)
	     '(?0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up buffer-move to easily swap buffers.
(require 'buffer-move)
; We'll use control + shift + arrow to move buffers.
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global hook to delete trailing whitespace on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use ibuffer to list buffers as default..
(defalias 'list-buffers 'ibuffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; save/restore opened files and windows config
(desktop-save-mode 1) ; 0 for off

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; turn on company mode.
(add-hook 'after-init-hook 'global-company-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; simplify switching between buffers with windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
(setq windmove-wrap-around t) ;; enable wrap around buffer movement.
;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Things to make delimiters a little easier to use.
;; Rainbow delimiters for pretty colors.
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; autopair mode to add delimiters in pairs.
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)
;; adjust mode by uncommenting appropriate line below
(setq show-paren-style 'parenthesis) ; highlight brackets
;(setq show-paren-style 'expression) ; highlight entire expression
;(setq show-paren-style 'mixed) ; highlight brackets if visible, else entire expression
;; some face/color customization
(require 'paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "yellow")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A function to rename current file and buffer.
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to new-name."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
;; Bind that function to C-c r.
(global-set-key (kbd "C-c r") 'rename-file-and-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; anzu to count search results
(global-anzu-mode 1)
(anzu-mode 1)
(set-face-attribute 'anzu-mode-line nil
		    :foreground "yellow"
		    :weight 'bold)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; move to beginning of line in a clever way.
;; (defadvice move-beginning-of-line (around smarter-bol activate)
;;   ;; Move to requested line if needed.
;;   (let ((arg (or (ad-get-arg 0) 1)))
;;     (when (/= arg 1)
;;       (forward-line (1- arg))))
;;   ;; Move to indentation on first call, then to actual BOL on second.
;;   (let ((pos (point)))
;;     (back-to-indentation)
;;     (when (= pos (point))
;;       ad-do-it)))
;; That doesn't work in my org files. Let's try crux.
;; Here's Bozhidar Batsov's method.
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)
;; dang it. that doesn't work in  org mode either.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avoid weasel words with artbollocks-mode.
(require 'artbollocks-mode)
(setq artbollocks-weasel-words-regex
          (concat "\\b" (regexp-opt
                         '("one of the"
                           "should"
                           "just"
                           "sort of"
                           "a lot"
                           "probably"
                           "maybe"
                           "perhaps"
                           "I think"
                           "really"
                           "pretty"
                           "nice"
                           "action"
                           "utilize"
                           "leverage") t) "\\b"))
(setq artbollocks-jargon nil) ; skip jargon.
(setq artbollocks-lexical-illusions nil) ; skip repeated words.
;; adjust face of highlighted text.
(set-face-attribute 'artbollocks-passive-voice-face nil
		    :background "Black")
(set-face-attribute 'artbollocks-weasel-words-face nil
		    :background "Black")
(set-face-attribute 'artbollocks-face nil
		    :background "Black")
(autoload 'artbollocks-mode "artbollocks-mode")
(add-hook 'text-hook 'artbollocks-mode)
(add-hook 'org-mode-hook 'artbollocks-mode)
(add-hook 'org-capture-mode-hook 'artbollocks-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; smooth scrolling feels good.
(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Unfill paragraph from https://www.emacswiki.org/emacs/UnfillParagraph
;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
	;; This would override `fill-column' if it's an integer.
	(emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))
; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keyboard macro to turn list like a;b;c into
;; 1. a
;; 2. b
;; 3. c
;; dangerous: will replace any semicolon separated lists
;; after the cursor. Want to limit to replace semicolons on the
;; current line.
(fset 'semicolon_to_numbered_list
   [?1 ?. ?  ?\M-% ?\; return ?\C-q ?\C-j ?1 ?. ?  return ?! backspace backspace backspace backspace ?\C-c ?\C-c])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(use-package aggressive-indent
;;	     :ensure t
;;	     :config
;;	     (global-aggressive-indent-mode +1))
(global-aggressive-indent-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(paradox-github-token t)
 '(safe-local-variable-values
   (quote
    ((eval when
	   (require
	    (quote rainbow-mode)
	    nil t)
	   (rainbow-mode 1))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

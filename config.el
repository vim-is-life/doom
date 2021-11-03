;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Daunovan McCullough"
      user-mail-address "dmccullough@imsa.edu")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; set the default org archive location
(setq org-archive-location "~/org/archive/todo_archive.org::* From %s")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;; my additions outside of the above
;; function for making sure the line endings are always compatible
(defun no-junk-please-were-unixish ()
  (let ((coding-str (symbol-name buffer-file-coding-system)))
    (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
      (set-buffer-file-coding-system 'unix))))
(add-hook 'find-file-hook 'no-junk-please-were-unixish) ;; call the function defined earlier i believe this is doing


(setq ob-mermaid-cli-path "~/.local/bin/node_modules/.bin/mmdc")
(setq ispell-program-name "aspell")
(setq lsp-tex-server 'texlab)   ; latex lsp

(setq org-odt-preferred-output-format "docx")

;;; org ref stuff
(require 'org-ref-ivy)
(setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
      org-ref-insert-cite-function 'org-ref-cite-insert-ivy
      org-ref-insert-label-function 'org-ref-insert-label-link
      org-ref-insert-ref-function 'org-ref-insert-ref-link
      org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))

(require 'org-ref-refproc)
;; fine tuned export --> html
;; (setq ((org-export-before-parsing-hook '(org-ref-cite-natmove ;; do this first
;;                                         org-ref-csl-preprocess-buffer
;;                                         org-ref-refproc)))
;;   (org-open-file (org-html-export-to-html)))
;; ;; fine tuned export --> odt
;; (setq ((org-export-before-parsing-hook '(org-ref-cite-natmove ;; do this first
;;                                         org-ref-csl-preprocess-buffer
;;                                         org-ref-refproc)))
;;   (org-open-file (org-odt-export-to-odt) 'system))
;; ;; fine tuned export --> docx
;; (setq ((org-export-before-parsing-hook '(org-ref-cite-natmove ;; do this first
;;                                         org-ref-csl-preprocess-buffer
;;                                         org-ref-refproc)))
;;   (org-open-file (plist-get (org-pandoc-export-to-docx) 'output-file) 'system))

;; setting some org ref variables
(setq bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"
      bibtex-completion-additional-search-fields '(keywords)
      bibtex-completion-display-formats
      '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
        (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
        (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
        (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
        (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
      bibtex-completion-pdf-open-function
      (lambda (fpath)
	(call-process "open" nil 0 nil fpath)))
(setq bibtex-dialect 'biblatex)
(setq org-latex-pdf-process '("latexmk -f -shell-escape -bibtex -pdfxe %f"))
;; easier calling of org ref
(define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link-hydra)

;; mu4e config
(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-maildir       "~/Maildir"))   ;; top-level Maildir



(set-email-account! "school-gmail"
  '((mu4e-sent-folder       . "/school-gmail/[Gmail].Sent Mail")
    ;; (mu4e-drafts-folder     . "/school-gmail/Drafts")
    ;; (mu4e-trash-folder      . "/school-gmail/Trash")
    (mu4e-refile-folder     . "/school-gmail/[Gmail].All Mail")
    (smtpmail-smtp-user     . "dmccullough@imsa.edu")
    (user-mail-address      . "dmccullough@imsa.edu")    ;; only needed for mu < 1.4
    (mu4e-compose-signature . "\nDaunovan McCullough"))
  t)

(setq mu4e-context-policy 'ask-if-none
      mu4e-compose-context-policy 'always-ask)

;; don't need to run cleanup after indexing for gmail
(setq mu4e-index-cleanup nil
      ;; because gmail uses labels as folders we can use lazy check since
      ;; messages don't really "move"
      mu4e-index-lazy-check t)

;; fix "No such file or directory, mu4e"
;; if you installed it using your package manager
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

;; elfeed
(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

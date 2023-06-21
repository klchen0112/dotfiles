;;; $DOOMDIR/custom.el -*- lexical-binding: t; -*-
;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(codeium/metadata/api_key "be3834fd-1475-4a8f-b5a2-fc4d0c45d233")
 '(connection-local-criteria-alist
   '(((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "klchendeMacBook-Pro-305.local")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)
     ((:application eshell)
      eshell-connection-default-profile)))
 '(connection-local-profile-alist
   '((tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))
     (eshell-connection-default-profile
      (eshell-path-env-list))))
 '(custom-safe-themes
   '("02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" "944d52450c57b7cbba08f9b3d08095eb7a5541b0ecfb3a0a9ecd4a18f3c28948" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00" "60ada0ff6b91687f1a04cc17ad04119e59a7542644c7c59fc135909499400ab8" "a589c43f8dd8761075a2d6b8d069fc985660e731ae26f6eddef7068fece8a414" "51c71bb27bdab69b505d9bf71c99864051b37ac3de531d91fdad1598ad247138" "5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" "2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350" "70b596389eac21ab7f6f7eb1cf60f8e60ad7c34ead1f0244a577b1810e87e58c" "2e05569868dc11a52b08926b4c1a27da77580daa9321773d92822f7a639956ce" "a44e2d1636a0114c5e407a748841f6723ed442dc3a0ed086542dc71b92a87aee" "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a" "443e2c3c4dd44510f0ea8247b438e834188dc1c6fb80785d83ad3628eadf9294" "c865644bfc16c7a43e847828139b74d1117a6077a845d16e71da38c8413a5aaa" "7e377879cbd60c66b88e51fad480b3ab18d60847f31c435f15f5df18bdb18184" "4ff1c4d05adad3de88da16bd2e857f8374f26f9063b2d77d38d14686e3868d8d" "2853dd90f0d49439ebd582a8cbb82b9b3c2a02593483341b257f88add195ad76" "7e068da4ba88162324d9773ec066d93c447c76e9f4ae711ddd0c5d3863489c52" "afa47084cb0beb684281f480aa84dab7c9170b084423c7f87ba755b15f6776ef" "333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "c4063322b5011829f7fdd7509979b5823e8eea2abf1fe5572ec4b7af1dd78519" default))
 '(mouse-wheel-progressive-speed nil)
 '(wakatime-api-key "e84a8cdb-576e-4f1b-a801-134822c60ea2"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-done ((t (:inherit 'fixed-pitch))))
 '(org-ellipsis ((t (:inherit 'fixed-pitch))))
 '(org-level-1 ((t (:height 1.15))))
 '(org-level-2 ((t (:height 1.13))))
 '(org-level-3 ((t (:height 1.11))))
 '(org-level-4 ((t (:height 1.09))))
 '(org-level-5 ((t (:height 1.07))))
 '(org-level-6 ((t (:height 1.05))))
 '(org-level-7 ((t (:height 1.03))))
 '(org-level-8 ((t (:height 1.01))))
 '(org-modern-statistics ((t (:inherit org-checkbox-statistics-todo))))
 '(org-property-value ((t (:inherit 'fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit 'fixed-pitch))))
 '(org-superstar-header-bullet ((t (:height 232 :inherit 'fixed-pitch))))
 '(org-superstar-item ((t (:inherit 'fixed-pitch))))
 '(org-todo ((t (:inherit 'fixed-pitch)))))

(put 'customize-group 'disabled nil)
(put 'projectile-ripgrep 'disabled nil)

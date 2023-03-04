# multi-sync-robocopy
Spiegeleung mehrerer Ordner

## Zweck
Es können mehrere Ordner mittels des Skripts `rcsync_multi_folder.cmd` gespiegelt werden. Diese müssen in der Datei `SourceDest.txt` definiert werden.

Das Skript nutzt `robocopy`, näheres dazu unter

https://learn.microsoft.com/de-de/windows-server/administration/windows-commands/robocopy

Der Aufbau der Datei `SourceDest.txt` sieht folgendermaßen aus:

|#SOURCE;|FILE;|DEST;|LOGF;|SWITCH;|MSG|
|--------|-----|-----|-----|-------|---|
|\\SERVER1\SHARE1$\DIR1;|file1.txt;|C:\DIR1;|logfile1;|/NDL /NP /R:1 /W:1;|kopiere ersten Ordner ...|
|\\SERVER2\SHARE2$\DIR2;|file1.txt;|C:\DIR2;|logfile1;|/NDL /NP /R:1 /W:1;|kopiere zweiten Ordner ...|
|\\SERVER3\SHARE3$\DIR3;|file1.txt;|C:\DIR3;|logfile1;|/NDL /NP /R:1 /W:1;|kopiere dritten Ordner ...|

Soll der ganze Ordner gespiegelt werden, kann statt filen.txt auch das Wildcard-Symbol eingetragen werden

|#SOURCE;|FILE;|DEST;|LOGF;|SWITCH;|MSG|
|--------|-----|-----|-----|-------|---|
|\\SERVER1\SHARE1$\DIR1;|*;|C:\DIR1;|logfile1;|/NDL /NP /R:1 /W:1;|kopiere ersten Ordner ...|

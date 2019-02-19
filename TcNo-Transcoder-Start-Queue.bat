@ECHO OFF
FOR /F "usebackq tokens=*" %%A in ("extra/queue.txt") DO ECHO %%A
PAUSE
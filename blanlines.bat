for /f "usebackq tokens=* delims=" %%a in ("c:\temp\ServerList.txt") do (echo(%%a)>>~.txt
move /y  ~.txt "c:\temp\ServerList.txt"
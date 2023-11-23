var objShell = WSH.CreateObject("Wscript.Shell");
var pattern = /MULTI\(\d+\)DISK\(\d+\)RDISK\(\d+\)PARTITION\(\d+\)/gi;
var startOptions = objShell.RegRead("HKLM\\System\\CurrentControlSet\\Control\\SystemStartOptions");
startOptions = startOptions.replace(pattern, "ramdisk(0)");
objShell.RegWrite("HKLM\\System\\CurrentControlSet\\Control\\SystemStartOptions", startOptions);

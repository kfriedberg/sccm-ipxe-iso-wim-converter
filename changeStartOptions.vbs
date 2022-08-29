Set objShell = Wscript.CreateObject("Wscript.Shell")
Set objRegExp = New RegExp
objRegExp.IgnoreCase = True
objRegExp.Global = True
objRegExp.Pattern = "MULTI\(\d+\)DISK\(\d+\)RDISK\(\d+\)PARTITION\(\d+\)"
startOptions = objShell.RegRead("HKLM\System\CurrentControlSet\Control\SystemStartOptions")
startOptions = objRegExp.Replace(startOptions,"ramdisk(0)")
objShell.RegWrite "HKLM\System\CurrentControlSet\Control\SystemStartOptions",startOptions

# sccm-ipxe-iso-wim-converter
This will convert SCCM ISO task sequence media so that it can be booted using iPXE's wimboot.

1. Place these files somewhere on your local disk.
2. Create a bootable media ISO from the SCCM console.
3. Drag the ISO onto thescript.bat

The script will ask to elevate (dism needs admin rights), and it will generate a .wim file in the same location as the ISO.  This WIM is ready to use with iPXE.

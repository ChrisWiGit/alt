@echo off
REM -- First make map file from Microsoft Visual C++ generated resource.h
echo // MAKEHELP.BAT generated Help Map file.  Used by MESSAGEBOX.HPJ. >"hlp\MessageBox.hm"
echo. >>"hlp\MessageBox.hm"
echo // Commands (ID_* and IDM_*) >>"hlp\MessageBox.hm"
makehm ID_,HID_,0x10000 IDM_,HIDM_,0x10000 resource.h >>"hlp\MessageBox.hm"
echo. >>"hlp\MessageBox.hm"
echo // Prompts (IDP_*) >>"hlp\MessageBox.hm"
makehm IDP_,HIDP_,0x30000 resource.h >>"hlp\MessageBox.hm"
echo. >>"hlp\MessageBox.hm"
echo // Resources (IDR_*) >>"hlp\MessageBox.hm"
makehm IDR_,HIDR_,0x20000 resource.h >>"hlp\MessageBox.hm"
echo. >>"hlp\MessageBox.hm"
echo // Dialogs (IDD_*) >>"hlp\MessageBox.hm"
makehm IDD_,HIDD_,0x20000 resource.h >>"hlp\MessageBox.hm"
echo. >>"hlp\MessageBox.hm"
echo // Frame Controls (IDW_*) >>"hlp\MessageBox.hm"
makehm IDW_,HIDW_,0x50000 resource.h >>"hlp\MessageBox.hm"
REM -- Make help for Project MESSAGEBOX


echo Building Win32 Help files
start /wait hcw /C /E /M "hlp\MessageBox.hpj"
if errorlevel 1 goto :Error
if not exist "hlp\MessageBox.hlp" goto :Error
if not exist "hlp\MessageBox.cnt" goto :Error
echo.
if exist Debug\nul copy "hlp\MessageBox.hlp" Debug
if exist Debug\nul copy "hlp\MessageBox.cnt" Debug
if exist Release\nul copy "hlp\MessageBox.hlp" Release
if exist Release\nul copy "hlp\MessageBox.cnt" Release
echo.
goto :done

:Error
echo hlp\MessageBox.hpj(1) : error: Problem encountered creating help file

:done
echo.

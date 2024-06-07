{
@abstract(dtWindows.pas beinhaltet Funktionen mit dem Umgang mit Windows
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}
unit dtWindows;

interface
uses Windows,Messages,Classes,SysUtils,Forms,Registry,ShellApi,Graphics,Dialogs;

type
   {TOnFindWindowProc wird von @Link(FindWindows) aufgerufen, wenn ein Fenster von FindWindows gefunden wurde.
   WindowText ist der Titeltext, WindowHandle das Fensterhandle. Add gibt an, ob diese Fenster in die Liste aufgenommen werden
   soll (TRUE). Wenn Continue TRUE ist, wird nach dem n�chsten Fenster gesucht.}
   TOnFindWindowProc = procedure (WindowText : String; WindowHandle : HWND; var add,continue : Boolean);
   {TOnFindWindowProc wird von @Link(FindWindows) aufgerufen, wenn ein Fenster von FindWindows gefunden wurde.
   WindowText ist der Titeltext, WindowHandle das Fensterhandle. Add gibt an, ob diese Fenster in die Liste aufgenommen werden
   soll (TRUE). Wenn Continue TRUE ist, wird nach dem n�chsten Fenster gesucht.
   Diese Ereignismethode wird in Klassen verwendet.}
   TOnFindWindowObj = procedure (WindowText : String; WindowHandle : HWND; var add,continue : Boolean) of object;


type
  {Installiert/Registriert eine Datei in Windows mit @Link(RegisterFile) }
  TRegisterFile = record
    FileExtension: string; {Dateierweiterung , die registriert werden soll z.B. : txt}

    Icon: string; {f�r die Dateierweiterung ein Symbol (DefaultIcon)
                         z.B. : C:\Windows\Icon.ico
                                C:\Windows\MoreIcons.dll,_4 {Unterstrich (_) ist ein Leerzeichen!
                                %1 - Die Datei mit der Erweiterung wird als Symbol verwendet
                                }

    Content: string; {ContentTyp : InhaltsTyp}
    Description: string; {Typ-Beschreibung}
    Linked: Boolean; {Nur Verkn�pfung}

    InstallationsCommand: string; {Installationsbefehl : zb. %SystemRoot%\System32\rundll32.exe setupapi,InstallHinfSection DefaultInstall 132 %1}
    Command: string; {Ausf�hrungsdatei : z.B. C:\Windows\notepad.exe %1}
    PrintCommand: string; {Druckkommando : z.B. %SystemRoot%\System32\NOTEPAD.EXE /p %1}
    EditCommand: string; {Kommando zum Editieren}
  end;

{IsAppRunning gibt TRUE zur�ck , wenn es eine Anwendung mit Namen Appnamen
und und Klasse mit ClassName existiert.}
function IsAppRunning(AppName, ClassName: string): Boolean;

{GetAppHandle gibt ein Window_Handle, wenn ein Fenster mit den Applikationsname Appname und Klassname Classname
gefunden wurde. zur�ck}
function GetAppHandle(AppName, ClassName: string): Longint;


{FindWindows z�hlt alle Fenster auf dem Desktop auf und gibt derren Titel in
einer Stringliste zur�ck.
Die Objektliste enth�lt die Fensterhandles als Longint - Pointer
MyHandle := Longint(Windows.Objects[index]);
Als Ereignis OnFindWindowProc wird eine Standard-Prozedur verwendet.
}
function FindWindows(OnFindWindowProc : TOnFindWindowProc): TStringList; overload;

{FindWindows z�hlt alle Fenster auf dem Desktop auf und gibt derren Titel in
einer Stringliste zur�ck.
Die Objektliste enth�lt die Fensterhandles als Longint - Pointer
MyHandle := Longint(Windows.Objects[index]);
Als Ereignis OnFindWindowProc wird eine Methode verwendet}
function FindWindows(OnFindWindowProc : TOnFindWindowObj): TStringList; overload;

{GetParameter gibt True zur�ck , wenn der Parameter Para vom Anwender angegeben wurde.
Gro�- & Kleinschreibung spielt keine Rolle.}
function GetParameter(Para: string): Boolean;

{SetWinOnTop l�sst das Windows mit den Style VS_ALWAYSONTOP darstellen
ohne das es aufblinkt,wie TForm.FormStyle = fsStayOnTop}
procedure SetWinOnTop(Wnd: HWND; OnTop: Boolean);

{ChangeWindowStyle �ndert das WindowStyle (HAndle = WindowHandle) in Style.
N�tzlich f�r EverOnTop, da in Delphi das Fenster flackert}
procedure ChangeWindowStyle(Handle: Longint; Style: Longint);



{Registriert eine Dateierweiterung
Sollte die Dateierweiterung schon existieren wird sie �berschrieben
Sollen mehrere Dateitypen registriert werden , so wird nur einmal der komplette Record definiert (also Command)
und jede weitere neue Erweiterung nur FileExtension und Description (+Icon und Content , wenn erw�nscht)
Dazu noch Linked auf TRUE.
}
function RegisterFile(Regfile: TRegisterFile): Integer;

{Externe Quelle 0001
CreateFileAssociation wie @Link(RegisterFile) , nur mit einfacheren
Extension ist die zu registrierende Erweiterung
als InternalName oder RealName den internen oder den wirklichen Namen und als
ApplicationPath den Pfad Ihrer Andwendung.
Bei Erfolg , ist der R�ckgabewert TRUE.
V1.302}
function CreateFileAssociation(Extension,InternalName, RealName, ApplicationPath: string): Boolean;


{RegisterLink registriert im Explorer/Dateimanager einen Dateityp
Ext beschreibt die Dateiendung mit vorangegangenem Punkt. FType ist der Registriereintragsname
in der Registry (Key). FriendlyName wird dem Benutzer als Beschreibung angezeigt.
Cmd ist der Pfad zu einer Anwendung, die mit dem Dateityp umgehen kann.
Beispiel : ('.~pa','~pafile','PAS-Backups','C:\...DragDrop.exe "%1").  }
procedure RegisterLink(Ext, FType, FriendlyName, Cmd: PChar);

{HideTitlebar l��t die Titel-Bar eines Fensters verschwinden}
procedure HideTitlebar(Window: TCustomForm);

{ShowTitlebar l��t die Titel-Bar eines Fensters anzeigen}
procedure ShowTitlebar(Window: TCustomForm);

{MonitorPower bringt den Bildschirm in den Powersave-modus
(sofern m�glich und zugelassen)}
procedure MonitorPower(Off: Boolean);

{TaskbarAutoHide ermittelt ,ob die Taskleiste sich automatisch versteckt.
Dies entspricht Taskbar-Eigenschaft-"Automatisch im Hintergrund"}
function TaskbarAutoHide: boolean;

{RunCPL startet ein Systemsteurerungsmodul (CPL-Datei) mit dem Namen sName}
function RunCPL(sName: string): Boolean;

{GetAppName ermittelt aus einem Dateinamen dessen verkn�pfte Anwendungsdatei
z.B. f�r TXT-Dateien das NotePad}
function GetAppName(Doc: string): string;

{ExecDOC f�hrt das Anwendungsprogramm mit dem Paramater Doc aus , da�
mit Doc verkn�pft wurde}
function ExecDOC(Doc: string): Boolean;

{RunOnStartup tr�gt eine Anwendung in die Registry-AutoStart-Registrierung ein
bOnlyOnce gibt an , ob diese Anwendung nur einmal bei einem Neustart
gestartet werden soll}
procedure RunOnStartup(sTitle, sCommand: string; bOnlyOnce: Boolean);



{GetClockWndHandle gibt das Fensterhandle der Uhrzeit in der Taskleiste zur�ck}
function GetClockWndHandle: Longint;
{GetClockRect gibt die Gr��e der Uhrzeit zur�ck}
function GetClockRect: TRect;
{GetClockPos gibt die Position der Uhr zur�ck (Bildschirmkoordinaten)}
function GetClockPos: TPoint;

{ShowTaskBar zeigt die Windows-Taskleiste an (TRUE) oder nicht (FALSE)}
procedure ShowTaskBar(Show: Boolean);
{IsShowTaskBar ermittelt , ob die Taskbar sichtbar ist(TRUE)}
function IsShowTaskBar: Boolean;

{TaskBarClientRect gibt die Gr��e der Taskbar zur�ck.}
function TaskBarClientRect: TRect;

{GetRAM gibt die Gr��e der verf�gbaren realen RAM-Speichers zur�ck}
function GetRAM: cardinal;

{ScreenDump kopiert den aktuellen Bildschirm in das Bitmap bit.
bmp muss vorher Initialisiert werden!}
procedure ScreenDump(bmp: TBitmap);

{WinDump kopiert das Fenster Win in das Bitmap bmp.}
procedure WinDump(Win : THandle;bmp: TBitmap);


{EmptyRecycleBin l�scht den Papierkorb ohne Nachfrage}
function EmptyRecycleBin : Boolean;



implementation
uses dtSystem,dtStringsRes;

var AppHandle: Longint = 0;






function IsAppRunning(AppName, ClassName: string): Boolean;
var h1: HWND;
begin
  H1 := FindWindow(PCHAR(ClassName), PCHAR(Appname));
  AppHandle := h1;
  Result := (H1 <> 0);
end;

function GetAppHandle(AppName, ClassName: string): Longint;
var h1: HWND;
begin
  H1 := FindWindow(PCHAR(ClassName), PCHAR(Appname));
  Result := H1;
end;


type PWindowsProcEvent = ^TWindowsProcEvent;
     TWindowsProcEvent = record
       OnFindWindowProc : TOnFindWindowProc;
       OnFindWindowObj  : TOnFindWindowObj;
       List : TStringList;
     end;

function EnumWindowsProc(hwnd: HWND ; lParam : Longint) : Boolean;    stdcall;
{---> FindWindows}
var p : array[0..512] of char;
    ptr : Pointer;
    List : TStringList;
    EV : PWindowsProcEvent;
    add : Boolean;
begin
  result := TRUE;
  EV := PWindowsProcEvent(Pointer(lParam));
  List := EV^.List;
  if not Assigned(List) then exit;
  ptr := Pointer(hwnd);
  GetWindowText(hwnd,p,512);
  add := TRUE;
  if Assigned(EV^.OnFindWindowObj) then
   EV^.OnFindWindowObj(String(p),hwnd,add,result)
  else
   if Assigned(EV^.OnFindWindowProc) then
    EV^.OnFindWindowProc(String(p),hwnd,add,result);

  if add then EV^.List.AddObject(String(p),ptr);
end;

function FindWindows(OnFindWindowProc : TOnFindWindowObj): TStringList;
var EV : ^TWindowsProcEvent;
begin
  GetMem(EV,SizeOf(TWindowsProcEvent));
  Result := TStringList.Create;
  EV^.List := Result;
  EV^.OnFindWindowProc := nil;
  EV^.OnFindWindowObj := OnFindWindowProc;
  EnumWindows(@EnumWindowsProc,Integer(Pointer(EV)));
  FreeMem(EV,SizeOf(TWindowsProcEvent));
end;

function FindWindows(OnFindWindowProc : TOnFindWindowProc): TStringList;
var EV : ^TWindowsProcEvent;
begin
  GetMem(EV,SizeOf(TWindowsProcEvent));
  Result := TStringList.Create;
  EV^.List := Result;
  EV^.OnFindWindowProc := OnFindWindowProc;
  EV^.OnFindWindowObj := nil;
  EnumWindows(@EnumWindowsProc,Integer(Pointer(EV)));
  FreeMem(EV,SizeOf(TWindowsProcEvent));
end;

function GetParameter(Para: string): Boolean;
var i: Integer;
begin
  for i := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(i)) = UpperCase(Para) then
    begin
      Result := TRUE;
      exit;
    end;
  end;
  Result := FALSE;
end;

procedure SetWinOnTop(Wnd: HWND; OnTop: Boolean);
begin
  if OnTop then
    SetWindowPos(Wnd, HWND_TOPMOST, -1, -1, -1, -1, SWP_NOMOVE + SWP_NOSIZE)
  else
    SetWindowPos(Wnd, HWND_NOTOPMOST, -1, -1, -1, -1, SWP_NOMOVE + SWP_NOSIZE)
end;

procedure ChangeWindowStyle(Handle: Longint; Style: Longint);
var r: HRGN;
  l: Longint;
  rect: TRECT;
begin
  l := GetWindowLong(Handle, GWL_STYLE);
  if l and Style = Style then
    l := l - Style
  else
    l := l + Style;

  GetWindowRect(Handle, rect);

  SetWindowLong(Handle, GWL_STYLE, l);
  R := CreateRectRgn(rect.Left, rect.Top, rect.Left + rect.Right, rect.Top +
    rect.Bottom);
  SendMessage(Handle, WM_NCPAINT, r, 0);
end;

function RegisterFile(Regfile: TRegisterFile): Integer;
var Reg: TRegistry;
    y: string;
begin
  ASSERT(Length(RegFile.FileExtension) <> 0, 'FileExtension darf nicht leer sein');
  ASSERT(Length(RegFile.Description) <> 0, 'FileExtension darf nicht leer sein');

  reg := TRegistry.Create;
  reg.RootKey := HKEY_CLASSES_ROOT;
  Reg.DeleteKey('.' + RegFile.FileExtension);
  Assert(Reg.OpenKey('.' + RegFile.FileExtension, TRUE));
  Reg.WriteString('', RegFile.Description);

  if Length(RegFile.Content) <> 0 then
  begin
    Reg.WriteString('Content Type', RegFile.Content);
  end;

  Reg.CloseKey;

  if RegFile.Linked and (Length(RegFile.Icon) <> 0) then
  begin
    ASSERT(Reg.Openkey('.' + RegFile.FileExtension + '\DefaultIcon', TRUE));
    Reg.WriteString('', RegFile.Icon);
    Reg.CloseKey;
  end;


  if (not Reg.KeyExists(RegFile.Description)) and (not Regfile.Linked) then
  begin
    Reg.DeleteKey(RegFile.Description);
    ASSERT(Reg.Openkey(RegFile.Description, TRUE));
    Reg.WriteString('', RegFile.Description);
    Reg.CloseKey;
  end;



  if not RegFile.Linked then
  begin
    if Length(RegFile.Icon) <> 0 then
    begin
      ASSERT(Reg.Openkey(RegFile.Description + '\DefaultIcon', TRUE));
      Reg.WriteString('', RegFile.Icon);
      Reg.CloseKey;
    end;

    ASSERT(Reg.CreateKey(RegFile.Description + '\Shell'));



    if Length(RegFile.Command) <> 0 then
    begin
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Open', TRUE));
      Reg.WriteString('', '&Oeffnen');
      Reg.CloseKey;
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Open\Command', TRUE));
      Reg.WriteString('', RegFile.Command);
      Reg.CloseKey;
    end;

    if Length(RegFile.InstallationsCommand) <> 0 then
    begin
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Install', TRUE));
      Reg.WriteString('', '&Installieren');
      Reg.CloseKey;
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Install\Command', TRUE));
      Reg.WriteString('', RegFile.InstallationsCommand);
      Reg.CloseKey;
    end;

    if Length(RegFile.PrintCommand) <> 0 then
    begin
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Print', TRUE));
      Reg.WriteString('', '&Drucken');
      Reg.CloseKey;
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Print\Command', TRUE));
      Reg.WriteString('', RegFile.PrintCommand);
      Reg.CloseKey;
    end;

    if Length(RegFile.EditCommand) <> 0 then
    begin
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Edit', TRUE));
      Reg.WriteString('', '&Bearbeiten');
      Reg.CloseKey;
      ASSERT(Reg.OpenKey(RegFile.Description + '\Shell\Edit\Command', TRUE));
      Reg.WriteString('', RegFile.EditCommand);
      Reg.CloseKey;
    end;
  end;


  reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Control Panel\desktop\WindowMetrics', TRUE) then
  begin
    y := Reg.ReadString('Shell Icon Size');
    reg.WriteString('Shell Icon Size', '0');
    SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, 0);
    reg.WriteString('Shell Icon Size', y);
    SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, 0);
    SendMessage(HWND_BROADCAST, WM_DEVICECHANGE, 0, 0);
    reg.Closekey;
  end;
  Result := 0;

  reg.Free;
end;

function CreateFileAssociation(Extension,
  InternalName, RealName, ApplicationPath: string): Boolean;
var
  Reg: TRegistry;
begin
  if (Length(Extension) > 0) and (Length(InternalName) > 0) and
    (Length(RealName) > 0) and (Length(ApplicationPath) > 0) then
  begin
    // Evtl. Punkt am Anfang hinzuf�gen
    if (Extension[1] <> '.') then Extension := '.' + Extension;

    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CLASSES_ROOT;
      if Reg.OpenKey(Extension, True) then
      begin
        try
          // Internen Namen setzen
          Reg.WriteString('', InternalName);
        finally
          Reg.CloseKey;
        end;

        if Reg.OpenKey(InternalName, True) then
        begin
          try
            // Realen Namen setzen
            Reg.WriteString('', RealName);

            if Reg.OpenKey('shell', True) then
            begin
              try
                if Reg.OpenKey('open', True) then
                begin
                  try
                    if Reg.OpenKey('command', True) then
                    begin
                      try
                        // Pfad der Anwendung eintragen
                        Reg.WriteString('', ApplicationPath);
                        Result := True;
                      finally
                        Reg.CloseKey;
                      end;
                    end else
                      Result := False;
                  finally
                    Reg.CloseKey;
                  end;
                end else
                  Result := False;
              finally
                Reg.CloseKey;
              end;
            end else
              Result := False;
          finally
            Reg.CloseKey;
          end;
        end else
          Result := False;
      end else
        Result := False;
    finally
      Reg.Free;
    end;
  end else
    Result := False;
end;

procedure RegisterLink(Ext, FType, FriendlyName, Cmd: PChar);
var key: HKey; SZEntry: array[0..255] of Char; SZSize: Longint;
begin
  if RegOpenKey(HKEY_CLASSES_ROOT, Ext, Key) = ERROR_SUCCESS then
  begin
    SZSize := SizeOf(SZEntry);
    RegQueryValue(Key, '', SZEntry, SZSize);
    StrCat(SZEntry, '\Shell\Open\Command');
    if RegOpenKey(HKEY_CLASSES_ROOT, SZEntry, Key) = ERROR_SUCCESS then
    begin
      SZSize := SizeOf(SZEntry);
      RegQueryValue(Key, '', SZEntry, SZSize);
      if (StrIComp(SZEntry, Cmd) = 0) and (MessageDlg('Die Dateierweiterung "' + StrPas(Ext) + '" ist ' +
        'bereits mit dem Befehl ' + StrPas(SZEntry) + ' verkn�pft. ' +
        '�berschreiben?', mtConfirmation, [mbyes, mbNo], 0) = ID_YES) then exit;
    end;
  end;
  RegCreateKey(HKEY_CLASSES_ROOT, Ext, Key);
  RegSetValue(Key, '', REG_SZ, FType, StrLen(FType));
  RegCreateKey(HKEY_CLASSES_ROOT, FType, Key);
  RegSetValue(Key, '', REG_SZ, FriendlyName, StrLen(FriendlyName));
  StrCat(StrCopy(SZEntry, FType), '\Shell\Open\Command');
  RegCreateKey(HKEY_CLASSES_ROOT, SZEntry, Key);
  RegSetValue(Key, '', REG_SZ, Cmd, StrLen(Cmd));
end;

procedure HideTitlebar(Window: TCustomForm);
var
  Save: LongInt;
begin
  if Window.BorderStyle = bsNone then Exit;
  Save := GetWindowLong(Window.Handle, gwl_Style);
  if (Save and ws_Caption) = ws_Caption then begin
    case Window.BorderStyle of
      bsSingle,
        bsSizeable: SetWindowLong(Window.Handle, gwl_Style, Save and
          (not (ws_Caption)) or ws_border);
      bsDialog: SetWindowLong(Window.Handle, gwl_Style, Save and
          (not (ws_Caption)) or ds_modalframe or ws_dlgframe);
    end;
    Window.Height := Window.Height - getSystemMetrics(sm_cyCaption);
    Window.Refresh;
  end;
end;

procedure ShowTitlebar(Window: TCustomForm);
var
  Save: LongInt;
begin
  if Window.BorderStyle = bsNone then Exit;
  Save := GetWindowLong(Window.Handle, gwl_Style);
  if (Save and ws_Caption) <> ws_Caption then begin
    case Window.BorderStyle of
      bsSingle,
        bsSizeable: SetWindowLong(Window.Handle, gwl_Style, Save or
          ws_Caption or ws_border);
      bsDialog: SetWindowLong(Window.Handle, gwl_Style, Save or
          ws_Caption or ds_modalframe or ws_dlgframe);
    end;
    Window.Height := Window.Height + getSystemMetrics(sm_cyCaption);
    Window.Refresh;
  end;
end;

procedure MonitorPower(Off: Boolean);
begin
  if Off then
    SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, 0)
  else
    SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, -1)
end;

function TaskbarAutoHide: boolean;
var TB: TAppBarData;
begin
  TB.cbSize := sizeof(TB);
  Result :=
    (SHAppBarMessage(ABM_GETSTATE, TB)
    and ABS_AUTOHIDE) > 0;
end;

function RunCPL(sName: string): Boolean;
begin
  Result :=
    WinExec(
    PChar('rundll32.exe shell32.dll,' +
    'Control_RunDLL ' + sName),
    SW_SHOWNORMAL) > 32;
end;

function GetAppName(Doc: string): string;
var FN, DN, RES: array[0..255] of Char;
begin
  StrPCopy(FN, DOC);
  DN[0] := #0; RES[0] := #0;
  FindExecutable(FN, DN, RES);
  Result := StrPas(RES);
end;

function ExecDOC(Doc: string): Boolean;
var DN: array[0..255] of Char;
begin
  StrPCopy(DN, DOC);
  Result := ShellExecute(0, 'open', DN, nil, nil, SW_SHOWNormal) > 32;
end;

procedure RunOnStartup(sTitle, sCommand: string; bOnlyOnce: Boolean);
var
  sKey: string;
begin
  if (bOnlyOnce) then
    sKey := 'RunOnce'
  else
    sKey := 'Run';

  with TRegistry.Create do begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft'
      + '\Windows\CurrentVersion\' + sKey, False);
    WriteString(sTitle, sCommand);
    Free;
  end;
end;

function GetClockRect: TRect;
var h: Longint;
  r: TRect;
  p: TPoint;
begin
  h := GetClockWndHandle;
  GetWindowRect(H, R);
  p.x := r.Left;
  p.y := r.Top;
  Windows.ScreenToClient(H, p);
  r.Left := p.x;
  r.Top := p.y;

  p.x := r.Right;
  p.y := r.Bottom;
  Windows.ScreenToClient(H, p);
  r.Right := p.x;
  r.Bottom := p.y;
  result := r;
end;

function GetClockPos: TPoint;
var h: Longint;
  r: TRect;
begin
  h := GetClockWndHandle;
  GetWindowRect(H, R);
  Result.x := R.Left;
  Result.y := R.Top;
end;


function GetClockWndHandle: Longint;
var H_Shell_TrayWnd,
  H_TrayNotifyWnd,
    H_TrayClockWClass: Longint;
begin
  H_Shell_TrayWnd := GetAppHandle('', 'Shell_TrayWnd');
  H_TrayNotifyWnd := FindWindowEx(H_Shell_TrayWnd, 0, PCHAR('TrayNotifyWnd'), nil);
  H_TrayClockWClass := FindWindowEx(H_TrayNotifyWnd, 0, PCHAR('TrayClockWClass'), nil);
  Result := H_TrayClockWClass;
end;

procedure ShowTaskBar(Show: Boolean);
var TaskBarHandle: Integer;
begin
  TaskBarHandle := FindWindow('Shell_TrayWnd', nil);
  if Show then
    ShowWindow(TaskBarHandle, SW_SHOW)
  else
    ShowWindow(TaskBarHandle, SW_HIDE);
end;

function IsShowTaskBar: Boolean;
var TaskBarHandle: Integer;
begin
  TaskBarHandle := FindWindow('Shell_TrayWnd', nil);
  Result := GetWindowLong(TaskBarHandle, GWL_STYLE) and WS_VISIBLE = WS_VISIBLE;
end;

function TaskBarClientRect: TRect;
var TaskBarHandle: Integer;
begin
  TaskBarHandle := FindWindow('Shell_TrayWnd', nil);
  GetWindowRect(TaskBarHandle, Result);
end;

function GetRAM: cardinal;
var
  MemBuf: _MEMORYSTATUS;
begin
  MemBuf.dwLength := sizeof(MemBuf);
  GlobalMemoryStatus(MemBuf);
  GetRAM := MemBuf.dwTotalPhys div 1000000;
  //1048576;
end;

procedure WinDump(Win : THandle;bmp: TBitmap);
var
  DESKWND: HWND;
  DeskDC: HDc;
  DeskCV: TCanvas;
  R: Trect;
  w, h: Integer;
begin
  if not Assigned(bmp) then exit;

  DeskWnd := Win;
  DeskDC := GetWindowDC(DeskWnd);
  DeskCV := TCanvas.Create;
  DeskCV.Handle := DeskDC;
  W := Screen.Width;
  H := Screen.Height;
  R := Bounds(0, 0, w, h);
  try
    bmp.handletype := bmdib;
    bmp.Pixelformat := pf24bit;
    bmp.Width := w;
    bmp.Height := h;
    bmp.Canvas.CopyMode := cmsrccopy;
    bmp.Canvas.CopyRect(r, deskcv, r);
  finally
    deskcv.free;
    releasedc(deskwnd, DeskDC)
  end;
end;

procedure ScreenDump(bmp: TBitmap);
var
  DESKWND: HWND;
  DeskDC: HDc;
  DeskCV: TCanvas;
  R: Trect;
  w, h: Integer;
begin
  if not Assigned(bmp) then exit;

  DeskWnd := GetDesktopWindow;
  DeskDC := GetWindowDC(DeskWnd);
  DeskCV := TCanvas.Create;
  DeskCV.Handle := DeskDC;
  W := Screen.Width;
  H := Screen.Height;
  R := Bounds(0, 0, w, h);
  try
    bmp.handletype := bmdib;
    bmp.Pixelformat := pf24bit;
    bmp.Width := w;
    bmp.Height := h;
    bmp.Canvas.CopyMode := cmsrccopy;
    bmp.Canvas.CopyRect(r, deskcv, r);
  finally
    deskcv.free;
    releasedc(deskwnd, DeskDC)
  end;
end;

function EmptyRecycleBin : Boolean;
Const
  SHERB_NOCONFIRMATION = $00000001 ;
  SHERB_NOPROGRESSUI   = $00000002 ;
  SHERB_NOSOUND        = $00000004 ;
Type
  TSHEmptyRecycleBin = function (Wnd : HWND;
                                 pszRootPath : PChar;
                                 dwFlags : DWORD):
                             HRESULT; stdcall ;
Var
  SHEmptyRecycleBin : TSHEmptyRecycleBin;
  LibHandle         : THandle;
Begin
  result := TRUE;
  LibHandle := LoadLibrary(PChar('Shell32.dll')) ;
  if LibHandle <> 0 then
    @SHEmptyRecycleBin:= GetProcAddress(LibHandle,
                                    'SHEmptyRecycleBinA')
  else
    begin
      result := FALSE;
      Exit;
    end;

  if @SHEmptyRecycleBin <> nil then
     SHEmptyRecycleBin(Application.Handle,
                       nil,
                       SHERB_NOCONFIRMATION or {Keine Abfrage}
                       SHERB_NOPROGRESSUI or SHERB_NOSOUND);
  FreeLibrary(LibHandle);
  @SHEmptyRecycleBin := nil ;
end;

end.

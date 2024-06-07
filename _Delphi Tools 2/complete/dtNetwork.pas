{
@abstract(dtDataBase.pas beinhaltet Funktionen f�r den Umgang mit Netzwerken und Internet)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}


unit dtNetwork;

interface
uses Windows,Classes,SysUtils,WinSock;

type
    {TIPResult wird nicht mehr verwendet und besteht nur noch wegen der Abw�rtskompatibilit�t}
    TIPResult = (ipr_ok,ipr_InvalidIP,ipr_InvalidPort);

    {TIPData wird von @link(GetIPData) verwendet, um IP-Addressen (nicht v6!) n�her darzustellen.
    s1 bis s4 stellen die einzelnen IP-Segmente als Integer dar.
    Port den Kommunikationsport, der hinter manchen IPs durch ein ":" getrennt wird.
    Bin die IP-Addresse als Bin�re schreibweise}
    TIPData = record
       s1,s2,s3,s4 : Integer;
       port : Integer;
       bin : Integer;
     end;

{IsNetworkPath pr�ft, ob es sich bei dem Pfad: Path um ein Netzwerklaufwerkt handelt,
und gibt bei Erfolg TRUE zur�ck.}
function IsNetworkPath(Path : String) : Boolean;

{GetComputerName liefert den Computername (angemeldeter Netzwerkname) zur�ck}
function GetComputerName: string;

{CreateNetConnection
Erstellt eine Dateisystemverbindung zu einem anderen Computer im Netzwerk
LocalName ist der Festplattenpfad auf dem Client-rechner (von dem die funktion aufgerufen wird) : Bsp. M:
RemoteName ist ein UNC-Pfad der auf den Host-rechner zeigt : \\Host\Platte
Comment ist ein beliebieger Name welcher der Zuweisung zugewiesen wird
Username ist ein Name , der als Zugriffsname zum Hostrechner verwendet wird
ist Username = '' , wird der Standardbenutzername des Computers verwendet
UserPassword ist ein Zugriffspasswort auf die Resource
ist UserPassword = '' , wird das StandardPassword des Computers verwendet
Flags definiert die Verwendungsart der Resource

Funktionsergebnisse siehe in der WinAPI-SDK unter WNetAddConnection2}
function CreateNetConnection(LocalName, RemoteName, Comment, UserName, UserPassword: string; Flags: DWord): DWord;

{Trennt eine mit @link(CreateNetConnection) aufgebaute Netzwerk-Verbindung
Parameter siehe CreateNetConnection
Force gibt an , ob die Resource auch dann gekappt werden soll,
wenn noch offene Verbindungen (offene Dateien) bestehen
Funktionsergebnisse siehe in der WinAPI-SDK unter WNetCancelConnection2}
function DisconnetNetConnection(LocalName: string; Flags: DWord; Force: Boolean): DWord;

{ConnectNetDialog zeigt einen StandardWindows-Verbindungsdialog an
mehr unter WNetConnectionDialog}
function ConnectNetDialog(Parent: Longint; fType: DWord = RESOURCETYPE_DISK): DWord;

{Zeigt einen Cancel-Verbindungsdialog an
Mehr siehe in der WinAPI-SDK unter  WNetDisconnectDialog}
function DisConnectNetDialog(Parent: Longint; fType: DWord = RESOURCETYPE_DISK): DWord;

{GetLocalIPs bringt alle auf dem lokalen Computer verwendete IP-Addressen in einen String unter (druch Leerzeichen getrennt)
z.b. Lokal-Netzwerk-IP oder Internet - IP}
function GetLocalIPs: string;

{�berpr�ft, ob es sich bei der IP-Addresse um eine "g�ltige" Addresse handelt.
Dabei wird nicht untersucht, ob die IP-Addressen benutzt werden, sondern lediglich
ihre Glieder innerhalb von 255 befinden.
}
function CheckIP(IP : String) : Boolean;

{Wandelt einen IP-String in einen Record um
siehe @link(TIPData)
}
function GetIPData(IP : String) : TIPData;

implementation
uses dtSystem,dtFiles,dtStrings,dtStringsRes;

function IsNetworkPath(Path : String) : Boolean;
var p : String;
begin
  p := ExpandUNCFileName(Path);
  if pos('\\',p) > 0 then
   result := TRUE
  else
  begin //nur zur Sicherheit , falls es sich um ein anderes gemapptes Remote-Laufwerk handeln sollte
     P := ExtractFileDrive(Path);
     if Length(p) = 0 then raise Exception.Create('Invalid path');
     result := dtFiles.GetDriveType(p[1]) = DRIVE_REMOTE;
  end;
end;

function GetComputerName: string;
var p: array[0..CharBufferLen] of char;
  s: Cardinal;
begin
  FillChar(p, SizeOf(p), 0);
  s := CharBufferLen;
  try
    Windows.GetComputerName(p, s);
  except
  end;
  Result := string(p);
end;

function CreateNetConnection(LocalName, RemoteName, Comment,
  UserName, UserPassword: string; Flags: DWord): DWord;
var NetResource: TNetResource;
begin
  with NetResource do
  begin
    dwScope := RESOURCE_GLOBALNET;
    dwType := RESOURCETYPE_DISK;
    dwDisplayType := RESOURCEDISPLAYTYPE_GENERIC;
    dwUsage := RESOURCEUSAGE_CONNECTABLE;
    lpLocalName := PCHAR(LocalName); //Laufwerksbuchstabe
    lpRemoteName := PCHAR(RemoteName);
    lpComment := PCHAR(Comment); ;
    lpProvider := nil;
  end;
  Result := WNetAddConnection2(NetResource, PCHAR(UserPassword), PCHAR(UserName), Flags);
end;

function DisconnetNetConnection(LocalName: string; Flags: DWord; Force: Boolean): DWord;
begin
  Result := WNetCancelConnection2(PCHAR(LocalName), Flags, Force);
end;

function ConnectNetDialog(Parent: Longint; fType: DWord = RESOURCETYPE_DISK): DWord;
begin
  Result := WNetConnectionDialog(Parent, fType);
end;

function DisConnectNetDialog(Parent: Longint; fType: DWord = RESOURCETYPE_DISK): DWord;
begin
  Result := WNetDisconnectDialog(Parent, fType);
end;

function GetIPData(IP : String) : TIPData;

function GetIP(s : String) : TIPData;
var p : Integer;
    str : String;

function Get(var s : String) : Integer;
var p : Integer;
begin
  p := pos('.',s);
  if p > 0 then
  begin
    result := StrToIntDef(Copy(s,1,p-1),-1);
    Delete(s,1,p);
  end
  else
   result := -1;
end;

begin
  p := pos(':',s);
  if p <= 0 then p := Length(s)+1;
  str := copy(s,1,p-1);
  str := DelSpaces(Str)+'.';


  result.s1 := Get(str);
  result.s2 := Get(str);
  result.s3 := Get(str);
  result.s4 := Get(str);
end;

function GetServerPort(s : String): Integer;
var p : Integer;
begin
  p := pos(':',s);
  if p <= 0 then
   result := -1
  else
  begin
    s := copy(s,p+1,length(S));
    s := DelSpaces(s);
    result := StrToIntDef(s,-1);
  end;
end;

begin
  result := GetIP(IP);
  result.Port := GetServerPort(IP);
end;

function GetLocalIPs: string;
type PPInAddr = ^PInAddr;
var wsaData: TWSAData;
  HostInfo: PHostEnt;
  HostName: array[0..255] of Char;
  Addr: PPInAddr;
begin
  Result := '';
  if WSAStartup($0102, wsaData) <> 0 then exit;
  try
    if gethostname(HostName, SizeOf(HostName)) <> 0 then exit;

    HostInfo := gethostbyname(HostName);

    if HostInfo = nil then Exit;

    Addr := Pointer(HostInfo^.h_addr_list);

    if (Addr = nil) or (Addr^ = nil) then exit;

    Result := StrPas(inet_ntoa(Addr^^));
    inc(Addr);
    while Addr^ <> nil do
    begin
      Result := Result + ^M^J+ StrPas(inet_ntoa(Addr^^));
      inc(Addr);
    end;
  finally
    WSACleanup;
  end;
end;

function CheckIP(IP : String) : Boolean;
var p : TIPData;
begin
  p := GetIPData(IP);
  result := (p.s1 >= 0) and (p.s1 <= 255) and
     (p.s2 >= 0) and (p.s2 <= 255) and
     (p.s3 >= 0) and (p.s3 <= 255) and
     (p.s4 >= 0) and (p.s4 <= 255) and
     (P.Port >= 0) and (P.Port <= High(Word));
end;

end.

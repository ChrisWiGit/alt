{
@abstract(dtRegistry.pas beinhaltet  Funktionen f�r den Umgang mit der Windows Registry)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtRegistry;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Registry;

type {TKEY ist ein Delphi-Typ, der den unflexiblen HKEY-Typ kopiert}
     TKEY = (TKEY_CLASSES_ROOT, TKEY_CURRENT_USER, TKEY_LOCAL_MACHINE,
             TKEY_USERS, TKEY_CURRENT_CONFIG, TKEY_DYN_DATA,
             TKEY_ERROR //304
             );

type
   {TFontData enth�lt die Daten eines Fonts, die in einem Stream gespeichert werden.
   Die Bezeichner sind dieselben, wie in TFont.}
   TFontData = record
    Checked: boolean;
    Indent: ShortString;

    Charset: TFontCharset;
    Color: TColor;
    Height: Integer;
    Name: ShortString;
    Pitch: TFontPitch;
    PixelsPerInch: Integer;
    Size: Integer;
    Style: set of TFontStyle;
  end;

{TKeyToHKey wandelt ein @link(TKey)-Typ in ein HKEY}
function TKeyToHKey(key: TKey): HKEY;
{HKeyToTKey wandelt ein HKEY-Typ in ein @link(TKey)}
function HKeyToTKey(Key: HKey): TKey;

{ExtractRegStr extrahiert aus dem Registry-Pfad RegStr den Schl�ssel (TKey) und den reinen Pfad}
procedure ExtractRegStr(RegStr : String; var Reg : TKey; var Key : String); //304

{Behandlungen f�r den schnellen Zugriff auf die Registry.
WriteRegString schreibt einen String in die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function WriteRegString(Root: TKEY; Key, Name, Value: string): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegString liest einen String aus die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegString(Root: TKEY; Key, Name: string; var Value: string): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegStringDef liest einen String aus die Registry, und gibt im Fehlerfall
Default zur�ck.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegStringDef(Root: TKEY; Key, Name: string; Default: string): string;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
WriteRegInt schreibt einen Integer in die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function WriteRegInt(Root: TKEY; Key, Name: string; Value: Integer): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegInt liest einen Integer aus die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegInt(Root: TKEY; Key, Name: string; var Value: Integer): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegIntDef liest einen Integer aus die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegIntDef(Root: TKEY; Key, Name: string; Default: Integer): Integer;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
WriteRegFloat schreibt einen Double in die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function WriteRegFloat(Root: TKEY; Key, Name: string; Value: Double): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegFloat liest einen Double aus die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegFloat(Root: TKEY; Key, Name: string; var Value: Double): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegFloatDef liest einen Double aus die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegFloatDef(Root: TKEY; Key, Name: string; Default: Double): Double;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
WriteRegBinary schreibt Bin�rwerte in die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function WriteRegBinary(Root: TKEY; Key, Name: string; var Buffer; BufSize: Integer): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegBinary liest Bin�rwere aus die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegBinary(Root: TKEY; Key, Name: string; var Buffer; BufSize: Integer): Boolean;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
DeleteKey l�scht einen Schl�ssel unwiderruflich.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function DeleteKey(Root: TKEY; Key: string): boolean;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
DeleteKey l�scht einen Wert unwiderruflich.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function DeleteValue(Root: TKEY; Key,Value: string): boolean;


{FontToRec wandelt die Klasse TFont in den Record @link(TFontData) um.}
function FontToRec(Font: TFont): TFontData;

{RecToFont wandelt den Record @link(TFontData) in die Klasse TFont um.}
procedure RecToFont(Rec: TFontData; Font: TFont);

{Behandlungen f�r den schnellen Zugriff auf die Registry.
WriteRegFont schreibt ein Font in die Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function WriteRegFont(Root: TKEY; Key, Name: string; Font: TFont): Boolean;
{Behandlungen f�r den schnellen Zugriff auf die Registry.
ReadRegFont liest ein Font aus der Registry.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ReadRegFont(Root: TKEY; Key, Name: string; Font: TFont): Boolean;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
ExistsValue �berpr�ft, ob ein Wert in der Registry vorhanden ist.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ExistsValue(Root: TKEY; Key, Name: string): Boolean;

{Behandlungen f�r den schnellen Zugriff auf die Registry.
ExistsValue �berpr�ft, ob ein Schl�ssel in der Registry vorhanden ist.
Der R�ckgabewert ist im Erfolgsfall TRUE.}
function ExistsKey(Root: TKEY; Key: string): Boolean;

implementation
uses dtSystem,dtStringsRes;


function HKeyToTKey(Key: HKey): TKey;
begin
  case key of
    HKEY_CLASSES_ROOT: Result := TKEY_CLASSES_ROOT;
    HKEY_CURRENT_USER: Result := TKEY_CURRENT_USER;
    HKEY_LOCAL_MACHINE: Result := TKEY_LOCAL_MACHINE;
    HKEY_USERS: Result := TKEY_USERS;
    HKEY_CURRENT_CONFIG: Result := TKEY_CURRENT_CONFIG;
    HKEY_DYN_DATA: Result := TKEY_DYN_DATA;
  else
    raise Exception.Create('Ung�ltiger Wert f�r HKEY.');
  end;
end;

function TKeyToHKey(key: TKey): HKEY;
begin
  Result := HKEY_CLASSES_ROOT;
  case key of
    TKEY_CLASSES_ROOT: Result := HKEY_CLASSES_ROOT;
    TKEY_CURRENT_USER: Result := HKEY_CURRENT_USER;
    TKEY_LOCAL_MACHINE: Result := HKEY_LOCAL_MACHINE;
    TKEY_USERS: Result := HKEY_USERS;
    TKEY_CURRENT_CONFIG: Result := HKEY_CURRENT_CONFIG;
    TKEY_DYN_DATA: Result := HKEY_DYN_DATA;
  end;
end;

procedure ExtractRegStr(RegStr : String; var Reg : TKey; var Key : String);
function GetTKey : TKey;
function GetBackSlash : Integer;
var p : Integer;
begin
  p := pos('\',RegStr);
  if p = 0 then
   result := Length(RegStr)
  else
   result := p;
end;
begin
  if pos('HKEY_CURRENT_USER',UpperCase(RegStr)) < GetBackSlash then
   result := TKEY_CURRENT_USER
  else
  if pos('HKEY_CLASSES_ROOT',UpperCase(RegStr)) < GetBackSlash then
   result := TKEY_CLASSES_ROOT
  else
  if pos('HKEY_LOCAL_MACHINE',UpperCase(RegStr)) < GetBackSlash then
   result := TKEY_LOCAL_MACHINE
  else
  if pos('HKEY_USERS',UpperCase(RegStr)) < GetBackSlash then
   result := TKEY_USERS
  else
  if pos('HKEY_CURRENT_CONFIG',UpperCase(RegStr)) < GetBackSlash then
   result := TKEY_CURRENT_CONFIG
  else
  if pos('HKEY_DYN_DATA',UpperCase(RegStr)) < GetBackSlash then
   result := TKEY_DYN_DATA
  else
   result := TKEY_ERROR;
end;
var p : Integer;
begin
  Reg := GetTKey;
  Key := '';
  p := pos('\',RegStr);
  if p = 0 then exit;
  Key := Copy(RegStr,p+1,Length(RegStr));
  if Key[Length(Key)] = '\' then Delete(Key,Length(Key),1);
end;

function WriteRegString(Root: TKEY; Key, Name, Value: string): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, TRUE);
  if Result then
  begin
    Reg.WriteString(Name, Value);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function ExistsKey(Root: TKEY; Key: string): Boolean;
var Reg: TRegistry;
  Res: Boolean;
begin
  Result := FALSE;
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Res := Reg.OpenKey(Key, FALSE);
  Result := res;
  Reg.Free;
end;

function ExistsValue(Root: TKEY; Key, Name: string): Boolean;
var Reg: TRegistry;
  Res: Boolean;
begin
  Result := FALSE;
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Res := Reg.OpenKey(Key, FALSE);
  if Res then
  begin
    if Reg.ValueExists(Name) then Result := TRUE;
    Reg.CloseKey;
  end;
  Reg.Free;
end;


function ReadRegInt(Root: TKEY; Key, Name: string; var Value: Integer): Boolean;
var Reg: TRegistry;
  s: Integer;
begin
  s := Value;
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, FALSE);
  if Result then
  begin
    try
      Value := Reg.ReadInteger(Name);
    except
      Value := s;
    end;
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function ReadRegIntDef(Root: TKEY; Key, Name: string; Default: Integer): Integer;
var s: Integer;
  b: Boolean;
begin
  s := Default;
  try
    b := ReadRegInt(Root, Key, Name, s);
  except
  end;
  Result := s;
end;

function WriteRegFloat(Root: TKEY; Key, Name: string; Value: Double): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, TRUE);
  if Result then
  begin
    Reg.WriteFloat(Name, Value);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function ReadRegFloat(Root: TKEY; Key, Name: string; var Value: Double): Boolean;
var Reg: TRegistry;
  s: Double;
begin
  s := Value;
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, FALSE);
  if Result then
  begin
    try
      Value := Reg.ReadFloat(Name);
    except
      Value := s;
    end;
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function ReadRegFloatDef(Root: TKEY; Key, Name: string; Default: Double): Double;
var s: Double;
  b: Boolean;
begin
  s := Default;
  try
    b := ReadRegFloat(Root, Key, Name, s);
  except
  end;
  Result := s;
end;


function WriteRegInt(Root: TKEY; Key, Name: string; Value: Integer): Boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, TRUE);
  if Result then
  begin
    Reg.WriteInteger(Name, Value);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function ReadRegStringDef(Root: TKEY; Key, Name: string; Default: string): string;
var s: string;
  b: Boolean;
begin
  s := Default;
  b := ReadRegString(Root, Key, Name, s);
  Result := s;
end;

function ReadRegString(Root: TKEY; Key, Name: string; var Value: string): Boolean;
var Reg: TRegistry;
  s: string;
begin
  s := Value;
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, FALSE);
  if Result then
  begin
    Value := Reg.ReadString(Name);
    if Length(Value) = 0 then Value := s;
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function FontToRec(Font: TFont): TFontData;
begin
  with Result do
  begin
    Charset := Font.CharSet;
    Color := Font.Color;
    Height := Font.Height;
    Name := Font.Name;
    Pitch := Font.Pitch;
    PixelsPerInch := Font.PixelsPerInch;
    Size := Font.Size;
    Style := Font.Style;
  end;
end;

procedure RecToFont(Rec: TFontData; Font: TFont);
begin
  with Rec do
  begin
    Font.Charset := CharSet;
    Font.Color := Color;
    Font.Height := Height;
    Font.Name := Name;
    Font.Pitch := Pitch;
    Font.PixelsPerInch := PixelsPerInch;
    Font.Size := Size;
    Font.Style := Style;
  end;
end;

function WriteRegFont(Root: TKEY; Key, Name: string; Font: TFont): Boolean;
var Reg: TRegistry;
  d: TFontData;

begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, TRUE);
  if Result then
  begin
    d := FontToRec(Font);
    Reg.WriteBinaryData(Name, d, sizeof(d));
    //Reg.WriteString(Name,Value);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function ReadRegFont(Root: TKEY; Key, Name: string; Font: TFont): Boolean;
var Reg: TRegistry;
  d: TFontData;

begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, FALSE);
  if Result then
  begin

    if Reg.ReadBinaryData(Name, d, sizeof(d)) = SizeOf(d) then
     RecToFont(d, Font);
    //Reg.WriteString(Name,Value);
    Reg.CloseKey;

  end;
  Reg.Free;
end;


function WriteRegBinary(Root: TKEY; Key, Name: string; var Buffer; BufSize: Integer): Boolean;

var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, TRUE);
  if Result then
  begin
    Reg.WriteBinaryData(Name, Buffer, BufSize);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function DeleteValue(Root: TKEY; Key,Value: string): boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, TRUE);
  if Result then
  begin
    Reg.DeleteValue(Value);
    Reg.CloseKey;
  end;

  Reg.Free;
end;

function DeleteKey(Root: TKEY; Key: string): boolean;
var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Reg.DeleteKey(Key);
  Reg.Free;
end;

function ReadRegBinary(Root: TKEY; Key, Name: string; var Buffer; BufSize: Integer): Boolean;

var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := TKeyToHKey(Root);
  Result := Reg.OpenKey(Key, FALSE);
  if Result then
  begin
    Reg.ReadBinaryData(Name, Buffer, BufSize);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

end.

unit dtResource;

interface
uses Windows,Classes,SysUtils,Graphics,Controls,ShellApi;

type ImageType = (aIMAGE_BITMAP, aIMAGE_ICON);
     TLoadType = (aLR_DEFAULTCOLOR,//aLR_LOADREALSIZE,
                   aLR_CREATEDIBSECTION,aLR_DEFAULTSIZE, aLR_LOADFROMFILE, aLR_LOADMAP3DCOLORS,aLR_LOADTRANSPARENT, aLR_MONOCHROME, aLR_SHARED);

type TResType = (RTACCELERATOR, RTANICURSOR, RTANIICON, RTBITMAP, RTCURSOR,
                 RTDIALOG, RTFONT, RTFONTDIR, RTGROUPCURSOR, RTGROUPICON,
                 RTICON, RTMENU, RTMESSAGETABLE, RTRCDATA, RTSTRING, RTVERSION);

//Lädt eine Stringresource Indent in Title
//Wenn die Resource nicht existiert wird der vordefinierte Wert Title
//verwendet und False zurückgegeben
function LoadToStr(var Title: string; Indent: Integer): Boolean;
//Wie LoadToStr , nur werden Boolwerte verwendet
//Ein String[1] von 1 bedeutet TRUE , sonst FALSE
function LoadToBool(var b: Boolean; Indent: Integer): Boolean;



//Lädt ein Symbol oder Bitmap mit dem Bezeichner Int oder Name aus einer
//Symboldatei (EXE,DLL,ICO,BMP),
//Dabei kann eine Typumwandlung verwendet werden :
//also kann eine Symbolbezeichner in ein TBitmap-Objekt verwandelt
//werden.
//Dazu geben Sie den Symbolbezeichner in Name oder int an und
//geben für uType aIMAGE_BITMAP oder aIMAGE_ICON an.
//Der Rückgabewert richtet sich entsprechend dieser Angabe.
//Info : Der Rückgabewert muss entsprechend Typumgewandelt werden.
//Zusätzlich kann die Breite (witdh) und Höhe (height) angegeben werden ,
//nur wird hier einfach das Bild geschnitten und nicht verzerrt.
//In LoadType kann die Art des Bildes angegeben werden , wie es sich
//darstellen soll.

function LoadIconFromExe(hinst: Longint; Name: string; Int: WORD; uType: ImageType;Width, Height: Integer; LoadType:TLoadType): TGraphic;
function GetIconNameString(const Name: string; const DefaultIndex: Integer; var PathName: string; var Index: Integer): Boolean;
function ExtractIcon(Name: string; Index: Integer): TICon; //*** 1.287b


function GetIconCount(Name: string): DWord; //*** 1.305


//Erstellt aus einem Bitmap eine Resourcen-skript-datei
//BitmapFileName : das Bitmap
//BitmapScriptFileName : die neue resourcendatei , kann leerer String sein
//                       , -> Lines verwenden
//TempFileName           : temporäre Datei (mit Pfad) für Zwischenspeicherung
//                         wenn leer sucht windows eine aus
//BitmapIdent              : gültiger Bitmap-resourcenbezeichner
//NewWidth,NewHeight       : Angepasste Grösse
//Lines                    : StringList für Ressourcenskript wenn benötigt und ungleich nil
function CreateBitmapScriptResourceEx(const BitmapFileName, BitmapScriptFileName, TempFileName: string;
  BitmapIdent: string; NewWidth, NewHeight: Integer; var Lines: TStringList): Integer;

function CreateBitmapScriptResource(const BitmapFileName, BitmapScriptFileName: string;
  BitmapIdent: string; NewWidth, NewHeight: Integer): Integer;



//Konvertiert ResourcenTyp in einen String
function ConvResType(ResType: TResType): PCHAR;

//Prüft eine ResourcenID auf Gültigkeit
function IsResourceIDValid(aModule: HMODULE; Id: Integer; ResType: TResType): Boolean;
//Prüft einen ResourcenName auf Gültigkeit
function IsResourceNameValid(aModule: HMODULE; Id: string; ResType: TResType): Boolean;


implementation
uses dtSystem,dtStrings,dtFiles;

function LoadToStr(var Title: string; Indent: Integer): Boolean;
var s: string;
begin
  s := LoadStr(Indent);
  RESULT := FALSE;
  if s <> '' then
  begin
    s := changechar(s, '^', #13);
    Title := s;
    Result := TRUE;
  end;
end;

function LoadToBool(var b: Boolean; Indent: Integer): Boolean;
var s: string;
begin
  s := LoadStr(Indent);
  RESULT := FALSE;
  if s <> '' then
  begin
    if s[1] = '1' then
      b := TRUE else b := FALSE;
    Result := TRUE;
  end;
end;

function LoadIconFromExe(hinst: Longint; Name: string; Int: WORD; uType: ImageType;
  Width, Height: Integer; LoadType:
  TLoadType
                         //Integer
  ): TGraphic;
var t: TIcon;
  b: TBitmap;
  u: Integer;
  s: Integer;
  r: array[0..255] of char;
  l: Longint;
begin
  if uType = aIMAGE_BITMAP then
  begin
    b := TBitmap.Create;
    u := IMAGE_BITMAP;
  end
  else
  begin
    t := TIcon.Create;
    u := IMAGE_ICON;
  end;
  FillChar(r, sizeof(r), #0);
  case LoadType of
    aLR_DEFAULTCOLOR: l := LR_DEFAULTCOLOR;
//    aLR_LOADREALSIZE : l :=LR_LOADREALSIZE;
    aLR_CREATEDIBSECTION: l := LR_CREATEDIBSECTION;
    aLR_DEFAULTSIZE: l := LR_DEFAULTSIZE;
    aLR_LOADFROMFILE: l := LR_LOADFROMFILE;
    aLR_LOADMAP3DCOLORS: l := LR_LOADMAP3DCOLORS;
    aLR_LOADTRANSPARENT: l := LR_LOADTRANSPARENT;
    aLR_MONOCHROME: l := LR_MONOCHROME;
    aLR_SHARED: l := LR_SHARED;
  else
    l := LR_DEFAULTCOLOR;
  end;
  if Name = NullStr then
//   strcopy(r,PCHAR(MAKEINTRESOURCE(int)))
    s := LoadImage(
      hinst, // handle of the instance that contains the image
      MAKEINTRESOURCE(int), // name or identifier of image
      u, // type of image
      Width, // desired width
      Height, // desired height
      l // load flags
      )
  else
//   strcopy(r,PCHAR(Name));
    s := LoadImage(
      hinst, // handle of the instance that contains the image
      PCHAR(Name), // name or identifier of image
      u, // type of image
      Width, // desired width
      Height, // desired height
      l // load flags
      );
  if uType = aIMAGE_BITMAP then
  begin
    b.Handle := s;
    LoadIconFromExe := b;
  end
  else
  begin
    t.Handle := s;
    LoadIconFromExe := t;
  end;
end;

function GetIconNameString(const Name: string; const DefaultIndex: Integer; var PathName: string; var Index: Integer): Boolean;
var str: string;
  p: Integer;
begin
  REsult := FALSE;
  str := Name;
  Str := GetTransString(Str);
  p := pos(',', Str);
  Index := DefaultIndex;
  if p <> 0 then
    Index := StrToIntDef(GetTransString(Copy(Str, 1, p - 1)), Index);
  Delete(str, 1, p);
  PathName := GetTransString(Copy(Str, 1, Length(Str)));
  if FileExists(PathName) then
    Result := TRUE;
end;

function ExtractIcon(Name: string; Index: Integer): TICon;
var i: TIcon;
    c1,c2 : HICON;
begin
  i := Ticon.Create;
 // i.ReleaseHandle;
  c1 := 0;
  c2 := 0;

  shellapi.ExtractIconEx(PChar(Name),Index,c1,c2, 1);

  i.Handle := c1;

  if i.Handle <> 0 then
  begin
    Result := i
  end
  else
  begin
    i.Free;
    Result := nil;
  end;
end;


function GetIconCount(Name: string): DWord;
var c1,c2 : HICON;
begin
  c1 := 0;
  c2 := 0;
  result := shellapi.ExtractIconEx(PChar(Name),-1,c1,c2, 0);
end;


function CreateBitmapScriptResourceEx(const BitmapFileName, BitmapScriptFileName, TempFileName: string;
  BitmapIdent: string; NewWidth, NewHeight: Integer; var Lines: TStringList): Integer;
var Bit: TBitmap;
  TempName: string;
  F: TFileStream;
  List: TStringList;
  k: array[0..15] of char;
  l: Longint;
  s: string;
  i2: Integer;
const BinReturn = #$0D#$0A;
begin
  Result := 0;
  if not FileExists(BitmapFileName) then
  begin
    raise Exception.CreateFmt('CreateBitmapScriptResourceEx' + return + '"%s" existiert nicht.',
      [BitmapFileName]);
    exit;
  end;
  if not IsValidIdent(BitmapIdent) then
  begin
    raise Exception.CreateFmt('CreateBitmapScriptResourceEx' + return + '"%s" ist ein ungültiger Bezeichner.',
      [BitmapIdent]);
    exit;
  end;
  Bit := TBitmap.Create;
  Bit.LoadFromFile(BitmapFileName);

  if NewWidth > 0 then
    Bit.Width := NewWidth;
  if NewHeight > 0 then
    Bit.Height := NewWidth;

  if TempFileName = '' then
    TempName := dtFiles.GetTempFile('')
  else
    TempName := TempFileName;

  //doppelt gemoppelt ist nötig , damit die Bitmapgröße verändert werden kann
  Bit.SaveToFile(TempName);
  Bit.Free;

  F := TFileStream.Create(TempName, fmOpenRead);
  s := BitmapIdent;

  List := TStringList.Create;

  List.Add(BinReturn + s + ' BITMAP');
  List.Add('BEGIN');
  FillChar(k, Sizeof(k), #0);

  l := f.Read(k, 16);
  while l > 0 do
  begin
    s := '''';
    for i2 := 1 to l do
    begin
      s := s + DoubleZero(IntToHex(Ord(k[i2 - 1]), 1)) + ' ';
    end;
    Delete(s, Length(s), 1);
    s := s + '''' + BinReturn + #$09;
    List.Add(s);
    l := f.Read(k, 16)
  end;
  List.Add('END');
  f.Free;
  SysUtils.DeleteFile(TempName);

  if BitmapScriptFileName <> '' then
    List.SaveToFile(BitmapScriptFileName);

  if Assigned(Lines) then
    Lines.Assign(List);
  Result := List.Count;
  List.Free;
end;


function CreateBitmapScriptResource(const BitmapFileName, BitmapScriptFileName: string;
  BitmapIdent: string; NewWidth, NewHeight: Integer): Integer;
var str: TStringList;
begin
  str := nil;
  Result :=
    CreateBitmapScriptResourceEx(BitmapFileName, BitmapScriptFileName, '',
    BitmapIdent, NewWidth, NewHeight, str);
end;

function ConvResType(ResType: TResType): PCHAR;
begin
  case ResType of
    RTACCELERATOR: Result := RT_ACCELERATOR;
    RTANICURSOR: Result := RT_ANICURSOR;
    RTANIICON: Result := RT_ANIICON;
    RTBITMAP: Result := RT_BITMAP;
    RTCURSOR: Result := RT_CURSOR;
    RTDIALOG: Result := RT_DIALOG;
    RTFONT: Result := RT_FONT;
    RTFONTDIR: Result := RT_FONTDIR;
    RTGROUPCURSOR: Result := RT_GROUP_CURSOR;
    RTGROUPICON: Result := RT_GROUP_ICON;
    RTICON: Result := RT_ICON;
    RTMENU: Result := RT_MENU;
    RTMESSAGETABLE: Result := RT_MESSAGETABLE;
    RTRCDATA: Result := RT_RCDATA;
    RTSTRING: Result := RT_STRING;
    RTVERSION: Result := RT_VERSION;
  else
    Result := #0;
  end;
end;

function IsResourceIDValid(aModule: HMODULE; Id: Integer; ResType: TResType): Boolean;
var aResult: HMODULE;
  p, p2: PCHAR;
begin
  p := PCHAR('#' + IntToStr(ID));
  p2 := PCHAR(ConvResType(ResType));
  aResult := FindResource(aModule, p, p2);
{  MessageDlg(IntToStr(GetLastError),mterror,[mbok],0);}

  Result := aResult <> 0;
end;


function IsResourceNameValid(aModule: HMODULE; Id: string; ResType: TResType): Boolean;
var aResult: HMODULE;
  p, p2: PCHAR;
begin
  p := PCHAR(ID);
  p2 := PCHAR(ConvResType(ResType));
  aResult := FindResource(aModule, p, p2);
{  MessageDlg(IntToStr(GetLastError),mterror,[mbok],0);}

  Result := aResult <> 0;
end;

end.

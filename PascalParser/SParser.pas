{Pascalsyntax bezogener Stream
geschrieben von author 24.4.2003
}
unit SParser;

interface

uses SysUtils, Classes;


type

  TTextStream = class(TMemoryStream)
  private
    fActuallyRead: integer;
    fFileName: string;
  public
       {Erstellt ein MemoryStream mit den Inhalt der Datei Filename.
       Mode kann den Zugriff auf die Datei bestimmen, allerdings werden Schreibrechte
       nicht ausgef�hrt, weil eine Kopie der Daten in den Speicher geladen und dann verwendet wird.}
    constructor Create(const FileName: string; Mode: word); overload;

    constructor Create(const Data : String); overload;

    {Da es mehrere Konstruktoren gibt, wird Init aufgerufen um zus�tzliche Initialisierungen vorzunehmen    }
    procedure Init; virtual;

       {Liest eine Datei in den Speicher. Vorhandene geladene Daten werden gel�scht und
       der Positionszeiger auf 0 gesetzt.
       Mode kann den Zugriff auf die Datei bestimmen, allerdings werden Schreibrechte
       nicht ausgef�hrt, weil eine Kopie der Daten in den Speicher geladen und dann verwendet wird.}
    procedure LoadFromFile(const FileName: string; Mode: word);

    {Liest einen String aus dem Stream mit der L�nge Len und gibt die tats�chlich gelesenen Bytes (bei Fehler 0) zur�ck}
    function ReadString(out Str: string; Len: integer): integer; overload;
    {Liest eine Char aus dem Stream mit der L�nge Len und gibt die tats�chlich gelesenen Bytes (bei Fehler 0) zur�ck}
    function ReadString(out C: char): integer; overload;

    {Gibt wahr zur�ck, wenn das Ende der Datei erricht wurde, sonst unwahr.}
    function EOF: boolean;

       {Liest einen Text in @aBuffer ein bis ein TextTeil in StopTrigger vorkommt.
       StopTrigger wird mit eingelesen.
       ReadOverhead lie�t x weitere Zeichen nach dem StopTrigger weiter ein.
       Wenn ReadOverHead kleiner Null ist wird der nur bis zur Position nach StopTrigger-ReadOverhead gelesen.

       Zwischen Gro�- und Kleinschreibung wird unterschieden, wenn CaseSensitive wahr ist.}
    procedure ReadText(var aBuffer: string; StopTrigger: string;
      var ReadOverhead: integer; CaseSensitive: boolean = True);

       {Liest ein Wort ein. Diese Methode muss �berschrieben werden, weil W�rter unter
       bestimmten Bedingung Zeichen enthalten, die normalerweise nicht dazugeh�ren}
    function ReadWord(GetReturn: boolean = False): string; virtual; abstract;

       {Liest einen kompletten Kommentar ein und gibt ihn zur�ck.
       Der Kommentaranfang und dessen einleitenden Zeichen muss an der aktuellen Leseposition stehen.}
    function ReadComment(var Token : String): string; virtual; abstract;

    {Liest ein Zeichen ein und setzt den Positionszeiger auf den vorherigen Wert, wenn Move wahr ist.}
    function GetNextChar(Move: boolean = True): char;
       
       {Liest Len Zeichen ein und setzt den Positionszeiger auf den vorherigen Wert, wenn Move wahr ist.
       Move wird ignoriert, wenn MoveBy ungleich 0 ist. Dabei wird der Positionszeiger um MoveBy verschoben.}
    function GetNextChars(Len: integer; MoveBy: integer = 0;
      Move: boolean = True): string;

    {Liest ein Zeichen vor dem Positionszeiger ein und setzt den ihn auf den vorherigen Wert, wenn Move wahr ist.}
    function GetPrevChar(Move: boolean = True): char;
       {Liest Len Zeichen vor dem Positionszeiger ein und setzt den ihn auf den vorherigen Wert, wenn Move wahr ist.
       Move wird ignoriert, wenn MoveBy ungleich 0 ist. Dabei wird der Positionszeiger um MoveBy verschoben.}
    function GetPrevChars(Len: integer; MoveBy: integer = 0;
      Move: boolean = True): string;

       {LeaveSpaces liest solange Leerzeichen oder Zeilenumbr�che ein,
       bis ein anderes Zeichen kommt und gibt dies zur�ck.
       Wenn GetReturns wahr ist, wird bis zum n�chsten Zeilenumbruch gelesen und
       das erste Zeichen des Umbruches zur�ckgegeben.}
    function LeaveSpaces(GetReturns: boolean = False): char;

       {Liest eine Zeile bis zum Umbruch ein, egal ob Befehle dadurch getrennt werden.
       Wenn FullLine wahr ist wird eine komplette Zeile gelesen, sonst von der aktuellen Position bis Umbruch}
    function ReadLine(FullLine: boolean = False): string;

       {Ermittelt die aktuelle Zeile des Positionsanzeigers.
       Sie wird berechnet, indem alle Zeilenumbr�che zuvor gesucht werden.}
    function ReadLineNumber: integer;

    function WriteNull(len: integer): integer;

    {Bei Leseroutinen verwendet, um die tats�chlich gelesenen Bytes zu bestimmen.}
    property ActuallyRead: integer read fActuallyRead;

    {Wenn Create oder LoadFromFile verwendet wurde, ist Filename der Dateiname der in den Speicehr geladenen Datei.}
    property FileName: string read fFileName;
  end;

type 
  LineSizeInt = 3..1024;

const 
  StringBufferSize: LineSizeInt = 16;

implementation

uses StrUtils;

var 
  IsException: boolean = False;

procedure TTextStream.Init;
begin

end;

constructor TTextStream.Create(const FileName: string; Mode: word);
begin
  inherited Create;

  {if ((Mode or fmCreate ) = fmCreate) then
   raise Exception.Create('TTextStream (a descendant from TMemoryStream) is only for reading purposes! Cannot use fmCreate in Mode.');
   }
  LoadFromFile(FileName, Mode);
  fFileName := FileName;
  Init;
end;

constructor TTextStream.Create(const Data : String);
begin
  inherited Create;
  Write(Data[1],Length(Data));
  Position := 0;
  Init;
end;

procedure TTextStream.LoadFromFile(const FileName: string; Mode: word);
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(FileName, Mode);

  try
   { if ((Mode and fmCreate ) <> fmCreate) and ((Mode or fmCreate ) <> fmCreate) then}
   if FS.Size > 0 then
      Self.CopyFrom(FS, 0);
  finally
    fFileName := FileName;
    Self.Position := 0;
    if Assigned(FS) then
      FS.Free;
  end;
end;

function TTextStream.WriteNull(len: integer): integer;
var 
  i: integer;
  c: char;
begin
  c := ' ';
  Result := 0;
  for i := 1 to len do
    Inc(Result, Write(c, 1));
end;

function TTextStream.ReadLineNumber: integer;
var 
  ActPosition: integer;
begin
  ActPosition := Position;
  if Position > 0 then
    Result := 1
  else
    Result := 0;
  while Position > 0 do
    if GetPrevChar = #$A then Inc(Result);

  Position := ActPosition;
end;

function TTextStream.EOF: boolean;
begin
  Result := Position >= Size; 
end;

function TTextStream.LeaveSpaces(GetReturns: boolean = False): char;
begin
  Result := GetNextChar;
  while not EOF and
    ((not GetReturns and (Result in [' ', #13, #10]) or (GetReturns and (Result in [' '])))) do
  begin
    Result := GetNextChar;
  end;
end;

function TTextStream.ReadLine(FullLine: boolean = False): string;
var 
  Pos1: integer;
  s: string;
  c: char;
  //    IsBreak : Boolean;
begin
  pos1 := 0;
  if FullLine then
  begin
    s := '';
    //  IsBreak := FALSE;
    repeat
      if Position = 0 then break;
      c := GetPrevChar;
      if (c = #10) or (c = #13) then
      begin
        GetNextChar;
        break;
      end;
    until False;
  end;

  ReadText(s, #13, Pos1);

  Result := StringReplace(s, #13, '', [rfReplaceAll]);
end;

function TTextStream.ReadString(out Str: string; Len: integer): integer;
begin
  SetLength(Str, Len);
  Result := Read(Str[1], Len);
end;

function TTextStream.ReadString(out C: char): integer;
begin
  Result := Read(C, 1);
end;

function TTextStream.GetNextChar(Move: boolean = True): char;
var 
  L: integer;
begin
  try
    L := ReadString(Result);
  except
    L := -1;
  end;

  fActuallyRead := L;

  if not Move then
    Seek(-L, soFromCurrent);
end;

function TTextStream.GetNextChars(Len: integer; MoveBy: integer = 0;
  Move: boolean = True): string;
begin
  {SetLength(Result, Len);
  FillChar(Result,Length(result),#0);    }
  try
    Len := ReadString(Result, Len);
    fActuallyRead := Len;
  finally
    if MoveBy <> 0 then
      Seek(MoveBy, soFromCurrent)
    else if not Move then Seek(-Len, soFromCurrent);
    SetLength(Result, Len);
//    if Len = 0 then

  end;
end;

function TTextStream.GetPrevChar(Move: boolean = True): char;
begin
  IsException := False;
  try
    Seek(-1,soFromCurrent);
  except
    IsException := True;
  end;

  if not IsException then
    fActuallyRead := Read(Result, SizeOf(char));
  if not Move then
    // Seek(1,soFromCurrent)
  else
    Seek(-1,soFromCurrent)
end;

function TTextStream.GetPrevChars(Len: integer; MoveBy: integer = 0;
  Move: boolean = True): string;
begin
  IsException := False;
  if (Position - Len) >= 0 then
  begin
    try
      Seek(-Len, soFromCurrent);
    except
      IsException := True;
    end;
  end
  else
    Position := 0;

  SetLength(Result, Len);
  try
    Len := ReadString(Result, Len);
    fActuallyRead := Len;
  finally
    if MoveBy <> 0 then
      Seek(MoveBy, soFromCurrent)
    else if not Move then
      //  Seek(Len,soFromCurrent)
    else
      Seek(-Len, soFromCurrent)
  end;
end;

var 
  mainstr: string = '';

procedure TTextStream.ReadText(var ABuffer: string; StopTrigger: string;
  var ReadOverhead: integer; CaseSensitive: boolean = True);
var 
  pBuffer, pBufferTemp, pString: string;
  pSize, iPos, StartPos: integer;
begin
  fActuallyRead := 0;
  if not CaseSensitive then
    StopTrigger := Uppercase(StopTrigger);

  StartPos := Position;

  while Position < Size do
  begin
    try
      pSize := Self.ReadString(pString, StringBufferSize);

      Inc(fActuallyRead, pSize);
    except
    end;

    if not CaseSensitive then
    begin
      pBuffer := pBuffer + pString;
      iPos := pos(StopTrigger, Uppercase(pBuffer + pString));
    end                       
    else
    begin
      pBuffer := pBuffer + pString;
      iPos := pos(StopTrigger, pBuffer);
    end;



    if iPos > 0 then
    begin
      //Position := Position - psize + ipos+1;
      Position := StartPos + ipos +
       {pos gibt die position des ersten zeichens, des gefundenen wortes zur�ck,
       deshalb muss die aktuelle Position an das erste Zeichen nach dem gefundenen Wort gesetzt werden. -> -1}
        Length(StopTrigger) - 1;

      aBuffer := Copy(pBuffer, 1,(iPos - 1) + Length(StopTrigger)
        //Wenn StopTrigger mit eingelesen werden soll auskommentieren
        );
      // MainStr := MainStr + Copy(pString,1,iPos+1);
      pBufferTemp := GetNextChars(20,0,False);
      if ReadOverhead > 0 then
      begin
        try
          ReadOverhead := ReadString(pString, ReadOverhead);
        finally
          aBuffer := aBuffer + pString;
        end;
      end
      else if ReadOverHead < 0 then
      begin
        GetPrevChars(-ReadOverHead);
        aBuffer := Copy(aBuffer, 1,Length(aBuffer) + ReadOverHead);
      end;
      exit;
    end
    else;
    // pBuffer := pBuffer+pString;
  end;
end;

{$WARNINGS OFF}
end.






{
var pBuffer,pBufferTemp,pString,pStringTemp : String;
    pSize,aPos,iPos,reng,StartPos : Integer;
begin
 // MainStr := '';
  fActuallyRead := 0;
  if not CaseSensitive then
   StopTrigger := Uppercase(StopTrigger);

  StartPos := Position;

  while Position < Size do
  begin
    try
      apos := Position;
      pSize := Self.ReadString(pString,StringBufferSize);

      Inc(fActuallyRead,pSize);
    except
    end;

    if not CaseSensitive then
      pStringTemp := Uppercase(pString);


    iPos := pos(StopTrigger,pStringTemp);

    if iPos > 0 then
    begin
      Position := Position - psize + ipos+1;

      aBuffer := pBuffer + Copy(pString,1,iPos-1);
     // MainStr := MainStr + Copy(pString,1,iPos+1);

      if ReadOverhead > 0 then
      begin
        try
          ReadOverhead := ReadString(pString,ReadOverhead);
        finally
          aBuffer := aBuffer + pString;
        end;
      end;
      exit;
    end
    else
    begin
      pBuffer := pBuffer+pString;

     { pBufferTemp := pBuffer; }
      if not CaseSensitive then
       pBufferTemp := Uppercase(pBuffer);

      iPos := pos(StopTrigger, pBufferTemp);

      if iPos > 0 then
      begin
  //Position := Position - psize + ipos+1;
  Position := StartPos + ipos + 1;

  aBuffer := Copy(pBuffer, 1,iPos - 1);
  // MainStr := MainStr + Copy(pString,1,iPos+1);

  if ReadOverhead > 0 then
  begin
    try
      ReadOverhead := ReadString(pString, ReadOverhead);
    finally
      aBuffer := aBuffer + pString;
    end;
  end;
  exit;
end
     // mainstr := mainstr + pString;
    end;

  end;

}

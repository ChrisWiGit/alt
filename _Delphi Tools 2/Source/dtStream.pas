{
@abstract(dtStream.pas beinhaltet  Funktionen f�r den Umgang mit Streams)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)

Streams sind m�chtige Werkzeuge um Daten im Speicher oder auf Festplatte (Dateien) zu verwalte.
Im Zusammenhang mit Signaturen kann man schnell und effizient, Daten schreiben und nur dann lesen,
wenn es sich um korrekte Inhalte handelt. Mehr dazu siehe in der Unit dtSignature
}

unit dtStream;

interface
uses Windows,SysUtils,Classes,ComCtrls,
     dtSignature;

type
  {TOnWriteFileData wird aufgerufen, wenn BenutzerDaten in die Datei geschrieben werden sollen.
  Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
  Sie wird in Klassen als Ereignis verwendet.
  Siehe @link(WriteFile)}
  TOnWriteFileData = function(Stream: TStream): Longint of object; //Daten zu schreiben ; R�ckgabewert : Anzahl der geschriebenen Bytes

  {TOnReadFileData wird aufgerufen, wenn BenutzerDaten aus der Datei gelesen werden sollen.
  Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
  Sie wird in Klassen als Ereignis verwendet.
  Siehe @link(ReadFile)}
  TOnReadFileData = function(Stream: TStream): Longint of object; //Daten zu lesen     ; R�ckgabewert : Anzahl der gelesenen Bytes

  {TOnReadCompatibledFileData wird aufgerufen, wenn BenutzerDaten aus der Datei gelesen werden sollen.
  Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
  Sie wird in Klassen als Ereignis verwendet.
  Siehe @link(ReadFileCompatible)}
  TOnReadCompatibledFileData = function(Stream: TStream; SignVersion: TSignVersion): Longint of object; //Daten zu lesen     ; R�ckgabewert : Anzahl der gelesenen Bytes

  {TOnExtReadFileData wird aufgerufen, wenn BenutzerDaten aus der Datei gelesen und
  die Version manuell verglichen werden soll.
  Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
  Sie wird in Klassen als Ereignis verwendet.
  Siehe @link(ReadFileExtended)}
  TOnExtReadFileData = function(Stream : TStream; FileSignVersion,ExpectedSignVersion: TSignVersion) : Longint of object;

  {TOnWriteFileDataStd wird aufgerufen, wenn BenutzerDaten in die Datei geschrieben werden sollen.
  Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
  Sie wird als Ereignisfunktion auserhalb von Klassen verwendet.
  Siehe @link(WriteFileStd)}
  TOnWriteFileDataStd = function(Stream: TStream; Data: Pointer): Longint; //Daten zu schreiben ; R�ckgabewert : Anzahl der geschriebenen Bytes

  {TOnReadFileDataStd wird aufgerufen, wenn BenutzerDaten aus der Datei gelesen werden sollen.
  Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
  Sie wird als Ereignisfunktion auserhalb von Klassen verwendet.
  Siehe @link(ReadFileStd)}
  TOnReadFileDataStd = function(Stream: TStream; var Data: Pointer): Longint; //Daten zu lesen     ; R�ckgabewert : Anzahl der gelesenen Bytes


type
  {TOnStreamingNode wird aufgerufen, wenn ein Knoten gelesen oder geschrieben werden soll.
  Stream , ist der Stream in den geschrieben oder aus dem gelesen wird.
  Node ist der Knoten , der geschrieben oder gelesen werden soll.
  Sie wird in Klassen als Ereignis verwendet.
  Der R�ckgabewert sind die geschriebenen oder gelesenen Bytes.}
  TOnStreamingNode = function(Stream: TStream; var Node: TTreeNode): Longint of object;
  {TOnStreamingNode2 wird aufgerufen, wenn ein Knoten gelesen oder geschrieben werden soll.
  Stream , ist der Stream in den geschrieben oder aus dem gelesen wird.
  Node ist der Knoten , der geschrieben oder gelesen werden soll
  Sie wird als Ereignisfunktion auserhalb von Klassen verwendet.
  Der R�ckgabewert sind die geschriebenen oder gelesenen Bytes}
  TOnStreamingNode2 = function(Stream: TStream; var Node: TTreeNode): Longint;

{WriteString schreibt einen String in einen Stream.
Jeder String besitzt zus�tzlich eine Indentifiezierungsnummer (#1#2),  um ihn eindeutig als solchen erkennen zu k�nnen
 Aufbau : #1#1[StrL�nge als Integer][Str als PChar]
NICHT KOMPATIBEL MIT DEM WRITESTRING/READSTRING VON TSTRINGSTREAM (ODER ANDEREN OBJEKTEN VON DELPHI)

Siehe auch @link(WriteString2a),@link(WriteString3a),@link(WriteString4)
}
function WriteString(Stream: TStream; Data: string): Longint;

{SizeOfString ermittelt, den Verbrauch eines Strings "Data" in einem Stream.
Siehe @link(WriteString)}
function SizeOfString(Data: string): Longint;

{ReadString liest den mit @link(WriteString) gespeicherten String wieder aus.
ReadString funktioniert nur bei Daten, die mit @link(WriteString) gespeichert wurden!
Bei Fehlern in der Indentifiezierung wird eine Exception ausgel�st
 NICHT KOMPATIBEL MIT DEM WRITESTRING/READSTRING VON TSTRINGSTREAM (ODER ANDEREN OBJEKTEN VON DELPHI)}
function ReadString(Stream: TStream): string;

{WriteString2a schreibt einen String in einen Stream.
Siehe auch @link(WriteString),@link(WriteString3a),@link(WriteString4)}
procedure WriteString2a(Stream: TStream; Data: string);

{ReadString2a liest den mit @link(WriteString2a) gespeicherten String wieder aus.
ReadString2a funktioniert nur bei Daten, die mit @link(WriteString2a) gespeichert wurden!}
function ReadString2a(Stream: TStream): string;

{WriteString3a schreibt einen String in einen Stream.
Siehe auch @link(WriteString),@link(WriteString2a),@link(WriteString4)
}
procedure WriteString3a(Stream: TStream; Data: string);

{ReadString3a liest den mit @link(WriteString3a) gespeicherten String wieder aus.
ReadString3a funktioniert nur bei Daten, die mit @link(WriteString3a) gespeichert wurden!}
function ReadString3a(Stream: TStream): string;

{SizeOfStringBuffer3a liefert die Anzahl der gespeicherten Bytes f�r WriteString2a und WriteString3a zur�ck.}
function SizeOfStringBuffer3a(Data: string): Longint;


{WriteString4 schreibt sehr schnell einen String in einen Stream
Der R�ckgabewert ist die anzahl der geschriebenen Bytes.
Siehe auch @link(WriteString),@link(WriteString2a),@link(WriteString3a)}
function WriteString4(Stream : TStream; Text : String) : Longint;

{ReadString4 liest sehr schnell einen String, der mit WriteString3 geschrieben wurde, aus einem Stream.
Siehe auch @link(WriteString4)}
function ReadString4(Stream : TStream;var Text : String) : Longint;


{WriteInteger schreibt einen Integerwert in einen Stream.}
function WriteInteger(Stream: TStream; Data: Integer): Longint;

{ReadInteger liest einen Integerwert, der mit @link(WriteInteger) geschrieben wurde.
}
function ReadInteger(Stream: TStream): Integer;

{WriteBool schreibt einen Boolwert in einen Stream.}
function WriteBool(Stream : TStream; Bool : Boolean) : Longint;

{ReadBool liest einen Boolwert, der mit @link(WriteBool) geschrieben wurde, aus einen Stream.}
function ReadBool(Stream : TStream) : Boolean;


//Marke


{WriteFile schreibt eine Datei mit einer Signatur und den darauf beliebigen Daten.
OnWriteFileData mu� definiert worden sein, es wird dann einmalig nach dem Schreiben der Signatur aufgerufen
Verwende f�r SignVersion die Konstante @link(NULL_SignVersion) , wenn keine Signatur gebraucht werden soll}
function WriteFile(const FileName: string; SignVersion: TSignVersion; OnWriteFileData: TOnWriteFileData): Longint;

{WriteFileStd schreibt eine Datei mit einer Signatur und den darauf beliebigen Daten.
OnWriteFileData mu� definiert worden sein, es wird dann einmalig nach dem Schreiben der Signatur aufgerufen
Verwende f�r SignVersion die Konstante @link(NULL_SignVersion) , wenn keine Signatur gebraucht werden soll}
function WriteFileStd(const FileName: string; SignVersion: TSignVersion; OnWriteFileData: TOnWriteFileDataStd; Data: Pointer): Longint;

{ReadFile lie�t eine Datei mit einer Signatur und den darauf beliebigen Daten.
OnReadFileData mu� definiert worden sein, es wird dann einmalig nach dem
Lesen der korrekten Signatur aufgerufen
Wurde eine inkorrekte SignVersion gefunden , so wird OnReadFileData nicht aufgerufen
und der R�ckgabewert <= @link(SizeOfSignVersion) (<SignVersion>)
Nat�rlich funktioniert der Benutzervergleich mit @link(TSignVersionCompUsrFunc)
Verwende f�r SignVersion die Konstante @link(NULL_SignVersion) , wenn keine Signatur gebraucht worden ist.}
function ReadFile(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileData): Longint;

{ReadFileStd lie�t eine Datei mit einer Signatur und den darauf beliebigen Daten.
OnReadFileData mu� definiert worden sein, es wird dann einmalig nach dem
Lesen der korrekten Signatur aufgerufen
Wurde eine inkorrekte SignVersion gefunden , so wird OnReadFileData nicht aufgerufen
und der R�ckgabewert <= @link(SizeOfSignVersion) (<SignVersion>)
Nat�rlich funktioniert der Benutzervergleich mit @link(TSignVersionCompUsrFunc)
Verwende f�r SignVersion die Konstante @link(NULL_SignVersion) , wenn keine Signatur gebraucht worden ist.
Der R�ckgabewert ist die Anzahl der gelesenen Bytes.}
function ReadFileStd(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileDataStd; var Data: Pointer): Longint;

{ReadFileMin funktioniert, wie @link(ReadFile) mit der Einschr�nkung:
Beim Vergleich werden folgende Daten verglichen : SignatureStr,SubSignature,FileName,FileTyp.}
function ReadFileMin(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileData): Longint;

{ReadFileMinStd funktioniert, wie @link(ReadFileStd) mit der Einschr�nkung:
Beim Vergleich werden folgende Daten verglichen : SignatureStr,SubSignature,FileName,FileTyp.
Der R�ckgabewert ist die Anzahl der gelesenen Bytes.}
function ReadFileMinStd(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileDataStd; var Data: Pointer): Longint;

{ReadFileCompatible}
function ReadFileCompatible(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileData; OnReadCompatibleFileData: TOnReadCompatibledFileData): Boolean;


{ReadFileExtended liest eine Datei ein und �bergibt der Lese Routine @link(TOnExtReadFileData) die gelesene Dateiversion.
Der R�ckgabewert ist die Anzahl der gelesenen Bytes.}
function ReadFileExtended(const FileName: string; SignVersion: TSignVersion; OnExtReadFileData : TOnExtReadFileData) : Longint;






{WriteTreeNodesToStream schreibt einen kompletten Baum "Nodes" in einen Stream.
Dabei wird zus�tzlich zu jedem Knoten das Ereignis OnWriteNode aufgerufen
Das Klassen-Ereignis wird erst nach dem Schreiben der Knotendaten ausgel�st.
Der R�ckgabewert ist die Anzahl der geschriebenen Bytes}
function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream; OnWriteNode: TOnStreamingNode): Longint; overload;

{WriteTreeNodesToStream schreibt einen kompletten Baum "Nodes" in einen Stream.
Dabei wird zus�tzlich zu jedem Knoten das Ereignis OnWriteNode aufgerufen
Das FunktionsEreignis wird erst nach dem Schreiben der Knotendaten ausgel�st.
Der R�ckgabewert ist die Anzahl der geschriebenen Bytes}

function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream; OnWriteNode: TOnStreamingNode2): Longint; overload;

{ReadTreeNodesFromStream lie�t einen Baum "Nodes" aus einem Stream
Dabei wird zus�tzlich zu jedem Knoten das Ereignis OnReadNode aufgerufen
Das KlassenEreignis wird aufgerufen nachdem der Knoten gelesen , erzeugt und dem Baum hinzugef�hrt wurde
So kann z.B. die Eigenschaft Data ge�ndert werden , oder aber auch alle Anderen
Der R�ckgabewert ist die Anzahl der gelesenen Bytes
}
function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream; OnReadNode: TOnStreamingNode): Longint; overload;

{ReadTreeNodesFromStream lie�t einen Baum "Nodes" aus einem Stream
Dabei wird zus�tzlich zu jedem Knoten das Ereignis OnReadNode aufgerufen
Das FunktionsEreignis wird aufgerufen nachdem der Knoten gelesen , erzeugt und dem Baum hinzugef�hrt wurde
So kann z.B. die Eigenschaft Data ge�ndert werden , oder aber auch alle Anderen
Der R�ckgabewert ist die Anzahl der gelesenen Bytes}
function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream; OnReadNode: TOnStreamingNode2): Longint; overload;




implementation
uses dtSystem,dtStringsRes,dtMultimedia;

const StrIndent = #1#2;
      StrIndentLen = Length(StrIndent);


function WriteString(Stream: TStream; Data: string): Longint;
var Len: Integer;
begin
  Result := 0;
  Len := Length(Data);
  Inc(Result, Stream.Write(StrIndent, Length(StrIndent)));
  Inc(Result, Stream.Write(Len, SizeOf(Len)));
  Inc(Result, Stream.Write(PCHAR(Data)^, Len));
end;

function SizeOfString(Data: string): Longint;
begin
  Result := 0;
  Inc(Result, Length(StrIndent));
  Inc(Result, SizeOf(Integer));
  Inc(Result, Length(Data));
end;

function ReadString(Stream: TStream): string;
var Len, i: Integer;
  Data: string;
  c: Char;
  p: array[0..StrIndentLen - 1] of char;
begin
  Result := '';
  try
    Stream.Read(p, Length(StrIndent));
  except
  end;
  if CompareStr(StrIndent, string(p)) <> 0 then exit;
  Stream.Read(Len, SizeOf(Len));
  Data := '';
  for i := 0 to Len - 1 do
  begin
    Stream.Read(c, 1);
    Data := Data + c;
  end;
  Result := Data;
end;

procedure WriteString2a(Stream: TStream; Data: string);
var Len: Integer;
  i: Integer;
begin
  Len := Length(Data);
  Stream.Write(Len, SizeOf(Integer));
  for i := 1 to Len do
    Stream.Write(Data[i], 1);
end;                        


function ReadString2a(Stream: TStream): string;
var Len: Integer;
  c: Char;
  i: Integer;
begin
  Stream.Read(Len, SizeOf(Integer));
  Result := '';
  for i := 1 to Len do
  begin
    Stream.ReadBuffer(c, 1);
    Result := Result + c;
  end;
end;

procedure WriteString3a(Stream: TStream; Data: string);
var Len: Integer;
  p: array[0..511] of char;
begin
  Len := Length(Data);
  Stream.WriteBuffer(Len, SizeOf(Integer));

  StrLCopy(@p, PCHAR(Data), len);

  Stream.WriteBuffer(p, len);
end;

function SizeOfStringBuffer3a(Data: string): Longint;
begin
  Result := SizeOf(Integer) + Length(Data);
end;


function ReadString3a(Stream: TStream): string;
var Len: Integer;
  p: array[0..1023] of char;
  s: string;
begin
  Stream.ReadBuffer(Len, SizeOf(Integer));
  Stream.ReadBuffer(p, Len);

  if Len > 0 then
  begin
    SetLength(s, Len);
    StrLCopy(PCHAR(s), p, Len);
  end
  else s := '';

  Result := s;
end;



function WriteString4(Stream : TStream; Text : String) : Longint;
var l : Integer;
begin
  l := Length(Text);
  Result := Stream.Write(l,SizeOf(l));
  Inc(Result,Stream.Write(Text,l));
end;

function ReadString4(Stream : TStream;var Text : String) : Longint;
var l : Integer;
begin
  result := -1;
  try
   Result := Stream.Read(l,SizeOf(l));
   Inc(Result,Stream.Read(Text,l));
  except
   Text := '';
  end;
end;

function WriteInteger(Stream: TStream; Data: Integer): Longint;
begin
  Result := Stream.Write(Data, SizeOf(Data));
end;

function ReadInteger(Stream: TStream): Integer;
var i: Integer;
begin
  Stream.Read(i, SizeOf(i));
  Result := i;
end;

function WriteBool(Stream : TStream; Bool : Boolean) : Longint;
begin
  Result := Stream.Write(Bool,SizeOf(Boolean));
end;
function ReadBool(Stream : TStream) : Boolean;
begin
  Stream.Read(Result,SizeOf(Boolean));
end;


function ReadFileMinStd(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileDataStd; var Data: Pointer): Longint;
var S: TFileStream;
begin
  if not Assigned(OnReadFileData) then
  begin
    raise Exception.Create(dtStream_ReadFileMinStd_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := 0;
  Inc(Result, SizeOfSignVersion(SignVersion));

  if ReadValidSignVersionMin(S, SignVersion) then
    Inc(Result, OnReadFileData(S, Data));

  S.Free;
end;

function ReadFileStd(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileDataStd; var Data: Pointer): Longint;
var S: TFileStream;
begin
  if not Assigned(OnReadFileData) then
  begin
    raise Exception.Create(dtStream_ReadFileStd_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := 0;
  Inc(Result, SizeOfSignVersion(SignVersion));

  if not EqualSignVersion(SignVersion, NULL_SignVersion) then
  begin
    if ReadValidSignVersion(S, SignVersion) then
      Inc(Result, OnReadFileData(S, Data));
  end
  else
    Inc(Result, OnReadFileData(S, Data));
  S.Free;
end;

function WriteFileStd(const FileName: string; SignVersion: TSignVersion; OnWriteFileData: TOnWriteFileDataStd; Data: Pointer): Longint;
var S: TFileStream;
begin
  if not Assigned(OnWriteFileData) then
  begin
    raise Exception.Create(dtStream_WriteFileStd_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmCreate or fmOpenReadWrite);

  Result := 0;
  if not EqualSignVersion(SignVersion, NULL_SignVersion) then
    Inc(Result, WriteSignVersion(S, SignVersion));
  Inc(Result, OnWriteFileData(S, Data));
  S.Free;
end;


function WriteFile(const FileName: string; SignVersion: TSignVersion; OnWriteFileData: TOnWriteFileData): Longint;
var S: TFileStream;
begin
  if not Assigned(OnWriteFileData) then
  begin
    raise Exception.Create(dtStream_WriteFile_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmCreate or fmOpenReadWrite);

  Result := 0;
  if not EqualSignVersion(SignVersion, NULL_SignVersion) then
    Inc(Result, WriteSignVersion(S, SignVersion));
  Inc(Result, OnWriteFileData(S));
  S.Free;
end;

function ReadFileCompatible(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileData; OnReadCompatibleFileData: TOnReadCompatibledFileData): Boolean;
var S: TFileStream;
  ss: TSignVersion;
begin
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := TRUE;
//  Inc(Result,SizeOfSignVersion(SignVersion));

  if not EqualSignVersion(SignVersion, NULL_SignVersion) then
  begin
    if ReadValidSignVersion(S, SignVersion) then
    begin
      if Assigned(OnReadFileData) then
        Inc(Result, OnReadFileData(S));
    end
    else
    begin
      S.Position := 0;
      if ReadValidSignatureMin(S, SignVersion.Signature) then
      begin
        S.Position := 0;
        ss := ReadSignVersion(S);
        if Assigned(OnReadCompatibleFileData) then
          Inc(Result, OnReadCompatibleFileData(S, ss));
      end
      else
        Result := FALSE;
    end;
  end
  else
    Inc(Result, OnReadFileData(S));
  S.Free;
end;

function ReadFileExtended(const FileName: string; SignVersion: TSignVersion; OnExtReadFileData : TOnExtReadFileData) : Longint;
var S: TFileStream;
    V : TSignVersion;
begin
  if not Assigned(OnExtReadFileData) then
  begin
    raise Exception.Create(dtStream_ReadFileExtended_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := 0;

  V := ReadSignVersion(S);
  Inc(Result, OnExtReadFileData(S,V,SignVersion));

  S.Free;
end;

function ReadFile(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileData): Longint;
var S: TFileStream;
begin
  if not Assigned(OnReadFileData) then
  begin
    raise Exception.Create(dtStream_ReadFile_Error);
    exit;
  end;
  try
   S := TFileStream.Create(FileName, fmOpenRead);
  Result := 0;

  if not EqualSignVersion(SignVersion, NULL_SignVersion) then
  begin
    if ReadValidSignVersion(S, SignVersion) then
    begin
      Inc(Result, OnReadFileData(S));
      Inc(Result, SizeOfSignVersion(SignVersion));
    end
    else
     Result := -1;
  end
  else
  begin
    Inc(Result, OnReadFileData(S));
    Inc(Result, SizeOfSignVersion(SignVersion));
  end;
  finally
   FreeAndNil(S);
  end;
end;


function ReadFileMin(const FileName: string; SignVersion: TSignVersion; OnReadFileData: TOnReadFileData): Longint;
var S: TFileStream;
begin
  if not Assigned(OnReadFileData) then
  begin
    raise Exception.Create(dtStream_ReadFileMin_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := 0;

 {
  if ReadValidSignVersionMin(S, SignVersion) then
    Inc(Result, OnReadFileData(S));
  }

  if not EqualSignVersion(SignVersion, NULL_SignVersion) then
  begin
    if ReadValidSignVersionMin(S, SignVersion) then
    begin
      Inc(Result, SizeOfSignVersion(SignVersion));
      Inc(Result, OnReadFileData(S))
    end
    else
     Result := -1;
  end
  else
  begin
    Inc(Result, SizeOfSignVersion(SignVersion));
    Inc(Result, OnReadFileData(S));
  end;

  S.Free;
end;










function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream; OnReadNode: TOnStreamingNode): Longint;
  function ReadNode(S: TStream; TreeNodes: TTreeNodes): Longint;
  var Index: Integer;
    Text: string;
    Node: TTreeNode;
  begin
    Result := 0;

    Text := ReadString3a(S);
    Inc(Result, SizeOfStringBuffer3a(Text));

    Inc(Result, s.Read(Index, SizeOf(Index)));


    if Index <> 0 then
    begin
      Node := TreeNodes.AddChild(TreeNodes[Index - 1], Text);
    end
    else
    begin
      Node := TreeNodes.Add(nil, Text);
    end;
    if Assigned(OnReadNode) then
      Inc(Result, OnReadNode(S, Node));
  end;

var i, Count: Integer;

begin
  ASSERT(Assigned(Stream));
  ASSERT(Assigned(Nodes));
  Result := 0;
  Stream.Read(Count, SizeOf(Count));
  for i := 0 to Count - 1 do
  begin
    Inc(Result, ReadNode(Stream, Nodes));
  end;
end;


function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream; OnReadNode: TOnStreamingNode2): Longint;
  function ReadNode(S: TStream; TreeNodes: TTreeNodes): Longint;
  var Index: Integer;
    Text: string;
    Node: TTreeNode;
  begin
    Result := 0;

    Text := ReadString3a(S);
    Inc(Result, SizeOfStringBuffer3a(Text));

    Inc(Result, s.Read(Index, SizeOf(Index)));


    if Index <> 0 then
    begin
      Node := TreeNodes.AddChild(TreeNodes[Index - 1], Text);
    end
    else
    begin
      Node := TreeNodes.Add(nil, Text);
    end;
    if Assigned(OnReadNode) then
      Inc(Result, OnReadNode(S, Node));
  end;

var i, Count: Integer;

begin
  ASSERT(Assigned(Stream));
  ASSERT(Assigned(Nodes));
  Result := 0;
  Stream.Read(Count, SizeOf(Count));
  for i := 0 to Count - 1 do
  begin
    Inc(Result, ReadNode(Stream, Nodes));
  end;
end;


function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream; OnWriteNode: TOnStreamingNode): Longint;
  function WriteNode(S: TStream; Node: TTreeNode): Longint;
  var I: Integer;
  begin
    Result := 0;
    WriteString3a(S, Node.Text);
    Inc(Result, SizeOfStringBuffer3a(Node.Text));

    if Assigned(Node.Parent) then
    begin
      i := Node.Parent.AbsoluteIndex + 1;
      Inc(Result, s.Write(i, SizeOf(Node.Parent.AbsoluteIndex)));
    end
    else
    begin
      i := 0;
      Inc(Result, s.Write(i, SizeOf(Integer)));
    end;
    if Assigned(OnWriteNode) then
      Inc(Result, OnWriteNode(S, Node));
  end;

var i: Integer;
begin
  ASSERT(Assigned(Stream));
  ASSERT(Assigned(Nodes));
  Result := 0;
  i := Nodes.Count;
  Inc(Result, Stream.Write(i, SizeOf(Nodes.Count)));
  for i := 0 to Nodes.Count - 1 do
  begin
    Inc(Result, WriteNode(Stream, Nodes[i]));
  end;
end;


function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream; OnWriteNode: TOnStreamingNode2): Longint;
  function WriteNode(S: TStream; Node: TTreeNode): Longint;
  var I: Integer;
  begin
    Result := 0;
    WriteString3a(S, Node.Text);
    Inc(Result, SizeOfStringBuffer3a(Node.Text));

    if Assigned(Node.Parent) then
    begin
      i := Node.Parent.AbsoluteIndex + 1;
      Inc(Result, s.Write(i, SizeOf(Node.Parent.AbsoluteIndex)));
    end
    else
    begin
      i := 0;
      Inc(Result, s.Write(i, SizeOf(Integer)));
    end;
    if Assigned(OnWriteNode) then
      Inc(Result, OnWriteNode(S, Node));
  end;

var i: Integer;
begin
  ASSERT(Assigned(Stream));
  ASSERT(Assigned(Nodes));
  Result := 0;
  i := Nodes.Count;
  Inc(Result, Stream.Write(i, SizeOf(Nodes.Count)));
  for i := 0 to Nodes.Count - 1 do
  begin
    Inc(Result, WriteNode(Stream, Nodes[i]));
  end;
end;
end.

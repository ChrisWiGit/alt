{*******************************************
 *  DelphiTools Version 2.x
 *  07/09/2002
 *  Unit : dtStream
 *  created by removed
 *******************************************}

unit dtStream;

interface

uses Windows, SysUtils, Classes, ComCtrls,
  dtSignature;

type 
  TOnWriteFileData = function(Stream: TStream): longint of object;
  //Daten zu schreiben ; R�ckgabewert : Anzahl der geschriebenen Bytes
  TOnReadFileData = function(Stream: TStream): longint of object;
  //Daten zu lesen     ; R�ckgabewert : Anzahl der gelesenen Bytes

  TOnReadCompatibledFileData = function(Stream: TStream;
    SignVersion: TSignVersion): longint of object;
  //Daten zu lesen     ; R�ckgabewert : Anzahl der gelesenen Bytes
  TOnExtReadFileData = function(Stream: TStream;
    FileSignVersion, ExpectedSignVersion: TSignVersion): longint of object;

  TOnWriteFileDataStd = function(Stream: TStream; Data: Pointer): longint;
  //Daten zu schreiben ; R�ckgabewert : Anzahl der geschriebenen Bytes
  TOnReadFileDataStd = function(Stream: TStream; var Data: Pointer): longint;
  //Daten zu lesen     ; R�ckgabewert : Anzahl der gelesenen Bytes


type
  //Stream , ist der Stream in den geschrieben oder aus dem gelesen wird
  //Node ist der Knoten , der geschrieben oder gelesen werden soll
  //Der R�ckgabewert sind die geschriebenen oder gelesenen Bytes
  TOnStreamingNode = function(Stream: TStream; var Node: TTreeNode): longint of object;
  TOnStreamingNode2 = function(Stream: TStream; var Node: TTreeNode): longint;  

  //Schreibt einen String in einen Stream
  //Die L�nge ist egal
  //Jeder String besitzt zus�tzlich noch eine Indentifiezierungsnummer (#1#2),  um ihn eindeutig als solchen erkennen zu k�nnen
  // Aufbau : #1#1[StrL�nge als Integer][Str als PChar]
  // NICHT KOMPATIBEL MIT DEM WRITESTRING/READSTRING VON TSTRINGSTREAM (ODER ANDEREN OBJEKTEN VON DELPHI)
function WriteString(Stream: TStream; Data: string): longint;
function SizeOfString(Data: string): longint;
  //Liest den mit WriteString gespeicherten String wieder aus
  //Bei Fehlern in der Indentifiezierung wird eine Exception ausgel�st
  // NICHT KOMPATIBEL MIT DEM WRITESTRING/READSTRING VON TSTRINGSTREAM (ODER ANDEREN OBJEKTEN VON DELPHI)
function ReadString(Stream: TStream): string;

procedure WriteString2a(Stream: TStream; Data: string);
function ReadString2a(Stream: TStream): string;

procedure WriteString3a(Stream: TStream; Data: string);
function ReadString3a(Stream: TStream): string;

  //Anzahl der gespeicherten Bytes f�r 2a und 3a
function SizeOfStringBuffer3a(Data: string): longint;


  //schreibt sehr schnell einen String in einen Stream
  //Der R�ckgabewert ist die anzahl der geschriebenen/gelesenen Bytes
function WriteString4(Stream: TStream; Text: string): longint;
  //liest sehr schnell einen String aus einem Stream
function ReadString4(Stream: TStream; var Text: string): longint;


  //Schreibt einen Integerwert in einen Stream
  // NICHT KOMPATIBEL MIT DEM WRITESTRING/READSTRING VON TSTRINGSTREAM (ODER ANDEREN OBJEKTEN VON DELPHI)
function WriteInteger(Stream: TStream; Data: integer): longint;
  //Und hier wird er wieder herausgelesen
  // NICHT KOMPATIBEL MIT DEM WRITESTRING/READSTRING VON TSTRINGSTREAM (ODER ANDEREN OBJEKTEN VON DELPHI)
function ReadInteger(Stream: TStream): integer;


function WriteBool(Stream: TStream; Bool: boolean): longint;

function ReadBool(Stream: TStream): boolean;


  //Marke


  //Schreibt eine Datei mit einer Signatur und den darauf beliebigen Daten
  //OnWriteFileData mu� definiert worden sein, es wird dann einmalig nach dem Schreiben der Signatur aufgerufen
  //Verwende f�r SignVersion die Konstante NULL_SignVersion , wenn keine Signatur gebraucht werden soll
function WriteFile(const FileName: string; SignVersion: TSignVersion;
  OnWriteFileData: TOnWriteFileData): longint;
function WriteFileStd(const FileName: string; SignVersion: TSignVersion;
  OnWriteFileData: TOnWriteFileDataStd; Data: Pointer): longint;

  //Lie�t eine Datei mit einer Signatur und den darauf beliebigen Daten
  //OnReadFileData mu� definiert worden sein, es wird dann einmalig nach dem
  //Lesen der korrekten Signatur aufgerufen
  //Wurde eine inkorrekte SignVersion gefunden , so wird OnReadFileData nicht aufgerufen
  //und der R�ckgabewert <= SizeOfSignVersion(<SignVersion>)
  //Nat�rlich funktioniert der Benutzervergleich mit SignVersionCompUsrFunc
  //Verwende f�r SignVersion die Konstante NULL_SignVersion , wenn keine Signatur gebraucht worden ist
function ReadFile(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileData): longint;
function ReadFileStd(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileDataStd; var Data: Pointer): longint;

  //Wie ReadFile nur :
  //Beim Vergleich werden folgende Daten verglichen      SignatureStr,SubSignature,FileName,FileTyp
function ReadFileMin(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileData): longint;
function ReadFileMinStd(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileDataStd; var Data: Pointer): longint;


function ReadFileCompatible(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileData; OnReadCompatibleFileData: TOnReadCompatibledFileData): boolean;


  //Liest eine Datei ein und �bergibt der Lese Routine die gelesene Dateiversion
function ReadFileExtended(const FileName: string; SignVersion: TSignVersion;
  OnExtReadFileData: TOnExtReadFileData): longint;






  //Schreibt einen kompletten Baum Nodes in einen Stream
  //Dabei wird zus�tzlich zu jedem Knoten das Ereignis OnWriteNode aufgerufen
  //Das Ereignis wird erst nach dem Schreiben ausgel�st.
  //Der R�ckgabewert ist die Anzahl der geschriebenen Bytes
function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream;
  OnWriteNode: TOnStreamingNode): longint; overload;
function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream;
  OnWriteNode: TOnStreamingNode2): longint; overload;
  //lie�t einen  Baum Nodes aus einem Stream
  //Dabei wird zus�tzlich zu jedem Knoten das Ereignis OnReadNode aufgerufen
  //Das Ereignis wird aufgerufen nachdem der Knoten gelesen , erzeugt und dem Baum hinzugef�hrt wurde
  //So kann z.B. die Eigenschaft Data ge�ndert werden , oder aber auch alle Anderen
  //Der R�ckgabewert ist die Anzahl der gelesenen Bytes
function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream;
  OnReadNode: TOnStreamingNode): longint; overload;
function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream;
  OnReadNode: TOnStreamingNode2): longint; overload;




implementation

uses dtSystem, dtStringsRes, dtMultimedia;

const 
  StrIndent = #1#2;
  StrIndentLen = Length(StrIndent);


function WriteString(Stream: TStream; Data: string): longint;
var 
  Len: integer;
begin
  Result := 0;
  Len := Length(Data);
  Inc(Result, Stream.Write(StrIndent, Length(StrIndent)));
  Inc(Result, Stream.Write(Len, SizeOf(Len)));
  Inc(Result, Stream.Write(PChar(Data)^, Len));
end;

function SizeOfString(Data: string): longint;
begin
  Result := 0;
  Inc(Result, Length(StrIndent));
  Inc(Result, SizeOf(integer));
  Inc(Result, Length(Data));
end;

function ReadString(Stream: TStream): string;
var 
  Len, i: integer;
  Data: string;
  c: char;
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
var 
  Len: integer;
  i: integer;
begin
  Len := Length(Data);
  Stream.Write(Len, SizeOf(integer));
  for i := 1 to Len do
    Stream.Write(Data[i], 1);
end;                        


function ReadString2a(Stream: TStream): string;
var 
  Len: integer;
  c: char;
  i: integer;
begin
  Stream.Read(Len, SizeOf(integer));
  Result := '';
  for i := 1 to Len do
  begin
    Stream.ReadBuffer(c, 1);
    Result := Result + c;
  end;
end;

procedure WriteString3a(Stream: TStream; Data: string);
var 
  Len: integer;
  p: array[0..511] of char;
begin
  Len := Length(Data);
  Stream.WriteBuffer(Len, SizeOf(integer));

  StrLCopy(@p, PChar(Data), len);

  Stream.WriteBuffer(p, len);
end;

function SizeOfStringBuffer3a(Data: string): longint;
begin
  Result := SizeOf(integer) + Length(Data);
end;


function ReadString3a(Stream: TStream): string;
var 
  Len: integer;
  p: array[0..1023] of char;
  s: string;
begin
  Stream.ReadBuffer(Len, SizeOf(integer));
  Stream.ReadBuffer(p, Len);

  if Len > 0 then
  begin
    SetLength(s, Len);
    StrLCopy(PChar(s), p, Len);
  end
  else 
    s := '';

  Result := s;
end;



function WriteString4(Stream: TStream; Text: string): longint;
var 
  l: integer;
begin
  l := Length(Text);
  Result := Stream.Write(l, SizeOf(l));
  Inc(Result, Stream.Write(Text, l));
end;

function ReadString4(Stream: TStream; var Text: string): longint;
var 
  l: integer;
begin
  Result := -1;
  try
    Result := Stream.Read(l, SizeOf(l));
    Inc(Result, Stream.Read(Text, l));
  except
    Text := '';
  end;
end;

function WriteInteger(Stream: TStream; Data: integer): longint;
begin
  Result := Stream.Write(Data, SizeOf(Data));
end;

function ReadInteger(Stream: TStream): integer;
var 
  i: integer;
begin
  Stream.Read(i, SizeOf(i));
  Result := i;
end;

function WriteBool(Stream: TStream; Bool: boolean): longint;
begin
  Result := Stream.Write(Bool, SizeOf(boolean));
end;

function ReadBool(Stream: TStream): boolean;
begin
  Stream.Read(Result, SizeOf(boolean));
end;


function ReadFileMinStd(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileDataStd; var Data: Pointer): longint;
var 
  S: TFileStream;
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

function ReadFileStd(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileDataStd; var Data: Pointer): longint;
var 
  S: TFileStream;
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

function WriteFileStd(const FileName: string; SignVersion: TSignVersion;
  OnWriteFileData: TOnWriteFileDataStd; Data: Pointer): longint;
var 
  S: TFileStream;
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


function WriteFile(const FileName: string; SignVersion: TSignVersion;
  OnWriteFileData: TOnWriteFileData): longint;
var 
  S: TFileStream;
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

function ReadFileCompatible(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileData; OnReadCompatibleFileData: TOnReadCompatibledFileData): boolean;
var 
  S: TFileStream;
  ss: TSignVersion;
begin
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := True;
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
        Result := False;
    end;
  end
  else
    Inc(Result, OnReadFileData(S));
  S.Free;
end;

function ReadFileExtended(const FileName: string; SignVersion: TSignVersion;
  OnExtReadFileData: TOnExtReadFileData): longint;
var 
  S: TFileStream;
  V: TSignVersion;
begin
  if not Assigned(OnExtReadFileData) then
  begin
    raise Exception.Create(dtStream_ReadFileExtended_Error);
    exit;
  end;
  S := TFileStream.Create(FileName, fmOpenRead);
  Result := 0;

  V := ReadSignVersion(S);
  Inc(Result, OnExtReadFileData(S, V, SignVersion));

  S.Free;
end;

function ReadFile(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileData): longint;
var 
  S: TFileStream;
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


function ReadFileMin(const FileName: string; SignVersion: TSignVersion;
  OnReadFileData: TOnReadFileData): longint;
var 
  S: TFileStream;
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










function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream;
  OnReadNode: TOnStreamingNode): longint;
  function ReadNode(S: TStream; TreeNodes: TTreeNodes): longint;
  var 
    Index: integer;
    Text: string;
    Node: TTreeNode;
  begin
    Result := 0;

    Text := ReadString3a(S);
    Inc(Result, SizeOfStringBuffer3a(Text));

    Inc(Result, s.Read(Index, SizeOf(Index)));


    if Index <> 0 then
    begin
      Node := TreeNodes.AddChild(TreeNodes[Index -1], Text);
    end
    else
    begin
      Node := TreeNodes.Add(nil, Text);
    end;
    if Assigned(OnReadNode) then
      Inc(Result, OnReadNode(S, Node));
  end;
var 
  i, Count: integer;
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


function ReadTreeNodesFromStream(Nodes: TTreeNodes; Stream: TStream;
  OnReadNode: TOnStreamingNode2): longint;
  function ReadNode(S: TStream; TreeNodes: TTreeNodes): longint;
  var 
    Index: integer;
    Text: string;
    Node: TTreeNode;
  begin
    Result := 0;

    Text := ReadString3a(S);
    Inc(Result, SizeOfStringBuffer3a(Text));

    Inc(Result, s.Read(Index, SizeOf(Index)));


    if Index <> 0 then
    begin
      Node := TreeNodes.AddChild(TreeNodes[Index -1], Text);
    end
    else
    begin
      Node := TreeNodes.Add(nil, Text);
    end;
    if Assigned(OnReadNode) then
      Inc(Result, OnReadNode(S, Node));
  end;
var 
  i, Count: integer;
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


function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream;
  OnWriteNode: TOnStreamingNode): longint;
  function WriteNode(S: TStream; Node: TTreeNode): longint;
  var 
    I: integer;
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
      Inc(Result, s.Write(i, SizeOf(integer)));
    end;
    if Assigned(OnWriteNode) then
      Inc(Result, OnWriteNode(S, Node));
  end;
var 
  i: integer;
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


function WriteTreeNodesToStream(Nodes: TTreeNodes; Stream: TStream;
  OnWriteNode: TOnStreamingNode2): longint;
  function WriteNode(S: TStream; Node: TTreeNode): longint;
  var 
    I: integer;
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
      Inc(Result, s.Write(i, SizeOf(integer)));
    end;
    if Assigned(OnWriteNode) then
      Inc(Result, OnWriteNode(S, Node));
  end;
var 
  i: integer;
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


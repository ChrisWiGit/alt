{
@abstract(dtDirectSocketProtokoll.pas beinhaltet Funktionen f�r den Umgang mit Streams bei DelphiX)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)

 dtDirectSocketProtokoll vereinfacht die Hantierung bei TDxPlay bei DelphiX
 Damit ist es nun m�glich , beliebig gro�e Daten zu verschicken und
 mit einem Nachrichtenidentifizierer zu versehen.

 Um diese Funktionen zu verwenden, setzen Sie die Compilerdirektive USEDELPHIX.
 (*$DEFINE USEDELPHIX*).
 Offiziell gibt es DelphiX auf http://www.yks.ne.jp/~hori/DelphiX-e.html
 inofiziell dort : http://www.gamedev.net/

 Das DirectSocketProtokoll kann man unter www.vclcomponents.com download, jedoch wird diese Version nicht mehr
 unterst�tzt.

 Nutzen Sie auch die mitgelieferte und erweiterte DXPlay-Unit (bis Delphiversion 5).
 Sie l�st Probleme, die auftreten wenn man einen Spieler w�hrend des Ereignisses OnMessage l�schen will.
 Dadurch kann man das Objekt noch am Ende ohne Fehler l�schen.
}

unit dtDirectSocketProtokoll;

interface

uses
  Windows, Messages, SysUtils, Classes, DirectX,DXPlay;


type
   {Mit TMessageType kann die Typ-Gr��e von Msg und SubMsg schnell ge�ndert werden}
   TMessageType = Integer;


const
     {MessageTypeError wird als anderer Fehlerwert f�r @link(ReceiveStream) verwendet}
     MessageTypeError = -1;


const
      {Signatur die eine Nachricht als echt ausweist}
      Signature = 12345;



{SendStream sendet einen Stream mit dem Messagetyp Msg und SubMsg an ToID
Msg und SubMsg sind vom Programmierer frei w�hlbar.
Stream muss danach freigegeben werden
Mann kann nat�rlich auch leeren Stream (= nil) senden}
function SendStream(DXPlay : TDXPlay;ToID:DPID; Msg,SubMsg : TMessageType;Stream : TMemoryStream) : Boolean;



{ReceiveStream empf�ngt eine Nachricht und wertet sie aus.
Wenn es eine mit Sendstream gesendete nachricht ist so wird TRUE zur�ckgegeben und die variablen Parameter
Msg,SubMsg und Stream haben g�ltige Werte
Stream darf nicht initialisiert werden}
function ReceiveStream(Data : Pointer; Size : Longint;var Msg,SubMsg : TMessageType;var Stream : TMemoryStream) : Boolean;



{AssembleStream verkn�pft eine Nachricht und einen Stream zu einen versendbaren Stream
Stream wird in @link(AssembleStream) NICHT gel�scht!
Diese Funktion wird intern verwendet.}

function AssembleStream(Msg,SubMsg : Integer; Stream : TMemoryStream) : TMemoryStream;


{Entkn�pft eine versendbaren Stream in Nachricht (Msg,SubMsg) und einen LeseStream "Stream"
Stream wird in @link(DisAssembleStream) erstellt!
Diese Funktion wird intern verwendet.
}
function DisAssembleStream(Source : TMemoryStream;var Msg,SubMsg : TMessageType;var Stream : TMemoryStream) : Boolean;


{WriteString schreibt einen String beliebiger L�nge in einen Stream
Jeder String besitzt zus�tzlich noch eine Indentifizierungsnummer (#1#2),
um ihn eindeutig als solchen erkennen zu k�nnen.
Diese Funktion wird intern verwendet.
}
function WriteString(Stream:TStream; Data : String) : Longint;




{ReadString liest den mit WriteString gespeicherten String wieder aus
Bei Fehlern in der Indentifizierung wird eine leerer String ('') zur�ckgeliefert}
function  ReadString (Stream:TStream) : String;

{SizeOfString gibt die Bytesgr��e die ein String im Stream braucht ,wenn er von WriteString
geschrieben wurde}
function SizeOfString(Data : String) : Longint;
                               



{WriteInteger speichert einen Integer-Wert im Stream ohne Signatur}
function WriteInteger(Stream:TStream; Data : Integer) : Longint;

{ReadInteger liest einen Integerwert aus einem Stream}
function ReadInteger (Stream:TStream) : Integer;




implementation

type TCMemoryStream = class (TCustomMemoryStream) 
                                                 //damit die Methode SetPointer �ffentlich zug�nglich wird
 					         //so we can access the methode SetPointer
     public
       procedure SetPointer(Ptr: Pointer; Size: Longint);
     end;

procedure TCMemoryStream.SetPointer(Ptr: Pointer; Size: Longint);
begin
  inherited;
end;


function ReceiveStream(Data : Pointer; Size : Longint;var Msg,SubMsg : TMessageType;var Stream : TMemoryStream) : Boolean;
var DestStream : TCMEmoryStream;
    Count : Longint;
begin
  Result := FALSE;

  Msg := MessageTypeError;
  SubMsg := MessageTypeError;
  Stream := nil;
  Count := Size;

  DestStream := TCMEmoryStream(TMemoryStream.Create);

  try
   DestStream.SetPointer(Data,Count); //empfangene Daten in den Stream , received data into the stream
  except
   DestStream.Free;
   exit;
  end;

  Result := DisAssembleStream(TMemoryStream(DestStream),Msg,SubMsg,Stream); //den empfangenen Stream entschl�sseln , disassemble received stream 
  //die Position ist danach auf Stream.Size , after that position has the value of Stream.Size
  if Assigned(Stream) then
    Stream.Position := 0;

  DestStream.Free;
end;

function SendStream(DXPlay : TDXPlay;ToID:DPID; Msg,SubMsg : TMessageType;Stream : TMemoryStream) : Boolean;

var DestStream : TMemoryStream;
    Count : Longint;
begin
  DestStream := TMemoryStream(AssembleStream(Msg,SubMsg,Stream));

  Count := DestStream.Size;
  DXPlay.SendMessage(ToID,DestStream.Memory,Count); //An ToID den Stream senden , send stream to ToID
  Result := TRUE;
  DestStream.Free;
end;

function DisAssembleStream(Source : TMemoryStream;var Msg,SubMsg : Integer;var Stream : TMemoryStream) : Boolean;


var Sign : Integer;
//    Size ,
    SourceSize  : Longint;
begin
  Result := FALSE;
  if not Assigned(Source) or (Source.Size <= 0) then exit;
  try                        //auf ganz sicher gehen
   Sign := ReadInteger(Source);
  except
   exit;
  end;
  if Sign <> Signature then exit; //unbekannte Daten ausfiltern , received stream is not a valid stream for us

  Msg    := ReadInteger(Source);
  SubMsg := ReadInteger(Source);
//  Size   := ReadInteger(Source); //unbenutzt , unused
  SourceSize   := ReadInteger(Source);  //so gro� ist der Datenstream , size of datastream (stream)

  if SourceSize > 0 then
  begin
    Stream := TMemoryStream.Create;
    Stream.CopyFrom(Source,SourceSize); //... und herdamit , get it
  end;

  Result := TRUE;
end;

function AssembleStream(Msg,SubMsg : TMessageType; Stream : TMemoryStream) : TMemoryStream;
begin
  Result := TMemoryStream.Create;
  WriteInteger(Result,Signature);
  WriteInteger(Result,Msg);
  WriteInteger(Result,SubMsg);
//  WriteInteger(Result,Result.Size);

  if Assigned(Stream) then
  begin
    WriteInteger(Result,Stream.Size);
    Result.CopyFrom(Stream,0);
  end
  else
   WriteInteger(Result,0);
end;

const StrIndent = #1#2;
      StrIndentLen = Length(StrIndent);

function SizeOfString(Data : String) : Longint;
begin
  Result := 0;
  Inc(Result,Length(StrIndent));
  Inc(Result,SizeOf(Integer));
  Inc(Result,Length(Data));
end;
function WriteString(Stream:TStream; Data : String) : Longint;
var Len : Integer;
begin
  Result := 0;
  Len := Length(Data);
  Inc(Result,Stream.Write(StrIndent,Length(StrIndent)));
  Inc(Result,Stream.Write(Len,SizeOf(Len)));
  Inc(Result,Stream.Write(PCHAR(Data)^,Len));
end;


function ReadString (Stream:TStream) : String;
var Len,i : Integer;
    Data : String;
    c : Char;
    p : array[0..StrIndentLen-1] of char;
begin
  Result := '';
  try
   Stream.Read(p,Length(StrIndent));
  except
  end;
  if CompareStr(StrIndent,String(p)) <> 0 then exit;
  Stream.Read(Len,SizeOf(Len));
  Data := '';
  for i := 0 to Len-1 do
  begin
   Stream.Read(c,1);
   Data := Data+c;
  end;
  Result := Data;
end;


function ReadInteger (Stream:TStream) : Integer; 
var i : Integer;
begin
  Stream.Read(i,SizeOf(i));
  Result := i;
end;

function WriteInteger(Stream:TStream; Data : Integer) : Longint;
begin
  Result := Stream.Write(Data,SizeOf(Data));
end;


end.

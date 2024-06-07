{
@abstract(dtSocketProtokoll.pas beinhaltet Funktionen f�r den Umgang mit Streams bei Sockets)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)

 dtSocketProtokoll vereinfacht die Hantierung bei TServerSocket und TClientSocket mit Streams
 Damit ist es nun m�glich , beliebig gro�e Daten zu verschicken und
 mit einem Nachrichtenidentifizierer zu versehen
 BETA 3 VERSION  !!!!!!!

 Das DirectSocketProtokoll kann man unter www.vclcomponents.com download, jedoch wird diese Version nicht mehr
 unterst�tzt.
}
unit dtSocketProtokoll;

interface

uses
  Windows, Messages, SysUtils, Classes,Graphics,StdCtrls,
  ScktComp;


type
     {Mit TMessageType kann die Typ-Gr��e von Msg und SubMsg schnell ge�ndert werden}
     TMessageType = Integer;

     {TOnSendMessage wird aufgerufen, wenn eine Nachricht gesendet wird.
     Count = Anzahl von Sendeversuchen;
     WaitTime = Anzahl von Milisekunden , die gewartet werden sollen , bis ein weiterer Sende-Versuch gemacht werden. (Standard = 10);
     Break = Abbruch des Sende-Versuch}
     TOnSendMessage = procedure (Socket:TCustomWinSocket; Count : Integer;var WaitTime : Integer; var Break : Boolean) of object;


const  {MessageTypeError wird als anderer Fehlerwert f�r @link(ReceiveStream) verwendet}
       MessageTypeError = -1;

const
      {Signatur die eine Nachricht als echt ausweist}
      Signature : Integer = 12345;



{SendStream sendet einen Stream mit dem Messagetyp Msg und SubMsg an Socket
Stream muss danach freigegeben werden
Nicht identisch mit TServersocket/TClientSocket.SendStream !!
      ReceiveStream erkennt diese abgeschickten Nachricht nicht.
Mann kann nat�rlich auch Stream = nil senden
Warnung : Mehr als (8*1024 - 16) Bytes zu senden wird aufgrund des zu kleinen WinSock Puffers fehlschlagen!!!!
          (2*1024 - 16) ist meine Empfehlung.
Der R�ckgabewert ist die Anzahl von Bytes


OnMessage wird immer dann aufgerufen , wenn das Senden aufgrund eines zu kleinen WinSock Puffers fehlgeschlagen ist.
SendStream Funktion kehrt erst dann zur�ck wenn der Puffer gef�llt wurde.
D.h. aber nicht , dass die Daten schon gesendet wurden!!!
}
function SendStream(Socket:TCustomWinSocket; Msg,SubMsg : TMessageType;Stream : TMemoryStream; OnMessage : TOnSendMessage) : Longint; overload;


{SendStream kehrt sofort zur�ck , und gibt bei einem zu kleinem Puffer -1 zur�ck - Siehe DelphiHilfe -> SendBuf}
function SendStream(Socket:TCustomWinSocket; Msg,SubMsg : TMessageType;Stream : TMemoryStream) : Longint; overload;


{GetPufferStreamSize gibt die Gr��e des gesendeten Streams + extra Informationen zur�ck (Msg , SubMsg,...)
extra Informationen haben Standardm��ig eine Gr��e von 16 Bytes (abh�ngig vom Typ TMessageType)}
function GetPufferStreamSize(Stream : TStream) : Longint;


{Sollte als einzige Funktion in Empfangs-Nachrichten (TClientSocket.OnRead;TServerSocket.OnClienRead/OnClientWrite)
eingetragen sein. D.h. nach dem Aufruf ist der Nachrichtenpuffer leer!
in Msg ( und SubMsg) steht dann der Typ der Nachricht , oder wenn fehlerhaft  : MessageTypeError (-1) und der
R�ckgabewert FALSE
Stream wird immer erstellt , au�er es wurde SendStream mit nil aufgerufen
Stream wird evtl. auch dann mit Daten gef�llt , wenn ReceiveStream FALSE zur�ckliefert.
Diese Daten wurden dann auf eine andere Art gesendet (Bsp. Socket.SendBuf)

Ein Beispiel gibt es in der Datei : SocketBsp.txt


}
function ReceiveStream(Socket:TCustomWinSocket; Count : Longint; var Msg,SubMsg : TMessageType; var Stream : TMemoryStream) : Boolean;



{AssembleStream verkn�pft eine Nachricht und einen Stream zu einen versendbaren Stream
Stream wird in AssembleStream NICHT gel�scht!
Diese Funktion wird intern verwendet.
}
function AssembleStream(Msg,SubMsg : Integer; Stream : TMemoryStream) : TMemoryStream;



{DisAssembleStream entkn�pft eine versendbaren Stream in Nachricht und einen LeseStream
Stream wird in DisAssembleStream erstellt!
Diese Funktion wird intern verwendet.
}
function DisAssembleStream(Source : TMemoryStream;var Msg,SubMsg : TMessageType;var Stream : TMemoryStream) : Boolean;




implementation
uses Dialogs;
type TCMemoryStream = class (TCustomMemoryStream) //damit die Methode SetPointer �ffentlich zug�nglich wird
     public
       procedure SetPointer(Ptr: Pointer; Size: Longint);
     end;

procedure TCMemoryStream.SetPointer(Ptr: Pointer; Size: Longint);
begin
  inherited;
end;

function ReceiveStream(Socket:TCustomWinSocket; Count : Longint; var Msg,SubMsg : TMessageType; var Stream : TMemoryStream) : Boolean;
var DestStream : TCMEmoryStream;
    Ptr : Pointer;
//    Count : Longint;
begin
  Result := FALSE;
  if not Assigned(Socket) then
   raise Exception.Create('Socket darf nicht nil sein');

//  Count := Socket.ReceiveLength;

{  if Count <= 0 then
  begin
     MessageDlgExt('(Source.Size <= 0) then'+return+
     'Size : %d ',[count],mtInformation,[mbok],0);
  end;}

  Msg := MessageTypeError; SubMsg := MessageTypeError;
  Stream := nil;

  GetMem(Ptr,Count);
  try
    Count := Socket.ReceiveBuf(Ptr^,Count); //Daten in Speicher lesen
  except
    FreeMem(Ptr);
    MessageDlg('Socket.Receive-Fehler',mtInformation,[mbok],0);
    exit;
  end;
  //Datenpuffer ist nun leer
  //weiter aufrufe von Receive.... sind unnuetz

  DestStream := TCMEmoryStream(TMemoryStream.Create);


  try
   DestStream.SetPointer(Ptr,Count); //Den Zeiger �bergeben
  except
   DestStream.Free;
   FreeMem(Ptr);
   MessageDlg('SetPointer-Fehler',mtInformation,[mbok],0);
   exit;
  end;

  DestStream.Position := 0;
  Result := DisAssembleStream(TMemoryStream(DestStream),Msg,SubMsg,Stream); //den empfangenen Stream entschl�sseln

  if (not Result) and (DestStream.Size > 0) then      //gibt auch den Inhalt von unbekannten Daten zur�ck
  begin
    DestStream.Position := 0;
    Stream := TMemoryStream.Create;
    Stream.CopyFrom(DestStream,DestStream.Size);
  end;


  if Assigned(Stream) then
   Stream.Position := 0;  //die Position ist danach auf Stream.Size

  DestStream.Free;
//  FreeMem(Ptr,Count);  //darf nicht freigegeben werden , da DestStream.Free das schon macht
end;


function SendStream(Socket:TCustomWinSocket; Msg,SubMsg : TMessageType;Stream : TMemoryStream; OnMessage : TOnSendMessage) : Longint;
var Count : Integer;
    Break : Boolean;
    DestStream : TMemoryStream;
    WaitTime : Integer;
begin
  DestStream := TMemoryStream(AssembleStream(Msg,SubMsg,Stream));

  Count := 1;
  Break   := FALSE;
  WaitTime := 10;
  repeat
    Result := Socket.SendBuf(DestStream.Memory^,DestStream.Size); //An Socket den Stream senden
    if Result = -1 then
    begin
      if Assigned(OnMessage) then OnMessage(Socket,Count,WaitTime,Break);
      Sleep(WaitTime); //we'll wait a few miliseconds
      Inc(Count);
    end;
  until (Result <> -1) or Break;

  if Break then Result := -1;

  DestStream.Free;
end;


function SendStream(Socket:TCustomWinSocket; Msg,SubMsg : TMessageType;Stream : TMemoryStream) : Longint;
var Count : Longint;
    DestStream : TMemoryStream;
begin
  DestStream := TMemoryStream(AssembleStream(Msg,SubMsg,Stream));
  Count := DestStream.Size;

  Result := Socket.SendBuf(DestStream.Memory^,Count); //An Socket den Stream senden
  DestStream.Free;
end;

function DisAssembleStream(Source : TMemoryStream;var Msg,SubMsg : Integer;var Stream : TMemoryStream) : Boolean;

function  ReadInteger (Stream:TStream) : Integer; //schnell einen Integerwert speichern
var i : Integer;
begin
  Stream.Read(i,SizeOf(i));
  Result := i;
end;

var Sign : Integer;
//    Size ,
    SourceSize,
    DataSize  : Longint;
begin
  Result := FALSE;
  if not Assigned(Source) or (Source.Size <= 0) then
  begin
{    MessageDlgExt('if not Assigned(Source) or (Source.Size <= 0) then'+return+
     '1. %d  , Size : %d ',[Integer(Assigned(Source)),Source.Size],mtInformation,[mbok],0);}
    exit;
  end;
  try                        //auf ganz sicher gehen
   Sign := ReadInteger(Source);
  except
   MessageDlg('Fehlerhafte Signatur',mtInformation,[mbok],0);
   exit;
  end;
{  MessageDlgExt('ClientSign : %d'+return+'ServerSign : %d',[Sign,Signature],mtInformation,[mbok],0);}
  if Sign <> Signature then exit; //unbekannte Daten ausfiltern

  Msg    := ReadInteger(Source);
  SubMsg := ReadInteger(Source);
//  Size   := ReadInteger(Source); //unbenutzt
  SourceSize   := ReadInteger(Source);  //so gro� ist der Datenstream

  DataSize := Source.Size - Source.Position;
  //(3*SizeOf(Integer));

  if DataSize <> SourceSize then
  begin
    result := FALSE;
    //raise Exception.CreateFmt('The data size of %d Bytes is not equal to the expected size of %d Bytes',[Datasize,SourceSize]);
  end
  else
  if (SourceSize > 0) then
  begin
    Stream := TMemoryStream.Create;
    Stream.CopyFrom(Source,SourceSize); //... und herdamit
  end;

  Result := TRUE;
end;

function GetPufferStreamSize(Stream : TStream) : Longint;
function GSize : Longint;
begin
  if Assigned(Stream) then
   result := Stream.Size
  else result := 0;
end;
begin
  Result := SizeOf(Signature) +      //Signature length
            2*SizeOf(TMessageType) +  //Msg and SubMsg
            SizeOf(Longint) +        //stream data - size length
            GSize;  
end;

function AssembleStream(Msg,SubMsg : TMessageType; Stream : TMemoryStream) : TMemoryStream;
function WriteInteger(Stream:TStream; Data : Integer) : Longint;
begin
  Result := Stream.Write(Data,SizeOf(Data));
end;
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
  if Result.Size <= 0 then
   MessageDlg('AssembleStream : result(TmemoryStream).size = 0',mterror,[mbok],0);
end;

end.

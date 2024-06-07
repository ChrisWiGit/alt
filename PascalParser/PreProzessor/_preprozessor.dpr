program preprozessor;

{$APPTYPE CONSOLE}

uses
  SysUtils,Dialogs,Classes,SParser;
{Der Sinn des Preprozessors besteht darin, alle Compilerdirektiven zu erkennen,
und wenn erforderlich zu entfernen.
in einem Stream ist es nicht möglich Zeichen zu entfernen!
man kann aber einen zweiten stream dazu verwenden, um dort das hintereinander zu reinzuschreiben, was
der alte stream beherbergt. Die CopyFrom funktion ist hier sehr hilfreich

SourceStream, DestStream

Lesen aus SourceStream -> auswerten, wenn z.b. das ausgewertete verwende werden soll
dann
  Source.Position := wo starten
  DestStream.CopyFrom(SourceStream, <anzahl der Bytes);
wenn etwas übersprungen werden soll :
 Source.Position := position an die stelle wo es weitergehen soll z.b. nach (*$ENDIF*) = überspringen
->und weitermachen

übrigens muss nur bis implementation gescannt werden!
}

function PreParseUnit(aUnit : TTextStream) : Boolean;
Var R,S:String;
    Defines:Array Of String;
begin
  Repeat
    If aUnit.LeaveSpaces(True)='{' Then Begin
      R:=aUnit.GetNextChars(4,0,True);
      If UpperCase(R)='$DEF' Then Begin //{$DEFINE...
        aUnit.GetNextChars(4,0,True);
        R:='';
        Repeat
          S:=aUnit.GetNextChars(1,0,True);
          IF S<>'}' Then R:=R+S Else Break;
        Until R='}';
        SetLength(Defines, Length(Defines)+1);
        Showmessage(R);
        Defines[Length(Defines)-1]:=R;//Define Memory
      End;//End $DEFINE
    End;

  Until aUnit.EOF;
end;

var InStream : TTextStream;
    OutStream : TFileStream;
    NewName,OpenName : String;

begin
  { TODO -oUser -cConsole Main : Insert code here }

  {OpenName ist die Eingabe-Datei}
//  OpenName := ParamStr(1);

  OpenName := 'F:\Projekte D7\PascalParser\testunits\compilerdirektiven.pas';

  {NewName ist die AusgabeDatei}
  NewName := ExtractFileDir(OpenName)+'\Output.txt';

  //InStream - Eingabestream zum Lesen, dieses Create gibt es nur bei TTextStream, nicht bei TMemoryStream
  InStream := TTextStream.Create(OpenName,fmOpenRead);

  //OutStream - Ausgabestream zum schreiben
  OutStream := TFileStream.Create(NewName,fmCreate or fmOpenWrite);

  PreParseUnit(InStream);

  //Von InStream alles nach OutStream kopieren zum schreiben
  OutStream.CopyFrom(InStream,0);
   
  OutStream.Free;
  InStream.Free;
end.

{
@abstract(dtDelphiX.pas beinhaltet Funktionen f�r den Umgang mit DelphiX)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}
unit dtDelphiX;

{DEFINE USEDELPHIX}

interface
uses windows,classes
{$IFDEF USEDELPHIX}
 {USE DELPHIX muss selbst definiert werden , damit sind folgende funktionen verf�gbar :
  SaveRGBQuadsToStream,ReadRGBQuadsToStream}
  , DirectX,
  DIB
{$ENDIF}
 ;


{$IFDEF USEDELPHIX}
{SaveRGBQuadsToStream speichert ein RGBQuads Typ in einen Stream.
Der R�ckgabewert ist die Anzahl der gespeicherten Bytes.
Hinweis : Zur Nutzung dieser Funktion muss die Compilerdirektive :
 USEDELPHIX definiert worden sein. $DEFINE USEDELPHIX (in geschweiften Klammern)
Siehe auch @link(ReadRGBQuadsToStream).}
function SaveRGBQuadsToStream(Stream: TStream; RGBQuads: TRGBQuads): Longint;
{ReadRGBQuadsToStream l�dt ein RGBQuads Typ aus einen Stream.
Der R�ckgabewert ist die Anzahl der geladenen Bytes.
Hinweis : Zur Nutzung dieser Funktion muss die Compilerdirektive :
 USEDELPHIX definiert worden sein. $DEFINE USEDELPHIX (in geschweiften Klammern)
Siehe auch @link(SaveRGBQuadsToStream)}
function ReadRGBQuadsToStream(Stream: TStream): TRGBQuads;
{$ENDIF}


implementation

{$IFDEF USEDELPHIX}

function SaveRGBQuadsToStream(Stream: TStream; RGBQuads: TRGBQuads): Longint;
begin
  Result := Stream.Write(RGBQuads, SizeOf(RGBQuads));
end;

function ReadRGBQuadsToStream(Stream: TStream): TRGBQuads;
begin
  Stream.Read(Result, SizeOf(Result));
end;
{$ENDIF}

end.

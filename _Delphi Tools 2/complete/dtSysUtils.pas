{
@abstract(dtSysUtils.pas beinhaltet Funktionen f�r den Umgang mit verschiedenen Aufgaben)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtSysUtils;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

var
    {CRCTableCalculated wird in @link(calcCRC32) verwendet,um festzulegen, ob
    eine CRC-Tabelle erzeugt werden soll (Standardm��ig wird keine erzeugt)}
    CRCTableCalculated : boolean = False;

type {CRCT ist eine CRC-Tabelle, die in @link(calcCRC32) geltung findet}
     CRCT = array [0..16383] of byte;


type {TPascalError wird in @link(ValidatePascalIdentfier) und @link(ValidateAnchorIdentfier) verwendet,
um Fehler darzustellen.
pe_InvalidChar bedeutet ein ung�ltiges zeichen in Ident.
pe_NoIdent bedeutet, dass Ident aus mehreren W�rtern besteht , die mit Leerzeichen getrennt sind
pe_InvalidIdent bedeutet, dass der Bezeichner mit einer Zahl anf�ngt.
}

     TPascalError = (pe_NoError,
                     pe_InvalidChar,  //ung�ltiges zeichen
                     pe_NoIdent,      //Ident besteht aus mehreren W�rtern, die mit Leerzeichen getrennt sind
                     pe_InvalidIdent //der bezeichner f�ngt mit einer Zahl an
                     );

{Berechnet eine CRC Pr�fsumme
gefunden:  http://www.delphi-total.de/probs/a167.htm}
function calcCRC32(crcAnt : longint; buffer : CRCT; size : longint) : longint;
{Berechnet eine CRC Pr�fsumme aus einer Datei.}
function CRC32(AFile : string) : longint;

{ValidatePascalIdentfier pr�ft, ob ein Pascal-Bezeichner Ident g�ltig ist, oder nicht.
Der R�ckgabewert gibt mehr Aufschluss �ber die Fehlerart (@link(TPascalError))}
function ValidatePascalIdentfier(Ident : String; out Line: Integer) : TPascalError;

{ValidateAnchorIdentfier pr�ft, ob ein Pascal-Bezeichner Ident g�ltig ist, oder nicht.
Der Unterschied zu @link(ValidatePascalIdentfier) besteht darin, dass ValidateAnchorIdentfier
auch folgende Symbole zul�sst : (' ','-',':','.')
Der R�ckgabewert gibt mehr Aufschluss �ber die Fehlerart (@link(TPascalError))}
function ValidateAnchorIdentfier(Ident : String; out Line: Integer) : TPascalError;

implementation
uses dtSystem,dtStringsRes;

var  crcTable : array [0..255] of longint;

procedure calcCRCTable;
var c   : longint;
    n,k : integer;
 begin
   for n:=0 to 255 do
    begin
     c:=n;
     for k:=0 to 7 do
      begin
       if (c and 1)=1 then
        c:=$edb88320 xor (c shr 1)
       else
        c := c shr 1;
      end;
     crcTable[n]:=c;
    end;
   CRCTableCalculated := True;
 end;

function calcCRC32(crcAnt : longint; buffer : CRCT; size : longint) : longint;
var i : longint;
 begin
  crcAnt:=crcAnt xor $FFFFFFFF;
  for i:=0 to pred(size) do
   crcAnt:=crcTable[(crcAnt xor buffer[i]) and $FF] xor (crcAnt shr 8);
  calcCRC32:=crcAnt xor $FFFFFFFF;
 end;

function CRC32(AFile : string) : longint;
var F         : TFileStream;
    B         : CRCT;
    BytesRead : longint;
    crcTemp   : longint;
 begin
  if not CRCTableCalculated then CalcCRCTable;
  F:=TFileStream.create(AFile,fmOpenRead);
  crcTemp:=$00000000;
  repeat
   BytesRead:=F.Read(B,16384);
   CRCTemp:=calcCRC32(crcTemp,B,BytesRead);
  until BytesRead=0;
  CRC32:=CRCTemp;
  F.free;
end;

function ValidatePascalIdentfier(Ident : String; out Line: Integer) : TPascalError;
var p,add : Integer;
begin
  Line := 1;
  add  := 0;
  while (Line <= Length(ident)) do
  begin
    if ident[Line]= ' ' then
    begin
      delete(ident,1,1);
      Line := 0;
      Inc(add);
    end
    else
     break;
    inc(Line);
  end;

  if Length(ident) > 0 then
  begin
    Line := 1;
    if (Upcase(ident[Line]) in ['0','1'..'9']) then
    begin
      result := pe_InvalidIdent;
      Inc(Line,add);
      exit;
    end;

    while (Line <= Length(ident)) do
    begin
      if (ident[line] = ' ') and (line+1 <= Length(ident)) and (ident[line+1] <> ' ')  then
      begin
        result := pe_NoIdent;
        Inc(Line,add);
        exit;
      end;

      if not (Upcase(ident[Line]) in ['0','1'..'9','A'..'Z','_',' ']) then
      begin
        result := pe_InvalidChar;
        Inc(Line,add);
        exit;
      end;

      inc(Line);
    end;
  end;

  result := pe_NoError;
end;

function ValidateAnchorIdentfier(Ident : String; out Line: Integer) : TPascalError;
var p,add : Integer;
begin
  Line := 1;
  add  := 0;
  while (Line <= Length(ident)) do
  begin
    if ident[Line]= ' ' then
    begin
      delete(ident,1,1);
      Line := 0;
      Inc(add);
    end
    else
     break;
    inc(Line);
  end;

  if Length(ident) > 0 then
  begin
    Line := 1;
    if (Upcase(ident[Line]) in ['0','1'..'9']) then
    begin
      result := pe_InvalidIdent;
      Inc(Line,add);
      exit;
    end;

    while (Line <= Length(ident)) do
    begin
      if (ident[line] = ' ') and (line+1 <= Length(ident)) and (ident[line+1] <> ' ')  then
      begin
        result := pe_NoIdent;
        Inc(Line,add);
        exit;
      end;

      if not (Upcase(ident[Line]) in ['0','1'..'9','A'..'Z','_',' ','-',':','.']) then
      begin
        result := pe_InvalidChar;
        Inc(Line,add);
        exit;
      end;

      inc(Line);
    end;
  end;

  result := pe_NoError;
end;
end.

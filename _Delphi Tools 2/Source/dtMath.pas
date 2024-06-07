{
@abstract(dtMath.pas beinhaltet Funktionen f�r den Umgang mit Mathematik)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}
unit dtMath;

interface
uses Windows,SysUtils;


const
      {WordBitLength ist die L�nge eines Word in Bitdarstellung}
      WordBitLength = (SizeOf(Word) * 4); {8 Bit}
      {DWordBitLength ist die L�nge eines DWord in Bitdarstellung}
      DWordBitLength = (SizeOf(DWord) * 4);

type
  {TScreens wird von @link(ScreenToPercent) und @Link(PercentToScreen) verwendet,
  um Breite und H�he des Bildschirms zu speichern}
  TScreens = record
    Width, Height: Word;
  end;

  {TScreens wird von @link(ScreenToPercent) und @Link(PercentToScreen)  verwendet,
  um Breite und H�he des Bildschirms in Prozent zu speichern}
  TPercent = record
    x, y: Double;
  end;


{BitLinkByte verkn�pft Bit-weise zwei Bytes zu einem Word
Z.B. Integer in einer Bin�r-Datei sind immer in zwei Bytes (die vertauscht sind) gespeichert : D007
     Diese zwei Bytes k�nnen aber nicht ohne weiteres in einen Integerwert transferiert werden
     Deshalb wird Bit1 $D0 und Bit2 $07 zugewiesen um einen Wordwert (2000) zu resultieren

Hinweis : In Bin�r-Dateien sind die Zahlenwerte in der H�lfte ihrer Anzahl von Bits vertauscht :
          Bsp : Bin�r : 10101111 01000000(2 Bytes) , als Integerwert zu lesen = 01000000 10101111 oder BitLinkByte(64,175) =  16559 (Word)
         Steht in der Datei z.B.  $12 $23 $45 $67  , so entspricht dies nicht dem Aufruf von
                                                     BitLinkWord(BitLinkByte($12,$23),BitLinkByte($45,$67))
                                                     sondern , da $12 $23 und $45 $67 vertauscht werden m�ssen :
                                                     BitLinkWord(BitLinkByte($45,$67),BitLinkByte($12,$23)) =  304301415
                                                     Exakt dasselbe Ergebnis liefert BitLinkWordExt($12,$23,$45,$67)
}
function BitLinkByte(bit1, bit2: Byte): Word;

{Transferiert zwei Word-werte zu einem Double-Word -> $12 und $34 zu $3412 (12818)
 mehr dazu siehe @Link(BitLinkByte)
}
function BitLinkWord(bit1, bit2: Word): DWORD;

{Transferiert vier Byte-werte zu einem Dword , dabei werden Bit1 und Bit2 mit Bit3 und Bit4 vertauscht und verkn�pft wiedergegeben
Diese Funktion entspricht der folgenden Aufrufes : Result := BitLinkWord(BitLinkByte(Bit3,Bit4),BitLinkByte(Bit1,Bit2));
mehr dazu siehe @Link(BitLinkByte)
}
function BitLinkWordExt(Bit1, Bit2, Bit3, Bit4: Byte): DWORD;

{WordToBytes und DWordToBytes sind die Gegenfunktionen zu den obeneren Funktionen
WordToBytes liefert das h�her und niederwertige Byte von Worth zur�ck
Diese Funktion ist identisch mit dem Aufruf von Lo f�r Bit2 und Hi f�r Bit1
mehr dazu siehe @Link(BitLinkByte)
}
procedure WordToBytes(Worth: Word; var Bit1, Bit2: Byte);

{ByteToBytes spaltet ein Byte in ein erstes und zweites Bit auf.
mehr dazu siehe @Link(BitLinkByte)
}
procedure ByteToBytes(Worth: Byte; var Bit1, Bit2: Byte);

{DWordToBytes liefert vier Byte-werte aus dem ein DWORD-wert bestehen kann
 mehr dazu siehe @Link(BitLinkByte)
}
procedure DWordToBytes(Worth: DWord; var Bit1, Bit2, Bit3, Bit4: Byte);

{GetBit gibt den Status (gesetzt oder nicht) eines bestimmten Bits (BitNo) von Combination zur�ck
Die Z�hlung f�ngt bei 0 an und h�rt bei 63 (64Bit bei Int64) auf
Es ist allgemein so ,dass das Z�hlen beim Bits rechts und von 0 anf�ngt.
Das erste bit von links ist also das 7 Bit.
mehr dazu siehe @Link(BitLinkByte)
}
function GetBit(Combination: Int64; BitNo: Byte): Boolean;

{ggT ermittelt (rechnerisch) den gr��ten gemeinsamen Teiler zweier Zahlen}
function ggT(a, b: integer): integer;

{kgV ermittelt (rechnerisch) den kleinsten gemeinsamen Teiler zweier Zahlen}
function kgV(a, b: Integer): Integer;

{SetOrgRect setzt die H�he und Weite als Koordinaten um, d.h.
 R.Bottom := Y+Height
 R.Right  := X+ Width}
procedure SetOrgRect(var r: TRect; x, y, width, height: Integer);


{ScreenToPercent berechnet aus einer Gr��e Screen und dem Anteil Pos den Prozentwert
Sie wird dazu verwendet, absolute Koordinaten auf dem Bildschirm unabh�ngig zu anderen
Aufl�sungen zu machen, um so immer z.B. Fenstergr��en und Positionen zu wahren.
}
function ScreenToPercent(Screen: TScreens; Pos: TPoint): TPercent;
{PercentToScreen berechnet aus Prozentwerten (Perc) und den dazugeh�rigen Gr��enangaben Screen,
die Position innerhalb von Screen.
Mehr siehe @link(ScreenToPercent)}
function PercentToScreen(Perc: TPercent; Screen: TScreens): TPoint;

function IsPrim(z: Int64): Boolean;

{Seit DelphiTools Version 1.302 dabei.
Externe Quelle : 0002 (siehe Quelltext)
LongToByte konvertiert einen Longintwert in 4 Bytewerte
}
procedure LongToByte(l : longint; var b1,b2,b3,b4 : byte);

{ByteToLong konvertiert 4 Byte Werte in ein Longint.
Siehe auch @Link(LongToByte)
}
function ByteToLong(b1,b2,b3,b4 : byte) : longint;

{Pow errechnet aus Base und einen beliebigen Wert die Potenz.
Die Funktion arbeitet im Ergebnis mit Int64.}
function pow(base, Exp: Integer): int64;

implementation
uses dtSystem;



function BitLinkByte(bit1, bit2: Byte): Word;
begin
  Result := Bit1 shl (SizeOf(Byte) * 8);
  Result := Result xor Bit2;
end;

function BitLinkWord(bit1, bit2: Word): DWORD;
var l, l2: Longint;
begin
  Result := Bit2 shl
    (sizeof(Word) * 8); //L�nge eines Word-Wertes = 2Bytes |1 Byte = 8 Bits
  Result := Result xor Bit1;
end;


function BitLinkWordExt(Bit1, Bit2, Bit3, Bit4: Byte): DWORD;
begin
  Result := BitLinkWord(BitLinkByte(Bit3, Bit4), BitLinkByte(Bit1, Bit2));
end;

procedure WordToBytes(Worth: Word; var Bit1, Bit2: Byte);
begin
  Bit2 := (Worth shl WordBitLength) shr WordBitLength; // = Lo(Worth);
  Bit1 := (Worth shr WordBitLength); // = Hi(Worth);
end;

procedure ByteToBytes(Worth: Byte; var Bit1, Bit2: Byte);
begin
//$18 - 24 -  11000
//            01100
//            00110
//            00011
// 1       -  00001

  Bit1 := Worth shr 4;
  Bit2 := (Worth shr 4) shl 3;
end;

procedure DWordToBytes(Worth: DWord; var Bit1, Bit2, Bit3, Bit4: Byte);
var w, Lo_w, Hi_w: DWORD;
begin
  w := Worth;
  Hi_w := w shr DWordBitLength;
  Lo_w := (w shl (DWordBitLength - 2)) shr (DWordBitLength - 2);
  Bit1 := Hi(Hi_w);
  Bit2 := Lo(Hi_w);

  Bit3 := Hi(Lo_w);
  Bit4 := Lo(Lo_w);
end;

function GetBit(Combination: Int64; BitNo: Byte): Boolean;
var i: Integer;
begin
  ASSERT((BitNo in [0..63]), 'GetBit : BitNo ist nicht zw. 0 bis 63');

  Result := Combination and (pow(2, BitNo)) = pow(2, BitNo);
end;

function ggT(a, b: integer): integer;
begin
  while a > 0 do
  begin
    if a < b then ChangeVar(a, b);
    a := a - b;
  end;
  ggT := b;
end;

function kgV(a, b: Integer): Integer;
begin
  kgV := (a * b) div ggT(a, b);
end;

procedure SetOrgRect(var r: TRect; x, y, width, height: Integer);
begin
  R.Left := x;
  R.Top := y;
  R.Right := x + Width;
  R.Bottom := y + Height;
end;

function ScreenToPercent(Screen: TScreens; Pos: TPoint): TPercent;
begin
  Result.x := (Pos.X / Screen.Width) * 100;
  Result.y := (Pos.Y / Screen.Height) * 100;
end;

function PercentToScreen(Perc: TPercent; Screen: TScreens): TPoint;
begin
  Result.x := Round(Perc.X * Screen.Width) div 100;
  Result.y := Round(Perc.y * Screen.Height) div 100;
end;


function IsPrim(z: Int64): Boolean;
var t: Int64;
begin
  ASSERT(FALSE,'not implemented yet');
 { result := TRUE;
  if z = 1 then result := FALSE;
  t := 2;
  while t <= trunc(sqrt(Exteded(z*z))) do
    if z mod t = 0 then result := FALSE;
    Inc(t);
  end;
  if z = 2 then result := TRUE;}
end;

procedure LongToByte(l : longint; var b1,b2,b3,b4 : byte);
begin
b1:=byte(l); b2:=byte(l shr 8); b3:=byte(l shr 16); b4:=byte(l shr
24)
end;
function ByteToLong(b1,b2,b3,b4 : byte) : longint;
begin
result:=b1+b2 shl 8+b3 shl 16+b4 shl 24
end;

function pow(base, Exp: Integer): int64;
var i: Integer;
begin
  Result := 1;
  for i := 1 to Exp do
    Result := Base * Result;
end;



end.

unit dtStrings;

interface
uses windows,classes,forms,sysutils;


const StrHexFormatStd = '%s-%s'; //Standard DoubleWord - Stringhexformat
      StrHexFormat: string = StrHexFormatStd;
      HexArray: array[0..15] of char = '0123456789ABCDEF';
type  T16HexBit = string[2];

//Sucht String durch Benutzerfunbktion
type TCallCompareString = function(Index: Integer; StringName: string; StrObject: TObject;CompareWithStr: string): Integer;

type TEnumCharRec = record
    CharCount: array of Longint; //Anzahl von einzelnen Zeichen/gefundene Zahl
    Count, //Gesamtanzahl der Zeichen/der Zahlen
      SingleCharCount: Longint; //Anzahl von Zeichen , ohne daß doppelte mitgezählt worden sind/ für Zahlen : = 0
  end;

type TCharArray = array of Char;

type
  TOnDataWrite = function(Stream: TStream; Index: Integer; aObject: TObject): Longint of object;
  TOnDataRead = function(Stream: TStream; Index: Integer; var aObject: TObject): Longint of object;


//Löscht in einem String alle Leerzeichen #255
function DelSpaces(Str: string): string;


//Verändert alle Zeichen ch im String str zu Toch.
function ChangeChar(str: string; ch, toch: Char): string;

//Kehrt einen String um ABCD -> DCBA
function GetTransString(str: string): string;

//Erstetzt in einem Text den String ReplaceText , unter
//Berücksichtiung der Groß- und Kleinschreibung ,durch
//den Text NewText
function ReplaceStr(const Text, ReplaceText, NewText: string): string;
//Wie ReplaceStr , nur ohne Berücksichtigung der Groß- und
//Kleinschreibung
function ReplaceLStr(const Text, ReplaceText, NewText: string): string;


//Gibt einen Longint-Wert in einen hexdezimalen Wert aus : z.B. $FF



function Hex8ToString(Hexchar: char): Integer;
function Hex16ToString(Hexchar: T16HexBit): Byte;

//Formatiert einen Bit-longint-Wert wie FormHexStr in eine formatierte
//Hexdezimalzahl um
//Die Formatierung bestimmt StrHexFormat
//Jeder String in StrHexFormat ist 4 Zeichen lang (0..9,A..F)
function FormatHexStr(L: DWORD): string;
function FormHexStr(L: DWORD): string;
//Wandelt einen 32-Bit-DWORD-Wert in einen hexdezimalen Wert um (max 8Hexzahlen)
//Max DWORD :  4294967295 -> FFFFFFFF (ohne Vorzeichen!)
function Hex8(L: DWORD): string;
//Wandelt ein vorzeichenlosen 16-Bit-Word-wert in einen hexdezimalen Wert um (max 4Hexzahlen)
//Max Word : 65535 -> FFFF
function Hex4(W: Word): string;
//Wandelt ein vorzeichnlosen 8-Bit-Byte-wert in einen hexdezimalen Wert um (max 2Hexzahlen)
//Max Byte : 255 -> FF
function Hex2(B: Byte): ShortString;
{ Dezimal - Hexdezimal
     01 - 01
     02 - 02
     ..
     09 - 09
     10 - 0A
     11 - 0B
     ...
     15 - 0F
     16 - 10
     17 - 11
     ...
     25 - 19
     26 - 1A
     ....
}

//wandelt eine einstellige Zahl (Bsp : 1) in eine zweistellige : 2 -> 02
function DoubleZero(str: string): string;
function DoubleZeroInt(str: Integer): string;
function Double2ZeroInt(str: Integer; DoIt: Boolean): string;




//Sucht in einer String ohne Groß- und Kleinschreibung zu beachten
function FindString(Strings: TStrings; Str: string): Integer;

function FindStringCall(Strings: TStrings; Proc: TCallCompareString; FindStr: string): Integer;


//Splittet den String Str in mehrere einzelne Strings bei dem Zeichen NewLineChar auf und gibt sie in einer StringListe zurück
//Feature : NewLineChar muß nicht als letztes Zeichen gesetzt sein

function ConvertStringToList(const Str: string; const NewLineChar: Char): TStringList;


//Kovertiert einen String , welcher als Stringbegrenzungen das ";" enthält in eine Stringliste
//siehe auch ConvertStringToList
function ConvertSemiColonStrToStringList(aString: string): TStringList;

//Sucht nach fast beliebigTen Type in einem String Source.
//In FindStrings können nach folgende Typen gesucht werden :
// Integer , Boolean , Char , String
// Bsp . : ..('123 TRUE FalSCH c, FALSE hallo',[123,TRUE,FALSE,'c','hallo',FALSE)
//         ergibt : 1 (für 123)
// boolean - Ausdrücke werden in Deutsch und Englisch verstanden (WAHR,FALSCH,TRUE,FALSE)
// CaseSensitive gibt an ob zwischen Groß- und Kleinschreibung unterschieden werden soll (TRUE)
//Der Rückgabewert ist die Anfangsposition des zuerst gefundenen Strings
//wurde keine Übereinstimmung gefunden , wird 0 zurückgeliefert
function FindInString(Source: string; FindStrings: array of const; CaseSensitive: Boolean = FALSE): Integer;

function _FindInString(Source: string; FindStrings: array of const; var FindStringLen: Integer; CaseSensitive: Boolean = FALSE): Integer;

//Erstellt einen String aus den Bits (Bits) der nur Count Bits enthält
//Bsp : 5 -> 101
function IntToBinStr(Bits: Int64; Count: Byte): string;

//Erstellt einen Integerwert aus einem BitString (BitStr)
//Es werden nur 1 für Bit gesetzt und 0 für nicht gesetzt als Bits erkannt
//Auserdem wird nur bis zu dem ersten ungültigen Zeichen (oder StringEnde)
//die Bitkombination erstellt
function BinStrToInt(BitsStr: string): Int64;

//Dreht einen String um
function ReverseString(Str: string): string;
function DeleteCharsFromString(Text: string; Chars: array of const): string;





//Zählt in einem String die Anzahl des Auftretens aller Zeichen
//Der Rückgabewert ist die Anzahl der Zeichen
function EnumChars(Text: string; var EnumCharRec: TEnumCharRec): Integer;
//Gibt die Anzahl eines Zeichens im String zurück
//Die Berechnung wurde zuvor in EnumChars durchgeführt und muß EnumCharRec übergeben werden
function GetCharCount(aChar: Char; EnumCharRec: TEnumCharRec): Integer;

//Sucht aus einem String alle ganzzahligen Werte (positive und negative)
//der Rückgabewert entspricht dessen Summe
function EnumNumbers(Text: string; var EnumCharRec: TEnumCharRec): Integer;




//Konvertiert einen String in einen Array of char
function StringToTCharArray(Chars: string): TCharArray;

//Gibt die Gesamtanzahl der in Chars angegebenen und in Text gefundenen Zeichen zurück
function EnumSpecChars(Text: string; const Chars: TCharArray): Integer;
//läßt die eckige Klammerschreibweise für Chars zu (Bsp : ['s','d'])
function _EnumSpecChars(Text: string; const Chars: array of char): Integer;

function BOOLToStr(b: Boolean): string;
function BOOLToStrExt(b: Boolean; sTRUE, sFALSE: string): string;




function SaveStringsToStream(StringList: TStrings; Stream: TStream; OnDataWrite: TOnDataWrite = nil): Longint;
function LoadStringsFromStream(StringList: TStringList; Stream: TStream; OnDataRead: TOnDataRead = nil): Longint;


//Wiederholt den String Return (siehe unter Konstanten (oben)) times-Mal
function MultiReturn(Times: Integer): string;

implementation
uses dtSystem,dtMath,dtStream;



function DelSpaces(Str: string): string;
var
  i: Longint;
  s: string;
begin
  s := STR;
  DelSpaces := s;
  if (Length(s) <= 0) then exit;
  i := 1;
  while (i <= Length(s)) do
  begin
    if (Ord(s[i]) = 255) or (Ord(s[i]) = 32) then
    begin
      Delete(S, i, 1);
      i := 0;
    end;
    Inc(i);
  end;
  DelSpaces := s;
end;

function ChangeChar(str: string; ch, toch: Char): string;
var s: string; i: integer;
begin
  s := STR;
  for i := 1 to length(s) do
  begin
    if s[i] = ch then
      s[i] := toch;
  end;
  changechar := s;
end;

function GetTransString(str: string): string;
var i: Integer;
  s: string;
begin
  s := '';
  for i := Length(str) downto 1 do
  begin
    Insert(Str[i], s, Length(s) + 1);
  end;
  REsult := s;
end;

function ReplaceStr(const Text, ReplaceText, NewText: string): string;
var i: Integer;
  t: string;
begin
  Result := Text;
  if ReplaceText = '' then exit;
  if (CompareStr(ReplaceText, NewText) = 0) then exit;
  i := pos(ReplaceText, Text);
  if i <> 0 then
    if CompareStr(ReplaceText, Copy(Text, i, Length(ReplaceText))) <> 0 then
      i := 0;
  t := Text;
  while i <> 0 do
  begin
    if i <> 0 then
    begin
      Delete(t, i, Length(ReplaceText));
      Insert(NewText, t, i);
    end;
    i := pos(ReplaceText, T);
    if i <> 0 then
      if CompareStr(ReplaceText, Copy(T, i, Length(ReplaceText))) <> 0 then
        i := 0;
  end;
  Result := t;
end;

function ReplaceLStr(const Text, ReplaceText, NewText: string): string;
begin
  Result :=
    ReplaceStr(UpperCase(Text),
    UpperCase(ReplaceText),
    UpperCase(NewText));
end;

function Hex8ToString(Hexchar: char): Integer;
var i: Integer;
begin
  for i := Low(HexArray) to High(HexArray) do
    if UpperCase(HexChar) = UpperCase(HexArray[i]) then
    begin
      Result := i;
      exit;
    end;
  raise Exception.CreateFmt('Hex8ToString : %s ist kein gültiger 8Bit Hex-Wert!', [HexChar]);
end;

function Hex16ToString(Hexchar: T16HexBit): byte;
var a, b: Integer;
begin
  if Length(HexChar) = 1 then
  begin
    HexChar[2] := HexChar[1];
    HexChar[1] := '0';
  end;
  if Length(HexChar) = 0 then
    raise Exception.Create('Hex16ToString : Ungültiger Parameter : <Leerstring>.');

  a := Hex8ToString(HexChar[1]);
  b := Hex8ToString(HexChar[2]);
  Result := a * 15 + b + a;
end;

function FormatHexStr(L: DWORD): string;
var s, s2, hexstr: string;
begin
  HexStr := FormHexStr(l);
  Delete(HexStr, 1, 1);
  if (Length(HexStr) mod 2) <> 0 then
    Insert('0', HexStr, 1);
  S := Copy(HexStr, 1, Length(HexStr) div 2);
  while Length(s) < 4 do Insert('0', s, 1);
  S2 := Copy(HexStr, (Length(HexStr) div 2) + 1, Length(HexStr));
  while Length(s2) < 4 do Insert('0', s2, 1);

  Result := Format(StrHexFormat, [s, s2]);

end;

function FormHexStr(L: DWORD): string;
var
  Minus: boolean;
  S: string[20];
begin
  Minus := L < 0;
  if Minus then L := -L;
  S := Hex8(L);
  while (Length(S) > 1) and (S[1] = '0') do Delete(S, 1, 1);
  S := '$' + S;
  if Minus then System.Insert('-', S, 2);
  FormHexStr := S;
end;

function Hex8(L: DWORD): string;
begin Hex8 := Hex4(LongRec(L).Hi) + Hex4(LongRec(L).Lo); end;

function Hex4(W: Word): string;
begin Hex4 := Hex2(Hi(W)) + Hex2(Lo(W)); end;

function Hex2(B: Byte): ShortString;
begin
  Hex2[0] := #2;
  Hex2[1] := HexArray[B shr 4];
  Hex2[2] := HexArray[B and $F];
end;

function DoubleZero(str: string): string;
begin
  if Length(str) = 1 then
    Result := '0' + Str
  else
    Result := str;
end;

function DoubleZeroInt(str: Integer): string;
begin
  Result := DoubleZero(IntToStr(Str));
end;

function Double2ZeroInt(str: Integer; DoIt: Boolean): string;
begin
  if not DoIt then
  begin
    Result := IntToStr(Str);
    exit;
  end;

  if str < 10 then
    Result := '00' + IntToStr(Str)
  else
    if str < 100 then
      Result := '0' + IntToStr(Str)
    else
      Result := IntToStr(Str);
end;

function FindString(Strings: TStrings; Str: string): Integer;
var i: Integer;
begin
  Result := -1;
  if not Assigned(Strings) then exit;
  for i := 0 to Strings.Count - 1 do
  begin
    if CompareText(Str, Strings[i]) = 0 then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function FindStringCall(Strings: TStrings; Proc: TCallCompareString; FindStr: string): Integer;
var i: Integer;
begin
  Result := -1;
  if not Assigned(Strings) then exit;
  if not Assigned(Proc) then exit;
  for i := 0 to Strings.Count - 1 do
  begin
    //if CompareText(Str,Strings[i]) = 0 then
    if Proc(i, Strings[i], Strings.Objects[i], FindStr) = 0 then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function ConvertStringToList(const Str: string; const NewLineChar: Char): TStringList;
var s, ss: string; //String and SubString
  i: Integer;
begin
  Result := TStringList.Create;
  s := Str;
  i := pos(NewLineChar, s);
  while i > 0 do
  begin
    ss := Copy(s, 1, i - 1);
    Delete(s, 1, i);
    Result.Add(ss);
    i := pos(NewLineChar, s);
  end;
  if Length(s) > 0 then
  begin
    ss := Copy(s, 1, Length(s));
    Result.Add(ss);
  end;
end;

function ConvertSemiColonStrToStringList(aString: string): TStringList;
begin
  Result := ConvertStringToList(aString, ';');
end;

function _FindInString(Source: string; FindStrings: array of const; var FindStringLen: Integer; CaseSensitive: Boolean = FALSE): Integer;
  function FindIt(s, s2: string): Longint;
  begin
    if CaseSensitive then
      FindIt := pos(s2, s)
    else
      FindIt := pos(UpperCase(s2), UpperCase(s));
  end;
var i: Integer;
begin
  Result := 0;
  FindStringLen := 0;
  for i := low(FindStrings) to High(FindStrings) do
  begin
    Result := 0;
    if (FindStrings[i].VType = 0) then
    begin
      FindStringLen := Length(IntToStr(FindStrings[i].VInteger));
      Result := FindIt(Source, IntToStr(FindStrings[i].VInteger));
    end
    else
      if (FindStrings[i].VType = 1) then
      begin
        if FindStrings[i].VBoolean then
          Result := _FindInString(Source, ['TRUE', 'WAHR'], FindStringLen, FALSE)
        else
          Result := _FindInString(Source, ['FALSE', 'FALSCH'], FindStringLen, FALSE);
      end
      else
        if FindStrings[i].VType = 11 then
        begin
          FindStringLen := Length(string(FindStrings[i].VPChar));
          Result := FindIt(Source, string(FindStrings[i].VPChar));
        end
        else
          if FindStrings[i].VType = 2 then
          begin
            FindStringLen := Length(string(FindStrings[i].VChar));
            Result := FindIt(Source, string(FindStrings[i].VChar));
          end;
    if Result <> 0 then exit;
  end;
end;

function FindInString(Source: string; FindStrings: array of const; CaseSensitive: Boolean = FALSE): Integer;
  function FindIt(s, s2: string): Longint;
  begin
    if CaseSensitive then
      FindIt := pos(s2, s)
    else
      FindIt := pos(UpperCase(s2), UpperCase(s));
  end;
var i: Integer;
begin
  Result := 0;
  for i := low(FindStrings) to High(FindStrings) do
  begin
    Result := 0;
    if (FindStrings[i].VType = 0) then
      Result := FindIt(Source, IntToStr(FindStrings[i].VInteger))
    else
      if (FindStrings[i].VType = 1) then
      begin
        if FindStrings[i].VBoolean then
          Result := FindInString(Source, ['TRUE', 'WAHR'], FALSE)
        else
          Result := FindInString(Source, ['FALSE', 'FALSCH'], FALSE);
      end
      else
        if FindStrings[i].VType = 11 then
          Result := FindIt(Source, string(FindStrings[i].VPChar))
        else
          if FindStrings[i].VType = 2 then
            Result := FindIt(Source, string(FindStrings[i].VChar));
    if Result <> 0 then exit;
  end;
end;

function BinStrToInt(BitsStr: string): Int64;
  function ExtractBitsFromString(Str: string): string;
  var i: Integer;
  begin
    i := 1;
    Result := '';
    while (i <= Length(Str)) and (Str[i] in ['0', '1']) do
    begin
      Result := Result + Str[i];
      Inc(i);
    end;
  end;
  function BitBool(BitCh: Char): Boolean;
  begin
    Result := BitCh = '1';
  end;
var bits: string;
  i: Integer;
  Data: Int64;
begin
  bits := ExtractBitsFromString(BitsStr);
  Data := 0;
  for i := 1 to Length(Bits) do
  begin
    if BitBool(Bits[i]) then
      Data := Data + Pow(2, Length(Bits) - i);
  end;
  Result := Data;
end;

function IntToBinStr(Bits: Int64; Count: Byte): string;
var i: Integer;
begin
  ASSERT((Count in [1..64]), 'IntToBinStr : Count ist nicht zw. 1 bis 64');
  Result := '';
  for i := Count downto 1 do
  begin
    if GetBit(Bits, i) then
      Result := Result + '1'
    else
      Result := Result + '0';
  end;
end;

function ReverseString(Str: string): string;
var i: integer;
begin
  Result := '';
  for i := Length(Str) downto 1 do
    Result := Result + Str[i];
end;

function DeleteCharsFromString(Text: string; Chars: array of const): string;
var p, len: Integer;
  s: string;
begin
  p := _FindInString(Text, Chars, len);
  Result := Text;
  while p <> 0 do
  begin
    Delete(Result, p, len);
    p := _FindInString(Result, Chars, len);
  end;
end;

function EnumChars(Text: string; var EnumCharRec: TEnumCharRec): Integer;
var i, ActMax: Integer;

begin
  SetLength(EnumCharRec.CharCount, 0);
  FillChar(EnumCharRec, SizeOf(EnumCharRec), 0);
  EnumCharRec.Count := Length(Text);
  Result := 0;
  if EnumCharRec.Count <= 0 then exit;

  ActMax := 0;
  EnumCharRec.SingleCharCount := 0;
  for i := 1 to Length(Text) do
  begin
    with EnumCharRec do
    begin
      if ord(Text[i]) > ActMax then
      begin
        SetLength(CharCount, ord(Text[i]) + 1);
        CharCount[ord(Text[i])] := 0;
        ActMax := ord(Text[i]);
      end;
      if CharCount[ord(Text[i])] <= 0 then
        Inc(EnumCharRec.SingleCharCount);
      Inc(CharCount[ord(Text[i])]);
    end;
  end;
  Result := EnumCharRec.Count;
end;

function GetCharCount(aChar: Char; EnumCharRec: TEnumCharRec): Integer;
begin
  Result := -1;
  if (High(EnumCharRec.CharCount) <= 0) or (EnumCharRec.Count <= 0) then exit;
  if Ord(aChar) > High(EnumCharRec.CharCount) then exit;
  Result := EnumCharRec.CharCount[Ord(aChar)];
end;

function EnumNumbers(Text: string; var EnumCharRec: TEnumCharRec): Integer;
var i, res, v, b: integer;
  zahl, s: string;
const Num = ['-', '+', '0', '1'..'9'];
  Numbers = ['0', '1'..'9'];
  Sums = ['-', '+'];
begin
  zahl := '';
  res := 0;
  EnumCharRec.SingleCharCount := -1;
  EnumCharRec.Count := 0;

  SetLength(EnumCharRec.CharCount, 0);
  for i := 1 to Length(Text) do
  begin
    if ((Text[i] in Numbers)) or ((Text[i] in Sums) and (Length(Zahl) = 0)) then
    begin
      Zahl := Zahl + text[i];
    end
    else
    begin
      if Length(Zahl) > 0 then
      begin
        b := 0;
        if not (Zahl[1] in Num) then
        begin
          Zahl := '';
          if ((Text[i] in Numbers)) or ((Text[i] in Sums) and (Length(Zahl) = 0)) then
          begin
            Zahl := text[i];
          end;
        end
        else
        begin
          s := DeleteCharsFromString(Zahl, ['-', '+']);
          if Length(s) > 0 then
          begin
            b := StrToIntDef(s, 0);
            if Zahl[1] = '-' then b := -b;
            Inc(res, b);
            Inc(EnumCharRec.Count);
            SetLength(EnumCharRec.CharCount, EnumCharRec.Count);
            EnumCharRec.CharCount[EnumCharRec.Count - 1] := b;
          end;
          Zahl := '';
          if ((Text[i] in Numbers)) or ((Text[i] in Sums) and (Length(Zahl) = 0)) then
          begin
            Zahl := text[i];
          end;


        end;
      end;
    end;
  end;
  if Length(Zahl) > 0 then
  begin
    if not (Zahl[1] in Num) then
    begin
      Zahl := '';
    end
    else
    begin
      s := DeleteCharsFromString(Zahl, ['-', '+']);
      if Length(s) > 0 then
      begin
        b := StrToIntDef(s, 0);
        if Zahl[1] = '-' then b := -b;
        Inc(res, b);
        Inc(EnumCharRec.Count);
        SetLength(EnumCharRec.CharCount, EnumCharRec.Count);
        EnumCharRec.CharCount[EnumCharRec.Count - 1] := b;
      end;
      Zahl := '';
    end;
  end;
  Result := res;
end;

function StringToTCharArray(Chars: string): TCharArray;
var i: integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  if Length(Chars) <= 0 then exit;
  SetLength(Result, Length(Chars));
  for i := 0 to High(Result) do
  begin
    Result[i] := Chars[i + 1];
  end;
end;


function EnumSpecChars(Text: string; const Chars: TCharArray): Integer;
var aEnumCharRec: TEnumCharRec;
  c, i: Integer;
begin
  Result := 0;
  if EnumChars(Text, aEnumCharRec) <= 0 then exit;
  for i := low(Chars) to High(Chars) do
  begin
    c := GetCharCount(Chars[i], aEnumCharRec);
    if c > 0 then Inc(Result, c);
  end;
end;

function _EnumSpecChars(Text: string; const Chars: array of char): Integer;
var aEnumCharRec: TEnumCharRec;
  c, i: Integer;
begin
  Result := 0;
  if EnumChars(Text, aEnumCharRec) <= 0 then exit;
  for i := low(Chars) to High(Chars) do
  begin
    c := GetCharCount(Chars[i], aEnumCharRec);
    if c > 0 then Inc(Result, c);
  end;
end;

function BOOLToStrExt(b: Boolean; sTRUE, sFALSE: string): string;
begin
  if b then
    Result := sTRUE
  else
    Result := sFALSE;
end;

function BOOLToStr(b: Boolean): string;
begin
  if b then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;

function SaveStringsToStream(StringList: TStrings; Stream: TStream; OnDataWrite: TOnDataWrite = nil): Longint;
var len, i: Longint;
begin
  ASSERT(Assigned(Stream), 'Streamerror');
  ASSERT(Assigned(StringList), 'Streamerror');
  len := StringList.Count;
  Result := 0;
  Inc(Result, Stream.Write(Len, SizeOf(Len)));
  for i := 0 to StringList.Count - 1 do
  begin
    WriteString2a(Stream, StringList[i]);
    if Assigned(OnDataWrite) then
      Inc(Result, OnDataWrite(Stream, i, StringList.Objects[i]));
    Inc(Result, Length(StringList[i]) + SizeOf(Integer));
  end;
end;

function LoadStringsFromStream(StringList: TStringList; Stream: TStream; OnDataRead: TOnDataRead = nil): Longint;
var len, i: Longint;
  s: string;
  o: TObject;
begin
  ASSERT(Assigned(Stream), 'Streamerror');
  ASSERT(Assigned(StringList), 'Streamerror');
  Result := 0;
  Inc(Result, Stream.Read(Len, SizeOf(Len)));
  for i := 0 to Len - 1 do
  begin
    s := ReadString2a(Stream);
    if Assigned(OnDataRead) then
    begin
      o := nil;
      Inc(Result, OnDataRead(Stream, i, o));
      StringList.AddObject(s, o);
    end
    else
      StringList.Add(s);

    Inc(Result, Length(s) + SizeOf(Integer));
  end;
end;

function MultiReturn(Times: Integer): string;
var i: Integer;
begin
  Result := '';
  for i := 1 to Times do
    Result := Result + return;
end;

end.

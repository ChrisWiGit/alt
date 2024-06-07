{
@abstract(dtTools.pas beinhaltet allgemeine Funktionen f�r den Umgang mit Delphi)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtTools;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

{IsDelphiRunning gibt True zur�ck , wenn Delphi aktiv ist, unabh�nging von der Version}
function IsDelphiRunning: Boolean;

{IsDelphi4Running gibt True zur�ck , wenn Delphi 4 aktiv ist.}
function IsDelphi4Running: Boolean;

{EnCode codiert nach dem ASCII-Zeichensatz einen String und gibt den
codierten String zur�ck. Dabei wird der String s einfach um m
Zeichen verschoben.
Diese Funktion ist nicht f�r den professionellen Einsatz geeignet und kann leicht
durch Brute-Force-Attacken gecrackt werden.
Siehe auch @link(DeCode)}
function EnCode(s: string; m: Integer): string;
{DeCode decodiert nach dem ASCII-Zeichensatz einen String und gibt den
codierten String zur�ck. Dabei wird der String s einfach um -m
Zeichen verschoben.
Diese Funktion ist nicht f�r den professionellen Einsatz geeignet und kann leicht
durch Brute-Force-Attacken gecrackt werden.
Siehe auch @link(EnCode)}
function DeCode(s: string; m: Integer): string;

{DeAlpha decodiert wie @link(Decode) den String s
Es werden allerdings nur Buchstaben (ohne Umlaute) kodiert.}
function DeAlpha(s: string; m: Integer): string;
{EnAlpha codiert wie @link(Encode) den String s
Es werden allerdings nur Buchstaben (ohne Umlaute) kodiert.}
function EnAlpha(s: string; m: Integer): string;






implementation
uses dtWindows,dtStringsRes;

function IsDelphi4Running: Boolean;
var h1, h2, h3, h4: HWND;
const A1: array[0..12] of char = 'TApplication'#0;
  A2: array[0..15] of char = 'TAlignPalette'#0;
  A3: array[0..18] of char = 'TPropertyInspector'#0;
  A4: array[0..11] of char = 'TAppBuilder'#0;
  T1: array[0..8] of char = 'Delphi 4'#0;
begin
  H1 := FindWindow(A1, T1);
  H2 := FindWindow(A2, nil);
  H3 := FindWindow(A3, nil);
  H4 := FindWindow(A4, nil);
  Result := (H1 <> 0) and (H2 <> 0) and (H3 <> 0) and (H4 <> 0);
end;

function IsDelphiRunning: Boolean;
var h1, h2, h3, h4: HWND;
const A1: array[0..12] of char = 'TApplication'#0;
  A2: array[0..15] of char = 'TAlignPalette'#0;
  A3: array[0..18] of char = 'TPropertyInspector'#0;
  A4: array[0..11] of char = 'TAppBuilder'#0;
  T1: array[0..6] of char = 'Delphi'#0;
begin
  H1 := FindWindow(A1, T1);
  H2 := FindWindow(A2, nil);
  H3 := FindWindow(A3, nil);
  H4 := FindWindow(A4, nil);
  Result := (H1 <> 0) and (H2 <> 0) and (H3 <> 0) and (H4 <> 0);
end;

function EnCode(s: string; m: Integer): string;
var str: string;
  i: Integer;
begin
  Str := '';
  for i := 1 to Length(s) do
    Insert(char(ord(s[i]) + m), str, Length(Str) + 1);

  Result := Str;
end;

function DeCode(s: string; m: Integer): string;
var str: string; i: Integer;

begin
  Str := '';
  for i := 1 to Length(s) do
    Insert(char(ord(s[i]) - m), str, Length(Str) + 1);
  Result := Str;
end;


function DeAlpha(s: string; m: Integer): string;
var str2, str: string;
  i: Integer;
  str3: Char;

begin
  Str := '';
  Str2 := UpperCase(s);
  for i := 1 to Length(str2) do
  begin
    str3 := Uppercase(str2[i])[1];
    if (str3 in ['A'..'Z']) then
    begin
      if m > 0 then
      begin
        if Ord(str3) + m > 90 then
          Str3 := Char((m - (90 - Ord(str3)) + 64))
        else
          str3 := Char(Ord(str3) + m);
      end
      else
      begin
        if Ord(str3) + m < 65 then
          Str3 := Char(90 + (m + (Ord(str3) - 64)))
        else
          str3 := Char(Ord(str3) + m);
      end;
    end;
    Insert(str3, str, Length(Str) + 1);
  end;
  Result := Str;
end;

function EnAlpha(s: string; m: Integer): string;
var str2, str: string;
  i: Integer;
  str3: Char;
{
   TUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ
   ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFG
}

begin
  Str := '';
  Str2 := UpperCase(s);
  for i := 1 to Length(str2) do
  begin
    str3 := Uppercase(str2[i])[1];
    if (str3 in ['A'..'Z']) then
    begin
      if Ord(str3) + m > 90 then
        Str3 := Char((m - (90 - Ord(str3)) + 64))
      else
        str3 := Char(Ord(str3) + m);
    end;
    Insert(str3, str, Length(Str) + 1);
  end;
  Result := Str;
end;


end.

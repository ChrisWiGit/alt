{
@abstract(dtTime.pas beinhaltet  Funktionen f�r den Umgang mit Zeit und Datum)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtTime;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Registry;

type  {TGMT ist ein Green-Wich-Mean-Time-Typ, der angibt welche Zeitzone verwendet wird.}
      TGMT = -12.. + 12;
      {TBeats ist der Typ, der Beatsschl�ge aufnimmt.}
      TBeats = Double;

const
      {BeatsPerSec berechnet die Anzahl der Beats die pro Sekunde ablaufen.}
      BeatsPerSec = (24 * 60 * 60) / 1000;

type
  {TZI nimmt TimeZoneInformationen auf.
  Bias -
  Display -
  Dlt - DaylightName
  Std - StandardName
  Index - Index ,verwendet von GetActualTimeZone
                ,um die Zeitzone in der Stringlist (wie sie von GetWindowsTimeZoneStrings zur�ckgeliefert wird)
                anzugeben
                      }
  TZI = class {TimeZoneInformation}
  public
    Bias: Integer;
    Display,
      Dlt, {DaylightName}
      Std: string; {StandardName}
    Index: Integer; {Index ,verwendet von GetActualTimeZone
                   ,um die Zeitzone in der Stringlist (wie sie von GetWindowsTimeZoneStrings zur�ckgeliefert wird)
                     anzugeben
                       }
  end;
  {TTZIResult gibt die R�ckgabewerte von @link(GetActualTimeZone) an
  (zi_ok - R�ckgabewert ist in Ordnung
   zi_unknow - R�ckgabewert ist nicht definiert
   zi_unexact - R�ckgabewert ist eine Auswahl aus mehreren m�glichen Zeitzonen}
  TTZIResult = (zi_ok, {R�ckgabewert ist in Ordnung}
    zi_unknow, {R�ckgabewert ist nicht definiert}
    zi_unexact); {R�ckgabewert ist eine Auswahl aus mehreren m�glichen Zeitzonen}

{ConvertSecToTime errechnet aus der Anzahl von Sekunden Secs die Anzahl von Stunden , Minuten und Sekunden
Man sollte Hour nicht in EncodeTime oder TimeToStr verwenden ,da Hour > 23 sein kann
Minute , Second sind dazu im Gegensatz zwischen 0-59.
Updated 289a}
procedure ConvertSecToTime(Secs: Longint; var Hour, Minute, Second: Word);

{ConvertHSecToTime errechnet aus der Anzahl von Milisekunden HSecs die Anzahl von Stunden , Minuten und Sekunden
Man sollte Hour nicht in EncodeTime oder TimeToStr verwenden ,da Hour > 23 sein kann
Minute , Second sind dazu im Gegensatz zwischen 0-59.
Updated 289a}
procedure ConvertHSecToTime(HSecs: Longint; var Hour, Minute, Second, MSec: Word);
{ConvertSecToTTime konvertiert eine Zahl von Sekunden in einen TTime-Wert}
function ConvertSecToTTime(Secs: Longint): TTime;
{ConvertHSecToTTime konvertiert eine Zahl von MiliSekunden in einen TTime-Wert}
function ConvertHSecToTTime(Secs: Longint): TTime;
{ConvertTTimeToSecs konvertiert eine einen TTime-Wert in eine Zahl von Sekunden}
function ConvertTTimeToSecs(aTime: TTime): Longint; //Ergebnis in Sekunden
{ConvertTTimeToHSecs konvertiert eine einen TTime-Wert in eine Zahl von MiliSekunden}
function ConvertTTimeToHSecs(aTime: TTime): Longint; //Ergebnis in MiliSekunden


{lngTimeToBeats ermittelt aus der Greenwich MeanTime (GMT) und der Uhrzeit Time (h,m,s) die Internetzeit @@ (Beat)}
function lngTimeToBeats(GMT: TGMT; h, m, s: Word): TBeats;
{TimeToBeats errechnet aus der Greenwich MeanTime (GMT) und der Uhrzeit Time die Internetzeit @@ (Beat)}
function TimeToBeats(GMT: TGMT; Time: TTime): TBeats;

{BeatsToTime ermittelt aus der Greenwich MeanTime (GMT) und der Internetzeit @@ (Beat) die gew�hnliche Uhrzeit}
function BeatsToTime(GMT: TGMT; Beats: TBeats): TTime;
{BeatsTolngTime wie @link(BeatsToTime) , liefert jedoch zus�tzlich noch Stunden ,Minuten und Sekunden zur�ck}
function BeatsTolngTime(GMT: TGMT; Beats: TBeats; var h, m, s: Word): TTime;

{CorrectHour korrigiert Zeitstunden : z.B. 24uhr -> 0uhr, 25 -> 1 , 48 -> 0, , -1 -> 23 , -24 -> 0 }
function CorrectHour(h: Integer): Word;



{GetWindowsTimeZoneStrings ermittelt alle Zeitzonen , die in dieser Windows verwendet werden k�nnen
ShowHalfTime gibt an , ob (TRUE) Zeiten die zwischen Zeitzonen liegen , mit in die Liste aufgenommen werden sollen
}
function GetWindowsTimeZoneStrings(ShowHalfTime: Boolean = TRUE): TStringList;
{GetActualTimeZone ermittelt die aktuelle Zeitzone
ProcResult gibt �ber Fehler aufschlu�
ShowHalfTime , ist wie bei GetWindowsTimeZoneStrings zust�ndig
               Sollte die aktuelle Zeitzone eine Zwischenzone (z.B. : 3:30) sein und ShowHaltTime = FALSE
               dann wird ein Fehler zi_unknow in ProcResult geliefert
Der R�ckgabewert wird !vollst�ndig! gef�llt , d.h. auch .Index wird mit dem StringIndex definiert.}
function GetActualTimeZone(var ProcResult: TTZIResult; ShowHalfTime: Boolean = TRUE): TZI;


implementation
uses dtSystem,dtStrings,dtStringsRes;

function ConvertTTimeToSecs(aTime: TTime): Longint;
var Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(aTime, Hour, Min, Sec, MSec);
  Result := (Hour * 60 * 60) + (Min * 60) + Sec;
end;

function ConvertTTimeToHSecs(aTime: TTime): Longint;
var Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(aTime, Hour, Min, Sec, MSec);
  Result := (Hour * 60 * 60 * 100) + (Min * 60 * 100) + (Sec * 1000) + MSec;
end;

function ConvertHSecToTTime(Secs: Longint): TTime;
var Hour, Minute, Second, MSec: Word;
begin
  ConvertHSecToTime(Secs, Hour, Minute, Second, MSec);
  if MSec = 0 then
    Result := 0
  else
    Result := EnCodeTime(Hour, Minute, Second, MSec);
end;

function ConvertSecToTTime(Secs: Longint): TTime;
var Hour, Minute, Second: Word;
    Year, Month, Day: Word;
    Date : TDateTime;
begin
  ConvertSecToTime(Secs, Hour, Minute, Second);
  if (Hour > 23) or (Hour < 0) then Hour := 0;
  if (Minute > 59) or (Minute < 0) then Minute := 0;
  if (Second > 59) or (Second < 0) then Second := 0;

  try
   Result := EnCodeTime(Hour, Minute, Second, 0);
  except
  end;
end;

procedure ConvertHSecToTime(HSecs: Longint; var Hour, Minute, Second, MSec: Word);
var Rest: longint;
begin
  Rest := HSecs;
  Hour := HSecs div (60 * 60 * 100);
  Rest := Rest mod (60 * 60 * 100);
  Minute := Rest div (60 * 100);
  Rest := Rest mod (60 * 100);
  Second := Rest div (1000);
  MSec := Rest mod 1000;
end;

procedure ConvertSecToTime(Secs: Longint; var Hour, Minute, Second: Word);
var dSec: longint;
begin
  Hour := Secs div (60 * 60);
  dSec := (Secs mod (60 * 60));
  Minute := dSec div 60;
  Second := (dSec mod 60);
end;


function BeatsTolngTime(GMT: TGMT; Beats: TBeats; var h, m, s: Word): TTime;
var n: Word;
begin
  Result := BeatsToTime(GMT, Beats);
  DeCodeTime(Result, h, m, s, n);
end;

function BeatsToTime(GMT: TGMT; Beats: TBeats): TTime;
var
  bb: TBeats;
  hh, mm, ss: Word;
begin
  bb := (Beats * BeatsPerSec);
  ConvertSecToTime(Round(bb), hh, mm, ss);

  Dec(gmt);

  if hh + gmt > 23 then
    hh := gmt
  else
    if (gmt < 0) and (hh + gmt < 0) then
      hh := 24 + gmt
    else
      if (gmt < 0) or (hh < gmt) then
        hh := hh + gmt
      else
        hh := hh - gmt;

  Result := EnCodeTime(hh, mm, ss, 00);
end;

function lngTimeToBeats(GMT: TGMT; h, m, s: Word): TBeats;
var Time: TTime;
  n: Word;
begin
  n := 0;
  Time := EnCodeTime(h, m, s, n);
  Result := TimeToBeats(GMT, Time);
end;

function CorrectHour(h: Integer): Word;
var l, l2: Integer;
begin
  if h > 23 then
  begin
    Result := h mod 24;
  end
  else
    if h < 0 then
    begin
      Result := (24 + (h)) mod 24;
    end
    else
      Result := h;
end;

function TimeToBeats(GMT: TGMT; Time: TTime): TBeats;
var
  nul, hh, mm, ss: Word;
  hh3, hh2: Integer;

  bb, r: Double;
  s: string;

  function posi(int: Integer): Integer;
  begin
    if int < 0 then
      result := -int
    else
      result := int;
  end;
var p: Integer;
begin
  DecodeTime(Time, hh, mm, ss, nul);

  if (hh = -1) or (mm = -1) or (ss = -1) then exit;
  if (hh > 23) or (mm > 59) or (ss > 59) then
  begin
    raise Exception.Create('Ung�ltige Uhrzeit');
    exit;
  end;

  //Dec(gmt);

 { if hh+gmt > 23 then
   hh := gmt
  else}
  { if (gmt < 0) and (hh+gmt < 0) then
     hh := 23+hh+gmt
  else}

  hh3 := hh;
{  hh2 := hh;
  p := gmt;
  hh3 := hh3 - p;
  if hh3 < 0 then
   hh3 := 25 - (posi(gmt) - hh2);

  if hh3 > 23 then
   hh3 := (gmt - hh2);}

{  Dec(gmt);
  if hh3+gmt-1 > 23 then
   hh3 := gmt-1-(24 - hh3)
  else
  if hh3+gmt-1 < 0 then
   hh3 := 24+(gmt-1+hh3)
  else
   hh3 := hh3 + (gmt-1);}

 { if hh3+gmt-1 > 23 then
   hh3 := hh3-(gmt-1)}
  if (hh3 - gmt + 1 > 23) then
    hh3 := gmt + 1 + (24 - hh3)
  else
    if hh3 - (gmt - 1) < 0 then
      hh3 := 24 - (gmt - 1 - hh3)
    else
      hh3 := hh3 - gmt + 1;


{  if hh+gmt < 0 then
    hh := 24 + (hh+gmt);}

  hh3 := CorrectHour(hh3);
  r := ((hh3) * 60 * 60) + (mm * 60) + (ss);

  bb := r / BeatsPerSec;

  Result := bb;
end;


function DoCompare(List: TStringList; Index1, Index2: Integer): Integer;
{--> GetWindowsTimeZoneStrings}
begin
  if TZI(List.Objects[Index1]).Bias < TZI(List.Objects[Index2]).Bias then
    Result := -1
  else
    if TZI(List.Objects[Index1]).Bias > TZI(List.Objects[Index2]).Bias then
      Result := 1
    else
    begin
      Result := CompareStr(List[Index1], List[Index2]);
    end;
end;

function GetWindowsTimeZoneStrings(ShowHalfTime: Boolean = TRUE): TStringList;
const WinNTTZ = '\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\';
  WinTZ = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Time Zones\';
var r: TRegistry;

  procedure SortList(List: TStringList);
  begin
    List.CustomSort(DoCompare);
  end;

  procedure ReadFromReg(List: TStringList; Key: string);
  var Strings: TStringList;
    i: Integer;
    function NewObject(Bias: Integer; Display, Dlt, Std: string): TZI;
    begin
      Result := TZI.Create;
      Result.Bias := Bias;
      Result.Display := Display;
      Result.Dlt := Dlt;
      Result.Std := Std;
    end;
  var Bias: Integer; Display, Dlt, Std: string;
    function ExtractBiasFromDisplay(D: string): Integer;
    var p, p2, p3,
      mult: Integer;
      t, h, m: string;
    begin
      p := FindInString(D, ['+', '-']);
      if p = 0 then
      begin
        Result := 0;
        exit;
      end
      else
      begin
        p2 := pos(')', D);
        t := copy(D, p, p2 - p);
        if t[1] = '-' then mult := -1 else mult := 1;
        p3 := pos(':', D);
        h := copy(D, p + 1, p3 - (p + 1));
        m := copy(D, p3 + 1, p2 - (p3 + 1));
        Result := ((StrToInt(h) * 60) + StrToInt(m)) * mult;
      end;
    end;

  begin
    Strings := TStringList.Create;
    R.GetKeyNames(Strings);
    R.CloseKey;
    for i := 0 to Strings.Count - 1 do
    begin
      if R.OpenKey(Key + Strings[i], FALSE) then
      begin
        Display := r.ReadString('Display');
        Dlt := r.ReadString('Dlt');
        Std := r.ReadString('Std');
        Bias := ExtractBiasFromDisplay(Display);
        if (not ShowHalfTime) and ((Bias mod 60) = 0) then
          List.AddObject(Display, NewObject(Bias, Display, Dlt, Std));
        r.CloseKey;
      end;
    end;
    SortList(List);
  end;

begin
  Result := TStringList.Create;
  r := TRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;

  if r.OpenKey(WinNTTZ, FALSE) then
  begin
    ReadFromReg(Result, WinNTTZ);
  end
  else
    if r.OpenKey(WinTZ, FALSE) then
    begin
      ReadFromReg(Result, WinTZ);
    end
    else
      raise Exception.Create('TZ Error');
  r.Free;
end;

function GetActualTimeZone(var ProcResult: TTZIResult; ShowHalfTime: Boolean = TRUE): TZI;
var p: _TIME_ZONE_INFORMATION;
  d: TStringList;
  i, count, lastID: Integer;
  ZI, lastZI: TZI;
begin
  FillChar(Result, SizeOf(Result), 0);

  GetTimeZoneInformation(p);
  d := GetWindowsTimeZoneStrings(ShowHalfTime);

  count := 0;
  lastID := 0;
  for i := 0 to D.Count - 1 do
  begin
    ZI := TZI(d.Objects[i]);
    if (CompareText(ZI.Dlt, string(p.DaylightName)) = 0) and
      (CompareText(ZI.Std, string(p.StandardName)) = 0) then
    begin
      Inc(Count);
      LastZI := ZI;
      LastZI.Index := i;
    end;
  end;
  if count = 1 then
  begin
    Result := LastZI;
    ProcResult := zi_ok;
  end
  else
    if count > 1 then
    begin
      Result := LastZI;
      ProcResult := zi_unexact;
    end
    else
      ProcResult := zi_unknow;
end;

end.

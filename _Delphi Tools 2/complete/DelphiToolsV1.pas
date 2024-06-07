unit DelphiToolsV1;
(*

    DelphiTools Version 1.308gpl

    Copyright (C) 2000/2001 author - removed/removed

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public
    License along with this library; if not, write to the Free
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA



   ~305 Funktionen/Prozeduren
   last change :          October 2001



   Wer eine (Windows-)Hilfe schreiben will : Bitte Kontakt aufnehmen.
   Wer weiter Funktionen hinzuf�gen m�chte :
   Bitte Kontakt aufnehmen : Nur Source wird angenommen (auch wenn er noch so klein ist)
                             Es mu� unter den gleichen angegebenen Bedingungen (GPL) stehen.



   Updates unter http://www.vclcomponents.com/

   ~~Help wanted / Hilfe gesucht~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
   | I'm seeking people who can create html help pages for some of the DelphiTools procedures or/and functions.            |
   | It would be enough , if you could create a couple of help pages in englisch or german.                                |
   | Of course , your name (+e-mail) will be shown on these pages , too.                                                   |
   | Many DelphiTools users will thank you for your effort.                                                                |
   | But before you start working , make a contact with author (see e-mail above) ,                                     |
   | because it's necessary to create an equal-looking manual.                                                             |
   | Thanks.                                                                                                               |
   |                                                                                                                       |
   | Ich suche Leute , die Hilfeseiten auf html-Basis f�r die einzelnen DelphiTools-Prozeduren oder/und Funktionen machen. |
   | Es reicht auch , wenn Du nur ein paar St�ck machst , in englisch oder deutsch.                                        |
   | Nat�rlich wird dein Name (+E-Mail) dann auf der HilfeSeite stehen.                                                    |
   | Dein Aufwand wird dadurch bezahlt, dass viele DelphiTools-User Dir danken.                                            |
   | Bevor Du Dich aber an die Arbeit machst , setze Dich mit author (E-Mail siehe oben)                                |
   | in Verbindung , um einen einheitlichen Aufbau der Hilfeseite zu erm�glichen.                                          |
   | Vielen Dank.                                                                                                          |
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|



  Anwendung :
    Kopiere diese Dateien in ein beliebieges Verzeichnis.
    Damit du darauf zugreifen kannst mu�t du das Verzeichnis
    in deine Projektverzeichnisliste eintragen. Dazu �ffne den
    Projektoptionendialog �ber Men�:Projekt->Optionen.
    W�hle dann die Registrierkarte Verzeichnisse/Bedingungen und
    setze den DelphiTools-Pfad in Suchpfad.
    Mehrere Pfade werden durch Semikolon (;) getrennt.

   In ihren Units bindest du DelphiTools wie folgt ein.

      uses ...,Delphitools;

   Hinweis zu den Hilfetexten :
     Es wird zuerst der Hilfetext , und dann die Funktion/Prozedur angegeben:
     Beispiel :

         //Wie EnCode nur das Gegenteil                  <<-- Hilfe f�r Decode
         function DeCode(s:String;m:Integer) : String;   <<-- Hier die Funktion DeCode

         //Codiert wie Encode den String s
         //Aber hier werden nur Buchstaben (ohne Umlaute) kodiert
         function DeAlpha(s:String;m:Integer): String;

        //L�scht in einem String alle Leerzeichen #255
        function DelSpaces(Str:String) : String;

     Alle Funktionen mit den drei Sternen ( *** ) sind seit der Version die dahinter steht veraendert worden!


   Externe Quellen :

    0001 : PC Magazin 10/2000
    0002 : paracore - paracore@gmx.net
    0003 : Daywalker - daywalker_2000@gmx.net | Codehunter - codehunter@gmx.net

*)

interface
uses Windows, ShellApi, ShlObj,SysUtils, Dialogs, Classes, Graphics, forms, controls, imgList,
  extCtrls, comctrls, stdctrls
  ;


























{TSystemTime = record
       wYear: Word;
       wMonth: Word;
       wDayOfWeek: Word;
       wDay: Word;
       wHour: Word;
       wMinute: Word;
       wSecond: Word;
       wMilliseconds: Word;
   end;

TByHandleFileInformation = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    dwVolumeSerialNumber: DWORD;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    nNumberOfLinks: DWORD;
    nFileIndexHigh: DWORD;
    nFileIndexLow: DWORD;
  end;
}










{TSHFileOpStructA = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PAnsiChar;
    pTo: PAnsiChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PAnsiChar;
  end;}
//type










//Externe Quelle : 0003
//V1.304







//Wandelt die alten CD-Key von Win95 in eine Maske von Maskedit um
function TransCDKey2MaskUp(id: string): string;
//wie TransCDKey2MaskUp , nur dass alle Eingabe (sofern m�glich) in Gro�buchstaben umgewandelt werden
function TransCDKey2Mask(id: string): string;
















//Stream Data Handling




























































































//no operation
function PointToInt(p: TPoint): Integer;









































(*
!
type TCode = record
      Code, HTML : String;
     end;
     Tcodes = array[1..2] of TCode;

     TStringPattern = record
       InputPattern,OutputPattern : String;
     end;

// InputPattern : [url="%1"]%2[/url]
// OutputPattern : <a href="%1">%2</a>


function TransformString(Input: String; out OutPut : String; Pattern : TStringPattern): Boolean;

const BoardCodes : TCodes = (
         (code:'b';html:'B'),
         (code:'url';html:'<')

         );


//function BoardCodesToHTML(
        *)





implementation
{$HINTS OFF}
{$WARNINGS OFF}
uses buttons
  , DelphiToolsForm1 //Passwortdialog
  , DelphiToolsForm2
  , SplashForm
 //DefPasswortdialog

  , Messages, registry, FileCtrl, math,
  TypInfo, WinSock;

{function TransformString(Input: String; out OutPut : String; Pattern : TStringPattern): Boolean;
begin
end;}


























































(*

if (Image.Bitmap.Canvas.Pixels[x,y] <> MaskColor) and
    (Image.Bitmap.Canvas.Pixels[x,y] <> -1)
    then
     begin
        p := GetRGBColor(Image.Bitmap.Canvas.Pixels[x,y]);
        dRed   := 255-p.rgbRed;
        dGreen := 255-p.rgbGreen;
        dBlue  := 255-p.rgbBlue;

        p2 := GetRGBColor(NewColor);
        if p2.rgbRed-dRed > 0 then
         p2.rgbRed   := p2.rgbRed-dRed
        else
         p2.rgbRed   := 0;
        if p2.rgbGreen-dGreen > 0 then
         p2.rgbGreen := p2.rgbGreen-dGreen
        else
         p2.rgbGreen := 0;

        if p2.rgbBlue-dBlue > 0 then
         p2.rgbBlue := p2.rgbBlue-dBlue
        else
         p2.rgbBlue := 0;

        Img.Canvas.Pixels[x,y] := RGBToColor(p2);
     end
     else
      Img.Canvas.Pixels[x,y] := Image.Bitmap.Canvas.Pixels[x,y];
   end;


var x,y,
    dRed,dGreen,dBlue,w,h :Longint;
    p,p2 : TRGBQuad;
    Img : TPicture;
begin
  Img := TPicture.Create;
  Img.Assign(Image);

  h := Image.Height;
  w := Image.Width;

  for y := 0 to h-1 do
  for x := 0 to w-1 do
  begin

   if (Image.Bitmap.Canvas.Pixels[x,y] <> MaskColor) and
    (Image.Bitmap.Canvas.Pixels[x,y] <> -1)
    then
     begin
        p := GetRGBColor(Image.Bitmap.Canvas.Pixels[x,y]);
        dRed   := 255-p.rgbRed;
        dGreen := 255-p.rgbGreen;
        dBlue  := 255-p.rgbBlue;

        p2 := GetRGBColor(NewColor);
        if p2.rgbRed-dRed > 0 then
         p2.rgbRed   := p2.rgbRed-dRed
        else
         p2.rgbRed   := 0;
        if p2.rgbGreen-dGreen > 0 then
         p2.rgbGreen := p2.rgbGreen-dGreen
        else
         p2.rgbGreen := 0;

        if p2.rgbBlue-dBlue > 0 then
         p2.rgbBlue := p2.rgbBlue-dBlue
        else
         p2.rgbBlue := 0;

        Img.Bitmap.Canvas.Pixels[x,y] := RGBToColor(p2);
     end
     else
      Img.Bitmap.Canvas.Pixels[x,y] := Image.Bitmap.Canvas.Pixels[x,y];
   end;

   Result := Img;
end;
*)





function PointToInt(p: TPoint): Integer;
begin
  nop;
end;




























































































































































(*{TRegisterFile = record
       FileExtension : String; {Dateierweiterung , die registriert werden soll z.B. : txt}

       Icon : String;  {f�r die Dateierweiterung ein Symbol (DefaultIcon)
                         z.B. : C:\Windows\Icon.ico
                                C:\Windows\MoreIcons.dll,_4 {Unterstrich (_) ist ein Leerzeichen!
                                %1 - Die Datei mit der Erweiterung wird als Symbol verwendet
                                }
                       }
       Content : String {ContentTyp : InhaltsTyp}
       Description : String {Typ-Beschreibung}

       InstallationsCommand : String; {Installationsbefehl : zb. %SystemRoot%\System32\rundll32.exe setupapi,InstallHinfSection DefaultInstall 132 %1}
       Command : String; {Ausf�hrungsdatei : z.B. C:\Windows\notepad.exe %1}
       PrintCommand : String; {Druckkommando : z.B. %SystemRoot%\System32\NOTEPAD.EXE /p %1}

     end;
 }*)
//Registriert eine Dateierweiterung
//  Sollte die Dateierweiterung schon existieren wird sie �berschrieben














































































{type TKEY = (TKEY_CLASSES_ROOT,TKEY_CURRENT_USER,TKEY_LOCAL_MACHINE,
             TKEY_USERS,TKEY_CURRENT_CONFIG,TKEY_DYN_DATA);
             }






























function TransCDKey2MaskUp(id: string): string;
var m: string;
  i: Integer;
begin
  m := '';
  //9999-LLL-9999999-99999;1;_
  for i := 1 to Length(id) do
  begin
    case AnsiUpperCase(id[i])[1] of
      '0'..'9': Insert('9', m, Length(m) + 1);
      'A'..'Z', '�', '�', '�': Insert('>L', m, Length(m) + 1);
//      '-' : Insert(id[i],m,Length(m)+1);
    else
      Insert('\' + id[i], m, Length(m) + 1);
    end;
  end;
  Insert(';1;_', m, Length(m) + 1);
  Result := m;
end;

function TransCDKey2Mask(id: string): string;
var m: string;
  i: Integer;
begin
  m := '';
  //9999-LLL-9999999-99999;1;_
  for i := 1 to Length(id) do
  begin
    case AnsiUpperCase(id[i])[1] of
      '0'..'9': Insert('9', m, Length(m) + 1);
      'A'..'Z', '�', '�', '�': Insert('L', m, Length(m) + 1);
//      '-' : Insert(id[i],m,Length(m)+1);
    else
      Insert('\' + id[i], m, Length(m) + 1);
    end;
  end;
  Insert(';1;_', m, Length(m) + 1);
  Result := m;
end;







{type TDialogData = Record
       Owner : TComponent;
       PassWord : String;
       MinLength,MaxLength : Integer;
       PassWordChar : Char;
       CaseSensitive : Boolean;
       Label1,Label2,Label3 : String;
       Ok,Cancel : String;
     end;}










































































































































































































end.


{
@abstract(dtMultimedia.pas beinhaltet Funktionen f�r den Umgang mit Multimediadaten)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtMultimedia;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ImgList;


type
{TExtCustomImageList wird intern benutzt, um die Prozedur GetImages verwenden zu k�nnen.
Folgende Funktionen nutzen diese Klasse:
  @link(SaveImageListFileToStream)
  @link(LoadImageListFileFromStream)
  @link(LoadImageListFileFromStreamExt)}
  TExtCustomImageList = class(TCustomImageList)
  public
    {GetImages ist in TCustomImageList nicht �ffentlich und wird daher neueingef�hrt.
    Sie ist f�r den Programmierer nicht wichtig.}
    procedure GetImages(Index: Integer; Image, Mask: TBitmap); reintroduce;
  end;


type
{F�r @link(SaveImageListFileToStream) und @link(LoadImageListFileToStream) wird TBitmapRec benutzt.
UseBitmap gibt an, ob ein Bitmap verwendet werden soll.
Bitmap gibt das Bild an.
UseMask gibt an, ob eine Maske (schwarz-wei� Bild) verwendet werden soll.
Mask beinhaltet das Maskenbild}
  TBitmapRec = record
    UseBitmap: Boolean;
    Bitmap: TBitmap;
    UseMask: Boolean;
    Mask: TBitmap;
  end;

{TDSoundState wird von @link(LockSound) verwendet, um den aktuellen Status setzen zu k�nnen.
DSS_Locked gibt an, dass der Lautsprecher verwendet wird.
DSS_UnLocked gibt an, dass der Lautsprecher nicht verwendet wird.
DSS_RET gibt nur den aktuellen Status von SoundLock zur�ck
}
TDSoundState = (DSS_LOCKED, DSS_UNLOCKED, DSS_RET);

const
  {ImageFileSignature ist eine ImageListDateierkennungssignatur als String}
  ImageFileSignature = 'ImageListFile'#2#5#3#0;
  {ImageFileSignatureLen ist die ImageListDateierkennungssignaturl�nge von ImageFileSignature}
  ImageFileSignatureLen = 16;
  {ImageFileVersion ist die aktuell in DelphiTools verwendete DateiVersion f�r die Speicherung von Bilderlisten.}
  ImageFileVersion: Integer = 1000002;


{DSound gibt �ber PC-Lautsprecher einen Hz-Hertz Ton aus.
 Die Prozedur ist nicht implementiert!}
procedure DSound(Hz: Word);
{DNoSound stoppt den mit DSound erzeugten HerzTon
Die Prozedur ist nicht implementiert!}
procedure DNoSound;

{IsSound gibt TRUE zur�ck, wen derzeit ein Ton mit DSound ausgegeben wird.
Die Prozedur ist nicht implementiert!
}
function IsSound: Boolean;

{LockSound verhindert ,wenn State = DSS_LOCKED ist , da� DSound
einen Ton spielt. DSS_UNLOCKED kehrt den Befehl um.
DSS_RET gibt nur den aktuellen Status von SoundLock zur�ck
Die Prozedur ist nicht implementiert!}
function LockSound(State: TDSoundState): Boolean;



{CreateImageListFile speichert eine ImageList in einer vollst�ndigen ImageListDatei
Die Datei enth�lt eine f�r sie typische ImageListDateierkennungssignatur.
Siehe @link(ImageFileSignature), @link(ImageFileSignatureLen), @link(ImageFileVersion) und @link(TExtCustomImageList)}
function CreateImageListFile(const FileName: string; ImageList: TExtCustomImageList): Integer;
{LoadImageListFile l�dt eine zuvor mit @link(CreateImageListFile) gespeicherte Bilderliste zur�ck in
 eine TimageList-Klasse, die zuvor erstellt werden muss!
 Der R�ckgabewert ist immer Null.
}
function LoadImageListFile(const FileName: string; var ImageList: TExtCustomImageList): Integer;

{LoadImageListFileExt l�dt eine zuvor mit @link(CreateImageListFile) gespeicherte Bilderliste zur�ck in
 eine TimageList-Klasse, die zuvor erstellt werden muss!
 DoNotLoad ist ein Array Of Integer, der angibt welche IndexNummer nicht geladen werden sollen.
 Der R�ckgabewert ist immer Null.
}
function LoadImageListFileExt(const FileName: string; var ImageList: TExtCustomImageList; const DoNotLoad: array of const): Integer;

{SaveImageListFileToStream speichert eine Bilderliste in einem Stream ohne dabei eine Dateisignatur (@Link(CreateImageListFile)) zu verwende.
 Der R�ckgabewert ist immer Null.
}
function SaveImageListFileToStream(Stream: TStream; ImageList: TExtCustomImageList): Integer;

{LoadImageListFileFromStream l�dt eine zuvor mit @link(SaveImageListFileToStream) gespeicherte Bilderliste zur�ck in
 eine TimageList-Klasse, die zuvor erstellt werden muss!
 Der R�ckgabewert ist immer Null.
}
function LoadImageListFileFromStream(Stream: TStream; var ImageList: TExtCustomImageList): Integer;

{LoadImageListFileFromStream l�dt eine zuvor mit @link(SaveImageListFileToStream) gespeicherte Bilderliste zur�ck in
 eine TimageList-Klasse, die zuvor erstellt werden muss!
 DoNotLoad ist ein Array Of Integer, der angibt welche IndexNummer nicht geladen werden sollen.
 Der R�ckgabewert ist immer Null.
}
function LoadImageListFileFromStreamExt(Stream: TStream; var ImageList: TExtCustomImageList; const DoNotLoad: array of const): Integer;


{Ermittelt aus einem TColorwert die einzelnen RGB-Farben.
 Siehe auch @Link(RGBToColor)}
function GetRGBColor(Color: TColor): TRGBQuad;
{Ermittelt aus einem RGBQuad einen TColor-wert
 Siehe auch @Link(GetRGBColor)}
function RGBToColor(Color: TRGBQuad): TColor;



{ConvertImageToNewColor �ndert die Farbei eines Bitmaps und gibt das Ergebnis als ein neues Bitmap zur�ck
Image enth�lt das Quellbitmap , das konvertiert werden soll
Maskcolor ist die Farbe , die unangetastet bleiben soll
NewColor ist die Farbe , die alle anderen Farben au�er Maskcolor annehmen
Wichtig : Das Ergebnis mu� wieder gel�scht werden , wenn es nicht mehr gebraucht wird.
Diese Funktion l�sst folgendes Problem :

Ich will ein Bitmap , da� nur scharz, wei� und grau�hnliche Farben besitzt ,
also eine Maskenbitmap , zur Laufzeit eine andere Farbe zuweisen.
So sollen alle wei�e Pixel , z.B. gr�n werden.
Nun gibt es am Rand (=von schwarz zu zu wei� im Maskenbitmap) das Problem ,
da� die Pixel ja nicht mehr ganz wei� sind = weiche Abstufung.
Sie sollen aber nat�rlich auch gr�n werden , nur dementsprechend etwas dunkler ,
so da� eine WEICHE Abstufung von gr�n zu schwarz entsteht.
Das daraus entstehende Bild soll nun wie das Maskenbitmap aussehen , nur in anderer Farbe.
Dabei sollen alle Abstufungen ber�cksichtig werden.
}

function ConvertImageToNewColor(Image: TBitmap; MaskColor, NewColor: TColor): TBitmap; overload;

{ConvertImageToNewColor �ndert die Farbei eines Bitmaps und gibt das Ergebnis als ein neues Bitmap zur�ck
Image enth�lt das Quellbitmap , das konvertiert werden soll
Maskcolor ist die Farbe , die unangetastet bleiben soll
NewColor ist die Farbe , die alle anderen Farben au�er Maskcolor annehmen
Wichtig : Das Ergebnis mu� wieder gel�scht werden , wenn es nicht mehr gebraucht wird.

Diese Prozedur verwendet statt eines TBitmaps eine TPicture-Klasse als Container.}
function ConvertImageToNewColor(Image: TPicture; MaskColor, NewColor: TColor): TPicture; overload;

{ConvertFile arbeitet wie die Funktion @link(ConvertImageToNewColor).
Allerdings werden Dateien dazu verwendet, und auch nur Bildertypen verarbeitet , die auch von TPicture
verarbeitet werden k�nnen.
FileName ist die Quelldatei, die das Bild enth�lt welches ver�ndert in NewFileName gespeichert wird.
}
function ConvertFile(FileName, NewFileName: string; MaskColor, NewColor: TColor): Boolean;

{ConvertFileExt l�dt ein Bitmap aus einer Datei und konvertiert es in eine Klasse TBitmap.
Bitmap darf nicht initialisiert , mu� aber nach Gebrauch gel�scht werden.
Siehe auch @link(ConvertFile) und @link(ConvertImageToNewColor)}
function ConvertFileExt(FileName: string; var Bitmap: TBitmap; MaskColor, NewColor: TColor): Boolean;

type
{TOrientation wird von @link(JoinBitmaps) und @link(JoinBitmapsI) verwendet, um die
Ausrichtung der anhgeh�ngten Bilder anzugeben.
orVertical bedeutet, dass die Bilder vertikal (|) angeh�ngt werden,
orHorizontal demnach horizontal. (-)}
TOrientation = (orVertical, orHorizontal);

{JoinBitmaps verkn�pft mehrere Bitmaps einer ImageListe zu einem
Die Bitmaps werden in der Reihenfolge in ImageIndexes in der angegeben Richtung in Orientation :@link(TOrientation) zusammengef�gt.
Sollen dynamische Bitmapnummer (ImageIndexes) verwendet werden ist @link(JoinBitmapsI) vorzuziehen.}
function JoinBitmaps(ImageList : TImageList; ImageIndexes : Array of const; Orientation : TOrientation) : TBitmap;
{JoinBitmapsI verkn�pft mehrere Bitmaps einer ImageListe zu einem.
Die Bitmaps werden in der Reihenfolge in ImageIndexes in der angegeben Richtung in Orientation :@link(TOrientation) zusammengef�gt.
Ein Array Of Integer kann im Gegensatz zu einem Array Of Const bequemer gehandhabt werden, und ist somit viel flexibler.}
function JoinBitmapsI(ImageList : TImageList; ImageIndexes : Array of integer; Orientation : TOrientation) : TBitmap;


implementation
uses dtSystem,dtStringsRes;

var SoundActive: Boolean = FALSE;
    vLockSound: Boolean = FALSE;

procedure DSound(Hz: Word);
//var TmpW  :Word;
begin
  if vLockSound then exit;
  raise Exception.Create('Unhandled Port-Exception '#13 +
    'Delphi Port-instruction isn''t available'#13 +
    'Nichtbehandelter Port-Ausl�ser'#13 +
    'Delphi Port-Anweisung ist noch nicht verf�gbar.');
{  Port[$43] := 182;
  TmpW      := Port[$61];
  Port[$61] := TmpW or 3;
  Port[$42] := lo(1193180 div hz);
  Port[$42] := hi(1193180 div hz);}
  SoundActive := TRUE;
end;


procedure DNoSound;
//var TmpW  :Word;
begin
  raise Exception.Create('Unhandled Port-Exception '#13 +
    'Delphi Port-instruction isn''t available'#13 +
    'Nichtbehandelter Port-Ausl�ser'#13 +
    'Delphi Port-Anweisung ist noch nicht verf�gbar.');
{  Port[$43] := 182;
  TmpW      := Port[$61];
  Port[$61] := TmpW and 3;}
  SoundActive := FALSE;
end;


function IsSound: Boolean;
begin
  Result := SoundActive;
end;

function LockSound(State: TDSoundState): Boolean;
begin
  case State of
    DSS_LOCKED: vLockSound := TRUE;
    DSS_UNLOCKED: vLockSound := FALSE;
  end;
  Result := vLockSound;
end;

procedure TExtCustomImageList.GetImages(Index: Integer; Image, Mask: TBitmap);
begin
  inherited;
end;

function CreateImageListFile(const FileName: string; ImageList: TExtCustomImageList): Integer;
var bit, mask: TBitmap;
  i: Integer;
  f: TFileStream;
  Data: array of TBitmapRec;
  Sign: array[0..100] of char;
begin
  Result := 0;
  f := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  Result := SaveImageListFileToStream(f, ImageList);
(*  strcopy(Sign,ImageFileSignature);
  f.Write(Sign,strlen(ImageFileSignature));

  f.Write(ImageFileVersion,Sizeof(ImageFileVersion));

  bit := TBitmap.Create;
  bit.Width := ImageList.Width;
  bit.Height := ImageList.Height;
  mask := TBitmap.Create;
  mask.Width := ImageList.Width;
  mask.Height := ImageList.Height;
  SetLength(Data,ImageList.Count);

  i := ImageList.Width;
  f.Write(i,Sizeof(i));

  i := ImageList.Height;
  f.Write(i,Sizeof(i));

  i := ImageList.Count;
  f.Write(i,Sizeof(i));



  for i := 0 to Length(Data) -1 do
  begin
    with Data[i] do
    begin
      UseBitmap := FALSE;
      Bitmap    := nil;
      UseMask   := FALSE;
      Mask      := nil;
    end;
  end;

  for i := 0 to ImageList.Count -1 do
  begin
    ImageList.GetImages(i,bit,mask);
    Data[i].UseBitmap := Assigned(bit) and not bit.Empty;
    Data[i].UseMask   := Assigned(mask) and not mask.Empty;
    if Data[i].UseBitmap then
    begin
     Data[i].Bitmap := TBitmap.Create;
     Data[i].Bitmap.Assign(Bit);
    end;
    if Data[i].UseMask then
    begin
     Data[i].Mask := TBitmap.Create;
     Data[i].Mask.Assign(Mask);
    end;
  end;
  {Save}

  for i := 0 to Length(Data) -1 do
  begin
    with Data[i] do
    begin
      f.Write(UseBitmap,sizeof(UseBitmap));
      f.Write(UseMask,sizeof(UseMask));
      if UseBitmap then Bitmap.SaveToStream(f);
      if UseMask   then Mask.SaveToStream(f);
    end;
  end;

  for i := 0 to Length(Data) -1 do
  begin
    with Data[i] do
    begin
      if Assigned(Mask) then Mask.Free;
      if Assigned(Bitmap) then Bitmap.Free;
    end;

  end;
  Bit.Free;*)
  strcopy(sign, 'This file was created with the help of DelphiTools and his developer Christian. '#13#10#0);
  f.Write(Sign, StrLen(Sign));
  strcopy(sign, PCHAR(Concat('FileVersion : ', IntToStr(ImageFileVersion), #0)));
  f.Write(Sign, StrLen(Sign));

  f.Free;
end;

function LoadImageListFile(const FileName: string; var ImageList: TExtCustomImageList): Integer;
var bit, mask: TBitmap;
  i: Integer;
  f: TFileStream;
  Data: array of TBitmapRec;
  Sign: array[0..100] of char;
  Version, count: integer;
  l: Longint;
begin
  Result := 0;
  f := TFileStream.Create(FileName, fmOpenRead);

  l := f.Read(Sign, strLen(ImageFileSignature));
  i := StrComp(Sign, ImageFileSignature);
  if (l <> ImageFileSignatureLen) or (i <> 0) then
  begin
    f.Free;
    raise Exception.Create('Datei scheint keine ImageListDatei zu sein!');
    exit;
  end;
  f.Read(Version, Sizeof(ImageFileVersion));
  if Version <> ImageFileVersion then
  begin
    f.Free;
    raise Exception.CreateFmt('Datei besitzt eine falsche Versionsnummer!'#13#10 +
      'Die ben�tigte ist : %d (Dateiversion : %d)', [ImageFileVersion, Version]);
    exit;
  end;

(*  bit := TBitmap.Create;
  bit.Width := ImageList.Width;
  bit.Height := ImageList.Height;
  mask := TBitmap.Create;
  mask.Width := ImageList.Width;
  mask.Height := ImageList.Height;
  SetLength(Data,ImageList.Count);

  ImageList.Clear;
  f.Read(i,Sizeof(i));
  ImageList.Width := i;
  f.Read(i,Sizeof(i));
  ImageList.Height := i;

  f.Read(Count,Sizeof(Count));
  SetLength(Data,Count);

  for i := 0 to Length(Data) -1 do
  begin
    with Data[i] do
    begin
      UseBitmap := FALSE;
      Bitmap    := TBitmap.Create;
      UseMask   := FALSE;
      Mask      := TBitmap.Create;
    end;
  end;

  for i := 0 to Length(Data) -1 do
  begin
    with Data[i] do
    begin
      f.Read(UseBitmap,sizeof(UseBitmap));
      f.Read(UseMask,sizeof(UseMask));
      if UseBitmap then Bitmap.LoadFromStream(f);
      if UseMask   then Mask.LoadFromStream(f);
    end;
  end;

  for i := 0 to Count -1 do
  begin
    with Data[i] do
    begin
     if UseBitmap and UseMask then
       ImageList.Add(Bitmap,Mask)
     else
      if UseBitmap then
       ImageList.Add(Bitmap,nil)
      else
       if UseMask then
        ImageList.Add(nil,Mask)
    end;
  end;
  {Save}

  for i := 0 to Length(Data) -1 do
  begin
    with Data[i] do
    begin
      if Assigned(Mask) then Mask.Free;
      if Assigned(Bitmap) then Bitmap.Free;
    end;

  end;
  Bit.Free;*)
  Result := LoadImageListFileFromStream(f, ImageList);
  f.Free;
end;

function LoadImageListFileExt(const FileName: string; var ImageList: TExtCustomImageList; const DoNotLoad: array of const): Integer;
var bit, mask: TBitmap;
  i: Integer;
  f: TFileStream;
  Data: array of TBitmapRec;
  Sign: array[0..100] of char;
  Version, count: integer;
  l: Longint;
begin
  Result := 0;
  f := TFileStream.Create(FileName, fmOpenRead);
  l := f.Read(Sign, strLen(ImageFileSignature));
  i := StrComp(Sign, ImageFileSignature);
  if (l <> ImageFileSignatureLen) or (i <> 0) then
  begin
    f.Free;
    raise Exception.Create('Datei scheint keine ImageListDatei zu sein!');
    exit;
  end;
  f.Read(Version, Sizeof(ImageFileVersion));
  if Version <> ImageFileVersion then
  begin
    f.Free;
    raise Exception.CreateFmt('Datei besitzt eine falsche Versionsnummer!'#13#10 +
      'Die ben�tigte ist : %d (Dateiversion : %d)', [ImageFileVersion, Version]);
    exit;
  end;
  Result := LoadImageListFileFromStreamExt(f, ImageList, DoNotLoad);
  f.Free;
end;


function SaveImageListFileToStream(Stream: TStream; ImageList: TExtCustomImageList): Integer;
var bit, mask: TBitmap;
  i: Integer;
  Data: array of TBitmapRec;
  Sign: array[0..100] of char;
begin
  Result := 0;
  Assert(Assigned(Stream), 'Stream is nil');

  strcopy(Sign, ImageFileSignature);
  Stream.Write(Sign, strlen(ImageFileSignature));

  Stream.Write(ImageFileVersion, Sizeof(ImageFileVersion));

  bit := TBitmap.Create;
  bit.Width := ImageList.Width;
  bit.Height := ImageList.Height;
  mask := TBitmap.Create;
  mask.Width := ImageList.Width;
  mask.Height := ImageList.Height;
  SetLength(Data, ImageList.Count);

  i := ImageList.Width;
  Stream.Write(i, Sizeof(i));

  i := ImageList.Height;
  Stream.Write(i, Sizeof(i));

  i := ImageList.Count;
  Stream.Write(i, Sizeof(i));



  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      UseBitmap := FALSE;
      Bitmap := nil;
      UseMask := FALSE;
      Mask := nil;
    end;
  end;

  for i := 0 to ImageList.Count - 1 do
  begin
    ImageList.GetImages(i, bit, mask);
    Data[i].UseBitmap := Assigned(bit) and not bit.Empty;
    Data[i].UseMask := Assigned(mask) and not mask.Empty;
    if Data[i].UseBitmap then
    begin
      Data[i].Bitmap := TBitmap.Create;
      Data[i].Bitmap.Assign(Bit);
    end;
    if Data[i].UseMask then
    begin
      Data[i].Mask := TBitmap.Create;
      Data[i].Mask.Assign(Mask);
    end;
  end;
  {Save}

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      Stream.Write(UseBitmap, sizeof(UseBitmap));
      Stream.Write(UseMask, sizeof(UseMask));
      if UseBitmap then Bitmap.SaveToStream(Stream);
      if UseMask then Mask.SaveToStream(Stream);
    end;
  end;

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      if Assigned(Mask) then Mask.Free;
      if Assigned(Bitmap) then Bitmap.Free;
    end;

  end;
  Bit.Free;
end;

function LoadImageListFileFromStream(Stream: TStream; var ImageList: TExtCustomImageList): Integer;
var bit, mask: TBitmap;
  i: Integer;
  Data: array of TBitmapRec;
  Sign: array[0..100] of char;
  Version, count: integer;
  l: Longint;
begin
  Result := 0;
  Assert(Assigned(Stream), 'Stream is nil');

  bit := TBitmap.Create;
  bit.Width := ImageList.Width;
  bit.Height := ImageList.Height;
  mask := TBitmap.Create;
  mask.Width := ImageList.Width;
  mask.Height := ImageList.Height;
  SetLength(Data, ImageList.Count);

  ImageList.Clear;
  Stream.Read(i, Sizeof(i));
  ImageList.Width := i;
  Stream.Read(i, Sizeof(i));
  ImageList.Height := i;

  Stream.Read(Count, Sizeof(Count));
  SetLength(Data, Count);

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      UseBitmap := FALSE;
      Bitmap := TBitmap.Create;
      UseMask := FALSE;
      Mask := TBitmap.Create;
    end;
  end;

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      Stream.Read(UseBitmap, sizeof(UseBitmap));
      Stream.Read(UseMask, sizeof(UseMask));
      if UseBitmap then Bitmap.LoadFromStream(Stream);
      if UseMask then Mask.LoadFromStream(Stream);
    end;
  end;

  for i := 0 to Count - 1 do
  begin
    with Data[i] do
    begin
      if UseBitmap and UseMask then
        ImageList.Add(Bitmap, Mask)
      else
        if UseBitmap then
          ImageList.Add(Bitmap, nil)
        else
          if UseMask then
            ImageList.Add(nil, Mask)
    end;
  end;
  {Save}

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      if Assigned(Mask) then Mask.Free;
      if Assigned(Bitmap) then Bitmap.Free;
    end;

  end;
  Bit.Free;
end;

function LoadImageListFileFromStreamExt(Stream: TStream; var ImageList: TExtCustomImageList; const DoNotLoad: array of const): Integer;
var bit, mask: TBitmap;
  i, i2: Integer;
  Data: array of TBitmapRec;
  Sign: array[0..100] of char;
  Version, count: integer;
  l: Longint;
begin
  Result := 0;
  Assert(Assigned(Stream), 'Stream is nil');

  bit := TBitmap.Create;
  bit.Width := ImageList.Width;
  bit.Height := ImageList.Height;
  mask := TBitmap.Create;
  mask.Width := ImageList.Width;
  mask.Height := ImageList.Height;
  SetLength(Data, ImageList.Count);

  ImageList.Clear;
  Stream.Read(i, Sizeof(i));
  ImageList.Width := i;
  Stream.Read(i, Sizeof(i));
  ImageList.Height := i;

  Stream.Read(Count, Sizeof(Count));
  SetLength(Data, Count);

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      UseBitmap := FALSE;
      Bitmap := TBitmap.Create;
      UseMask := FALSE;
      Mask := TBitmap.Create;
    end;
  end;

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      Stream.Read(UseBitmap, sizeof(UseBitmap));
      Stream.Read(UseMask, sizeof(UseMask));
      if UseBitmap then Bitmap.LoadFromStream(Stream);
      if UseMask then Mask.LoadFromStream(Stream);
    end;
  end;

  for i := 0 to Count - 1 do
  begin
    for i2 := 0 to Length(DoNotLoad) - 1 do
      if not (i = DoNotLoad[i2].VInteger) then
        with Data[i] do
        begin
          if UseBitmap and UseMask then
            ImageList.Add(Bitmap, Mask)
          else
            if UseBitmap then
              ImageList.Add(Bitmap, nil)
            else
              if UseMask then
                ImageList.Add(nil, Mask);
        end
      else break;
  end;
  {Save}

  for i := 0 to Length(Data) - 1 do
  begin
    with Data[i] do
    begin
      if Assigned(Mask) then Mask.Free;
      if Assigned(Bitmap) then Bitmap.Free;
    end;

  end;
  Bit.Free;
end;

function RGBToColor(Color: TRGBQuad): TColor;
begin
  Result := TColor(Color);
end;


function GetRGBColor(Color: TColor): TRGBQuad;
begin
  Result := TRGBQuad(ColorToRGB(Color));
end;

function ConvertImageToNewColor(Image: TBitmap; MaskColor, NewColor: TColor): TBitmap;
var x, y,
  dRed, dGreen, dBlue, w, h: Longint;
  p, p2: TRGBQuad;
  Img: TBitmap;
const c = 255;
begin
  Img := TBitmap.Create;
  Img.Assign(Image);

  h := Image.Height;
  w := Image.Width;

  for y := 0 to h - 1 do
    for x := 0 to w - 1 do
    begin

      if (Image.Canvas.Pixels[x, y] <> MaskColor) and
        (Image.Canvas.Pixels[x, y] <> -1)
        then
      begin
        p := GetRGBColor(Image.Canvas.Pixels[x, y]);
        dRed := c - p.rgbRed;
        dGreen := c - p.rgbGreen;
        dBlue := c - p.rgbBlue;

        p2 := GetRGBColor(NewColor);
        if p2.rgbRed - dRed > 0 then
          p2.rgbRed := p2.rgbRed - dRed
        else
          p2.rgbRed := 0;
        if p2.rgbGreen - dGreen > 0 then
          p2.rgbGreen := p2.rgbGreen - dGreen
        else
          p2.rgbGreen := 0;

        if p2.rgbBlue - dBlue > 0 then
          p2.rgbBlue := p2.rgbBlue - dBlue
        else
          p2.rgbBlue := 0;

        Img.Canvas.Pixels[x, y] := RGBToColor(p2);
      end
      else
        Img.Canvas.Pixels[x, y] := Image.Canvas.Pixels[x, y];
    end;

  Result := Img;
end;

function ConvertImageToNewColor(Image: TPicture; MaskColor, NewColor: TColor): TPicture;
var x, y,
  dRed, dGreen, dBlue, w, h: Longint;
  p, p2: TRGBQuad;
  Img: TBitmap;
  Pic: TPicture;
begin
{  Img := TPicture.Create;
  Img.Assign(Image);
 }
  h := Image.Height;
  w := Image.Width;

  Img := TBitmap.Create;
  Img.Height := Image.Height;
  Img.Width := Image.Width;
  Img.Canvas.Draw(0, 0, Image.Graphic);
  Image.Bitmap := Img;
  Pic := TPicture.CreatE;
  pic.assign(Image);

  for y := 0 to h - 1 do
    for x := 0 to w - 1 do
    begin

      if (Image.Bitmap.Canvas.Pixels[x, y] <> MaskColor) and
        (Image.Bitmap.Canvas.Pixels[x, y] <> -1)
        then
      begin
        p := GetRGBColor(Image.Bitmap.Canvas.Pixels[x, y]);
        dRed := 255 - p.rgbRed;
        dGreen := 255 - p.rgbGreen;
        dBlue := 255 - p.rgbBlue;

        p2 := GetRGBColor(NewColor);
        if p2.rgbRed - dRed > 0 then
          p2.rgbRed := p2.rgbRed - dRed
        else
          p2.rgbRed := 0;
        if p2.rgbGreen - dGreen > 0 then
          p2.rgbGreen := p2.rgbGreen - dGreen
        else
          p2.rgbGreen := 0;

        if p2.rgbBlue - dBlue > 0 then
          p2.rgbBlue := p2.rgbBlue - dBlue
        else
          p2.rgbBlue := 0;

        Img.Canvas.Pixels[x, y] := RGBToColor(p2);
      end
      else
        Img.Canvas.Pixels[x, y] := Image.Bitmap.Canvas.Pixels[x, y];
    end;

  pic.bitmap.assign(img);
  Result := pic;
end;

function ConvertFileExt(FileName: string; var Bitmap: TBitmap; MaskColor, NewColor: TColor): Boolean;
var Image1, Image2: TPicture;

begin
  Result := FALSE;
  Image1 := TPicture.Create;

  try
    Image1.LoadFromFile(FileName);
  except
    exit;
  end;

  Image2 := ConvertImageToNewColor(Image1, MaskColor, NewColor);



  Bitmap := TBitmap.Create;
  Bitmap.Assign(Image2.Bitmap);
  Result := TRUE;

  Image1.Free;
  Image2.Free;
end;

function ConvertFile(FileName, NewFileName: string; MaskColor, NewColor: TColor): Boolean;
var Image1, Image2: TPicture;

begin
  Result := FALSE;
  Image1 := TPicture.Create;

  try
    Image1.LoadFromFile(FileName);
  except
    exit;
  end;


  Image2 := ConvertImageToNewColor(Image1, MaskColor, NewColor);
  try
    Image2.SaveToFile(newFileName);
  except
    exit;
  end;
  Result := TRUE;

  Image1.Free;
  Image2.Free;
end;


function JoinBitmaps(ImageList : TImageList; ImageIndexes : Array of const; Orientation : TOrientation) : TBitmap;
var
  I: Integer;
  Bit : TBitmap;
begin
   result := Tbitmap.Create;
   for I := 0 to High(ImageIndexes) do
    with ImageIndexes[I] do
      case VType of
        vtInteger: begin
           Bit := TBitmap.Create;
           ImageList.GetBitmap(VInteger,Bit);
           if Orientation = orVertical then
           begin
             result.Height := result.Height + Bit.Height;
             if result.Width < Bit.Width then
              result.Width := Bit.Width;
             result.Canvas.Draw(0,result.Height - Bit.Height,Bit);
           end
           else
           begin
             result.Width := result.Width + Bit.Width;
             if result.Height < Bit.Height then
              result.Height := Bit.Height;
             result.Canvas.Draw(result.Width - Bit.Width,0,Bit)
           end;
           Bit.free;
        end;
      end;
end;

function JoinBitmapsI(ImageList : TImageList; ImageIndexes : Array of integer; Orientation : TOrientation) : TBitmap;
var
  I: Integer;
  Bit : TBitmap;
begin
   result := Tbitmap.Create;
   for I := 0 to High(ImageIndexes) do

      begin
           Bit := TBitmap.Create;
           ImageList.GetBitmap(ImageIndexes[I],Bit);
           if Orientation = orVertical then
           begin
             result.Height := result.Height + Bit.Height;
             if result.Width < Bit.Width then
              result.Width := Bit.Width;
             result.Canvas.Draw(0,result.Height - Bit.Height,Bit);
           end
           else
           begin
             result.Width := result.Width + Bit.Width;
             if result.Height < Bit.Height then
              result.Height := Bit.Height;
             result.Canvas.Draw(result.Width - Bit.Width,0,Bit)
           end;
           Bit.free;
        end;
end;

end.

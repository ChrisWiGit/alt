unit Objekte;

interface

uses Forms, Sysutils, classes, DBGridEH, stdctrls, comctrls, MyAccess, Db;

//TSpalten, um die Reihenfolge der Spalten speichern zu können
type

  TSpalte=class
    Spalte : String;
    Width, Nr : Integer;
    Titel : String;
    constructor Create; overload;
    constructor Create(pSpalte, pTitel : String; pWidth, pNr : Integer); overload;
  end;

  TSpalten=class(TComponent)
    private
      MySpalten : TMyQuery;
      Spalten : Array of TSpalte;
      HighNr : Integer;
      Typ : Char;
    public
      function get_SQL_Spalten : String;
      procedure save_Data;
      constructor Create(pOwner : TComponent; pTyp : Char); overload;
      destructor Destroy; overload;
      procedure del_Spalte(pNr : Integer); overload;
      procedure del_Spalte(pName : String); overload;
      procedure Format_Grid(var pGrid : TDBGridEH);
      procedure Add_Spalte(pName, pTitel : String; pWidth : Integer);
      procedure Order_Spalten_By_Nr;
      procedure Change_Width(pFieldName : String; pWidth : Integer); overload;
      procedure Change_Width(pIndex, pWidth : Integer); overload;
      procedure Change_Nr(pIndex, pNr : Integer);
      function Spalte_exists(pName : String; pTitel : String = '') : Boolean;
      function get_widths : Integer;
  end;

  //TSuche, um Dateien auf der Festplatte zu finden und in der Suchergebnis - Tabelle zu speichern
  TSuche=class(TComponent)
    private
      MyQry : TMyQuery;
      OrdnerRec : TSearchRec;
      Endung, Pfad, CD_Bez : String;
      t_Label : TStatusBar;
      zaehler : Integer;
      procedure Add_To_DB(pFileName : String);
      procedure Search_Sub(pDirectory : String);
    public
      constructor Create(pEndung, pPfad : String; POwner : TComponent); overload;
      constructor Create(pEndung, pPfad : String; pLabel : TStatusBar; POwner : TComponent); overload;
      constructor Create(pEndung, pPfad : String; pLabel : TStatusBar; pCDROM : String; POwner : TComponent); overload;
      function Start : Integer;
      destructor Destroy();
  end;

  //Kapselt die Informationen für eine MP3-Datei
  TMP3Rec = record
      Titel, Interpret, Ordner, Dateiname, CD, Titelv2, Interpretv2 : String;
      Album, Kommentar, GStr, Bitrate, Jahr, Albumv2, Kommentarv2, GStrv2, Jahrv2 : String;
      Composer, Encoder, Copyright, Language, Link, MpegType, ChannelMode, TagVersion : String;
      Genre, Beliebtheit, Dauer, Track, SampleRate : Integer;
  end;

  //repräsentiert eine MP3-Datei
  TMP3Song=class(TComponent)
    private
      MP3Data : TMP3Rec;
      function get_best_Titelv1() : String;
      function get_best_Titelv2() : String;
      function get_best_Interpretv1() : String;
      function get_best_Interpretv2() : String;
      function get_best_Albumv1() : String;
      function get_best_Albumv2() : String;
      function get_best_Kommentarv1() : String;
      function get_best_Kommentarv2() : String;
      function get_best_GenreStringv1() : String;
      function get_best_GenreStringv2() : String;
      function get_best_Jahrv1() : String;
      function get_best_Jahrv2() : String;
    public
      property Titel       : String  read get_best_titelv1       write MP3Data.Titel;
      property Titel_v1    : String  read MP3Data.Titel;
      property Interpret   : String  read get_best_Interpretv1   write MP3Data.Interpret;
      property Interpret_v1: String  read MP3Data.Interpret;
      property Ordner      : String  read MP3Data.Ordner         write MP3Data.Ordner;
      property Dateiname   : String  read MP3Data.Dateiname      write MP3Data.Dateiname;
      property CD          : String  read MP3Data.CD             write MP3Data.CD;
      property Titelv2     : String  read get_best_Titelv2       write MP3Data.Titelv2;
      property Titel_v2    : String  read MP3Data.Titelv2;
      property Interpretv2 : String  read get_best_Interpretv2   write MP3Data.Interpretv2;
      property Interpret_v2: String  read MP3Data.Interpretv2;
      property Album       : String  read get_best_Albumv1       write MP3Data.Album;
      property Album_v1    : String  read MP3Data.Album;
      property Kommentar   : String  read get_best_Kommentarv1   write MP3Data.Kommentar;
      property Kommentar_v1: String  read MP3Data.Kommentar;
      property GStr        : String  read get_best_GenreStringv1 write MP3Data.GStr;
      property GStr_v1     : String  read MP3Data.GStr;
      property Bitrate     : String  read MP3Data.Bitrate        write MP3Data.Bitrate;
      property Jahr        : String  read get_best_Jahrv1        write MP3Data.Jahr;
      property Jahr_v1     : String  read MP3Data.Jahr;
      property Albumv2     : String  read get_best_Albumv2       write MP3Data.Albumv2;
      property Album_v2    : String  read MP3Data.Albumv2;
      property Kommentarv2 : String  read get_best_Kommentarv2   write MP3Data.Kommentarv2;
      property Kommentar_v2: String  read MP3Data.Kommentarv2;
      property GStrv2      : String  read get_best_GenreStringv2 write MP3Data.GStrv2;
      property GStr_v2     : String  read MP3Data.GStrv2;
      property Jahrv2      : String  read get_best_Jahrv2        write MP3Data.Jahrv2;
      property Jahr_v2     : String  read MP3Data.Jahrv2;
      property Composer    : String  read MP3Data.Composer       write MP3Data.Composer;
      property Encoder     : String  read MP3Data.Encoder        write MP3Data.Encoder;
      property Copyright   : String  read MP3Data.Copyright      write MP3Data.Copyright;
      property Language    : String  read MP3Data.Language       write MP3Data.Language;
      property Link        : String  read MP3Data.Link           write MP3Data.Link;
      property MpegType    : String  read MP3Data.MpegType       write MP3Data.MpegType;
      property ChannelMode : String  read MP3Data.ChannelMode    write MP3Data.ChannelMode;
      property TagVersion  : String  read MP3Data.TagVersion     write MP3Data.TagVersion;
      property Genre       : Integer read MP3Data.Genre          write MP3Data.Genre;
      property Beliebtheit : Integer read MP3Data.Beliebtheit    write MP3Data.Beliebtheit;
      property Dauer       : Integer read MP3Data.Dauer          write MP3Data.Dauer;
      property Track       : Integer read MP3Data.Track          write MP3Data.Track;
      property SampleRate  : Integer read MP3Data.SampleRate     write MP3Data.SampleRate;

      procedure fill_data(pID : Integer);
      constructor Create(pOwner : TComponent);
      procedure fill_Detail_Components(pForm : TForm);
      procedure get_Detail_Components(pForm : TForm);
      procedure save_to_db(pID : Integer);
      procedure save_to_disk();
      procedure get_v2_out_of_v1();
      procedure copy(pSong : TMP3Song);
  end;

  //TEinfuegen speichert die getroffenen Einstellungen beim Einfügen von MP3s
  TEinfuegen=class(TComponent)
    private
      MP3s : Array of TMP3Song;
      MyQry : TMyQuery;
      Status : TProgressBar;
      function MP3_OK(var pMP3 : TMP3Song) : Boolean;
      function Back(pOrdner : String) : String;
    public
      Doppelt, MP3Tag, Kopieren : Boolean;
      Ordner : String;
      procedure insert;
      constructor Create(pOwner : TComponent; pStatus : TProgressBar);
      destructor Destroy;
  end;

  TFeld=class
      DatenTyp : TFieldType;
      FName : String;
      Size : Integer;
  end;

  //TTabelle beim Auslesen der Access - Tabelle benötigt
  TTabelle=class
    private
    public
      Felder: Array of TFeld;
      TName : String;
  end;

const Buchstaben : Array[0..36] of Char = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','ß','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9');

implementation

uses DMMP3, Dialogs, ShellAPI, KeinTag, Math, Main, OrdnerStrukt, MP3Info;

constructor TSpalte.Create;
begin
  Create('','',0,0);
end;

constructor TSpalte.Create(pSpalte, pTitel : String; pWidth, pNr : Integer);
begin
  Self.Spalte:=pSpalte;
  Self.Titel:=pTitel;
  Self.Width:=pWidth;
  Self.Nr:=pNr;
end;

function TSpalten.get_SQL_Spalten : String;
var i : Integer;
    t_sql : String;
begin
  t_sql:=',ID';
  for i:=0 to High(Spalten) do
  begin
    t_sql:=t_sql + ', ' + Spalten[i].Spalte;
  end;
  if trim(t_sql) <> ',ID' then t_sql:=copy(t_sql,2,length(t_sql))
                          else t_sql:='*';
  Result:=t_sql;
end;

procedure TSpalten.save_Data;
var i : Integer;
begin
  with MySpalten do
  begin
    SQL_Query('DELETE FROM Spalten WHERE Typ = '''+Self.Typ+'''','E');
    for i:=0 to High(Spalten) do
    begin
      SQL_Query('INSERT INTO Spalten (Nr, Spalte, Width, Titel, Typ) VALUES ('+IntToStr(Spalten[i].Nr)+', '''+Spalten[i].Spalte+''','''+IntToStr(Spalten[i].width)+''', '''+Spalten[i].Titel+''', '''+Self.Typ+''')','E');
    end;
    SQL_Query('SELECT * FROM Spalten ORDER BY Nr','O');
  end;
end;

constructor TSpalten.Create(pOwner : TComponent; pTyp : Char);
begin
  inherited Create(pOwner);
  Self.Typ:=pTyp;
  SetLength(Spalten,0);
  MySpalten:=TMyQuery.Create(Self);
  MySpalten.Name:='QrySpalten';
  with MySpalten do
  begin
    SQL_Query('SELECT ID, Spalte, Nr, Width, Titel FROM Spalten WHERE Typ = '''+pTyp+''' ORDER BY Nr','O');
    First;
    while not EOF do
    begin
      Self.HighNr:=Max(Self.HighNr,FieldByName('Nr').AsInteger);
      Next;
    end;
    First;
    while not EOF do
    begin
      SetLength(Spalten,High(Spalten)+2);
      Spalten[High(Spalten)]:=TSpalte.Create;
      Spalten[High(Spalten)].Spalte:=FieldByName('Spalte').AsString;
      Spalten[High(Spalten)].Width:=FieldByName('Width').AsInteger;
      Spalten[High(Spalten)].Titel:=FieldByName('Titel').AsString;
      Spalten[High(Spalten)].Nr:=FieldByName('Nr').AsInteger;
      Next;
    end;
    First;
  end;
end;

destructor TSpalten.Destroy;
begin
//  try MySpalten.Destroy; except; end;
  try FreeAndNil(MySpalten); except; end;
  inherited Destroy;
end;

procedure TSpalten.del_Spalte(pName : String);
var i : Integer;
begin
  for i:=0 to High(Spalten) do
  begin
    if AnsiUpperCase(Spalten[i].Spalte) = AnsiUpperCase(pName) then
    begin
      del_Spalte(i);
      break;
    end;
  end;
end;

procedure TSpalten.del_Spalte(pNr : Integer);
var i : Integer;
begin
  for i:=0 to High(Spalten)-1 do
  begin
    if (i >= pNr) then
    begin
      Spalten[i]:=Spalten[i+1];
    end;
  end;
  SetLength(Spalten,High(Spalten));
end;

procedure TSpalten.Format_Grid(var pGrid : TDBGridEH);
var t_titel, t_spalte : String;
    t_width, i        : Integer;
    t_column          : TColumnEH;
begin
  with pGrid.Columns do
  begin
    clear;
    for i:=0 to High(Spalten) do
    begin
      t_spalte:=Spalten[i].Spalte;
      if t_spalte = '' then continue;
      t_titel:=Spalten[i].Titel;
      t_width:=Spalten[i].Width;
      if trim(t_titel) = '' then t_titel:=t_spalte;
      if(t_width) = 0 then t_width:=100;
      t_column:=Add;
      with t_column do
      begin
        FieldName:=t_spalte;
        Title.Caption:=t_titel;
        Width:=t_width;
        if t_titel = 'X' then
        begin
          ReadOnly:=true;
          Checkboxes:=true;
        end
        else
        begin
          ReadOnly:=true;
//          Checkboxes:=false;          
        end;
      end;
    end;
  end;
end;

procedure TSpalten.Add_Spalte(pName, pTitel : String; pWidth : Integer);
begin
  SetLength(Spalten,High(Spalten)+2);
  Spalten[High(Spalten)]:=TSpalte.Create(pName,pTitel,pWidth,HighNr+1);
  HighNr:=HighNr+1;
end;


procedure TSpalten.Order_Spalten_By_Nr;
var t_spalten : Array of TSpalte;
    i, c : Integer;
begin
  SetLength(t_spalten,High(Spalten)+1);
  for i:=0 to High(Spalten) do
  begin
    t_spalten[i]:=TSpalte.Create(Spalten[i].Spalte,Spalten[i].Titel,Spalten[i].Width,Spalten[i].Nr);
  end;
  SetLength(Spalten,0);
  for c:=1 to Self.HighNr do
  begin
    for i:=0 to High(t_spalten) do
    begin
      if t_spalten[i].Nr = c then
      begin
        SetLength(Spalten,High(Spalten)+2);
        Spalten[High(Spalten)]:=TSpalte.Create(t_spalten[i].Spalte,t_spalten[i]..Titel,t_spalten[i].Width,t_spalten[i].Nr);
        break;
      end;
    end;
  end;
end;

procedure TSpalten.Change_Width(pFieldName : String; pWidth : Integer);
var i : Integer;
begin
  for i:=0 to High(Spalten) do
  begin
    if Spalten[i].Spalte = pFieldName then
    begin
      Spalten[i].Width:=pWidth;
      break;
    end;
  end;
end;

procedure TSpalten.Change_Width(pIndex, pWidth : Integer);
begin
  Spalten[pIndex].Width:=pWidth;
  Save_Data;
end;

procedure TSpalten.Change_Nr(pIndex, pNr : Integer);
begin
  Spalten[pIndex].Nr:=pNr;
end;

function TSpalten.Spalte_exists(pName : String; pTitel : String = '') : Boolean;
var i : Integer;
begin
  Result:=false;
  if pTitel = '' then
  begin
    for i:=0 to High(Spalten) do
    begin
      if not Result then Result:=(AnsiLowerCase(Spalten[i].Spalte) = AnsiLowerCase(pName));
    end;
  end
  else
  begin
    for i:=0 to High(Spalten) do
    begin
      if not Result then Result:=(AnsiLowerCase(Spalten[i].Titel) = AnsiLowerCase(pTitel));
    end;
  end;
end;

function TSpalten.get_widths : Integer;
var i, tResult : Integer;
begin
  tResult:=0;
  for i:=0 to High(Spalten) do
  begin
    Inc(tResult,Spalten[i].Width);
  end;
  Result:=tResult;
end;

constructor TSuche.Create(pEndung, pPfad : String; pOwner : TComponent);
begin
  Create(pEndung, pPfad, nil, pOwner);
end;

constructor TSuche.Create(pEndung, pPfad : String; pLabel : TStatusBar; pOwner : TComponent);
begin
  Create(pEndung,pPfad,pLabel,'',pOwner);
end;

constructor TSuche.Create(pEndung, pPfad : String; pLabel : TStatusBar; pCDROM : String; POwner : TComponent);
begin
  inherited Create(pOwner);
  CD_Bez:=pCDROM;
  Self.Endung:=pEndung;
  if trim(Self.Endung) = '' then Self.Endung:='mp3';
  Self.Pfad:=pPfad;
  if trim(Self.Pfad) = '' then Self.Pfad:='C:\';
  t_Label:=pLabel;
  MyQry:=TMyQuery.Create(Self);
  MyQry.Name:='QrySuche';
  MyQry.SQL_Query('DELETE FROM Suchergebnis','E');
  zaehler:=0;
end;

function TSuche.Start : Integer;
begin
  OrdnerRec.Attr:=OrdnerRec.Attr and faDirectory;
  Search_Sub(Self.Pfad);
  t_Label.Panels[0].Text:='';
  Application.ProcessMessages;
  Result:=zaehler;
end;

procedure TSuche.Add_To_DB(pFileName : String);
var tMP3Info : TLSMP3Info;
    tSong : TMP3SOng;
begin
  inc(zaehler);
  tMP3Info:=TLSMP3Info.Create(Self, pFileName);
  tSong:=tMP3Info.get_MP3Song();
  with Self.MyQry do
  begin
    SQL.Clear;
    SQL.Add('INSERT INTO Suchergebnis (Ordner, Dateiname, Titel, Interpret, checked, Album, Kommentar, Genre, GenreStr, CD, ');
    SQL.Add('Titelv2, Interpretv2, Albumv2, Kommentarv2, GenreStrv2, Jahr, Jahrv2, Bitrate, ');
    SQL.Add('Track, Composer, Encoder, Copyright, Sprache, Link, MpegType, Samplerate, Channelmode, TagVersion, dauer) ');
    SQL.Add('VALUES (:Ordner, :Dateiname, :Titel, :Interpret, :check, :Album, :Kommentar, :Genre, :GenreStr, :CD, ');
    SQL.Add(':Titelv2, :Interpretv2, :Albumv2, :Kommentarv2, :GenreStrv2, :Jahr, :Jahrv2, :bitrate, ');
    SQL.Add(':Track, :composer, :encoder, :copyright, :Sprache, :link, :mpegtype, :samplerate, :channelmode, :tagversion, :dauer)');
    Add_Param('Ordner',ExtractFilePath(pFileName));
    Add_Param('Dateiname',ExtractFileName(pFileName));
    Add_Param('Titel',tSong.Titel_v1);
    Add_Param('Interpret',tSong.Interpret_v1);
    Add_Param('check',true);
    Add_Param('Album',tSong.Album_v1);
    Add_Param('Kommentar',tSong.Kommentar_v1);
    Add_Param('Genre',tSong.Genre);
    Add_Param('GenreStr',FormMain.get_Genre_Str(tSong.Genre));
    Add_Param('CD',CD_Bez);
    Add_Param('Titelv2',tSong.Titel_v2);
    Add_Param('Interpretv2',tSong.Interpret_v2);
    Add_Param('Albumv2',tSong.Album_v2);
    Add_Param('Kommentarv2',tSong.Kommentar_v2);
    Add_Param('GenreStrv2',tSong.GStr_v2);
    Add_Param('Jahr',tSong.Jahr_v1);
    Add_Param('Jahrv2',tSong.Jahr_v2);
    Add_Param('Track',tSong.Track);
    Add_Param('composer',tSong.Composer);
    Add_Param('encoder',tSong.Encoder);
    Add_Param('copyright',tSong.Copyright);
    Add_Param('sprache',tSong.Language);
    Add_Param('link',tSong.Link);
    Add_Param('mpegtype',tSong.MpegType);
    Add_Param('samplerate',tSong.SampleRate);
    Add_Param('channelmode',tSong.ChannelMode);
    Add_Param('tagversion',tSong.TagVersion);
    Add_Param('dauer',tSong.Dauer);
    Add_Param('bitrate',tSong.Bitrate);
    ExecSQL;
  end;
  FreeAndNil(tMP3Info);
end;

procedure TSuche.Search_Sub(pDirectory : String);
var t_orec, t_frec : TSearchRec;
begin
  if t_Label <> nil then t_Label.Panels[0].Text:=pDirectory; // t_Label ist ein Pointer auf meine StatusBar
  Application.ProcessMessages;
  if FindFirst(pDirectory+'*.*',faDirectory,t_orec) = 0 then
  begin
    if ((t_orec.Attr and faDirectory) <> 0) and not ((t_orec.name = '.') or (t_orec.name = '..')) then Search_Sub(pDirectory+t_orec.Name+'\'); //rekursiver Aufruf der Funktion.
    while FindNext(t_orec) = 0 do
    begin
      Application.ProcessMessages;
      if ((t_orec.Attr and faDirectory) <> 0) and not ((t_orec.name = '.') or (t_orec.name = '..')) then Search_Sub(pDirectory+t_orec.Name+'\'); //s.o.
    end;
  end;
  FindClose(t_orec);
  if FindFirst(pDirectory+'*.'+Self.Endung,faAnyFile,t_frec) = 0 then  //Self.Endung ist in dem Fall 'mp3'
  begin
    Add_To_DB(pDirectory+t_frec.Name);   //speichert das MP3 in die Suchergebnis - Datenbank
    while FindNext(t_frec) = 0 do
    begin
      Application.ProcessMessages;
      Add_To_DB(pDirectory+t_frec.Name); //s.o.
    end;
  end;
  FindClose(t_frec);
end;

destructor TSuche.Destroy();
begin
  try FreeAndNil(MyQry); except; end;
  inherited Destroy;
end;

//TMP3Song
function TMP3Song.get_best_Titelv1() : String;
begin
  if Self.MP3Data.Titel = '' then Result:=Self.MP3Data.Titelv2
                             else Result:=Self.MP3Data.Titel;
end;

function TMP3Song.get_best_Titelv2() : String;
begin
  if Self.MP3Data.Titelv2 = '' then Result:=Self.MP3Data.Titel
                               else Result:=Self.MP3Data.Titelv2;
end;

function TMP3Song.get_best_Interpretv1() : String;
begin
  if Self.MP3Data.Interpret = '' then Result:=Self.MP3Data.Interpretv2
                                 else Result:=Self.MP3Data.Interpret;
end;

function TMP3Song.get_best_Interpretv2() : String;
begin
  if Self.MP3Data.Interpretv2 = '' then Result:=Self.MP3Data.Interpret
                                   else Result:=Self.MP3Data.Interpretv2;
end;

function TMP3Song.get_best_Albumv1() : String;
begin
  if Self.MP3Data.Album = '' then Result:=Self.MP3Data.Albumv2
                             else Result:=Self.MP3Data.Album;
end;

function TMP3Song.get_best_Albumv2() : String;
begin
  if Self.MP3Data.Albumv2 = '' then Result:=Self.MP3Data.Album
                               else Result:=Self.MP3Data.Albumv2;
end;

function TMP3Song.get_best_Kommentarv1() : String;
begin
  if Self.MP3Data.Kommentar = '' then Result:=Self.MP3Data.Kommentarv2
                                 else Result:=Self.MP3Data.Kommentar;
end;

function TMP3Song.get_best_Kommentarv2() : String;
begin
  if Self.MP3Data.Kommentarv2 = '' then Result:=Self.MP3Data.Kommentar
                                   else Result:=Self.MP3Data.Kommentarv2;
end;

function TMP3Song.get_best_GenreStringv1() : String;
begin
  if Self.MP3Data.GStr = '' then Result:=Self.MP3Data.GStrv2
                            else Result:=Self.MP3Data.GStr;
end;

function TMP3Song.get_best_GenreStringv2() : String;
begin
  if Self.MP3Data.GStrv2 = '' then Result:=Self.MP3Data.GStr
                              else Result:=Self.MP3Data.GStrv2;
end;

function TMP3Song.get_best_Jahrv1() : String;
begin
  if Self.MP3Data.Jahr = '' then Result:=Self.MP3Data.Jahrv2
                            else Result:=Self.MP3Data.Jahr;
end;

function TMP3Song.get_best_Jahrv2() : String;
begin
  if Self.MP3Data.Jahrv2 = '' then Result:=Self.MP3Data.Jahr
                              else Result:=Self.MP3Data.Jahrv2;
end;

procedure TMP3Song.fill_data(pID : Integer);
var t_qry : TMyQuery;
begin
  t_qry:=TMyQuery.Create(Self);
  with t_qry do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM MP3s WHERE ID = :ID');
    Add_Param('ID',pID);
    Open;
    if recordcount > 0 then
    begin
      Self.Titel:=FieldByName('Titel').AsString;
      Self.Interpret:=FIeldByName('Interpret').AsString;
      Self.Titelv2:=FieldByName('Titelv2').AsString;
      Self.Interpretv2:=FIeldByName('Interpretv2').AsString;
      Self.Ordner:=FieldByName('Verzeichnis').AsString;
      Self.Dateiname:=FieldByName('Dateiname').AsString;
      Self.CD:=FieldByName('CD').AsString;
      Self.Album:=FieldByName('Album').AsString;
      Self.Kommentar:=FieldByName('Kommentar').AsString;
      Self.GStr:=FieldByName('GenreStr').AsString;
      Self.Albumv2:=FieldByName('Albumv2').AsString;
      Self.Kommentarv2:=FieldByName('Kommentarv2').AsString;
      Self.GStrv2:=FieldByName('GenreStrv2').AsString;
      Self.Genre:=FieldByName('Genre').AsInteger;
      Self.Beliebtheit:=FieldByName('Beliebtheit').AsInteger;
      Self.Bitrate:=FieldByName('Bitrate').AsString;
      Self.Dauer:=FieldByName('Dauer').AsInteger;
      Self.Jahr:=FieldByName('Jahr').AsString;
      Self.Jahrv2:=FieldByName('Jahrv2').AsString;
      Self.Track:=FieldByName('Track').AsInteger;
      Self.Composer:=FieldByName('Composer').AsString;
      Self.encoder:=FieldByName('encoder').AsString;
      Self.copyright:=FieldByName('copyright').AsString;
      Self.language:=FieldByName('Sprache').AsString;
      Self.link:=FieldByName('link').AsString;
      Self.mpegtype:=FieldByName('mpegtype').AsString;
      Self.SampleRate:=FieldByName('Samplerate').AsInteger;
      Self.channelmode:=FieldByName('channelmode').AsString;
      Self.tagversion:=FieldByName('tagversion').AsString;
    end
    else
    begin
      Self.Titel:='';
      Self.Interpret:='';
      Self.Titelv2:='';
      Self.Interpretv2:='';
      Self.Ordner:='';
      Self.Dateiname:='';
      Self.CD:='';
      Self.Album:='';
      Self.Kommentar:='';
      Self.GStr:='';
      Self.Albumv2:='';
      Self.Kommentarv2:='';
      Self.GStrv2:='';
      Self.Genre:=0;
      Self.Beliebtheit:=0;
      Self.Bitrate:='';
      Self.Dauer:=0;
      Self.Jahr:='';
      Self.Jahrv2:='';
      Self.Track:=0;
      Self.Composer:='';
      Self.encoder:='';
      Self.copyright:='';
      Self.language:='';
      Self.link:='';
      Self.mpegtype:='';
      Self.SampleRate:=0;
      Self.channelmode:='';
      Self.tagversion:='';
    end;
  end;
  FreeAndNil(t_qry);
end;

constructor TMP3Song.Create(pOwner : TComponent);
begin
  inherited;
end;

procedure TMP3Song.fill_Detail_Components(pForm : TForm);
begin
  TEdit(pForm.FindComponent('EDInterpret')).Text:=Self.MP3Data.Interpret;
  TEdit(pForm.FindComponent('EDTitel')).Text:=Self.MP3Data.Titel;
  TEdit(pForm.FindComponent('EDBemerkung')).Text:=Self.MP3Data.Kommentar;
  TEdit(pForm.FindComponent('EDAlbum')).Text:=Self.MP3Data.Album;
  FormMain.select_CB(TComboBox(pForm.FindComponent('CBGenre')),Self.GStr);
  TEdit(pForm.FindComponent('EDInterpretv2')).Text:=Self.MP3Data.Interpretv2;
  TEdit(pForm.FindComponent('EDTitelv2')).Text:=Self.MP3Data.Titelv2;
  TEdit(pForm.FindComponent('EDBemerkungv2')).Text:=Self.MP3Data.Kommentarv2;
  TEdit(pForm.FindComponent('EDAlbumv2')).Text:=Self.MP3Data.Albumv2;
  FormMain.select_CB(TComboBox(pForm.FindComponent('CBGenrev2')),Self.MP3Data.GStrv2);
  TComboBox(pForm.FindComponent('CBGenrev2')).Text:=Self.MP3Data.GStrv2;
  TLabel(pForm.FindComponent('LVerzeichnis')).Caption:=FormMain.make_more_Lines(Self.MP3Data.Ordner,TLabel(pForm.FindComponent('LVerzeichnis')).Width);
  TLabel(pForm.FindComponent('LVerzeichnisr')).Caption:=Self.MP3Data.Ordner;
  TLabel(pForm.FindComponent('LDateiname')).Caption:=FormMain.make_more_Lines(Self.MP3Data.Dateiname,TLabel(pForm.FindComponent('LDateiname')).Width);
  TLabel(pForm.FindComponent('LDateinameR')).Caption:=Self.MP3Data.Dateiname;
  TLabel(pForm.FindComponent('LCD')).Caption:=Self.MP3Data.CD;
  TLabel(pForm.FindComponent('LBitrate')).Caption:=Self.MP3Data.Bitrate+' kbps';
  TLabel(pForm.FindComponent('LDauer')).Caption:=FormMain.get_TimeStr(Self.MP3Data.Dauer);
  TEdit(pForm.FindComponent('EDJahr')).Text:=Self.MP3Data.Jahr;
  TEdit(pForm.FindComponent('EDJahrv2')).Text:=Self.MP3Data.Jahrv2;
  TEdit(pForm.FindComponent('EDTrack')).Text:=IntToStr(Self.MP3Data.Track);
  TEdit(pForm.FindComponent('EDComposer')).Text:=Self.MP3Data.Composer;
  TEdit(pForm.FindComponent('EDencoder')).Text:=Self.MP3Data.encoder;
  TEdit(pForm.FindComponent('EDcopyright')).Text:=Self.MP3Data.copyright;
  TEdit(pForm.FindComponent('EDlanguage')).Text:=Self.MP3Data.language;
  TEdit(pForm.FindComponent('EDlink')).Text:=Self.MP3Data.link;
  TLabel(pForm.FindComponent('Lmpegtype')).Caption:=Self.MP3Data.mpegtype;
  TLabel(pForm.FindComponent('LSamplerate')).Caption:=IntToStr(Self.MP3Data.Samplerate);
  TLabel(pForm.FindComponent('Lchannelmode')).Caption:=Self.MP3Data.channelmode;
  TLabel(pForm.FindComponent('Ltagversion')).Caption:=Self.MP3Data.tagversion;
end;

procedure TMP3Song.get_Detail_Components(pForm : TForm);
begin
  Self.Interpret:=TEdit(pForm.FindComponent('EDInterpret')).Text;
  Self.Titel:=TEdit(pForm.FindComponent('EDTitel')).Text;
  Self.Kommentar:=TEdit(pForm.FindComponent('EDBemerkung')).Text;
  Self.Album:=TEdit(pForm.FindComponent('EDAlbum')).Text;
  Self.Genre:=FormMain.get_Genre_ID(TComboBox(pForm.FindComponent('CBGenre')).Text);
  Self.GStr:=FormMain.get_Genre_Str(Self.Genre);
  Self.Interpretv2:=TEdit(pForm.FindComponent('EDInterpretv2')).Text;
  Self.Titelv2:=TEdit(pForm.FindComponent('EDTitelv2')).Text;
  Self.Kommentarv2:=TEdit(pForm.FindComponent('EDBemerkungv2')).Text;
  Self.Albumv2:=TEdit(pForm.FindComponent('EDAlbumv2')).Text;
  Self.GStrv2:=TComboBox(pForm.FindComponent('CBGenrev2')).Text;
  Self.Ordner:=TLabel(pForm.FindComponent('LVerzeichnisR')).Caption;
  Self.Dateiname:=TLabel(pForm.FindComponent('LDateinameR')).Caption;
  Self.CD:=TLabel(pForm.FindComponent('LCD')).Caption;
  Self.Jahr:=TEdit(pForm.FindComponent('EDJahr')).Text;
  Self.Jahrv2:=TEdit(pForm.FindComponent('EDJahrv2')).Text;
  Self.Track:=StrToInt(TEdit(pForm.FindComponent('EDTrack')).Text);
  Self.Composer:=TEdit(pForm.FindComponent('EDComposer')).Text;
  Self.encoder:=TEdit(pForm.FindComponent('EDencoder')).Text;
  Self.copyright:=TEdit(pForm.FindComponent('EDcopyright')).Text;
  Self.language:=TEdit(pForm.FindComponent('EDlanguage')).Text;
  Self.link:=TEdit(pForm.FindComponent('EDlink')).Text;
  Self.mpegtype:=TLabel(pForm.FindComponent('Lmpegtype')).Caption;
  Self.Samplerate:=StrToIntDef(TLabel(pForm.FindComponent('LSamplerate'))..Caption,0);
  Self.channelmode:=TLabel(pForm.FindComponent('Lchannelmode')).Caption;
  Self.tagversion:=TLabel(pForm.FindComponent('Ltagversion')).Caption;
end;

procedure TMP3Song.save_to_db(pID : Integer);
var t_qry : TMyQuery;
    t_sql_tag : String;
    t_tag : Boolean;
    tMP3Info : TLSMP3Info;
begin
  t_qry:=TMyQuery.Create(Self);
  with t_qry do
  begin
    try
      if (FileExists(FormMain.BackSlash(Self.Ordner)+Self.Dateiname) and (trim(Self.CD) = '')) then
      begin
        t_sql_tag:='Interpret = :Interpret, Titel = :Titel, Kommentar = :Kommentar, Album = :Album, Genre = :Genre, GenreStr = :GStr, '
                  +'Interpretv2 = :Interpretv2, Titelv2 = :Titelv2, Kommentarv2 = :Kommentarv2, Albumv2 = :Albumv2, GenreStrv2 = :Gstrv2, '
                  +'Jahr = :Jahr, Jahrv2 = :Jahrv2, Track = :Track, Composer = :Composer, Encoder = :Encoder, Copyright = :Copyright, Sprache = :Sprache, '
                  +'Link = :Link, ';
        t_tag:=true;
      end
      else
      begin
        t_sql_tag:='';
        t_tag:=false;
      end;
      tMP3Info:=TLSMP3Info.Create(Self, FormMain.BackSlash(Self.Ordner)+Self.Dateiname);
      try
        tMP3Info.set_to_file(Self);
      except;
        FreeAndNil(t_qry);
        FreeAndNil(tMP3Info);
        exit;
      end;
      FreeAndNil(tMP3Info);
      Close;
      SQL.Clear;
      SQL.Add('SELECT ID FROM MP3s WHERE ID = :ID');
      Add_Param('ID',pID);
      Open;
      if recordcount > 0 then //ID bereits vorhanden
      begin
        CLose;
        SQL.Clear;
        SQL.Add('UPDATE MP3s SET '+t_sql_tag+'Verzeichnis = :Verzeichnis, Dateiname = :Dateiname,');
        SQL.Add(' CD = :CD, Dauer = :Dauer, Bitrate = :bitrate, MPegType = :mpegtype, SampleRate = :samplerate, '
               +' Channelmode = :channelmode, TagVersion = :TagVersion WHERE ID = :ID');
        if t_tag then
        begin
          Add_Param('Interpret',Self.MP3Data.Interpret);
          Add_Param('Titel',Self.MP3Data.Titel);
          Add_Param('Kommentar',Self.MP3Data.Kommentar);
          Add_Param('Album',Self.MP3Data.Album);
          Add_Param('Genre',Self.MP3Data.Genre);
          Add_Param('GStr',Self.MP3Data.Gstr);
          Add_Param('Interpretv2',Self.MP3Data.Interpretv2);
          Add_Param('Titelv2',Self.MP3Data.Titelv2);
          Add_Param('Kommentarv2',Self.MP3Data.Kommentarv2);
          Add_Param('Albumv2',Self.MP3Data.Albumv2);
          Add_Param('GStrv2',Self.MP3Data.Gstrv2);
          Add_Param('Jahr',Self.MP3Data.Jahr);
          Add_Param('Jahrv2',Self.MP3Data.Jahrv2);
          Add_Param('Track',Self.MP3Data.Track);
          Add_Param('Composer',Self.MP3Data.Composer);
          Add_Param('Encoder',Self.MP3Data.Encoder);
          Add_Param('CopyRight',Self.MP3Data.CopyRight);
          Add_Param('Sprache',Self.MP3Data.Language);
          Add_Param('Link',Self.MP3Data.Link);
        end;
        Add_Param('Verzeichnis',Self.MP3Data.Ordner);
        Add_Param('Dateiname',Self.MP3Data.Dateiname);
        Add_Param('CD',Self.MP3Data.CD);
        Add_Param('Dauer',Self.MP3Data.Dauer);
        Add_Param('Bitrate',Self.MP3Data.Bitrate);
        Add_Param('MPegType',Self.MP3Data.MpegType);
        Add_Param('SampleRate',Self.MP3Data.SampleRate);
        Add_Param('ChannelMode',Self.MP3Data.ChannelMode);
        Add_Param('TagVersion',Self.MP3Data.TagVersion);
        Add_Param('ID',pID);
        ExecSQL;
      end;
    except
      on E : Exception do
      begin
//        ShowMessage(E.Message+#10+#13+t_qry.SQL.Text);
      end;
    end;
  end;
  FreeAndNil(t_qry);
end;

procedure TMP3Song.save_to_disk();
var tMP3Info : TLSMP3Info;
begin
  tMP3Info:=TLSMP3Info.Create(Self,FormMain.BackSlash(Self.Ordner)+Self.Dateiname);
  tMP3Info.set_to_file(Self);
  FreeAndNil(tMP3Info);
end;

procedure TMP3Song.get_v2_out_of_v1();
begin
  Self.Titelv2:=Self.Titel;
  Self.Interpretv2:=Self.Interpret;
  Self.Albumv2:=Self.Album;
  Self.Kommentarv2:=Self.Kommentar;
  Self.GStrv2:=Self.GStr;
  Self.Jahrv2:=Self.Jahr;
end;

procedure TMP3Song.copy(pSong : TMP3Song);
begin
  Self.Titel:=pSong.Titel_v1;
  Self.Titelv2:=pSong.Titel_v2;
  Self.Interpret:=pSong.Interpret_v1;
  Self.Interpretv2:=pSong.Interpret_v2;
  Self.Ordner:=pSong.Ordner;
  Self.Dateiname:=pSong.Dateiname;
  Self.CD:=pSong.CD;
  Self.Album:=pSong.Album_v1;
  Self.Albumv2:=pSong.Album_v2;
  Self.Kommentar:=pSong.Kommentar_v1;
  Self.Kommentarv2:=pSong.Kommentar_v2;
  Self.GStr:=pSong.GStr_v1;
  Self.GStrv2:=pSong.GStr_v2;
  Self.Bitrate:=pSong.Bitrate;
  Self.Jahr:=pSong.Jahr_v1;
  Self.Jahrv2:=pSong.Jahr_v2;
  Self.Composer:=pSong.Composer;
  Self.Encoder:=pSong.Encoder;
  Self.Copyright:=pSong.Copyright;
  Self.Language:=pSong.Language;
  Self.Link:=pSong.Link;
  Self.MpegType:=pSong.MpegType;
  Self.ChannelMode:=PSong.ChannelMode;
  Self.TagVersion:=pSong.TagVersion;
  Self.Genre:=pSong.Genre;
  Self.Beliebtheit:=pSong.Beliebtheit;
  Self.Dauer:=pSong.Dauer;
  Self.Track:=pSong.Track;
  Self.SampleRate:=pSong.SampleRate;
end;

procedure TEinfuegen.insert;
var t_mp3 : TMP3Song;
    t_insertqry: TMyQuery;
    t_mp3OK : Boolean;
    t_mp3Info : TLSMP3Info;
begin
  SetLength(MP3s,0);
  if Status <> nil then Status.Position:=0;
  with MyQry do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM Suchergebnis WHERE checked = :check');
    Add_Param('check',true);
    Open;
    first;
    if Status <> nil then Status.Max:=recordcount;
    t_insertqry:=TMyQuery.Create(Self);
    while not EOF do
    begin
      Application.ProcessMessages;
      if Status <> nil then Status.StepBy(1);
      SetLength(MP3s,High(MP3s)+2);
      t_mp3Info:=TLSMP3Info.Create(Self,FormMain.BackSlash(FieldByName('Ordner').AsString) + FieldByName('Dateiname').AsString);
      t_mp3:=t_mp3Info.get_MP3Song;
      t_mp3.CD:=FieldByName('CD').AsString; //Name der CD
      if MP3_OK(t_mp3) then
      begin
        with t_insertqry do
        begin
          try Close; except; end;
          t_mp3OK:=true;
          if Self.Doppelt then
          begin
            SQL.Clear;
            SQL.Add('SELECT ID FROM MP3s WHERE Verzeichnis = :verz AND Dateiname = :dat');
            Add_Param('verz',t_mp3.Ordner);
            Add_Param('dat',t_mp3.Dateiname);
            Open;
            t_mp3ok:=(recordcount = 0);
          end;
          SQL.Clear;
          if t_mp3ok then
          begin
            SQL.Add('INSERT INTO MP3s (Titel,Interpret, Kommentar, Verzeichnis, Dateiname, Album, Beliebtheit, checked, CD, Genre, GenreStr, Bitrate, Dauer, '
                                     +'Titelv2, Interpretv2, Kommentarv2, Albumv2, GenreStrv2, Jahr, Jahrv2, '
                                     +'Track, Composer, Encoder, Copyright, Sprache, Link, MpegType, SampleRate, Channelmode, TagVersion)');
            SQL.Add('VALUES( :Titel, :Interpret, :Kommentar, :Ordner, :Dateiname, :Album, :Beliebt, :check, :CD, :Genre, :GStr, :bitrate, :dauer, '
                          +':Titelv2, :Interpretv2, :Kommentarv2, :Albumv2, :GStrv2, :Jahr, :Jahrv2, '
                          +':Track, :Composer, :Encoder, :Copyright, :Sprache, :Link, :MpegType, :SampleRate, :Channelmode, :TagVersion)');
            Add_Param('Titel',t_mp3.Titel);
            Add_Param('Interpret',t_mp3.Interpret);
            Add_Param('Kommentar',t_mp3.Kommentar);
            Add_Param('Ordner',t_mp3.Ordner);
            Add_Param('Dateiname',t_mp3.Dateiname);
            Add_Param('Album',t_mp3.Album);
            Add_Param('Beliebt',t_mp3.Beliebtheit);
            Add_Param('check',false);
            Add_Param('CD',t_mp3.CD);
            Add_Param('Genre',t_mp3.Genre);
            Add_Param('GStr',t_mp3.GStr);
            Add_Param('Bitrate',t_mp3.Bitrate);
            Add_Param('Dauer',t_mp3.Dauer);
            Add_Param('Titelv2',t_mp3.Titelv2);
            Add_Param('Interpretv2',t_mp3.Interpretv2);
            Add_Param('Kommentarv2',t_mp3.Kommentarv2);
            Add_Param('Albumv2',t_mp3.Albumv2);
//            Add_Param('Genrev2',t_mp3.Genrev2);
            Add_Param('GStrv2',t_mp3.GStrv2);
            Add_Param('Jahr',t_mp3.Jahr);
            Add_Param('Jahrv2',t_mp3.Jahrv2);
            Add_Param('Track',t_mp3.Track);
            Add_Param('Composer',t_mp3.Composer);
            Add_Param('Encoder',t_mp3.Encoder);
            Add_Param('Copyright',t_mp3.Copyright);
            Add_Param('Sprache',t_mp3.Language);
            Add_Param('Link',t_mp3.Link);
            Add_Param('MpegType',t_mp3.MpegType);
            Add_Param('SampleRate',t_mp3.SampleRate);
            Add_Param('Channelmode',t_mp3.Channelmode);
            Add_Param('TagVersion',t_mp3.TagVersion);
            ExecSQL;
          end;
        end;
      end;
    Next;
    end;
  end;
  if Status <> nil then Status.Position:=0;
//  t_mp3.Destroy;
  FreeAndNil(t_mp3);
//  t_insertqry.Destroy;
  FreeAndNil(t_insertQry);
end;

function TEinfuegen.MP3_OK(var pMP3 : TMP3Song) : Boolean;
var t_result : Boolean;
    t_wind : TFormKeinTag;
begin
  t_result:=true;
  if Self.MP3Tag then
  begin  //To - DO genaues Überprüfen, ob kein MP3Tag gefunden wurde!!!
    if (trim(pMP3.Titel+pMP3.Interpret)) = '' then t_result:=false;
  end;
  if not t_result then
  begin
    t_wind:=TFormKeinTag.Create(Self,'MP3-Datei ohne ID3Tag gefunden!', pMP3);
    t_wind.ShowModal;
    t_wind.Release;
  end;
  if (Self.Kopieren) and t_result and (trim(Ordner) <> '') then
  begin
    DataMP3.FileUtil.FilesFrom:=Back(pMP3.Ordner)+pMP3.Dateiname;
    DataMP3.FileUtil.FilesTo:=Back(Ordner)+pMP3.Dateiname;;
    if DataMP3.FileUtil.Execute then
    begin
      if FileExists(Back(Ordner)+pMP3.Dateiname) then pMP3.Ordner:=Back(Ordner);
    end;
  end;
  Result:=t_result;
end;

function TEinfuegen.Back(pOrdner : String) : String;
begin
  if copy(pOrdner,Length(pOrdner),1) <> '\' then Result:=pOrdner+'\'
                                            else Result:=pOrdner;
end;

constructor TEinfuegen.Create(pOwner : TComponent; pStatus : TProgressBar);
begin
  inherited Create(pOwner);
  Self.Status:=pStatus;
  MyQry:=TMyQuery.Create(Self);
end;

destructor TEinfuegen.Destroy;
begin
  try FreeAndNil(MyQry); except; end;
  inherited Destroy;
end;

end.


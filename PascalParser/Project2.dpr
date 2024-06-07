program Project2;


{warum ist das parsen plötzlich so langsam?=??
->> liegt am Preprocessor
->> fehler zeile 144 in preprocessor.pas}
{$DEFINE PREPROCESSING}

{$APPTYPE CONSOLE}


uses
  MemCheck,
  SysUtils,
  Windows,
  Classes,
  SParser in 'SParser.pas',
  IOClasses in 'IOClasses.pas',
  PasStream in 'PasStream.pas',
  PascalScanner in 'PascalScanner.pas',
  NewCrt,
  PrePParser in 'PrePParser.pas',
  IncludeParser,
  RegClasses in 'RegClasses.pas';

var 
  Strings,Parameters: TStringList;
  F: Text;

  FileName: string;
  aUnit: TUnit;
  functionsCount, typesCount, varsCount, constsCount, recCount,
  objectsCount, classesCount, interfacesCount: integer;

var
  Timer: DWORD;
  //TDateTime;

procedure WriteAll; forward;
procedure UpdateAll; forward;
procedure ClearCount; forward;

procedure WritelnE(s: string);
begin
  Strings.Add(StringReplace(s, #$d#$a, '#', [rfReplaceAll]));
end;




{comment besitzt #13#10 das lässt die darstellung verkorksen
 spaces > 0 rückt ein bei mehreren Zeilen sind
 }


procedure AddComment(comment: string; Spaces: cardinal = 0);
var
  i, c: integer;
  s: string;

  procedure Add(S: string);
  var
    space: string;
  begin
    if (Spaces > 0) and (C > 0) then
      space := StringOfChar(' ', Spaces);
    Strings.Add(space + s);
  end;


begin
  if comment = '' then exit;
  //  s := '{';
  c := 0;
  //space := '';
  comment := StringReplace(comment, #13#10, '_', [rfReplaceAll]);
  for i := 1 to Length(Comment) do
  begin
    if //(comment[i] = #1) or
      (((i mod (79)) = 0) or ((c > 0) and ((i mod (75 - integer(Spaces))) = 0))) then
    begin
      // if (comment[i] <> #1) then
      s := s + comment[i];
      Add(s);
      s := '';
      Inc(c);
    end
    else
      s := s + comment[i];
  end;
  Add(s);
end;


var 
  tokencount: cardinal = 0;

procedure WriteHeader;
var
  Msg, Data: string;
  aend: DWORD;
  //TdateTime;

  hh,mm,ss,ms : Word;
  c: int64;
  a,z : Extended;
  LpS,t : String; //Lines per sec
begin
  aend := GetTickCount - Timer;


  if aUnit.IsLibrary then
    Data := 'Bibilothek'
  else
    Data := 'Unit';

  Msg := 'eingebundene Units';
  Strings.Add(Format('%s "%s" wurde erfolgreich analysiert.', [Data, aUnit.Name]));
  Strings.Add('benoetigte Zeit :');
  if ParamCount = 0 then
    c := 1
  else
    c := ParamCount;
//  t := FormatDateTime('hh "Stunden" nn "Minuten" ss "Sekunden" zzz "Hunderstel"', aend);
  t := '';
  Strings.Add(Format('%d Datei(en) gelesen',
    [c]));

 //  hier ausrechnen -> aend in hh , mm, ss und hudnerstel um dann
 //  a := hh * 60 * 60 + m *60 + ss + hh div 100
{   DecodeTime(aend,hh,mm,ss,ms);
  a := hh * 60 * 60 + mm * 60 + ss + (ms div 1000);}

  a := aend /  1000;
  if a = 0 then
    lps := '?'
  else
  begin
//    c := Round(System.Int(a));
    lps := Format('%0.0f',[aUnit.LineCount / a ]);
  end;

  Strings.Add(Format('%d token gelesen; %d zeilen in %0.2f sek (%s Zeilen/s) ', [tokencount,aUnit.LineCount,a,lps]));
  z := (100000 / aUnit.LineCount) * a;
  Strings.Add(Format('(theoretisch 100.000 Zeilen in %0.2f sek)',[z]));


  Strings.Add('');
  Strings.Add(StringOfChar(#196, 12) + Msg + StringOfChar(#196, 80 - Length(Msg) - 5));
  Strings.Add(StringOfChar(#196, 80));
end;

procedure WriteItems(aUnit: TUnit; aType: TIOClassType; var Count: integer; Msg: string);
var 
  i, c, p: integer;
  CheckType: boolean;
begin
  p := Strings.Count;
  c := 0;
  for i := 0 to aUnit.Items.Count - 1 do
  begin
    CheckType := (TBaseEntry(aUnit.Items[i]).Kind = aType);
    if CheckType      //and not (TBaseEntry(aUnit.Items[i]) is TBaseVariable)
      {}// or        CheckType and (TBaseEntry(aUnit.Items[i]) is TBaseVariable) and not (Assigned(TBaseVariable(aUnit.Items[i]).Parent))
      then
    begin
      Inc(c);
      Strings.Add(IntToStr(c));
      //Strings.Add('// '+TFunction(aUnit.Items[i]).Comment);
      if Length(TBaseEntry(aUnit.Items[i]).SingleComment) > 0 then
        AddComment('//' + TBaseEntry(aUnit.Items[i]).SingleComment);
      AddComment('{' + TBaseEntry(aUnit.Items[i]).Comment + '}');
      //Strings.Add('-->'+TBaseEntry(aUnit.Items[i]).Declaration);
      AddComment('-->' + TBaseEntry(aUnit.Items[i]).Declaration);

      Inc(Count);
    end;
  end;
  if Count = 0 then exit;
  Strings.Add(StringOfChar(#196, 80));
  Strings.Insert(p, StringOfChar(#196, 12) + Msg + StringOfChar(#196, 80 - Length(Msg) - 5));
end;

procedure WriteClasses(aUnit: TUnit);
var 
  i, c, p: integer;
  CheckType: boolean;
  Msg: string;

  procedure AddItems(i: integer; aTyp: TIOClassType);
    function GetVis(vis: TVisibility): string;
    begin
      case vis of
        vprivate: Result := 'privat';
        vprotected: Result := 'protected';
        vpublic: Result := 'public';
        vpublished: Result := 'published';
        else
          Result := '';
      end;
    end;
  var 
    ClassITem: TBaseEntry;
    ii: integer;
  begin
    for ii := 0 to TOCIEntry(aUnit.Items[i]).Items.Count - 1 do
    begin
      ClassItem := TBaseEntry(TOCIEntry(aUnit.Items[i]).Items[ii]);
      if (ClassItem.Kind = aTyp) then
      begin
        AddComment(' ');
        if Length(ClassItem.SingleComment) > 0 then
          AddComment('//' + ClassItem.SingleComment);
        AddComment('________>{' + ClassItem.Comment + '}', 10);
        AddComment(GetVis(ClassItem.Visibility) + '-->' + ClassItem.Declaration, 8);
      end;
    end;
  end;
begin
  p := Strings.Count;
  c := 0;
  Msg := 'Klassen';
  for i := 0 to aUnit.Items.Count - 1 do
  begin
    CheckType := (TBaseEntry(aUnit.Items[i]).Kind in [ct_class, ct_object,
      ct_interface, ct_dispinterface]);
    if CheckType then
    begin
      Inc(c);
      Strings.Add(IntToStr(c));
      AddComment('{' + TBaseEntry(aUnit.Items[i]).Comment + '}');
      if Length(TBaseEntry(aUnit.Items[i]).SingleComment) > 0 then
        AddComment('//' + TBaseEntry(aUnit.Items[i]).SingleComment);
      AddComment('-->' + TBaseEntry(aUnit.Items[i]).Declaration);
      AddItems(i, ct_BaseVariable);
      AddItems(i, ct_Function);
      AddItems(i, ct_property);

      case TBaseEntry(aUnit.Items[i]).Kind of
        ct_class: Inc(classesCount);
        ct_object: Inc(objectsCount);
        ct_interface: Inc(interfacesCount);
        ct_dispinterface: Inc(interfacesCount);
      end;
    end;
  end;
  if (classesCount + objectsCount + interfacesCount) = 0 then exit;
  Strings.Add(StringOfChar(#196, 80));
  Strings.Insert(p, StringOfChar(#196, 12) + Msg + StringOfChar(#196, 80 - Length(Msg) - 5));
end;


procedure WriteEnd;
begin
  Strings.Add('');

  Strings.Add(StringOfChar(#196, 80));
  Strings.Add(Format('%.3d Funktion(en), %.3d Typ(en), %.3d Variable(n), %.3d Strukturen,',
    [functionsCount, typesCount, varsCount, recCount]));
  Strings.Add(Format('%.3d Konstante(n), %.3d Objekt(e), %.3d Klasse(n), %.3d Interface gefunden.',
    [constsCount, objectsCount, classesCount, interfacesCount]));
end;

var 
  position: integer = 0;

procedure RewriteStrings(Direction: integer);
var 
  i, i2, lp: integer;
  IsComment: boolean;
begin
  if (position > 0) and (Direction < 0) then
  begin
    if Position + Direction < 0 then
    begin
      Position := 0;
      Click;
    end
    else
      Position := Position + Direction
  end
  else if (position < Strings.Count) and (Direction > 0) then
  begin
    if (Strings.Count - Position) < 21 then
      exit;
    if (Direction + Position + 20) >= Strings.Count then
    begin
      Position := Strings.Count - 20;
      Click;
    end
    else
      Position := Position + Direction
  end
  else if (Direction <> 0) then
  begin
    exit;
  end;

  Window(1,3,80,24);
  TextColor(White);
  TextBackground(blue);
  //  FillerScreen(' ');
  Window(1,1,80,25);


  lp := position + (24 - 3);
  if lp >= Strings.Count then
    lp := Strings.Count - 1;

  IsComment := False;
  for i := position to lp do
  begin
    gotoxy(1,i - position + 3);
    {if (Length(Strings[i]) > 0) and (Strings[i][1] = '-') then
     TextColor(White)
    else
     TextColor(DarkGray);}
    if not IsComment then
      TextColor(White);

    if (pos('{', Strings[i]) > 0) or (pos('//', Strings[i]) > 0) then
      isComment := True
    else if (pos('}', Strings[i]) > 0) then
      isComment := False;

    if IsComment then
      TextColor(DarkGray);


    Write(Strings[i]);

    if (pos('}', Strings[i]) > 0) or (pos('//', Strings[i]) > 0) then
      isComment := False;

    if WhereX < 79 then
    begin
      for i2 := WhereX to 80 do
        Write(' ');
      //Gotoxy(1,1);
    end;
  end;
  {wenn der letzte eintrag höher als die untere kante steht, muss gelöscht werden}
  if (lp - position + 3 < 24) then
  begin
    for i := lp - position + 4 to 24 do
    begin
      gotoxy(1,i);
      for i2 := 1 to 80 do
        Write(' ');
    end;
  end;
end;

procedure UpdateTitle(FileName: string);
begin
  TextColor(White);
  TextBackground(red);
  Window(1,1,80,2);
  clrscr;
  WriteLN('Pascal Parser Alpha');
  Write('Datei : ' + FileName);
end;

procedure UpdateStatusBar;
var 
  c: integer;
begin
  if Strings.Count < 19 then
    c := 20
  else
    c := Strings.Count;
  Window(1,25,80,25);
  TextBackground(Black);
  Writeln('ESC - Exit ' + #179 + ' Pfeiltasten hoch und runter zum scrollen     ' +
    #179 + ' ', (Position + 1): 5,' von ', (c - 19): 5);
end;

procedure SaveStream;
var 
  F: TFileStream;
begin
  f := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\data.dta',
    fmCreate or fmOpenWrite);

  aUnit.Store(F);

  F.Free;
end;

procedure LoadStream;
var 
  F: TFileStream;
begin
  f := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\data.dta', fmOpenRead);

  aUnit.free;
 { if not Assigned(aUnit) then}
  aUnit := TUnit.Create('',nil);
{  else
   aUnit.Clear;}
  aUnit.Load(F);

  ClearCount;
  WriteAll;
  UpdateAll;

  F.Free;
end;

procedure CreateParentFile;
var Strings : TStringList;
    parentsFile : String;

procedure WriteChilds(Parent : TBaseEntry);
procedure DoWrite;
var s  : String;
begin
  s := Format('%1:s[%0:s]',[Parent.ClassName,Parent.GetNamePathOfSelf]);
  Strings.Add(s);
end;
var ii : Integer;
begin
  if Parent is TContainerEntry then
  begin
    DoWrite;
    for ii := 0 to TContainerEntry(Parent).Items.Count -1 do
       WriteChilds(TContainerEntry(Parent).Items[ii])
  end
  else
  begin
    DoWrite;
  end;
end;

begin
  parentsFile := ExtractFileDir(ParamStr(0)) +'\parents.txt';
  Strings := TStringList.Create;

  WriteChilds(aUnit);
  Strings.SaveToFile(ParentsFile);
  Strings.Free;
end;

procedure HandleScreenOut;
var
  ch: char;
begin
  repeat
    ch := ReadKey;
    case ch of
      '&' {runter}: RewriteStrings(-1);
      '(' {hoch}: RewriteStrings(+1);
      '"':{runter} RewriteStrings(+10);
      '!':{runter} RewriteStrings(-10);
      '$': {pos1} RewriteStrings(-position);
      '#': {pos1} RewriteStrings(high(integer) div 2);
      'S': Strings.SaveToFile(ExtractFileDir(ParamStr(0)) + '\unit.txt');
      'A': SaveStream;
      'Q': LoadStream;
      'C':
        begin
          aUnit.Clear;
          FreeAndNil(aUnit);
          aUnit := TUnit.Create('',nil);
          WriteAll;
          UpdateAll;
        end;
      'E' : CreateParentFile;
    end;
    UpdateTitle(FileName);
    UpdateStatusBar;
  until ch = #27;
end;


procedure StartTimer;
begin
  Timer := GetTickCount;
end;


function GetConsoleWindow: THandle;
  {source: http://www.swissdelphicenter.ch/de/showcode.php?id=1205}
var
  S: AnsiString; 
  C: char; 
begin 
  Result := 0;
  Setlength(S, MAX_PATH + 1); 
  if GetConsoleTitle(PChar(S), MAX_PATH) <> 0 then 
  begin 
    C := S[1];
    S[1] := '$'; 
    SetConsoleTitle(PChar(S)); 
    Result := FindWindow(nil, PChar(S)); 
    S[1] := C; 
    SetConsoleTitle(PChar(S)); 
  end; 
end;

procedure StopTimer;
{var aend : TdateTime;
    h : Integer;}
begin
  // aend := now - Timer;
  { h := GetConsoleWindow;
  MessageBox(h,PCHAR(Format('%d Dateien mit der Zeit : %s%s',[ParamCount,#13#10,FormatDateTime('hh "Stunden" nn "Minuten" ss "Sekunden" zzz "Hunderstel"',aend)])),'text',0);
  SetForeGroundWindow(h);}
end;

procedure WriteAll;
begin
  Strings.Clear;

  if not Assigned(aUnit) then exit;

  WriteHeader;
  WriteItems(aUnit, ct_Function, FunctionsCount, 'Funktionen/Prozeduren');
  WriteItems(aUnit, ct_TypeFunction, TypesCount, 'FunktionsTypen');
  WriteItems(aUnit, ct_Type, TypesCount, 'Typen');
  WriteItems(aUnit, ct_Record, recCount, 'Strukturen');
  WriteItems(aUnit, ct_BaseVariable, varsCount, 'Variablen');
  WriteItems(aUnit, ct_Constant, constsCount, 'Konstanten');
  WriteClasses(aUnit);

  WriteEnd;
end;

procedure UpdateAll;
begin
  Window(1,3,79,24);
  TextColor(White);
  TextBackground(blue);
  clrscr;

  UpdateTitle(FileName);

  UpdateStatusBar;

  StartTimer;


  UpdateStatusBar;
  RewriteStrings(0);
end;

procedure ClearCount;
begin
  functionsCount := 0; 
  typesCount := 0; 
  varsCount := 0;
  constsCount := 0; 
  recCount := 0; 
  objectsCount := 0; 
  classesCount := 0; 
  interfacesCount := 0;
end;


function ScanUnit(aFileName: string): TUnit;
var 
  PS: TPascalStream;
  Scanner: TPascalScanner;
  Dest: TMEmoryStream;
  Path: TAStrings;
begin
  PS := TPascalStream.Create(aFileName, fmopenread);
  //PreParseUnit(PS);


  SetLength(Path, 1);
  Path[0] := ExtractFileDir(ParamStr(0));

  Scanner := TPascalScanner.Create(PS);
  Dest := TMEmoryStream.Create;

  try
    (*Scanner.IncludeParse(Scanner.Stream, Dest, Path);
    //    Scanner.Stream.Free;
    Scanner.Stream.Size := 0;
    Scanner.Stream.Copyfrom(Dest, 0);
    Scanner.Stream.Position := 0;*)
   if Parameters.IndexOf('-ni') < 0 then
    Scanner.IncludeParseStd(Path);
 {$IFDEF PREPROCESSING}
    if Parameters.IndexOf('-np') < 0 then
      Scanner.PreprocessingStd();
  {$ENDIF}


    Result := Scanner.DoScan;
   // result := nil;
    tokencount := Scanner.Stream.TokenReadCount;

  finally
    {FILO-Prinzip}
    Scanner.Free;
    PS.Free;
    Dest.Free;
  end;

 { TUnit(result).Free;
  halt;    }
end;

const test = newcrt.BW40;

var
  ii,c: integer;
  paramstart,paramend : Integer;
  s : String;
  d : TObject;
begin
  MemCheckLogFileName :=  ExtractFileDir(ParamStr(0)) + '\memleaks.txt';
 // MemChk;



  SetCursor(0);
  DirectVideo := True;
  TextColor(White);
  TextBackground(Black);
  clrscr;

  Strings := TStringList.Create;
  ClearCount;


  paramstart := 1;
  paramend := ParamCount;
  if (ParamCount = 1) and (FileExists(ParamStr(1))) then
  begin
    FileName := ParamStr(1);
    Inc(paramstart);
  end
  else
  begin
    FileName := ExtractFileDir(ParamStr(0)) +

//  FileName := 'F:\Projekte D7\SDK Help Maker 2\MainData.pas';
    '\testfile2.txt';
  // '\DocSpy_Unit.pas';
    //'\Kopie von IOClasses.pas';
// '\virtualtrees.pas';
// '\TestUnits\testfile3.txt';
  // '\testunits\pascalscanner.pas';
  // '\pascalscanner.pas';
  // '\\testunits\crt.pas';
  //'\TestUnits\DIUtils.pas';
  //  '\TestUnits\dtFiles.pas';
  //'\dtStream.pas';
  end;

  Parameters := TStringList.Create;
  Parameters.CaseSensitive := FALSE;
  Parameters.Sorted := TRUE;

  Parameters.Add(FileName);


  for ii := paramstart to paramend do
  begin
    s := ParamStr(ii);
    Parameters.Add(s);
  end;


  StartTimer;
  try
(*    if (ParamCount > 1) then
    begin
      for ii := 1 to Parameters.Count do
      begin
        FileName := ParamStr(ii);
       { if FileExists(FileName) then
          aUnit := ScanUnit(FileNAme);   }
      end;
    end
    else*)
      aUnit := ScanUnit(FileNAme);
  except
    on E: Exception do
    begin
      if MessageBox(0,PChar(e.Message), 'Error (Click Yes to copy error into error.log)',
        MB_YESNO or MB_ICONSTOP) = idYes then
      begin
        try
          AssignFile(f, ExtractFileDir(ParamStr(0)) + '\error.log');
          if not FileEXists(ExtractFileDir(ParamStr(0)) + '\error.log') then
            Rewrite(f)
          else
            Append(f);

          Writeln(f);
          Writeln(f, '***********************************************');
          Writeln(f, 'Error message:');
          Writeln(f, 'Generated on ' + DateTimeToStr(Now));
          Writeln(f, e.Message);
          Writeln(f, 'end message:');
          CloseFile(F);
        except
        end;
      end;
      //ShowException(ExceptObject,ExceptAddr);
      halt(1);
    end;
  end;
//  ASSERT(Assigned(aUnit), 'aUnit=nil?');


  StopTimer;

  WriteAll;
  UpdateAll;




  HandleScreenOut;

  Strings.Free;
  aUnit.Free;

  //readkey;
  {
  WriteEnd;
  Writeln('Bitte [Eingabe] druecken...');  }
  //UnMemChk;
end.

{IncludeParserProgramm und Interface
definiere INCPARSERPROGRAMM, um das Programm als Konsole auszuführen.

definiere  INCLUDEDEFINITIONS, um Typendefinition für die Procedure zu definieren.
definiere INCPARSERIMPLEMENTATION und lösche INCLUDEDEFINITIONS,um die procedure definieren zu können
}
{$IFDEF INCPARSERPROGRAMM}
program IncParser;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  SParser;

{$DEFINE INCLUDEDEFINITIONS}
{$DEFINE INCPARSERIMPLEMENTATION}
{$ENDIF}


{$IFDEF INCLUDEDEFINITIONS}
type
      //eine array liste von strings
      TAStrings = array of String;
      //Fehlerprocedure, wenn Includedatei nicht gefunden wurde,
      //Errornumber = 1 = IncludeDatei nicht gefunden
      //Source ist der Parameter Source an PreIncludeParse übergeben
      // Source.FileName der Dateiname wo der Fehler auftrat, Source.Position die Position wo die fehlerhafte Position ist
      // Source.FileName funktioniert nur mit der überladenen Version von Create oder wenn es definiert wurde
      TIncludeErrorProc = procedure(ErrorNumber : Cardinal; Source : TTextStream;var halt : boolean) of object;
{$ENDIF}



{Sucht nach Include Anweisungen in einem Pascalquelltext, auch in den Include Dateien selber,
die Verschachtelungseben ist unendlich.
Source ist der zu analysierende Pascalquelltext, Dest der Zielstream.
IncludePaths ist eine Liste von Verzeichnissen, in denen nach Includedateien gesucht werden kann, wenn diese nicht genau definiert wurden.
ErrorProc wird bei Fehlern aufgerufen.
}


{$IFDEF INCPARSERIMPLEMENTATION}

function ResolveRelativePaths(const Current: String; const Relative: String): String;

  function SplitString(const Str: String; Lines: TStrings): Integer;
  const
    Split = [#0, '/'];
  var
    pc, bpc: PChar;
    l, x: Integer;
    s: String;
  begin
    Result := 0;
    if Str <> '' then begin
      l := Length(Str);
      pc := @Str[1];
      bpc := nil;
      x := 0;
      repeat
        if pc^ in Split then begin
          if x > 0 then begin
            if Assigned(bpc) then begin
              SetLength(s, x);
              Move(bpc^, s[1], x);
              Lines.Add(s);
              Inc(Result);
              bpc := nil;
            end;
            x := 0;
          end;
        end else begin
          if not Assigned(bpc) then begin
            bpc := pc;
          end;
          Inc(x);
        end;
        Inc(pc);
        Dec(l);
      until l <= 0;
      if x > 0 then begin
        if Assigned(bpc) then begin
          SetLength(s, x);
          Move(bpc^, s[1], x);
          Lines.Add(s);
          Inc(Result);
        end;
      end;
    end;
  end;

var
  cur, dirs, res: TStrings;
  d: String;
  x, y: Integer;
begin
  Result := '';
  if (Current <> '') and (Relative <> '') then begin
    dirs := TStringList.Create;
    cur := TStringList.Create;
    res  := TStringList.Create;
    SplitString(Relative, dirs);
    SplitString(Current, cur);
    y := 0;
    for x := 0 to dirs.Count - 1 do begin
      d := dirs.Strings[x];
      if d = '.' then begin
        if x = 0 then begin
          res.AddStrings(cur);
          cur.Clear;
        end else begin
          res.Clear;
          Break;
        end;
      end else if d = '..' then begin
        if res.Count > 1 then begin
          res.Delete(res.Count - 1);
        end else begin
          res.Clear;
          Break;
        end;
      end else begin
        res.Add(dirs.Strings[x]);
      end;
    end;
    dirs.Free;
    cur.Free;
    for x := 0 to res.Count - 1 do begin
      Result := Result + res.Strings[x] + '';
    end;
    res.Free;
  end;
end;



function PreIncludeParse(Source: TTextStream; Dest: TStream; IncludePaths : TAStrings; ErrorProc : TIncludeErrorProc = nil) : Cardinal;

var Includes : Integer; //Anzahl der geparsten Includes

 {Lädt eine Includedatei und analysiert auch diese}
 procedure IncludeFile(Const FileName: String; Dest : TStream);
 var anIncludeFile : TTextStream;
     Src : TTextStream;
 begin
   anIncludeFile := TTextStream.Create(FileName,fmOpenRead);
   Inc(Includes,PreIncludeParse(anIncludeFile,Dest,IncludePaths,ErrorProc));
   anIncludeFile.Free;
 end;

 function GetIncludeFile(Const FileName: String; IncludePaths : TAStrings) : String;
 var ii :IntegeR;
     name : String;
 begin
    if Length(ExtractFilePath(FileNAme)) > 1 then
   begin
     {es gibt auch \..\bla.pas für das vorherige verzeichnis
      \bla.pas für das aktuelle verzeichnis
     wird nicht unterstützt
     }
     if LEngth(IncludePaths) > 0 then
      result := ResolveRelativePaths(IncludePaths[0],FileName)
     else
      result := FileName;
   end
   else
   begin
    for ii := 0 to Length(IncludePaths) -1 do
    begin
      name := IncludePaths[ii];
      if Name[Length(name)] <> '\' then
       Name := Name + '\';

      Name := Name + FileName;
      if FileExists(Name) then
      begin
        //gefunden
        result := Name;
        exit;
      end;
    end;
     //nichts gefunden
   end;

 end;


var c : Char;
    Token : String;

    IncludeName : String;
    SrcPos,  //Quellcodeposition
    LastPos, //letzte position zum kopieren
    DummyPos : Int64;
    doHalt : Boolean;

const //End-Bedingung
      sImplementation = 'IMPLEMENTATION';
      sExports = 'EXPORTS';
      snclude = 'nclude';

begin
  Includes := 0;
  LastPos := 0;
  doHalt := FALSE;
  repeat
    c := Source.GetNextChar;
    if (c = '{') or ((c = '(') and (Source.GetNextChar(FALSE) = '*')) then //es handelt sich um { oder (*
    begin
      SrcPos := Source.Position-1; //gespeicherte position vor den kommentar setzen
      if (c = '(') then
      begin
        Dec(SrcPos);
        Source.GetNextChar;
      end;
      Token := Source.GetNextChars(2);

      if (CompareText(Token,'$I') = 0) and not (Source.GetNextChar(FALSE) in ['+','-']) then
      begin
        {es kann sich auch um $INCLUDE handeln}
        if CompareText(Source.GetNextChars(Length(snclude),0,FALSE),snclude) = 0 then
         Source.GetNextChars(Length(snclude));


        {Position im Kommentar speichern, um sie nachher für weitere verwendenung wiederherzustellen}
        DummyPos := Source.Position;

        {kopiert von dem letzen Include-Kommentar in Source bis zum jetzigen, alles an die aktuelle Position in Dest}
        Source.Position := LastPos;
        Dest.CopyFrom(Source,SrcPos);

        Source.Position := DummyPos;

        Source.GetNextChar; //Leerzeichen

        if Source.GetNextChar(FALSE) in ['''','"'] then
         Source.GetNextChar;

        {Lädt den Dateinamen}
        IncludeName := '';
        repeat
          c := Source.GetNextChar;
          if c in ['}','*','''','"'] then
          begin
            break
          end
          else
            IncludeName := IncludeName + c;
        until FALSE;

         //Wenn es sich um *) handelt, wird auch die Klammer gelesen - eigentlich nicht nötig ?
        if c in ['''','"','*'] then
        begin
          repeat
            c := Source.GetNextChar;
            if c in ['}',')'] then
              break
          until FALSE;
        end;

        //Die letzte Position hinter dem Include-Kommentar und nach dem Zeilenumbruch (+2)
        LastPos := Source.Position+2;

        //Lädt
        IncludeName := GetIncludeFile(IncludeName,IncludePaths);
        if FileExists(IncludeName) then
        begin
          IncludeFile(IncludeName,Dest);
          LastPos := Source.Position+2;
          Inc(Includes);
        end
        else
        begin
          if Assigned(ErrorProc) then
          begin
            ErrorProc(1,Source,doHalt);
            if doHalt then exit;
          end
          else
            raise Exception.Create('"'+IncludeName+'" not found."');
        end;
      end;
    end
    else
    begin
      if Source.Position = Source.Size then  //abbrechen wenn das ende der datei erreicht wurde
        break;

      //abbrechen wenn implementation oder exports erreicht wurde, dass nicht in einem kommentar steckt
      Token := Uppercase(c+Source.GetNextChars(Length(sImplementation),0,FALSE));
      if (pos(sImplementation,Token) > 0) or (pos(sExports,Token) > 0) then
      begin
        break;
      end;
    end;

  until FALSE;

  {die letzten Bytes im Stream source nach dest kopieren,
  wenn nicht schon am ende angelangt
  }
  Source.Position := LastPos;
  if Source.Size > LastPos then
   Dest.CopyFrom(Source,Source.Size - LastPos);

  result := Includes;
end;
{$ENDIF}





// Hauptprogramm 
{$IFDEF INCPARSERPROGRAMM}
var InStream : TTextStream;
    OutStream : TFileStream;
    NewName,OpenName : String;
    P:String;
    Includes : Integer;
    Paths : TAStrings;
begin
  GetDir(0,P);
  { TODO -oUser -cConsole Main : Insert code here }

  {OpenName ist die Eingabe-Datei}
  OpenName := ParamStr(1);

  OpenName := 'F:\Projekte D7\PascalParser\IncludeParser\test.pas';
 // OpenName := p+'\compilerdirektiven.pas';

  {NewName ist die AusgabeDatei}
  NewName := ExtractFileDir(OpenName)+'\Output.pas';

  //InStream - Eingabestream zum Lesen, dieses Create gibt es nur bei TTextStream, nicht bei TMemoryStream
  InStream := TTextStream.Create(OpenName,fmOpenRead);

  //OutStream - Ausgabestream zum schreiben
  OutStream := TFileStream.Create(NewName,fmCreate or fmOpenWrite);

  try
   SetLength(Paths,1);
   Paths[0] := 'F:\Projekte D7\PascalParser\IncludeParser';


   Includes := PreIncludeParse(InStream,OutStream, Paths);
  except
   OutStream.Size := 0;
  end;

  //Von InStream alles nach OutStream kopieren zum schreiben
//  OutStream.CopyFrom(InStream,0);

  OutStream.Free;
  InStream.Free;
  Write('parsed : '+IntToStr(Includes)+' include(s)');
  Readln;
end.

{$ENDIF}

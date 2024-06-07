program Preprozessor;
{.$DEFINE RELEASE}

{$IFDEF RELEASE}
{$C-,D-,F-,Y-,L-}
{$ENDIF}

{$APPTYPE CONSOLE}

uses
  Preprocessor,

SysUtils,
  Classes,
  Windows,
  IOClasses,
  PascalScanner,
{$IFNDEF PROFILE}  PasStream;{$ENDIF}
{$IFDEF PROFILE} { Do NOT Delete ProfOnli !!! } {$ENDIF}
{$IFDEF PROFILE}  PasStream ,Profonli ,Profint;{$ENDIF}






var F,O : TPascalStream;

    s : String;
    OutPutFile : string;
    Warnings,Directives,Definitions : TStringList;
const  //fmCreate : word        = $FFFF;
       ui : Char = 'a';


begin
(*  writeln(CompareStr('2','1.9'));
  readln;
  exit;*)

  outputfile := ExtractFilePath(ParamStr(0))+'output.txt';
{$IFDEF RELEASE}
  if not FileExists(ParamStr(1)) then
  begin
    writeln('error : add a pascal file to parameterlist');
    readln;
    exit;
  end;

    F := TPascalStream.Create(ParamStr(1),fmOpenRead);
{$ELSE}
  F := TPascalStream.Create(ExtractFilePath(ParamStr(0))+'input.pas',fmOpenRead);
{$ENDIF}


  O := TPascalStream.Create;

 // O.Write(ui,SizeOf(ui));

  Directives := TStringList.Create;  //Compilerschalter etc
  Directives.Add('CLX');
  Definitions := TStringList.Create; //konstanten ausdrücke
//  Definitions.Add('LibVersion=3.9');

{$IFDEF RELEASE}
  if FileExists(ExtractFilePath(ParamStr(0))+'directives.txt') then
   Directives.LoadFromFile(ExtractFilePath(ParamStr(0))+'directives.txt');
{$ENDIF}

  Warnings := TStringList.Create;
  Preprocessing(nil,F,O,Directives,Definitions,Warnings,0);

  if Warnings.Count > 0 then
  begin
    MessageBox(0,PCHAR(Format('%d warnings : %s',[Warnings.Count,Warnings.Text])),'Warnings occured',mb_ok);

    //Readln;
  end;


  O.SavetoFile(OutputFile);

  O.Free;
  F.Free;
end.

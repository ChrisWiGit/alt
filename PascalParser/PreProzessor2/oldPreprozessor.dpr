


program Preprozessor;
{.$DEFINE RELEASE}

{$IFDEF RELEASE}
{$C-,D-,F-,Y-,L-}
{$ENDIF}

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  IOClasses,
  PascalScanner,
{$IFNDEF PROFILE}  PasStream;{$ENDIF}
{$IFDEF PROFILE} { Do NOT Delete ProfOnli !!! } {$ENDIF}
{$IFDEF PROFILE}  PasStream ,Profonli ,Profint;{$ENDIF}

type TPreProcessorType = (ppt_none,ppt_IFDEF,ppt_IFNDEF,ppt_ELSE,ppt_ENDIF,ppt_IF,ppt_IFEND,ppt_ELSEIF,ppt_DEFINE,ppt_UNDEF);

var  PreStrings : Array[ppt_none..ppt_UNDEF] of String =
                ('','IFDEF','IFNDEF','ELSE','ENDIF','IF','IFEND','ELSEIF','DEFINE','UNDEF');



function GetNextPreProcessorString(InputStream : TPascalStream; out Position : Int64; out pType : TPreProcessorType; out Definition : String) : String;
var Token,s : String;
   // prevPos : Int64;
    p : Integer;
    i : TPreProcessorType;
begin
  repeat
    if InputStream.EOF then
     break
    else
    begin
      //prevpos kann auch vor einem kommentar sein, der vor dem token kommt

      Token := Inputstream.ReadToken(FALSE,[rc_comment]);
      if (InputStream.TokenType = [st_Word]) and (CompareText(Token,'implementation') = 0) then
      begin
        result := Token;
        Position := Inputstream.TokenPosition;
        Definition := '';
        pType := ppt_none;
        exit;
      end;
    end;
  until (InputStream.EOF) or (st_PreProzessor in Inputstream.TokenType);
        

  if InputStream.EOF then
    Position := -1
  else
    Position := Inputstream.TokenPosition;

  if (st_PreProzessor in Inputstream.TokenType) then
  begin
   // Position := PrevPos;
    Delete(Token,1,2);
    Delete(Token,Length(Token),1);
    p := pos(' ',Token);
    if p = 0 then
    begin
      p := Length(Token);
      Definition := '';
      s := Token;
    end
    else
    begin
      Definition := Copy(Token,p+1,Length(Token));
      s := Copy(Token,1,p-1);
    end;

    result := Token;


    for i := low(PreStrings) to high(PreStrings) do
    begin
      if (CompareText(s,PreStrings[i]) = 0) and (i <> ppt_none) then
      begin
        PType := i;
        break;
      end;
    end;

  end;
end;


(*
{$IF Defined(CLX) and (LibVersion > 2.0) }
  procedure CLXLib(alib : shortstring);
{$ELSE}
{$IFEND}

*)

function IsDirectiveActive(Directives : TStringlist; Directive : String) : Boolean;
var ii : Integer;
begin
  result := Directives.IndexOf(Directive) >= 0;
end;

procedure CopyFrom(InputStream,OutPutStream : TPascalStream; Start,Ending : Int64; CopyAll : boolean = FALSE);
var currPos : Int64;
begin
  if ((Ending-Start) = 0) and not CopyAll then exit;
  currPos := InputStream.Position;
  InputStream.Position := Start;
  OutPutStream.CopyFrom(InputStream,(Ending-Start));
  InputStream.Position := currPos;
end;


type TIsDeclarefnc = function (Parameter : String; Directives : TStringList) : boolean;
     TDeclarations = record
       Name : ShortString;
       DeclareFnc : TIsDeclarefnc;
     end;


function IsDeclared(Parameter : String; Directives : TStringList) : boolean;
begin
  result := IsDirectiveActive(Directives,Uppercase(Parameter));
end;

const FncDeclaration : array[1..2]of TDeclarations =
      ((Name:'DECLARED';
        DeclareFnc : IsDeclared),
       (Name:'DEFINED';
        DeclareFnc : IsDeclared)
      );

function GetDeclaration(Name : ShortString) : TDeclarations;
var i : Integer;
begin
  Fillchar(result,sizeof(result),0);
  for i := low(FncDeclaration) to high(FncDeclaration) do
  begin
    if CompareText(Name,FncDeclaration[i].Name) = 0 then
    begin
      result := FncDeclaration[i];
      exit;
    end;
  end;
end;


function IsDefinitionsDefined(definition : String;Definitions,Directives : TStringList) : boolean;
var Temp : TPascalStream;
    token,token2 : string;
    brackets : integer;

    adec : TDeclarations;

    defined : array of boolean;
    idefined : Integer;
    op,def,value : String;
begin
  Temp := TPascalStream.Create(definition);

  brackets := 0;
  idefined := 0;

  while not temp.EOF do
  begin
    token := Temp.ReadToken(FALSE,[]);
    if token = '(' then
    begin
      Inc(brackets);
      token := Temp.ReadToken(FALSE,[]);
    end;

    adec := GetDeclaration(Token);
    if (@adec.DeclareFnc <> nil) then
    begin
      token := Temp.ReadToken(FALSE,[]); // (
      token := Temp.ReadToken(FALSE,[]);

      Inc(idefined);
      SetLength(defined,idefined);

      defined[idefined-1] := adec.DeclareFnc(token,Directives);

      token := Temp.ReadToken(FALSE,[]); // )
    end
    else
    if CompareText(token,'AND') = 0 then
    begin
    end
    else
    if token[1] in ['=','>','<'] then
    begin
      op := Copy(Token,1,1);
      token2 := Temp.ReadToken(FALSE,[]);
      if (token2[1] in ['=','>','<']) then
       Op := op + token[1]
      else
        value := token2; 
    end
    else
    if Temp.TokenType = [st_number] then
    begin
      value := Token;
    end
    else
    if Temp.TokenType = [st_string] then
    begin
      value := Token;
    end
    else
    if Temp.TokenType = [st_word] then

     def := token
    else
    if brackets > 0  then
    begin
      Dec(brackets);
      token := Temp.ReadToken(FALSE,[]); //)
    end;

    if (length(value) > 0) and (length(def) > 0) then
    begin

      exit;
    end;
  end;
  Temp.Free;
end;

{useoutput, dürfen daten in outputstream geschrieben werden
}
function Preprocessing(InputStream,OutPutStream : TPascalStream; Directives,Definitions : TStringlist; DefinitionsNesting : Integer; UseOutput : boolean = TRUE) : Integer;
var Token : String;
    Position,StartPosition,ElsePosition,currPos : Int64;
    pType : TPreProcessorType;
    Definition : String;
    IsDefined : Boolean;
    Defines : Integer;
begin
//  Inputstream.Position := 0;


  Directives.Duplicates := dupIgnore;
  Directives.CaseSensitive := FALSE;
  Directives.Sort;

  Defines := 0;

  StartPosition := InputStream.Position;

  while not Inputstream.EOF do
  begin
    Token := GetNextPreProcessorString(InputStream,Position,pType,Definition);
    if ptype = ppt_none then break;

    case ptype of
      ppt_DEFINE :  begin
                      currPos := InputStream.Position;
                      CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                      StartPosition := currPos;


                      Directives.Add(Uppercase(definition));
                    end;

      ppt_UNDEF  : begin
                     currPos := InputStream.Position;
                     CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                     StartPosition := currPos;

                     if IsDirectiveActive(Directives,Definition) then
                        Directives.Delete(Directives.IndexOf(Definition));
                   end;
      ppt_IF,ppt_ELSEIF,ppt_IFDEF,ppt_IFNDEF  :  begin

                      if Defines > 0 then
                      begin
                        InputStream.Position := Position;
                        Preprocessing(InputStream,OutPutStream,Directives,Definitions,Defines,UseOutput);
                        StartPosition := InputStream.Position;
                      end
                      else
                      begin
                        if ptype in [ppt_IF,ppt_ELSEIF] then
                        begin
                          IsDefined := IsDefinitionsDefined(Definition,Definitions,Directives);
                        end
                        else
                        begin
                          IsDefined := IsDirectiveActive(Directives,Definition);
                          if ptype = ppt_IFNDEF then
                            IsDefined := not IsDefined;
                        end;

                        Inc(Defines);

                        currPos := InputStream.Position;
                        CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                        StartPosition := currPos;

                        if IsDefined then
                        begin
                          StartPosition := InputStream.Position;
                        end
                        else
                        begin
                          StartPosition := -1;// Position;
                        end;
                      end;
                    end;
      ppt_ELSE :  begin
                    if IsDefined then
                    begin
                      currPos := InputStream.Position;
                      CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                      StartPosition := currPos;
                    end
                    else
                    begin
                      StartPosition := InputStream.Position;
                    end;
                     IsDefined := not IsDefined;
                  end;
      ppt_ENDIF : begin
                    Dec(Defines);
                    if not IsDefined then
                    begin
                      StartPosition := InputStream.Position;
                    end
                    else
                    begin
                      currPos := InputStream.Position;
                      CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                      StartPosition := currPos;   
                    end;
                    if (DefinitionsNesting > 0) and (Defines <= 0) then
                     exit; 
                  end;
    end;
  end;
  if (DefinitionsNesting <= 0) then
   CopyFrom(InputStream,OutPutStream,StartPosition,Inputstream.Size);
end;



var F,O : TPascalStream;

    s : String;
    OutPutFile : string;
    Directives,Definitions : TStringList;
const  //fmCreate : word        = $FFFF;
       ui : Char = 'a';


begin
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
  Definitions := TStringList.Create; //konstanten ausdrücke
{$IFDEF RELEASE}
  if FileExists(ExtractFilePath(ParamStr(0))+'directives.txt') then
   Directives.LoadFromFile(ExtractFilePath(ParamStr(0))+'directives.txt');
{$ENDIF}


  Preprocessing(F,O,Directives,Definitions,0);

  O.SavetoFile(OutputFile);

  O.Free;
  F.Free;
end.

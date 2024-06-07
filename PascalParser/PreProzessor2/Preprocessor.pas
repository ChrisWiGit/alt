unit Preprocessor;

interface
{$IFNDEF PROFILE}uses PasStream,Classes;{$ENDIF}
{$IFDEF PROFILE}uses PasStream,Classes ,Profint;{$ENDIF}

type TPreProcessorType = (ppt_none,ppt_IFDEF,ppt_IFNDEF,ppt_ELSE,ppt_ENDIF,ppt_IF,ppt_IFEND,ppt_ELSEIF,ppt_DEFINE,ppt_UNDEF);
     TOnProcessing = procedure (Position : int64) of object;

var  PreStrings : Array[ppt_none..ppt_UNDEF] of String =
                ('','IFDEF','IFNDEF','ELSE','ENDIF','IF','IFEND','ELSEIF','DEFINE','UNDEF');

    //CompilerStatements in diesem array werden nicht interpretiert und im quelltext belassen - keine groß-kleinschreibung
     IgnoreStatements : array[1..2] of String =
               ('I','INCLUDE');

     //beinhaltet Bezeichner die das ende des Deklarationsabschnittes bezeichnen - keine groß-kleinschreibung
     SourceSectionBegin : String = (',implementation,exports');

     //%name% gibt an, ob der quelltext nach implementation
     AppendSourceSection : Boolean = FALSE;

     //left fest, ob Umbrüche erhalten bleiben sollen (TRUE) oder nicht.
     MaintainBreaks : boolean = FALSE;

     IgnoreSourceDefines : Boolean = FALSE;
     IgnoreSourceConstants : Boolean = FALSE;

const Breaks = [#13,#10];

var IsConst : boolean = FALSE;

function Preprocessing(OnProcessing : TOnProcessing; InputStream,OutPutStream : TPascalStream; Directives, Definitions, Warnings : TStringlist; DefinitionsNesting : Integer = 0) : Integer;



implementation
uses
  SysUtils,
  Windows,
  IOClasses,
  PascalScanner;


function IsDeclared(Parameter : String; Directives : TStringList) : boolean;                                                                                                        forward;

type TIsDeclarefnc = function (Parameter : String; Directives : TStringList) : boolean;
     TDeclarations = record
       Name : ShortString;
       DeclareFnc : TIsDeclarefnc;
     end;


const FncDeclaration : array[1..2]of TDeclarations =
      ((Name:'DECLARED';
        DeclareFnc : IsDeclared),
       (Name:'DEFINED';
        DeclareFnc : IsDeclared)
      );



//--------------
function GetNextPreProcessorString(InputStream : TPascalStream; out Position : Int64; out pType : TPreProcessorType; out Definition : String; Definitions : TStringList ) : String; forward;
function IsDirectiveActive(Directives : TStringlist; Directive : String) : Boolean;                                                                                                 forward;
procedure CopyFrom(InputStream,OutPutStream : TPascalStream; Start,Ending : Int64; CopyAll : boolean = FALSE);                                                                      forward;

function ComputeExpression(Declaration,Value,Operand : String; Declarations,Warnings : TStringList; InputStream : TPascalStream) : Boolean;                                         forward;
function GetDeclaration(Name : ShortString) : TDeclarations;                                                                                                                        forward;
function IsDefinitionsDefined(definition : String;Definitions,Directives : TStringList;Warnings : TStringList;InputStream : TPascalStream) : boolean;                               forward;
function AddBreaks(InputStream,OutPutStream: TPascalStream; StartPos,EndPos : Int64) : Integer;                                                                                     forward;




function GetNextPreProcessorString(InputStream : TPascalStream; out Position : Int64; out pType : TPreProcessorType; out Definition : String; Definitions : TStringList ) : String;
var Token,s : String;
    Tokens : array[1..4] of string;
   // prevPos : Int64;
    p,ii : Integer;
    i : TPreProcessorType;
//    IsConst : Boolean;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,779; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  IsConst := FALSE;
  repeat
    if InputStream.EOF then
     break
    else
    begin
      Token := Inputstream.ReadToken(FALSE,[rc_comment]);

      if (InputStream.TokenType = [st_Word]) and
       ((pos(token,SourceSectionBegin) > 0) and
       (SourceSectionBegin[pos(token,SourceSectionBegin)-1] = ','))
//       (Token = 'implementation') 
      then
      begin
        result := Token;
        Position := Inputstream.TokenPosition;
        Definition := '';
        pType := ppt_none;
        exit;
      end
      else
      if not IgnoreSourceConstants and (InputStream.TokenType = [st_Word])  then
      begin
        if not IgnoreSourceConstants and (CompareText(Token,'const') = 0) then
        begin
          IsConst := TRUE;
        end
        else
        if IsConst then
        begin
          if (StringtoPascalWord(Token) in
          [pw_exports,pw_interface,pw_type, pw_const, pw_var, pw_out, //Deklarationsart
           pw_resourcestring, pw_procedure, pw_function, pw_constructor, pw_destructor, //Funktion
           pw_register, pw_pascal, pw_forward, pw_cdecl,   pw_deprecated, pw_popstack, pw_stdcall, pw_overload, pw_near, pw_far,
           pw_safecall, pw_external, pw_varargs, pw_export, //Aufrufkonventionen
           pw_set, pw_array, pw_of, pw_case, pw_interfaceClass, pw_dispinterface,       //Interface konventionen
           pw_class, pw_object, pw_record, pw_packed, pw_begin, pw_end,pw_property, pw_private, pw_protected, pw_public,  pw_published, pw_read, pw_write, pw_index, pw_stored, pw_default,
           pw_override, pw_virtual, pw_reintroduce, pw_abstract,pw_dynamic, pw_dispid, pw_message
          ]) then
          begin
            IsConst := FALSE;
            continue;
          end;
          Tokens[1] := Token;
          //Inputstream.ReadToken(FALSE,[]); //name
          Tokens[2] := Inputstream.ReadToken(FALSE,[]); //=
          if Tokens[2] = '=' then
          begin
            repeat
              Tokens[4] := Inputstream.ReadToken(FALSE,[]); //Value
              if Tokens[4] <> ';' then
                Tokens[3] := Tokens[3] + Tokens[4];
            until Tokens[4] = ';';

            //fügt konstante hinzu wenn nicht existent, sonst wird die alte verändert
        //!!!    operation für sortierte listen nicht erlaubt??
            if Definitions.IndexOfName(Tokens[1]) >= 0 then
            begin
              if Definitions.Sorted then
              begin
                //Definitions.ValueFromIndex[Definitions.IndexOfName(Tokens[1])] := Tokens[3]
                ii := Definitions.IndexOfName(Tokens[1]);
                Definitions.Delete(ii);
                Definitions.Add(Tokens[1]+'='+Tokens[3]);
              end
              else
                Definitions.ValueFromIndex[Definitions.IndexOfName(Tokens[1])] := Tokens[3]
            end
            else
              Definitions.Add(Tokens[1]+'='+Tokens[3]);
          end
          else
          if Tokens[2] = ':' then
          begin
            repeat
              Tokens[4] := Inputstream.ReadToken(FALSE,[]); //Value
            until Tokens[4] = ';';
          end;
        end
        else
         IsConst := FALSE;
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

    Token := StringReplace(Token,#13,' ',[rfReplaceAll]);
    Token := StringReplace(Token,#10,'',[rfReplaceAll]);

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
      Definition := StringReplace(Definition,#10,'',[rfReplaceAll]);
      Definition := StringReplace(Definition,' ','',[rfReplaceAll]);
      s := Copy(Token,1,p-1);
    end;

    result := Token;

    PType := ppt_none;
    for i := low(PreStrings) to high(PreStrings) do
    begin
      if (CompareText(s,PreStrings[i]) = 0) and (i <> ppt_none) then
      begin
        PType := i;
        break;
      end;
    end;

  end;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,779; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;


(*
{$IF Defined(CLX) and (LibVersion > 2.0) }
  procedure CLXLib(alib : shortstring);
{$ELSE}
{$IFEND}

*)

//function

function IsDirectiveActive(Directives : TStringlist; Directive : String) : Boolean;
var ii : Integer;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,780; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  result := Directives.IndexOf(Directive) >= 0;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,780; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;


procedure CopyFrom(InputStream,OutPutStream : TPascalStream; Start,Ending : Int64; CopyAll : boolean = FALSE);
var currPos : Int64;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,781; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  if ((Ending-Start) = 0) and not CopyAll then exit;
  currPos := InputStream.Position;
  InputStream.Position := Start;
  OutPutStream.CopyFrom(InputStream,(Ending-Start));
  InputStream.Position := currPos;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,781; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;



function IsDeclared(Parameter : String; Directives : TStringList) : boolean;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,782; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  result := IsDirectiveActive(Directives,Uppercase(Parameter));
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,782; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;



{Berechnet einen Ausdruck mit dem Ausdrucks dem Vergleichsoperand und dem Vergleichswert
sowie die Definitionsliste für den Declarationsvergleich.
}

function ComputeExpression(Declaration,Value,Operand : String; Declarations,Warnings : TStringList; InputStream : TPascalStream) : Boolean;

function GetValueFromList(const Cmp : String; out Error : Boolean) : String;
var ii : Integer;
begin
  Error := FALSE;
  begin
    //result := StrToInt(Declaration);
    //Declarations.

    Declarations.CaseSensitive := FALSE;
    ii := Declarations.IndexOfName(Cmp);
    if ii < 0 then
    begin
      result := '';
      Error := TRUE;
      exit;
    end
    else
     result := Declarations.ValueFromIndex[ii];
  end;
end;


function GetValue(const Cmp : String; out Error : Boolean) : Extended;
var ii : Integer;

begin
  Error := FALSE;
  DecimalSeparator := '.';
  try
    result := StrToFloat(Cmp)
  except
    Declarations.CaseSensitive := FALSE;
    ii := Declarations.IndexOf(Cmp);
    if ii < 0 then
    begin
      result := 0;
      Error := TRUE;
      exit;
    end;
  end;
end;

const DefaultExpression : Boolean = FALSE;

function GetResult(Expression : String; err : Boolean) : Boolean;

begin
  if err then
   begin
     if Warnings <> nil then
       Warnings.Add(Format('Preprocessor: Unknown constant "%s" or not a constant in preprocessor at line %d - Expression will be assumed as %s',
           [Expression,InputStream.ReadLineNumber,BoolToStr(DefaultExpression,TRUE)]));
     result := DefaultExpression;
    exit;
  end
  else
   result := not DefaultExpression;
end;

var CmpI1,CmpI2 : Extended;
    ii : Integer;
    e : Boolean;
    CmpS1,CmpS2 : String;
    IsStr1,IsStr2 : Boolean;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,786; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  if Declaration[1] = '''' then //String
  begin
    CmpS1 := Declaration;
    IsStr1 := TRUE;
  end
  else
  if Declaration[1] in ['1'..'9','0','+','-'] then //zahl
  begin
    CmpI1 := GetValue(Declaration,e);
    IsStr1 := FALSE;
  end
  else
  begin
    IsStr1 := TRUE;
    try
      CmpS1 := GetValueFromList(Declaration,e); //liste
    except
      result := GetResult(CmpS1,e);
      if result = DefaultExpression then exit;
    end;

    if (Length(Cmps1) > 0) and (CmpS1[1] in ['1'..'9','0','+','-']) then //zahl
    begin
      CmpI1 := GetValue(CmpS1,e);
      result := GetResult(CmpS1,e);
      if result = DefaultExpression then exit;
      CmpS1 := '';
      IsStr1 := FALSE;
    end;
  end;

  result := GetResult(Declaration,e);
  if result = DefaultExpression then exit;

  if Value[1] = '''' then //String
  begin
    CmpS2 := Value;
    IsStr2 := TRUE;
  end
  else
  if Value[1] in ['1'..'9','0','+','-'] then //zahl
  begin
    CmpI2 := GetValue(Value,e);
    IsStr2 := FALSE;
  end
  else
  begin
    IsStr2 := TRUE;
    CmpS2 := GetValueFromList(Declaration,e); //liste
    if (Length(Cmps1) > 0) and (CmpS2[1] in ['1'..'9','0','+','-']) then //zahl
    begin
      CmpI2 := GetValue(CmpS2,e);

      result := GetResult(CmpS2,e);
      if result = DefaultExpression then exit;

      CmpS2 := '';
      IsStr2 := FALSE;
    end;
  end;

  result := GetResult(Declaration,e);
  if result = DefaultExpression then exit;

  if (IsStr1 <> IsStr2) then
  begin
    if not IsStr1 then
      CmpS1 := FloatToStr(CmpI1);

    if not IsStr2 then
      CmpS2 := FloatToStr(CmpI2);


    if Warnings <> nil then
       Warnings.Add(
Format('Preprocessor: Cannot compare constant expression %s with %s in preprocessor at line %d - Expression will be assumed as %s',
           [CmpS1,CmpS2,InputStream.ReadLineNumber,BoolToStr(DefaultExpression,TRUE)]));

    result := DefaultExpression;
    exit;
  end;

  if (Length(CmpS1)> 0) and (Length(CmpS2) > 0) then //String
  begin
    if Operand = '=' then
      result := CompareStr(CmpS1,CmpS2) = 0
    else
    if Operand = '>' then
      result := CompareStr(CmpS1,CmpS2) > 0
    else
    if Operand = '<' then
      result := CompareStr(CmpS1,CmpS2) < 0
    else
    if Operand = '>=' then
      result := CompareStr(CmpS1,CmpS2) >= 0
    else
    if Operand = '<=' then
      result := CompareStr(CmpS1,CmpS2) <= 0
    else
    if Operand = '<>' then
      result := CompareStr(CmpS1,CmpS2) <> 0;
  end
  else
  begin
    if Operand = '=' then
      result := CmpI1 = CmpI2
    else
    if Operand = '>' then
      result := CmpI1 > CmpI2
    else
    if Operand = '<' then
      result := CmpI1 < CmpI2
    else
    if Operand = '>=' then
      result := CmpI1 >= CmpI2
    else
    if Operand = '<=' then
      result := CmpI1 <= CmpI2
    else
    if Operand = '<>' then
      result := CmpI1 <> CmpI2
  end;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,786; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;




function GetDeclaration(Name : ShortString) : TDeclarations;
var i : Integer;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,787; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  Fillchar(result,sizeof(result),0);
  for i := low(FncDeclaration) to high(FncDeclaration) do
  begin
    if CompareText(Name,FncDeclaration[i].Name) = 0 then
    begin
      result := FncDeclaration[i];
      exit;
    end;
  end;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,787; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;



function IsDefinitionsDefined(definition : String;Definitions,Directives : TStringList;Warnings : TStringList;InputStream : TPascalStream) : boolean;
var Temp : TPascalStream;
    token,token2 : string;
    brackets : integer;

    adec : TDeclarations;

    defined : array of boolean;
    idefined : Integer;
    op,def,value : String;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,788; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
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
      result := ComputeExpression(def,value,op,Definitions,Warnings,InputStream);
      exit;
    end;
  end;
  Temp.Free;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,788; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;

{ließt die zeilenumbrüche aus inputstream zwischen start- und endpos
und fügt diese in outputstream ein, sowie gibt die anzahl zurück
}


function AddBreaks(InputStream,OutPutStream: TPascalStream; StartPos,EndPos : Int64) : Integer;
var i,p,z,save : Integer;
    c : array[1..2] of char;

begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,789; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  i := StartPos;
  result := 0;

  if (MaintainBreaks) then exit;

  save := InputStream.Position;//vorherige position speichern

  InputStream.Position := StartPos;

  c[2] := #0;
  {schleife ließt alle zeichen ein zwischen startpos und endpos und
  berechnet die anzahl der breaks}
  while (InputStream.Position < EndPos)  do
  begin
    try
     z := InputStream.Read(c[1],1);
    except
     break;
    end;
    if z <= 0 then break;

    if (c[1] in Breaks) and (c[2] in Breaks) then
    begin
      Inc(result);
      c[2] := #0;
    end
    else
     c[2] := c[1];
  end;
  InputStream.Position := save;

  if (OutPutStream = nil) or (MaintainBreaks) then exit;
  //schreibt soviele zeilenumbrüche wie vorher zeilen existierten
  OutPutStream.Seek(0,soFromEnd);
  OutPutStream.Size := OutPutStream.Size + (result * 2);

  c[1] := #13; c[2] := #10;
  for i := 1 to result do
  begin
    OutPutStream.Write(c,2);
  end;
{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,789; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;

{useoutput, dürfen daten in outputstream geschrieben werden
}
function Preprocessing(OnProcessing : TOnProcessing; InputStream,OutPutStream : TPascalStream; Directives, Definitions, Warnings : TStringlist; DefinitionsNesting : Integer = 0) : Integer;
var Token : String;
    Position,StartPosition,ElsePosition,currPos,
    BreaksStart,newPosition : Int64;
    pType : TPreProcessorType;
    Definition : String;
    IsDefined,IsIFDEF : Boolean;
    Defines,ii,Size : Integer;
    ReadBreaks : array[1..2] of char;
begin
{$IFDEF PROFILE}asm DW 310FH; call Profint.ProfStop; end; Try; asm mov edx,790; xor eax,eax; call Profint.ProfEnter; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; {$ENDIF}
  Directives.Duplicates := dupIgnore;
  Directives.CaseSensitive := FALSE;
  Directives.Sort;

  result := 0;
  Defines := 0;
  StartPosition := -1;
  size := 0;
  Position := -1;

  StartPosition := InputStream.Position;
  IsIFDEF := FALSE;

  pType := ppt_none;
  while not Inputstream.EOF do
  begin
    Token := GetNextPreProcessorString(InputStream,Position,pType,Definition,Definitions);

    //unbekannte compileranweisung oder ende
    if (ptype = ppt_none) then
    begin
//      if CompareText(Token,'implementation') = 0 then
      //if ((pos(SourceSectionBegin,token) > 0) and (SourceSectionBegin[pos(SourceSectionBegin,token)-1] = ',')) then
      if ((pos(token,SourceSectionBegin) > 0) and (SourceSectionBegin[pos(token,SourceSectionBegin)-1] = ',')) then
      begin
        Inc(Position,Length('implementation'));
        break;
      end;

      if InputStream.EOF then break;


      newPosition := Position;
      for ii := low(IgnoreStatements) to high(IgnoreStatements) do
      begin
        if pos(Uppercase(IgnoreStatements[ii]),Uppercase(Token)) = 1 then //an der ersten stelle gefunden
        begin
          newPosition := InputStream.Position;
          break;
        end;
      end;

      //Warnung nur ausgeben, wenn Direktive nicht ignoriert werden soll
      if (Warnings <> nil) and (newPosition = Position) then
        Warnings.Add(format('Preprocessor: Unknown directive found at line %d : "%s" - ignored',[InputStream.ReadLineNumber,Token]));

      currPos := InputStream.Position;
      CopyFrom(InputStream,OutPutStream,StartPosition,newPosition);
      StartPosition := currPos;
    end;

    if @OnProcessing <> nil then
     OnProcessing(Position);


    case ptype of
      ppt_DEFINE :  begin
                      currPos := InputStream.Position;
                      CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                      StartPosition := currPos;

                      if not IgnoreSourceDefines then
                        Directives.Add(Uppercase(definition));
                    end;

      ppt_UNDEF  : begin
//                     currPos := InputStream.Position;
                     CopyFrom(InputStream,OutPutStream,StartPosition,Position);
//                     StartPosition := currPos;

                     if IsDirectiveActive(Directives,Definition) and not IgnoreSourceDefines then
                        Directives.Delete(Directives.IndexOf(Definition));
                   end;
      ppt_IF,ppt_ELSEIF,ppt_IFDEF,ppt_IFNDEF  :  begin


                      if ptype <> ppt_ELSEIF then
                        IsIFDEF := TRUE //ifdef anweisung ist richtig begonnen worden
                      else
                      if not IsIFDEF then
                      begin
                        raise Exception.CreateFmt('Preprocessor: Directive ELSEIF without IFDEF found at line : %d',[InputStream.ReadLineNumber]);
                      end;

                      BreaksStart := Position;
                      if Defines > 0 then
                      begin
                        //kopiert die Daten zwischen der vorherigen Anweisung und der neuen in den Outputstream
                        //es handelt sich dabei nur um quelltext
                        currPos := InputStream.Position;
                        CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                        StartPosition := currPos;

                        //untersucht eine neu Compilerdirtive
                        InputStream.Position := Position;
                        Preprocessing(OnProcessing,InputStream,OutPutStream,Directives,Definitions, Warnings,Defines);
                        StartPosition := InputStream.Position;
                      end
                      else
                      begin
                        if ptype in [ppt_IF,ppt_ELSEIF] then
                        begin
                          IsDefined := IsDefinitionsDefined(Definition,Definitions,Directives,Warnings,InputStream);
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

                        //if IsDefined then
                        begin
                          StartPosition := InputStream.Position;
                        end;
                        //else
                        begin
                          // StartPosition := -1;// Position;
                        end;
                      end;
                    end;
      ppt_ELSE :  begin
                    if not IsIFDEF then
                    begin
                       raise Exception.CreateFmt('Preprocessor: Direktive ELSE without IFDEF found at line : %d',[InputStream.ReadLineNumber]);
                    end;
                    if IsDefined then
                    begin
                      currPos := InputStream.Position;
                      CopyFrom(InputStream,OutPutStream,StartPosition,Position);
                      StartPosition := currPos;
                    end
                    else
                    begin
                      StartPosition := InputStream.Position;
                      AddBreaks(InputStream,OutPutStream,BreaksStart,InputStream.Position);
                    end;
                    IsDefined := not IsDefined;
                    BreaksStart := Position;
                  end;
      ppt_ENDIF,ppt_IFEND : begin



                    if not IsIFDEF then
                    begin
                       raise Exception.CreateFmt('Directive ELSE without IFDEF found at line : %d',[InputStream.ReadLineNumber]);
                    end;

                   //wenn IF 
                   // if ([ppt_IFDEF,ppt_IFNDEF] in prevType) and (


                    Dec(Defines);
                    if not IsDefined then
                    begin
                      AddBreaks(InputStream,OutPutStream,BreaksStart,InputStream.Position);


                      if MaintainBreaks and (InputStream.Position+2 < InputStream.Size) then
                      begin
                        Size := 0;
                        for ii := 1 to 2 do
                        begin
                          InputStream.Read(ReadBreaks,1);
                          if not (ReadBreaks[1] in Breaks) then
                            Inc(Size);
                        end;
                        InputStream.Seek(-Size,soFromCurrent);
                      end;

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
  //nur den rest kopieren, wenn keine rekursive funktionsaufrufe existieren
  //nur bis implementation lesen, der rest ist uninteressant
  if (DefinitionsNesting <= 0) then
  begin

    if not AppendSourceSection then
     size := Position
    else
     size := Inputstream.Size;

    if Size > 0 then
      CopyFrom(InputStream,OutPutStream,StartPosition, size);
  end;
   //Position);

{$IFDEF PROFILE}finally; asm DW 310FH; mov ecx,790; call Profint.ProfExit; mov ecx,eax; DW 310FH; add[ecx].0,eax; adc[ecx].4,edx; end; end; {$ENDIF}
end;


end.

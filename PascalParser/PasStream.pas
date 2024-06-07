{Pascalsyntax bezogener Stream
mit der Unit TPascalStream
}
unit PasStream;


//kommentarzeichen werden in strings als solche erkannt

interface

uses SysUtils, Classes,
  SParser;

type //Ein Datentyp der von ReadToken genutzt wird, um herauszufinden, welche Art von Kommentar gelesen werden darf
  TReadableComment = (rc_comment, rc_single);
  TReadableComments = set of TReadableComment;

  TSymbolType = set of (st_word,st_number,st_symbol,st_string,st_PreProzessor,
                        st_comment,st_singlecomment,st_singlelinecomment);



type SetOfChar = Set of Char;
     Array3Len = array[1..7] of string;

     {}

     LineReadNum = 2..High(Word);

const
  Symbols  : SetOfChar = [':',';','^','.','#','+','-',',','=','''','[',']','(',')','{','}','/','<','>'];
  //Zeichen, die in wörtern vorkommen (von WordChar verwendet)
  WordChar : SetOfChar = ['A'..'Z','a'..'z', '0'..'9', '_'];
  AlphaChar : SetOfChar = ['A'..'Z','a'..'z'];
  //positive/negative (Hex-,Float-) Zahlen und Zeichen in numerischer darstellung (#12)
  NumChar  : SetOfChar = ['-', '+', '1'..'9', '0', '$', '.','A'..'F','a'..'f'];
  NumerusChar : SetOfChar = ['1'..'9', '0', '$','A'..'F','a'..'f'];
  BreakChar : SetOfChar = [#13,#10];


  {Kommentar auf :ungerade, kommentar zu: gerade indizies,
   wenn ungerader index = #1 , ist es ein einzeiliger kommentar der durch ein Break beendet wird}
  Comments: Array3Len = (#0,'{','}','(*','*)','//',#1);

  PreProzessor = '$';

  {Standard länge für default parameter}
  cTokenDefaultLineLength = 10;

  {cTokenLineLength ist die Anzahl der Zeichen, die in ReadWord aus dem Stream
     gleichzeitig gelesen werden.
     Sie ist abhänging von der durchschnittlichen Wortgröße in der Datei.
     bei normalen Quelltexten gehe ich derzeit von einem Wert von 10 aus,
     der bis jetzt die Besten Resultate erzielte.
  }
  cTokenLineLength : LineReadNum = cTokenDefaultLineLength;



{$IF cTokenDefaultLineLength < 2}
//ERROR : cTokenLineLength must be greater than 2 !!
{$IFEND}

const
  RC_ALL = [rc_comment, rc_single];
  RC_NONE = [];
      
type
  TIntArray = array of int64;



  {Behandelt Pascalcode}
  TPascalStream = class(TTextStream)
    fLastComment,
    fLastSingleComment,
    fBackComment: string;
    fNewSingleComment: boolean;
    CommentFlag: boolean;
    //True wenn Kommentar gefunden wurde, wird in ReadNextComment benutzt
    fCompilerSwitches: string;
    //TIntArray;
    fTokenReadCount: cardinal;
    fTokenType : TSymbolType;
    fTokenPosition,
    fWordPosition : Int64;

    InputToken : String;
    InputType : TSymbolType;
    InputPos : Int64;
  public

    procedure Init; override;
        {Liest ein Wort auch einen String und (Hexdezimale-)Zahlen ein.
         Wenn GetReturn wahr ist auch Zeilenumbrüche.
         ReadToken sollte ReadWord vorgezogen werden, da ReadToken vorrausliest
         um beim lesen von kommentaren Zeit zu sparen.
         ReadWord ließt nach einem Readtoken also immer ein Wort zu weit vorne}
    function ReadWord(GetReturn: boolean = False): string; virtual;

    {Ließt ein String ein und gibt mit ihn mit "'" zurück}
    function ReadString: string;

        {Liest ein Wort, wie ReadWord und speichert mögliche vorangegangene Kommentare in GetLastComment.
        ReadWord bzw ReadToken sollte mit try überprüft werden, damit eine Exception abgefangen werden kann :
         z.b. Wenn ein String nicht terminiert wurde.
        Setze ReadableComment auf einen oder mehrere Werte, die angeben welche Art von Kommentaren gelesen werden dürfen.
        Wenn kein Kommentar zu diesem Token benötigt wird, kann dies Geschwindigkeitsvorteile bringen }
    function ReadToken(GetReturn: boolean = False;
      ReadableComment: TReadableComments = RC_ALL): string;


        {Gibt den Kommentar zurück der von dem letzten ReadToken gelesen wurde.
        Der Kommentar ist danach gelöscht,
        um den Kommentar zu lesen, ohne ihn zu löschen siehe @LastComment}
    function GetLastComment: string;

        {Gibt den Kommentar zurück der nach dem letzten ReadToken gelesen wurde.
        Der Kommentar ist danach gelöscht,
        um den Kommentar zu lesen, ohne ihn zu löschen siehe @SingleComment}
    function GetSingleComment: string;

        {Überspringt alle Kommentare bis zum letzten Kommentar und liefert diese mit Zeilenumbruch zurück.
        Schalter und Compileranweisungen werden dort auch eingefügt.}
    function ReadComments(var Token : String; out TType : TSymbolType; var TokenPos : Int64): string;


        {Liest solange bis ein Compilerschalter ($) erscheint, und gibt den Schalter zurück.
        Der Positionszeiger steht dann hinter der Klammer.}
    function ReadToSwitch: string;
    {Liest ein Pascalkommentar an der aktuellen Leseposition ein.}
    function ReadComment(var Token : String; var TType : TSymbolType): string; virtual;
        {Liest den nächsten Pascalkommentar ein, bis ein Zeilenumbruch kommt.
        Wenn kein PascalKommentar erkannt wurde, wird ein leerer String zurückgegeben,
        und der Lesezeiger zeigt auf das Ende des Zeilenumbruches oder des ersten
        nicht Kommentarzeichens. Wenn ein Kommentar existiert, ist der Lesezeiger danach auf
        das folgende Zeichen der schließenden Klammer. Bei "//" zeigt der Lesezeiger auf das erste
        Zeichen der darauffolgende Zeile.
         }
    function ReadNextComment(out CommentType: byte): string;

    procedure SavetoFile(Const FileName : String);

        {LastComment enthält den letzten Kommentar und wird von GetLastComment verwendet.
         Damit kann man GetLastComment beeinflussen.
         Dieser Kommentar wird bei Zugriff im Gegensatz zu GetLastComment nicht gelöscht.}
    property LastComment: string read fLastComment write fLastComment;

        {Ist TRUE wenn ein neuer EinzelKommentar existiert.
        Ein Einzelkommentar ist ein einzeiliger Kommentar, der direkt hinter Anweisungen steht}
    property IsNewSingleComment: boolean read fNewSingleComment;
        {SingleComment enthält den letzten Kommentar und wird von GetSingleComment verwendet.
         Damit kann man GetSingleComment beeinflussen.
         Dieser Kommentar wird bei Zugriff im Gegensatz zu GetSingleComment nicht gelöscht.}
    property SingleComment: string read fLastSingleComment write fLastSingleComment;

    {CompilerSwitches enthält durch Zeilenumbruch (#$D#$A) getrennte Compilerschalter jeglicher Art ohne Zeilenangabe.}
    property CompilerSwitches: string read fCompilerSwitches;

    property TokenReadCount: cardinal read fTokenReadCount;
    property TokenType : TSymbolType read fTokenType;
    property TokenPosition : Int64 read fTokenPosition;
    property WordPosition : Int64 read fWordPosition;

    property PreReadToken : String read InputToken write InputToken;
    property PreReadInputType : TSymbolType read InputType write InputType;
    property PreReadInputPos : Int64 read InputPos write InputPos;   
  end;



const
  CommentOpen: array[1..3] of string =
    ('{', '(*', '//');
  CommentClose: array[1..3] of string =
    ('}', '*)', '');

function IsInArray(const anArray : Array3Len; s : String) : Byte;


implementation

uses Math;


procedure TPascalStream.Init;
begin
  inherited;
  InputToken := '';
  InputType := [];
  InputPos := -1;
end;




procedure TPascalStream.SavetoFile(Const FileName : String);
var F : TFileStream;
begin
  F := TfileStream.Create(FileName,fmCreate or fmOpenWrite);
  F.Size := 0;
  F.CopyFrom(Self,0);
  F.Free;
end;

function TPascalStream.ReadToSwitch: string;
var
  s: string;
  c: char;
  i: integer;
begin
  repeat
    s := ReadWord;
    if (s = CommentOpen[1]) or (s = CommentOpen[2]) then
    begin
      if (s = CommentOpen[1]) then
        i := 1
      else
        i := 2;
      c := GetNextChar;
      if c = '$' then
      begin
        Result := c;
        repeat
          s := ReadWord;
          if s <> CommentClose[i] then
            Result := Result + s + ' ';
        until (s = CommentClose[i]) or (EOF);
        Result := Trim(Result);
        exit;
      end;
    end;
  until EOF;
end;


//hier müssen auch Strings eingelesen werden können

function TPascalStream.ReadString: string;
var 
  c: char;
begin
  Result := '';
  c := GetNextChar;
  if c <> '''' then
  begin
    GetPrevChar;
    exit;
  end;
  repeat
    c := GetNextChar;
    if c = '''' then
    begin
      c := GetNextChar;
      if c = '''' then
        Result := Result + c
      else
        break;
    end
    else
      Result := Result + c;

  until False;
end;



function IsInArray(const anArray : Array3Len;s : String) : Byte;
var i,hi,lo : Integer;
begin
   Delete(s,3,Length(s));
   hi := Low(anArray);
   lo := High(anArray);

   for i := hi to lo do
     if (pos(anArray[i],s) > 0) and (anArray[i] <> #1) then
     begin
       if pos(anArray[i],s) = 1 then
       begin
         result := i;
         exit;
       end;
     end;
end;


{Löscht alle Leerzeichen bis das erste echte Zeichen kommt}
procedure ClearSpacesAtBegin(var Line : String);
  var i,p,pMax : Integer;
      s : String;
begin
    p := 0;
    pMax := Length(Line);
    for i := 1 to pMax do
    begin
      if Line[i] = ' ' then
       Line[i] := #1
       //p := i
      else
       if not (Line[i] in BreakChar) then
         break;
    end;
    for i := Length(Line) downto 1 do
     if Line[i] = #1 then
      Delete(Line,i,1);
end;

{Löscht alle Zeilenumbrüche bis das erste echte Zeichen kommt}
procedure ClearBreaksAtBegin(var Line : String);
  var i,p,pMax : Integer;
      s : String;
begin
    p := 0;
    pMax := Length(Line);
    for i := 1 to pMax do
    begin
      if (Line[i] in BreakChar) then
       //p := i
        Line[i] := #1
        //Delete(Line,i,1)
      else
       if (Line[i] <> ' ') then
         break;
    end;
    for i := Length(Line) downto 1 do
     if Line[i] = #1 then
      Delete(Line,i,1);
end;


{ermittelt das hinterste echte zeichen,
dass nicht ein zeilenumbruch oder leerzeichen darstellt}
function GetLastRealChar(const TokenLine : String; out idx : Integer) : Char;
var ii : Integer;
    begin
      idx := -1;
      result := #0;
      for ii := Length(TokenLine) downto 1 do
      begin
        if not (TokenLine[ii] in [#13,#10,' ']) then
        begin
          result := TokenLine[ii];
          idx := Length(TokenLine)-ii+1;
          exit;
        end;
      end;
end;


function TPascalStream.ReadWord(GetReturn: boolean = False): string;


  {ließt eine zeile mit der länge von TokenLineLength ein.
  wenn Zeilenumbrüche oder leerzeichen als erste zeichen auftauchen, und
  GetReturn und GetSpaces unwahr ist, werden diese entfernt und neue zeichen eingelesen.
  Die länge des rückgabewertes ist immer Tokenlinelength, außer das dateiende wurde erreicht}
  function GetTokenLine(GetReturn,GetSpaces: boolean; out aWordPositon : Int64; TokenLineLength : LineReadNum = cTokenDefaultLineLength) : String;
  var Tokens : String;
      L1,L2,p : Integer;
  begin
    Tokens := GetNextChars(TokenLineLength);

    L1 := Length(Tokens);

    if not GetReturn then       //notwendig?
      ClearBreaksAtBegin(Tokens);
    if not GetSpaces then
      ClearSpacesAtBegin(Tokens);

    L2 := Length(Tokens);
   // aWordPositon := Position - (L1 - L2);
    
    while (Length(Tokens) < TokenLineLength) and not EOF do
    begin
      Tokens := Tokens + GetNextChars(TokenLineLength - Length(Tokens));

      if not GetReturn then       //notwendig?
        ClearBreaksAtBegin(Tokens);
      if not GetSpaces then
        ClearSpacesAtBegin(Tokens);
    end;

    {am ende ist die länge von tokens so wie in TokenLineLength gewollt. }

    L2 := Length(Tokens);

    {if (L2 = 0) and not EOF then //solange lesen bis ein zeichen kommt
      result := GetTokenLine(GetReturn,GetSpaces)
    else   }
    begin
      if (GetReturn) and
        (L2 > 0) and (Tokens[1] in BreakChar) then
      begin
        if (L2 > 1) and (Tokens[2] in BreakChar) then
          result := Tokens[1] + Tokens[2]
        else
          result := Tokens[1];
        Seek(-(L2-Length(result)),soFromCurrent);
      end
       else
       begin
         ClearBreaksAtBegin(Tokens);
         result := Tokens;
       end;
    end;

    aWordPositon := Position - Length(Result);
  end;



  {Ließt solange tokenline ein bis Chars nicht mehr erfüllt wurde und
  gibt das resultat zurück und setzt den dateizeiger zurück auf das zeichen,
  welches nicht in chars vorkommt}
  function ReadChars(var TokenLine : String; const Chars : SetofChar): String;
  var i,p : Integer;
      aWordPosition : Int64;
      s : String;
  begin
    result := TokenLine[1];
    i := 2;

    while TRUE do
    begin
      //wenn zuwenige zeichen - weiter einlesen
      if i > Length(TokenLine) then
      begin
        {WordPosition wird ignoriert da in TokenLine das erste Wort zu finden ist}
        s := GetTokenLine(TRUE,TRUE,aWordPosition); //auch leerzeichen und umbrüche für kommentare
        if Length(s) = 0 then break;
        TokenLine := TokenLine + s;
      end
      else
      if not (TokenLine[i] in Chars) then 
      begin
        p := Length(TokenLine)-(i-1);
        Seek(-(p),soCurrent);
      //  Delete(TokenLine,i,Length(TokenLine));
        break;
      end
      else
      begin
        result := result + TokenLine[i];
        Inc(i);
      end;
    end;
  end;


  {ließt ei kommentar aus tokenline ein und gibt den index aus comments in commenttype zurück.
  der rückgabewert ist der kommentar mit kommentarzeichen }
  function ReadComment(TokenLine : String; CommentType : Byte) : String;
  var i,p,b1,b2 : Integer;
      aWordPosition : Int64;
  begin
    i := 2;

    while TRUE do
    begin
      //if CommentType = 6 then
      if Comments[CommentType+1] = #1 then
      begin
        b1 := pos(#10,TokenLine);
        b2 := pos(#13,TokenLine);

        p := Max(b1,b2);
        if b1 > 0 then
         dec(p);
        if b2 > 0 then
         dec(p);
      end
      else
        p := pos(Comments[CommentType+1],TokenLine);

      if p > 0 then
      begin
        if CommentType <> 6 then
         Inc(p,Length(Comments[CommentType+1]))
        else
         Inc(p,Length(Comments[CommentType]));

        p := Length(TokenLine)-(p-1);
        Seek(-(p),soCurrent);

        if CommentType <> 6 then
          Delete(TokenLine,Length(TokenLine)-p+1,Length(TokenLine))
        else
          Delete(TokenLine,Length(TokenLine)-p,Length(TokenLine));

        result := TokenLine;
        break;
      end
      else
      begin
        p := (i * cTokenLineLength) div 2; //ließt große kommentare immer schneller ein
        if p < cTokenLineLength then
          p := cTokenLineLength;

        TokenLine := TokenLine + GetTokenLine(TRUE,TRUE,aWordPosition,p);

        Inc(i);
      end;
    end;
  end;


  {Ließt einen komplexen String aus Tokenline ein. der Rest wird in tokenline wieder zurückggeliefert.
  das resultat ist der string}
  function ReadStringToken(var TokenLine : String) : String;

    {ließt einen einfachen string ein umschlossen durch "'" ,
     wenn zwei '-Zeichen hintereinander kommen, um ein solches Zeichen darzustellem,
     wird der rest das nächste mal eingelesen.}
    function ReadAString(var ii:Integer;var TokenLine : String) : String;
    var oldII : Integer;
        aWordPosition : Int64;
    begin
      result := '';
      oldII := ii;
      if TokenLine[ii] = '''' then
       Inc(ii);
      While TRUE do
      begin
        if ii > Length(TokenLine) then
          TokenLine := TokenLine + GetTokenLine(FALSE,FALSE,aWordPosition);

        if (ii > Length(TokenLine) ) or (TokenLine[ii] = '''') then //break wenn außerhalb des bereichs oder stringende
          break;
        Inc(ii);
      end;

      //langsames kopieren des strings nach result
      result := Copy(TokenLine,oldII,(ii-OldII)+1);

      //Dieser String wird entfernt
      Delete(TokenLine,oldII,(ii-OldII)+1);

      ii := 0;
    end;

    {ließt ein zeichenstring im ordinalwert ein #}
    function ReadAChar(var ii:Integer;var TokenLine : String) : String;
    var oldII : Integer;
        aWordPosition : Int64;
    begin
      result := '';
      oldII := ii;
      if TokenLine[ii] = '#' then
       Inc(ii);

      //einlesen von Zahlen
      While TRUE do
      begin
        if ii > Length(TokenLine) then
          TokenLine := TokenLine + GetTokenLine(FALSE,FALSE,aWordPosition);

        if (ii > Length(TokenLine) ) or not (TokenLine[ii] in NumerusChar) then //nur echte (hex-)zahlen
         break;
        Inc(ii);
      end;

      //langsames kopieren des strings nach result
      result := Copy(TokenLine,oldII,(ii-OldII));

      //Dieser String wird entfernt
      Delete(TokenLine,oldII,(ii-OldII));

      ii := 0;
    end;


  var ii,p,idx : Integer;
      ExitFlag,
      PlusFlag : Boolean;
      aWordPosition : Int64;
  begin
    ii := 1;
    ExitFlag := FALSE;
    ClearSpacesAtBegin(TokenLine);

    while TRUE do
    begin
      if ii > Length(TokenLine) then
        TokenLine := TokenLine + GetTokenLine(FALSE,FALSE,aWordPosition);

      if ii > Length(TokenLine) then //tritt nur ein, wenn EOF
      begin
        ExitFlag := TRUE;
        break;
      end;

      if TokenLine[ii] = '''' then //normaler string einlesen
      begin
        PlusFlag := FALSE;
        result := result + ReadAString(ii,TokenLine);
      end
      else
      if TokenLine[ii] = '+' then //verbundener string auch mit zeilenumbruch danach, aber nicht davor!
      begin
        result := result + '+';
        Delete(TokenLine,ii,1);
        Dec(ii);
        PlusFlag := TRUE;
      end
      else
      if TokenLine[ii] = '#' then //char einlesen
      begin
        PlusFlag := FALSE;
        result := result + ReadAChar(ii,TokenLine);
      end
      else
      if not (TokenLine[ii] in ['''','+','#']) then
      begin
        if (not PlusFlag) then  //wenn kein verbundener string (mit +)
        begin
          ExitFlag := TRUE;
          break;
        end
        else
        begin
          result := result + TokenLine[ii];

          //das zeichen löschen, damit es in der nächsten runde nicht von den funktionen mitgelesen wird
          Delete(TokenLine,ii,1);
          Dec(ii);
        end;
      end;

      Inc(ii);
    end;

    //raus
    if ExitFlag then
    begin
       p := Length(TokenLine);
       Seek(-(p),soCurrent);
    end;
  end;

 { aktuelles projekt
  single line comments, die nicht direkt hinter einer definition
  stehen sondern durch break getrennt sind werden trotzdem zur vorherigen definition gezählt
  wer  }

var TokenLine,s : String;
    i,L,p : Integer;
begin
  TokenLine := GetTokenLine(GetReturn,FALSE,fWordPosition);
//  ClearSpacesAtBegin(TokenLine);

  fTokenType := [];

  if Length(TokenLine) = 0 then
  begin
    result := #0;
    exit;
  end;

  L := Length(TokenLine);

  if (TokenLine[1] in BreakChar) then //breaks
  begin
    if not GetReturn then
      raise Exception.Create('ReadWord : this error should never happen :  Breakchar found, but Parameter GetReturn was FALSE. ');
    result := TokenLine;
    exit;
  end
  else
  if TokenLine[1] in Symbols then  //Symbole und Kommentare auch Strings
  begin
    if (TokenLine[1] = '''') or (TokenLine[1] = '#') then
    begin
      fTokenType := [st_String];
      result := ReadStringToken(TokenLine);
      exit;
    end
    else
    begin
      //symbole, kommentar oder preprozessor?
      p := IsInArray(Comments,TokenLine);

      if (p > 0) and (p mod 2 = 0) and (TokenLine[1+Length(Comments[p])] = Preprozessor)then //Preprozessor
      begin
        fTokenType := [st_PreProzessor];
        result := ReadComment(TokenLine,p);
        exit;
      end
      else
      if (p > 0) and (p mod 2 = 0) then //aufgehende klammer , mod 2 heißt gerade zahl - mehr siehe comments
      begin
        fTokenType := [st_Comment];
        try
          if Comments[p+1] = #1 then
            Include(fTokenType,st_singlecomment);
        except
        end;

        result := ReadComment(TokenLine,p);
        //single oder mehrzeiliger kommentar?
        if  ((pos(#13,result) = 0) and (pos(#10,result) = 0)) and not (st_singlecomment in fTokenType) then
          Include(fTokenType,st_singlelinecomment);
        exit;
      end;
    end;

    if (TokenLine[1] = '.') then
    begin
      result := TokenLine[1];

      if (Length(TokenLine) > 1) and (TokenLine[2] = '.') then
        result := result + TokenLine[2];
    end
    else
    begin
      result := TokenLine[1];
    end;

    fTokenType := [st_Symbol];

    p := Length(TokenLine)-(Length(result));
    if p > 0 then
     Seek(-(p),soCurrent);
    exit;
  end
  else
  if (TokenLine[1] in NumChar) and not (TokenLine[1] in AlphaChar) then //Zahlen
  begin
    result := ReadChars(TokenLine,NumChar);
    fTokenType := [st_Number];
  end
  else
  if TokenLine[1] in WordChar then  //Wörter
  begin
    result := ReadChars(TokenLine,WordChar);

    fTokenType := [st_Word];
  end
  else
  begin
    {Tokenline := StringReplace(Tokenline,#0,'°',[rfReplaceAll]);  }
    raise Exception.CreateFmt('ReadWord : Ungültiges Zeichen "%s" (%d).',[TokenLine[1],Ord(TokenLine[1])]);
  end;
end;


//

function TPascalStream.ReadToken(GetReturn: boolean = False; ReadableComment: TReadableComments = RC_ALL): string;
var
  s,token: string;
  CType: byte;
  ipos: int64;
  TType : TSymbolType;

begin
  {schon gelesen tokens werden verwendet um die geschwindigkeit zu erhöhen
  }
  if Length(InputToken) > 0 then
  begin
    if InputToken[1] in BreakChar then //auf zeilenumbruch überprüfen, da ReadWord in ReadComment mit GetReturn = TRUE aufgerufen wird
      Token := ''
    else
    begin
      Token := InputToken;
      fTokenType := InputType;
      ipos := InputPos;
    end;
    InputToken := '';
  end;

  (*alle Kommentare einlesen, in Token steht danach das erste nicht Kommentar-token, in TType dessen Typus.
   gleichzeitig wird in Token ein bereits eingelesenes Token eingesetzt, TType ist als Input irrelevant.

   fLastComment besitzt folgende Pascal Kommentare :
   - mehrere einzeilige Kommentare hintereinander
       {123}
       {123456}
     oder
       // 123
       // 123456
     ergibt 123^123456, wobei ^ ein Zeilenumbruch ist  
   - der letzte mehrzeilige Kommentar
     {1234
      5678}
     {dieser kommentar wird verwendet} 

   *)
  fLastComment := ReadComments(Token,TType,ipos);

  //Wenn das zuletzt gelesen Token in ReadComments vorkommt, übernehmen...
  if TType = [] then //sonst neu einlesen
  begin
    Result := ReadWord(GetReturn);
    ipos := WordPosition;
  end
   else
   begin
     result := Token;
     fTokenType := TType;
   end;

  {einzelne Kommentare}
  if rc_single in ReadableComment then
  begin
    InputToken := '';
    InputType := [];
    InputPos := -1;

    {Kommentar hinter der Tokenzeile lesen.
     es werden nur kommentare gelesen, die in derselben zeile stehen, wie das letzte token.
     es darf also kein zeilenumbruch gelesen worden sein.}
    s := ReadComment(InputToken,InputType);

    if (st_comment in TokenType) then
    // keine breaks für einzeilige Kommentare
    begin
      fLastSingleComment := s;
      fNewSingleComment := True;
    end
    else
    begin
      fLastSingleComment := '';
      fNewSingleComment := False;  
    end;

    //TokenType muss wiederhergestellt werden, da es in ReadComment geändert wird
    if TType <> [] then
      fTokenType := TType;
  end;

  fTokenPosition := ipos;
  Inc(fTokenReadCount);//Anzahl der tokens erhöhen

  //wenn kein token gelesen werden konnte sind wir vorschnell am ende angekommen
  if Length(Result) = 0 then
  begin
    raise Exception.Create(Format('Unexpected end of file at line %d : %s',
      [ReadLineNumber, ReadLine]));
  end;
end;



function TPascalStream.GetLastComment: string;
begin
  Result := LastComment;
  LastComment := '';
end;

function TPascalStream.GetSingleComment: string;
begin
  Result := SingleComment;
  fNewSingleComment := False;
  fLastSingleComment := '';
end;

function TPascalStream.ReadComments(var Token : String; out TType : TSymbolType; var TokenPos : Int64): string;
var
  CommentType, LastCommentType: byte;
  LastTokenType : TSymbolType;
  ipos : Int64;
begin
  LastCommentType := 0;

  if Length(Token) = 0 then
  begin
    Token := ReadWord();
    ipos := WordPosition;
  end
  else
  begin
    if Token[1] in BreakChar then //auf zeilenumbruch überprüfen, da ReadWord in ReadComment mit GetReturn = TRUE aufgerufen wird
    begin
      Token := ReadWord();
      ipos := WordPosition;
    end;
  end;

  if TokenPos < 0 then
   ipos := WordPosition;

  repeat

    if not (st_comment in TokenType) then
    begin
      TType := TokenType;

      {Position := streamPos;}
      fTokenType := LastTokenType;
      TokenPos := ipos;
      exit;
    end;

   CommentType := IsInArray(Comments,Token);

   //kommentar
   if (st_comment in TokenType) then
    begin
      Delete(Token,1,Length(Comments[CommentType]));
      if Comments[CommentType+1] <> #1 then
        Delete(Token,Length(Token),Length(Comments[CommentType]));
      if Length(Result) > 0 then
        result := result + #13#10;
      Result := result + Token;

      LastTokenType := TokenType;
    end
    else
    //Compileranweisungen
    if (st_PreProzessor in TokenType) then
    begin
      if Length(fCompilerSwitches) > 0 then
        fCompilerSwitches := fCompilerSwitches + #13#10;
      fCompilerSwitches := fCompilerSwitches + Token;
    end;

    LastCommentType := CommentType;

//    if (Token = '') and (not CommentFlag) then break;
    if (CommentType < 0) then break;


    Token := ReadWord;
    ipos := WordPosition;
  until FALSE;
end;


function TPascalStream.ReadComment(var Token : String; var TType : TSymbolType): string;
var 
  CommentType: byte;
  OverHead: integer;
  //Token: string;
  iPos : int64;

begin
  iPos := Position;

  if Length(Token) = 0 then
    result := ReadWord(TRUE)
  else
  begin
    result := Token;
    fTokenType := TType;
  end;

  if (st_comment in TokenType) then
  begin
    CommentType := IsInArray(Comments,result);

    Delete(result,1,Length(Comments[CommentType]));
    if Comments[CommentType+1] <> #1 then
      Delete(result,Length(result)-Length(Comments[CommentType+1])+1,Length(Comments[CommentType+1]));
  end
  else
  begin
    {Position := iPos;}
    Token := Result;
    TType := TokenType;
    result := '';
  end;

end;



function TPascalStream.ReadNextComment(out CommentType: byte): string;

begin
(*  function CheckForCommentOpen(s: string): integer;
  var
    i: integer;
  begin
    Result := 0;
    for i := low(CommentOpen) to high(CommentOpen) do
      if pos(CommentOpen[i], s) > 0 then
      begin
        Result := i;
        //Length(CommentOpen[i]);
        exit;
      end;
  end;
var
  s: string;
  l: integer;
begin
  Result := '';
  CommentFlag := False;
  repeat
    s := ReadWord(True);
    l := CheckForCommentOpen(s);
    CommentType := l;
    if l > 0 then
    begin
      GetPrevChars(Length(s));
      Result := ReadComment;
      CommentFlag := True;
      exit;
    end
    else
    begin
      if s = #$D#$A then
      begin
        CommentFlag := True;
        exit
      end
      else
      begin //Kein Kommentar !
        GetPrevChars(Length(s));
          {s := GetNextChars(20,0,FALSE);
          if s = '' then;}
        exit;
      end;
    end;
  until False; *)
end;


end.



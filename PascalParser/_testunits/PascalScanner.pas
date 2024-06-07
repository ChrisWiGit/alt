{PascalScanner
 createdy

}


unit PascalScanner;

interface
uses SysUtils, Classes,Scanner, IOClasses, SParser,PasStream;




type  {TAStrings = String;
      TIncludeErrorProc = pointer;   }

    { INCPARSERPROGRAMM}

      TPascalWord = (pw_none,
                      pw_unit,pw_library,
                      pw_exports,
                      pw_interface,
                      pw_type,pw_const,pw_var, //Deklarationsart
                      pw_procedure,pw_function,pw_constructor,pw_destructor, //Funktion
                      pw_register,pw_pascal,pw_forward,pw_cdecl,pw_deprecated,pw_stdcall,pw_overload,pw_near,pw_far,pw_safecall,pw_external,pw_varargs,pw_export, //Aufrufkonventionen
                      pw_set,pw_array,pw_of,pw_case,
                      pw_interfaceClass,pw_dispinterface,       //Interface konventionen
                      pw_class,pw_object,pw_record,pw_packed,pw_begin,pw_end,
                      pw_property,pw_private,pw_protected,pw_public,pw_published,pw_read,pw_write,pw_index,pw_stored,pw_default,
                      pw_override,pw_virtual,pw_reintroduce,pw_abstract,pw_dynamic,pw_dispid,pw_message,
                      {...}

                      pw_implementation);

      {Ein Set von Pascalwörtern aus @TPascalWord}
      TPascalWords = set of TPascalWord;

const {Methodendeklarationen, die hinter einer Methode auftauchen können}
      MethodDefinitions   :TPascalWords = [pw_message,pw_dispid,pw_default,pw_dynamic,pw_abstract,pw_override,pw_virtual,pw_reintroduce,pw_overload];
                                          //pw_override,pw_virtual,pw_overload,pw_reintroduce,pw_abstract,pw_message,pw_dispID,pw_dynamic


      {Funktionsdeklarationen, die hinter einem Funktionskopf auftauchen können}
      FuncDefinitions : TPascalWords = [pw_reintroduce,pw_register..pw_safecall,pw_varargs,pw_external];
      {Eigenschaftendeklarationen, die hinter Eigenschaften bei Klassen und Interfaces auftauchen können.}
      PropertyDefinitions :TPascalWords = [pw_dispid,pw_default,pw_read,pw_write,pw_index];



//type

    //  TSequenceType = (st_Type,st_Value);

   {   TFigure = packed record
         case Boolean of
            TRUE : (we : Integer);
            FALSE : (wwe : byte);
          case Boolean of
            TRUE : (i : Integer);
            FALSE : (s : byte);

      end;      }


const {SPascalWord ist ein genaues Abbild des Typs: @TPascalWord als Text.}
      SPascalWord : array[pw_none..pw_implementation] of ShortString =
      ('','unit','library','exports',
      'interface','type','const','var',
      'procedure','function','constructor','destructor',
      'register','pascal','forward','cdecl','deprecated','stdcall','overload','near','far','safecall','external','varargs','export',

      'set','array','of','case',
      'interface','dispinterface',
      'class','object','record','packed','begin','end',
      'property','private','protected','public','published','read','write','index','stored','default','override','virtual','reintroduce','abstract','dynamic','dispid','message',

      'implementation');

      function StringtoPascalWord(Str : ShortString) : TPascalWord;
      function PascalWord2String(PascalWord : TPascalWord) : ShortString;
type

     TPascalScanner = class(TScanner)
     private
       {Zwischenspeicher der Unitklasse für Progressfortschritt.}
       fUnit : TUnit;

       {der zu scannende Quellcode}
       fPStream : TPascalStream;
       {aktuelle Compilerdefinitionen im Quelltext - wird von ReadCommentSwitches gesetzt oder gelöscht,
       wenn hier was drinsteht, befinden wir uns in einem (oder mehreren) IFDEF-Block!
       Der aktuelle IFDEF Block ist der letzte Eintrag.
       Wenn man sich in einer Else Verzweigung befindet, hat der letzte Eintrag ein Boolean Flag in Object : FALSE
       !!! Derzeit nicht in Verwendung!!!}
       fDefinitions,
       {vom User gesetzte Compilerdefinitionen}
       fUserDefinitions  : TStringList;

       {der letzte Kommentar zur Zwischenspeicherung}
       LastComment : String;
       {scannt den Unit Header bis "interface"
       Gibt danach die Kontrolle an ScanForInterface.}
       function ScanUnit : TUnit;

       {Untersucht den Unit-Kopf bis zum interface abschnitt und den uses klauseln.
       Gibt danach die Kontrolle an ScanForDefinitions.
       }
       function ScanForInterface(aUnit : TUnit) : String;
       {-->}
       {Scannt alle Definitionen bis zum Implementation Abschnitt.}
       procedure ScanForDefinitions(aUnit : TUnit; InputToken : String = '');


       {-->}
        {Scannt nach einer function/procedure und fügt diese in aUnit ein.
        WordType gibt an, ob es sich um eine function oder procedure handelt. bei pw_none wird dies intern festgestellt (ohne Fehlerkontrolle).
        DeclarationType gibt an, um was für eine Deklaration (möglich sind pw_none, pw_type und pw_class) handelt,
         also eine normale function, eine typenfunction oder methode.
        Name wird verwendet wenn es sich bei DeclarationType um pw_type handelt.
        Comment bezeichnet den Kommentar der der Funktion vorangestellt wurde.
         Wenn kein Kommentar ermittelt werden konnte, wird dieser String verwendet.
          Comment liefert den nächsten Kommentar zurück, wenn einer vorhanden ist.
          Comment ist in der Regel gültig, wenn der Rückgabewert etwas enthält.
        Die Parameter werden nicht ausgewertet, dies übernimmt die Klasse TFunction.}
         function ScanFunction(aUnit : TUnit; var Item : TItem; Container : TContainer  = nil; InitToken : String = '') : String;
         //;WordType,DeclarationType : TPascalWord;  Name : String; var Comment : String) : String;
         {Scannt nach Variablen, auch in Klassen,objekten und records,
          wenn es sich nicht um eine Variable handelt, wird auf die vorangegangene Position zurückgespult.
         Mehrere Variablen des gleich Typs bekommen eigene TBaseVariable Klassen.
         Setze Container, um die Variable(n) in ein Record, Objekt oder Klasse zu deponieren.
         }
         function ScanForVariables(aUnit : TUnit; Container : TContainer = nil; Visibility : TVisibility = vnone; InputToken : String = '') : String;

         function ScanForConstants(aUnit : TUnit; Container : TContainer) : String;

         {Scannt nach einem Block, der mit "[]" oder "()" eingeschlossen ist und gibt den Inhalt mit Klammern zurück.
          Wenn kein Block existiert, wird das nächste Word zurückgeliefert
         }
         function ScanDefinition : String;
         {Scannt nach einem Variablentyp oder nach einer Wertzuweisung.
         SqType ist für zukünfiges}
         function ScanSequence(out Buffer : String) : String;

         {Scannt nach Typen, auch Funktionstypen und fügt diese der Unit hinzu.
         Objekte, Klassen werden an ScanForOC übergeben.
         Records and ScanForRecord.
         Hinweis : Es muss sich eindeutig um eine typdeklaration handeln.
         }
         function ScanForTypes(aUnit : TUnit; Token : String = '') : String;

         {-->}
         {Scannt nach einer Klasse oder einem Objekt.
          Variablen werden durch ScanForVariables erkannt.
          Procedures/Functions durch ScanFunction.

          Scannt kein Interface!
          }
          {Scannt nach einem (O)bjekt, (C)lass und (I)nterface.
         es muss ein initialisierter container mit namen und deklarationsart angegeben werden!
         zurückgegeben wird das nächste Token, wenn vorhanden.
          es kann sich dabei auch wieder um ein objekt handeln, aber die funktion Scannt nur immer eine deklaration
         in jedem sichtbarkeitsabschnitt (private,protected,public,published) wird nach folgendem gescannt :
         ScanForVariables->ScanFunction->ScanProperty

         ScanFunction muss noch für den gebrauch in klassen angepasst werden!!
         }
         {-->}
         function ScanOCI(aUnit : TUnit; var Container : TOCIItem) : String;
           {Scannt nach Eigenschaften.}
           function ScanForProperties(aUnit : TUnit; Container : TOCIItem; Visibility : TVisibility; InputToken : String ='') : String; virtual;

         {Records sehen zwar ähnlich aus wie Klassen,
         damit aber case construkte erkannt werden,
         wurde eine eigene funktion verwendet, die ScanForOC ähnelt.}
         function ScanForRecord(aUnit : TUnit; var Item: TRecord) : String;


        {ScanForExtras ließt eine Reihe von Definitionen vom Typ Extras bis zum Semicolon.
         ScanRepeat ließt auch nach dem Semicolon weiter, sofern die Definitionen in Extras enthalten sind.
         Buffer beinhaltet die gelesenen Definitionen, das letzte Semicolon ist enthalten (wenn vorhanden), und
         wird als Rückgabewert zurückgeliefert.
         Der Rückgabewert ist die erste Definition, die nicht in Extras enthalten ist,oder auch ein Semicolon, wenn Scanrepeat TRUE ist.
         Wird von ScanForProperties und ScanForFunction verwendet}
        function ScanForExtras(extras : TPascalWords; InputToken : String;out Buffer: String;ScanRepeat :Boolean = FALSE)  : String;

        {CheckForDefinitions ließt eine Reihe von Definitionen ein die durch Leerzeichen getrennt sind, bis ein Semicolon auftaucht,
         und gibt die Reihe ohne Semicolon zurück.
         Der Rückgabewert ist das letzte Semicolon.}
        function CheckForDefinitions(InputToken : String;out Buffer: String) : string;



       {untersuch input, ob es sich dabei um ein PascalWort expectation handelt und liefert bei Erfolg wahr zurück.}
       function Expected(input : String; expectation : TPascalWord) : Boolean; overload;
       function Expected(input : String; expectation : String) : Boolean;overload;

       {untersuch input, ob es sich dabei um ein oder mehrere PascalWorte Expectations handelt und liefert bei Erfolg wahr zurück.}
       function Expected(input : String; Expectations : TPascalWords; out WordResult : TPascalWord) : Boolean; overload;

       {Löst eine Exception aus mit Dateinamen (sofern vorhanden),Zeilenangabe und dem Fehlertext Msg.}
       procedure RaiseException(Msg : String; Position : Cardinal = 0); overload;
       procedure RaiseException(Msg : String; const Args: array of const);overload;

       {zusätzliche Funktionen zur Quelltextanalyse}
       
     public
       constructor Create(Stream : TStream); override;

       {Startet den Scanvorgang und kehrt mit der Unit zurück.
       Fortschritt siehe ScanProgress}
       function DoScan : TUnit;

       {Compilerdefinitionen für den Umgang mit CompilerKonditionen
        derzeit nicht verwendet}
       property UserDefinitions : TStringList read fUserDefinitions;
       property Stream : TPascalStream  read fPStream write fPSTream;


       function IncludeParse(Source: TTextStream; Dest: TStream; IncludePaths : TAStrings; ErrorProc : TIncludeErrorProc = nil) : Cardinal;
     end;

implementation

uses StrUtils;
{$I .\Inc\Utils.pas}
{I .\Inc\TPascalScanner_ScanUnit.pas}



          
function TPascalScanner.IncludeParse(Source: TTextStream; Dest: TStream; IncludePaths : TAStrings; ErrorProc : TIncludeErrorProc = nil) : Cardinal;
{$UNDEF INCLUDEDEFINITIONS}
{$DEFINE INCPARSERIMPLEMENTATION}
{$I .\..\IncludeParser\IncParser.pas}
{$UNDEF INCPARSERIMPLEMENTATION}
begin
  result := PreIncludeParse(Source,Dest,IncludePaths,ErrorProc);
end;


function TPascalScanner.ScanUnit : TUnit;
var Comments : String;

    Declaration,
    Dummy : String;
    WordResult : TPascalWord;
    ii : Integer;
begin
  Dummy := fPStream.ReadToken;
  Comments := fPStream.GetLastComment;

  if not Expected(Dummy,[pw_Unit,pw_library],WordResult) then
    RaiseException('Unit or library expected, but "%s" found!',[Dummy]);

  {Erzeige Unit-Klasse}
  result := TUnit.Create(Declaration);

  result.IsLibrary := WordResult = pw_library;

  //Name lesen
  Declaration := fPStream.ReadToken;
  if Length(Declaration) = 0 then
    RaiseException('Unit or library name expected.');

 //Wenn hier kein Semicolon kommt, dann ist was faul    
  Dummy := fPStream.ReadToken;
  if not Expected(Dummy,';') then
    RaiseException('";" expected, but "%s" found!',[Dummy]);

  result.Name := Declaration;

  result.Comment := Comments;
  result.Declaration := 'unit '+Declaration+';';

  ScanForInterface(result);
end;


{ScanForExtras ließt eine Reihe von Definitionen vom Typ Extras bis zum Semicolon.
 ScanRepeat ließt auch nach dem Semicolon weiter, sofern die Definitionen in Extras enthalten sind.
 Buffer beinhaltet die gelesenen Definitionen, das letzte Semicolon ist enthalten (wenn vorhanden), und
 wird als Rückgabewert zurückgeliefert.
 Der Rückgabewert ist die erste Definition, die nicht in Extras enthalten ist,oder auch ein Semicolon, wenn Scanrepeat TRUE ist.
Wird von ScanForProperties und ScanForFunction verwendet}
function TPascalScanner.ScanForExtras(extras : TPascalWords; InputToken : String;out Buffer: String;ScanRepeat :Boolean = FALSE) : String;
var token,
    OutPutBuffer : String;
    WordType : TPascalWord;
begin
 result := '';
 repeat
    if Length(InputToken) = 0 then
      token := fPStream.ReadToken
    else
     token := InputToken;   //property
    InputToken := '';

  WordType := StringtoPascalWord(token);
  if WordType in extras //[pw_default,pw_dispid,pw_message,pw_read,pw_write]
  then
   begin
     InputToken := CheckForDefinitions(token,OutPutBuffer);
     Buffer := Buffer+OutPutBuffer+InputToken;

     result := InputToken;
     InputToken := '';
     Token := '';

   end
   else
   begin
     result := token;
     exit;
   end;
 until (ScanRepeat and (not (WordType in extras))) or (not ScanRepeat);
end;

{verbesserungsbedürftig
 soll eine reihe von definitionen scannen bis ; erscheint
 trennung durch Leerzeichen nur wo man es darf
Sucht nach weiteren Defintionen für Eigenschafte, wie read, write, index usw}
function TPascalScanner.CheckForDefinitions(InputToken : String;out Buffer: String) : string;
var token,token2,descr : String;
begin
  result := '';
  token:= '';
  repeat
    if Length(Token) = 0 then
    begin
      if Length(InputToken) = 0 then
        token := fPStream.ReadToken //index, read , write,default,
      else
        token := InputToken;
      InputToken := '';

      if token <> ';' then
      begin
        if (Length(descr) > 0) and (Length(Token)>1) then
         descr := descr + ' ';
        descr := descr + token;
      end
      else
      begin
        //result := token;
        break;
      end;
    end;
    token2 := ScanDefinition;

    if token2 <> ';' then
    begin
     if (Length(Token2)>0) and (Upcase(token2[1]) in ['A'..'Z','0'..'9','_','+','-','$']) and
      ((Length(Token) > 0) and not (Upcase(token[1]) in ['+','-','0'..'9','$']))  then
      descr := descr + ' ';
     descr := descr + token2;

      token := fPStream.ReadToken;
      if (token <> ';') then
      begin
        if (Length(descr) > 0) and (Length(Token2)>0) and (Upcase(token2[1]) in ['A'..'Z','0'..'9']) and not (descr[Length(descr)] in ['+','-']) then
       //((Length(Token)>1) or (not (Upcase(Token[1]) in ['A'..'Z']))) then
          descr := descr + ' ';
        descr := descr + token;
      end;
    end
    else
    begin
      token := token2;
      break;
    end;
    {else if token = ';' then
     descr := descr + token;}
  until (token = ';');
 // fPStream.GetPrevChar;
  Buffer := descr;
  result := token;
 // aProperty.Declaration := aProperty.Declaration + descr;
end;



//testen!

function TPascalScanner.ScanFunction(aUnit : TUnit;var Item : TItem; Container : TContainer = nil; InitToken : String = '') : String;


    function ScanParameters(aFunction : TFunction; out  Parameters: String;InputToken : String = '') : String;
        procedure AddParameter(var ParameterName,ParameterType,ParameterDefinitionString,DefaultValue : String);
        var P : TParameter;
        begin
          P := aFunction.AddParameter(ParameterName,PArameterType,ParameterDefinitionString,DefaultValue);
        end;

        {Statt  ScanSequence wird dies verwendet, da flexibler}
        function GetParameterType(out Buffer,DefaultValue :String) : String;
        var Token,LastToken : String;
        begin
          repeat
            Token := FPSTream.ReadToken;
            if Token[1] in [';',')'] then
              begin
                result := Token;
                break;
              end
            else
              if Token[1] in ['='] then
                begin
                  DefaultValue := FPSTream.ReadToken;
               end
              else
                begin //Ende
                  if ((Length(LastToken) = 1) and (LastToken[1] in [':',')','('])) or ((Length(Token) = 1)and (Token[1] in [':',')','('])) or
                     (LEngth(LastToken) <= 0) then
                     Buffer := Buffer + Token
                  else
                    Buffer := Buffer + ' ' +Token;
                  LastToken := Token;
                end;
          until FALSE;
        end;

var token : String;
    WordType : TPascalWord;

    ParameterDefinitionString, //var, const
    ParameterName,
    ParameterType,

    DefaultValue : String;

    ParaNames : array of String;
    i : Integer;

begin
  if Length(InputToken) = 0 then
   Token := fPStream.Readtoken
  else
   Token := InputToken;

  Parameters := '';
  result := Token;
  if Token <> '(' then exit;

  Token := '';

  repeat
    if Length(Token) = 0 then
    begin
      Token := FPStream.ReadToken; //var, const oder Bezeichner

      if StringToPascalWord(Token) in [pw_var,pw_const] then
      begin
        ParameterDefinitionString := Token;
        Token := FPStream.ReadToken; //Bezeichner
      end;

      SetLength(ParaNames,1);
      ParaNames[0] := Token;

      Token := FPStream.ReadToken; //:,; oder )
    end;

    if Token[1] in [','] then
      begin
        SetLength(ParaNames,Length(ParaNames)+1);

        Token := FPStream.ReadToken;
        ParaNames[Length(ParaNames)-1] := Token;

        Token := FPStream.ReadToken;
    end;

    if Token[1] in [';',')'] then
    begin
      if Length(Parameters) > 0 then
        Parameters := Parameters + ';';
      if Length(ParameterDefinitionString) > 0 then
          ParameterDefinitionString := ParameterDefinitionString + ' ';

      Parameters := Parameters + ParameterDefinitionString;

      for i := 0 to Length(ParaNames)-1 do
      begin
        ParameterName := ParaNames[i];

        AddParameter(ParameterName,PArameterType,ParameterDefinitionString,DefaultValue);
        if i < Length(ParaNames)-1 then
         ParameterName := ParameterName + ',';

        Parameters := Parameters + ParameterName;
      end;

      if Length(PArameterType) > 0 then
        PArameterType := ':'+PArameterType;
      if Length(DefaultValue) > 0 then
        DefaultValue := '='+DefaultValue;

      Parameters := Parameters + PArameterType + DefaultValue;

      ParameterName := '';
      PArameterType := '';
      ParameterDefinitionString := '';
      DefaultValue := '';

      SetLength(ParaNames,1);

      if (Length(Token) > 0) and (Token[1] <> ')') then
      begin
        Token := '';
        continue;
      end;
   end;

    if (Length(Token) > 0) and (Token[1] = ')') then
    begin
      result := fPStream.ReadToken;
      break;
    end
    else
    if Token[1] = ':' then
    begin
      Token := GetParameterType(PArameterType,DefaultValue); // -> ;
      //AddParameter(ParameterName,PArameterType,ParameterDefinitionString,DefaultValue,     Parameters);
      {if Token[1] = ';'
      Token := '';   }
    end;

  until FALSE;
end;    {END ScanParameters}




var Dummy,
    Token,
      //Textcontainer
    aComment, //Kommentarcontainer
   // Declaration, //procedure/function unterscheidung
    ParameterDeclaration, //vollständige Parameterdeklaration
    Parameters,//alle PArameter innerhalb von ( und )
    Buffer,
    Return : String; //Rückgabewert der funktion
    ii,i : TPascalWord;
    Closed : Boolean;
    aFunction : TFunction;
    //einzelne Parameter
    ParameterName, //Para-Name
    ParameterType, //Parametertyp
    ParameterDefinition //Übergabeart : var,const
                        : String;
begin
  if Length(InitToken) = 0 then
  begin
    InitToken := fPSTream.ReadToken;
  end;


  if not Assigned(Item) then
  begin
    aFunction := TFunction.Create(InitToken);
    item := aFunction;
    item.Comment := fPStream.GetLastComment;
  end;
  aFunction := TFunction(item);

  aComment := fPStream.GetLastComment; //zwischen jedem Readword die comments herrausnehmen - zukünftig auch compilerdirektiven
  if (aFunction.Comment = '') then
   aFunction.Comment := LastComment;

  if (aFunction.DeclarationType = dt_none) and (aFunction.Declaration = '') then
  begin
   aFunction.Declaration := fPStream.ReadToken; //wenn unbekannt, ob procedure oder function
  end
  else
  begin
  end;


  if aFunction.DeclarationType <> dt_type then  //Methoden und proceduren/functionen besitzen Namen, typen aber nicht
  begin
    if aFunction.DeclarationType <> dt_method then //bei methoden wird der name schon in aFunction gelesen
      aFunction.Name := fPStream.ReadToken; //procedure/function Name
    aFunction.Declaration := aFunction.Declaration + ' ' +aFunction.Name;
  end
  else
  if aFunction.DeclarationType = dt_type then //
  begin
    aFunction.Declaration := aFunction.Name+'=' + aFunction.Declaration;
  end;



  dummy := ScanParameters(aFunction,Parameters,'');


  if Parameters <> '' then
   aFunction.Declaration := Format('%s(%s)',[aFunction.Declaration,Parameters]);


  if (aFunction.IsProcedure) or (aFunction.IsConstructor) or (aFunction.IsDestructor) then
  begin
    if dummy <> ';' then
     dummy := fPStream.ReadToken; // ;
    if dummy = ';' then   //da kommt noch was - wohl ein of object?
    begin
      aFunction.Declaration := aFunction.Declaration + dummy;
      dummy := '';
    end;

  end
  else


  begin
    if dummy <> ':' then
    begin
     dummy := fPStream.ReadToken; // :
     //ASSERT(Expected(dummy,':'),'":" expected.');
     if not Expected(dummy,':') then
      RaiseException('; expected instead of %s',[dummy]);
    end;
    aFunction.Declaration := aFunction.Declaration + Dummy;

    aFunction.Return := fPStream.ReadToken; // Result
    aFunction.Declaration := aFunction.Declaration + {' ' +}aFunction.Return;

    dummy := fPStream.ReadToken; // ;
    if dummy = ';' then
    begin
      aFunction.Declaration := aFunction.Declaration + dummy;
      dummy := '';
    end;
  end;

  LastComment := fPStream.GetLastComment; //für pw_none wird ein kommentar miteingelesen

  begin
    result := '';
    dummy := '';
    result := ScanForExtras(MethodDefinitions+FuncDefinitions,'',buffer,TRUE);

    if StringToPascalWord(Result) = pw_None then
    begin
      RaiseException('Unknown word "%s". Next statement expected',[result]);
    end;

    aFunction.SingleComment := fPStream.GetSingleComment;

    aFunction.Declaration := aFunction.Declaration + Buffer;

    if not Assigned(Container) then
      aUnit.Items.Add(aFunction)
    else
    begin
      Container.Items.Add(aFunction);
      aFunction.ParentClass := TOCIItem(Container);
    end;

    if Length(result) = 0 then
    begin
    //  aFunction.Comment := fPStream.GetSingleComment;
      result := fPStream.ReadToken;
    end;

   // exit;
  end;

(*  aFunction.ParentClass := TOCIItem(Container);
  aUnit.Items.Add(aFunction);

  result := fPStream.ReadToken;      *)
end;

function TPascalScanner.ScanForRecord(aUnit : TUnit;var Item : TRecord) : String;
var Dummy,aComment,aName : String;
    aWordType,aDeclarationType : TPascalWord;
    Begins : Integer;
    aBaseVariable : TBaseVariable;
    over,ii : Integer;
    childs : String;
begin
  //Man scannt nur nach !einem! Record
  //es gibt auch
  //ret
  repeat
     //Dummy := FPStream.ReadToken;
     dummy := ScanForVariables(aUnit,TContainer(Item));
     aWordType := StringtoPascalWord(dummy);

     
     if aWordType = pw_end then
     begin
       break;
     end
     else
     if aWordType = pw_case then
     begin
       repeat
         dummy := FPStream.ReadToken(TRUE);
         if aWordType = pw_end then
         begin
           break;
         end;
         over := 0;

         fPStream.ReadText(aName,'end',over,FALSE);
         //fPStream.GetPrevChars(Length('end'));


         aName := 'case '+dummy+' '+aName;
         aBaseVariable := TBaseVariable.Create(aName);

         //noch nicht fertig!!!!!!!
         Item.Items.Add(aBaseVariable);

         begin
           aWordType := pw_end;
           break;
         end;

       until FALSE;
     end;
  until aWordType = pw_end;

  Dummy := FPStream.ReadToken;
  if not Expected(dummy,';') then RaiseException(Format('"%s" expected, but "%s" found.',[';',dummy]));

  if Item.IsPacked then
   dummy := 'packed '
  else
   dummy := '';

  childs := '';
  for ii := 0 to Item.Items.Count -1 do
  begin
    if Length(childs) > 0 then
     childs := Childs + #13#10;
    childs := childs + TItem(Item.Items[ii]).Declaration;
  end;

  Item.Declaration := Item.Name + '='+dummy+'record'+#13#10+childs+#13#10+'end;';


  result := '';
end;

function TPascalScanner.ScanDefinition : String;
var dummy : String;
    brackets,brackets2 : Integer;
begin
  result := '';
  brackets := 0;
  brackets2 := 0;
  repeat
    dummy := fPStream.ReadToken;
    if (Dummy = '(') then
     Inc(brackets)
    else
     if (Dummy = ')') then
      Dec(brackets)
    else
    if (Dummy = '[') then
     Inc(brackets2)
    else
     if (Dummy = ']') then
      Dec(brackets2)
    else
    if (brackets = 0) and (brackets2 = 0) then
    begin
      if Length(Result) = 0 then
       result := dummy;
      break;
    end;
    if (Length(Dummy) > 1) and (Length(result) > 0) then
     result := Result + ' ' +dummy
    else
     result := Result + dummy;
  until (Brackets = 0) and (Brackets2 = 0);
end;



function TPascalScanner.ScanSequence(out Buffer : String) : String;
var dummy,lastDummy : String;
    brackets,strings : Integer;
    strdummy : String;
    c,nc : Char;
begin
  result := '';
  brackets := 0;
  strings := 0;
 // strdummy := 'asdf ''  dfsadf '' ';
  dummy := '';
  repeat
    lastDummy := dummy;
    //Buffer;
    try
     dummy := fPStream.ReadToken;
    except
      on e: Exception do
        RaiseException(e.Message );
    end;

    if (dummy = '(') then
      Inc(brackets)
    else
     if (dummy = ')') then
       Dec(brackets)
    else
    if ((dummy = ';') or (dummy = '=')) and (brackets = 0) then
    begin
      break;
    end;
    if (Length(dummy) > 1) and (Length(dummy) > 0) and (Length(lastDummy) > 1) then
     Buffer := Buffer + ' ' +dummy
    else
     Buffer := Buffer + dummy;
  until ((dummy = ';') or (dummy = '=')) and (Brackets = 0);

   result := dummy;
end;

function TPascalScanner.ScanForConstants(aUnit : TUnit; Container : TContainer) : String;
var Dummy,aComment,aName,aType,aValue : String;
    aWordType : TPascalWord;
    Begins : Integer;
    aConstant : TConstant;
begin
  { const asdf = 123;
          asdf : asdfe = 123;
  }
  repeat                                                
    dummy := '';
    aName := fPStream.ReadToken; //Name oder etwas unbekanntes, dass keine Konstante ist

    aWordType := StringtoPascalWord(aName);
    if aWordType <> pw_none then
    begin
      dummy := aName;
      break;
    end;

    aComment := fPStream.GetLastcomment;

    dummy := fPStream.ReadToken; // = oder ; ?
    if dummy = '=' then //variable constant
    begin
      dummy := ScanSequence(aValue);
    end
    else
    if dummy = ':' then
    begin
      dummy := ScanSequence(aType);
      //dummy := fPStream.ReadToken; // =
      if not Expected(dummy,'=') then
       RaiseException(Format('"%s" expected, but "%s" found.',['=',dummy]));
      //aValue :=
      dummy := ScanSequence(aValue);
    end
    else
     RaiseException(Format('":" or "=" expected, but "%s" found.',[dummy]));

    if Length(Dummy) = 0 then
      dummy := fPStream.ReadToken; // ;
    if not Expected(dummy,';') then
     RaiseException(Format('"%s" expected, but "%s" found.',[';',dummy]));

    if (aName <> '') and (aValue <> '') then
    begin
      dummy := aName;
      if (aType <> '') then
       Dummy := dummy + ':'+aType;

      dummy := dummy + '='+ aValue;
      dummy := dummy + ';';

      aConstant := TConstant.Create(dummy);
      aConstant.Name := aName;
      aConstant.TypeString := aType;
      aConstant.Value := aValue;
      aConstant.Comment := aComment;
      aConstant.Parent := Container;

      if Assigned(aUnit) then
       aUnit.Items.Add(aConstant);

      aConstant.SingleComment := fPStream.GetSingleComment;

      aName := '';
      aType := '';
      aValue:= '';
    end;

  until FALSE;
  result := dummy;
end;

function TPascalScanner.ScanForVariables(aUnit : TUnit; Container : TContainer = Nil; Visibility : TVisibility = vnone; InputToken : String = '') : String;
var Dummy,aComment,aName,aType,aValue : String;
    aWordType : TPascalWord;
    Begins,ii : Integer;
    BaseVariable : TBaseVariable;
    List : TStringList;
begin
  {var
       as : Integer;
       as : Integer = 0;
       X, Y, Z: Double;
       Digit: 0..9;

  }
  List := TStringList.Create;
  aComment := '';
  repeat
    //Scan nach variablen
    repeat
      if Length(InputToken) = 0 then
       aName := fPStream.ReadToken //Name
      else
      begin
        aName := InputToken;
        InputToken := '';
      end;

      if Length(fPStream.Lastcomment) > 0 then
       aComment := fPStream.GetLastcomment;

      List.Add(aName+'='+aComment);

      aWordType := StringtoPascalWord(aName);
      if aWordType <> pw_none then
      begin
        result := aName;
        exit;
      end;


      dummy := fPStream.ReadToken;
      if (not Expected(dummy,':')) and (not Expected(dummy,',')) then RaiseException('":" ord "," expected');
    until (dummy = ':');

    //aType :=
    dummy := ScanSequence(aType);//Typ
//    dummy := fPStream.ReadToken; // = oder ; ?
    if (dummy = '=') and (List.Count = 1) then //variable constant
    begin
      //aValue :=
      dummy := ScanSequence(aValue);
//      dummy := fPStream.ReadToken; // ;
    end
    else
    if (dummy = '=') and (List.Count > 1) then
    begin
      RaiseException(Format('%s expected, but %s found.',[';',dummy]));
    end;

    if (Dummy <> '=') and (Dummy <> ';') then
     if not Expected(dummy,';') then
       RaiseException('";" expected');

    if (aName <> '') and (aType <> '') then
    begin
      for ii := 0 to List.Count -1 do
      begin
        aName := List.Names[ii];
        dummy := aName + ':'+aType;
        if (aValue <> '') then
         dummy := dummy + '=' + aValue;
        dummy := dummy + ';';

        BaseVariable := TBaseVariable.Create(dummy);
        BaseVariable.Name := aName;
        BaseVariable.TypeString := aType;
        BaseVariable.Value := aValue;
        try
         BaseVariable.Comment := List.Values[List.Names[ii]];
        except
         BaseVariable.Comment := '';
        end;
        BaseVariable.Parent := Container;
        BaseVariable.Visibility := Visibility;

        BaseVariable.SingleComment := fPStream.GetSingleComment;

        if Assigned(aUnit) and not Assigned(Container) then
          aUnit.Items.Add(BaseVariable)
        else
        if Assigned(Container) then
         Container.Items.Add(BaseVariable)
        else
         RaiseException('ScanForVariables: aUnit or Container must be defined.')
      end;
      List.Clear;
      aName := '';
      aType := '';
      aValue:= '';
      dummy := '';
    end;


  until FALSE;

  result := Dummy;
end;


function TPascalScanner.ScanForTypes(aUnit : TUnit; Token : String = '') : String;

function CheckExit(Dummy : String) : boolean;
begin
  result := (StringtoPascalWord(dummy) in [pw_function,pw_procedure,pw_var,pw_type,pw_const,pw_implementation,pw_set,pw_array,pw_record,pw_packed])
end;

function PW2ClassType(pw : TPascalWord) : TIOClassType;
begin
  case pw of
    pw_class           : result := ct_class;
    pw_interfaceclass  : result := ct_interface;
    pw_object          : result := ct_object;
    pw_dispinterface   : result := ct_dispinterface;
  else
   RaiseException('ScanForTypes.PW2ClassType unknown ClassType')
  end
end;



var Dummy,aName,aTypeString,Comment : String;
    aWordType : TPascalWord;
    aFunction : TTypeFunction;
    aType : TType;
    aRecord : TRecord;
    aOCI : TOCIItem;
begin
repeat
  if dummy <> '' then
   aName := dummy
  else
   aName := fPStream.ReadToken; //Name


  if CheckExit(aName) then
  begin
    dummy := aName;
    break;
  end;

  Comment := fPStream.GetLastComment;

  if not Expected(fPStream.ReadToken,'=') then
   RaiseException('"=" expected, but "%s" found.',[dummy]);


  dummy := fPStream.ReadToken; // procedure, class, object, record sonst einfach alles übernehmen -> ELSE

  aWordType := StringtoPascalWord(dummy);
  case aWordType of
    pw_procedure,pw_function : begin
                                  aFunction := TTypeFunction.Create('');
                                  aFunction.Declaration := SPascalWord[aWordType];
                                  aFunction.Name := aName;
                                  aFunction.Comment := Comment;
                                  aFunction.DeclarationType := dt_type;
                                  dummy := ScanFunction(aUnit,TItem(aFunction),nil,dummy);
                                end;
    pw_record,pw_packed : begin
                  aRecord := TRecord.Create('');
                  aRecord.Name := aName;
                  aRecord.Comment := Comment;

                  aUnit.Items.Add(aRecord);
                  {da fehlt noch ein record}
                  if aWordType = pw_packed then
                  begin
                    dummy := fPStream.ReadToken; //record
                    if StringtoPascalWord(dummy) <> pw_record then
                     RaiseException(Format('record expected, but %s found.',[dummy]));
                  end;

                  dummy := ScanForRecord(aUnit,aRecord);
                  //aWordType,aDeclarationType,aName,Comment);
                  //RaiseException('ScanForType : Records are not supported yet.');
                end;
    pw_class,pw_interfaceclass,pw_dispinterface,pw_object :
                 begin
                   aOCI := TOCIItem.Create('',PW2ClassType(aWordType));
                   aOCI.Name := aName;
                   aOCI.Comment := Comment;
                   aOCI.DeclarationType := dt_Type;
                   dummy := ScanOCI(aUnit,aOCI);
                 end;

  else
   begin
   //unbekanntes material, normalerweise von ; begrenzt
   //type XY = 1..9;
   //Type blub = array of char;
   //type bf = string[5];
   aTypeString := dummy;
   repeat
      dummy := fPStream.ReadToken;
      if Length(dummy) > 1 then
       Dummy := ' ' +Dummy;

      aTypeString := aTypeString+dummy;
      aWordType := StringtoPascalWord(dummy);
   until (dummy = ';');


   aType := TType.Create(aName +' = '+ aTypeString);
   aType.Name := aName;
   aType.Comment := Comment;
   aType.TypeString := LeftStr(aTypeString,Length(aTypeString)-1);
   aUnit.Items.Add(aType);

    dummy := fPStream.ReadToken; //nächstes einlesen für das Schleifenende
   end;
  end;
until CheckExit(dummy);
  result := dummy
end;


function TPascalScanner.ScanForProperties(aUnit : TUnit; Container : TOCIItem; Visibility : TVisibility; InputToken : String ='') : String;
const PropertyTypes = [pw_read,pw_write,pw_index,pw_stored,pw_default];

var token,token2,outputbuffer,name,declaration,extras,addition,typeString,comment : String;
    aProperty : TProperty;
    WordType : TPascalWord;
    overhead : Integer;
    IsClosed : Boolean;

(*
property Size: Integer read FSize;
property Size: Integer read GetText write SetText;
property Size: Integer read FColor write SetColor stored False;
property Size: Integer read FTag   write FTag     default 0; ->> nodefault??
property Left: Longint index 0 read GetCoordinate write SetCoordinate;


property Strings[Index: Integer]: string ...; default;
property Coordinates[Index: Integer]: Longint read GetCoordinate write SetCoordinate;

property Options: TVTHeaderOptions read FOptions write SetOptions default [hoColumnResize, hoDrag, hoShowSortGlyphs];

property Text;
*)



begin
  repeat
    if (Length(InputToken) = 0) then
    begin
      if Length(Token) = 0 then
        token := fPStream.ReadToken   //property
    end
    else
      token := InputToken;

      InputToken := '';

    WordType := StringtoPascalWord(token);
    if WordType <> pw_property then
    begin
      result := token;
      break;
    end;

    comment := fPStream.GetLastComment;

    overhead := 0;
    //Name
    Name := '';
    Token := '';
    repeat
      if Length(Name) > 1 then
       Name := Name + ' ' + Token
      else
       Name := Name + Token;
      token := fPStream.ReadToken;
    until (Length(Token) <= 0) or (Token[1] in [':',';','[']);
    //fPSTream.GetPrevChar; // !!!!!!!! ob das zulässig ist? ':',';','[' einlesen

    aProperty := TProperty.Create('');
    aProperty.Name := Name;
    aProperty.Comment := comment;
    Container.Items.Add(aProperty);

    if Length(Token) = 0 then
      token := fPStream.ReadToken;   //[,; oder Typ
    if token = '[' then              //liest einen Index ein in []:  bla[...] : das
    begin
      IsClosed := FALSE;
      addition := '';
      repeat
       if (Length(addition) > 1) and (Length(token) > 1) and (Upcase(token[1]) in ['A'..'Z','0'..'9']) then
        addition := addition + ' ' + Token
       else
        addition := addition + Token;
       token := fPStream.ReadToken;
       if token = ']' then IsClosed := TRUE;
      until (Length(Token) <= 0) or ((Token[1] in [':',';']) and IsClosed);
    end
    else

    {überschriebene Eigenschaft, ohne Typ}
    if token = ';' then
     begin
       token := ScanForExtras(PropertyDefinitions,'',extras,TRUE);
       aProperty.Declaration := Format('property %s%s;%s',[aProperty.Name,addition,extras]);
       aProperty.SingleComment := fPStream.GetSingleComment;

       result := ScanForProperties(aUnit,Container,Visibility,token); //next property
       exit;
     end;

    //Type
    aProperty.TypeString := fPStream.ReadToken;

    token := ScanForExtras(PropertyDefinitions,'',extras, FALSE);

   if token <> ';' then
    RaiseException('ScanForProperties: ";" expected but found : '+token);


   //Scannt nach der Eigenschaftsdefinition - default, usw
   token := ScanForExtras(PropertyDefinitions,'',Declaration, TRUE);


    if Length(extras) > 0 then
     Insert(' ',extras,1);
    if (Length(extras) = 0) and (Length(Declaration) = 0) then
     extras := ';';

    aProperty.SingleComment := fPStream.GetSingleComment;

    aProperty.Declaration := Format('property %s%s:%s%s%s',[aProperty.Name,addition,aProperty.TypeString,extras,Declaration]);


    addition := '';
    extras := '';
    Declaration := '';

//    token := fPStream.ReadToken; //extra definition nach ;
//    token := fPStream.ReadToken; //; or write}
    





  until FALSE;
end;

function TPascalScanner.ScanOCI(aUnit : TUnit; var Container : TOCIItem) : String;
  function PW2Visibility(pw: TPascalWord) : TVisibility;
  begin
    case pw of
       pw_private      : result := vprivate;
       pw_protected    : result := vprotected;
       pw_public       : result := vpublic;
       pw_published    : result := vpublished;
    else
     result := vnone;
    end;
  end;

var Dummy,guidstr,Comment,Name,TypeString : String;
    WordType : TPascalWord;
    aType : TType;
    anAncestor : PAncestor;
    Visibility : TVisibility;
    aFunction : TFunction;
    overhead : Integer;
    aName,Declarationtype,Ancestors : String;
begin
  result := '';
  
  Dummy := fPStream.ReadToken; //
  WordType := StringtoPascalWord(dummy);

//  if Container.DeclarationType = dt_obj

  if WordType = pw_of then // of Klassendeklaration
  begin

    Name := fPStream.ReadToken; //Typ

    dummy := fPStream.ReadToken; //;
    if not Expected(dummy,';') then RaiseException('ScanForType : ";" expected');

    TypeString := 'class of '+Name+dummy;
    aType := TType.Create(Container.Name+'='+TypeString);
    aType.Name := Container.Name;
    aType.TypeString := TypeString;
    aType.Comment := Container.Comment;
    aType.SingleComment := fPStream.GetSingleComment;

    aUnit.Items.Add(aType);

    FreeAndNil(Container);
    exit;
  end;

  Ancestors := '';
  if Dummy = '(' then {Vorfahren - ancestors}
  begin
    repeat
      dummy := fPStream.ReadToken;
      if dummy = ')' then break;
      if Length(dummy) > 1 then
      begin
        //anAncestor.
        anAncestor := CreateAnchestorPtr(TRUE);
      //  anAncestor.NameType := TRUE;
        anAncestor^.NameString := dummy;
        Container.Ancestors.Add(anAncestor);
        if Length(Ancestors) > 0 then
         Ancestors := Ancestors+',';
        Ancestors := Ancestors+Dummy;
      end;
    until FALSE;
    dummy := '';
  end;

//  if (ct_interface = Container.Kind) or (ct_dispinterface = Container.Kind) then
  if (Container.Kind in [ct_interface,ct_dispinterface]) then
  begin
    //['{EE05DFE2-5549-11D0-9EA9-0020AF3D82DA}']
    dummy := fPSTream.ReadToken;
    if dummy = '[' then
    begin
      dummy := fPSTream.ReadToken; //ließt ' ein
      fPStream.GetPrevChar;   //funktioniert
      guidstr := fPStream.ReadString;


      dummy := fPSTream.ReadToken; //ließt ] ein
      Container.Guid := StringToGUID(guidstr);
//      guidstr := GUIDtoString(Container.Guid);
      dummy := '';
    end;


  end;

  Visibility := vPrivate;

  {die Untereinträge analysieren}

  repeat
    if Length(dummy) = 0 then
     dummy := fPStream.ReadToken;
    Comment := fPStream.LastComment;
    WordType := StringtoPascalWord(dummy);

    case WordType of
       pw_end : break;
       pw_private,pw_protected,pw_public,pw_published : begin Visibility := PW2Visibility(WordType); dummy := '';end;
       pw_class, //Klassenmethode
       pw_function,pw_procedure,pw_constructor,pw_destructor :
                                  begin
                                    aFunction := TFunction.Create('');
                                    aFunction.Declaration := SPascalWord[WordType];

                                    if WordType = pw_class then  //klassen methode - diese Methode gehört zu einer Klasse und nicht zur Instanz!
                                    begin
                                      Dummy := fPStream.ReadToken; //procedure/funktion ... einlesen
                                      aFunction.Declaration := SPascalWord[WordType] + ' ' +dummy;
                                      if not (StringToPascalWord(Dummy) in [pw_function,pw_procedure,pw_constructor,pw_destructor]) then
                                        RaiseException('ScanOCI: Class definition can only be used with methods! "%s" found, but method type expected.',[dummy]);
                                    end;

                                    aName := fPStream.ReadToken;
                                    aFunction.Name := aName;
                                    aFunction.Comment := Comment;
                                    aFunction.DeclarationType := dt_method;
                                    aFunction.Visibility := Visibility;
                                    dummy := ScanFunction(aUnit,TItem(aFunction),Container,dummy);
                                    if dummy = '' then;
                                  end;
       pw_property : begin
                       Dummy := ScanForProperties(aUnit,Container,Visibility,dummy)
                     end;
     else
      //Variablen oder ";"
      begin
       if WordType <> pw_none then //Wenn es sich um etwas bekanntes handelt, dass nicht in case definiert wurde, dann ist es hier fehl am platz
       begin
         RaiseException('Instruction "%s" misplaced, "end" expected!',[dummy]);
       end;

    
        if Dummy <> ';' then
        begin
          dummy := ScanForVariables(aUnit,Container,Visibility,dummy);
        end
        else
         break;
      end;
    end;


  until FALSE;

  case Container.Kind of
    ct_class   : Declarationtype := 'class';
    ct_object  : Declarationtype := 'object';
    ct_interface : Declarationtype := 'interface';
    ct_dispinterface : Declarationtype := 'dispinterface';
  end;

  //Es wird keine vollständige deklaration vorgenommen, weil sowas sehr groß ist.
  Container.Declaration := Format('%s=%s(%s);',[Container.Name,Declarationtype,Ancestors]);
//  Container.Name + '='+Declarationtype+'('+Ancestors+')';

  aUnit.Items.Add(Container);

  dummy := fPStream.ReadToken; //;
  if not Expected(dummy,';') then RaiseException('ScanOCI : ";" expected, but found :'+dummy);
  result := '';
end;


procedure TPascalScanner.ScanForDefinitions(aUnit : TUnit; InputToken : String = '');
var Dummy,Comment,Name : String;
    WordType,DeclarationType : TPascalWord;
    aFunction : TFunction;
begin
  dummy := '';
  repeat
   if dummy = '' then
   begin
     if Length(InputToken) = 0 then
       dummy := fPStream.ReadToken
     else
     begin
       dummy := InputToken;
       InputToken := '';
     end;

     WordType := StringtoPascalWord(dummy);
     //DeclarationType := pw_none;
     Name := '';
   end;
   case WordType of
     pw_type : begin
                   DeclarationType := WordType;
                   {Scannt solange bis kein Typen-Deklaration mehr auftritt}
                   dummy := ScanForTypes(aUnit,Dummy);
                 end;
     pw_procedure,pw_function   : begin
                                  aFunction := TFunction.Create('');
                                  aFunction.Declaration := SPascalWord[WordType];
                                  aFunction.Comment := fPStream.GetLastComment;

                                  dummy := ScanFunction(aUnit,TItem(aFunction),nil,dummy);
                                end;
     pw_var : begin
                Dummy := ScanForVariables(aUnit,nil);
              end;
     pw_const : begin
                  Dummy := ScanForConstants(aUnit,nil);
                end;
     pw_implementation : exit;
     pw_begin : begin
                  if not aUnit.IsLibrary then
                    RaiseException('Code lines are not supported in an interface part! Sorry!')
                  else
                    exit;
                end;
     pw_exports : begin
                    if not aUnit.IsLibrary then
                      RaiseException('"Exports" directive is only allowed in a library.')
                    else
                      exit;
                  end;
   else
   begin
     RaiseException('ScanForDefinitions : "%s" is not supported yet or unknown instruction. Sorry don''t know what to do.',[dummy]);
     dummy := '';
   end;
   end;
   if dummy <> '' then
   begin
     if StringtoPascalWord(dummy) <> pw_none then //wenn pw_none auftritt handelt es sich wohl um einen Bezeichner innerhalb von Type
      WordType := StringtoPascalWord(dummy);
   end;
  until FALSE;
end;

function TPascalScanner.ScanForInterface(aUnit : TUnit) : String;
var Dummy : String;
begin
  if not Assigned(aUnit) then
   Raise Exception.Create('ScanForInterface : aUnit must not be nil');


  //interface wird nur bei units erwartet
  if not aUnit.IsLibrary then
  begin
    dummy := fPStream.ReadToken;
    if not Expected(dummy,pw_Interface) then
      RaiseException('Interface expected!');
  end;

  dummy := fPStream.ReadToken;
  if CompareText(dummy,'uses') = 0 then //Alle uses Klauseln überspringen
  begin
    repeat
      dummy := fPStream.ReadToken;   //Unit Name und "," sowie ";"
      if (Length(Dummy) > 1) then
        aUnit.UsesUnits.Add(Dummy);
      if dummy = ';' then break;
    until FALSE;
    dummy := '';
  end;

  ScanForDefinitions(aUnit,dummy);
end;

constructor TPascalScanner.Create(Stream : TStream);
begin
  inherited Create(Stream);
  if not (Stream is TPascalStream) then
   raise Exception.Create('Invalid StreamType! TPascalScanner needs a class descendant of TTextStream');
  fPStream := TPascalStream(Stream);

  fDefinitions := TStringList.Create;//nicht sortieren!


  fUserDefinitions := TStringList.Create;
  fUserDefinitions.Sorted := TRUE;
  fUserDefinitions.Duplicates := dupIgnore;
end;

procedure TPascalScanner.RaiseException(Msg : String; const Args: array of const);
begin
  RaiseException(Format(Msg,Args));
end;

procedure TPascalScanner.RaiseException(Msg : String; Position : Cardinal = 0);
var s : String;
begin
  if Position > 0 then
   s := 'Char : '+IntToStr(Position)
  else
   s := '';
  raise Exception.Create(Format(#10#13'Error in File "%s" Line : %d  %s'#10#13+'Source: "%s"'#10#13'Errormessage:'#10#13'"%s"',[fPStream.FileName,fPStream.ReadLineNumber,s,fPStream.ReadLine(TRUE),Msg]));
end;


function TPascalScanner.Expected(input : String; expectation : TPascalWord) : Boolean;
begin
  input := RemoveSpaces(input);
  result := CompareText(Input,SPascalWord[expectation]) = 0;
end;

function TPascalScanner.Expected(input : String; expectation : String) : Boolean;
begin
  input := RemoveSpaces(input);
  result := CompareText(Input,expectation) = 0;
end;

function TPascalScanner.Expected(input : String; Expectations : TPascalWords; out WordResult : TPascalWord) : Boolean;
var ii : TPascalWord;
begin
  result := FALSE;
  input := RemoveSpaces(input);
  WordResult := pw_None;
  for ii := pw_none to pw_implementation do
  begin
    result := (ii in Expectations) and (CompareText(Input,SPascalWord[ii]) = 0);
    if result then
    begin
      WordResult := ii;
      exit;
    end;
  end;
end;


function TPascalScanner.DoScan : TUnit;
begin
  fPStream.Position := 0;
  fUnit := ScanUnit;
  result := fUnit;
end;

end.




 {Parameter untersuchen}
  Closed := TRUE;
  AllowNextToken := TRUE;
  Token := '';
  repeat
    {abc : array of name
     abc : type}
   // if Length(Token) = 0 then
    if AllowNextToken then
     Token := fPStream.ReadToken; //( + Parameter + )
    AllowNextToken := TRUE;

    if (Token <> '(') and (Parameters = '') then  //
     break
    else
     if (Token = '(') then
     begin
       Closed := FALSE;
     //  Token := '';
     end
     else
      if (Token <> ')') and (Token <> ';') and (Token <> ':') then
      begin
       ii := StringtoPascalWord(Token);
       if (ii in [pw_var,pw_const] ) then
        begin
          ParameterDefinition := lowercase(Token);
          Insert(' ',Token,Length(Token)+1);
     //     Token := '';
        end
        else
          if (ParameterName = '') then
          begin
            ParameterName := Token;
        //    Token := '';
          end
          else
            if (ParameterType = '')then
              begin
                ParameterType := Token;  //sichern

                Token := fPStream.ReadToken; //erweiterter Parametertyp

                ii := StringtoPascalWord(Token);
                if ii = pw_of then  //entweder ein Array of
                  begin
                    ParameterDeclaration := ParameterType + ' ' + Token;

                    ParameterDeclaration := ParameterDeclaration + ' ' + fPStream.ReadToken; //erweiterter Parametertypname
                    Token := ParameterDeclaration;
                    ParameterType := ParameterDeclaration;
                  end
                  else
                  if pos('=',Token) > 0 then //oder ein Default
                    begin
                      ParameterDeclaration := ParameterType + {' ' +} Token;

                      ParameterDeclaration := ParameterDeclaration + {' ' +} fPStream.ReadToken; //default wert
                      Token := ParameterDeclaration;
                      ParameterType := ParameterDeclaration;
                    end
                  else
                  begin
                   // fPStream.GetPrevChars(Length(Token)); // !!!!!!!!!!!!!!!!
                   AllowNextToken := FALSE;
                   Token := ParameterType;
                  //           Token := '';
                  end;
              end;
      end;



    Parameters := Parameters + Token;

    if (Token = ')') or ((Token = ';') and Closed) then
    begin
      if (ParameterName <> '') and (ParameterType <> '') then
       aFunction.AddParameter(ParameterName,ParameterType,ParameterDefinition);
      ParameterName := '';
      ParameterType := '';
      ParameterDefinition := '';
      break;
    end
    else
    if (ParameterName <> '') and (ParameterType <> '') then
    begin
      aFunction.AddParameter(ParameterName,ParameterType,ParameterDefinition);
      ParameterName := '';
      ParameterType := '';
      ParameterDefinition := '';
   //   Token := '';
    end;
  until FALSE;















************************************************************


property code
    case WordType of
      pw_property : begin
                      aProperty := TProperty.Create('');
                    end;
    {  pw_read : aProperty.ReadOnly := TRUE;
      pw_write : aProperty.ReadOnly := FALSE; }
{      pw_end : begin
                 result := Token;
                 exit;
               end;}
     else
     begin
       if WordType <> pw_none then
       begin
         result := Token;
         break;
       end;

       //Token := '';
       WordType := pw_None;
       //Name
       repeat
         if ((Length(Token) = 1) or (Length(Token) = 0)) or (Length(Name)=0) then
          Name := Name + Token
         else
          Name := Name + ' '+ Token;

         token := fPStream.ReadToken;
         if (token = ';') or (token = ':') then
         begin
           token := '';
           break
         end
         else
         begin //stored
           WordType := StringtoPascalWord(token);
           if (WordType in PropertyTypes) then
            break;
         end;
       until FALSE;
       aProperty.Name := Name;

       if Length(Token) = 0 then
         Token := fPStream.ReadToken;

       if (Token = ';') then
       begin
         aProperty.Declaration := 'property '+aProperty.Name+';';
         break;
       end;


       {Type :
        nur Typ ermitteln, wenn es sich nicht um ein überschriebene Eigenschaft handelt
        }
       if WordType = pw_none then
       begin
        // Token := '';
         Name := '';
         repeat
           if (Length(Token) > 1) then
            Name := Name + Token
           else
            Name := Name + ' '+ Token;
           token := fPStream.ReadToken;
           WordType := StringtoPascalWord(token);
         until (token = ';') or (WordType in PropertyTypes);
         aProperty.TypeString := Name;
       end;

       if WordType = pw_none then
        token := fPStream.ReadToken;
       //Alle sonstigen Werte ermitteln
       repeat
         if token = ';' then
          break
         else
         begin
          if Length(Declaration) > 1 then
           declaration := declaration + ' ';
          declaration := declaration + token;
         end;
         token := fPStream.ReadToken;

         WordType := StringtoPascalWord(token);
         case WordType of
           pw_read : aProperty.ReadOnly := TRUE;
           pw_write : aProperty.ReadOnly := FALSE;
         end;
       until FALSE;

       if LEngth(aProperty.TypeString) > 0 then
        typeString := ':'+aProperty.TypeString
       else
        typeString := '';
       if Length(declaration) > 0 then
        declaration := ' '+declaration;

       aProperty.Declaration := 'property '+aProperty.Name+TypeString+declaration+';';
     end;           //else
    end;//case

}

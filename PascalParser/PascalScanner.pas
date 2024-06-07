{PascalScanner
 createdy}
{
 Unitbezeichner vor fernen variablen sollten miteinbezogen werden.
 neue funktion erstellen die sowas einließt?

var
  bes : myunit.Typ;
          ^----
}
{$DEFINE RAISEEXCEPTION}
unit PascalScanner;

interface

uses SysUtils, Classes, Scanner, IOClasses, SParser, PasStream, IncludeParser,Preprocessor;


type
  { INCPARSERPROGRAMM}

  TPascalWord = (pw_none,
    pw_unit, pw_library,
    pw_exports,
    pw_interface,
    pw_type, pw_const, pw_var, pw_out, //Deklarationsart
    pw_resourcestring,
    pw_procedure, pw_function, pw_constructor,
    pw_destructor, //Funktion
    pw_register, pw_pascal, pw_forward, pw_cdecl,
    pw_deprecated, pw_popstack, pw_stdcall, pw_overload, pw_near, pw_far,
    pw_safecall, pw_external, pw_varargs, pw_export, //Aufrufkonventionen
    pw_set, pw_array, pw_of, pw_case,
    pw_interfaceClass, pw_dispinterface,       //Interface konventionen
    pw_class, pw_object, pw_record, pw_packed, pw_begin, pw_end,
    pw_property, pw_private, pw_protected, pw_public,
    pw_published, pw_read, pw_write, pw_index, pw_stored, pw_default,
    pw_override, pw_virtual, pw_reintroduce, pw_abstract,
    pw_dynamic, pw_dispid, pw_message,
    {...}

    pw_implementation);

  {Ein Set von Pascalwörtern aus @TPascalWord}
  TPascalWords = set of TPascalWord;

const
  ReservedWords = [pw_unit, pw_library, pw_exports,  pw_interface,
    pw_implementation,pw_exports,pw_end,pw_begin,
    pw_type, pw_const, pw_var, pw_out, //Deklarationsart
    pw_resourcestring,
    pw_procedure, pw_function, pw_constructor,
    pw_destructor, //Funktion
    pw_register, pw_pascal, pw_forward, pw_cdecl,
    pw_deprecated, pw_popstack, pw_stdcall, pw_overload, pw_near, pw_far,
    pw_safecall, pw_external, pw_varargs, pw_export, //Aufrufkonventionen
    pw_set, pw_array, pw_of, pw_case,
    pw_interfaceClass,        //Interface konventionen
    pw_class, pw_object, pw_record, pw_packed, pw_begin, pw_end,
    pw_property, pw_private, pw_protected, pw_public,
    pw_published,
    pw_override, pw_virtual, pw_reintroduce, pw_abstract,
    pw_dynamic, pw_dispid];


  {Methodendeklarationen, die hinter einer Methode auftauchen können}
  MethodDefinitions: TPascalWords = [pw_message, pw_dispid, pw_default,
    pw_dynamic, pw_abstract, pw_override, pw_virtual, pw_reintroduce, pw_overload, pw_of, pw_object];
  //pw_override,pw_virtual,pw_overload,pw_reintroduce,pw_abstract,pw_message,pw_dispID,pw_dynamic


  {Funktionsdeklarationen, die hinter einem Funktionskopf auftauchen können}
  FuncDefinitions: TPascalWords = [pw_reintroduce, pw_register..pw_safecall,
    pw_varargs, pw_external];
  {Eigenschaftendeklarationen, die hinter Eigenschaften bei Klassen und Interfaces auftauchen können.}
  PropertyDefinitions: TPascalWords = [pw_dispid, pw_default, pw_read,
    pw_write, pw_index];

  EndDefinition = [pw_implementation, pw_exports, pw_begin, pw_end];

  {Bei diesen Wörtern wird aus ReadForTypes gesprungen}
  CheckExitOnType: TPascalWords = [pw_function, pw_procedure,
    pw_var,{überdenken} pw_type, pw_const, pw_set, pw_array, pw_record, pw_packed,pw_implementation];


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


const
  {SPascalWord ist ein genaues Abbild des Typs: @TPascalWord als Text.}
  SPascalWord: array[pw_none..pw_implementation] of ShortString =
    ('', 'unit', 'library', 'exports',
    'interface', 'type', 'const', 'var', 'out',
    'resourcestring',
    'procedure', 'function', 'constructor', 'destructor',
    'register', 'pascal', 'forward', 'cdecl', 'deprecated', 'popstack',
    'stdcall', 'overload', 'near', 'far', 'safecall', 'external', 'varargs', 'export',

    'set', 'array', 'of', 'case',
    'interface', 'dispinterface',
    'class', 'object', 'record', 'packed', 'begin', 'end',
    'property', 'private', 'protected', 'public', 'published', 'read',
    'write', 'index', 'stored', 'default', 'override', 'virtual', 'reintroduce',
    'abstract', 'dynamic', 'dispid', 'message',

    'implementation');

function StringtoPascalWord(Str: ShortString): TPascalWord;
function PascalWord2String(PascalWord: TPascalWord): ShortString;



type
  TPascalScanner = class(TScanner)
  private
    {Zwischenspeicher der Unitklasse für Progressfortschritt.}
    fUnit: TUnit;
    fLines : Integer;
    {der zu scannende Quellcode}
    fPStream: TPascalStream;
       {aktuelle Compilerdefinitionen im Quelltext - wird von ReadCommentSwitches gesetzt oder gelöscht,       }
    fDefinitions,
    {vom User gesetzte Compilerdefinitionen}
    fDirectives: TStringList;


    {der letzte Kommentar zur Zwischenspeicherung}
    LastComment: string;
       {scannt den Unit Header bis "interface"
       Gibt danach die Kontrolle an ScanForInterface.}
    function ScanUnit: TUnit;

       {Untersucht den Unit-Kopf bis zum interface abschnitt und den uses klauseln.
       Gibt danach die Kontrolle an ScanForDefinitions.
       }
    function ScanForInterface(aUnit: TUnit): string;
    {-->}
    {Scannt alle Definitionen bis zum Implementation Abschnitt.}
    procedure ScanForDefinitions(aUnit: TUnit; InputToken: string = '');


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
        Die Parameter werden nicht ausgewertet, dies übernimmt die Klasse TFunctionEntry.}
    function ScanFunction(aUnit: TUnit; var Item: TBaseEntry;
      Container: TContainerEntry = nil; InitToken: string = ''): string;
    //;WordType,DeclarationType : TPascalWord;  Name : String; var Comment : String) : String;
         {Scannt nach Variablen, auch in Klassen,objekten und records,
          wenn es sich nicht um eine Variable handelt, wird auf die vorangegangene Position zurückgespult.
         Mehrere Variablen des gleich Typs bekommen eigene TBaseVariableEntry Klassen.
         Setze Container, um die Variable(n) in ein Record, Objekt oder Klasse zu deponieren.
         }
    function ScanForVariables(aUnit: TUnit; Container: TContainerEntry = nil;
      Visibility: TVisibility = vnone; InputToken: string = ''): string;

    function ScanForConstants(aUnit: TUnit; Container: TContainerEntry): string;

         {Scannt nach einem Block, der mit "[]" oder "()" eingeschlossen ist und gibt den Inhalt mit Klammern zurück.
          Wenn kein Block existiert, wird das nächste Word zurückgeliefert
         }
    function ScanDefinition: string;
         {Scannt nach einem Variablentyp oder nach einer Wertzuweisung.
         SqType ist für zukünfiges}
    function ScanSequence(out Buffer: string): string;

         {Scannt nach Typen, auch Funktionstypen und fügt diese der Unit hinzu.
         Objekte, Klassen werden an ScanForOC übergeben.
         Records and ScanForRecord.
         Hinweis : Es muss sich eindeutig um eine typdeklaration handeln.
         }
    function ScanForTypes(aUnit: TUnit; Token: string = ''): string;

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
    function ScanOCI(aUnit: TUnit; var Container: TOCIEntry): string;
    {Scannt nach Eigenschaften.}
    function ScanForProperties(aUnit: TUnit; Container: TOCIEntry;
      Visibility: TVisibility; InputToken: string = ''): string; virtual;

         {Records sehen zwar ähnlich aus wie Klassen,
         damit aber case construkte erkannt werden,
         wurde eine eigene funktion verwendet, die ScanForOC ähnelt.}
    function ScanForRecord(aUnit: TUnit; var Item: TRecordEntry): string;


        {ScanForExtras ließt eine Reihe von Definitionen vom Typ Extras bis zum Semicolon.
         ScanRepeat ließt auch nach dem Semicolon weiter, sofern die Definitionen in Extras enthalten sind.
         Buffer beinhaltet die gelesenen Definitionen, das letzte Semicolon ist enthalten (wenn vorhanden), und
         wird als Rückgabewert zurückgeliefert.
         Der Rückgabewert ist die erste Definition, die nicht in Extras enthalten ist,oder auch ein Semicolon, wenn Scanrepeat TRUE ist.
         Wird von ScanForProperties und ScanForFunction verwendet}
    function ScanForExtras(extras: TPascalWords; InputToken: string;
      out Buffer: string; ScanRepeat: boolean = False): string;

        {CheckForDefinitions ließt eine Reihe von Definitionen ein die durch Leerzeichen getrennt sind, bis ein Semicolon auftaucht,
         und gibt die Reihe ohne Semicolon zurück.
         Der Rückgabewert ist das letzte Semicolon.}
    function CheckForDefinitions(InputToken: string; out Buffer: string): string;

    {Scannt nach einem Unitbezeichner vor einem Typ und gibt diese in UnitName zurück.
    das erste Wort des Bezeichners }
   // function ScanUnitLink(out UnitName,NextToken : String) : String;


    {untersuch input, ob es sich dabei um ein PascalWort expectation handelt und liefert bei Erfolg wahr zurück.}
    function Expected(input: string; expectation: TPascalWord): boolean; overload;
    function Expected(input: string; expectation: string): boolean; overload;

    {untersuch input, ob es sich dabei um ein oder mehrere PascalWorte Expectations handelt und liefert bei Erfolg wahr zurück.}
    function Expected(input: string; Expectations: TPascalWords;
      out WordResult: TPascalWord): boolean; overload;

    {Löst eine Exception aus mit Dateinamen (sofern vorhanden),Zeilenangabe und dem Fehlertext Msg.}
    procedure RaiseException(Msg: string; Position: cardinal = 0); overload;
    procedure RaiseException(Msg: string; const Args: array of const); overload;

    {zusätzliche Funktionen zur Quelltextanalyse}
       
  public
    constructor Create(Stream: TStream); override;
    destructor Destroy; override;

       {Startet den Scanvorgang und kehrt mit der Unit zurück.
       Fortschritt siehe ScanProgress}
    function DoScan: TUnit;


    property LineCount : Integer read fLines;

    property Directives: TStringList read fDirectives write fDirectives;
    property Definitions: TStringList read fDefinitions write fDefinitions;



    property Stream: TPascalStream read fPStream write fPSTream;

    function IncludeParseStd(IncludePaths: TAStrings; ErrorProc: TIncludeErrorProc = nil): cardinal;

    function IncludeParse(Source: TTextStream; Dest: TStream;
      IncludePaths: TAStrings; ErrorProc: TIncludeErrorProc = nil): cardinal;

//      Directives, Definitions,
    function PreprocessingStd(OnProcessing : TOnProcessing = nil;
         Warnings : TStringlist = nil;  IgnoreSourceDefines : Boolean = FALSE;IgnoreSourceConstants : Boolean = FALSE) : Integer;

    function Preprocessing(OnProcessing : TOnProcessing; InputStream,OutPutStream : TPascalStream;
        Directives, Definitions, Warnings : TStringlist; IgnoreSourceDefines: Boolean = FALSE;IgnoreSourceConstants : Boolean = FALSE) : Integer;
  end;

{@Name gibt den Pointer Item1 oder Item2 zurück, der nicht nil ist.
Wenn beide ungleich nil sind, wird Item1 zuerst zurückgegeben.}
function GetNoneNullItem(Item1,Item2 : TBaseEntry) : TBaseEntry;

implementation

uses StrUtils;
{$I .\Inc\Utils.pas}

function GetNoneNullItem(Item1,Item2 : TBaseEntry) : TBaseEntry;
begin
  if Assigned(Item1) then
   result := Item1
  else
  if Assigned(Item2) then
   result := Item2
  else
    result := nil;
end;


function TPascalScanner.PreprocessingStd(OnProcessing : TOnProcessing = nil;
         Warnings : TStringlist = nil;
         IgnoreSourceDefines : Boolean = FALSE;IgnoreSourceConstants : Boolean = FALSE) : Integer;

var InStream : TPascalStream;
begin
  InStream := TPascalStream.Create();
  InStream.CopyFrom(fPStream,0);
  fPStream.Size := 0;
  InStream.Position := 0;

  result := Preprocessing(OnProcessing,InStream,fPStream,fDirectives,fDefinitions,Warnings,IgnoreSourceDefines,IgnoreSourceConstants);
  InStream.Free;
  fPStream.Position := 0;
end;

function TPascalScanner.Preprocessing(OnProcessing : TOnProcessing; InputStream,OutPutStream : TPascalStream;
        Directives, Definitions, Warnings : TStringlist;
        IgnoreSourceDefines : Boolean = FALSE;
        IgnoreSourceConstants : Boolean = FALSE) : Integer;
begin
  PreProcessor.IgnoreSourceDefines   := IgnoreSourceDefines;
  PreProcessor.IgnoreSourceConstants := IgnoreSourceConstants;

  result := Preprocessor.Preprocessing(OnProcessing,InputStream,OutPutStream,
         Directives, Definitions, Warnings);
end;

function TPascalScanner.IncludeParseStd(IncludePaths: TAStrings; ErrorProc: TIncludeErrorProc = nil): cardinal;
var InStream : TPascalStream;
begin
  InStream := TPascalStream.Create();
  InStream.CopyFrom(fPStream,0);
  fPStream.Size := 0;
  InStream.Position := 0;

  result := IncludeParse(InStream,fStream,IncludePaths,ErrorProc);
  InStream.Free;
  fPStream.Position := 0;
end;

function TPascalScanner.IncludeParse(Source: TTextStream; Dest: TStream;
  IncludePaths: TAStrings; ErrorProc: TIncludeErrorProc = nil): cardinal;
begin
  Result := PreIncludeParse(Source, Dest, IncludePaths, ErrorProc);
end;


function TPascalScanner.ScanUnit: TUnit;
var
  Comments: string;

  Declaration, Dummy: string;
  WordResult: TPascalWord;
begin
  Dummy := fPStream.ReadToken(False, [RC_COMMENT]);
  Comments := fPStream.GetLastComment;

  if not Expected(Dummy, [pw_Unit, pw_library], WordResult) then
    RaiseException('Unit or library expected, but "%s" found!', [Dummy]);

  {Erzeige Unit-Klasse}
  Result := TUnit.Create(Declaration,Nil);

  Result.IsLibrary := WordResult = pw_library;

  //Name lesen
  Declaration := fPStream.ReadToken(FALSE,RC_NONE);
  if Length(Declaration) = 0 then
    RaiseException('Unit or library name expected.');

  //Wenn hier kein Semicolon kommt, dann ist was faul    
  Dummy := fPStream.ReadToken(FALSE,[rc_single]);
  if not Expected(Dummy, ';') then
    RaiseException('";" expected, but "%s" found!', [Dummy]);

  Result.Name := Declaration;

  Result.Comment := Comments;

  if Result.IsLibrary then
    Result.Declaration := 'library ' + Declaration + ';'
  else
    Result.Declaration := 'unit ' + Declaration + ';';

  CallOnScanProgress(Self,Pointer(Result));

  ScanForInterface(Result);
end;




{ScanForExtras ließt eine Reihe von Definitionen vom Typ Extras bis zum Semicolon.
 ScanRepeat ließt auch nach dem Semicolon weiter, sofern die Definitionen in Extras enthalten sind.
 Buffer beinhaltet die gelesenen Definitionen, das letzte Semicolon ist enthalten (wenn vorhanden), und
 wird als Rückgabewert zurückgeliefert.
 Der Rückgabewert ist die erste Definition, die nicht in Extras enthalten ist,oder auch ein Semicolon, wenn Scanrepeat TRUE ist.
Wird von ScanForProperties und ScanForFunction verwendet}


{!!!!!!!!!!!!to be tuned!!!!!!!!!!!!!!!!!!}
function TPascalScanner.ScanForExtras(extras: TPascalWords;
  InputToken: string; out Buffer: string; ScanRepeat: boolean = False): string;
var 
  token, OutPutBuffer: string;
  WordType: TPascalWord;
begin
  Result := '';
  repeat
    if Length(InputToken) = 0 then
      token := fPStream.ReadToken(False, RC_ALL)
    else
      token := InputToken;   //property
    InputToken := '';

    WordType := StringtoPascalWord(token);
    if WordType in extras //[pw_default,pw_dispid,pw_message,pw_read,pw_write]
      then
    begin
      InputToken := CheckForDefinitions(token, OutPutBuffer);
      Buffer := Buffer + OutPutBuffer + InputToken;

      Result := InputToken;
      SetLength(InputToken,0);
      SetLength(Token,0);
    end
    else
    begin
      Result := token;
      exit;
    end;
  until (ScanRepeat and (not (WordType in extras))) or (not ScanRepeat);
end;

{
 soll eine reihe von definitionen scannen bis ; erscheint
 trennung durch Leerzeichen nur wo man es darf
Sucht nach weiteren Defintionen für Eigenschafte, wie read, write, index usw}
function TPascalScanner.CheckForDefinitions(InputToken: string;
  out Buffer: string): string;
var 
  token, token2, descr: string;
begin
  Result := '';
  token := '';
  repeat
    if Length(Token) = 0 then
    begin
      if Length(InputToken) = 0 then
        token := fPStream.ReadToken(False, RC_ALL) //index, read , write,default,
      else
        token := InputToken;
      InputToken := '';

      if token <> ';' then
      begin
        if (Length(descr) > 0) and (Length(Token) > 1) then
          descr := descr + ' ';
        descr := descr + token;
      end
      else
      begin
        break;
      end;
    end;
    token2 := ScanDefinition;

    if token2 <> ';' then
    begin
      if (Length(Token2) > 0) and (Upcase(token2[1]) in ['A'..'Z', '0'..'9',
        '_', '+', '-', '$']) and
        ((Length(Token) > 0) and not (Upcase(token[1]) in ['+', '-', '0'..'9', '$'])) then
        descr := descr + ' ';
      descr := descr + token2;

      token := fPStream.ReadToken;
      if (token <> ';') then
      begin
        if (Length(descr) > 0) and (Length(Token2) > 0) and
          (Upcase(token2[1]) in ['A'..'Z', '0'..'9']) and not (descr[Length(descr)] in ['+', '-']) then
          descr := descr + ' ';
        descr := descr + token;
      end;
    end
    else
    begin
      token := token2;
      break;
    end;
  until (token = ';');
  Buffer := descr;
  Result := token;
end;



//testen!

function TPascalScanner.ScanFunction(aUnit: TUnit; var Item: TBaseEntry;
  Container: TContainerEntry = nil; InitToken: string = ''): string;


  function ScanParameters(aFunction: TFunctionEntry; out Parameters: string;
    InputToken: string = ''): string;

    procedure AddParameter(var ParameterName, ParameterType, ParameterDefinitionString, DefaultValue: string);
    begin
      aFunction.AddParameter(ParameterName, PArameterType,ParameterDefinitionString, DefaultValue);
    end;

    {Statt  ScanSequence wird dies verwendet, da flexibler}
    function GetParameterType(out Buffer, DefaultValue: string): string;
    var 
      Token, LastToken: string;
    begin
      repeat
        Token := FPSTream.ReadToken;
        if Token[1] in [';', ')'] then
        begin
          Result := Token;
          break;
        end
        else if Token[1] in ['='] then
        begin
          DefaultValue := FPSTream.ReadToken;
        end
        else
        begin //Ende
          if ((Length(LastToken) = 1) and (LastToken[1] in [':', ')', '(']))
            or ((Length(Token) = 1) and (Token[1] in [':', ')', '('])) or
            (LEngth(LastToken) <= 0) then
            Buffer := Buffer + Token
          else
            Buffer := Buffer + ' ' + Token;
          LastToken := Token;
        end;
      until False;
    end;
  var 
    token: string;

    ParameterDefinitionString, //var, const
    ParameterName, ParameterType, DefaultValue: string;

    ParaNames: array of string;
    i: integer;
  begin
    if Length(InputToken) = 0 then
      Token := fPStream.Readtoken()
    else
      Token := InputToken;

    Parameters := '';
    Result := Token;
    if Token <> '(' then exit;

    Token := '';

    repeat
      if Length(Token) = 0 then
      begin
        Token := FPStream.ReadToken; //var, const oder Bezeichner

        //!!!!!!
        if StringToPascalWord(Token) in [pw_var, pw_const, pw_out] then
        begin
          ParameterDefinitionString := Token;
          Token := FPStream.ReadToken; //Bezeichner
        end;

        SetLength(ParaNames, 1);
        ParaNames[0] := Token;

        Token := FPStream.ReadToken; //:,; oder )
      end;

      if Token[1] in [','] then
      begin
        SetLength(ParaNames, Length(ParaNames) + 1);

        Token := FPStream.ReadToken;
        ParaNames[Length(ParaNames) - 1] := Token;

        Token := FPStream.ReadToken;
      end;

      if Token[1] in [';', ')'] then
      begin
        if Length(Parameters) > 0 then
          Parameters := Parameters + ';';
        if Length(ParameterDefinitionString) > 0 then
          ParameterDefinitionString := ParameterDefinitionString + ' ';

        Parameters := Parameters + ParameterDefinitionString;

        for i := 0 to Length(ParaNames) - 1 do
        begin
          ParameterName := ParaNames[i];

          AddParameter(ParameterName, PArameterType, ParameterDefinitionString, DefaultValue);
          if i < Length(ParaNames) - 1 then
            ParameterName := ParameterName + ',';

          Parameters := Parameters + ParameterName;
        end;

        if Length(PArameterType) > 0 then
          PArameterType := ':' + PArameterType;
        if Length(DefaultValue) > 0 then
          DefaultValue := '=' + DefaultValue;

        Parameters := Parameters + PArameterType + DefaultValue;

        ParameterName := '';
        PArameterType := '';
        ParameterDefinitionString := '';
        DefaultValue := '';

        SetLength(ParaNames, 1);

        if (Length(Token) > 0) and (Token[1] <> ')') then
        begin
          Token := '';
          continue;
        end;
      end;

      if (Length(Token) > 0) and (Token[1] = ')') then
      begin
        Result := fPStream.ReadToken;
        break;
      end
      else if Token[1] = ':' then
      begin
        Token := GetParameterType(PArameterType, DefaultValue); // -> ;
      end;

    until False;
  end;    {END ScanParameters}
var //Dummy,
  Token,
  //Textcontainer
  aComment, //Kommentarcontainer
  // Declaration, //procedure/function unterscheidung
  Parameters,//alle PArameter innerhalb von ( und )
  Buffer: string;
  aFunction: TFunctionEntry;
begin
  if Length(InitToken) = 0 then
  begin
    InitToken := fPSTream.ReadToken;
  end;


  if not Assigned(Item) then
  begin
    aFunction := TFunctionEntry.Create(InitToken,GetNoneNullItem(Container,aUnit));
    item := aFunction;
    item.Comment := fPStream.GetLastComment;
  end;
  aFunction := TFunctionEntry(item);

  aComment := fPStream.GetLastComment;
  //zwischen jedem Readword die comments herrausnehmen - zukünftig auch compilerdirektiven
  if (aFunction.Comment = '') then
    aFunction.Comment := LastComment;

  if (aFunction.DeclarationType = dt_none) and (aFunction.Declaration = '') then
  begin
    aFunction.Declaration := fPStream.ReadToken;
    //wenn unbekannt, ob procedure oder function
  end
  else
  begin
  end;


  if aFunction.DeclarationType <> dt_type then
  //Methoden und proceduren/functionen besitzen Namen, typen aber nicht
  begin
    if aFunction.DeclarationType <> dt_method then
      //bei methoden wird der name schon in aFunction gelesen
      aFunction.Name := fPStream.ReadToken; //procedure/function Name
    aFunction.Declaration := aFunction.Declaration + ' ' + aFunction.Name;
  end
  else if aFunction.DeclarationType = dt_type then //
  begin
    aFunction.Declaration := aFunction.Name + '=' + aFunction.Declaration;
  end;



  Token := ScanParameters(aFunction, Parameters, '');


  if Parameters <> '' then
    aFunction.Declaration := Format('%s(%s)', [aFunction.Declaration, Parameters]);


  if (aFunction.IsProcedure) or (aFunction.IsConstructor) or (aFunction.IsDestructor) then
  begin
   { if Token <> ';' then
    begin
      Buffer := Token;
      Token := fPStream.ReadToken; // ; / object
    end;
    if Token <> ';' then
    begin
      Buffer :=Buffer + Token;
      Token := fPStream.ReadToken; // ;
    end;
          }
    if Token = ';' then   //da kommt noch was - wohl ein of object?
    begin
      aFunction.Declaration := aFunction.Declaration + Token;
      Token := '';
    end;
  end
  else 
  begin
    if Token <> ':' then
    begin
      Token := fPStream.ReadToken; // :
      //ASSERT(Expected(dummy,':'),'":" expected.');
      if not Expected(Token, ':') then
        RaiseException('; expected instead of %s', [Token]);
    end;
    aFunction.Declaration := aFunction.Declaration + Token;

    aFunction.Return := fPStream.ReadToken; // Result
    aFunction.Declaration := aFunction.Declaration + {' ' +}aFunction.Return;

    Token := fPStream.ReadToken; // ;
    if Token = ';' then
    begin
      aFunction.Declaration := aFunction.Declaration + Token;
      Token := '';
    end;
  end;

  LastComment := fPStream.GetLastComment; //für pw_none wird ein kommentar miteingelesen

  begin
    Result := '';
//    Token := '';
    Result := ScanForExtras(MethodDefinitions + FuncDefinitions, Token, buffer, True);

    if StringToPascalWord(Result) = pw_None then
    begin
      //RaiseException('Unknown word "%s". Next statement expected', [Result]);
    end;

    aFunction.SingleComment := fPStream.GetSingleComment;

    aFunction.Declaration := aFunction.Declaration + Buffer;

    if not Assigned(Container) then
      aUnit.Add(aFunction)
    else
    begin
      Container.Add(aFunction);
//      aFunction.Parent := TOCIEntry(Container);
    end;

    CallOnScanProgress(Self,Pointer(aFunction));

    if Length(Result) = 0 then
    begin
      Result := fPStream.ReadToken;
    end;
  end;
end;

function TPascalScanner.ScanForRecord(aUnit: TUnit; var Item: TRecordEntry): string;
var 
  Dummy, aName: string;
  aWordType: TPascalWord;
  aBaseVariable: TBaseVariableEntry;
  over, ii: integer;
  childs: string;
begin
  //Man scannt nur nach !einem! Record
  //es gibt auch
  //ret
  repeat
    //Dummy := FPStream.ReadToken;
    dummy := ScanForVariables(aUnit, TContainerEntry(Item));
    aWordType := StringtoPascalWord(dummy);

     
    if aWordType = pw_end then
    begin
      break;
    end
    else if aWordType = pw_case then
    begin
      repeat
        dummy := FPStream.ReadToken(True);
        if aWordType = pw_end then
        begin
          break;
        end;
        over := 0;

        fPStream.ReadText(aName, 'end', over, False);

        aName := 'case ' + dummy + ' ' + aName;
        aBaseVariable := TBaseVariableEntry.Create(aName,aUnit);

        Item.Add(aBaseVariable);

        begin
          aWordType := pw_end;
          break;
        end;

      until False;
    end;
  until aWordType = pw_end;

  Dummy := FPStream.ReadToken;
  if not Expected(dummy, ';') then RaiseException(Format('"%s" expected, but "%s" found.',
      [';', dummy]));

  if Item.IsPacked then
    dummy := 'packed '
  else
    dummy := '';

  childs := '';
  for ii := 0 to Item.Items.Count - 1 do
  begin
    if Length(childs) > 0 then
      childs := Childs + #13#10;
    childs := childs + TBaseEntry(Item.Items[ii]).Declaration;
  end;

  Item.Declaration := Item.Name + '=' + dummy + 'record' + #13#10 +
    childs + #13#10 + 'end;';

  CallOnScanProgress(Self,Pointer(Item));

  Result := '';
end;

function TPascalScanner.ScanDefinition: string;
var 
  dummy: string;
  brackets, brackets2: integer;
begin
  Result := '';
  brackets := 0;
  brackets2 := 0;
  repeat
    dummy := fPStream.ReadToken;
    if (Dummy = '(') then
      Inc(brackets)
    else if (Dummy = ')') then
      Dec(brackets)
    else if (Dummy = '[') then
      Inc(brackets2)
    else if (Dummy = ']') then
      Dec(brackets2)
    else if (brackets = 0) and (brackets2 = 0) then
    begin
      if Length(Result) = 0 then
        Result := dummy;
      break;
    end;
    if (Length(Dummy) > 1) and (Length(Result) > 0) then
      Result := Result + ' ' + dummy
    else
      Result := Result + dummy;
  until (Brackets = 0) and (Brackets2 = 0);
end;



function TPascalScanner.ScanSequence(out Buffer: string): string;
var 
  dummy, lastDummy,UnitName: string;
  brackets: integer;
begin
  Result := '';
  brackets := 0;
  dummy := '';
  repeat
    lastDummy := dummy;
    //Buffer;
    try
     (* dummy := ScanUnitLink(UnitName,lastDummy);
      if Length(UnitName) > 0 then
        dummy := UnitName+LastDummy+dummy;*)
      dummy := fPStream.ReadToken(False, RC_ALL);
    except
      on e: Exception do
        RaiseException(e.Message);
    end;

    if (dummy = '(') then
      Inc(brackets)
    else if (dummy = ')') then
      Dec(brackets)
    else if ((dummy = ';') or (dummy = '=')) and (brackets = 0) then
    begin
      break;
    end;
    if (Length(dummy) > 1) and (Length(dummy) > 0) and (Length(lastDummy) > 1) then
      Buffer := Buffer + ' ' + dummy
    else
      Buffer := Buffer + dummy;
  until ((dummy = ';') or (dummy = '=')) and (Brackets = 0);

  Result := dummy;
end;

function TPascalScanner.ScanForConstants(aUnit: TUnit; Container: TContainerEntry): string;
var 
  Dummy, aComment, aName, aType, aValue: string;
  aWordType: TPascalWord;
  aConstant: TConstantEntry;
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

    dummy := fPStream.ReadToken(False, RC_ALL); // = oder ; ?
    if dummy = '=' then //variable constant
    begin
      dummy := ScanSequence(aValue);
    end
    else if dummy = ':' then
    begin
      dummy := ScanSequence(aType);
      //dummy := fPStream.ReadToken; // =
      if not Expected(dummy, '=') then
        RaiseException(Format('"%s" expected, but "%s" found.', ['=', dummy]));
      //aValue :=
      dummy := ScanSequence(aValue);
    end
    else
      RaiseException(Format('":" or "=" expected, but "%s" found.', [dummy]));

    if Length(Dummy) = 0 then
      dummy := fPStream.ReadToken(False, RC_ALL); // ;
    if not Expected(dummy, ';') then
      RaiseException(Format('"%s" expected, but "%s" found.', [';', dummy]));

    if (aName <> '') and (aValue <> '') then
    begin
      dummy := aName;
      if (aType <> '') then
        Dummy := dummy + ':' + aType;

      dummy := dummy + '=' + aValue;
      dummy := dummy + ';';

      aConstant := TConstantEntry.Create(dummy,aUnit);
      aConstant.Name := aName;
      aConstant.TypeString := aType;
      aConstant.Value := aValue;
      aConstant.Comment := aComment;
      aConstant.Parent := Container;

      if Assigned(aUnit) then
        aUnit.Add(aConstant);

      aConstant.SingleComment := fPStream.GetSingleComment;

      CallOnScanProgress(Self,Pointer(aConstant));

      aName := '';                                                                  
      aType := '';
      aValue := '';
    end;

  until False;
  Result := dummy;
end;

function TPascalScanner.ScanForVariables(aUnit: TUnit; Container: TContainerEntry = nil;
  Visibility: TVisibility = vnone; InputToken: string = ''): string;
var
  Dummy, aComment, aName, aType, aValue: string;
  aWordType: TPascalWord;
  ii: integer;
  BaseVariable: TBaseVariableEntry;
  List: TStringList;


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
      begin
//        aName := fPStream.ReadToken; //Name
        dummy := fPStream.ReadToken;
        if dummy = ',' then
         aName := fPStream.ReadToken
        else
        begin
          aName := dummy; //Name

        end;
      end
      else
      begin
        aName := InputToken;
        InputToken := '';
      end;

      if Length(fPStream.Lastcomment) > 0 then
        aComment := fPStream.GetLastcomment
      else
       aComment := '';

      List.Add(aName + '=' + aComment);

      aWordType := StringtoPascalWord(aName);
      if (aWordType in ReservedWords)  then
      begin
        Result := aName;
        List.Free;
        exit;
      end;


      dummy := fPStream.ReadToken;
      if (not Expected(dummy, ':')) and (not Expected(dummy, ',')) then
        RaiseException('":" or "," expected');
    until (dummy = ':');

    //aType :=
    dummy := ScanSequence(aType);//Typ
    // = oder ; ?
    if (dummy = '=') and (List.Count = 1) then //variable constant
    begin
      //aValue :=
      dummy := ScanSequence(aValue);
    end
    else if (dummy = '=') and (List.Count > 1) then
    begin
      RaiseException(Format('%s expected, but %s found.', [';', dummy]));
    end;

    if (Dummy <> '=') and (Dummy <> ';') then
      if not Expected(dummy, ';') then
        RaiseException('";" expected');

    if (aName <> '') and (aType <> '') then
    begin
      for ii := 0 to List.Count - 1 do
      begin
        aName := List.Names[ii];
        dummy := aName + ':' + aType;
        if (aValue <> '') then
          dummy := dummy + '=' + aValue;
        dummy := dummy + ';';

        BaseVariable := TBaseVariableEntry.Create(dummy,GetNoneNullItem(Container,aUnit));
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
          aUnit.Add(BaseVariable)
        else if Assigned(Container) then
          Container.Add(BaseVariable)
        else
          RaiseException('ScanForVariables: aUnit or Container must be defined.');

        CallOnScanProgress(Self,Pointer(BaseVariable));
      end;
      List.Clear;
      aName := '';
      aType := '';
      aValue := '';
      dummy := '';
    end;


  until FALSE;

  List.Free;
  Result := Dummy;
end;


function TPascalScanner.ScanForTypes(aUnit: TUnit; Token: string = ''): string;

  function CheckExit(Dummy: string): boolean;
  begin
    //!!!!!!!!!!!
    Result := (StringtoPascalWord(dummy) in CheckExitOnType)
  end;

  function PW2ClassType(pw: TPascalWord): TIOClassType;
  begin
    Result := ct_none;
    case pw of
      pw_class: Result := ct_class;
      pw_interfaceclass,pw_interface: Result := ct_interface;
      pw_object: Result := ct_object;
      pw_dispinterface: Result := ct_dispinterface;
      else
        RaiseException('ScanForTypes.PW2ClassType unknown ClassType')
    end
  end;
var 
  Dummy, aName, aTypeString, Comment, StrPtr: string;
  aWordType: TPascalWord;
  aFunction: TTypeFunctionEntry;
  aType: TTypeEntry;
  aRecord: TRecordEntry;
  aOCI: TOCIEntry;
  Ispacked: boolean;
begin
  dummy := Token;

  //wenn es sich um z.b. type handelt, wird dieses verworfen, da sonst die schleife zu früh abgebrochen wird
  if CheckExit(dummy) then
    Dummy := '';

  Ispacked := False;
  repeat
    if not Ispacked then
    begin
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

      if not Expected(fPStream.ReadToken, '=') then
        RaiseException('"=" expected, but "%s" found.', [dummy]);
    end;


    StrPtr := fPStream.ReadToken;
    if (StrPtr = '^') then          //Pointer abfangen
      dummy := fPStream.ReadToken
    else
    begin
      dummy := StrPtr;
      StrPtr := '';
    end;

    // procedure, class, object, record sonst einfach alles übernehmen -> ELSE
    aWordType := StringtoPascalWord(dummy);


    case aWordType of
      pw_implementation : Exit;
      pw_procedure, pw_function:
        begin
          aFunction := TTypeFunctionEntry.Create('',aUnit);
          aFunction.Declaration := SPascalWord[aWordType];
          aFunction.Name := aName;
          aFunction.Comment := Comment;
          aFunction.DeclarationType := dt_type;

          dummy := ScanFunction(aUnit,
            TBaseEntry(aFunction), nil, dummy);
//          CallOnScanProgress(Self,Pointer(aFunction));
        end;
      pw_packed: 
        begin //FreePascal Syntax für class
          Ispacked := True;
          dummy := '';  //sonst würde CheckExit anspringen
        end;
      pw_record: 
        begin
          aRecord := TRecordEntry.Create('',aUnit);
          aRecord.Name := aName;
          aRecord.Comment := Comment;
          aRecord.IsPacked := Ispacked;
          Ispacked := False;

          aUnit.Add(aRecord);
          {da fehlt noch ein record}
          if aWordType = pw_packed then
          begin
            dummy := fPStream.ReadToken; //record
            if StringtoPascalWord(dummy) <> pw_record then
              RaiseException(Format('record expected, but %s found.', [dummy]));
          end;

          dummy := ScanForRecord(aUnit, aRecord);
          CallOnScanProgress(Self,Pointer(aRecord));
        end;
      pw_class, pw_interface,pw_interfaceclass, pw_dispinterface, pw_object:
        begin
          aOCI := TOCIEntry.Create('', aUnit,PW2ClassType(aWordType));
          aOCI.Name := aName;
          aOCI.Comment := Comment;
          aOCI.DeclarationType := dt_Type;
          aOCI.Ispacked := Ispacked;
          Ispacked := False;

          dummy := ScanOCI(aUnit, aOCI);
          CallOnScanProgress(Self,Pointer(aOCI));
        end;

      else
        begin
          //unbekanntes material, normalerweise von ; begrenzt
          //type XY = 1..9;
          //Type blub = [packed] array of char;
          //type bf = string[5];
          aTypeString := dummy;
          repeat
            dummy := fPStream.ReadToken;
            if Length(dummy) > 1 then
              Dummy := ' ' + Dummy;

            aTypeString := aTypeString + dummy;
            // aWordType := StringtoPascalWord(dummy);
          until (dummy = ';');

          aType := TTypeEntry.Create(aName + ' = ' + StrPtr+ aTypeString,aUnit);
          aType.Name := aName;
          aType.Comment := Comment;
          aType.TypeString := StrPtr + LeftStr(aTypeString, Length(aTypeString) - 1);
          aType.IsPacked := Ispacked;

          aUnit.Add(aType);
          CallOnScanProgress(Self,Pointer(aType));

          dummy := fPStream.ReadToken; //nächstes einlesen für das Schleifenende
        end;
    end;
  until CheckExit(dummy);
  Result := dummy
end;


function TPascalScanner.ScanForProperties(aUnit: TUnit; Container: TOCIEntry;
  Visibility: TVisibility; InputToken: string = ''): string;
const 
  PropertyTypes = [pw_read, pw_write, pw_index, pw_stored, pw_default];
var 
  token, Name, declaration, extras, addition, comment: string;
  aProperty: TPropertyEntry;
  WordType: TPascalWord;
  IsClosed: boolean;

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
      Result := token;
      break;
    end;

    comment := fPStream.GetLastComment;

    //Name
    Name := '';
    Token := '';
    repeat
      if Length(Name) > 1 then
        Name := Name +' ' + Token
      else
        Name := Name +Token;
      token := fPStream.ReadToken;
    until (Length(Token) <= 0) or (Token[1] in [':', ';', '[']);

    aProperty := TPropertyEntry.Create('',Container);
    aProperty.Name := Name;
    aProperty.Comment := comment;
    Container.Add(aProperty);


    if Length(Token) = 0 then
      token := fPStream.ReadToken;   //[,; oder Typ
    if token = '[' then              //liest einen Index ein in []:  bla[...] : das
    begin
      IsClosed := False;
      addition := '';
      repeat
        if (Length(addition) > 1) and (Length(token) > 1) and
          (Upcase(token[1]) in ['A'..'Z', '0'..'9']) then
          addition := addition + ' ' + Token
        else
          addition := addition + Token;
        token := fPStream.ReadToken;
        if token = ']' then IsClosed := True;
      until (Length(Token) <= 0) or ((Token[1] in [':', ';']) and IsClosed);
    end
    else {überschriebene Eigenschaft, ohne Typ}
    if token = ';' then
    begin
      token := ScanForExtras(PropertyDefinitions, '', extras, True);
      aProperty.Declaration := Format('property %s%s;%s',
        [aProperty.Name, addition, extras]);
      aProperty.SingleComment := fPStream.GetSingleComment;


      CallOnScanProgress(Self,Pointer(aProperty));
      Result := ScanForProperties(aUnit, Container, Visibility, token); //next property
      exit;
    end;

    //Type
    aProperty.TypeString := fPStream.ReadToken;

    token := ScanForExtras(PropertyDefinitions, '', extras, False);

    if token <> ';' then
      RaiseException('ScanForProperties: ";" expected but found : ' + token);


    //Scannt nach der Eigenschaftsdefinition - default, usw
    token := ScanForExtras(PropertyDefinitions, '', Declaration, True);


    if Length(extras) > 0 then
      Insert(' ', extras, 1);
    if (Length(extras) = 0) and (Length(Declaration) = 0) then
      extras := ';';

    aProperty.SingleComment := fPStream.GetSingleComment;

    aProperty.Declaration := Format('property %s%s:%s%s%s',
      [aProperty.Name, addition, aProperty.TypeString, extras, Declaration]);

    CallOnScanProgress(Self,Pointer(aProperty));
    addition := '';
    extras := '';
    Declaration := '';


  until False;
end;

function TPascalScanner.ScanOCI(aUnit: TUnit; var Container: TOCIEntry): string;
  function PW2Visibility(pw: TPascalWord): TVisibility;
  begin
    case pw of
      pw_private: Result := vprivate;
      pw_protected: Result := vprotected;
      pw_public: Result := vpublic;
      pw_published: Result := vpublished;
      else
        Result := vnone;
    end;
  end;
var 
  Dummy, guidstr, Comment, Name, TypeString: string;
  WordType: TPascalWord;
  aType: TTypeEntry;
  anAncestor: PAncestor;
  Visibility: TVisibility;
  aFunction: TFunctionEntry;
  aName, Declarationtype, Ancestors: string;
begin
  Result := '';

  Dummy := fPStream.ReadToken; //
  WordType := StringtoPascalWord(dummy);


  if dummy = ';' then //Forward class deklaration
  begin
    exit;
  end;

  if WordType = pw_of then // of Klassendeklaration
  begin
    Name := fPStream.ReadToken; //Typ

    dummy := fPStream.ReadToken(False, RC_ALL); //;
    if not Expected(dummy, ';') then RaiseException('ScanForType : ";" expected');

    TypeString := 'class of ' + Name +dummy;
    aType := TTypeEntry.Create(Container.Name + '=' + TypeString,aUnit);
    aType.Name := Container.Name;
    aType.TypeString := TypeString;
    aType.Comment := Container.Comment;
    aType.SingleComment := fPStream.GetSingleComment;

    aUnit.Add(aType);
    CallOnScanProgress(Self,Pointer(aType));

    FreeAndNil(Container);
    exit;
  end;

  Ancestors := '';
 // dummy := '';
  if Dummy = '(' then {Vorfahren - ancestors}
  begin
    repeat
      dummy := fPStream.ReadToken;
      if dummy = ')' then break;
      if Length(dummy) > 1 then
      begin
        //anAncestor.
        anAncestor := Container.AddAncestor;
        //CreateAnchestorPtr(TRUE);
        //  anAncestor.NameType := TRUE;
//        anAncestor^.NameString := dummy;

        //Container.Ancestors.Add(anAncestor);

        if Length(Ancestors) > 0 then
          Ancestors := Ancestors + ',';
        Ancestors := Ancestors + Dummy;
      end;
    until False;
    dummy := '';
  end;

  if (Container.Kind in [ct_interface, ct_dispinterface]) then
  begin
    //['{EE05DFE2-5549-11D0-9EA9-0020AF3D82DA}']
    if dummy <> '[' then
      dummy := fPSTream.ReadToken;
    if dummy = '[' then
    begin
      dummy := fPSTream.ReadToken; //ließt ' ein

      if dummy <> '''' then //Konstantenausdruck
      begin
        Container.GuidAsString := Dummy;
        Container.Guid := StringToGUID('{00000000-0000-0000-0000-000000000000}');
        dummy := fPSTream.ReadToken; //ließt ] ein
        dummy := '';
      end
      else
      begin
        fPStream.GetPrevChar;   //funktioniert
        guidstr := fPStream.ReadString;

        Container.GuidAsString := guidstr;

        dummy := fPSTream.ReadToken; //ließt ] ein
        Container.Guid := StringToGUID(guidstr);
        //      guidstr := GUIDtoString(Container.Guid);
        dummy := '';
      end;
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
      pw_end: begin dummy := ''; break;end;
      pw_private, pw_protected, pw_public, pw_published: 
        begin 
          Visibility := PW2Visibility(WordType); 
          dummy := '';
        end;
      pw_class, //Klassenmethode
      pw_function, pw_procedure, pw_constructor, pw_destructor:
        begin
          aFunction := TFunctionEntry.Create('',Container);
          aFunction.Declaration := SPascalWord[WordType];

          if WordType = pw_class then
          //klassen methode - diese Methode gehört zu einer Klasse und nicht zur Instanz!
          begin
            Dummy := fPStream.ReadToken;
            //procedure/funktion ... einlesen
            aFunction.Declaration :=
              SPascalWord[WordType] + ' ' + dummy;
            if not (StringToPascalWord(Dummy) in [pw_function,
              pw_procedure, pw_constructor, pw_destructor]) then
              RaiseException(
                'ScanOCI: Class definition can only be used with methods! "%s" found, but method type expected.',
                [dummy]);
          end;

          aName := fPStream.ReadToken;
          aFunction.Name := aName;
          aFunction.Comment := Comment;
          aFunction.DeclarationType := dt_method;
          aFunction.Visibility := Visibility;
          dummy := ScanFunction(aUnit,
            TBaseEntry(aFunction), Container, dummy);

//          CallOnScanProgress(Self,Pointer(aFunction));

          if dummy = '' then;
        end;
      pw_property: 
        begin
          Dummy := ScanForProperties(aUnit, Container, Visibility, dummy)
        end;
      else
        //Variablen oder ";"
        begin
          if WordType <> pw_none then
          //Wenn es sich um etwas bekanntes handelt, dass nicht in case definiert wurde, dann ist es hier fehl am platz
          begin
            RaiseException('Instruction "%s" misplaced, "end" expected!', [dummy]);
          end;

    
          if Dummy <> ';' then
          begin
            dummy := ScanForVariables(aUnit, Container, Visibility, dummy);
          end
          else
          begin
            break;
          end;
        end;
    end;


  until False;

  case Container.Kind of
    ct_class: Declarationtype := 'class';
    ct_object: Declarationtype := 'object';
    ct_interface: Declarationtype := 'interface';
    ct_dispinterface: Declarationtype := 'dispinterface';
  end;

  //Es wird keine vollständige deklaration vorgenommen, weil sowas sehr groß ist.
  Container.Declaration := Format('%s=%s(%s);',
    [Container.Name, Declarationtype, Ancestors]);

  aUnit.Add(Container);
  CallOnScanProgress(Self,Pointer(Container));

  if Length(dummy) = 0 then
  dummy := fPStream.ReadToken; //;
  if not Expected(dummy, ';') then RaiseException('ScanOCI : ";" expected, but found :' +
      dummy);
  Result := '';
end;


procedure TPascalScanner.ScanForDefinitions(aUnit: TUnit; InputToken: string = '');
var 
  Dummy, Name: string;
  WordType: TPascalWord;
  aFunction: TFunctionEntry;
begin
  dummy := '';

  repeat

    if dummy = '' then
    begin
      if Length(InputToken) = 0 then
        dummy := fPStream.ReadToken(False, RC_NONE)
      else
      begin
        dummy := InputToken;
        InputToken := '';
      end;

      WordType := StringtoPascalWord(dummy);
      Name := '';
    end;

    case WordType of
      pw_type: 
        begin
          // DeclarationType := WordType;
          {Scannt solange bis kein Typen-Deklaration mehr auftritt}
          dummy := ScanForTypes(aUnit, Dummy);
        end;
      pw_procedure, pw_function: 
        begin
          aFunction := TFunctionEntry.Create('',aUnit);
          aFunction.Declaration := SPascalWord[WordType];
          aFunction.Comment := fPStream.GetLastComment;

          dummy := ScanFunction(aUnit,
            TBaseEntry(aFunction), nil, dummy);
        end;
      pw_var: 
        begin
          Dummy := ScanForVariables(aUnit, nil);
        end;
      pw_const,pw_resourcestring:
        begin
          Dummy := ScanForConstants(aUnit, nil);
        end;
      pw_implementation: begin
                           fLines := fPStream.ReadLineNumber;
                           aUnit.LineCount := fLines;
                           exit;
                         end;
      pw_begin: 
        begin
          if not aUnit.IsLibrary then
            RaiseException('Code lines are not supported in an interface part! Sorry!')
          else
            exit;
        end;
      pw_exports: 
        begin
          if not aUnit.IsLibrary then
            RaiseException('"Exports" directive is only allowed in a library.')
          else
            exit;
        end;
      else
        begin
          RaiseException(
            'ScanForDefinitions : "%s" is not supported yet or unknown instruction. Sorry don''t know what to do.',
            [dummy]);
          dummy := '';
        end;
    end;
    if dummy <> '' then
    begin
      if StringtoPascalWord(dummy) <> pw_none then
        //wenn pw_none auftritt handelt es sich wohl um einen Bezeichner innerhalb von Type
        WordType := StringtoPascalWord(dummy);
    end;
  until False;


end;

function TPascalScanner.ScanForInterface(aUnit: TUnit): string;
var 
  Dummy: string;
begin
  if not Assigned(aUnit) then
    raise Exception.Create('ScanForInterface : aUnit must not be nil');


  //interface wird nur bei units erwartet
  if not aUnit.IsLibrary then
  begin
    dummy := fPStream.ReadToken(FALSE,RC_NONE);
    if not Expected(dummy, pw_Interface) then
      RaiseException('Interface expected!');
  end;

  dummy := fPStream.ReadToken(False, RC_NONE);
  if CompareText(dummy, 'uses') = 0 then //Alle uses Klauseln überspringen
  begin
    repeat
      dummy := fPStream.ReadToken;   //Unit Name und "," sowie ";"
      if (Length(Dummy) > 1) then
        aUnit.UsesUnits.Add(Dummy);
      if dummy = ';' then break;
    until False;
    dummy := '';
  end;

  ScanForDefinitions(aUnit, dummy);
end;

constructor TPascalScanner.Create(Stream: TStream);
begin
  inherited Create(Stream);
  if not (Stream is TPascalStream) then
    raise Exception.Create('Invalid StreamType! TPascalScanner needs a class descendant of TTextStream');
  fPStream := TPascalStream(Stream);

  fDefinitions := TStringList.Create;//nicht sortieren!


  fDirectives := TStringList.Create;
  fDefinitions.Sorted := True;
  fDefinitions.Duplicates := dupIgnore;
end;

destructor TPascalScanner.Destroy;
begin
//  FreeAndNil(fPStream);
  fDefinitions.Free;
  fDirectives.Free;
  inherited;
end;

procedure TPascalScanner.RaiseException(Msg: string; const Args: array of const);
begin
  RaiseException(Format(Msg, Args));
end;

procedure TPascalScanner.RaiseException(Msg: string; Position: cardinal = 0);
var 
  s: string;
begin
  if Position > 0 then
    s := 'Char : ' + IntToStr(Position)
  else
    s := '';
{$IFDEF RAISEEXCEPTION}
    raise Exception.Create(Format(#10#13'Error in File "%s" Line : %d  %s'#10#13 +
    'Source: "%s"'#10#13'Errormessage:'#10#13'"%s"',
    [fPStream.FileName, fPStream.ReadLineNumber, s, fPStream.ReadLine(True), Msg]));
{$ENDIF}
end;


function TPascalScanner.Expected(input: string; expectation: TPascalWord): boolean;
begin
  input := RemoveSpaces(input);
  Result := CompareText(Input, SPascalWord[expectation]) = 0;
end;

function TPascalScanner.Expected(input: string; expectation: string): boolean;
begin
  input := RemoveSpaces(input);
  Result := CompareText(Input, expectation) = 0;
end;

function TPascalScanner.Expected(input: string; Expectations: TPascalWords;
  out WordResult: TPascalWord): boolean;
var 
  ii: TPascalWord;
begin
  input := RemoveSpaces(input);
  WordResult := pw_None;
  for ii := pw_none to pw_implementation do
  begin
    Result := (ii in Expectations) and (CompareText(Input, SPascalWord[ii]) = 0);
    if Result then
    begin
      WordResult := ii;
      exit;
    end;
  end;
end;


function TPascalScanner.DoScan: TUnit;
begin
  fPStream.Position := 0;
  fUnit := ScanUnit;
  Result := fUnit;
end;

end.

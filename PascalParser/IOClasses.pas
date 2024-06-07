{Version 0.4a
by author
removed}
unit IOClasses;



{$IFDEF DLLABSTRACTION}
 {$WARNINGS OFF}
 {$HINTS OFF}
{$ENDIF}

interface

uses Classes, SysUtils, RegClasses;

type  {gibt die Deklarations- und Klassenart an}
  TIOClassType = (
    ct_Item,
    ct_Switch,
    ct_Unknown,
    ct_Error,
    ct_None,
    ct_Unit,
    ct_BaseVariable,
    ct_Constant,
    ct_Type,
    ct_Function,
    ct_TypeFunction,
    ct_property,
    ct_container,
    ct_record,
    ct_class,
    ct_object,
    ct_parameter,
    ct_interface,
    ct_dispinterface);

  TVisibility = (vnone, vprivate, vprotected, vpublic, vpublished);

  {Item deklarations art}
  TDeclarationType = (dt_none, dt_type, dt_var, dt_const, dt_method,
    dt_class, dt_object, dt_interface, dt_dispinterface, dt_record);


  //      TBaseEntry = class;


     (* {Compiler Schalter : nicht verwendet}
      TSwitch = class(TPersistent)
      public
      end;*)

  TContainerEntry = class;

  TBaseEntry = class(TRegPersistent)
  private
    fDeclaration,
    fName,
    fComment,
    fSingleComment: string;
    fLine : Int64;
    fFileName : String;

    //        fSwitch : TSwitch;
    fKind: TIOClassType;
    fDeclarationType: TDeclarationType;
    fVisibility: TVisibility;
    fIsPacked: boolean;
    fCORItem: TContainerEntry;

  protected
    function ReadString(Stream: TStream; var Str: string): integer; overload; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ENDIF}
    function ReadString(Stream: TStream): string; overload;                   {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ENDIF}
    function WriteString(Stream: TStream; const Str: string): integer;        {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ENDIF}

    procedure SetDeclarationType(aDeclarationType: TDeclarationType); virtual;
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry);  {$IFDEF DLLABSTRACTION}dynamic;Abstract;{$ENDIF}
    destructor Destroy;                                         {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    {Erstellt aus der Klasse einen Namesverbund, dessen Besitzer durch @ getrennt sind
     z.b.
     UnitName.Klassename.Methodename.ParameterName}
    function GetNamePathOf(Item : TBaseEntry) : String; overload; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ENDIF}
    {Erstellt aus dieser Klasse einen Namesverbund, dessen Besitzer durch @ getrennt sind}
    function GetNamePathOfSelf : String; overload; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ENDIF}

    procedure Load(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    {Vollst�ndige Deklaration}
    property Declaration: string read fDeclaration write fDeclaration;
    function GetDeclaration: PChar; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    {Deklarationsart im Quellcode}
    property DeclarationType: TDeclarationType
      read fDeclarationType write SetDeclarationType;

    {Deklarationsname}
    property Name: string read fName write fName;

    {vorangestellter Kommentar}
    property Comment: string read fComment write fComment;
    {nachgestellt Kommentar in derselben Zeile}
    property SingleComment: string read fSingleComment write fSingleComment;

    {zugeh�rige Compilerdirektiven}
    //         property Switch : TSwitch read fSwitch write fSwitch;

    property FileName : String read fFileName write fFileName; 
    property Line : Int64 read fLine write fLine;


    {Klassentyp}
    property Kind: TIOClassType read fKind;

    {Sichtbarkeit in Klassen}
    property Visibility: TVisibility read fVisibility write fVisibility;

    {Packdeklaration f�r Arrays,Klassen,Objekte und records}
    property IsPacked: boolean read fIsPacked write fIsPacked;

    {Zugeh�rige Elternklasse, die eine Liste besitzt, worin das Child enthalten ist.}
    property Parent : TContainerEntry read fCORItem write fCORItem;
  end;


  {TContainerEntry = class(TBaseEntry)}
  TContainerEntry = class(TBaseEntry)
  private
    fItems: TList;
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry); {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
    destructor Destroy;                                       {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    procedure Load(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}


    {L�scht alle Unterobjekte}
    procedure Clear;  {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ENDIF}

    {@Name f�gt einen neuen Item in Items ein.}
    procedure Add(anItem : TBaseEntry); {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    {}
    property Items: TList read fItems;
  end;

  {Unit-deklarations Container}
  TUnit = class(TContainerEntry)
  private
    fUsesUnits: TStringList;
    fLibrary: boolean;
    fLines : Integer;
    fFileName : String;
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry);{$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    destructor Destroy; {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Load(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    {Definitionsliste}
    property UsesUnits: TStringList read fUsesUnits;
    property IsLibrary: boolean read fLibrary write fLibrary;

    //@Name wird durch den Programmierer gesetzt, wenn die Daten aus einer Datei stammen  
    property FileName : String read fFilename write fFilename;

    property LineCount : Integer read fLines write fLines;
  end;

      {Standardvariable mit "var" deklariert oder
      auch die eintr�ge in records und klassen}
  TBaseVariableEntry = class(TBaseEntry)
  private
    fType, fValue: string;

  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} virtual; {$ENDIF}
    destructor Destroy; {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}


    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Load(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    {Typenstring der Variable}
    property TypeString: string read fType write fType;
    property Value: string read fValue write fValue;
  end;

  TConstantEntry = class(TBaseVariableEntry)
  protected
    function IsReadOnly: boolean; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry);{$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    property ReadOnly: boolean read IsReadOnly;
  end;

  TTypeEntry = class(TBaseVariableEntry)
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
  end;

  TPropertyEntry = class(TBaseVariableEntry)
  private
    fReadOnly: boolean;
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Load(Stream: TStream);{$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    {wenn eine eigenschaft, kein write stadium besitzt ist readonly wahr.}
    property ReadOnly: boolean read fReadOnly write fReadOnly;
  end;


  TParameter = class(TBaseVariableEntry)
  private
    fDefinition,
    fDefaultValue: string;
  public
    constructor Create(aDeclaration : String; anOwner : TBaseEntry); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Load(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    {wie wurde der Parameter definiert : var oder const oder normal}
    property Definition: string read fDefinition write fDefinition;
    property DefaultValue: string read fDefaultValue write fDefaultValue;
  end;


  TRecordEntry = class(TContainerEntry)
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
  end;



  PAncestor = ^TAncestor;

      {Object Class Interface Item
       noch nicht ausgebaut.}
  TOCIEntry = class(TContainerEntry)
  private
    fAncestors: TList;
    fGuid: TGUID;
    fGUIDStr : String;
    
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry; ContainerTyp: TIOClassType); {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
    destructor Destroy;{$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    procedure Store(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Load(Stream: TStream);{$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    function AddAncestor: PAncestor; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
    procedure DeleteAncestor(Index: integer); {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    property Ancestors: TList read fAncestors;

    procedure Clear; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

        {Container.Guid := StringToGUID(guidstr);
         guidstr := GUIDtoString(Container.Guid);}
    property Guid: TGUID read fGuid write fGuid;
    property GuidAsString: String read fGUIDStr write fGUIDStr;

  end;


      {TAncestor enth�lt Daten �ber die Vorfahren einer Klasse.
      Die Daten k�nnen in zweierlei Form vorkommen
       NameType = TRUE bedeutet, dass genauere Informationen zu diesem Vorfahre nicht vorhanden sind, au�er dessen Name
       = FALSE, bedeutet, dass Informationen zu Vorfahren vorhanden sind.
      }
  TAncestor = record
    Size: integer;
    NameSize : Integer;
    NamePath : PCHAR;

    {case NameType: boolean of
      True: (NameString: ShortString);
      False: (NameObject: TOCIEntry); }
  end;

  {$IFNDEF DLLABSTRACTION}
  {Erstellt eine @PAncester Verbund. Wird in @PascalScanner.TPascalScanner.ScanOci verwendet.}
  function aCreateAnchestorPtr(aPathName : String) : PAncestor;
  {$ENDIF}

type
      {Funktions oder Procedure deklaration.
      Unterscheidung zwischen ihnen durch IsProcedure m�glich.}
  TFunctionEntry = class(TContainerEntry)
  private
    fResult, fCallConvention: string;
  protected
    procedure SetDeclarationType(aDeclarationType: TDeclarationType); override;
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry);{$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
    destructor Destroy; {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

    procedure Clear;  {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    {�berpr�ft, ob es sich um eine Prozedur handelt.}
    function IsProcedure: boolean; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    function IsDestructor: boolean; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
    function IsConstructor: boolean; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
    function IsFunction: boolean; {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    procedure Store(Stream: TStream);{$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}
    procedure Load(Stream: TStream); {$IFDEF DLLABSTRACTION}override;Abstract;{$ELSE} override; {$ENDIF}

         {F�gt an das Ende der Liste einen neuen Parameter ein.
         Definition gibt die �bergabeart an : var,const}
    function AddParameter(Name, TypeString, Definition,
      DefaultValue: string): TParameter;{$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}

    {Parameterliste}
    property Parameters: TList read fItems;

    {R�ckgabewerttyp}
    property Return: string read fResult write fResult;

    {Aufrufkonventionen : stdcall;}
    property CallConvention: string read fCallConvention write fCallConvention; //

  end;

  {Mehtodenereignis}
  TTypeFunctionEntry = class(TFunctionEntry)
  public
    constructor Create(aDeclaration: string; anOwner : TBaseEntry);  {$IFDEF DLLABSTRACTION}virtual;Abstract;{$ELSE} virtual; {$ENDIF}
  end;

  TBaseEntryClass = class of TBaseEntry;
  TContainerEntryClass = class of TContainerEntry;
  TUnitClass = class of TUnit;
  TBaseVariableClass = class of TBaseVariableEntry;
  TConstantClass = class of TConstantEntry;
  TTypeClass = class of TTypeEntry;
  TPropertyClass = class of TPropertyEntry;
  TParameterClass = class of TParameter;
  TRecordClass = class of TRecordEntry;
  TOCIItemClass = class of TOCIEntry;
  TFunctionClass = class of TFunctionEntry;
  TTypeFunctionClass = class of TTypeFunctionEntry;

type
  TProcGeTBaseEntryClass = function (ClassType : TBaseEntryClass): TBaseEntryClass; stdcall;


implementation

{$IFNDEF DLLABSTRACTION}
function aCreateAnchestorPtr(aPathName : String){(aNameType: boolean)}: PAncestor;
var
  Size: integer;
begin
  Size := SizeOf(TAncestor);

  try
    GetMem(Result, Size);
  except
    raise;
  end;

  Result^.Size := Size;

  Result^.NameSize := SizeOf(PCHAR)+Length(aPathName);

  GetMem(Result^.NamePath, Result^.NameSize);
  StrLCopy(Result^.NamePath,PCHAR(aPathName),Result^.NameSize);
end;

constructor TPropertyEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_property;
  ReadOnly := False;
end;


procedure TPropertyEntry.Store(Stream: TStream);
begin
  inherited;
  Stream.Write(fReadOnly,SizeOf(fReadOnly));
end;

procedure TPropertyEntry.Load(Stream: TStream);
begin
  inherited;
  Stream.Read(fReadOnly,SizeOf(fReadOnly));
end;



constructor TOCIEntry.Create(aDeclaration: string; anOwner : TBaseEntry; ContainerTyp: TIOClassType);
begin
  inherited Create(aDeclaration,anOwner);
  fKind := ContainerTyp;
  fAncestors := TList.Create;
end;

destructor TOCIEntry.Destroy;
begin
  Clear;
  if Assigned(fAncestors) then
    FreeAndNil(fAncestors);
  inherited;
end;

procedure TOCIEntry.Store(Stream: TStream);
var ii : Integer;
    s : String;
begin
   inherited;
  Stream.Write(fGuid,SizeOf(fGuid));
  WriteString(Stream,fGUIDStr);

  Stream.Write(fAncestors.Count,SizeOf(Integer));

  for ii := 0 to fAncestors.Count -1 do
  begin
    with PAncestor(fAncestors.Items[ii])^ do
    begin
      s := String(NamePath);
      WriteString(Stream,s);
    end;
  end;
end;

{ Size: integer;
    case NameType: boolean of
      True: (NameString: ShortString);
      False: (NameObject: TOCIEntry);
 }
procedure TOCIEntry.Load(Stream: TStream);
var ii,c,Namesize : Integer;
    P : pchar;
    s  : String;
    PA : PAncestor;
begin
  inherited;
  Stream.Read(fGuid,SizeOf(fGuid));
  ReadString(Stream,fGUIDStr);

  Stream.Read(c,SizeOf(Integer));
  Clear;

  for ii := 0 to c -1 do
  begin
     ReadString(Stream,s);
     PA := aCreateAnchestorPtr(s);
     fAncestors.Add(Pa);
   end;
end;



function TOCIEntry.AddAncestor: PAncestor;
begin
  Result := aCreateAnchestorPtr(GetNamePathOfSelf);
  //(aNameType);
  fAncestors.Add(Result);
end;

procedure TOCIEntry.DeleteAncestor(Index: integer);
var
  P: PAncestor;
begin
  P := PAncestor(fAncestors.Items[Index]);
  FreeMem(P^.NamePath,P^.NameSize);
  if Assigned(P) then
    FreeMem(P,P^.Size);
  fAncestors.Items[Index] := nil;
  fAncestors.Delete(Index);
end;

procedure TOCIEntry.Clear;
var
  ii: integer;
begin
  if not Assigned(fAncestors) then
   fAncestors := TList.Create;
  for ii := fAncestors.Count - 1 downto 0 do
  begin
    DeleteAncestor(ii);
  end;
//  fItems.Clear;
end;


constructor TRecordEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_record;
end;


{********* TContainerEntry **************}
constructor TContainerEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_container;
  fItems := TList.Create;
end;

destructor TContainerEntry.Destroy;
begin
  Self.Clear;
  try
   fItems.Free;
  finally
   fItems := nil;
  end;
  inherited;
end;

procedure TContainerEntry.Add(anItem : TBaseEntry);
begin
  if not Assigned(fItems) then
    fItems := TList.Create;

  anItem.fCORItem := self;
  fItems.Add(anItem);
end;

procedure TContainerEntry.Clear;
var 
  ii: integer;
begin
  if not Assigned(fItems) then
    fItems := TList.Create;
   
  for ii := fItems.Count - 1 downto 0 do
  begin
    if Assigned(fItems[ii]) then
    begin
      try
        TBaseEntry(fItems[ii]).Free;
      finally
        //fItems[ii] := nil;
      end;
    end;
  end;
  fItems.Clear;
end;

procedure TContainerEntry.Load(Stream: TStream);
var
  II: integer;
  MyItem: TRegPersistent;
  MyClass: TPersistentClass;
begin
  inherited;

  Clear;
  Stream.Read(II, SizeOf(II));

  for ii := 0 to II - 1 do
  begin
    MyClass := LoadClass(Stream);
    try
     MyItem := MyClass.Create(Self);
     try
       MyItem.Load(Stream);
     except
      raise;
     end;
    except
       FreeAndNil(MyItem);
    end;
    if Assigned(MyItem) then
    begin
      TBaseEntry(MyItem).Parent := self;
      Self.fItems.Add(MyItem);
    end;
  end;
end;

procedure TContainerEntry.Store(Stream: TStream);
var
  II: integer;
begin
  inherited;

  II := Self.fItems.Count;
  Stream.Write(II, SizeOf(II));

  for ii := 0 to Self.fItems.Count - 1 do
  begin
    RegClasses.StoreClass(Stream, TBaseEntry(fItems[ii]));
    TBaseEntry(fItems[ii]).Store(Stream);
  end;
end;

{********** TTypeEntry ************}

constructor TTypeEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_Type;
end;


constructor TTypeFunctionEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  fKind := ct_TypeFunction;
  inherited;
end;




constructor TConstantEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_Constant;
end;

function TConstantEntry.IsReadOnly: boolean;
begin
  Result := Length(TypeString) = 0;
end;



{*************** TBaseEntry ****************}

constructor TBaseEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  fDeclaration := aDeclaration;
  fKind := ct_Item;
  fOwner := anOwner;
end;

destructor TBaseEntry.Destroy;
begin
  inherited;
end;


function TBaseEntry.GetNamePathOfSelf : String;
begin
  result := GetNamePathOf(Self);
end;

function TBaseEntry.GetNamePathOf(Item : TBaseEntry) : String;
var P : TBaseEntry;
    Items : Array of TBaseEntry;
    i : Integer;
begin
  if not Assigned(Item) then exit;
  P := Item;
  while P.Owner <> nil do
  begin
    SetLength(Items,Length(Items)+1);
    Items[Length(Items)-1] := TBaseEntry(P.Owner);
    P := TBaseEntry(P.Owner);
  end;
  for i := Length(Items)-1 downto 0 do
  begin
    if Length(Result) > 0 then
     result := result + '@';
    result := result + Items[i].Name;
  end;
  if Length(Result) > 0 then
     result := result + '@';
  result := result + Item.Name;
end;


function TBaseEntry.GetDeclaration: PChar;
begin
  Result := PChar(fDeclaration);
end;



function TBaseEntry.ReadString(Stream: TStream): string;
begin
  ReadString(Stream,result);
end;
function TBaseEntry.ReadString(Stream: TStream; var Str: string): integer;
var 
  StrLen: integer;
begin
  Result := -1;
  try
    Result := Stream.Read(StrLen, SizeOf(StrLen));
    SetLength(Str, StrLen);
    Inc(Result, Stream.Read(Str[1], StrLen));
  except
    Str := '';
  end;
end;

function TBaseEntry.WriteString(Stream: TStream; const Str: string): integer;
var
  StrLen: integer;
begin
  StrLen := Length(Str);
  Result := Stream.Write(StrLen, SizeOf(StrLen));
  Inc(Result, Stream.Write(Str[1], StrLen));
end;

procedure TBaseEntry.Load(Stream: TStream);
begin
  Stream.Read(fKind,SizeOf(fKind));
  ReadString(Stream, Self.fDeclaration);
  Stream.Read(Self.fDeclarationType, SizeOf(TDeclarationType));
  ReadString(Stream, Self.fName);
  ReadString(Stream, Self.fComment);
  ReadString(Stream, Self.fSingleComment);
  //  Switch.Load(Stream);
  Stream.Read(fKind, SizeOf(TIOClassType));
  Stream.Read(Self.fVisibility, SizeOf(TVisibility));
  Stream.Read(Self.fIsPacked, SizeOf(boolean));

  Stream.Read(fLine,SizeOf(fLine));
  fFileName := ReadString(Stream);

//  ReadString(Stream,);
end;




procedure TBaseEntry.Store(Stream: TStream);
begin
  Stream.Write(fKind,SizeOf(fKind));
  WriteString(Stream, Self.fDeclaration);
  Stream.Write(Self.fDeclarationType, SizeOf(TDeclarationType));
  WriteString(Stream, Self.fName);
  WriteString(Stream, Self.fComment);
  WriteString(Stream, Self.fSingleComment);
  //  Switch.Load(Stream);
  Stream.Write(fKind, SizeOf(TIOClassType));
  Stream.Write(Self.fVisibility, SizeOf(TVisibility));
  Stream.Write(Self.fIsPacked, SizeOf(boolean));

  Stream.Write(fLine,SizeOf(fLine));
  WriteString(Stream,fFileName);

//  WriteString(Stream,GetNamePathOf(Owner));
//  WriteString(Stream,GetNamePathOf(Parent));
end;

procedure TBaseEntry.SetDeclarationType(aDeclarationType: TDeclarationType);
begin
  fDeclarationType := aDeclarationType;
end;



{************** Tunit *****************}


constructor TUnit.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fUsesUnits := TStringList.Create;
  fKind := ct_Unit;
end;

destructor TUnit.Destroy;
begin
  fUsesUnits.Free;
  Clear;
  inherited;
end;

procedure TUnit.Store(Stream: TStream);
var 
  ii: integer;
begin
  inherited;
  Stream.Write(fLines, SizeOf(fLines));
  fUsesUnits.SaveToStream(Stream);
end;

procedure TUnit.Load(Stream: TStream);
var
  ii: integer;
  MyItem: TRegPersistent;
  MyClass: TPersistentClass;
begin
  inherited;

  //  Items.Clear;
  Stream.Read(fLines, SizeOf(fLines));

  fUsesUnits.LoadFromStream(Stream);
end;




(*Definitionen*)
constructor TBaseVariableEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_BaseVariable;
end;

destructor TBaseVariableEntry.Destroy;
begin
  inherited;
end;

constructor TParameter.Create(aDeclaration : String; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_Parameter;
end;

procedure TParameter.Store(Stream: TStream);
begin
  inherited;
  Stream.Write(fDefinition, SizeOf(fDefinition));
  Stream.Write(fDefaultValue, SizeOf(fDefaultValue));
end;

procedure TParameter.Load(Stream: TStream);
begin
  inherited;
  Stream.Read(fDefinition, SizeOf(fDefinition));
  Stream.Read(fDefaultValue, SizeOf(fDefaultValue));
end;


procedure TBaseVariableEntry.Store(Stream: TStream);
begin
  WriteString(Stream,fType);
  WriteString(Stream,fValue);

end;
procedure TBaseVariableEntry.Load(Stream: TStream);
begin
  ReadString(Stream,fType);
  ReadString(Stream,fValue);
end;


function deletewhitespaces(str : String) : String;
begin
  result := StringReplace(Str,' ','',[rfReplaceAll]);
end;


procedure TFunctionEntry.SetDeclarationType(aDeclarationType: TDeclarationType);
begin
  if (Kind = ct_Function) and (aDeclarationType = dt_type) then
   fKind := ct_TypeFunction
  else
   fKind := ct_Function;
  inherited;
end;

(*hier sind probleme!!!
z.b. procedure kann auch im string vorkommen wenn es eigentlich eine funktion ist
aber bei einer typ-funktion steht das gleichheitszeichen davor, weshalb = 1 nicht funkz*)

function GetRightSide(const Str : String) : String;
var p : Integer;
begin
  result := Str;
  p := pos('=',Str);

  if p > 0 then
    Delete(result,1,p);
end;

function IsClassFunc(const Declaration : String) : Boolean;
begin
  Result := (pos('CLASS', Uppercase(deletewhitespaces(Declaration))) = 1);
end;

function CheckForWord(Kind : TIOClassType; Declaration: String; const aWord : String) : Boolean;
var i : Integer;
begin
  if Kind = ct_typefunction then
  begin
    Result := (pos(aWord, Uppercase(deletewhitespaces(GetRightSide(Declaration)))) = 1);
  end
  else
  begin
    if IsClassFunc(Declaration) then
      Delete(Declaration,1,pos(' ',Declaration));

    Result := (pos(aWord, Uppercase(deletewhitespaces(Declaration))) = 1);
  end;
end;




function TFunctionEntry.IsProcedure: boolean;
begin
  //if DeclarationType = dt_Type then
  result := CheckForWord(Kind,Declaration,'PROCEDURE');
end;

function TFunctionEntry.IsFunction: boolean;
begin
(*  if Kind = ct_typefunction then
  begin
    Result :=  (pos('FUNCTION', Uppercase(deletewhitespaces(GetRightSide(Declaration)))) = 1);
  end
  else
  Result :=  (pos('FUNCTION', Uppercase(deletewhitespaces(Declaration))) = 1);*)
  result := CheckForWord(Kind,Declaration,'FUNCTION');
end;


function TFunctionEntry.IsConstructor: boolean;
begin
  result := CheckForWord(Kind,Declaration,'CONSTRUCTOR');
//  Result := (pos('CONSTRUCTOR', Uppercase(deletewhitespaces(Declaration))) = 1);
end;

function TFunctionEntry.IsDestructor: boolean;
begin
  result := CheckForWord(Kind,Declaration,'DESTRUCTOR');
//  Result :=  (pos('DESTRUCTOR', Uppercase(deletewhitespaces(Declaration))) = 1);
end;



function TFunctionEntry.AddParameter(Name, TypeString, Definition,
  DefaultValue: string): TParameter;
var 
  Parameter: TParameter;
begin
  Parameter := TParameter.Create('',Self);
  Parameter.Name := Name;
  Parameter.TypeString := TypeString;
  Parameter.Definition := Definition;
  Parameter.DefaultValue := DefaultValue;

  if Length(Definition) > 0 then
    Definition := Definition + ' ';

  if Length(Typestring) > 0 then
    Typestring := ':' + Typestring;
  if Length(DefaultValue) > 0 then
    DefaultValue := '=' + DefaultValue;

  Parameter.Declaration := Definition + Name +Typestring + DefaultValue;
  Parameters.Add(Parameter);

  Result := Parameter;
end;

constructor TFunctionEntry.Create(aDeclaration: string; anOwner : TBaseEntry);
begin
  inherited;
  fKind := ct_Function;
//  fParameters := TList.Create;
end;



procedure TFunctionEntry.Store(Stream: TStream);
var
  II: integer;
begin
  inherited;
  WriteString(Stream,fResult);
  WriteString(Stream,fCallConvention);

{  II := Self.fParameters.Count;
  Stream.Write(II, SizeOf(II));

  for ii := 0 to Self.fParameters.Count - 1 do
  begin
    RegClasses.StoreClass(Stream, TBaseEntry(fParameters[ii]));
    TBaseEntry(fParameters[ii]).Store(Stream);
  end;    }
end;


procedure TFunctionEntry.Load(Stream: TStream);
var
  II: integer;
  MyItem: TRegPersistent;
  MyClass: TPersistentClass;
begin
  inherited;
  ReadString(Stream,fResult);
  ReadString(Stream,fCallConvention);

 { Clear;
  Stream.Read(II, SizeOf(II));

  for ii := 0 to II - 1 do
  begin
    MyClass := LoadClass(Stream);
    MyItem := MyClass.Create(Self);
    MyItem.Load(Stream);
    TBaseEntry(MyItem).Parent := self;
    Self.fParameters.Add(MyItem);
  end;       }
end;



procedure TFunctionEntry.Clear;
var  ii : Integer;
begin
 { for ii := Parameters.Count -1 downto 0 do
  begin
    TParameter(Parameters.Items[ii]).Free;
    Parameters.Items[ii] := nil;
  end;
  Parameters.Clear;  }
  inherited Clear;
end;

destructor TFunctionEntry.Destroy;
begin
  Clear;
 // FreeAndNil(fParameters);
  inherited;
end;
{$ENDIF}

initialization
  RegisterClass(TUnit);
  RegisterClass(TBaseEntry);
  RegisterClass(TContainerEntry);
  RegisterClass(TUnit);
  RegisterClass(TBaseVariableEntry);
  RegisterClass(TConstantEntry);
  RegisterClass(TTypeEntry);
  RegisterClass(TPropertyEntry);
  RegisterClass(TParameter);
  RegisterClass(TRecordEntry);
  RegisterClass(TOCIEntry);
  RegisterClass(TFunctionEntry);
  RegisterClass(TTypeFunctionEntry);
end.

unit RegClasses;

interface

uses Classes;


type  
  TPersistentClass = class of TRegPersistent;

  TRegPersistent = class(TPersistent)
   fOwner : TRegPersistent;
  protected
    class procedure PutClass(Stream: TStream);
    class function GetClass(Stream: TStream): TPersistentClass;
  public
    constructor Create(aOwner : TRegPersistent); virtual;

    procedure InitLoad;
    procedure DoneLoad;
    procedure Load(Stream: TStream); virtual;
    procedure Store(Stream: TStream); virtual;

    property Owner : TRegPersistent read fOwner write fOwner;
  end;


procedure StoreClass(Stream: TStream; aClass: TRegPersistent);
function LoadClass(Stream: TStream): TPersistentClass;


procedure RegisterClass(aClass: TPersistentClass; Alias: ShortString = '');
function FindClassName(ClassName: ShortString): TPersistentClass;

implementation

uses SysUtils;

var
  List: TStringList;




function ReadString(Stream: TStream; var Str: ShortString): integer;
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

function WriteString(Stream: TStream; const Str: ShortString): integer;
var 
  StrLen: integer;
begin
  StrLen := Length(Str);
  Result := Stream.Write(StrLen, SizeOf(StrLen));
  Inc(Result, Stream.Write(Str[1], StrLen));
end;

procedure RegisterClass(aClass: TPersistentClass; Alias: ShortString = '');
begin
  if Alias = '' then
    Alias := aClass.ClassName;
  List.AddObject(Alias, Pointer(aClass));
end;


function FindClassName(ClassName: ShortString): TPersistentClass;
var
  index: integer;
begin
  index := 0;
  if not List.Find(ClassName, index) then
    raise Exception.Create('Class not found ' + ClassName);
  Result := TPersistentClass(List.Objects[index]);
end;

class procedure TRegPersistent.PutClass(Stream: TStream);
begin
  WriteString(Stream, Self.ClassName);
end;

class function TRegPersistent.GetClass(Stream: TStream): TPersistentClass;
var 
  sClassName: ShortString;
begin
  ReadString(Stream, sClassName);
  Result := FindClassName(sClassName);
end;

constructor TRegPersistent.Create(aOwner : TRegPersistent);
begin
  inherited Create;
  fOwner := aOwner;
end;

var StreamClassArray : Array of TRegPersistent;

procedure TRegPersistent.InitLoad;
begin
  SetLength(StreamClassArray,0);
end;

procedure TRegPersistent.DoneLoad;
begin

end;

procedure TRegPersistent.Load(Stream: TStream);
begin

end;

procedure TRegPersistent.Store(Stream: TStream);
begin
end;

procedure StoreClass(Stream: TStream; aClass: TRegPersistent);
begin
  aClass.PutClass(Stream);
end;


function LoadClass(Stream: TStream): TPersistentClass;
begin
  Result := TPersistentClass.GetClass(Stream);
end;


initialization
  List := TStringList.Create;
  List.Sorted := True;

finalization
  List.Free;
  List := nil;
end.

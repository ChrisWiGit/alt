{
@abstract(dtSystem.pas beinhaltet grundlegende Funktionen f�r den Umgang mit Delphi)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}
unit dtSystem;

interface
uses Windows,Classes,SysUtils,TypInfo;


const
      {Return ist eine Konstante die einen Standard-Zeilenumbruch darstellt}
      Return = #10#13;


      CharBufferLen512    = 512;
      CharBufferLen       = CharBufferLen512;
      CharBufferLen1024   = 1024;

      {iTRUE liefert den Integerwert einen booleschen TRUE-Wertes zur�ck : 1
      Siehe auch @link(iFALSE)}
      iTRUE               = Integer(TRUE);
      {iFALSE liefert den Integerwert einen booleschen iFALSE-Wertes zur�ck : 0
      Siehe auch @link(iTRUE)}
      iFALSE              = Integer(FALSE);

      {TStrBoolean liefert den deutschen Text eines boolean Wertes. }
      TStrBoolean : array[FALSE..TRUE] of string = ('Falsch', 'Wahr');

      NullStr = '';

                       
{NOP ist eine Platzhalterprozedur, um den Delphi-Editor davon abzuhalten, Funktionen
aus dem Quelltext zu nehmen.
Sie hat sonst keinerlei Funktion.}
procedure NOP;

{SetPoint erzeugt einen TPoint-Record mit den angegeben Koordinaten.}
function SetPoint(x, y: Integer): TPoint;

{TStrBoolean vertauscht zwei Variablen}
procedure ChangeVar(var a, b: integer);

{GetProperties listet alle Eigenschaftsnamen eines Objekts Obj als Strings in Items auf.
Items muss vorher erzeugt werden.}
procedure GetProperties(Obj: TObject; Items: TStrings);

{CompareInt vergleicht wie CompareStr zwei Integervariablen.
Der R�ckgabewert ist dergleiche, wie CompareText.}
function CompareInt(i1, i2: Integer): Integer; overload;

{CompareInt vergleicht wie CompareStr zwei Integervariablen als Text.
Der R�ckgabewert ist dergleiche, wie CompareText.}
function CompareInt(i1, i2: string): Integer; overload;

{IsValidObject testet ob eine Objektvariable noch g�ltig ist (TRUE).
Es k�nnen auch Objektvariablen �bergeben werden , die nicht mehr eindeutig als g�ltig zu indentifizieren sind
mehr zu dem Thema ung�litge Objektvariablen , in der mitgelieferten Textdatei "Objekteigenschaft.txt"}
function IsValidObject(Obj : TObject) : Boolean;

{StrIdx macht case-Anweisung auch mit Strings m�glich
aus PC Magazin August 2001 - Seite 208
Bsp.
   case strIdx(edit1.Text, ['eins','zwei','drei']) of
    0 : listbox1.Itemindex := 0;
    1 : listbox1.Itemindex := 1;
    2 : listbox1.Itemindex := 2;
    3 : listbox1.Itemindex := 3;
   end;
}
function StrIdx(needle : String; stack : array of String) : Integer;

implementation
uses dtStringsRes;

procedure NOP;
begin
end;

function SetPoint(x, y: Integer): TPoint;
begin
  Result.X := x;
  Result.Y := y;
end;


procedure ChangeVar(var a, b: integer);
var h: integer;
begin
  h := a; a := b; b := h;
end;

procedure GetProperties(Obj: TObject; Items: TStrings);
var
  i: integer;
  PropList: TPropList;
begin
  i := 0;
  GetPropList(
    Obj.ClassInfo,
    tkProperties + [tkMethod],
    @PropList);
  while ((nil <> PropList[i]) and
    (i < High(PropList))) do
  begin
    Items.Add(
      PropList[i].Name + ': ' +
      PropList[i].PropType^.Name);
    Inc(i);
  end;
end;

function CompareInt(i1, i2: Integer): Integer;
begin
  if i1 < i2 then
    Result := -1
  else
    Result := +1;
end;

function CompareInt(i1, i2: string): Integer;
var i3, i4: Integer;
  b: Boolean;
begin
  result := 0;
  b := TRUE;
  try
    i3 := StrToInt(i1);
    i4 := StrToInt(i2);
  except
    b := FALSE;
    Result := CompareText(i1, i2);
  end;

  if b then
    Result := CompareInt(i3, i4);
end;

function IsValidObject(Obj : TObject) : Boolean;
begin
  Result := Assigned(Obj);
  if Result then
  begin
    try
      Obj.ClassName;  //wir testen , ob das Objekt noch g�ltig ist
    except
      Result := FALSE;
    end;
  end;
end;

function StrIdx(needle : String; stack : array of String) : Integer;
var x : IntegeR;
begin
  result := -1;
  for x := 0 to high(stack) do
  begin
    if (needle = stack[x]) then
     begin
       result := x;
       break;
     end;
  end;
end;

end.


{Schemes Version 1.0 (OpenSource)
 use it along with your SynEdit to improve user comfort and give the possibility to change color of a synedit

 created by author (removed)
 on 24th March 2003

 you will new following compontents, units or files to compile successfully
  SynEdit Component (http://sourceforge.net/project/showfiles.php?group_id=3221&release_id=16920)
  pascalcodeview.txt (see in procedure InitCodeViews at the end of file)

  build in delphi 5)

  Use this unit and its childs in all your applications for free and with special license.
  But honor the author and show his name and email in your credits.

  You will use this code at your own risk!

  why this unit?
    schemes are pre-defined color schemes that can be used in your synedits immeaditly.
    codeviews are pre-defined preview code examples to be shown with a specifc synhighlighter.
     that means a pascal/delphi highlighter will use a Delphi code as an preview e.g. in a SyntaxColorDlg.
  how to use it?
    There are many examples in the constant part of this unit that shows you how to usw
    a highlighter scheme.
    Be sure you know the proper attribute names (e.g. shown in elements list in SyntaxColorDlg) and
    put as many as needed into the Attribut array (TScheme.)Attributes. Be aware there is no case sensetive!
    If there are less attributes than supported by array you can leave them all blank, than they will be ignored.
    Now you knows all your attributes used, you can define their fore-,background color and font styles in TAttribute record.
    Clnone defines that there will no color be uesd (transparent) and [] means that the font has no style.
    The (TScheme.)Backgroundcolor defines the color of your synedit component to be set.
    SupportedSynClasses contains all classes that have the same attributes defined in Attributes.
    So they are supported by this scheme.

    then : Create a scheme with CreateScheme and create a SyntaxColorForm and put
     the schemes into the SchemesComboBox.

    TSyntaxHighlightForm(Sender).SchemesComboBox.Items.AddObject('Mytest',Pointer(MyScheme));
    Since the schemes will live after the dialog's destruction, myscheme must be initialized once
     in your own code :
    var myscheme : PScheme;
        myscheme := Schemes.CreateScheme(MyScheme);
    freeing is not necessary!

    Some hints :
     Especially, if you supports synhighlighter classes that do not own attributes that are defined in (TScheme.)Attributes
     the function SetHighlighter will thrown an exception
     SupportedSynClasses is only a information that shows you where you can use it. So be aware of it.

    CodeView will be used in the same way :
      set the synhighlighter class type of your code preview -> supportedclass
      write your code preview into codestring using PCHAR.
      Use GetCodeView to obtain the right (and first) code preview (in list) to a synhightlighter.

   any other tips :
    do not use NullScheme and NullCodeView in any routines.
    they are only code examples.


   knwon bugs :
     maybe there are memory leaks in finalization


   available schemes :
   for Delphi and C++
    DelphiStandardScheme
    DelphiClassicScheme
    DelphiDawnScheme
    DelphiOceanScheme
****  created by  **************
*  Corpsman (Corpsman@web.de)  *
********************************

  available codeviews:
    Delphi

}
unit Schemes;

interface
uses Graphics,
  SynHighlighterCpp, SynEditHighlighter,SynEditKeyCmds,SynEditTypes,SynEditMiscClasses,SynEdit,
  SynHighlighterPas,
  SynHighlighterKix,
  SynHighlighterGeneral, SynHighlighterJava,
  SynHighlighterM3, SynHighlighterHP48, SynHighlighterHC11,
  SynHighlighterASM, SynHighlighterADSP21xx, SynHighlighterSQL,
  SynHighlighterCache, SynHighlighterCAC, SynHighlighterTclTk,
  SynHighlighterPython, SynHighlighterPerl, SynHighlighterBat,
  SynHighlighterVBScript, SynHighlighterPHP, SynHighlighterJScript,
  SynHighlighterCss,SynHighlighterHTML;


type
  {class reference to synhighlighter base class}
  TSynClass = class of TSynCustomHighlighter;

  {maximum of supported syn classes is 16}
  TSynClasses = array[1..16] of TSynClass;

  {@name contains fore- and background color of an Highlighterattribute}
  TAttributeColor = record
    ForeGround,BackGround : TColor;
  end;

  {Attribute record
   AttributeName is the name of property to change (its proper name!!but not its name shown in code explorer)
                 in a synhighlighter - to get its proper names read the elements list of hightlighter config dialog
   AttributeColor contains fore- and background color of attribute
   AttributeStyle contains font style of attribute}
  TAttribute = record
    AttributeName : ShortString;
    AttributeColor : TAttributeColor;
    AttributeStyle : TFontStyles;
  end;
  TAttributes = array[1..16] of TAttribute;

  PScheme = ^TScheme;
  {MainScheme record.
  SupportedSynClasses contains all synhighlighter classes that are supported by this scheme, maximum 16
  Attributes contains all Attributes and its data to change in a highlighter
  Background is the color of a synedit 
  }
  TScheme = Record
    SupportedSynClasses : TSynClasses;
    Attributes : TAttributes;
    BackGround : TColor;
  end;

  PCodeView = ^TCodeView;
  {CodeView main record
   contains data, necessary to show a code example with a syntaxhighlighter
   SupportedSynClass is a highlighter class that fits to code example
   Size is the length of Codestring, set to 0 to let define its size by intern routines.
   CodeString contains code example to be shown}
  TCodeView = record
    SupportedSynClass : TSynClass;
    Size : Integer;
    CodeString : PCHAR;
  end;


var {DelphiCode View initialized by InitCodeViews and textfile}
    DelphiCodeView : TCodeView =
    (SupportedSynClass: TSynPasSyn;
     Size : 0;
     Codestring : 'procedure'#0);

const
      {Constant example. Do not use!}
      NullCodeView : TCodeView =
      (SupportedSynClass: nil;
      Codestring : '');


      {Constant example. Do not use!}
      NullScheme : TScheme =
     (SupportedSynClasses: (nil,nil,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil);
      Attributes:((AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[])
                  );
       BackGround : clnone;
       );
    {Start with Delphi schemes here}
     DelphiStandardScheme : TScheme =
     (SupportedSynClasses: (TSynPasSyn,TSynCppSyn,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil);

     Attributes:((AttributeName:'Assembler';
                    AttributeColor: (ForeGround:CLblack;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Comment';
                    AttributeColor: (ForeGround:CLnavy;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Identifier';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Reserved Word';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[fsbold]),
                  (AttributeName:'Number';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Space';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'String';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Symbol';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[])
                  );
      BackGround : clwindow;

       );

     DelphiClassicScheme : TScheme =
     (SupportedSynClasses: (TSynPasSyn,TSynCppSyn,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil);

     Attributes:((AttributeName:'Assembler';
                    AttributeColor: (ForeGround:CLlime;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Comment';
                    AttributeColor: (ForeGround:CLsilver;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Identifier';
                    AttributeColor: (ForeGround:clyellow;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Reserved Word';
                    AttributeColor: (ForeGround:clwhite;
                                     BackGround:clnone);
                    AttributeStyle:[fsbold]),
                  (AttributeName:'Number';
                    AttributeColor: (ForeGround:clyellow;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Space';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'String';
                    AttributeColor: (ForeGround:clyellow;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Symbol';
                    AttributeColor: (ForeGround:clyellow;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[])
                  );
      BackGround : clnavy;

       );


     DelphiDawnScheme : TScheme =
     (SupportedSynClasses: (TSynPasSyn,TSynCppSyn,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil);

     Attributes:((AttributeName:'Assembler';
                    AttributeColor: (ForeGround:CLlime;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Comment';
                    AttributeColor: (ForeGround:CLsilver;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Identifier';
                    AttributeColor: (ForeGround:clwhite;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Reserved Word';
                    AttributeColor: (ForeGround:claqua;
                                     BackGround:clnone);
                    AttributeStyle:[fsbold]),
                  (AttributeName:'Number';
                    AttributeColor: (ForeGround:clFuchsia;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Space';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'String';
                    AttributeColor: (ForeGround:clyellow;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Symbol';
                    AttributeColor: (ForeGround:claqua;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[])
                  );
      BackGround : clblack;
       );



     DelphiOceanScheme : TScheme =
     (SupportedSynClasses: (TSynPasSyn,TSynCppSyn,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil,
                            nil,nil,nil,nil);

     Attributes:((AttributeName:'Assembler';
                    AttributeColor: (ForeGround:CLblue;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Comment';
                    AttributeColor: (ForeGround:CLGray;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Identifier';
                    AttributeColor: (ForeGround:clblue;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Reserved Word';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[fsBold]),
                  (AttributeName:'Number';
                    AttributeColor: (ForeGround:clolive;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Space';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'String';
                    AttributeColor: (ForeGround:clPurple;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'Symbol';
                    AttributeColor: (ForeGround:clblack;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[]),
                  (AttributeName:'';
                    AttributeColor: (ForeGround:clnone;
                                     BackGround:clnone);
                    AttributeStyle:[])
                  );
      BackGround : claqua;

       );
{End of Delphie schemes}

{@name replaces data of synedit with a scheme.
It raises an exception, if scheme does not support syn or
scheme contains attributes that are not found in syn.}
procedure SetHighlighter(Scheme : TScheme;Syn : TSynCustomHighlighter);

{@name creates a scheme out of a synhighlighter}
function CreateSchemeRecord(Syn : TSynCustomHighlighter; BackGround : TColor = clnone) : TScheme;

{@name determines, if a scheme supportes synhighlighter (TRUE)}
function IsClassofSchemeSupported(Syn : TSynCustomHighlighter; Scheme : TScheme) : Boolean;

{@name creates a copy of scheme in memory and returns a pointer to that scheme.
An intern list will be used to get along with all schemes}
function CreateScheme(aScheme : TScheme) : PScheme;

{@name erases a scheme from memory and list.
At the end of execution all schemes created by CreateScheme will be deleted automatically! Do not use other routines!}
procedure FreeScheme(var p : PScheme);

{@name creates a pointer to a TCodeView record and adds it to a intern list.}
function CreateCodeView(aView : TCodeView) : PCodeView;
{@name frees a codeview created by CreateCodeView.
At the end of execution all CodeViews created by CreateCodeView will be deleted automatically! Do not use other routines!}
procedure FreeCodeView(var p : PCodeView);
{@name returns a codeview associated with a highlighter.
It finds the first codeview in memory that supports the highlighter by TCodeView.SupportedSynClass}
function GetCodeView(Highlighter : TSynCustomHighlighter) : PCodeView;


implementation
uses Sysutils,Classes;

var SchemeList,CodeList : TList;

function GetCodeView(Highlighter : TSynCustomHighlighter) : PCodeView;
var i : Integer;
begin
  result := nil;
  for i := 0 to CodeList.Count -1 do
  begin
    if PCodeView(CodeList.Items[i])^.SupportedSynClass = HighLighter.ClassType then
    begin
      result := PCodeView(CodeList.Items[i]);
      exit;
    end;
  end;
end;

function CreateCodeView(aView : TCodeView) : PCodeView;
var Size : Integer;
begin
  if aView.Size = 0 then
  begin
    Size := StrLen(aView.CodeString);
    aView.Size := Size;
  end
  else
    Size := aView.Size;


  GetMem(result,SizeOf(TCodeView)+Size);
  //GetMem(result^.CodeString,aView.Size);
  result^ := aView;
  CodeList.Add(result);
end;

procedure FreeCodeView(var p : PCodeView);
  procedure ClearOutOfList;
  var i : Integer;
  begin
    for i := 0 to CodeList.Count -1 do
    begin
      if p = CodeList.Items[i] then
      begin
        CodeList.Delete(i);
        exit;
      end;
    end;
  end;
begin
    ClearOutOfList;
  try
  //  FreeMem(p^.CodeString,p^.Size);
    FreeMem(p,SizeOf(TScheme)+p^.Size);
  finally
   p := nil;

  end;
end;

function CreateScheme(aScheme : TScheme) : PScheme;
begin
  GetMem(result,SizeOf(TScheme));
  result^ := aScheme;
  SchemeList.Add(result);
end;

procedure FreeScheme(var p : PScheme);
  procedure ClearOutOfList;
  var i : Integer;
  begin
    for i := 0 to SchemeList.Count -1 do
    begin
      if p = SchemeList.Items[i] then
      begin
        SchemeList.Delete(i);
        exit;
      end;
    end;
  end;
begin
    ClearOutOfList;
  try
    FreeMem(p,SizeOf(TScheme));
  finally
   p := nil;

  end;
end;

function IsClassofSchemeSupported(Syn : TSynCustomHighlighter; Scheme : TScheme) : Boolean;
var ii : Integer;
begin
    result := FALSE;
    for ii := 1 to high(Scheme.SupportedSynClasses) do
    begin
      if (Scheme.SupportedSynClasses[ii] <> TSynCustomHighlighter)and (Syn is Scheme.SupportedSynClasses[ii]) then
      begin
        result := TRUE;
        exit;
      end;
    end;
end;

function CreateSchemeRecord(Syn : TSynCustomHighlighter; BackGround : TColor = clnone) : TScheme;
  procedure GetAttributes;
  var ii : Integer;
  begin
    ii := 1;
    while (ii <= High(TAttributes)) and (ii < Syn.AttrCount) do
    begin
      result.Attributes[ii].AttributeName := Syn.Attribute[ii-1].Name;
      result.Attributes[ii].AttributeColor.ForeGround := Syn.Attribute[ii-1].Foreground;
      result.Attributes[ii].AttributeColor.BackGround := Syn.Attribute[ii-1].Background;
      result.Attributes[ii].AttributeStyle := Syn.Attribute[ii-1].Style;
      Inc(ii)
    end;
  end;
begin
  FillChar(result,SizeOf(Result),#0);
  result.SupportedSynClasses[1] := TSynClass(Syn.ClassType);
  result.BackGround := BackGround;
  GetAttributes;
end;

procedure SetHighlighter(Scheme : TScheme;Syn : TSynCustomHighlighter);

  function GetAttribute(aName : shortString) : TSynHighlighterAttributes;
  var ii : Integer;
  begin
    result := nil;
    if Length(aName) = 0 then exit;
    for ii := 0 to Syn.AttrCount-1 do
    begin
      if (CompareText(Syn.Attribute[ii].Name,aName) = 0) then
      begin
        result := Syn.Attribute[ii];
        exit;
      end;
    end;
    raise Exception.CreateFmt('SetHighlighter: An attribute with name "%s" does not exist in class "%s" (%s)!',[aName,Syn.Name,Syn.ClassName]);
  end;



var ii : Integer;
    Attribute : TSynHighlighterAttributes;
begin
  if not IsClassofSchemeSupported(Syn,Scheme) then
    Raise Exception.CreateFmt('SetHighlighter: Actual scheme does not support highlighter : "%s" (%s)!',[Syn.Name,Syn.ClassName]);

  for ii := 1 to High(Scheme.Attributes) do
  begin
    Attribute := GetAttribute(Scheme.Attributes[ii].AttributeName);
    if Assigned(Attribute) then
    begin
      Attribute.Foreground := Scheme.Attributes[ii].AttributeColor.ForeGround;
      Attribute.BackGround := Scheme.Attributes[ii].AttributeColor.BackGround;
      Attribute.Style      := Scheme.Attributes[ii].AttributeStyle;
    end;
  end;
end;


procedure ClearSchemes;
var p : PScheme;
    i : Integer;
begin
  for i := SchemeList.Count -1 downto 0 do
  begin
    P := PScheme(SchemeList.Items[i]);
    try
      FreeScheme(P);
    except
    end;
  end;
end;

procedure ClearViews;
var p : PCodeView;
    i : Integer;
begin
  for i := CodeList.Count -1 downto 0 do
  begin
    P := PCodeView(CodeList.Items[i]);
    try
      FreeCodeView(P);
    except
    end;
  end;
end;

procedure InitCodeViews;
var s : TStringList;
begin
  s := TStringList.Create;
  try
   s.LoadFromFile('pascalcodeview.txt');
  except
   s.Free;
   exit;
  end;  
  DelphiCodeView.CodeString := PCHAR(s.GetText);
  s.Free;
end;

initialization
 SchemeList := TList.Create;
 CodeList := TList.Create;
 InitCodeViews;
finalization
 ClearSchemes;
 SchemeList.Free;
 ClearViews;
 CodeList.Free;
end.

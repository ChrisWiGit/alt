{
@abstract(dtCl.pas beinhaltet Funktionen mit dem Umgang von Steuerelementen)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtCL;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls ;

type 
     {TStateTyp gibt an was mit dem Control passieren soll - wird u.a. von ChangeControlsState verwendet}
     TStateType = (st_Enabled, st_Visible, st_Enabled_Visible);
     {Wird von ClearNodes vor dem l�schen aufgerufen,wenn programm-spezifische Daten des Baumeeintrages gel�scht werden soll.
     Dieses Ereignis wird in Klassen verwendet}
     TOnClearNode = procedure(Node: TTreeNode) of object;
     {Wird von ClearNodes vor dem l�schen aufgerufen,wenn programm-spezifische Daten des Baumeeintrages gel�scht werden soll.
     Dieses Ereignis wird in Units verwendet.}
     TOnClearNode2 = procedure(Node: TTreeNode);

     {TOnNode wird von GetAllNodes aufgerufen, wenn durch alle Knoten des Baumes gesprungen wird.
     Dieses Ereignis wird in Klassen verwendet}
     TOnNode = procedure(Node: TTreeNode; Data: Pointer) of object;
     {TOnNode wird von GetAllNodes aufgerufen, wenn durch alle Knoten des Baumes gesprungen wird.
     Dieses Ereignis wird in Units verwendet.}
     TOnNode2 = procedure(Node: TTreeNode; Data: Pointer);

     {TButtonStyle wird von BorderButton verwendet und definiert das Aussehen eines Buttons.
      Statisch - Flach und Normal}
     TButtonStyle = (Static, Sunken, Normal);

     {TOnAdd wird von CreateDirTreeView, GetNodeByText, GetSubNode und InsertDir verwendet, um
      das Verhalten vor dem Einf�gen eines Knotens in den Baum zu kontrollieren.
      Node beschreibt den einzuf�gendenden Knoten.
      Path beschreibt den vollst�ndigen Pfad bis zu diesem Knoten als String.
      CanAdd gibt an, ob dieser Knoten eingef�gt werden soll.
     }
     TOnAdd = procedure(Node : TTreeNode; Path : String; var CanAdd : Boolean) of object;


{Setzt die Eigenschaft Enabled/Visible/Beide aller untergeordnete Steuerelemente auf den Wert "d", ohne
Maincontrol dabei zu ver�ndern.

Der R�ckgabewert ist die Anzahl der ver�nderten Unterkontrollelemente.}
function ChangeControlsState(d_Type: TStateType; d: Boolean; MainControl: TWinControl): Integer;

{Setzt die Eigenschaft Enabled/Visible/Beide aller untergeordnete Steuerelemente - mit der Ausnahme ExControls1 -
auf den Wert "d", ohne Maincontrol dabei zu ver�ndern.
Der Array kann aus Klassennamen, Kontrollnamen als String oder Typenbezeichnung bestehen.

Der R�ckgabewert ist die Anzahl der ver�nderten Unterkontrollelemente.}
function ChangeControlsStateEx(d_Type: TStateType; d: Boolean; MainControl: TWinControl;const ExControls1: array of const): Integer;

{Liefert das Unterelement von Owner zur�ck , da� denselben Klassennamen ClassName (als Typname) und dieselbe Eigenschaft Tag = TagNo besitzt}
function FindControlWithTagNo(Owner: TWinControl; ClassName: TClass; TagNo: Integer): TWinControl;
{Liefert das Unterelement von Owner zur�ck , da� denselben Klassennamen ClassName (als String) und dieselbe Eigenschaft Tag = TagNo besitzt}
function FindControlStrWithTagNo(Owner: TWinControl; ClassName: string; TagNo: Integer): TWinControl;

{L�scht alle Knoten im Baum Nodes.
Damit auch die Eigenschaft Data jedes Knotens entfernt werden kann,
werden zuerst zu jedem Knoten das Ereignis OnClearNode aufgerufen
Hierin kann dann Data (Pointer) entsorgt werden, was die Methode Clear von TTreeNodes normalerweise nicht tut.
Danach wird der Baum dann mit Clear gel�scht.
Diese Prozedur wird aufgerufen, wenn die Ereignisbehandlungsroutine eine Methode ist.}
procedure ClearNodes(Nodes: TTreeNodes; OnClearNode: TOnClearNode); overload;

{L�scht alle Knoten im Baum Nodes.
Damit auch die Eigenschaft Data jedes Knotens entfernt werden kann,
werden zuerst zu jedem Knoten das Ereignis OnClearNode aufgerufen
Hierin kann dann Data (Pointer) entsorgt werden, was die Methode Clear von TTreeNodes normalerweise nicht tut.
Danach wird der Baum dann mit Clear gel�scht.
Diese Prozedur wird aufgerufen, wenn die Ereignisbehandlungsroutine eine Prozedur ist.}
procedure ClearNodes(Nodes: TTreeNodes; OnClearNode: TOnClearNode2); overload;


{GetAllNodes durchl�uft index-orientiert alle Knoten eines Baumes, und liefert
der Ereignisbehandlungsroutine den Parameter Data und den aktuellen Knoten zur�ck.
Diese Prozedur wird aufgerufen, wenn die Ereignisbehandlungsroutine eine Methode ist.
}
procedure GetAllNodes(Nodes: TTreeNodes; OnNode: TOnNode; Data: Pointer); overload;

{GetAllNodes durchl�uft index-orientiert alle Knoten eines Baumes, und liefert
der Ereignisbehandlungsroutine den Parameter Data und den aktuellen Knoten zur�ck.
Diese Prozedur wird aufgerufen, wenn die Ereignisbehandlungsroutine eine Prozedur ist.
}
procedure GetAllNodes(Nodes: TTreeNodes; OnNode: TOnNode2; Data: Pointer); overload;



{BorderButton �ndert das Aussehen eines TButton-Kontrollelementes.}
procedure BorderButton(aButton: TButton; Style: TButtonStyle);

{DoHilight l�sst eine Tableiste "Tab" , "Times"-mal blinken , jeweils mit einer Dauer von "PeriodeTime" msek.
Einmal blinken (an - aus) dauert damit  "PeriodeTime"-mal.
Wenn Times = -1 ist ,wird bei StopOnVisible solange geblinkt bis das Tabsheet aktiviert wird.
StopOnVisible gibt an , ob das Blinken vorzeitig gestoppt werden soll , wenn die Tableiste aktiviert wird
Wenn TRUE wird kein Blinken initiert , wenn die Tableiste schon aktiviert ist.}

procedure DoHilight(Times, PeriodeTime: Integer; StopOnVisible: Boolean; Tab: TTabsheet);



{CreateDirTreeView erstellt aus einer Stringliste , gef�llt mit Verzeichnispfaden , einen Verzeichnisbaum,
der an den Knoten "Parent" angeh�ngt wird. (kann auch nil sein ,damit der ganze Baum genutzt wird)
OnAdd wird immer dann aufgerufen , wenn ein neues Unterverzeichnis erstellt werden soll
ist CanADD false , werden keine Unterverzeichnisse mehr erstellt. Allerdings bleiben , alle davor erstellten ,
�bergeordneten Verzeichnisse erhalten.
Der R�ckgabewert ist die Anzahl , der eingef�gten Verzeichnisse}
function CreateDirTreeView(TreeView : TTreeView; Parent : TTreeNode; DirList : TStringList; OnAdd : TOnAdd) : Cardinal;

{GetNodeByText liefert den Knoten zur�ck, der (ohne Ber�cksichtigung von Gro�- und Kleinschreibung)
denselben Text besitzt, wie in Name angegeben. Wenn Parent nicht nil ist, werden alle Unterknoten von Parent
nach dem Namen durchsucht.
$$$ Nicht vollst�ndig fertiggestellt!
}
function GetNodeByText(Nodes:TTreeNodes;Parent : TTreeNode; Name : String) : TTreeNode;

{$$$ Nicht vollst�ndig fertiggestellt!}
function GetSubNode(Nodes:TTreeNodes;Parent : TTreeNode; Path,Name : String; var c : Integer;OnAdd : TOnAdd) : TTreeNode;

{$$$ Nicht vollst�ndig fertiggestellt!}
function InsertDir(Nodes:TTreeNodes;Parent : TTreeNode; Path : String; OnAdd : TOnAdd) : Integer;

implementation
uses dtSystem,dtFiles,dtStrings,dtStringsRes;

function ChangeControlsState(d_Type: TStateType; d: Boolean; MainControl: TWinControl): Integer;
var k, i: Integer;
begin
  Result := 0;
  if not Assigned(MainControl) then exit;
  k := 0;
  for i := 0 to MainControl.ControlCount - 1 do
  begin
    case d_Type of
      st_Enabled: MainControl.Controls[i].Enabled := d;
      st_Visible: MainControl.Controls[i].Visible := d
    else
      begin
        MainControl.Controls[i].Enabled := d;
        MainControl.Controls[i].Visible := d;
      end;
    end;
    Inc(k);
  end;
  MainControl.Update;
  Result := k;
end;

function ChangeControlsStateEx(d_Type: TStateType; d: Boolean; MainControl: TWinControl;
  const ExControls1: array of const): Integer;
var k, i, z: Integer;
  l, l2: Boolean;
begin
  Result := 0;
  if not Assigned(MainControl) then exit;
  k := 0;
  for i := 0 to MainControl.ControlCount - 1 do
  begin
    l2 := FALSE;
    case d_Type of
      st_Enabled: l := d;
      st_Visible: l := d;
    else
      begin
        l := d;
        l2 := d;
      end;
    end;
    for z := Low(ExControls1) to High(ExControls1) do
    begin
      if ((ExControls1[z].VObject <> nil) and
        (ExControls1[z].VObject = MainControl.Controls[i]))
        then
      begin
        case d_Type of
          st_Enabled: l := MainControl.Controls[i].Enabled;
          st_Visible: l := MainControl.Controls[i].Visible;
        else
          begin
            l := MainControl.Controls[i].Enabled;
            l2 := MainControl.Controls[i].Visible;
          end;
        end;
      end
      else
        if ((ExControls1[z].VPChar <> '') and
          (CompareText(string(ExControls1[z].VPChar), MainControl.Controls[i].Name) = 0))
          then
        begin
          case d_Type of
            st_Enabled: l := MainControl.Controls[i].Enabled;
            st_Visible: l := MainControl.Controls[i].Visible;
          else
            begin
              l := MainControl.Controls[i].Enabled;
              l2 := MainControl.Controls[i].Visible;
            end;
          end;
        end
        else
          if (ExControls1[z].VInteger > 0) and
            (ExControls1[z].VInteger = i + 1) then
          begin
            case d_Type of
              st_Enabled: l := MainControl.Controls[i].Enabled;
              st_Visible: l := MainControl.Controls[i].Visible;
            else
              begin
                l := MainControl.Controls[i].Enabled;
                l2 := MainControl.Controls[i].Visible;
              end;
            end;
          end;
    end;
    MainControl.Controls[i].Enabled := l;
    case d_Type of
      st_Enabled: MainControl.Controls[i].Enabled := l;
      st_Visible: MainControl.Controls[i].Visible := l;
    else
      begin
        MainControl.Controls[i].Enabled := l;
        MainControl.Controls[i].Visible := l2;
      end;
    end;
    Inc(k);
  end;
  MainControl.Update;
  Result := k;
end;


function FindControlWithTagNo(Owner: TWinControl; ClassName: TClass; TagNo: Integer): TWinControl;
var i: Integer;
begin
  Result := nil;
  if not Assigned(Owner) then exit;

  for i := 0 to Owner.ControlCount - 1 do
  begin
    if (Owner.Controls[i] is ClassName) and (Owner.Controls[i].Tag = TagNo) then
    begin
      Result := TWinControl(Owner.Controls[i]);
      exit;
    end;
  end;
end;

function FindControlStrWithTagNo(Owner: TWinControl; ClassName: string; TagNo: Integer): TWinControl;
var i: Integer; s: string;
begin
  Result := nil;
  if not Assigned(Owner) then exit;

  for i := 0 to Owner.ControlCount - 1 do
  begin
    s := Owner.Controls[i].ClassName;
    if (CompareText(s, ClassName) = 0) and (Owner.Controls[i].Tag = TagNo) then
    begin
      Result := TWinControl(Owner.Controls[i]);
      exit;
    end;
  end;
end;

procedure GetAllNodes(Nodes: TTreeNodes; OnNode: TOnNode; Data: Pointer);
var i: Integer;
begin
  ASSERT(Assigned(Nodes));
  if Assigned(OnNode) and (Nodes.Count > 0) then
    for i := Nodes.Count - 1 downto 0 do
      OnNode(Nodes[i], Data);
end;

procedure GetAllNodes(Nodes: TTreeNodes; OnNode: TOnNode2; Data: Pointer);
var i: Integer;
begin
  ASSERT(Assigned(Nodes));
  if Assigned(OnNode) and (Nodes.Count > 0) then
    for i := Nodes.Count - 1 downto 0 do
      OnNode(Nodes[i], Data);
end;

procedure ClearNodes(Nodes: TTreeNodes; OnClearNode: TOnClearNode);
var i: Integer;
begin
  ASSERT(Assigned(Nodes));
  if Assigned(OnClearNode) and (Nodes.Count > 0) then
    for i := Nodes.Count - 1 downto 0 do
      OnClearNode(Nodes[i]);
  Nodes.Clear;
end;

procedure ClearNodes(Nodes: TTreeNodes; OnClearNode: TOnClearNode2);
var i: Integer;
begin
  ASSERT(Assigned(Nodes));
  if Assigned(OnClearNode) and (Nodes.Count > 0) then
    for i := Nodes.Count - 1 downto 0 do
      OnClearNode(Nodes[i]);
  Nodes.Clear;
end;

procedure DoHilight(Times, PeriodeTime: Integer; StopOnVisible: Boolean; Tab: TTabsheet);
var i: Integer;
begin
  i := 0;
  while (i < times) or ((Times = -1) and StopOnVisible) do
  begin
    if StopOnVisible and (Assigned(Tab.Parent)) and (TPageControl(Tab.Parent).ActivePage = Tab) then break;
    Tab.Highlighted := TRUE;
    Application.ProcessMessages;
    sleep(PeriodeTime div 2);
    Tab.Highlighted := FALSE;
    Application.ProcessMessages;
    sleep(PeriodeTime div 2);
    Inc(i);
  end;
end;


procedure BorderButton(aButton: TButton; Style: TButtonStyle);
var bx, by, bheight, bwidth: integer;
begin
  case Style of
    Static: SetWindowLong(aButton.Handle, GWL_EXSTYLE, WS_EX_STATICEDGE);
    Sunken: SetWindowLong(aButton.Handle, GWL_EXSTYLE, WS_EX_CLIENTEDGE);
    Normal: SetWindowLong(aButton.Handle, GWL_EXSTYLE, WS_EX_WINDOWEDGE);
  end;
  bx := aButton.Left;
  by := aButton.Top;
  bwidth := aButton.Width;
  bheight := aButton.Height;
  SetWindowPos(aButton.Handle, HWND_TOP, bx, by, bwidth, bheight, SWP_FRAMECHANGED);
end;



function CreateDirTreeView(TreeView : TTreeView; Parent : TTreeNode; DirList : TStringList; OnAdd : TOnAdd) : Cardinal;
var N : TTreeNode;
    i,Count : Integer;
begin
  Result := 0;
  for i := 0 to DirList.Count -1 do
  begin
    Inc(Result,InsertDir(TreeView.Items,Parent,DirList[i],OnAdd));
  end;
end;

function GetNodeByText(Nodes:TTreeNodes;Parent : TTreeNode; Name : String) : TTreeNode;
var i : Integer;
begin
  result := nil;
  if not Assigned(Parent) then
  begin
    if Assigned(Nodes) and (Nodes.Count > 0) and
    (CompareText(Nodes[0].Text,Name) = 0) then
     result := Nodes[0]
  end
  else
  begin
    for i := 0 to Parent.Count -1 do
     if CompareText(PArent.Item[i].Text,Name) = 0 then
       result := Parent.Item[i];
  end;
end;



function GetSubNode(Nodes:TTreeNodes;Parent : TTreeNode; Path,Name : String; var c : Integer;OnAdd : TOnAdd) : TTreeNode;
var CanAdd : Boolean;
begin
  c := 0;
  result := GetNodeByText(Nodes,Parent,Name);

  if Assigned(OnAdd) then
  begin
    CanAdd := Assigned(Result);
    OnAdd(Parent,Path,CanAdd);
    if not CanAdd then begin result := nil; exit; end;
  end;

  if Assigned(result) then exit;

  if not Assigned(result) then result := Parent;
  result := Nodes.AddChild(result,Name);
  Inc(c);
end;

function InsertDir(Nodes:TTreeNodes;Parent : TTreeNode; Path : String; OnAdd : TOnAdd) : Integer;
var i,Count,c : Integer;
    s : String;
begin
   Count := StrToInt(GetDirName(-1,Path));
   result := 0;
   for i := 0 to Count -1 do
   begin
     s := GetDirName(i,Path);
     Parent := GetSubNode(Nodes,Parent,Path,s,c,OnAdd);
     if not Assigned(Parent) then exit;
     Inc(Result,c);
   end;
end;

end.

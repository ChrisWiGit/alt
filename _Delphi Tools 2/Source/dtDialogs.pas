{*******************************************
 *  DelphiTools Version 2.x
 *  07/09/2002
 *  Unit : dtDialogs
 *  created by removed
 *******************************************}

unit dtDialogs;

interface
uses windows,classes,dialogs,Forms,StdCtrls,SysUtils,Controls,Buttons,Graphics;

type
  TDialogData = record
    Owner: TComponent;
    PassWord,
      MasterPassWord: string;
    MinLength, MaxLength: Integer;
    PassWordChar: Char;
    CaseSensitive: Boolean;
    Label1, Label2, Label3: string;
    Ok1, Ok2, Cancel: string;
    Caption: string;
    AllowDelPassWord: boolean;

    MasterPassWordUsed: Boolean;
    PassWordDeleted: Boolean;

  end;

type
  TOnExtraPaint = procedure(Sender: TObject; Canvas: TCanvas) of object;

  TStreamType = (st_Write, st_Read); //in Stream schreiben oder lesen
     //Schreibt oder liest (StreamType) die Daten eines Controls in/aus einen Stream und liefert die
     //geschriebenen/gelesen Bytes zur�ck
  TOnDialogControlWrite = function(Control: TControl; Stream: TStream; StreamType: TStreamType): Longint;
     //analog
  TOnDialogControlRead = TOnDialogControlWrite;


     //Erweitertes TForm mit Dialogmethoden
  TDialog = class(TForm)
  public
    procedure GetData; virtual; //Aufruf nach Dialogschluss (immer)
         //Weil diese Methode immer bei der Beendigung aufgerufen wird sollte mit ModalResult
                                       //die Sachlage erfragt werden : if ModalResult <> mrOk then Exit;
    procedure SetData; virtual; //Aufruf vor dem Dialog zeigen
    function Execute: Boolean; virtual; // Ausf�hren des Dialogs
    function ShowModal: Integer; override; //�quivalent zum Vorg�nger

  end;

  TDialogExt = class(TForm)
  public
    constructor Create(AOwner: TComponent); override;

    procedure GetData(var DoClose: Boolean); virtual;
    procedure SetData; virtual;

    procedure OnDoCloseQuery(Sender: TObject; var CanClose: Boolean); virtual;
    function Execute: Boolean; virtual; // Ausf�hren des Dialogs
    function ShowModal: Integer; override;
  end;


var
  ButtonNames: array[mrNone..mrAll] of string = (
   // '','OK','Cancel','Abort','Retry', 'Ignore','Yes', 'No','All');
    '','','','','', '','', '','');

  PassWordChar: Char = '*';

//Enth�lt das ParentFensterHandle f�r Anwendungsbezogene Dialogboxen , aufgerufen von SHGetSpecialFolderLocation
//Standard ist das DesktopFenster.
const SHLApplicationHandle : THandle = 0;


//Gibt eine Nachricht aus einer String-Resou4rce aus
function MessageDialog(const Indent: Integer; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
//Mit FormatString�bergabe (siehe Format)
function MessageFormat(const Indent: Integer; const Args: array of const; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;

function MessageDlgExt(const aMessage: string; const Args: array of const; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;

//1.307
function MessageDlgCaption(const aMessage,aCaption: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;


//1.308
//L�sst die �nderung der Beschriftung zu durch ButtonNames
{begin
  ButtonNames[mrOK] := 'Okedele';
  MessageDlgBtnCaption('asd','asd',mtInformation,[mbok,mbcancel,mbyes,mbno,mbRetry,mbIgnore,mball],0);
end;
 hier wird der OK-Button mit Okedele beschriftet dargestellt
 Hinweis : wenn die Titelzeile nicht ge�ndert werden soll,
  dann einfach einen leeren String an den Parameter aCaption �bergeben

}
function MessageDlgBtnCaption(const aMessage,aCaption: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;


//Erstellt einen Nachrichtendialog (wie MessageDlg) mit einer CheckBox
//Den CheckBox-Namen wird in HideLabel angegeben
//Die Position innerhalb des Dialogs wird in HidePos definiert
//HideClick gibt an , ob die CheckBox einen Haken besitzt oder nicht

function MsgDlg_CustomHideClick(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HideLabel: string; HidePos: TRect; var HideClick: Boolean): Word;
//MsgDlg_HideClick fungiert wie MsgDlg_CustomHideClick , nur da� die CheckBox am linken unteren Rand vordefiert dargestellt ist
function MsgDlg_HideClick(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HideLabel: string; var HideClick: Boolean): Word;


procedure DoMsgFlash;


//Wie InputQuery nur wird das Editierfeld mit Passwordchar verwendet.
//PassWordChar ist das Zeichen , welches im Editierfeld gezeigt wird.
function InputPassWordDlg(Owner: TComponent; const ACaption, APrompt: string; var Value: string): Boolean;
//Mit Hilfe eines Windowhandles
function InputPassWordDlgFoc(Handle: Longint; const ACaption, APrompt: string; var Value: string): Boolean;
//Nach Count-Milisekunden wird der Dialog abgebrochen
//Der R�ckgabewert betr�gt dann mrNone
//Sonst TRUE oder FALSE
function InputPassWordDlgCount(Owner: TComponent; const ACaption, APrompt: string; var Value: string; Count: Integer): Integer;


function DefPassWordDlg(var Data: TDialogData): boolean;
function GetDialogData(aOwner: TComponent): TDialogData;



//Gibt ein Objekt TForm mit dem SplashBitmap zur�ck
//Wie lange es angezeigt wird , wird in DelayTime (in Milisekunden : 1s = 100ms) angegeben
//Wenn DelayTime kleiner oder gleich 0 ist wird keine AutoClose verwendet
//Das Ereignis OnExtraPaint wird bei OnActivate ausgel�st (Bei OnPaint gibt es rekursive Aufrufe!!)
//Damit kann man Extras auf das Bitmap bringen


//In der Unit SplashForm existiert die Klasse TSplashDlg , welche verwendet wird
//Um etwas auf die Zeichenfl�che zu zeichnen , mu� man das ImageObject SplashImage.Canvas von TSplashDlg verwenden
//Um einfach nur einen Text auszugeben kann man StringLabel (vom Typ TLabel) verwenden
//Dabei mu� man beachten , da� die Positioneneigenschaften (Left,Top,Height,Width) eingestellt werden
//Und zus�tzlich Visible von StringLabel auf TRUE gestellt wird (Standard : FALSE)
//Eine Eigenschaft von TSplashDlg ist AllowClose, die wenn FALSE verhindert , da� der Benutzer den
//Dialog schlie�en kann.

//Um die Eigenschaften von SplashDlg mit SplashScreen verwenden zu k�nnen mu� eine TypUmwandlung stattfinden
{ uses ...,SplashForm,...
  var x : TSplashDlg
  begin
    x := TSplashDlg(SplashScreen(...));
    ...
    x.Free;
}
function SplashScreen(SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): TForm;

//Gibt ein modalses SplashBitmap mit dem Dateinamen SplashBitmap auf dem Bildschirm aus
function ModalSplashScreen(SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): Boolean;

function ResIDSplashScreen(aInstance: THandle; SplashBitmap: Integer; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): TForm;
function ResIDModalSplashScreen(aInstance: THandle; SplashBitmap: Integer; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): Boolean;
function ResNameSplashScreen(aInstance: THandle; SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): TForm;
function ResNameModalSplashScreen(aInstance: THandle; SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): Boolean;




//Definiert eine Funktion , die Daten von Controls speichert bzw. auslie�t und
//die geschriebenen/gelesenen Bytes zur�ckgibt
function DefOnDialogControlStream(Control: TControl; Stream: TStream; StreamType: TStreamType): Longint;

//Geht durch alle Controls von Form , um diese dann mit OnDialogControlWrite
//derren Inhaltsdaten zu speichern
//Der r�ckgabewert ist die Anzahl der gespeicherten Bytes
function DialogDataToStream(Stream: TStream; Form: TComponent; OnDialogControlWrite: TOnDialogControlWrite): Longint;
//analog zu DialogDataToStream f�r auslesen eines Streams in die Controls
function DialogDataFromStream(Stream: TStream; Form: TComponent; OnDialogControlRead: TOnDialogControlRead): Longint;
//Lieftert die Anzahl der Komponenten in Form zur�ck
function CountDialogComponents(Form: TComponent): Longint;


//gibt per MessageDlg eine Fehler-Dialogbox mit OK-Button aus
//
procedure MsgError(const Msg: string; HelpCtx : Integer = 0);overload;
procedure MsgError(const Msg: string; const Args: array of const);overload;





implementation
uses dtSystem,dtResource,dtStream,dtStringsRes,
    DelphiToolsForm1,
    DelphiToolsForm2,
    SplashForm
    ;

var
    DoFlash: Boolean = FALSE;



constructor TDialogExt.Create(AOwner: TComponent);
begin
  inherited;
  OnCloseQuery := OnDoCloseQuery;
end;

procedure TDialogExt.GetData(var DoClose: Boolean);
begin
  DoClose := TRUE;
end;

procedure TDialogExt.SetData;
begin
  //nothing to do here
end;

procedure TDialogExt.OnDoCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  GetData(CanClose);
end;

function TDialogExt.Execute: Boolean;
begin
  Result := self.ShowModal = mrOK;
end;

function TDialogExt.ShowModal: Integer;
begin
  SetData;
  Result := inherited ShowModal;
end;

procedure TDialog.GetData;
begin
  //nothing to do here
  if ModalResult <> mrOk then Exit; //Do not execute if user hasn't clicked the okbutton
end;

procedure TDialog.SetData;
begin
  //nothing to do here
end;

function TDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOK;
end;

function TDialog.ShowModal: Integer;
begin
  SetData;
  Result := inherited ShowModal;
  GetData;
end;


function MessageDialog(const Indent: Integer; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
var Str: string;
begin
  FlashWindow(GetFocus, TRUE);
  Str := '';
  if (not LoadToStr(Str, Indent)) then
    raise Exception.CreateFmt(
      'MessageDialog meldet ,da� der String mit der Nummer : %d'#13 +
      'nicht gefunden wurde.', [Indent]);
  Result := MessageDlg(Str, aType, abuttons, helpCtx);
  FlashWindow(GetFocus, FALSE);
end;


function MessageFormat(const Indent: Integer; const Args: array of const; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
var Str: string;
begin
  FlashWindow(GetFocus, TRUE);
  Str := '';
  if (not LoadToStr(Str, Indent)) then
    raise Exception.CreateFmt(
      'MessageDialog meldet , da� der String mit der Nummer : %d'#13 +
      'nicht gefunden wurde.', [Indent]);
  Str := Format(Str, Args);
  Result := MessageDlg(Str, aType, abuttons, helpCtx);
  FlashWindow(GetFocus, FALSE);
end;


function MessageDlgExt(const aMessage: string; const Args: array of const; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  FlashWindow(GetFocus, TRUE);
  Result := MessageDlg(Format(aMessage, Args), AType, AButtons, HelpCtx);
end;


function MessageDlgCaption(const aMessage,aCaption: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
var Dlg : TForm;
begin
   Dlg := CreateMessageDialog(aMessage, AType, AButtons);
   with Dlg do
    try
      HelpContext := HelpCtx;
//      HelpFile := HelpFileName;  //kommt in die Parameterzeile, wenn gew�nscht : HelpFileName : String;
      Caption := aCaption;
      Result := ShowModal;
    finally
      Free;
    end;
end;

function MessageDlgBtnCaption(const aMessage,aCaption: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
var i : Integer;
    dlg : TForm;
begin
   Dlg := CreateMessageDialog(aMessage, AType, AButtons);
   with Dlg do
    try
      HelpContext := HelpCtx;
      Caption := aCaption;

      for i := 0 to ControlCount -1 do
      begin
        if (Controls[i] is TButton) and (Length(ButtonNames[TButton(Controls[I]).ModalResult]) > 0) then
        begin
          try
           TButton(Controls[i]).Caption := ButtonNames[TButton(Controls[i]).ModalResult];
          except
          end;
        end;
      end;
      Result := ShowModal;
    finally
      Free;
    end;
end;


function MsgDlg_CustomHideClick(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HideLabel: string; HidePos: TRect; var HideClick: Boolean): Word;
var F: TForm;
  h: TCheckBox;
begin
  f := CreateMessageDialog(Msg, DlgType, Buttons);
  with f do
  begin
    f.WindowState := wsMaximized;
    h := TCheckBox.Create(f);
    h.Caption := HideLabel;

    if (HidePos.Left = -1) and (HidePos.Top = -1) then
    begin
      h.Left := 5;
      h.Height := F.Canvas.TextHeight(HideLabel) + 4;
      h.Width := f.Canvas.TextWidth(HideLabel) + 20;
      h.Top := f.Height - h.Height * 2 + 2;
      f.Height := f.Height + h.Height;
    end
    else
    begin
      h.Left := HidePos.Left;
      h.Top := HidePos.Top;
      h.Width := HidePos.Right;
      h.Height := HidePos.Bottom;
    end;


    h.Checked := HideClick;
    InsertControl(h);
    Result := ShowModal;
//  h.Visible := TRUE;
//  f.Show;


    HideClick := h.Checked;
  end;
{  h.Free;
  f.Free;}
end;

function MsgDlg_HideClick(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HideLabel: string; var HideClick: Boolean): Word;
var R: TRect;
begin
  SetRect(r, -1, -1, 0, 0);
  Result := MsgDlg_CustomHideClick(Msg, DlgType, Buttons, HideLabel, R, HideClick);
end;


procedure DoMsgFlash;
begin
  DOFlash := not DoFlash;
end;

function InputPassWordDlgCount(Owner: TComponent; const ACaption, APrompt: string; var Value: string; Count: Integer): Integer;
var Form: TPassWordDlg;
  Ret: Integer;
begin
  Form := TPassWordDlg.Create(Owner);
  Form.FormStyle := fsStayOnTop;
  with Form do
  begin
    Caption := ACaption;
    StaticText1.Caption := APrompt;
    Edit1.Text := Value;
    Edit1.PasswordChar := PassWordChar;
    if Count >= 100 then
    begin
      Timer1.Enabled := FALSE;
      Timer1.Interval := Count;
    end
    else
      raise Exception.Create('Countinterval-parameter ist ung�ltig.'#13 +
        'Minimalwert betr�gt 100');
    if Count >= 100 then
      Timer1.Enabled := TRUE;
    ShowCursor(TRUE);
    Ret := ShowModal;
    ShowCursor(FALSE);
    Value := Edit1.Text;
    case ret of
      mrOK: Result := Integer(TRUE);
      mrCancel: Result := Integer(FALSE);
      mrNone: Result := -2;
    else
      result := ret;
    end;
  end;
  Form.Free;
end;

function InputPassWordDlg(Owner: TComponent; const ACaption, APrompt: string; var Value: string): Boolean;
var Form: TForm;
  Label1: TLabel;
  Edit1: TEdit;
  Btn1, Btn2: TBitBtn;
begin
  Form := TForm.Create(Owner);
  Form.BorderStyle := bsDialog;
  Form.BorderIcons := [biSystemMenu];
  Form.Caption := ACaption;
  Form.Position := poScreenCenter;
  Form.Width := 435;
  Form.Height := 140;
  Form.FormStyle := fsStayOnTop;

  Label1 := TLabel.Create(Form);
  Label1.Caption := APrompt;
  Label1.Left := 4;
  Label1.Top := 24;
  Label1.Width := 97;
  Label1.Height := 17;
  Label1.AutoSize := FALSE;
  Label1.Alignment := taRightJustify;

  Form.InsertControl(Label1);

  Edit1 := TEdit.Create(Form);
  Edit1.Text := Value;
  Edit1.PasswordChar := PassWordChar;
  Edit1.Left := 112;
  Edit1.Top := 20;
  Edit1.Width := 301;
  Edit1.Height := 24;
  Edit1.Visible := TRUE;

  Form.InsertControl(Edit1);

  Btn1 := TBitBtn.Create(Form);
  Btn1.Kind := bkOK;
  Btn1.Left := 12;
  Btn1.Top := 68;
  Btn1.Width := 81;
  Btn1.Height := 30;

  Form.InsertControl(Btn1);

  Btn2 := TBitBtn.Create(Form);
  Btn2.Kind := bkCancel;
  Btn2.Left := 100;
  Btn2.Top := 68;
  Btn2.Width := 101;
  Btn2.Height := 30;

  Form.InsertControl(Btn2);
  ShowCursor(TRUE);
  Result := Form.ShowModal = mrOk;
  ShowCursor(FALSE);
  Value := Edit1.Text;

  Form.Free;
end;

function InputPassWordDlgFoc(Handle: Longint; const ACaption, APrompt: string; var Value: string): Boolean;
var Form: TForm;
  Label1: TLabel;
  Edit1: TEdit;
  Btn1, Btn2: TBitBtn;
  aHandle: Longint;
begin
  aHandle := Handle;

  if aHAndle <> 0 then
  begin
    Form := TForm.Create(nil);
    TWinControl(Form).Parent := nil;
    TWinControl(Form).ParentWindow := aHandle;
//   EnableWindow(aHandle,FALSE);
//   ShowWindow(aHandle,SW_HIDE);
  end
  else
    Form := TForm.Create(nil);
  Form.BorderStyle := bsDialog;
  Form.BorderIcons := [biSystemMenu];
  Form.Caption := ACaption;
  Form.Position := poScreenCenter;
  Form.Width := 435;
  Form.Height := 140;

  Label1 := TLabel.Create(Form);
  Label1.Caption := APrompt;
  Label1.Left := 4;
  Label1.Top := 24;
  Label1.Width := 97;
  Label1.Height := 17;
  Label1.AutoSize := FALSE;
  Label1.Alignment := taRightJustify;

  Form.InsertControl(Label1);

  Edit1 := TEdit.Create(Form);
  Edit1.Text := Value;
  Edit1.PasswordChar := PassWordChar;
  Edit1.Left := 112;
  Edit1.Top := 20;
  Edit1.Width := 301;
  Edit1.Height := 24;
  Edit1.Visible := TRUE;

  Form.InsertControl(Edit1);

  Btn1 := TBitBtn.Create(Form);
  Btn1.Kind := bkOK;
  Btn1.Left := 12;
  Btn1.Top := 68;
  Btn1.Width := 81;
  Btn1.Height := 30;

  Form.InsertControl(Btn1);

  Btn2 := TBitBtn.Create(Form);
  Btn2.Kind := bkCancel;
  Btn2.Left := 100;
  Btn2.Top := 68;
  Btn2.Width := 101;
  Btn2.Height := 30;

  Form.InsertControl(Btn2);

  ShowCursor(TRUE);
  Result := Form.ShowModal = mrOk;
  ShowCursor(FALSE);
  Value := Edit1.Text;

  Form.Free;
  if aHAndle <> 0 then
  begin
//   EnableWindow(aHandle,TRUE);
//   ShowWindow(aHandle,SW_SHOW);
  end;
end;

function DefPassWordDlg(var Data: TDialogData): boolean;
var Form: TDefPassDlg;
begin
  Form := TDefPassDlg.Create(Data.Owner);
  Form.MinLength := Data.MinLength;
  Form.MaxLength := Data.MaxLength;

  Form.PassWord := Data.PassWord;
  Form.PassWordChar := Data.PassWordChar;
  Form.CaseSensitive := Data.CaseSensitive;
  Form.MasterPassWord := Data.MasterPassWord;
  Form.AllowDelPassWord := Data.AllowDelPassWord;
  Form.FormStyle := fsStayOnTop;
  if Data.Label1 <> '' then
    Form.StaticText3.Caption := Data.Label1;
  if Data.Label2 <> '' then
    Form.StaticText1.Caption := Data.Label2;
  if Data.Label3 <> '' then
    Form.StaticText2.Caption := Data.Label3;

  if Data.Caption <> '' then
    Form.Caption := Data.Caption;

  with data do
    Form.SetOkCaption(Ok1, Ok2);

  if Data.Cancel <> '' then
    Form.CancelBtn.Caption := Data.Cancel;

  Result := Form.ShowModal = mrOk;
  Data.PassWord := Form.Edit1.Text;

  Data.MasterPassWordUsed := Form.IsUsedMasterPassWord;
  Data.PassWordDeleted := not Form.IsPassWordEnabled;

  Form.Free;
end;

function GetDialogData(aOwner: TComponent): TDialogData;
var t: TDialogData;
begin
  with t do
  begin
    Owner := aOwner;
    PassWord := '';
    MinLength := 0;
    MaxLength := 0;
    PassWordChar := '*';
    CaseSensitive := TRUE;
    Label1 := '';
    Label2 := '';
    Label3 := '';
    Ok1 := '';
    Ok2 := '';
    Cancel := '';
    MasterPassWord := '';
    AllowDelPassWord := FALSE;
  end;
  Result := t;
end;


function SplashScreen(SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): TForm;
var SplashForm: TSplashDlg;
begin
  Result := nil;
  if not FileExists(SplashBitmap) then exit;

  SplashForm := TSplashDlg.Create(ParentWindow);

  SplashForm.OnExtraPaint := OnExtraPaint;

  with SplashForm do
  begin
    try
      SplashImage.Picture.LoadFromFile(SplashBitmap);
    except
      raise Exception.CreateFmt('%s ResourcenID ist nicht g�ltig!', [SplashBitmap]);
    end;
    Width := SplashImage.Picture.Width + 1;
    Height := SplashImage.Picture.Height + 1;
    if DelayTime > 0 then
    begin
      Int := DelayTime - 100;
      Timer.Enabled := TRUE;
    end
    else
      Timer.Enabled := FALSE;

  end;
  Result := SplashForm;
end;

function ModalSplashScreen(SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): Boolean;
var f: TForm;
begin
  F := SplashScreen(SplashBitmap, ParentWindow, DelayTime, OnExtraPaint);
  Result := Assigned(f);
  if not Result then exit;
  f.ShowModal;
  f.Free;
end;

function ResIDModalSplashScreen(aInstance: THandle; SplashBitmap: Integer; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): Boolean;
var f: TForm;
begin
  F := ResIDSplashScreen(aInstance, SplashBitmap, ParentWindow, DelayTime, OnExtraPaint);
  Result := Assigned(f);
  if not Result then exit;
  f.ShowModal;
  f.Free;
end;








function ResIDSplashScreen(aInstance: THandle; SplashBitmap: Integer; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): TForm;
var SplashForm: TSplashDlg;

begin

  if not IsResourceIDValid(aInstance, SplashBitmap, RTBITMAP) then
    raise Exception.CreateFmt('%d ResourcenID ist nicht g�ltig!', [SplashBitmap]);


  SplashForm := TSplashDlg.Create(ParentWindow);

  SplashForm.OnExtraPaint := OnExtraPaint;

  with SplashForm do
  begin
    try
      SplashImage.Picture.Bitmap.LoadFromResourceID(aInstance, SplashBitmap);
    except
      raise Exception.CreateFmt('%d ResourcenID ist nicht g�ltig!', [SplashBitmap]);
    end;
    //LoadFromFile(SplashBitmap);
    Width := SplashImage.Picture.Width + 1;
    Height := SplashImage.Picture.Height + 1;
    if DelayTime > 0 then
    begin
      Int := DelayTime - 100;
      Timer.Enabled := TRUE;
    end
    else
      Timer.Enabled := FALSE;

  end;
  Result := SplashForm;
end;

function ResNameModalSplashScreen(aInstance: THandle; SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): Boolean;
var f: TForm;
begin
  F := ResNameSplashScreen(aInstance, SplashBitmap, ParentWindow, DelayTime, OnExtraPaint);
  Result := Assigned(f);
  if not Result then exit;
  f.ShowModal;
  f.Free;
end;


function ResNameSplashScreen(aInstance: THandle; SplashBitmap: string; ParentWindow: TForm; DelayTime: Integer;
  OnExtraPaint: TOnExtraPaint = nil): TForm;
var SplashForm: TSplashDlg;
begin


  if not IsResourceNameValid(aInstance, SplashBitmap, RTBITMAP) then
    raise Exception.CreateFmt('"%s" ResourcenName ist nicht g�ltig!', [SplashBitmap]);
  SplashForm := TSplashDlg.Create(ParentWindow);

  SplashForm.OnExtraPaint := OnExtraPaint;

  with SplashForm do
  begin
    try
      SplashImage.Picture.Bitmap.LoadFromResourceName(aInstance, SplashBitmap);
    except
      raise Exception.CreateFmt('"%s" ResourcenName ist nicht g�ltig!', [SplashBitmap]);
    end;

    Width := SplashImage.Picture.Width + 1;
    Height := SplashImage.Picture.Height + 1;
    if DelayTime > 0 then
    begin
      Int := DelayTime - 100;
      Timer.Enabled := TRUE;
    end
    else
      Timer.Enabled := FALSE;

  end;
  Result := SplashForm;
end;

function DefOnDialogControlStream(Control: TControl; Stream: TStream; StreamType: TStreamType): Longint;
begin
  Result := 0;
  if not Assigned(Control) then exit;
  if UpperCase(Control.ClassName) = 'TEDIT' then
  begin
    if StreamType = st_Write then
      WriteString2a(Stream, TEdit(Control).Text)
    else
    begin
      TEdit(Control).Text := ReadString2a(Stream);
    end;
    Result := SizeOfStringBuffer3a(TEdit(Control).Text);
  end;
end;

function DialogDataToStream(Stream: TStream; Form: TComponent; OnDialogControlWrite: TOnDialogControlWrite): Longint;
var ind, Count: Longint;
  function SaveToStream(Control: TComponent; Stream: TStream): Longint;
  var i: Integer;
  begin
    Result := 0;
    if not Assigned(Control) then exit;
    for i := 0 to Control.ComponentCount - 1 do
    begin
      Inc(Result, SaveToStream(Control.Components[i], Stream));
    end;
    Inc(Result, OnDialogControlWrite(TControl(Control), Stream, st_Write));
  end;

begin
  Count := CountDialogComponents(Form);
  Result := Stream.Write(Count, SizeOf(Count));
  ind := Form.ComponentIndex;
  Inc(Result, Stream.Write(ind, SizeOf(ind)));
  Inc(Result, SaveToStream(Form, Stream));
end;

function DialogDataFromStream(Stream: TStream; Form: TComponent; OnDialogControlRead: TOnDialogControlRead): Longint;
var Count, c, ind: Longint;
  function ReadFromStream(Control: TComponent; Stream: TStream): Longint;
  var i: Integer;
  begin
    Result := 0;
    if not Assigned(Control) then exit;
    for i := 0 to Control.ComponentCount - 1 do
    begin
      Inc(Result, ReadFromStream(Control.Components[i], Stream));
    end;
    Inc(Result, OnDialogControlRead(TWinControl(Control), Stream, st_Read));
  end;

begin
  c := CountDialogComponents(Form);
  Result := Stream.Read(Count, SizeOf(Count));
  Inc(Result, Stream.Read(ind, SizeOf(ind)));

  if ind <> Form.ComponentIndex then
    raise Exception.Create('Error in read stream : Streamed component and maincomponent are unequal!');

  if c <> Count then
    raise Exception.Create(
      'Error in read stream : count of streamed controls and controls in form are unequal.'
      );
  Inc(Result, ReadFromStream(TWinControl(Form), Stream));
end;

function CountDialogComponents(Form: TComponent): Longint;

  function CountIt(Control: TComponent): Longint;
  var i: Integer;
  begin
    Result := 0;
    if not Assigned(Control) then exit;
    for i := 0 to Control.ComponentCount - 1 do
    begin
      Inc(Result, CountIt(Control.Components[i]));
    end;
    Inc(Result);
  end;
begin
  Result := CountIt(TComponent(Form));
end;


procedure MsgError(const Msg: string; const Args: array of const);
begin
  MessageDlgExt(Msg,Args,mtError,[mbok],0)
end;

procedure MsgError(const Msg: string; HelpCtx : Integer = 0);
begin
  MessageDlg(Msg,mtError,[mbok],HelpCtx);
end;

end.

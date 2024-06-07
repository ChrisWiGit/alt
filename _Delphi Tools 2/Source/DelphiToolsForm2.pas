{
@abstract(DelphiToolsForm2.pas beiinhaltet Funktionen mit dem Umgang mit dem Passworteinstellungsdialog)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}



unit DelphiToolsForm2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Menus;

type
  {TDefPassDlg stellt den Dialog zur Verf�gung, die eine �nderung des Passwortes mit
  Best�tigung zul�sst.
  Siehe @link(dtDialogs) - @link(DefPassWordDlg)
  }
  TDefPassDlg = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Edit3: TEdit;
    Bevel1: TBevel;
    PopupMenu1: TPopupMenu;
    DelBtn: TBitBtn;
    StaticText1: TLabel;
    StaticText2: TLabel;
    StaticText3: TLabel;
    procedure Edit3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    fPassWord ,fmp:String;
    fMinLen,fMaxLen : Integer;
    fPAssWordChar : Char;
    fCaseSensitive,
    fAllowDelPassWord : Boolean;
    foldHintHidePause,
    fHintHidePause : Integer;
    fEnablePassword,
    fUsedMaster : boolean;



    procedure SetMaxLength(m : Integer);
    procedure SetPAssWordChar(c:Char);
    procedure SetPassWord(s:String);
    procedure SetMinLength(l:Integer);
    procedure SetHintHidePause(p:Integer);
    procedure SetAllowDelPassWord(b:Boolean);
  public
    { Public-Deklarationen }
    {Ermittelt das aktuell eingegebene Passwort}
    function GetPass(s:String) : String;
    {ChangeHintStrings setzt die Hinweis-Text-Array @link(HintArray) in die Kontrollelemente}
    procedure ChangeHintStrings;

    {SetOkCaption setzt die Texte des OK- und Abbruch-Schalters}
    procedure SetOkCaption(Ok,Del : String);

    {PassWord gibt und setzt das aktuelle Passwort}
    property PassWord : String read fPAssword write SetPassWord;
    {MinLength gibt die minimale L�nge des Passwortes an.}
    property MinLength : Integer read fMinLen write SetMinLength;
    {MaxLength gibt die maximale L�nge des Passwortes an.}
    property MaxLength : Integer read fMaxLen write SetMaxLength;
    {PassWordChar gibt an, welche Zeichen statt dem eingegebenen Zeichen dargestellt wird.}
    property PassWordChar: Char read fPAssWordChar write SetPAssWordChar;
    {CaseSensitive gibt an, ob bei dem Passwort zw. Gro�- und Kleinschreibung unterschieden wird.}
    property CaseSensitive : Boolean read fCaseSensitive write fCaseSensitive;
    {OldHintHidePause wird intern verwendet und sollte nicht ge�ndert werden.}
    property OldHintHidePause : Integer read fOldHintHidePause;
    {HintHidePause gibt an, wie lange ein Hinweistext angezeigt wird (in Milisek.)}
    property HintHidePause : Integer read fHintHidePause write SetHintHidePause;
    {MasterPassWord setzt das MasterPasswort}
    property MasterPassWord : String read fmp write fmp;
    {AllowDelPassWord gibt an, ob das Passwort gel�scht werden darf (leeres Passwort)}
    property AllowDelPassWord : Boolean read fAllowDelPassWord write SetAllowDelPassWord;

    {IsPassWordEnabled gibt beim Beenden zur�ck, ob das Passwort aktiviert ist.}
    property IsPassWordEnabled : Boolean read fEnablePassword;
    {IsUsedMasterPassWord gibt beim Beenden zur�ck, ob das MasterPasswort verwendet wurde.}
    property IsUsedMasterPassWord:Boolean read fUsedMaster;
  end;

var
  {DefPassDlg wird benutzt, um eine globale Klassenreferenz auf den Passwortdialog zu erzeugen.
  Diese Variable wird normalerweise nicht benutzt.}
  DefPassDlg: TDefPassDlg;

  {HintArray gibt alle Hinweis-Texte der Kontrollelemente an}
  HintArray : Array[1..6] of String =
  ('Geben Sie in dieses Editierfeld das richtige'#13+
   'Kennwort ein , da� ben�tigt wird um ein neues'#13+
   'zu definieren  zu k�nnen.',

   'Geben Sie hier das neue Kennwort ein und'#13+
   'best�tigen Sie es nocheinmal im unteren'#13+
   'Editierfeld.',

   'Best�tigen Sie in diesem Editierfeld das neue'#13+
   'Kennwort , indem Sie es einfach wiederholt'#13+
   'angeben.',

   'Hiermit wird die �nderung des Kennwortes'#13+
   'endg�ltig best�tigt.',

   'Damit wird dir Kennworteingabe'#13+
   'abgebrochen.',

   'Mit L�schen wird das Kennwort deaktiviert.'
   );

  MinLenHint : String = 'Die Minimalzeichenl�nge betr�gt %d.';
  NoPassWordHint : String = 'Soll das Password gel�scht werden , muss '#13+
                            'das Eingabefeld leer bleiben.';
  ErrorMsg : Array[1..4] of String=
   ('Das Kennwort mu� mind. %d Zeichen lang sein.',
    'Die Best�tigung stimmt nicht mit dem neuen Kennwort �berein.',
    'Achten Sie auf Gro�- und Kleinschreibung!',
    'Das neue Kennwort und die Best�tigung besitzen ungleich viele Zeichen.'
    );
  InfoMsg : Array[1..2] of String=
  ( 'Das Masterkennwort wurde benutzt und best�tigt.',
    'Das Kennwort wurde gel�scht.');

  OkCaption : Array[1..2] of String =
    ('O&K','&L�schen');


implementation
uses dtSystem,dtWindows,dtDialogs,dtStringsRes;
{$R *.DFM}

procedure TDefPassDlg.ChangeHintStrings;
begin
  StaticText3.Hint := HintArray[1];
  SetMinLength(MinLength);
  OkBtn.Hint := HintArray[4];
  CancelBtn.Hint := HintArray[5];
  DelBtn.Caption := HintArray[6];
end;

procedure TDefPassDlg.Edit3Change(Sender: TObject);
begin
  Edit1.Enabled := (
                    ((Edit3.Text <> '') and
                   (CompareStr(GetPass(Edit3.Text),GetPass(PassWord))=0))
                   or (PassWord = '')) or ((MasterPassWord <> '')and(GetPass(MasterPassWord) = GetPass(Edit3.Text)));
  StaticText1.Enabled := Edit1.Enabled;
end;

procedure TDefPassDlg.SetPassWordChar(c:Char);
begin
  Edit1.PasswordChar := c;
  Edit2.PasswordChar := c;
  Edit3.PasswordChar := c;
end;
procedure TDefPassDlg.SetOkCaption(Ok,Del : String);
begin
  if Ok <> '' then
   OkCaption[1] := Ok;
  if Del <> '' then
   OkCaption[2] := Del;

  OkBtn.Caption := OkCaption[1];
  DelBtn.Caption := OkCaption[2];
end;
procedure TDefPassDlg.SetPassWord(s:String);
begin
  fPassWord := s;
  Edit3.Enabled := s <> '';
  StaticText3.Enabled := Edit3.Enabled;
  Edit3Change(Self);
  if MinLength = -2 then
   MinLength := Length(s);
  if MaxLength = -2 then
   MaxLength := Length(s);
end;
function TDefPassDlg.GetPass(s:String) : String;
var d : String;
begin
  if CaseSensitive then
   d := s
  else
   d := UpperCase(s);
  REsult := d;
end;
procedure TDefPassDlg.SetAllowDelPassWord(b:Boolean);
begin
  fAllowDelPassWord := b;
  SetMinLength(MinLength);
  if not AllowDelPassWord then
    DelBtn.Visible := FALSE
  else
   DelBtn.Visible := TRUE;
end;
procedure TDefPassDlg.SetMaxLength(m : Integer);
begin
  fMaxLen := m;
  Edit1.MaxLength := fMaxLen;
  Edit2.MaxLength := fMaxLen;
  Edit3.MaxLength := fMaxLen;
end;
procedure TDefPassDlg.SetMinLength(l:Integer);
begin
  fMinLen := l;
  StaticText1.Hint := HintArray[2]+#13+Format(MinLenHint,[MinLength]);
  if self.AllowDelPassWord then
   StaticText1.Hint := StaticText1.Hint + #13+ NoPassWordHint;
  StaticText2.Hint := HintArray[3]+#13+Format(MinLenHint,[MinLength]);
end;
procedure TDefPassDlg.SetHintHidePause(p:Integer);
begin
  fHintHidePause := p;
  Application.HintHidePause := p;
end;
procedure TDefPassDlg.FormCreate(Sender: TObject);
var i : Integer;
begin
  if Edit3.TExt = '' then
  begin
    Edit3.Enabled := FALSE;
    Edit1.Enabled := TRUE;
  end;
  SetMaxLength(0);
  SetPAssWordChar('*');

  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';

  PassWord := '';
  CaseSensitive := TRUE;
  PassWordChar := #0;
  MinLength := -1;
  MaxLength := 0;

  MasterPassWord := '';

  fOldHintHidePause := Application.HintHidePause;
  SetHintHidePause(-1);
  ChangeHintStrings;
  AllowDelPassWord := FALSE;

  fEnablePassword := TRUE;
  fUsedMaster := FALSE;
  OkBtn.Caption := OkCaption[1];
  DelBtn.Caption := OkCaption[2];
  Edit1Change(Sender);
end;

procedure TDefPassDlg.Edit1Change(Sender: TObject);
var bit : Tbitmap;
begin
  Edit2.Enabled := (Edit1.Text <> '') and
                   ((Length(Edit1.Text) >= MinLength) or (MinLength = -1));
  StaticTExt2.Enabled := Edit2.Enabled;
  Edit2Change(Sender);
  if (Edit1.Text = '') and (AllowDelPassWord) then
  begin
   //OkBtn.Caption := OkCaption[2];
   //OkBtn.Hint := HintArray[6];
   //OkBtn.Enabled  := FALSE;
   DelBtn.Enabled := TRUE;
  end
  else
  begin
{   OkBtn.Kind := bkOK;
   OkBtn.Caption := OkCaption[1];
   OkBtn.Hint := HintArray[4];}
   //OkBtn.Enabled  := TRUE;
   DelBtn.Enabled := FALSE;
  end;
//  OkBtn.Update;
end;

procedure TDefPassDlg.Edit3Exit(Sender: TObject);
begin
  Edit3.Enabled := not Edit1.Enabled;
  StaticText3.Enabled := Edit3.Enabled;
  if ((MasterPassWord <> '') and
     (GetPass(MasterPassWord) = GetPass(Edit3.Text))) then
     MessageDlg(InfoMsg[1],mtInformation,[mbok],0);
end;

procedure TDefPassDlg.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
//  Close;
end;

procedure TDefPassDlg.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrOK;
//  Close;
end;

procedure TDefPassDlg.FormActivate(Sender: TObject);
begin
  if PassWord <> '' then
   Edit3.SetFocus
  else
   Edit1.SetFocus;
  SetWinOnTop(Handle,FALSE);
end;

procedure TDefPassDlg.Edit2Change(Sender: TObject);
begin
  OkBtn.Enabled := ((Edit1.Text <> '') and
                   (Edit2.Text <> '') and

                   (CompareStr(GetPass(Edit1.Text),GetPass(Edit2.Text))=0) and
                   ((Length(Edit1.Text) >= MinLength) or (MinLength = -1)) and
                   ((Length(Edit2.Text) >= MinLength) or (MinLength = -1)));
                   
  DelBtn.Enabled := ((AllowDelPassWord) and (Edit1.Text = ''));
  if (DelBtn.Enabled) and (DelBtn.Visible) and (not OkBtn.Enabled) then
   begin
     DelBtn.Default := TRUE;
     OkBtn.Default :=  FALSE;
   end
  else
   begin
     DelBtn.Default := FALSE;
     OkBtn.Default :=  TRUE;
   end;
end;

procedure TDefPassDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetHintHidePause(fOldHintHidePause);
  fUsedMaster := (GetPass(MasterPassWord) = GetPass(Edit3.Text));
  if (ModalResult = mrOK) then
   PassWord := Edit1.Text;
  if (ModalResult = mrCancel) or (Edit1.Text <> '') then
   fEnablePassword := TRUE
  else
   fEnablePassword := FALSE;
  if (not fEnablePassword) and (ModalResult = mrOK) then
  begin
   MessageDlg(InfoMsg[2],mtInformation,[mbok],0);
  end;
end;

procedure TDefPassDlg.Edit1Enter(Sender: TObject);
begin
  Edit1Change(Sender);
  Edit2Change(Sender);
  if (Length(Edit1.Text) < MinLength) and (Edit1.Text <> '') then
  begin
   MessageDlgExt(ErrorMsg[1],[MinLength],mterror,[mbok],0);
   Edit1.SetFocus;
  end;
end;

procedure TDefPassDlg.Edit1Exit(Sender: TObject);
begin
 exit;
end;

procedure TDefPassDlg.Edit2Exit(Sender: TObject);
var s :String;
begin
 if  (Edit2.Text <> '') and
     (
      (Length(Edit1.Text) < MinLength) or
      (GetPass(Edit2.Text) <> GetPAss(Edit1.Text)) or
      (Length(Edit1.Text) <> Length(Edit2.Text)))  then
  begin
   s := '';
   if (Length(Edit1.Text) < MinLength) then
    Insert(ErrorMsg[1]+#13,s,Length(s)+1);
   if (GetPass(Edit2.Text) <> GetPAss(Edit1.Text)) then
   begin
    Insert(ErrorMsg[2]+#13,s,Length(s)+1);
   if CaseSensitive then
    Insert(ErrorMsg[3]+#13,s,Length(s)+1);
   end;
   if (Length(Edit1.Text) <> Length(Edit2.Text)) then
    Insert(ErrorMsg[4]+#13,s,Length(s)+1);
   if s[Length(s)] = #13 then
    Delete(s,Length(s),1);
   MessageDlgExt(s,[MinLength],mterror,[mbok],0);
   Edit2.Text := '';
  end;
end;

procedure TDefPassDlg.DelBtnClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.


{
@abstract(DelphiToolsForm1.pas beinhaltet die Klasse TPassWordDlg f�r den Umgang mit dem Passwortdialog.)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}
unit DelphiToolsForm1;

interface
{DEFINE DIRECTX}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;


type
  {TPassWordDlg stellt einen Dialog zur Verf�gung, der die eingabe eines
Passworts zul�sst. Diese Klasse ist nur zur Abw�rtskompatiblit�t noch vorhanden.}
  TPassWordDlg = class(TForm)
    StaticText1: TStaticText;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    {TimeElaps gibt an, ob eine bestimmte Zeitobergrenze existiert, die den Dialog automatisch abbricht.}
    TimeElaps : Boolean;
  end;

var
  {PassWordDlg wird benutzt, um eine globale Klassenreferenz auf den Passwortdialog zu erzeugen.
  Diese Variable wird normalerweise nicht benutzt.}
  PassWordDlg: TPassWordDlg;

implementation

{$R *.DFM}

procedure TPassWordDlg.Timer1Timer(Sender: TObject);
begin
  ModalResult := mrNone;
  TimeElaps := TRUE;
  Close;
end;

procedure TPassWordDlg.Timer2Timer(Sender: TObject);
begin
   ModalResult := mrCancel;
  Close;
end;

end.


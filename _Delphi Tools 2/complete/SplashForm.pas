{
@abstract(SplashForm.pas beinhaltet die Klasse TSplashDlg f�r den Umgang mit dem SplashDialog.)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit SplashForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  {TOnExtraPaint ist das Ereignis, dass aufgerufen wird, wenn etwas auf den Dialog gezeichnet werden soll.}
  TOnExtraPaint = Procedure (Sender : TObject; Canvas : TCanvas) of object;

  {TSplashDlg wird benutzt, um eine Informationsanzeige darzustellen, w�hrend das Hauptprogramm
  damit besch�ftigt ist Daten zu laden.}
  TSplashDlg = class(TForm)
    SplashImage: TImage;
    Timer: TTimer;
    StringLabel: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private-Deklarationen }
    GoUp : Integer;
    mOnExtraPaint : TOnExtraPaint;
    mAllowUserClose : Boolean;
  public
    {Int wird f�r f�r interne Zwecke in SplashScreen verwendet}
    Int : Integer;
    {OnExtraPaint wird dann aufgerufen, wenn etwas auf den Splash geschrieben werden soll.}
    property OnExtraPaint : TOnExtraPaint read mOnExtraPaint write mOnExtraPaint;

    {AllowClose gibt an, ob der Dialog mit Alt+F4 geschlossen werden kann.}
    property AllowClose : boolean read mAllowUserClose write mAllowUserClose;
    { Public-Deklarationen }
  end;

var
  {SplashDlg wird benutzt, um eine globale Klassenreferenz auf den Splashdialog zu erzeugen.
  Diese Variable wird normalerweise nicht benutzt.}
  SplashDlg: TSplashDlg;

implementation
uses dtSystem,dtStringsRes;
{$R *.DFM}

procedure TSplashDlg.TimerTimer(Sender: TObject);
begin
  Inc(goUp,1);
  if GoUp >= Int  then
   Close;
end;

procedure TSplashDlg.FormActivate(Sender: TObject);
begin
//
  if Assigned(mOnExtraPaint) then
   mOnExtraPaint(Self,SplashImage.Picture.Bitmap.Canvas);
end;

procedure TSplashDlg.FormShow(Sender: TObject);
begin
  //
  GoUp := 0;
end;

procedure TSplashDlg.FormPaint(Sender: TObject);
begin
//
end;

procedure TSplashDlg.FormCreate(Sender: TObject);
begin
  AllowClose := FALSE;
end;

procedure TSplashDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (AllowClose) or (GoUp >= Int);
end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit,sParser,PasStream,PascalScanner,ioclasses;

type
  TForm1 = class(TForm)
    FilenameEdit1: TFilenameEdit;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var PS : TPascalStream;
    Scanner : TPascalScanner;
    starttime,endtime,durance : Extended;
    aunit : TUnit;
begin
  Memo1.Lines.Clear;
  PS := TPascalStream.Create(FilenameEdit1.Filename,fmOpenread);
  SCanner := TPascalScanner.Create(PS);
  try
    starttime := GetTickCount;
    aunit := Scanner.DoScan;
    endtime := GetTickCount;
  except
    on e:Exception do
      Memo1.Lines.Text := e.Message;
  end;

  durance := (endtime-starttime) /  1000;
  Memo1.Lines.Add(Format('Time : %f    (%f Zeilen/s)',[durance,aUnit.LineCount / durance]));

  Scanner.Free;
  PS.Free;
end;

end.

   Time : 3,75    (5389,85 Zeilen/s)

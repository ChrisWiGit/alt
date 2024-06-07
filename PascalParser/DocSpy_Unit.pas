unit DocSpy_Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ActiveX, ComObj, ImgList, ExtCtrls;

var
  Form1: TForm1;
  aRoot: IStorage;
implementation

{$R *.DFM}


type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure OpenStorage(Filename : String);
    procedure DoEnumStorage(aStorage: IStorage; aNode: TTreeNode);
    function FilterCaption(Caption : String): String;
  public
    { Public-Deklarationen }
  end;


uses axctrls;

resourcestring
  sNoStorageFile = 'Diese Datei "%s" ist kein Compound Dokument';


// Procedure öffnet Dateidialog zur Auswahl
procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      Edit1.Text := OpenDialog1.FileName;
      OpenStorage(OpenDialog1.FileName);
    end;
end;

// Prozedur öffnet und prüft Storage-Datei
procedure TForm1.OpenStorage(Filename: String);
var swFileName : WideString;
begin

  swFileName := FileName;

  if (StgIsStorageFile(PWideChar(swFileName)) <> S_OK) then begin
    ShowMessage(Format(sNoStorageFile, [FileName]));
    Edit1.Text := '';
    Abort;
  end;
  TreeView1.Items.Clear;

  OleCheck(StgOpenStorage(PWideChar(swFileName),NIL, STGM_READWRITE or STGM_DIRECT or STGM_SHARE_EXCLUSIVE, NIL, 0, aRoot));

  TreeView1.Items.Add(NIL, FileName);
  TreeView1.Items[0].ImageIndex := 0;

  DoEnumStorage(aRoot, TreeView1.Items[0]);
end;

// Prozedur Iteriert durch das Storage
procedure TForm1.DoEnumStorage(aStorage: IStorage; aNode: TTreeNode);
var
  aRes         : HResult;
  aEnumSTATSTG : IEnumSTATSTG;
  aStatStg     : TStatStg;
  iFetched     : Integer;
  aSubNode     : TTreeNode;
  aStorRes     : HResult;
  aSubStor     : IStorage;
begin

  aRes := aStorage.EnumElements(0, nil, 0, aEnumSTATSTG);

  if SUCCEEDED(aRes) then
    repeat

      aRes := aEnumSTATSTG.Next(1, aStatStg, @iFetched);

      if (aRes <> S_OK) then continue;

      case aStatStg.dwType of
        STGTY_STORAGE :
           begin
             aSubNode := TreeView1.Items.AddChild(aNode, FilterCaption(aStatStg.pwcsName));
             aSubNode.ImageIndex := 1;
             // Open the sub-storage
             aStorRes := aStorage.OpenStorage(aStatStg.pwcsName, nil,
                                  STGM_READWRITE or STGM_DIRECT or
                                  STGM_SHARE_EXCLUSIVE, nil, 0, aSubStor);
             if (SUCCEEDED(aStorRes)) then
               begin
                 // Alle Elemente der Sub-Storage auflisten
                 DoEnumStorage(aSubStor, aSubNode);
               end;
           end;
        STGTY_STREAM :
          begin
            aSubNode := TreeView1.Items.AddChild(aNode, FilterCaption(aStatStg.pwcsName));
            aSubNode.ImageIndex := 2;
          end;
      end; {case}
    until (aRes <> S_OK);
end;

// Prozedur beendet Anwendung
procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

// Prozedur formetiert anzuzeigenden Namen
function TForm1.FilterCaption(Caption: String): String;
begin
  if Caption[1] < Char(32) then Caption[1] := ' ';
  Result := Caption;
end;

end.

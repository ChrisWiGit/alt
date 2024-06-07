unit Scanner;

interface

uses SysUtils, Classes;

type 
  TScanProgress = procedure(Sender: TObject; Data : Pointer) of object;

  {TScanner gibt die Basis an für weitere spezifierte Quellcodescanner.}
  TScanner = class(TPersistent)
  protected
    fStream: TStream;
    fScanProgress: TScanProgress;

    procedure CallOnScanProgress(Sender : TObject; Data : Pointer);

  public
       {Erstellt ein Scannerobjekt und erwartet als Parameter eine Quellcodedatei.
       Das Objekt kann ein TStream oder eines seiner Nachfahren sein, normalerweise ist es
       eine von TTextStream abgeleitete Klasse.}
    constructor Create(Stream: TStream); virtual;

    property OnScanProgress: TScanProgress read fScanProgress write fScanProgress;
  end;

implementation

constructor TScanner.Create(Stream: TStream);
begin
  inherited Create;
  fStream := Stream;
end;

procedure TScanner.CallOnScanProgress(Sender : TObject; Data : Pointer);
begin
  //if @fScanProgress <> nil then
  if Assigned(TMethod(fScanProgress).code)  then //32 bit comparison
    OnScanProgress(Sender,Data);
end;

end.

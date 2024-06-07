{
@abstract(dtDataBase.pas beinhaltet Funktionen f�r den Umgang mit Datenbanken)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtDataBase;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Registry, StdCtrls;

{IsBDEInstalled untersucht ob BDE installiert ist und gibt bei Erfolg TRUE zur�ck.
}
function IsBDEInstalled: Boolean;

implementation
uses dtSystem,dtStringsRes;

function IsBDEInstalled: Boolean;
var DLLPath, CFFile: string;
begin
  CFFile := ''; DLLPath := '';
  Result := False;
{$IFDEF Ver80}
  with TiniFile.Create('WIN.INI') do begin
    CFFile := ReadString('IDAPI', 'ConfigFile01', '');
    DLLPath := ReadString('IDAPI', 'DLLPATH', '');
{$ELSE}
  with TRegistry.Create do begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Borland\Database Engine', False);
    CFFile := ReadString('ConfigFile01');
    DLLPATH := ReadString('DLLPath');
{$ENDIF}
    Free;
  end;
  if (CFFile <> '') and (DLLPath <> '') then
    Result := FileExists(CFFile);
end;

end.

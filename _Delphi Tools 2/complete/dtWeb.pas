{
@abstract(dtWeb.pas beinhaltet Funktionen f�r den Umgang mit Webdarstellungen)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtWeb;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls ;



{GetHTMLColor2 errechnet aus einem Farb- einen hexdezimalen Wert
in der Form  #xxxxxx (wobei x f�r eine hexdezimale Zahl steht)}
function GetHTMLColor2(Value: TColor): string;

implementation
uses dtSystem,dtStringsRes;

function GetHTMLColor2(Value: TColor): string;
begin
  with TRGBQuad(ColorToRGB(Value)) do
    Result := '#' + IntToHex(RGB(rgbRed, rgbGreen, rgbBlue), 6);
end;

end.

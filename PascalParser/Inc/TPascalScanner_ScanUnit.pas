
function TPascalScanner.ScanUnit : TUnit;
var Comment,
    Declaration : String;
begin
  if fPStream.LeaveSpaces <> #0 then //Leerzeichen weg
   fPStream.GetPrevChar; //vorheriges Zeichen zur�ckholen, durch Positionszeiger verschieben

  Comment := fPStream.ReadNextComment;
  Declaration := fPStream.ReadWord;
  Expected(

  if Declaration = '' then;
end;
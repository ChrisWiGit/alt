function StringtoPascalWord(Str : ShortString) : TPascalWord;
var i : TPascalWord;
begin
  result := pw_none;
  for i := low(TPascalWord) to high(TPascalWord) do
   if CompareText(Str,SPascalWord[i]) = 0 then
   begin
     result := i;
     exit;
   end;
end;

function PascalWord2String(PascalWord : TPascalWord) : ShortString;
begin
  try
   result := SPascalWord[PascalWord];
  except
   result := '';
  end;
end;

function RemoveSpaces(Input : String) : String;
var i : Integer;
begin
  result := '';
  for i := 1 to Length(Input) do
  begin
    if Input[i] <> ' ' then
     result := result + Input[i];
  end;
end;
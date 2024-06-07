program PasStreamTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,PasStream;

const asdf = '345'+#13#13'wer';

var P : TPascalStream;
    s : String;
begin
  P := TPascalStream.Create('tester.txt',fmOpenRead);

 // while TRUE do
 try
  while not P.EOF do
  begin
    s := P.ReadWord(FALSE);
    if not (s[1] in [#10,#13]) and (s <> #0) then
    begin
      writeln('---');
      Writeln(s);

      //case  of
      if st_comment in P.TokenType then
      begin
        if st_singlelinecomment in P.TokenType then
        begin
          write('->beliebiger Kommentar in einer Zeile');
        end
        else
        if st_singlecomment in P.TokenType then
          write('->einzel-kommentar')
        else
         write('->kommentar');
      end;

      writeln('---');
      Readln;
    end
    else
     writeln('keine ausgabe');

  end;
 except
  on e: exception do
    writeln(e.message);

 end;
  P.Free;
  write('_');
  readln;


  { TODO -oUser -cConsole Main : Hier Code einfügen }
end.

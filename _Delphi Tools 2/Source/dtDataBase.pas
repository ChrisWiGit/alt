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
  ExtCtrls, Registry, StdCtrls
  {$IFDEF USEINTERBASE}
  ,IBSQL
  {$ENDIF}
  ;


{$IFDEF USEINTERBASE}
{ExecSQL f�hrt eine Reihe von SQL Anweisung aus "SQLLines" in einer TIBSQL-Klasse aus.
Der R�ckgabewert ist -1 im Erfolgsfall, sonst wird eine Exception (EIBInterBaseError) ausgel�st,
und die Zeile, in der der Fehler auftrat zur�ckgeliefert.
} 
function ExecSQL(DSQL: TIBSQL; SQLLines : TStringList; SeperatorChar : Char = ';') : Integer;
{$ENDIF}

{IsBDEInstalled untersucht ob BDE installiert ist und gibt bei Erfolg TRUE zur�ck.}
function IsBDEInstalled: Boolean;

implementation
uses dtSystem,dtStringsRes,dtStrings,IB;

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



{$IFDEF USEINTERBASE}
function ExecSQL(DSQL: TIBSQL; SQLLines : TStringList; SeperatorChar : Char = ';') : Integer;
var i,i2 : Integer;
    s : String;
    OnComment : Boolean;

function GetCode(s : String;var IsComment : Boolean) : String;
var p,p2 : Integer;
    s1,s2 : String;
begin
  result := s;

  p := pos('//',s);
  if p > 0 then
  begin
    result := Copy(s,1,p-1);
  end;

  p := pos('/*',result);
  if p > 0 then
  begin
    IsComment := TRUE;


    p2 := pos('*/',result);
    if p2 > 0 then
    begin
      IsComment := FALSE;
    end;

    result := Copy(result,1,p-1);

  end
  else
  begin
    p2 := pos('*/',result);
    if p2 > 0 then
    begin
      result := Copy(result,p2+2,Length(result));
      IsComment := FALSE;
    end;
  end;
end;
begin
  result := -1;
  DSQL.SQL.Clear;

  OnComment := FALSE;
  for i := 0 to SQLLines.Count -1 do
  begin
    if Length(SQLLines[i]) > 0 then
    begin
      s := GetCode(SQLLines[i],OnComment);
      if not OnComment then
        if Length(DelSpaces(s)) > 0 then
        DSQL.SQL.Add(s);
    end;

    if ((pos(SeperatorChar,SQLLines[i]) > 0) or (i+1 = SQLLines.Count)) and (DSQL.SQL.Count > 0) then
    begin
      try
       DSQL.Prepare;
       DSQL.ExecQuery;
       DSQL.SQL.Clear;
      except
        on E:EIBInterBaseError do
        begin
          result := i;
          s := E.Message+MultiReturn(2)+'code lines:'+#10#13;
          for i2 := 0 to DSQL.SQL.Count -1 do
           s := s + IntToStr(i2+1)+'  '+DSQL.SQL[i2]+#10#13;
          s := s+#10#13+'Continue?';
          if MessageDlg(s,mtError,[mbyes,mbno],0) = mrno then
          begin
            exit;
          end;
          DSQL.SQL.Clear;
        end;
      end;
    end;
  end;
end;
{$ENDIF}

end.

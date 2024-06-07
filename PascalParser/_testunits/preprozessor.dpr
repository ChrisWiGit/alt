 program preprozessor;

{$APPTYPE CONSOLE}

uses
  SysUtils,Classes,SParser;
{Der Sinn des Preprozessors besteht darin, alle Compilerdirektiven zu erkennen,
und wenn erforderlich zu entfernen.
in einem Stream ist es nicht möglich Zeichen zu entfernen!
man kann aber einen zweiten stream dazu verwenden, um dort das hintereinander zu reinzuschreiben, was
der alte stream beherbergt. Die CopyFrom funktion ist hier sehr hilfreich

SourceStream, DestStream

Lesen aus SourceStream -> auswerten, wenn z.b. das ausgewertete verwende werden soll
dann
  Source.Position := wo starten
  DestStream.CopyFrom(SourceStream, <anzahl der Bytes);
wenn etwas übersprungen werden soll :
 Source.Position := position an die stelle wo es weitergehen soll z.b. nach (*$ENDIF*) = überspringen
->und weitermachen

übrigens muss nur bis implementation gescannt werden!
}

(*lala*)
//raise Exception.Create('Fehlermeldung hier');

//UserDefinitions - die Definitionen {$DEFINE ...} vom Benutzer verwendet, die aber kommen aber net im quelltext vor
//das ist eine liste von definitionen

//aber wenn es nur im quelltext steht und UseSourceDefinitions = FALSE ist dann ne


//IFTyp: 0 = Normal; 1 = IFNDEF

function PreParseUnit(Source: TTextStream; Dest: TFileStream; UserDefs:TStrings; UseSourceDefs:Boolean) : Boolean;
Var R,s2:String;
    S:Char;
    DontWrite:Boolean;
    Memory:Array Of Record Typ,Name:String[20];
                            R:Real;
                            L:Longint;
                            S:String;
                     End;
    OpenC:Boolean;
    CTyp,E,I,IFTyp:Integer;
    ADef:String;//aktiver definename

begin
  CTyp:=0;
  OpenC:=False;
  Repeat

    S:=Source.GetNextChar(True);//jedes zeichen einlesen
//    S:=Source.LeaveSpaces(True);

    IF (S='}') Then OpenC:=False;//getrennt vom // comment

    IF (CTyp=2) And (S=#13) Then Begin OpenC:=False;CTyp:=0;End;//nur wenn vorher wirklich der // comment verwendet wird
    IF S='/' Then Begin OpenC:=True;CTyp:=2;End;

    If (S='{') or (S='(') Then
    Begin  //erkennung von: { oder (*
      R:=Source.GetNextChars(4,0,False);
      If (UpperCase(R)='$DEF') or (UpperCase(R)='*$DE') Then Begin //{$DEFINE...
        If OpenC=False Then Begin//nur wenn kein Kommentar
          Source.Position:=Source.Position+8;
//          Source.GetNextChars(4,0,True);
          R:='';
          E:=0;
          Repeat
            Inc(E);
            S2:=Source.GetNextChars(1,0,True);
            IF (S2<>'}') and (S2<>'*') and (S2<>' ') Then R:=R+S2 Else S2:=S2;
          Until (S2='}') or (S2='*');

          For I:=0 TO UserDefs.Count-1 Do Begin
            If CompareText(UserDefs[I],R) = 0 Then Begin
              //nur wenn auch vom user definiert, speichern und nicht in output schreiben
              SetLength(Memory, Length(Memory)+1);
//              writeln(R);
              Memory[Length(Memory)-1].Typ:='DEFINE';
              Memory[Length(Memory)-1].Name:=R;
              DontWrite:=True;
            End;
            If DontWrite=False Then Begin
{              E:=E+9;
              Source.Position:=Source.Position-E;
              R:=Source.GetNextChars(Length(R)+8,0,True);
              Dest.Write(Pchar(R)^,E+2);
              DontWrite:=True;
}           End;
          End;
        End;
      End Else//End $DEFINE
      If (UpperCase(Source.GetNextChars(7,0,False))='$IFNDEF') or
         (UpperCase(Source.GetNextChars(8,0,False))='*$IFNDEF') or
         (UpperCase(R)='$IFD') or
         (UpperCase(R)='*$IF') Then Begin //{$IFDEF, $IFNDEF...Achtung *$IF und *$IFDEF...sollte noch vebessert werden: siehe IFNDEF

        If OpenC=False Then Begin//nur wenn kein Kommentar
          If UpperCase(Source.GetNextChars(4,0,False))[4]='N' THen Begin //ist ein $IFNDEF
            IFTyp:=1;
            Source.Position:=Source.Position+1;//eine position weiter
          End ELse IFTyp:=0;

          If (Length(Memory)=0) And (IFTyp=1) Then Begin
            Setlength(Memory,1);
          end;

          Source.Position:=Source.Position+7;
          R:='';
          E:=0;
          Repeat//name filtern
            Inc(E);
            S2:=Source.GetNextChars(1,0,True);
            IF (S2<>'}') and (S2<>'*') and (S2<>' ') Then R:=R+S2 Else S2:=S2;
          Until (S2='}') or (S2='*');
          ADef:=R;

//        For I:=0 To Length(Memory)-1 Do Begin
{           IF (Memory[I].Typ='DEFINE') and (Memory[I].Name=R) Then}Begin
              //IFDEF gefunden
              R:='';
              DontWrite:=True;
              Repeat
                S:=Source.GetNextChar(True);
                R:=R+S;
//                Dest.Write(S,SizeOf(S));
                S2:=S;


                //ELSE and ENDIF check (kommentare werden noch nicht beachtet)
                Source.Position:=Source.Position+1;
                If S='(' Then Source.Position:=Source.Position+1;

                IF (UpperCase(Source.GetNextChars(5,0,False))='$ELSE') Then Begin
                  For I:=0 To Length(Memory)-1 Do Begin//erstmal guggen ob definiert
                    E:=0;
                    IF (Memory[I].Typ='DEFINE') and (Memory[I].Name=ADef) OR (I=Length(Memory)-1) and (Memory[I].Name<>ADef) and (IFTYP=1) Then Begin
                      IF (IFTyp=1) and (Memory[I].Name=ADef) Then Begin
                        E:=0;
                        Break;
                      End;
                      Dest.Write(PChar(R)^,Length(R));
                      Repeat//lesen bis zum ENDIF
                        Source.Position:=Source.Position+1;
                      Until (Source.GetNextChars(6,0,False)='$ENDIF');
                      Source.Position:=Source.Position+7;
                      IF Source.GetNextChar(False)=')' Then Source.Position:=Source.Position+1; //wenn *) verwendet wird
                      E:=-1;
                      Break;
                    End;
                  End;
                  IF E<>-1 Then Begin //nicht definiert
                    R:='';
                    Source.Position:=Source.Position+7;
                    IF Source.GetNextChar(False)=')' Then Source.Position:=Source.Position+1; //wenn *) verwendet wird
                  End Else Break;
                End;

                If (Source.GetNextChars(6,0,False)='$ENDIF') Then Begin
                  Dest.Write(PChar(R)^,Length(R));
                  E:=6;
                  Break;
                End;
                //ELSE and ENDIF check

                Source.Position:=Source.Position-1;
                IF S='(' Then                Source.Position:=Source.Position-1;

              Until False;

              IF E<>-1 Then Source.Position:=Source.Position+E+1;

            End;
//        End;


        End;
      End//End $IFDEF
      Else Begin//Comment?
        OpenC:=True;
      End;
    End; {Else}

    IF DontWrite=False Then Dest.Write(S,SizeOf(S)) Else DontWrite:=False;
    //const check DISABLED
    {IF UpperCase(S)='C' Then Begin              //Const? Level 1 Check
      R:='';
      S:=Source.GetNextChars(4,0,True);
      IF UpperCase(S)='ONST' Then Begin                  //Level 2 Check (Name)
        IF OpenC=True Then Break;                        //Falls comment dann raus
        SetLength(Memory,Length(Memory)+1);
        Memory[Length(Memory)-1].Typ:='';
        Repeat
          S:=Source.LeaveSpaces(True);
          IF (S<>' ') and (S<>'=') Then R:=R+S;

          IF S='=' Then Begin                            //Level 3 Check (Content)
            Memory[Length(Memory)-1].Name:=R;
            R:='';
            Repeat
              S:=Source.LeaveSpaces(True);
              IF (S<>' ') and (S<>';') Then R:=R+S;
              IF S=';' Then Begin                        //fertig!
                Val(R,I,E);
                IF E=0 Then Begin
                  Memory[Length(Memory)-1].Typ:='CONST_INTEGER';
                  Memory[Length(Memory)-1].L:=I;
                End Else Try
                  Memory[Length(Memory)-1].R:=StrToFloat(R);
                  Memory[Length(Memory)-1].Typ:='CONST_REAL';
                Except
                  Memory[Length(Memory)-1].Typ:='CONST_STRING';
                  Memory[Length(Memory)-1].S:=R;
                End;
                Writeln(Memory[Length(Memory)-1].Name+': "'+Memory[Length(Memory)-1].Typ+'" '+Memory[Length(Memory)-1].S);
                Break;
              End;
            Until False;
          End;
        Until Memory[Length(Memory)-1].Typ<>'';
      End;
    End;
    }//const check DISABLED

  Until Source.EOF;
end;

var InStream : TTextStream;
    OutStream : TFileStream;
    NewName,OpenName : String;
    P:String;
    UserDefs:TStrings;
begin
  UserDefs:=TStringList.Create;
  GetDir(0,P);
  { TODO -oUser -cConsole Main : Insert code here }

  {OpenName ist die Eingabe-Datei}
  OpenName := ParamStr(1);

 // OpenName := 'F:\Projekte D7\PascalParser\PreProzessor\compilerdirektiven.pas';
 // OpenName := p+'\compilerdirektiven.pas';

  OpenNAme := 'F:\Projekte D7\PascalParser\PreProzessor\newcrt.pas';
  {NewName ist die AusgabeDatei}
  NewName := ExtractFileDir(OpenName)+'\Output.pas';

  //InStream - Eingabestream zum Lesen, dieses Create gibt es nur bei TTextStream, nicht bei TMemoryStream
  InStream := TTextStream.Create(OpenName,fmOpenRead);

  //OutStream - Ausgabestream zum schreiben
  OutStream := TFileStream.Create(NewName,fmCreate or fmOpenWrite);

  UserDefs.Add('DEBUG');
 // UserDefs.Add('CLX');

  PreParseUnit(InStream,OutStream, UserDefs, false);

  //Von InStream alles nach OutStream kopieren zum schreiben
//  OutStream.CopyFrom(InStream,0);
   
  OutStream.Free;
  InStream.Free;
  Write('Ready');
 // Readln;
end.

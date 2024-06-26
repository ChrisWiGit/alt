{Written by Attila Szomor, his e-mail: aszomor@dravanet.hu}
Unit NewCRT;
Interface
Uses {$IfDef Win32}CRT32{$Else}CRT{$EndIf};
Const
  { CRT modes }
  BW40={$IfDef Win32}CRT32.BW40{$Else}CRT.BW40{$EndIf};
  CO40={$IfDef Win32}CRT32.CO40{$Else}CRT.CO40{$EndIf};
  BW80={$IfDef Win32}CRT32.BW80{$Else}CRT.BW80{$EndIf};
  CO80={$IfDef Win32}CRT32.CO80{$Else}CRT.CO80{$EndIf};
  Mono={$IfDef Win32}CRT32.Mono{$Else}CRT.Mono{$EndIf};
  Font8x8={$IfDef Win32}CRT32.Font8x8{$Else}CRT.Font8x8{$EndIf};
  { Mode constants for 3.0 compatibility }
  C40={$IfDef Win32}CRT32.C40{$Else}CRT.C40{$EndIf};
  C80={$IfDef Win32}CRT32.C80{$Else}CRT.C80{$EndIf};
  { Foreground and background color constants }
  Black={$IfDef Win32}CRT32.Black{$Else}CRT.Black{$EndIf};
  Blue={$IfDef Win32}CRT32.Blue{$Else}CRT.Blue{$EndIf};
  Green={$IfDef Win32}CRT32.Green{$Else}CRT.Green{$EndIf};
  Cyan={$IfDef Win32}CRT32.Cyan{$Else}CRT.Cyan{$EndIf};
  Red={$IfDef Win32}CRT32.Red{$Else}CRT.Red{$EndIf};
  Magenta={$IfDef Win32}CRT32.Magenta{$Else}CRT.Magenta{$EndIf};
  Brown={$IfDef Win32}CRT32.Brown{$Else}CRT.Brown{$EndIf};
  LightGray={$IfDef Win32}CRT32.LightGray{$Else}CRT.LightGray{$EndIf};
  { Foreground color constants }
  DarkGray={$IfDef Win32}CRT32.DarkGray{$Else}CRT.DarkGray{$EndIf};
  LightBlue={$IfDef Win32}CRT32.LightBlue{$Else}CRT.LightBlue{$EndIf};
  LightGreen={$IfDef Win32}CRT32.LightGreen{$Else}CRT.LightGreen{$EndIf};
  LightCyan={$IfDef Win32}CRT32.LightCyan{$Else}CRT.LightCyan{$EndIf};
  LightRed={$IfDef Win32}CRT32.LightRed{$Else}CRT.LightRed{$EndIf};
  LightMagenta={$IfDef Win32}CRT32.LightMagenta{$Else}CRT.LightMagenta{$EndIf};
  Yellow={$IfDef Win32}CRT32.Yellow{$Else}CRT.Yellow{$EndIf};
  White={$IfDef Win32}CRT32.White{$Else}CRT.White{$EndIf};
  { Add-in for blinking }
  Blink={$IfDef Win32}CRT32.Blink{$Else}CRT.Blink{$EndIf};
  {  }
  {  New constans there are not in original CRT unit }
  {  }
  MouseLeftButton={$IfDef Win32}CRT32.MouseLeftButton{$Else}1{$EndIf};
  MouseRightButton={$IfDef Win32}CRT32.MouseRightButton{$Else}2{$EndIf};
  MouseCenterButton={$IfDef Win32}CRT32.MouseCenterButton{$Else}4{$EndIf};
  MouseButtons= MouseLeftButton OR MouseRightButton OR MouseCenterButton;

Var
  { Interface variables }
  CheckBreak: boolean {$IfDef Win32}ABSOLUTE CRT32.CheckBreak{$Else}ABSOLUTE CRT.CheckBreak{$EndIf};
  CheckEOF: boolean {$IfDef Win32}ABSOLUTE CRT32.CheckEOF{$Else}ABSOLUTE CRT.CheckEOF{$EndIf};
  DirectVideo: boolean {$IfDef Win32}ABSOLUTE CRT32.DirectVideo{$Else}ABSOLUTE CRT.DirectVideo{$EndIf};
  CheckSnow: boolean {$IfDef Win32}ABSOLUTE CRT32.CheckSnow{$Else}ABSOLUTE CRT.CheckSnow{$EndIf};
  LastMode: word {$IfDef Win32}ABSOLUTE CRT32.LastMode{$Else}ABSOLUTE CRT.LastMode{$EndIf};
  TextAttr: byte {$IfDef Win32}ABSOLUTE CRT32.TextAttr{$Else}ABSOLUTE CRT.TextAttr{$EndIf};
  WindMin: word {$IfDef Win32}ABSOLUTE CRT32.WindMin{$Else}ABSOLUTE CRT.WindMin{$EndIf};
  WindMax: word {$IfDef Win32}ABSOLUTE CRT32.WindMax{$Else}ABSOLUTE CRT.WindMax{$EndIf};
{  }
{  New types & variables there are not in original CRT unit }
{  }
Type
  TScrBorders= (NoLine,ThinLine,DoubleLine,DoubleTop,DoubleSide,FatLine1,FatLine2,FatLine3);
Var
  NoCursor,UlCursor,InsCursor: word;
  MouseInstalled: boolean{$IfDef Win32}ABSOLUTE CRT32.MouseInstalled{$EndIf};
  MousePressedButtons: word{$IfDef Win32}ABSOLUTE CRT32.MousePressedButtons{$EndIf};

{ Interface functions & procedures }
Procedure AssignCrt(Var F: Text);
Function  KeyPressed: boolean;
Function  ReadKey: char;
Procedure TextMode(Mode: integer);
Procedure Window(X1,Y1,X2,Y2: byte);
Procedure GotoXY(X,Y: byte);
Function  WhereX: byte;
Function  WhereY: byte;
Procedure ClrScr;
Procedure ClrEol;
Procedure InsLine;
Procedure DelLine;
Procedure TextColor(Color: byte);
Procedure TextBackground(Color: byte);
Procedure LowVideo;
Procedure HighVideo;
Procedure NormVideo;
Procedure Delay(MS: word);
Procedure Sound(Hz: word);
Procedure NoSound;
{ New functions & procedures there are not in original CRT unit }
Procedure FillerScreen(FillChar: Char);
Procedure FlushInputBuffer;
Function  GetCursor: word;
Procedure SetCursor(NewCursor: word);
Function  MouseKeyPressed : boolean;
Procedure MouseGotoXY(X,Y: integer);
Function  MouseWhereY: integer;
Function  MouseWhereX: integer;
Procedure MouseShowCursor;
Procedure MouseHideCursor;
{ New user defined functions & procedures there are not in original CRT unit }
Procedure DrawBorder(X,Y,Width,Height: integer; BorderStyle:TScrBorders);
Function  GetSetCursor(NewCursor: word): word;
Procedure Play(Octave,Note,Duration: integer);
Procedure Alarm;
Procedure Siren;
Procedure Train;
Procedure PhoneRing;
Procedure Click;
Procedure Birds;
Procedure WolfWhistle;

Implementation
Type
  NotesRecord= packed Record
    C,CF,D,DF,E,F,FF,G,GF,A,AF,B: integer;
  End;
{$IfNdef Win32}
  TScreenLeftTop= Record
    Left: byte;
    Top: byte;
  End;
  TScreenRightBottom= Record
    Right: byte;
    Bottom: byte;
  End;
{$EndIf}
Const
  Notes: NotesRecord = (C:1;CF:2;D:3;DF:4;E:5;F:6;FF:7;G:8;GF:9;A:10;AF:11;B:12);
  BordersCh: array [TScrBorders] Of
    {$IfDef Win32}ShortString{$Else}String[10]{$EndIf}=
  (
    '          ',
    '�Ŀ�������',
    '�ͻ���Ⱥ��',
    '�͸���Գ��',
    '�ķ���Ӻ��',
    '����������',
    '����������',
    '����������'
  );
{$IfNdef Win32}
  Var
    MouseRowWidth: word;
    MouseColWidth: word;
{$EndIf}

Procedure AssignCrt(Var F: Text);
Begin
{$IfDef Win32}CRT32.AssignCrt(F){$Else}CRT.AssignCrt(F){$EndIf};
End;

Function KeyPressed: boolean;
Begin
  KeyPressed:={$IfDef Win32}CRT32.KeyPressed{$Else}CRT.KeyPressed{$EndIf};
End;

Function ReadKey: char;
Begin
  ReadKey:={$IfDef Win32}CRT32.ReadKey{$Else}CRT.ReadKey{$EndIf};
End;

Procedure TextMode(Mode: Integer);
Begin
{$IfDef Win32}CRT32.TextMode(Mode){$Else}CRT.TextMode(Mode){$EndIf};
End;

Procedure Window(X1,Y1,X2,Y2: byte);
Begin
{$IfDef Win32}CRT32.Window(X1,Y1,X2,Y2){$Else}CRT.Window(X1,Y1,X2,Y2){$EndIf};
End;

Procedure GotoXY(X,Y: byte);
Begin
{$IfDef Win32}CRT32.GotoXY(X,Y){$Else}CRT.GotoXY(X,Y){$EndIf};
End;

Function WhereX: byte;
Begin
  WhereX:={$IfDef Win32}CRT32.WhereX{$Else}CRT.WhereX{$EndIf};
End;

Function WhereY: byte;
Begin
  WhereY:={$IfDef Win32}CRT32.WhereY{$Else}CRT.WhereY{$EndIf};
End;

Procedure ClrScr;
Begin
{$IfDef Win32}CRT32.ClrScr{$Else}CRT.ClrScr{$EndIf};
End;

Procedure ClrEol;
Begin
{$IfDef Win32}CRT32.ClrEol{$Else}CRT.ClrEol{$EndIf};
End;

Procedure InsLine;
Begin
{$IfDef Win32}CRT32.InsLine{$Else}CRT.InsLine{$EndIf};
End;

Procedure DelLine;
Begin
{$IfDef Win32}CRT32.DelLine{$Else}CRT.DelLine{$EndIf};
End;

Procedure TextColor(Color: byte);
Begin
{$IfDef Win32}CRT32.TextColor(Color){$Else}CRT.TextColor(Color){$EndIf};
End;

Procedure TextBackground(Color: byte);
Begin
{$IfDef Win32}CRT32.TextBackground(Color){$Else}CRT.TextBackground(Color){$EndIf};
End;

Procedure LowVideo;
Begin
{$IfDef Win32}CRT32.LowVideo{$Else}CRT.LowVideo{$EndIf};
End;

Procedure HighVideo;
Begin
{$IfDef Win32}CRT32.HighVideo{$Else}CRT.HighVideo{$EndIf};
End;

Procedure NormVideo;
Begin
{$IfDef Win32}CRT32.NormVideo{$Else}CRT.NormVideo{$EndIf};
End;

Procedure Delay(MS: word);
Begin
{$IfDef Win32}CRT32.Delay(MS){$Else}CRT.Delay(MS){$EndIf};
End;

Procedure Sound(Hz: word);
Begin
{$IfDef Win32}CRT32.Sound(Hz){$Else}CRT.Sound(Hz){$EndIf};
End;

Procedure NoSound;
Begin
{$IfDef Win32}CRT32.NoSound{$Else}CRT.NoSound{$EndIf};
End;

Procedure FillerScreen(FillChar: Char);
{$IfNdef Win32}
   Var
     X,Y: Byte;
     Size: word;
{$EndIf}
Begin
{$IfDef Win32}
  CRT32.FillerScreen(FillChar);
{$Else}
  Size:= TScreenRightBottom(WindMax).Right-TScreenLeftTop(WindMin).Left+1;
  X:=TScreenLeftTop(WindMin).Left;
  For Y:=TScreenLeftTop(WindMin).Top To TScreenRightBottom(WindMax).Bottom Do Begin
    ASM
      push ES;
      push DS;
      {$IfDef DPMI}
        xor  AX,AX;
        push AX;
        pop  ES;
        push AX;
        pop  DX;
      {$EndIf}
      push BP;
      push DI;
      push SI;
      mov  Ah,02;
      xor  BX,BX;
      mov  Dh,Y;
      mov  Dl,X;
      INT  $10;
      mov  Ah,09;
      mov  Al,FillChar;
      xor  BX,BX;
      mov  Bl,TextAttr;
      mov  CX,Size;
      INT  $10;
      pop  SI;
      pop  DI;
      pop  BP;
      pop  DS;
      pop  ES;
    END;
  End;
  GotoXY(1,1);
{$EndIf}
End;

Procedure WriteChrXY(X,Y: byte; Chr: char);
Begin
{$IfDef Win32}
  CRT32.WriteChrXY(X,Y,Chr);
{$Else}
  GotoXY(X,Y);Write(Chr);
{$EndIf};
End;

Procedure WriteStrXY(X,Y: byte; Str: PChar; dwSize: integer );
Begin
{$IfDef Win32}
  CRT32.WriteStrXY( X,Y,Str,dwSize );
{$Else}
  GotoXY(X,Y);Write(Str);
{$EndIf}
End;

Procedure FlushInputBuffer;
Begin
{$IfDef Win32}
  CRT32.FlushInputBuffer
{$Else}
  ASM
    push ES;
    push DS;
    {$IfDef DPMI}
      xor  AX,AX;
      push AX;
      pop  ES;
      push AX;
      pop  DX;
    {$EndIf}
    push BP;
    push DI;
    push SI;
    mov  AX,$0C06;
    mov  DX,$00FF;
    INT  $21;
    pop  SI;
    pop  DI;
    pop  BP;
    pop  DS;
    pop  ES;
  END;
{$EndIf};
End;

Function GetCursor: word;
{$IfNdef Win32}
Var
  wCursor: word;
{$EndIf}
begin
{$IfDef Win32}
  GetCursor:= CRT32.GetCursor;
{$Else}
  ASM
    push ES;
    push DS;
    {$IfDef DPMI}
      xor  AX,AX;
      push AX;
      pop  ES;
      push AX;
      pop  DX;
    {$EndIf}
    push BP;
    push DI;
    push SI;
    mov  AX,$0300;
    xor  BX,BX;
    INT  $10;
    pop  SI;
    pop  DI;
    pop  BP;
    pop  DS;
    pop  ES;
    mov  wCursor,CX;
  END;
  GetCursor:= wCursor;
{$EndIf}
End;

Procedure SetCursor(NewCursor: word);
Begin
{$IfDef Win32}
  CRT32.SetCursor(NewCursor);
{$Else}
  ASM
    push ES;
    push DS;
    {$IfDef DPMI}
      xor  AX,AX;
      push AX;
      pop  ES;
      push AX;
      pop  DX;
    {$EndIf}
    push BP;
    push DI;
    push SI;
    mov  AX,$0100;
    xor  BX,BX;
    mov  CX,NewCursor;
    INT  $10;
    pop  SI;
    pop  DI;
    pop  BP;
    pop  DS;
    pop  ES;
  END;
{$EndIf}
End;

Function MouseReset: boolean;
{$IfNdef WIN32}
Var
  Success: boolean;
{$EndIf}
Begin
  {$IfDef WIN32}
     MouseReset:=CRT32.MouseReset;
  {$Else}
    ASM
      push ES;
      push DS;
      {$IfDef DPMI}
        xor  AX,AX;
        push AX;
        pop  ES;
        push AX;
        pop  DX;
      {$EndIf}
      push BP;
      push DI;
      push SI;
      mov  AX,0;
      INT  $33;
      cmp  AX,$FFFF;
      jz   @1;
      mov  AX,FALSE;
      jmp  @4;
  @1:
      mov  AX,$000A; {Set Cursor Type}
      mov  BX,0
      mov  CX,$FFFF;
      mov  DX,$7700;
      INT  $33;
      mov  AX,$0001; {Show Cursor}
      INT  $33;
      mov  AX,$0004; {MouseGotoXY(Overflow,Overflow);}
      mov  CX,$7FFF;
      mov  DX,$7FFF;
      INT  $33;
      mov  DX,24*8;  {Because my mousedriver is stupid}
      mov  CX,79*8;  {Because my mousedriver is stupid}
      push DX;
      push CX;
      pop  AX;
      xor  CX,CX;
      mov  Cl,TScreenRightBottom(WindMax).Right;
      xor  DX,DX;
      div  CX;
      cmp  AX,0;
      jnz  @2;
      mov  AX,1;
  @2:
      mov  MouseColWidth,AX;
      pop  AX;
      xor  CX,CX;
      mov  Cl,TScreenRightBottom(WindMax).Bottom;
      xor  DX,DX;
      div  CX;
      cmp  AX,0;
      jnz  @3;
      mov  AX,1;
  @3:
      mov  MouseRowWidth,AX;
      mov  AX,TRUE;
  @4:
      pop  SI;
      pop  DI;
      pop  BP;
      pop  DS;
      pop  ES;
      mov  Success,Al;
    END;
    MouseReset:=Success;
  {$EndIf}
End;

Procedure MouseShowCursor;
Begin
  {$IfDef WIN32}
     CRT32.MouseShowCursor;
  {$Else}
    If MouseInstalled Then Begin
      ASM
        push ES;
        push DS;
        {$IfDef DPMI}
          xor  AX,AX;
          push AX;
          pop  ES;
          push AX;
          pop  DX;
        {$EndIf}
        push BP;
        push DI;
        push SI;
        mov  AX,$0001;
        INT  $33;
        pop  SI;
        pop  DI;
        pop  BP;
        pop  DS;
        pop  ES;
      END;
    End;
  {$EndIf}
End;

Procedure MouseHideCursor;
Begin
  {$IfDef WIN32}
     CRT32.MouseHideCursor;
  {$Else}
    If MouseInstalled Then Begin
      ASM
        push ES;
        push DS;
        {$IfDef DPMI}
          xor  AX,AX;
          push AX;
          pop  ES;
          push AX;
          pop  DX;
        {$EndIf}
        push BP;
        push DI;
        push SI;
        mov  AX,$0002;
        INT  $33;
        pop  SI;
        pop  DI;
        pop  BP;
        pop  DS;
        pop  ES;
      END;
    End;
  {$EndIf}
End;

Procedure MouseGotoXY(X,Y: integer);
Begin
  {$IfDef WIN32}
    CRT32.MouseGotoXY(X,Y);
  {$Else}
    If MouseInstalled Then Begin
      ASM
        push ES;
        push DS;
        {$IfDef DPMI}
          xor  AX,AX;
          push AX;
          pop  ES;
          push AX;
          pop  DX;
        {$EndIf}
        push BP;
        push DI;
        push SI;
        mov  AX,X;
        dec  AX;
        mul  MouseColWidth;
        mov  CX,AX;
        mov  AX,Y;
        dec  AX;
        mul  MouseRowWidth;
        mov  DX,AX;
        mov  AX,$0004;
        INT  $33;
        pop  SI;
        pop  DI;
        pop  BP;
        pop  DS;
        pop  ES;
      END;
    End;
  {$EndIf}
End;

Function MouseWhereY: integer;
{$IfNdef WIN32}
Var
  Position: word;
{$EndIf}
Begin
  {$IfDef WIN32}
    MouseWhereY:=CRT32.MouseWhereY;
  {$Else}
    MouseWhereY:=-1;
    If MouseInstalled Then Begin
      ASM
        push ES;
        push DS;
        {$IfDef DPMI}
          xor  AX,AX;
          push AX;
          pop  ES;
          push AX;
          pop  DX;
        {$EndIf}
        push BP;
        push DI;
        push SI;
        mov  AX,$0003;
        INT  $33;
        push DX;
        pop  AX;
        mov  CX,MouseRowWidth;
        xor  DX,DX
        div  CX;
        pop  SI;
        pop  DI;
        pop  BP;
        pop  DS;
        pop  ES;
        inc  AX;
        mov  Position,AX;
      END;
      MouseWhereY:=Position;
    End;
  {$EndIf}
End;

Function MouseWhereX : integer;
{$IfNdef WIN32}
Var
  Position: word;
{$EndIf}
Begin
  {$IfDef WIN32}
    MouseWhereX:=CRT32.MouseWhereX;
  {$Else}
    MouseWhereX:=-1;
    If MouseInstalled Then Begin
      ASM
        push ES;
        push DS;
        {$IfDef DPMI}
          xor  AX,AX;
          push AX;
          pop  ES;
          push AX;
          pop  DX;
        {$EndIf}
        push BP;
        push DI;
        push SI;
        mov  AX,$0003;
        INT  $33;
        push CX;
        pop  AX;
        mov  CX,MouseRowWidth;
        xor  DX,DX
        div  CX;
        pop  SI;
        pop  DI;
        pop  BP;
        pop  DS;
        pop  ES;
        inc  AX;
        mov  Position,AX;
      END;
      MouseWhereX:=Position;
    End;
  {$EndIf}
End;

Function MouseKeyPressed: boolean;
Begin
  MousePressedButtons:=0;
  {$IfDef WIN32}
    MouseKeyPressed:=CRT32.MouseKeyPressed;
  {$Else}
    If MouseInstalled Then Begin
      ASM
        push ES;
        push DS;
        {$IfDef DPMI}
          xor  AX,AX;
          push AX;
          pop  ES;
          push AX;
          pop  DX;
        {$EndIf}
        push BP;
        push DI;
        push SI;
        mov  AX,$0003;
        INT  $33;
        mov  MousePressedButtons,BX;
        pop  SI;
        pop  DI;
        pop  BP;
        pop  DS;
        pop  ES;
      END;
    End;
    MouseKeyPressed:=(MousePressedButtons AND MouseButtons) <> 0;
  {$EndIf}
End;

Procedure OverwriteChrXY(X,Y: byte; Chr: char);
Begin
{$IfDef Win32}
  CRT32.OverwriteChrXY(X,Y,Chr);
{$Else}
  GotoXY(X,Y);
  ASM
    push ES;
    push DS;
    {$IfDef DPMI}
      xor  AX,AX;
      push AX;
      pop  ES;
      push AX;
      pop  DX;
    {$EndIf}
    push BP;
    push DI;
    push SI;
    mov  Ah,$09;
    mov  Al,Chr;
    xor  BX,BX;
    mov  Bl,TextAttr;
    mov  CX,1;
    INT  $10;
    pop  SI;
    pop  DI;
    pop  BP;
    pop  DS;
    pop  ES;
  END;
{$EndIf};
End;

Procedure DrawBorder(X,Y,Width,Height: integer; BorderStyle:TScrBorders);
Const
  LeftTop= 1;
  Top= 2;
  RightTop= 3;
  RightCh= 4;
  RightBottom= 5;
  Bottom= 6;
  LeftBottom= 7;
  LeftCh= 8;
Var
  SS: {$IfDef Win32}ShortString{$Else}String{$EndIf};
  II: integer;
  PSS: PChar;
Begin
  Window(X,Y,X+Width-1,Y+Height-1);
  PSS:=@SS; Inc(PSS);
  SS:=BordersCh[BorderStyle][LeftTop];
  For II:=1 To (Width-2) Do SS:=SS+BordersCh[BorderStyle][Top];
  SS:=SS+BordersCh[BorderStyle][RightTop]+#0;
  WriteStrXY(X,Y,PSS,Length(SS)-1);
  {}
  For II:=1 To Height-2 Do Begin
    WriteChrXY(X,Y+II,BordersCh[BorderStyle][LeftCh]);
    WriteChrXY(X+Width-1,Y+II,BordersCh[BorderStyle][RightCh]);
  End;
  {}
  SS:=BordersCh[BorderStyle][LeftBottom];
  For II:=1 To (Width-2) Do SS:=SS+BordersCh[BorderStyle][Bottom];
  SS:=SS+#0;
  WriteStrXY(X,Y+Height-1,PSS,Length(SS)-1);
  OverwriteChrXY(X+Width-1,Y+Height-1,BordersCh[BorderStyle][RightBottom]);
  Window(X+1,Y+1,X+Width-2,Y+Height-2);
End;

Function GetSetCursor(NewCursor: word): word;
Begin
  GetSetCursor:= GetCursor;
  SetCursor(NewCursor);
End;

Procedure Play(Octave,Note,Duration: integer);
Var
  II: integer;
  Frequency: real;
Begin
  Frequency:= 32.625;
  For II:= 1 To Octave Do                { Compute C in Octave             }
    Frequency := Frequency * 2;
  For II:= 1 To Note - 1 Do              { Increase frequency Note-1 times }
    Frequency:= Frequency * 1.059463094;
  If Duration <> 0 Then Begin
    Sound(Round(Frequency));
    Delay(Duration);
    NoSound;
  End Else Sound(Round(Frequency));
End;

Procedure Alarm;
Var
  II: integer;
Begin
  For II:= 1 To 7 Do Begin
    With Notes Do Begin
      Play(4,G,70);
      Play(4,D,70);
    End;
  End;
End;

Procedure Siren;
Var
  Frequency: integer;
Begin
  For Frequency:= 500 To 2000 Do Begin
    Delay(1);
    Sound(Frequency);
  End;
  For Frequency:= 2000 DownTo 500 Do Begin
    Delay(1);
    Sound(Frequency);
  End;
  NoSound;
End;

Procedure Train;
Var
  Frequency: integer;
Begin
  For Frequency:= 500 DownTo 250 Do Begin
    Sound(Frequency);
    Delay(7);
    NoSound;
  End;
End;

Procedure PhoneRing;
Var
  II: integer;
Begin
  For II:= 1 To 25 Do Begin
    With Notes Do Begin
      Play(4,C,37);
      Delay(2);
      Play(4,E,18);
      Delay(4);
    End;
  End;
End;

Procedure Click;
Begin
  With Notes Do Begin
    Play(6,DF,6);
  End;
End;

Procedure Birds;
Begin
  With Notes Do Begin
    Play(6,a,40);
    Delay(50);
    Play(6,ff,60);
    Delay(50);
    Play(6,a,40);
  End;
End;

Procedure WolfWhistle;
Var
  Frequency: integer;
begin
  Frequency:= 400;
  While Frequency < 1350 Do begin
    Frequency:=Frequency+2;
    Delay(1);
    Sound(Frequency);
  End;
  NoSound;
  Delay(300);
  Frequency:=1550;
  While Frequency > 250 Do Begin
    Frequency:=Frequency-2;
    Delay(1);
    Sound(Frequency);
  End;
  NoSound;
End;

{$IfDef Win32}
initialization
{$Else}
BEGIN
{$EndIf}
  MouseInstalled:=MouseReset;
  {$IfDef Win32}
    NoCursor:= $0000;
    ULCursor:= $0014;
    InsCursor:= $0063;
  {$Else}
    NoCursor:= $2000;
    ULCursor:= $0607;
    InsCursor:= $0107;
  {$EndIf}
END.

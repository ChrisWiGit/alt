{$DEFINE VER120}
{Written by Attila Szomor, his e-mail: aszomor@dravanet.hu}
{Based on Frank Zimmer's CRT32.TXT, his e-mail: fzimmer@compuserve.com}
{..$Define HARD_CRT}
{..$Define CRT_EVENT}
{$Define OneByOne}
{$Define MOUSE_IS_USED}
Unit CRT32;
Interface
{$IfDef Win32}
  Const
    { CRT modes of original CRT unit }
    BW40          = 0;     { 40x25 B/W on Color Adapter }
    CO40          = 1;     { 40x25 Color on Color Adapter }
    BW80          = 2;     { 80x25 B/W on Color Adapter }
    CO80          = 3;     { 80x25 Color on Color Adapter }
    Mono          = 7;     { 80x25 on Monochrome Adapter }
    Font8x8       = 256;   { Add-in for ROM font }
    { Mode constants for 3.0 compatibility of original CRT unit }
    C40           = CO40;
    C80           = CO80;
    { Foreground and background color constants of original CRT unit }
    Black= 0;
    Blue= 1;
    Green= 2;
    Cyan= 3;
    Red= 4;
    Magenta= 5;
    Brown= 6;
    LightGray= 7;
    { Foreground color constants of original CRT unit }
    DarkGray= 8;
    LightBlue= 9;
    LightGreen= 10;
    LightCyan= 11;
    LightRed= 12;
    LightMagenta= 13;
    Yellow= 14;
    White= 15;
    { Add-in for blinking of original CRT unit }
    Blink= 128;
    {  }
    {  New constans there are not in original CRT unit }
    {  }
    MouseLeftButton=1;
    MouseRightButton=2;
    MouseCenterButton=4;

  Var
    { Interface variables of original CRT unit }
    CheckBreak: boolean;    { Enable Ctrl-Break }
    CheckEOF: boolean;      { Enable Ctrl-Z }
    DirectVideo: boolean;   { Enable direct video addressing }
    CheckSnow: boolean;     { Enable snow filtering }
    LastMode: word;         { Current text mode }
    TextAttr: byte;         { Current text attribute }
    WindMin: word;          { Window upper left coordinates }
    WindMax: word;          { Window lower right coordinates }
    {  }
    {  New variables there are not in original CRT unit }
    {  }
    MouseInstalled: boolean;
    MousePressedButtons: word;

  { Interface functions & procedures of original CRT unit }
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
  Function  MouseKeyPressed: boolean;
  Procedure MouseGotoXY(X,Y: integer);
  Function  MouseWhereY: integer;
  Function  MouseWhereX: integer;
  Procedure MouseHideCursor;
  { These functions & procedures are for inside use only }
  Function  MouseReset: boolean;
  Procedure WriteChrXY(X,Y: byte; Chr: char);
  Procedure WriteStrXY(X,Y: byte; Str: PChar; dwSize: integer );
  Procedure OverwriteChrXY(X,Y: byte; Chr: char);
{$EndIf Win32}

Implementation
{$IfDef Win32}
  Uses Windows,SysUtils;
  Type
    POpenText= ^TOpenText;
    TOpenText= Function (var F: Text; Mode: word): integer; far;

  Var
    IsWinNT: boolean;
    PtrOpenText: POpenText;
    hConsoleInput: THandle;
    hConsoleOutput: THandle;
    ConsoleScreenRect: TSmallRect;
    StartAttr: word;
    LastX,LastY: byte;
    SoundDuration: integer;
    SoundFrequency: integer;
    OldCP: integer;
    MouseRowWidth,MouseColWidth: word;
    MousePosX,MousePosY: smallInt;
    MouseButtonPressed: boolean;
    MouseEventTime: TDateTime;
  {  }
  {  This function handles the Write and WriteLn commands }
  {  }
  Function TextOut( var F: Text ): integer; far;
  {$IfDef OneByOne}
    Var
      dwSize: DWORD;
  {$EndIf}
  Begin
    With TTExtRec(F) Do Begin
      If BufPos>0 Then Begin
        LastX:=WhereX;
        LastY:=WhereY;
        {$IfDef OneByOne}
          dwSize:=0;
          While (dwSize < BufPos) Do Begin
            WriteChrXY(LastX,LastY,BufPtr[dwSize]);
            Inc(dwSize);
          End;
        {$Else}
          WriteStrXY(LastX,LastY,BufPtr,BufPos);
        {$EndIf}
        BufPos:=0;
      End;
    End;
    Result:=0;
  End;
  {  }
  {  This function handles the exchanging of Ipnout or Output }
  {  }
  Function OpenText(var F: Text; Mode: word): integer; far;
  Var
    OpenResult: integer;
  Begin
    OpenResult:=102; { Text not assigned }
    If Assigned(PtrOpenText) Then Begin
      TTextRec(F).OpenFunc:=PtrOpenText;
      OpenResult:=PtrOpenText^(F, Mode);
      If OpenResult=0 Then Begin
        If Mode=fmInput Then
          hConsoleInput:=TTextRec(F).Handle
        Else Begin
          hConsoleOutput:=TTextRec(F).Handle;
          TTextRec(Output).InOutFunc:=@TextOut;
          TTextRec(Output).FlushFunc:=@TextOut;
        End;
      End;
    End;
    Result:=OpenResult;
  End;
  {  }
  {  Filler the actual window with special character }
  {  }
  Procedure FillerScreen(FillChar: Char);
  Var
    Coord: TCoord;
    dwSize,dwCount: DWORD;
    Y: integer;
  Begin
    Coord.X:= ConsoleScreenRect.Left;
    dwSize:= ConsoleScreenRect.Right-ConsoleScreenRect.Left+1;
    For Y:=ConsoleScreenRect.Top To ConsoleScreenRect.Bottom Do Begin
      Coord.Y:= Y;
      FillConsoleOutputAttribute(hConsoleOutput,TextAttr,dwSize,Coord,dwCount);
      FillConsoleOutputCharacter(hConsoleOutput,FillChar,dwSize,Coord,dwCount);
    End;
    GotoXY(1,1);
  End;
  {  }
  {  Write one character into the X,Y position }
  {  }
  Procedure WriteChrXY(X,Y: byte; Chr: char);
  Var
    Coord: TCoord;
    dwSize,dwCount: DWORD;
  Begin
    LastX:=X;
    LastY:=Y;
    Case Chr Of
      #13: LastX:=1;
      #10: Begin
        LastX:=1;
        Inc(LastY);
      End;
      Else Begin
        Coord.X:= LastX-1+ConsoleScreenRect.Left;
        Coord.Y:= LastY-1+ConsoleScreenRect.Top;
        dwSize:=1;
        FillConsoleOutputAttribute(hConsoleOutput,TextAttr,dwSize,Coord,dwCount);
        FillConsoleOutputCharacter(hConsoleOutput,Chr,dwSize,Coord,dwCount);
        Inc(LastX);
      End;
    End;
    If (LastX+ConsoleScreenRect.Left)>(ConsoleScreenRect.Right+1) Then Begin
      LastX:=1;
      Inc(LastY);
    End;
    If (LastY+ConsoleScreenRect.Top)>(ConsoleScreenRect.Bottom+1) Then Begin
      Dec(LastY);
      GotoXY(1,1);DelLine;
    End;
    GotoXY(LastX,LastY);
  End;
  {  }
  {  Write string into the X,Y position }
  {  }
(* !!! The WriteConsoleOutput does not write into the last line !!!
  Procedure WriteStrXY(X,Y: byte; Str: PChar; dwSize: integer );
  {$IfDef OneByOne}
    Var
      dwCount: integer;
  {$Else}
    Type
      PBuffer= ^TBuffer;
      TBUffer= packed array [0..16384] of TCharInfo;
    Var
      I: integer;
      dwCount: DWORD;
      WidthHeight,Coord: TCoord;
      hTempConsoleOutput: THandle;
      SecurityAttributes: TSecurityAttributes;
      Buffer: PBuffer;
      DestinationScreenRect,SourceScreenRect: TSmallRect;
  {$EndIf}
  Begin
    If dwSize>0 Then Begin
      {$IfDef OneByOne}
        LastX:=X;
        LastY:=Y;
        dwCount:=0;
        While dwCount < dwSize Do Begin
          WriteChrXY(LastX,LastY,Str[dwCount]);
          Inc(dwCount);
        End;
      {$Else}
        SecurityAttributes.nLength:=SizeOf(SecurityAttributes)-SizeOf(DWORD);
        SecurityAttributes.lpSecurityDescriptor:=NIL;
        SecurityAttributes.bInheritHandle:=TRUE;
        hTempConsoleOutput:=CreateConsoleScreenBuffer(
         GENERIC_READ OR GENERIC_WRITE,
         FILE_SHARE_READ OR FILE_SHARE_WRITE,
         @SecurityAttributes,
         CONSOLE_TEXTMODE_BUFFER,
         NIL
        );
        If dwSize<=(ConsoleScreenRect.Right-ConsoleScreenRect.Left+1) Then Begin
          WidthHeight.X:=dwSize;
          WidthHeight.Y:=1;
        End Else Begin
          WidthHeight.X:=ConsoleScreenRect.Right-ConsoleScreenRect.Left+1;
          WidthHeight.Y:=dwSize DIV WidthHeight.X;
          If (dwSize MOD WidthHeight.X) > 0 Then Inc(WidthHeight.Y);
        End;
        SetConsoleScreenBufferSize(hTempConsoleOutput,WidthHeight);
        DestinationScreenRect.Left:=0;
        DestinationScreenRect.Top:=0;
        DestinationScreenRect.Right:=WidthHeight.X-1;
        DestinationScreenRect.Bottom:=WidthHeight.Y-1;
        SetConsoleWindowInfo(hTempConsoleOutput,FALSE,DestinationScreenRect);
        Coord.X:=0;
        For I:=1 To WidthHeight.Y Do Begin
          Coord.Y:=I-0;
          FillConsoleOutputAttribute(hTempConsoleOutput,TextAttr,WidthHeight.X,Coord,dwCount);
          FillConsoleOutputCharacter(hTempConsoleOutput,' '     ,WidthHeight.X,Coord,dwCount);
        End;
        WriteConsole(hTempConsoleOutput,Str,dwSize,dwCount,NIL);
        {  }
        New(Buffer);
        Coord.X:= 0;
        Coord.Y:= 0;
        SourceScreenRect.Left:=0;
        SourceScreenRect.Top:=0;
        SourceScreenRect.Right:=WidthHeight.X-1;
        SourceScreenRect.Bottom:=WidthHeight.Y-1;
        ReadConsoleOutputA(hTempConsoleOutput,Buffer,WidthHeight,Coord,SourceScreenRect);
        Coord.X:=X-1;
        Coord.Y:=Y-1;
        DestinationScreenRect:=ConsoleScreenRect;
        WriteConsoleOutputA(hConsoleOutput,Buffer,WidthHeight,Coord,DestinationScreenRect);
        GotoXY((dwSize MOD WidthHeight.X)-1,WidthHeight.Y+1);
        Dispose(Buffer);
        {  }
        CloseHandle(hTempConsoleOutput);
      {$EndIf}
    End;
  End;
*)
  Procedure WriteStrXY(X,Y: byte; Str: PChar; dwSize: integer );
  {$IfDef OneByOne}
    Var
      dwCount: integer;
  {$Else}
    Var
      I: integer;
      LineSize,dwCharCount,dwCount,dwWait: DWORD;
      WidthHeight: TCoord;
      OneLine: packed array [0..131] of char;
      Line,TempSrt: PChar;
      Procedure NewLine;
      Begin
        LastX:=1;
        Inc(LastY);
        If (LastY+ConsoleScreenRect.Top)>(ConsoleScreenRect.Bottom+1) Then Begin
          Dec(LastY);
          GotoXY(1,1);DelLine;
        End;
        GotoXY(LastX,LastY);
      End;
  {$EndIf}
  Begin
    If dwSize>0 Then Begin
      {$IfDef OneByOne}
        LastX:=X;
        LastY:=Y;
        dwCount:=0;
        While dwCount < dwSize Do Begin
          WriteChrXY(LastX,LastY,Str[dwCount]);
          Inc(dwCount);
        End;
      {$Else}
        dwWait:=dwSize;
        LastX:=X;
        LastY:=Y;
        If dwSize<=(ConsoleScreenRect.Right-ConsoleScreenRect.Left+1) Then Begin
          WidthHeight.X:=dwSize;
          WidthHeight.Y:=1;
        End Else Begin
          WidthHeight.X:=ConsoleScreenRect.Right-ConsoleScreenRect.Left+1;
          WidthHeight.Y:=dwSize DIV WidthHeight.X;
          If (dwSize MOD WidthHeight.X) > 0 Then Inc(WidthHeight.Y);
        End;
        TempSrt:=Str;
        For I:=1 To WidthHeight.Y Do begin
          FillChar(OneLine,SizeOf(OneLine),#0);
          Line:=@OneLine;
          LineSize:=WidthHeight.X-LastX+1;
          If LineSize>dwWait Then LineSize:=dwWait;
          Dec(dwWait,LineSize);
          StrLCopy(Line,TempSrt,LineSize);
          Inc(TempSrt,LineSize);
          dwCharCount:=Pos(#13#10,StrPas(Line));
          If dwCharCount>0 Then Begin
            OneLine[dwCharCount-1]:=#0;
            OneLine[dwCharCount]:=#0;
            WriteConsole(hConsoleOutput,Line,dwCharCount-1,dwCount,NIL);
            Inc(Line,dwCharCount+1);
            NewLine;
            LineSize:=LineSize-(dwCharCount+1);
          End;
          WriteConsole(hConsoleOutput,Line,LineSize,dwCount,NIL);
          If dwWait>0 Then NewLine;
        End;
      {$EndIf}
    End;
  End;
  {  }
  {  Empty the buffer }
  {  }
  Procedure FlushInputBuffer;
  Begin
    FlushConsoleInputBuffer(hConsoleInput);
  End;
  {  }
  {  Give size of actual cursor }
  {  }
  Function GetCursor: word;
  Var
    CCI: TConsoleCursorInfo;
  begin
    GetConsoleCursorInfo(hConsoleOutput,CCI);
    GetCursor:= CCI.dwSize;
  End;
  {  }
  {  Set size of actual cursor }
  {  }
  Procedure SetCursor(NewCursor: word);
  Var
    CCI: TConsoleCursorInfo;
  Begin
    If NewCursor=$0000 Then Begin
      CCI.dwSize:= GetCursor;
      CCI.bVisible:=False;
    End Else Begin
      CCI.dwSize:=NewCursor;
      CCI.bVisible:=True;
    End;
    SetConsoleCursorInfo(hConsoleOutput,CCI);
  End;
  {  }
  { --- Begin of Interface functions & procedures of original CRT unit --- }
  Procedure AssignCrt(Var F: Text);
  Begin
    Assign(F,'');
    TTextRec(F).OpenFunc:=@OpenText;
  End;

  Function KeyPressed: boolean;
  Var
    NumberOfEvents: DWORD;
    NumRead: DWORD;
    InputRec: TInputRecord;
    Pressed: boolean;
  Begin
    Pressed:=False;
    GetNumberOfConsoleInputEvents(hConsoleInput,NumberOfEvents);
    If NumberOfEvents > 0 Then Begin
      If PeekConsoleInput(hConsoleInput,InputRec,1,NumRead) Then Begin
         If (InputRec.EventType = KEY_EVENT) AND (InputRec{$IfDef VER120}.Event{$EndIf}.KeyEvent.bKeyDown) Then Begin
           Pressed:=True;
           {$IfDef MOUSE_IS_USED}
              MouseButtonPressed:=FALSE;
           {$EndIf}
         End Else Begin
           {$IfDef MOUSE_IS_USED}
             If (InputRec.EventType = _MOUSE_EVENT)  Then Begin
               With InputRec{$IfDef VER120}.Event{$EndIf}.MouseEvent Do Begin
                 MousePosX:=dwMousePosition.X;
                 MousePosY:=dwMousePosition.Y;
                 If dwButtonState=FROM_LEFT_1ST_BUTTON_PRESSED Then Begin
                   MouseEventTime:=NOW;
                   MouseButtonPressed:=TRUE;
                   {If (dwEventFlags AND DOUBLE_CLICK)<>0 Then Begin}
                   {End;}
                 End;
               End;
             End;
             ReadConsoleInput(hConsoleInput,InputRec,1,NumRead);
           {$Else}
             ReadConsoleInput(hConsoleInput,InputRec,1,NumRead);
           {$EndIf}
         End;
      End;
    End;
    Result := Pressed;
  End;

  Function ReadKey: char;
  Var
    NumRead: DWORD;
    InputRec: TInputRecord;
  Begin
    Repeat
      Repeat
      Until KeyPressed;
      ReadConsoleInput(hConsoleInput,InputRec,1,NumRead);
    Until InputRec{$IfDef VER120}.Event{$EndIf}.KeyEvent.wVirtualKeyCode > 0;
    //InputRec{$IfDef VER120}.Event{$EndIf}.KeyEvent.AsciiChar>#0;
    Result:= Char(InputRec{$IfDef VER120}.Event{$EndIf}.KeyEvent.wVirtualKeyCode);
    //InputRec{$IfDef VER120}.Event{$EndIf}.KeyEvent.AsciiChar;
  End;

  Procedure TextMode(Mode: Integer);
  Begin
  End;

  Procedure Window(X1,Y1,X2,Y2: byte);
  Begin
    ConsoleScreenRect.Left:= X1-1;
    ConsoleScreenRect.Top:= Y1-1;
    ConsoleScreenRect.Right:= X2-1;
    ConsoleScreenRect.Bottom:= Y2-1;
    WindMin:= (ConsoleScreenRect.Top SHL 8) OR ConsoleScreenRect.Left;
    WindMax:= (ConsoleScreenRect.Bottom SHL 8) OR ConsoleScreenRect.Right;
    {$IfDef WindowFrameToo}
      SetConsoleWindowInfo(hConsoleOutput,TRUE,ConsoleScreenRect);
    {$EndIf}
    GotoXY(1,1);
  End;

  Procedure GotoXY(X,Y: byte);
  Var
    Coord :TCoord;
  Begin
    Coord.X:= X-1+ConsoleScreenRect.Left;
    Coord.Y:= Y-1+ConsoleScreenRect.Top;
    SetConsoleCursorPosition(hConsoleOutput,Coord);
  End;

  Function WhereX: byte;
  Var
    CBI: TConsoleScreenBufferInfo;
  Begin
    GetConsoleScreenBufferInfo(hConsoleOutput,CBI);
    Result:= TCoord(CBI.dwCursorPosition).X+1-ConsoleScreenRect.Left;
  End;

  Function WhereY: byte;
  Var
    CBI: TConsoleScreenBufferInfo;
  Begin
    GetConsoleScreenBufferInfo(hConsoleOutput,CBI);
    Result:= TCoord(CBI.dwCursorPosition).Y+1-ConsoleScreenRect.Top;
  End;

  Procedure ClrScr;
  Begin
    FillerScreen(' ');
  End;

  Procedure ClrEol;
  Var
    Coord:TCoord;
    dwSize,dwCount: DWORD;
  Begin
    Coord.X:= WhereX-1+ConsoleScreenRect.Left;
    Coord.Y:= WhereY-1+ConsoleScreenRect.Top;
    dwSize:= ConsoleScreenRect.Right-Coord.Y+1;
    FillConsoleOutputAttribute(hConsoleOutput,TextAttr,dwSize,Coord,dwCount);
    FillConsoleOutputCharacter(hConsoleOutput,' ',dwSize,Coord,dwCount);
  End;

  Procedure InsLine;
  Var
    SourceScreenRect: TSmallRect;
    Coord: TCoord;
    CI: TCharInfo;
    dwSize,dwCount: DWORD;
  Begin
    SourceScreenRect:= ConsoleScreenRect;
    SourceScreenRect.Top:= WhereY-1+ConsoleScreenRect.Top;
    SourceScreenRect.Bottom:=ConsoleScreenRect.Bottom-1;
    CI.AsciiChar:= ' ';
    CI.Attributes:= TextAttr;
    Coord.X:= SourceScreenRect.Left;
    Coord.Y:= SourceScreenRect.Top+1;
    dwSize:= SourceScreenRect.Right-SourceScreenRect.Left+1;
    ScrollConsoleScreenBuffer(hConsoleOutput,SourceScreenRect,NIL,Coord,CI);
    Dec(Coord.Y);
    FillConsoleOutputAttribute(hConsoleOutput,TextAttr,dwSize,Coord,dwCount);
  End;

  Procedure DelLine;
  Var
    SourceScreenRect: TSmallRect;
    Coord: TCoord;
    CI: TCharinfo;
    dwSize,dwCount: DWORD;
  Begin
    SourceScreenRect:= ConsoleScreenRect;
    SourceScreenRect.Top:= WhereY+ConsoleScreenRect.Top;
    CI.AsciiChar:= ' ';
    CI.Attributes:= TextAttr;
    Coord.X:= SourceScreenRect.Left;
    Coord.Y:= SourceScreenRect.Top-1;
    dwSize:= SourceScreenRect.Right-SourceScreenRect.Left+1;
    ScrollConsoleScreenBuffer(hConsoleOutput,SourceScreenRect,NIL,Coord,CI);
    FillConsoleOutputAttribute(hConsoleOutput,TextAttr,dwSize,Coord,dwCount);
  End;

  Procedure TextColor(Color: byte);
  Begin
    LastMode:= TextAttr;
    TextAttr:= (Color AND $0F) OR (TextAttr AND $F0);
    SetConsoleTextAttribute(hConsoleOutput,TextAttr);
  End;

  Procedure TextBackground(Color: byte);
  Begin
    LastMode:= TextAttr;
    TextAttr:= (Color SHL 4) OR (TextAttr AND $0F);
    SetConsoleTextAttribute(hConsoleOutput,TextAttr);
  End;

  Procedure LowVideo;
  Begin
    LastMode:= TextAttr;
    TextAttr:= TextAttr AND $F7;
    SetConsoleTextAttribute(hConsoleOutput,TextAttr);
  End;

  Procedure HighVideo;
  Begin
    LastMode:= TextAttr;
    TextAttr:= TextAttr OR $08;
    SetConsoleTextAttribute(hConsoleOutput,TextAttr);
  End;

  Procedure NormVideo;
  Begin
    LastMode := TextAttr;
    TextAttr := StartAttr;
    SetConsoleTextAttribute(hConsoleOutput,TextAttr);
  End;

  Procedure Delay(MS: word);
  {
  Const
    Magic= $80000000;
  var
   StartMS,CurMS,DeltaMS: DWORD;
   }
  Begin
    Windows.Sleep(MS);
    {
    StartMS:= GetTickCount;
    Repeat
      CurMS:= GetTickCount;
      If CurMS >= StartMS Then
         DeltaMS:= CurMS - StartMS
      Else DeltaMS := (CurMS + Magic) - (StartMS - Magic);
    Until MS<DeltaMS;
    }
  End;

  Procedure Sound(Hz: word);
  Begin
    {SetSoundIOPermissionMap(LocalIOPermission_ON);}
    SoundFrequency:=Hz;
    If IsWinNT Then Begin
      Windows.Beep(SoundFrequency,SoundDuration)
    End Else Begin
      ASM
        mov  BX,Hz
        cmp  BX,0
        jz   @2
        mov  AX,$34DD
        mov  DX,$0012
        cmp  DX,BX
        jnb  @2
        div  BX
        mov  BX,AX
        { Sound is On ? }
        in   Al,$61
        test Al,$03
        jnz  @1
        { Set Sound On }
        or   Al,03
        out  $61,Al
        { Timer Command }
        mov  Al,$B6
        out  $43,Al
        { Set Frequency }
    @1: mov  Al,Bl
        out  $42,Al
        mov  Al,Bh
        out  $42,Al
    @2:
      END;
    End;
  End;

  Procedure NoSound;
  Begin
    If IsWinNT Then Begin
      Windows.Beep(SoundFrequency,0);
    End Else Begin
      ASM
        { Set Sound On }
        in   Al,$61
        and  Al,$FC
        out  $61,Al
      END;
    End;
    {SetSoundIOPermissionMap(LocalIOPermission_OFF);}
  End;
  { --- End of Interface functions & procedures of original CRT unit --- }
  {  }
  Procedure OverwriteChrXY(X,Y: byte; Chr: char);
  Var
    Coord: TCoord;
    dwSize,dwCount: DWORD;
  Begin
    LastX:=X;
    LastY:=Y;
    Coord.X:= LastX-1+ConsoleScreenRect.Left;
    Coord.Y:= LastY-1+ConsoleScreenRect.Top;
    dwSize:=1;
    FillConsoleOutputAttribute(hConsoleOutput,TextAttr,dwSize,Coord,dwCount);
    FillConsoleOutputCharacter(hConsoleOutput,Chr,dwSize,Coord,dwCount);
    GotoXY(LastX,LastY);
  End;

  {  --------------------------------------------------  }
  {  Console Event Handler }
  {  }
  {$IfDef CRT_EVENT}
    Function ConsoleEventProc(CtrlType : DWORD) : Bool; stdcall; far;
    Var
      S: {$IfDef Win32}ShortString{$Else}String{$EndIf};
      Message: PChar;
    Begin
      Case CtrlType Of
        CTRL_C_EVENT        : S:= 'CTRL_C_EVENT';
        CTRL_BREAK_EVENT    : S:= 'CTRL_BREAK_EVENT';
        CTRL_CLOSE_EVENT    : S:= 'CTRL_CLOSE_EVENT';
        CTRL_LOGOFF_EVENT   : S:= 'CTRL_LOGOFF_EVENT';
        CTRL_SHUTDOWN_EVENT : S:= 'CTRL_SHUTDOWN_EVENT';
        Else S:= 'UNKNOWN_EVENT';
      End;
      S:=S+' detected, but we not handled it.';
      Message:=@S;
      Inc(Message);
      MessageBox(0, Message, 'Win32 Console', MB_OK);
      Result := True;
    End;
  {$EndIf}

  Function MouseReset: boolean;
  Begin
    MouseColWidth:=1;
    MouseRowWidth:=1;
    Result:=TRUE;
  End;

  Procedure MouseShowCursor;
  const
    ShowMouseConsoleMode = ENABLE_MOUSE_INPUT;
  var
    cMode: DWORD;
  Begin
    GetConsoleMode(hConsoleInput,cMode);
    If (cMode AND ShowMouseConsoleMode) <> ShowMouseConsoleMode Then Begin
      cMode:=cMode OR ShowMouseConsoleMode;
      SetConsoleMode(hConsoleInput,cMode);
    End;
  End;

  Procedure MouseHideCursor;
  const
    ShowMouseConsoleMode = ENABLE_MOUSE_INPUT;
  var
    cMode: DWORD;
  Begin
    GetConsoleMode(hConsoleInput,cMode);
    If (cMode AND ShowMouseConsoleMode) = ShowMouseConsoleMode Then Begin
      cMode:=cMode AND ($FFFFFFFF XOR ShowMouseConsoleMode);
      SetConsoleMode(hConsoleInput,cMode);
    End;
  End;

  Function MouseKeyPressed: boolean;
  {$IfDef MOUSE_IS_USED}
    Const
      MouseDeltaTime=200;
    Var
      ActualTime: TDateTime;
      HourA,HourM,MinA,MinM,SecA,SecM,MSecA,MSecM: word;
      MSecTimeA,MSecTimeM: longInt;
      MSecDelta: longInt;
  {$EndIf}
  Begin
    MousePressedButtons:=0;
    {$IfDef MOUSE_IS_USED}
      Result:=False;
      If MouseButtonPressed Then Begin
        ActualTime:=NOW;
        DecodeTime(ActualTime,HourA,MinA,SecA,MSecA);
        DecodeTime(MouseEventTime,HourM,MinM,SecM,MSecM);
        MSecTimeA:=(3600*HourA+60*MinA+SecA)*100+MSecA;
        MSecTimeM:=(3600*HourM+60*MinM+SecM)*100+MSecM;
        MSecDelta:=Abs(MSecTimeM-MSecTimeA);
        If (MSecDelta<MouseDeltaTime) OR (MSecDelta>(8784000-MouseDeltaTime)) Then Begin
          MousePressedButtons:=MouseLeftButton;
          MouseButtonPressed:=FALSE;
          Result:=True;
        End;
      End;
    {$Else}
      Result:=FALSE;
    {$EndIf}
  End;

  Procedure MouseGotoXY(X,Y: integer);
  Begin
    {$IfDef MOUSE_IS_USED}
      mouse_event(MOUSEEVENTF_ABSOLUTE OR MOUSEEVENTF_MOVE,X-1,Y-1,WHEEL_DELTA,GetMessageExtraInfo() );
      MousePosY:=(Y-1)*MouseRowWidth;
      MousePosX:=(X-1)*MouseColWidth;
    {$EndIf}
  End;

  Function MouseWhereY: integer;
  {$IfDef MOUSE_IS_USED}
    {Var
      lppt, lpptBuf: TMouseMovePoint;}
  {$EndIf}
  Begin
    {$IfDef MOUSE_IS_USED}
      {GetMouseMovePoints(
        SizeOf(TMouseMovePoint), lppt, lpptBuf,
        7,GMMP_USE_DRIVER_POINTS
      );
      Result:=lpptBuf.Y DIV MouseRowWidth;}
      Result:=(MousePosY DIV MouseRowWidth)+1;
    {$Else}
      Result:=-1;
    {$EndIf}
  End;

  Function MouseWhereX: integer;
  {$IfDef MOUSE_IS_USED}
    {Var
      lppt, lpptBuf: TMouseMovePoint;}
  {$EndIf}
  Begin
    {$IfDef MOUSE_IS_USED}
      {GetMouseMovePoints(
        SizeOf(TMouseMovePoint), lppt, lpptBuf,
        7,GMMP_USE_DRIVER_POINTS
      );
      Result:=lpptBuf.X DIV MouseColWidth;}
      Result:=(MousePosX DIV MouseColWidth)+1;
    {$Else}
      Result:=-1;
    {$EndIf}
  End;
  {  }
  Procedure Init;
  const
    ExtInpConsoleMode = ENABLE_WINDOW_INPUT OR ENABLE_PROCESSED_INPUT OR ENABLE_MOUSE_INPUT;
    ExtOutConsoleMode = ENABLE_PROCESSED_OUTPUT OR ENABLE_WRAP_AT_EOL_OUTPUT;
  var
    cMode: DWORD;
    Coord: TCoord;
    OSVersion: TOSVersionInfo;
    CBI: TConsoleScreenBufferInfo;
  Begin
    OSVersion.dwOSVersionInfoSize:= SizeOf(TOSVersionInfo);
    GetVersionEx(OSVersion);
    If OSVersion.dwPlatformId = VER_PLATFORM_WIN32_NT Then
      IsWinNT:=TRUE
    Else IsWinNT:=FALSE;
    PtrOpenText:= TTextRec(Output).OpenFunc;
    {$IfDef HARD_CRT}
      AllocConsole;
      hConsoleInput:= GetStdHandle(STD_INPUT_HANDLE);
      TTextRec(Input).Mode:=fmInput;
      TTextRec(Input).Handle:= hConsoleInput;
      hConsoleOutput:= GetStdHandle(STD_OUTPUT_HANDLE);
      TTextRec(Output).Mode:=fmOutput;
      TTextRec(Output).Handle:= hConsoleOutput;
    {$Else}
      Reset(Input);
      hConsoleInput:= TTextRec(Input).Handle;
      ReWrite(Output);
      hConsoleOutput:= TTextRec(Output).Handle;
    {$EndIf}
    GetConsoleMode(hConsoleInput,cMode);
    If (cMode AND ExtInpConsoleMode) <> ExtInpConsoleMode Then Begin
      cMode:=cMode OR ExtInpConsoleMode;
      SetConsoleMode(hConsoleInput,cMode);
    End;

    TTextRec(Output).InOutFunc:=@TextOut;
    TTextRec(Output).FlushFunc:=@TextOut;
    GetConsoleScreenBufferInfo(hConsoleOutput,CBI);
    GetConsoleMode(hConsoleOutput,cMode);
    If (cMode AND ExtOutConsoleMode) <> ExtOutConsoleMode Then Begin
      cMode:=cMode OR ExtOutConsoleMode;
      SetConsoleMode(hConsoleOutput,cMode);
    End;
    TextAttr:= CBI.wAttributes;
    StartAttr:= CBI.wAttributes;
    LastMode:= CBI.wAttributes;

    Coord.X:= CBI.srWindow.Left;
    Coord.Y:= CBI.srWindow.Top;
    WindMin:= (Coord.Y SHL 8) OR Coord.X;
    Coord.X:= CBI.srWindow.Right;
    Coord.Y:= CBI.srWindow.Bottom;
    WindMax:= (Coord.Y SHL 8) OR Coord.X;
    ConsoleScreenRect:=CBI.srWindow;

    SoundDuration:= -1;
    OldCp:= GetConsoleOutputCP;
    SetConsoleOutputCP(1250);
    {$IfDef CRT_EVENT}
      SetConsoleCtrlHandler(@ConsoleEventProc, True);
    {$EndIf}
    {$IfDef MOUSE_IS_USED}
      SetCapture(hConsoleInput);
      KeyPressed;
    {$EndIf}
    MouseInstalled:=MouseReset;
  End;
  {  }
  Procedure Done;
  Begin
    {$IfDef CRT_EVENT}
      SetConsoleCtrlHandler(@ConsoleEventProc, False);
    {$EndIf}
    SetConsoleOutputCP(OldCP);
    TextAttr:= StartAttr;
    SetConsoleTextAttribute(hConsoleOutput,TextAttr);
    ClrScr;
    FlushInputBuffer;
    {$IfDef HARD_CRT}
      TTextRec(Input).Mode:=fmClosed;
      TTextRec(Output).Mode:=fmClosed;
      FreeConsole;
    {$Else}
      Close(Input);
      Close(Output);
    {$EndIf}
  end;

  initialization
    Init;
  finalization
    Done;
{$Endif win32}
End.

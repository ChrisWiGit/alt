{}
unit compilerdirektiven;

{Infos zu den Compilerdirektiven, siehe DelphiHilfe
IF directive

$IFDEF conditionalexpressions

.          // code including IF directive
.          // only executes if supported
$ENDIF}
{$DEFINE DEBUG}

{$IFDEF DEBUG}
procedure Debugger;
{$ELSE}
procedure Releaser;
{$ENDIF}

{$UNDEF DEBUG}

{$IFDEF DEBUG}
procedure Releaser2;
{$ENDIF}


implementation
{$IFDEF PROFILE}USES Profint;{$ENDIF}

{$DEFINE CLX}

const LibVersion = 2.1;

{$IF Defined(CLX) and (LibVersion > 2.0) }
  procedure CLXLib(alib : shortstring);
{$ELSE}
  procedure Lib(alib : string);
{$IFEND}

{$IF Defined(CLX) }
  procedure CLXLib1w(alib : shortstring);
{$ELSEIF LibVersion > 2.0}
  procedure CLXLib3w(alib : shortstring);
{$ELSEIF LibVersion = 2.0}
  procedure CLXLib2w(alib : shortstring);
{$ELSE}
  procedure CLXLibw(alib : shortstring);
{$IFEND}

{$IF Declared(Test)}
  ... // successful
{$IFEND}



interface
implementation

end.







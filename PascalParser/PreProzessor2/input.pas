{}
unit compilerdirektiven;

interface

{$IF Defined(CLX) and (LibVersion = '123') }
  procedure Lib(alib : string);
{$IFEND}hier ist nach ende -> AD

implementation
{$IFDEF PROFILE}USES Profint;{$ENDIF}

{UNDEF DEBUG}



implementation

const LibVersion = 2.1;


{$R +}

{$eEFINE D123}

{$IFNDEF DEBUG}
hallo
{$ELSE}
else
{$ENDIF}

{$IFNDEF DEBUG}
test2
{$ELSE}
else
{$ENDIF}

{$IF Defined(CLX) and (LibVersion > 2.0) }
  procedure CLXLib(alib : shortstring);
{$ELSE}
  procedure Lib(alib : string);
{$IFEND}



{$DEFINE CLX}


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







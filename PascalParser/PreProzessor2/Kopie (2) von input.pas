//******************************************************************************
// 
// Module Name : test
// ************* 
// 
// Programmer : rpogger
// ************ 
// 
// Version : 1.22.1
// ********* 
// 
// Bugs : 
// ****** 
//    no bugs
// 
// Comments : 
// ********** 
//   no comments 
// 
// Terminology : 
// ************* 
//    no term
// 
// Discussion : 
// ************ 
//   no disc 
// 
// Expected Usage : 
// **************** 
//   no eu 
// 
// Technical : 
// *********** 
//   no tech 
// 
// Documentation : 
// *************** 
//   no doc 
// 
//******************************************************************************
//******************************************************************************
// 
// Module Name : 
// ************* 
// 
// Programmer : 
// ************ 
// 
// Version : 
// ********* 
// 
// Bugs : 
// ****** 
//    
// 
// Comments : 
// ********** 
//    
// 
// Terminology : 
// ************* 
//    
// 
// Discussion : 
// ************ 
//    
// 
// Expected Usage : 
// **************** 
//    
// 
// Technical : 
// *********** 
//    
// 
// Documentation : 
// *************** 
//    
// 
//******************************************************************************
{}
unit compilerdirektiven;

interface

const LibVersion = 0;

{$IF Defined(CLX) and (LibVersion > 2.0) }
  {$R+}

  procedure CLXLib(alib : shortstring);
  {$IF Defined(CLX) and (LibVersion > 2.0) }
  sadfasdf
  {$ELSE}
   procedure Lib(alib : string);
  {$IFEND}
{$ELSE}
  procedure Lib(alib : string);
{$IFEND}

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







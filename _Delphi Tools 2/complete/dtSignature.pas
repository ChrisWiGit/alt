unit dtSignature;

interface
uses Windows,Classes,SysUtils;

type
     //speichern und laden von Versionsnummern in Streams
  TVersionRec = record
    Hi, Lo: Byte; //Kann genutzt werden wie man will
    Version: Integer; // "      "       "    "   "    "
  end;

  //Signaturen für Dateierkennung behandeln
type
  TSignatureRec = record
    SignatureStr,
      SubSignature,

    Programmer,
      Company,
      CopyRight,

    Notice,
      Comment,

    FileName,
      FileTyp: string;
    DateTime: TDateTime;
    TimeStamp: TTimeStamp;
  end;

  //Zusammensetzung von TSignatureRec und TVersionRec
type TSignVersion = record
    Signature: TSignatureRec;
    Version: TVersionRec;
  end;

type
      //wird von ReadValidSignVersion , EqualSignVersion und EqualSignVersionMin aufgerufen , wenn
      //SignVersionCompUsrFunc <> nil ist
      //Die Paramater werden den Funktionen wie folgt übergeben
      //ReadValidSignVersion : SignVersionCompUsrFunc(SignatureData,0);
      //EqualSignVersion     : SignVersionCompUsrFunc(SignatureData1,SignatureData2);
      //EqualSignVersionMin     : SignVersionCompUsrFunc(SignatureData1,SignatureData2);

  TSignVersionCompUsrFunc = function(SignatureData1, SignatureData2: TSignVersion): Boolean;

const
       //ermöglicht es einen benutzerdefinierte Vergleich bei einer Signatureerkennung
       //Man muß nur eine Funktion des Typs TSignVersionCompUsrFunc an SignVersionCompUsrFunc übergeben
       //Soll die Standardvergleiche verwendet werden muß SignVersionCompUsrFunc auf nil gesetzt werden
  SignVersionCompUsrFunc: TSignVersionCompUsrFunc = nil;
{DelphiTools}
  DelphiTools_SignVersion: TSignVersion = (
    Signature: (
    SignatureStr: 'DelphiTools';
    SubSignature: 'D-Library';
    Programmer: 'Hacker John';
    Company: '';
    CopyRight: '';
    Notice: '';
    Comment: '';
    FileName: '';
    FileTyp: '';
    DateTime: 0;
    TimeStamp: (
    Time: 0;
    Date: 0
    )
    );

    Version: (
    Hi: 1;
    Lo: 8;
    Version: 180
    )
    );


  { <TITLE kö>
  
  cvghfgh
             }
NULL_SignVersion: TSignVersion = (
    Signature: (
    SignatureStr: '';
    SubSignature: '';
    Programmer: '';
    Company: '';
    CopyRight: '';
    Notice: '';
    Comment: '';
    FileName: '';
    FileTyp: '';
    DateTime: 0;
    TimeStamp: (
    Time: 0;
    Date: 0
    )
    );

    Version: (
    Hi: 0;
    Lo: 0;
    Version: 0
    )
    );

(*

Definition einer TSignVersion-Struktur als Konstante
SignVersion           : TSignVersion = (
                              Signature : (
                                           SignatureStr : '';
                                           SubSignature : '';
                                           Programmer   : '';
                                           Company      : '';
                                           CopyRight    : '';
                                           Notice       : '';
                                           Comment      : '';
                                           FileName     : '';
                                           FileTyp      : '';
                                           DateTime     : 0;
                                           TimeStamp    : (
                                                           Time : 0;
                                                           Date : 0
                                                           )
                                           );
                              Version   : (
                                           Hi:0
                                           Lo:0;
                                           Version:0
                                          )
                              );

Signature : TSignatureRec = (
                                           SignatureStr : '';
                                           SubSignature : '';
                                           Programmer   : '';
                                           Company      : '';
                                           CopyRight    : '';
                                           Notice       : '';
                                           Comment      : '';
                                           FileName     : '';
                                           FileTyp      : '';
                                           DateTime     : 0;
                                           TimeStamp    : (
                                                           Time : 0;
                                                           Date : 0
                                                           )
                                           );

Version   : TVersionRec =  (
                                           Hi:0
                                           Lo:0;
                                           Version:0
                                          );

*)
const
  VersionIndentLen = 5;
  SignatureIndentLen = 5;
  VersionIndent: array[0..VersionIndentLen - 1] of char = (#2, #4, #2, #6, #8);

//      SignatureIndent = #54#34#23#65;
  SignatureIndent: array[0..SignatureIndentLen - 1] of char = (#2, #4, #2, #6, #8);


    //Schreibt den Record als Binärtdaten in den Stream
function WriteVersion(Stream: TStream; Version: TVersionRec): Longint;
   //Liest den Record als Binärtdaten aus dem Stream

function ReadVersion(Stream: TStream): TVersionRec;

  //Liest den Record als Binärtdaten aus den Stream , vergleicht den geladenen Record mit Version und gibt bei Gleichheit TRUE , sonst FALSE
 // zurück
function ReadValidVersion(Stream: TStream; Version: TVersionRec): Boolean;
 //Vergleicht peinlich genau zwei TVersionRec-Datentypen miteinander
function EqualVersion(Version1, Version2: TVersionRec): Boolean;

function SizeOfVersionRec(Rec: TVersionRec): Longint;



//Initialisiert TSignatureRec mit 0
procedure InitiateSignature(var SignatureData: TSignatureRec);
//Schreibt TSignatureRec in einen Stream
function WriteSignature(Stream: TStream; SignatureData: TSignatureRec): Longint;
//Liest TSignatureRec aus einem Stream
function ReadSignature(Stream: TStream): TSignatureRec;

  //Lies den TSignatureRec -Record als Binärtdaten aus den Stream , vergleicht den geladenen Record mit SignatureData und gibt bei Gleichheit TRUE , sonst FALSE
 // zurück
function ReadValidSignature(Stream: TStream; SignatureData: TSignatureRec): Boolean;
// Folgende Daten werden verglichen      SignatureStr,SubSignature,FileName,FileTyp
function ReadValidSignatureMin(Stream: TStream; SignatureData: TSignatureRec): Boolean;

 //Vergleicht peinlich genau zwei TSignatureRec-Datentypen miteinander
function EqualSignature(SignatureData1, SignatureData2: TSignatureRec): Boolean;
 //Vergleicht zwei TSignatureRec-Datentypen miteinander
// Folgende Daten werden verglichen      SignatureStr,SubSignature,FileName,FileTyp
function EqualSignatureMin(SignatureData1, SignatureData2: TSignatureRec): Boolean;

function SizeOfSignatureRec(Rec: TSignatureRec): Longint;



function CreateSignVersion: TSignVersion;

//  Schreibt TSignVersion in einen Stream
function WriteSignVersion(Stream: TStream; SignVersion: TSignVersion): Longint;
//Liest TSignVersion aus einem Stream
function ReadSignVersion(Stream: TStream): TSignVersion;

  //Lies den TSignVersion-Record als Binärtdaten aus den Stream , vergleicht den geladenen Record mit SignatureData und gibt bei Gleichheit TRUE , sonst FALSE
 // zurück
function ReadValidSignVersion(Stream: TStream; SignatureData: TSignVersion): Boolean;
// Folgende Daten werden verglichen      SignatureStr,SubSignature,FileName,FileTyp , Version
function ReadValidSignVersionMin(Stream: TStream; SignatureData: TSignVersion): Boolean;

 //Vergleicht peinlich genau zwei TSignVersion-Datentypen miteinander
function EqualSignVersion(SignatureData1, SignatureData2: TSignVersion): Boolean;
//Vergleicht  SignatureStr,SubSignature,FileName,FileTyp
function EqualSignVersionMin(SignatureData1, SignatureData2: TSignVersion): Boolean;

//Kopiert TVersionRec und TSignatureRec zusammen in ein TSignVersion-Record
function ConvertToSignVersion(Version: TVersionRec; SignatureData: TSignatureRec): TSignVersion;

function SizeOfSignVersion(Sign: TSignVersion): Longint;


implementation
uses dtSystem,dtStream;


function WriteVersion(Stream: TStream; Version: TVersionRec): Longint;
begin
  Result := 0;
  ASSERT(Assigned(Stream), 'SaveVersion : Parameter Stream must not be nil');

  Inc(Result, Stream.Write(VersionIndent, VersionIndentLen));

  Inc(Result, WriteInteger(Stream, Version.Hi));
  Inc(Result, WriteInteger(Stream, Version.Lo));
  Inc(Result, WriteInteger(Stream, Version.Version));
  {Stream.Write(Version.Hi     ,SizeOf(Version.Hi     ));
  Stream.Write(Version.Lo     ,SizeOf(Version.Lo     ));
  Stream.Write(Version.Version,SizeOf(Version.Version));}
end;

function ReadVersion(Stream: TStream): TVersionRec;
//var VersionData : TVersionRec;
var s: array[0..VersionIndentLen - 1] of char;
begin
  ASSERT(Assigned(Stream), 'LoadVersion : Parameter Stream must not be nil');

  Fillchar(Result, SizeOf(Result), 0);

  Stream.Read(s, VersionIndentLen);
  if string(s) <> VersionIndent then exit;


  try
    Result.Hi := ReadInteger(Stream);
    Result.Lo := ReadInteger(Stream);
    Result.Version := ReadInteger(Stream);
  except
    Fillchar(Result, SizeOf(Result), 0);
  end;
end;

function ReadValidVersion(Stream: TStream; Version: TVersionRec): Boolean;
begin
  Result := EqualVersion(ReadVersion(Stream), Version);
end;

function EqualVersion(Version1, Version2: TVersionRec): Boolean;
begin
  Result := (Version1.Hi = Version2.Hi) and
    (Version1.Lo = Version2.Lo) and
    (Version1.Version = Version2.Version);
end;

function SizeOfVersionRec(Rec: TVersionRec): Longint;
begin
  Result := 0;
  Inc(Result, VersionIndentLen);
  Inc(Result, SizeOf(Integer(Rec.Hi)));
  Inc(Result, SizeOf(Integer(Rec.Lo)));
  Inc(Result, SizeOf(Integer(Rec.Version)));
end;

procedure InitiateSignature(var SignatureData: TSignatureRec);
begin
  FillChar(SignatureData, SizeOf(SignatureData), 0);
end;

function WriteSignature(Stream: TStream; SignatureData: TSignatureRec): Longint;
begin
  Result := 0;
  ASSERT(Assigned(Stream), 'WriteSignature : Parameter Stream must not be nil');

  Inc(Result, Stream.Write(SignatureIndent, SignatureIndentLen));

  Inc(Result, WriteString(Stream, SignatureData.SignatureStr));
  Inc(Result, WriteString(Stream, SignatureData.SubSignature));

  Inc(Result, WriteString(Stream, SignatureData.Programmer));
  Inc(Result, WriteString(Stream, SignatureData.Company));
  Inc(Result, WriteString(Stream, SignatureData.CopyRight));

  Inc(Result, WriteString(Stream, SignatureData.Notice));
  Inc(Result, WriteString(Stream, SignatureData.Comment));

  Inc(Result, WriteString(Stream, SignatureData.FileName));
  Inc(Result, WriteString(Stream, SignatureData.FileTyp));

  Inc(Result, Stream.Write(SignatureData.DateTime, SizeOf(SignatureData.DateTime)));
  Inc(Result, Stream.Write(SignatureData.TimeStamp, SizeOf(SignatureData.TimeStamp)));
end;

function ReadSignature(Stream: TStream): TSignatureRec;
var s: array[0..SignatureIndentLen - 1] of char;
begin
  ASSERT(Assigned(Stream), 'ReadSignature : Parameter Stream must not be nil');

  Fillchar(Result, SizeOf(Result), 0);

  Stream.Read(s, SignatureIndentLen);
  if string(s) <> SignatureIndent then exit;

  try
    Result.SignatureStr := ReadString(Stream);
    Result.SubSignature := ReadString(Stream);

    Result.Programmer := ReadString(Stream);
    Result.Company := ReadString(Stream);
    Result.CopyRight := ReadString(Stream);

    Result.Notice := ReadString(Stream);
    Result.Comment := ReadString(Stream);

    Result.FileName := ReadString(Stream);
    Result.FileTyp := ReadString(Stream);

    Stream.Read(Result.DateTime, SizeOf(Result.DateTime));
    Stream.Read(Result.TimeStamp, SizeOf(Result.TimeStamp));
  except
    Fillchar(Result, SizeOf(Result), 0);
  end;
end;

function ReadValidSignature(Stream: TStream; SignatureData: TSignatureRec): Boolean;
begin
  Result := EqualSignature(ReadSignature(Stream), SignatureData);
end;


function ReadValidSignatureMin(Stream: TStream; SignatureData: TSignatureRec): Boolean;
begin
  Result := EqualSignatureMin(ReadSignature(Stream), SignatureData);
end;

function EqualSignature(SignatureData1, SignatureData2: TSignatureRec): Boolean;
begin
  Result := (CompareStr(SignatureData1.SignatureStr, SignatureData2.SignatureStr) = 0) and
    (CompareStr(SignatureData1.SubSignature, SignatureData2.SubSignature) = 0) and
    (CompareStr(SignatureData1.Programmer, SignatureData2.Programmer) = 0) and
    (CompareStr(SignatureData1.Company, SignatureData2.Company) = 0) and
    (CompareStr(SignatureData1.CopyRight, SignatureData2.CopyRight) = 0) and
    (CompareStr(SignatureData1.SignatureStr, SignatureData2.SignatureStr) = 0) and
    (CompareStr(SignatureData1.Notice, SignatureData2.Notice) = 0) and
    (CompareStr(SignatureData1.Comment, SignatureData2.Comment) = 0) and
    (CompareStr(SignatureData1.FileName, SignatureData2.FileName) = 0) and
    (CompareStr(SignatureData1.FileTyp, SignatureData2.FileTyp) = 0) and
    (SignatureData1.DateTime = SignatureData2.DateTime) and
    (SignatureData1.TimeStamp.Time = SignatureData2.TimeStamp.Time) and
    (SignatureData1.TimeStamp.Date = SignatureData2.TimeStamp.Date);
end;

function EqualSignatureMin(SignatureData1, SignatureData2: TSignatureRec): Boolean;
begin
  Result := (CompareStr(SignatureData1.SignatureStr, SignatureData2.SignatureStr) = 0) and
    (CompareStr(SignatureData1.SubSignature, SignatureData2.SubSignature) = 0) and
    (CompareStr(SignatureData1.FileName, SignatureData2.FileName) = 0) and
    (CompareStr(SignatureData1.FileTyp, SignatureData2.FileTyp) = 0);
end;



function SizeOfSignatureRec(Rec: TSignatureRec): Longint;
begin
  Result := 0;
  Inc(Result, SignatureIndentLen);
  Inc(Result, SizeOfString(Rec.SignatureStr));
  Inc(Result, SizeOfString(Rec.SubSignature));
  Inc(Result, SizeOfString(Rec.Programmer));
  Inc(Result, SizeOfString(Rec.Company));
  Inc(Result, SizeOfString(Rec.CopyRight));
  Inc(Result, SizeOfString(Rec.Notice));
  Inc(Result, SizeOfString(Rec.Comment));
  Inc(Result, SizeOfString(Rec.FileName));
  Inc(Result, SizeOfString(Rec.FileTyp));
  Inc(Result, SizeOf(Rec.DateTime));
  Inc(Result, SizeOf(Rec.TimeStamp));
end;

function CreateSignVersion: TSignVersion;
begin
  InitiateSignature(Result.Signature);
  FillChar(Result.Version, sizeof(Result.Version), 0);
end;


function WriteSignVersion(Stream: TStream; SignVersion: TSignVersion): Longint;
begin
  Result := 0;
  Inc(Result, WriteSignature(Stream, SignVersion.Signature));
  Inc(Result, WriteVersion(Stream, SignVersion.Version));
end;

function ReadSignVersion(Stream: TStream): TSignVersion;
begin
  Result.Signature := ReadSignature(Stream);
  Result.Version := ReadVersion(Stream);
end;


function ReadValidSignVersionMin(Stream: TStream; SignatureData: TSignVersion): Boolean;
begin
  if Assigned(SignVersionCompUsrFunc) then
    Result := SignVersionCompUsrFunc(SignatureData, CreateSignVersion)
  else
    Result := ReadValidSignatureMin(Stream, SignatureData.Signature) and
      ReadValidVersion(Stream, SignatureData.Version)
      ;
end;

function ReadValidSignVersion(Stream: TStream; SignatureData: TSignVersion): Boolean;
begin
  if Assigned(SignVersionCompUsrFunc) then
    Result := SignVersionCompUsrFunc(SignatureData, CreateSignVersion)
  else
    Result := ReadValidSignature(Stream, SignatureData.Signature) and
      ReadValidVersion(Stream, SignatureData.Version)
      ;
end;

function EqualSignVersionMin(SignatureData1, SignatureData2: TSignVersion): Boolean;
begin
  if Assigned(SignVersionCompUsrFunc) then
    Result := SignVersionCompUsrFunc(SignatureData1, SignatureData2)
  else
    Result := EqualSignatureMin(SignatureData1.Signature, SignatureData2.Signature) and
      EqualVersion(SignatureData1.Version, SignatureData1.Version);
end;

function EqualSignVersion(SignatureData1, SignatureData2: TSignVersion): Boolean;
begin
  if Assigned(SignVersionCompUsrFunc) then
    Result := SignVersionCompUsrFunc(SignatureData1, SignatureData2)
  else
    Result := EqualSignature(SignatureData1.Signature, SignatureData2.Signature) and
      EqualVersion(SignatureData1.Version, SignatureData2.Version);
end;

function ConvertToSignVersion(Version: TVersionRec; SignatureData: TSignatureRec): TSignVersion;
begin
  Result.Signature := SignatureData;
  Result.Version := Version;
end;

function SizeOfSignVersion(Sign: TSignVersion): Longint;
begin
  Result := SizeOfVersionRec(Sign.Version) + SizeOfSignatureRec(Sign.Signature);
end;


end.

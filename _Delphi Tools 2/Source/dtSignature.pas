{
@abstract(dtSignature.pas beinhaltet  Funktionen f�r den Umgang mit Dateisignaturen)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)

Signaturen werden in Dateien verwendet, um ihren Inhalt und Aktualit�t schon vor dem
eigentlich Lesen festzustellen. Damit kann auf eine schnelle Art und Weise der Benutzer
auf Versionsunterschiede oder sogar fehlerhaften Dateiinhalten hingewiesen werden.

Signaturen werden am Anfang der Datei abgelegt, und k�nnen neben der Dateiversion,
auch Kommentare, Autorhinweise und andere Texte hinzugef�gt werden.
Mehr dazu siehe in der Unit dtSignature.

Hinweis: Es wird kein CRC Fehlererkennungsystem unterst�tzt.

}
unit dtSignature;

interface
uses Windows,Classes,SysUtils;

type
  {TVersionRec beinhaltet die Dateiversion als Integer-Wert sowie Hi und Lo Byte.}
  TVersionRec = record
    Hi, Lo: Byte; //Kann genutzt werden wie man will
    Version: Integer; // "      "       "    "   "    "
  end;


type
  {TSignatureRec enth�lt alle Textdaten die als Signatur gespeichert gelesen werden soll.
  SignatureStr und SubSignature beinhaltet einen beliebigen String, der beim Lesen der Datei
  veglichen werden wird.
  Programmer,Company,CopyRight,Notice,Comment,FileName,FileTyp sind Informationen, die dem leichteren
  Identifizieren der Datei f�r den Benutzer dienen.
  DateTime,TimeStamp beinhaltet den originalen Zeitstempel der Datei.
  }
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


type
  {TSignVersion setzt @link(TSignatureRec) und @link(TVersionRec) zusammen, um eine leichtere Handhabung zu gew�hrleisten.}
  TSignVersion = record
    Signature: TSignatureRec;
    Version: TVersionRec;
  end;

type
{TSignVersionCompUsrFunc wird von @link(ReadValidSignVersion) , @link(EqualSignVersion) und @link(EqualSignVersionMin) aufgerufen , wenn
deren Parameter SignVersionCompUsrFunc ungleich nil ist, und damit eine eigene Vergleichsfunktion f�r die Version erfolgen soll.
Die Paramater werden den Funktionen wie folgt �bergeben :
ReadValidSignVersion  : SignVersionCompUsrFunc(SignatureData,0);
EqualSignVersion      : SignVersionCompUsrFunc(SignatureData1,SignatureData2);
EqualSignVersionMin   : SignVersionCompUsrFunc(SignatureData1,SignatureData2);
}
TSignVersionCompUsrFunc = function(SignatureData1, SignatureData2: TSignVersion): Boolean;

const
  {SignVersionCompUsrFunc erm�glicht es einen benutzerdefinierte Vergleich bei einer Signatureerkennung.
  Man mu� nur eine Funktion des Typs @link(TSignVersionCompUsrFunc) an SignVersionCompUsrFunc �bergeben/zuweisen.
  Sollen die Standardvergleiche verwendet werden mu� SignVersionCompUsrFunc auf nil gesetzt werden (voreingestellt)
  }
  SignVersionCompUsrFunc: TSignVersionCompUsrFunc = nil;

{DelphiTools_SignVersion bezeichnet eine Dateisignatur, die intern verwendet wird.
 Sie kann als Beispiel einer solchen konstanten Definition verwendet werden.
 Siehe mehr dazu @link(NULL_SignVersion)}
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


{NULL_SignVersion wird als leere Signatur verwendet.

So wird eine TSignVersion-Struktur als Konstante definiert :
Beispiel 1 :
SignVersion           : link(TSignVersion) = (
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
Beispiel 2 :
Signature : @link(TSignatureRec) = (
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
Beispiel 3 :
Version   : @link(TVersionRec) =  (
                                           Hi:0
                                           Lo:0;
                                           Version:0
                                          );

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

const
  {VersionIndentLen bezeichnet die L�nge des Versionssignaturstrings @link(VersionIndent)}
  VersionIndentLen = 5;
  {SignatureIndentLen bezeichnet die L�nge des Signaturstrings @link(SignatureIndent)}
  SignatureIndentLen = 5;
  {VersionIndent wird verwendet, um intern bestimmen zu k�nnen, um was es sich bei der Datei handelt.}
  VersionIndent: array[0..VersionIndentLen - 1] of char = (#2, #4, #2, #6, #8);

//      SignatureIndent = #54#34#23#65;
  {SignatureIndent wird verwendet, um intern bestimmen zu k�nnen, um was es sich bei der Datei handelt.}
  SignatureIndent: array[0..SignatureIndentLen - 1] of char = (#2, #4, #2, #6, #8);


{WriteVersion schreibt den Record Version : @link(TVersionRec) als Bin�rtdaten in den Stream.
Um mehr �ber die verwendeten Datencontainer zu erfahren, gehen Sie zu @link(NULL_SignVersion)}
function WriteVersion(Stream: TStream; Version: TVersionRec): Longint;

{ReadVersion liest den Record @link(TVersionRec) als Bin�rtdaten aus dem Stream
Um mehr �ber die verwendeten Datencontainer zu erfahren, gehen Sie zu @link(NULL_SignVersion)}
function ReadVersion(Stream: TStream): TVersionRec;

{Liest den Record Version : @link(TVersionRec) als Bin�rtdaten aus den Stream ,
vergleicht den geladenen Record mit "Version" und gibt bei Gleichheit TRUE , sonst FALSE
zur�ck.
Siehe auch @link(ReadVersion) ; @link(EqualVersion)}
function ReadValidVersion(Stream: TStream; Version: TVersionRec): Boolean;

{Vergleicht zwei @link(TVersionRec)-Datentypen miteinander in jeder Beziehung.
Um mehr �ber die verwendeten Datencontainer zu erfahren, gehen Sie zu @link(NULL_SignVersion)}
function EqualVersion(Version1, Version2: TVersionRec): Boolean;

{SizeOfVersionRec liefert die Gr��e von Rec zur�ck. 
Um mehr �ber die verwendeten Datencontainer zu erfahren, gehen Sie zu @link(NULL_SignVersion)}
function SizeOfVersionRec(Rec: TVersionRec): Longint;



{InitiateSignature initialisiert einen Record @link(TSignatureRec)}
procedure InitiateSignature(var SignatureData: TSignatureRec);

{WriteSignature schreibt TSignatureRec in einen Stream.
Der R�ckgabewert ist die Anzahl der geschriebenen Bytes.
Siehe dazu @link(SizeOfSignatureRec)}
function WriteSignature(Stream: TStream; SignatureData: TSignatureRec): Longint;

{ReadSignature liest TSignatureRec aus einem Stream und gibt ihn als R�ckgabewert zur�ck.}
function ReadSignature(Stream: TStream): TSignatureRec;

{ReadValidSignature liest den TSignatureRec -Record als Bin�rtdaten aus dem Stream und vergleicht den geladenen Record
mit SignatureData und gibt bei Gleichheit TRUE , sonst FALSE zur�ck}
function ReadValidSignature(Stream: TStream; SignatureData: TSignatureRec): Boolean;

{ReadValidSignatureMin liest den TSignatureRec -Record als Bin�rtdaten aus dem Stream und vergleicht den geladenen Record
mit SignatureData und gibt bei Gleichheit TRUE , sonst FALSE zur�ck
Im Gegensatz zu @link(ReadValidSignature) werden nur folgende Daten verglichen :
SignatureStr,SubSignature,FileName,FileTyp
}
function ReadValidSignatureMin(Stream: TStream; SignatureData: TSignatureRec): Boolean;

{EqualSignature vergleicht zwei TSignatureRec-Datentypen miteinander in jeder Beziehung.
Siehe auch @link(EqualSignatureMin)}
function EqualSignature(SignatureData1, SignatureData2: TSignatureRec): Boolean;

{EqualSignatureMin vergleicht zwei TSignatureRec-Datentypen miteinander
Folgende Daten werden verglichen : SignatureStr,SubSignature,FileName,FileTyp.
Siehe auch @link(EqualSignature)}
function EqualSignatureMin(SignatureData1, SignatureData2: TSignatureRec): Boolean;

{SizeOfSignatureRec liefert die Anzahl der Bytes in TSignatureRec zur�ck.}
function SizeOfSignatureRec(Rec: TSignatureRec): Longint;

{CreateSignVersion erstellt eine leere TSignVersion.}
function CreateSignVersion: TSignVersion;

{WriteSignVersion schreibt TSignVersion in einen Stream und liefert die Anzahl der geschriebenen Bytes zur�ck.}
function WriteSignVersion(Stream: TStream; SignVersion: TSignVersion): Longint;

{ReadSignVersion liest TSignVersion aus einem Stream und gibt es zur�ck.}
function ReadSignVersion(Stream: TStream): TSignVersion;

{ReadValidSignVersion liest den TSignVersion-Record als Bin�rtdaten aus den Stream , vergleicht den geladenen Record mit SignatureData und
gibt bei Gleichheit TRUE , sonst FALSE zur�ck.
Siehe auch @link(ReadValidSignVersionMin) und @link(TSignVersionCompUsrFunc)}
function ReadValidSignVersion(Stream: TStream; SignatureData: TSignVersion): Boolean;

{ReadValidSignVersionMin liest den TSignVersion-Record als Bin�rtdaten aus den Stream , vergleicht den geladenen Record mit SignatureData und
gibt bei Gleichheit TRUE , sonst FALSE zur�ck.
Folgende Daten werden verglichen : SignatureStr,SubSignature,FileName,FileTyp , Version
Siehe auch @link(ReadValidSignVersionMin) und @link(TSignVersionCompUsrFunc)}
function ReadValidSignVersionMin(Stream: TStream; SignatureData: TSignVersion): Boolean;

{EqualSignVersion vergleicht zwei TSignVersion-Datentypen in jeder Beziehung miteinander.
Siehe auch @link(ReadValidSignVersionMin) und @link(TSignVersionCompUsrFunc)}
function EqualSignVersion(SignatureData1, SignatureData2: TSignVersion): Boolean;

{EqualSignVersionMin vergleicht zwei TSignVersion-Datentypen in jeder Beziehung miteinander.
Folgende Daten werden verglichen : SignatureStr,SubSignature,FileName,FileTyp , Version
Siehe auch @link(ReadValidSignVersionMin) und @link(TSignVersionCompUsrFunc)}
function EqualSignVersionMin(SignatureData1, SignatureData2: TSignVersion): Boolean;

{ConvertToSignVersion kopiert TVersionRec und TSignatureRec zusammen in ein TSignVersion-Record}
function ConvertToSignVersion(Version: TVersionRec; SignatureData: TSignatureRec): TSignVersion;

{SizeOfSignVersion ermittelt die Anzahl der verwendeten Bytes in Sign.}
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

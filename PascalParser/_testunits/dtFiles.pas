{
@abstract(dtFiles.pas beinhaltet Funktionen f�r dem Umgang mit Dateien und Datentr�gern)
@author(author <removed>)
@created(25 Dec 2002)
@lastmod(26 Dec 2002)
}

unit dtFiles;

interface
uses windows,classes,forms,sysutils,ShellApi,ShlObj;

type TDriveType = (DRIVE_UNKNOWN, DRIVE_NO_ROOT_DIR,DRIVE_REMOVABLE, DRIVE_FIXED,DRIVE_REMOTE, DRIVE_CDROM, DRIVE_RAMDISK);
     TDriveRoot = Char;
     TDriveTypes = set of TDriveType;


  TFileType = (FILE_TYPE_UNKNOWN, FILE_TYPE_DISK,
  FILE_TYPE_CHAR, FILE_TYPE_PIPE, FILE_TYPE_ERROR, FILE_TYPE_REMOTE);

  TFileAttribute = (
    FILE_ATTRIBUTE_DIRECTORY,
    FILE_ATTRIBUTE_READONLY,
    FILE_ATTRIBUTE_HIDDEN,
    FILE_ATTRIBUTE_SYSTEM,
    FILE_ATTRIBUTE_ARCHIVE,
    FILE_ATTRIBUTE_NORMAL,
    FILE_ATTRIBUTE_TEMPORARY,
    FILE_ATTRIBUTE_COMPRESSED,
    FILE_ATTRIBUTE_OFFLINE,
    FILE_ATTRIBUTE_ERROR);
  TFileAttributes = set of TFileAttribute;

  TFileInfo = record
    CreateTime, AcessTime, WriteTime: TSystemTime;
    OfStruct: TOFStruct;
    FileSize: Longint;
    FileType: TFileType;
    FileAttribute: TFileAttributes;
    lpFileInformation: TByHandleFileInformation;
  end;
  TVolumeRecord = record
    VolumeName: string; // address of name of the volume
    VolumeSerialNumber: DWORD; // address of volume serial number
    MaximumComponentLength: DWORD; // address of system's maximum filename length
    FileSystemFlags: DWORD; // address of file system flags
    FileSystemNameBuffer: string; // address of name of file system
  end;
  TFreeSpaceRec = record
    SectorsPerCluster, // address of sectors per cluster
      BytesPerSector, // address of bytes per sector
      NumberOfFreeClusters, // address of number of free clusters
      TotalNumberOfClusters: DWORD; // address of total number of clusters
  end;



 TSpecDirectory = (
  SD_DESKTOP,   //Windows Desktop�virtual folder at the root of the namespace.
  SD_INTERNET,  //Virtual folder representing the Internet.
  SD_PROGRAMS,  //File system directory that contains the user's program groups (which are also file system directories).
  SD_CONTROLS, //Virtual folder containing icons for the Control Panel applications.
  SD_PRINTERS,  //Virtual folder containing installed printers.
  SD_PERSONAL, //File system directory that serves as a common repository for documents.
  SD_FAVORITES,//File system directory that serves as a common repository for the user's favorite items.
  SD_STARTUP, //File system directory that corresponds to the user's Startup program group. The system starts these programs whenever any user logs onto Windows NT or starts Windows 95.
  SD_RECENT,  //File system directory that contains the user's most recently used documents.
  SD_SENDTO,  //File system directory that contains Send To menu items.
  SD_BITBUCKET, // File system directory containing file objects in the user's Recycle Bin. The location of this directory is not in the registry; it is marked with the hidden and system attributes to prevent the user from moving or deleting it.
  SD_STARTMENU, //File system directory containing Start menu items.
  SD_None1,  //findet keine Verwendung
  SD_None2,  //findet keine Verwendung
  SD_None3,  //findet keine Verwendung
  SD_None4,  //findet keine Verwendung
  SD_DESKTOPDIRECTORY, //File system directory used to physically store file objects on the desktop (not to be confused with the desktop folder itself).
  SD_DRIVES, //My Computer�virtual folder containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives.
  SD_NETWORK, //Network Neighborhood Folder�virtual folder representing the top level of the network hierarchy.
  SD_NETHOOD, //File system directory containing objects that appear in the network neighborhood.
  SD_FONTS,  //Virtual folder containing fonts.
  SD_TEMPLATES, //File system directory that serves as a common repository for document templates.
  SD_COMMON_STARTMENU, //File system directory that contains the programs and folders that appear on the Start menu for all users.
  SD_COMMON_PROGRAMS,//File system directory that contains the directories for the common program groups that appear on the Start menu for all users.
  SD_COMMON_STARTUP, //File system directory that contains the programs that appear in the Startup folder for all users.
  SD_COMMON_DESKTOPDIRECTORY,//File system directory that contains files and folders that appear on the desktop for all users.
  SD_APPDATA, //File system directory that serves as a common repository for application-specific data.
  SD_PRINTHOOD,//File system directory that serves as a common repository for printer links.
  SD_None5,  //findet keine Verwendung
  SD_ALTSTARTUP, //  File system directory that corresponds to the user's nonlocalized Startup program group.
  SD_COMMON_ALTSTARTUP,// File system directory that corresponds to the nonlocalized Startup program group for all users.
  SD_COMMON_FAVORITES,//File system directory that serves as a common repository for all users' favorite items.
  SD_INTERNET_CACHE,//File system directory that serves as a common repository for temporary Internet files.
  SD_COOKIES,//File system directory that serves as a common repository for Internet cookies.
  SD_HISTORY//File system directory that serves as a common repository for Internet history items.
);

  TTypeDirectory = (DIR_WINDOWS, DIR_SYSTEM, DIR_CURRENT, DIR_TEMP);

var
  MoreDelFlags: Integer = 0;
//CreateNullFile - R�ckgabewerte
const ERR_NoError = 0;
      ERR_FileExists = -1;


type
{R�ckgabewert mu� die Anzahl der geschriebenen Bytes sein}
    TWriteProc = function(Stream: TStream; Data: Pointer): Longint of object;
// _TWriteProc = function (Stream : TStream;Data : Pointer) : Longint;

const InformationHeader = #22#34#34'Info';
      InfoHeaderLen = 7;

const InvalidChars : array[1..9] of char =
     ('\','/',':','*','?','"','<','>','|');
     InvalidCharsSet : set of char =
      ['\','/',':','*','?','"','<','>','|'];   //if key in InvalidCharsSet then key := #0;





{GetSpecVolList listet alle angegebenen und verf�gbaren Laufwerke auf.
Es wird nur der Laufwerksbuchstabe im String gespeichert.
Siehe GetDrivesEx}
function GetSpecVolList(DriveTypes: TDriveTypes): TStringList;


{GetCompletePath liefert aus einem Dateipfad das Verzeichnis zur�ck d.h. (mit abschliessenden '\')}
function GetCompletePath(const Path: string): string;

{GetDriveType stellt bei einem Laufwerk den Typ fest}
function GetDriveType(Drive: TDriveRoot): TDriveType;

function GetDriveTypeByPath(DrivePath: string): TDriveType;

{GetDrivesEx z�hlt alle Laufwerke (deren Typ zugelassen sind) auf
siehe TDriveType
Wenn Drive = [] ist , sind alle Type bis auf DRIVE_NO_ROOT_DIR zugelassen
Der Wert DRIVE_NO_ROOT_DIR bezeichnet ein nicht-existierende Laufwerk aus.
Anstelle von Drive = [] kann GetDrives verwendet werden -> Ist dasselbe
Die StringListe darf nicht initialisiert werden!
Die Eintr�ge besitzen den Laufwerksbuchstaben mit :\ z.B. C:\
Vorsicht : Um den Buchstaben zu bekommen lautet die Anweisung:
           <TStringList>.Strings[<Nummer>][1] // nicht 0 sondern 1
Die Liste m�ssen Sie aus dem Speicher entfernen!}
function GetDrivesEx(DriveCase: TDriveTypes): TStringList;

{GetMediaList ist @link(GetDrivesEx) vorzuziehen , wenn man alle Laufwerke aufgez�hlt haben m�chte.
Hier wird das Laufwerk nicht auf Funktionst�chtigkeit (CD enthalten od. nicht/Zugriff m�glich)
gepr�ft}
function GetMediaList: TStringList;

{Siehe @link(GetDrivesEx)}
function GetDrives: TStringList;


{Filesplitext splittet aus einem Windows9x Dateinamen das Laufwerk lw
,das Verzeichnis dir ,den DateiName name und die Erweiterung ext
Lange Datei- und Verzeichnisnamen werden unterst�tzt.
Version 2.1}
procedure Filesplitext(filename: string; var lw, dir, name, ext: string);

{Filesplit wie FileSplitExt , nur ohne Laufwerk. Das Laufwerk ist in dir enthalten}
procedure Filesplit(filename: string; var dir, name, ext: string);

{GetFileNameFromPath gibt den Dateinamen + Erweiterung aus einer kompletten Pfadangabe zur�ck
Ohne Erweiterung siehe ExtractFileNameIndent}
function GetFileNameFromPath(Path: string): string;

{GetDirFromPath gibt das Verzeichnis eines Pfades zur�ck (mit Backslash am Ende)}
function GetDirFromPath(Path: string): string;

{GetFileExtension ermittelt die Dateinamenerweiterung ohne "."}
function GetFileExtension(Path: string): string;




{GetFileDateTime_hfile gibt die Erstellungs,letzte Zugriffs- und Ver�nderungszeit + datum zur�ck
Man braucht ein Dateihandle -> aber schneller , da keine datei�ffnungsroutine
Tortzdem mu� die Datei mit OpenFile ge�ffnet werden
Aber man kann mehrer Dinge damit anstellen}
function GetFileDateTime_hfile(fileHandle: HFILE; var CreateTime, AcessTime, WriteTime: TSystemTime): Boolean;

{GetFileDateTime wie GetFileDateTime_hfile, allerdings kann der Dateiname direkt angegeben werden}
function GetFileDateTime(const FileName: string; var CreateTime, AcessTime, WriteTime: TSystemTime): Boolean;

function GetCreateFileDateTime(const FileName: string): TDateTime;

{GetFileSize gibt die Gr��e der Datei in Bytes zur�ck}
function GetFileSize(const FileName: string): longint;

function GetFileSize_hfile(fileHandle: HFILE): Longint;

{GetFileInformationByHandle gibt noch mehr Informationen �ber die Datei zur�ck
Im Record sind auch die oberen Funktionen enthalten.}
function GetFileInformationByHandle(const FileName: string; var lpFileInformation: TByHandleFileInformation): Boolean;
function GetFileInformationByHandle_hfile(fileHandle: HFILE; var lpFileInformation: TByHandleFileInformation): Boolean;

{GetFileData Packt alle oberen Funktionen in den Record @link(TFileInfo)}
function GetFileData(const FileName: string; var FileInfo: TFileInfo): Boolean;

{ GetVolumeInformation gibt Volumeninformation , d.h. FAT , Dateinamenbegrenzung}
function GetVolumeInformation(Drive: Char; var VolumeRecord: TVolumeRecord): Boolean;

function GetVolumeName(Drive: Char): string;

{GetFileType_Hfile gibt DateiTyp zur�ck :

FILE_TYPE_UNKNOWN	The type of the specified file is unknown.
FILE_TYPE_DISK	        The specified file is a disk file.
FILE_TYPE_CHAR	        The specified file is a character file, typically an LPT device or a console.
FILE_TYPE_PIPE	        The specified file is either a named or anonymous pipe.}
function GetFileType_Hfile(hFile: HFILE): TFileType;

function GetFileType(const FileName: string): TFileType;

function GetShortFilename(const FileName: string): string;


{GetFileAttributes liest den Typ der Datei Filename aus.
Es k�nnen Kombinationen aus TFileAttribute entstehen
die dann aus der Menge gelesen werden k�nnen
GetFileAttributes wird in GetFileData unterst�tzt}
function GetFileAttributes(const FileName: string): TFileAttributes;

function TFileAttributesToWord(FileAttributes: TFileAttributes): Word;

function WordToTFileAttributes(FileAttributes: Word): TFileAttributes;

{SetFileAttributes setzt Dateiattribute aus TFileAttributes}
function SetFileAttributes(const FileName: string; Attr: TFileAttributes): Boolean;

{GetDiskFreeSpace gibt Festplattenspeicherdaten zur�ck}
function GetDiskFreeSpace(drive: char; FreeSpaceRec: TFreeSpaceRec): Boolean;

{FileExists gibt True zur�ck , wenn die Datei oder das Verzeichnis (auch Laufwerk)
existiert}
function FileExists(const Name: string): Boolean;

function GetCurrentDirectory: string;

function SetCurrentDirectory(Name: string): Integer;

{GetFullFileName erweitert einen kurzen Dateiname zu einem langen Dateinamen}
function GetFullFileName(const ShortName: string): string;

{GetPathNames liefert alle Verzeichnisname in einer Stringliste zur�ck
Der erste Eintrag ist immer , wenn vorhanden in PathName ,
das Laufwerk mit einem Doppelpunkt
Die folgenden Verzeichnisnamen sind rein und besitzen kein Backslash
Der R�ckgabewert ist die Anzahl der Stringlisteneintr�ge
Hinweis : Paths darf nicht mit Create initalisiert werden
          PathName kann ein syntaktisch korrekter Dateipfad sein :
          C:\HALLO\OHO\guten.tag
                       ^-> Der Dateiname wird ignoriert
          "C:" + "HALLO" + "OHO"
Achtung : Es d�rfen keine doppelte Backslash , wie in C sein}
function GetPathNames(const PathName: string; var Paths: TStrings): Integer;

{IsFileInDir gibt die Anzahl der Dateien mit dem Namen FileName im
Verzeichnis PathName zur�ck
Platzhalter sind erlaubt, aber nicht mehrer Angaben.
z.B. Hall* ,Hall? oder *.* , aber nicht Hallo;Oho}
function IsFileInDir(const FileName, PathName: string): Integer;

{IsDirInDir wie @link(IsFileInDir) , nur eben mit Verzeichnissen anstatt Dateien}
function IsDirInDir(const DirName, PathName: string): Integer;


//  Names = Array of String;
{DeleteFile l�scht Dateien in den Papierkorb , wenn AllowUndo = TRUE
Es k�nnen mehrere Dateien in Filename angegeben werden : ['..','..']
Form  : DialogElternfenster
Wenn Form = nil dann wird der Desktop benutzt}
function DeleteFile(const FileName: array of string; Form: TCustomForm; AllowUndo: Boolean): Longint;

{DeleteFileStr wie @link(DeleteFile) nur mit TStrings f�r TOpenDialog.Files-�bergabe}
function DeleteFileStr(const FileName: TStrings; Form: TCustomForm; AllowUndo: Boolean): Longint;

{
GetSpecDirectory
Hier kann mehrere FunktionsParameter an TSHFileOpStruct.fFlags
�bergeben werden : siehe TSHFileOpStruct
Der R�ckgabewert entspricht des der SHFileOperation-Fkt.
Hinweis : FOF_ALLOWUNDO darf nicht angegeben werden , weil sie schon definiert wurde

FOF_ALLOWUNDO	          Preserves undo information, if possible.
                          Nicht benutzen!
FOF_CONFIRMMOUSE	  Not implemented.
FOF_FILESONLY	          Performs the operation only on files if a wildcard filename (*.*) is specified.
FOF_MULTIDESTFILES	  Indicates that the pTo member specifies multiple destination files (one for each source file) rather than one directory where all source files are to be deposited.
FOF_NOCONFIRMATION	  Responds with "yes to all" for any dialog box that is displayed.
FOF_NOCONFIRMMKDIR	  Does not confirm the creation of a new directory if the operation requires one to be created.
FOF_RENAMEONCOLLISION	  Gives the file being operated on a new name (such as "Copy #1 of...") in a move, copy, or rename operation if a file of the target name already exists.
FOF_SILENT	          Does not display a progress dialog box.
FOF_SIMPLEPROGRESS	  Displays a progress dialog box, but does not show the filenames.
FOF_WANTMAPPINGHANDLE	  Fills in the hNameMappings member. The handle must be freed by using the SHFreeNameMappings function


Erweiterte Version zu TTypeDirectory mit mehr Verzeichnisr�ckgaben}
function GetSpecDirectory(Typ: TSpecDirectory): string; overload;

//Verzeichnistyp f�r GetSpecDirectory
{GetSpecDirectory liefert ein konstantes Systemverzeichnis zur�ck}
function GetSpecDirectory(Typ: TTypeDirectory): string; overload;

{GetSpecDirectory erzeugt eine Tempor�re Datei in PathName mit einem Prefix (Prefixstring)
GetTempFileEx is �quivalent zu Win32-Funktion : GetTempFileName
PathName : Das Beherbergungsverzeichnis der neuen Datei - kann mit GetSpecDirectory(DIR_TEMP)
           herausgefunden werden
PrefixString : die ersten drei Zeichen werden zu den ersten drei Zeichen im Dateinamen
Unique       : eine BezeichnerZiffer die an den Dateinamen hinzugef�gt wird
             Bsp :  path\preuuuu.TMP
Die Datei wird zwar erstellt ,aber nicht mehr gel�scht}
function GetTempFileEx(const PathName, PrefixString: string;Unique: Integer): string;

{ GetTempFile vereinfachte Funktion von GetTempFileEx
Unique = 0 , d.h. Windows bestimmt selbst eine Zahl}
function GetTempFile(const PrefixString: string): string;

{ExtractFileNameIndent gibt den Dateiname (ohne Erweiterung) zur�ck
Mit Erweiterung siehe GetFileNameFromPath}
function ExtractFileNameIndent(const FileName: string): string;



{ AddDirToFile ist OverWriteExisting = TRUE wird der Verzeichnisstring von FileName
durch Directory �berschrieben
Wenn OverWriteExisting = FALSE ist , wird Directory nicht �ber den
existierenen Verzeichnisstring von FileName geschrieben.

Dies geschieht dann nur wenn FileName kein Verzeichnis beinhaltet
VerifyDirectory (TRUE) pr�ft das Verzeichnis von Filename und
�berschreibt es mit Directory auf jeden Fall wenn es nicht existiert
Directory wird auf keinen Fall gepr�ft    }
function AddDirToFile(const FileName: string; Directory: string; OverWriteExisting: Boolean; VerifyDirectory: Boolean = TRUE): string;

{AddExtToFile wie AddDirToFile , nur wird die Erweiterung ge�ndert anstatt das Verzeichnis}
function AddExtToFile(const FileName: string; Extension: string; OverWriteExisting: Boolean): string;

{ReplaceInValidFile gibt FileName zur�ck wenn dieser existiert sonst NewFileName}
function ReplaceInValidFile(const FileName, NewFileName: string): string;

{CreateNullFile erstellt eine leere Datei mit dem Namen FileName
wenn OwerwriteExisting = FALSE und die Datei nicht schon existiert
Ist OwerwriteExisting = TRUE und die Datei existiert wird sie �berschrieben
Der R�ckgabewert ist oben definiert
Weitere Dateierstellungsfehler werden per Exception bekanntgegeben}
function CreateNullFile(const FileName: string; OwerwriteExisting: Boolean = FALSE): Integer;

{ GetLogicalDrives ermittelt alle verf�gbaren Laufwerke
und gibt die Laufwerksbuchstaben in einer Stringliste zur�ck}
function GetLogicalDrives: TStringList;

{ExtractShortPathName ermittelt den DOS-Pfadname aus einem langem Verzeichnissname}
function ExtractShortPathName(const FileName: string): string;

{ExtractLongPathName ermittelt aus einem DOS-Pfadname einen langem Verzeichnissname}
function ExtractLongPathName(const PathName: string): string;


{AddInformationToFile schreibt an das Ende einer Datei beliebiege Informationen
dabei kann der vorherige Inhalt in der Gr��e bei jedem lesen von Informationen eine andere
Gr��e haben
die Inhalte werden �ber WriteProc geschrieben
es ist wichtig , da� die Anzahl der geschriebenen Bytes korrekt �bergeben wird
da sonst die Daten nicht wiederhergestellt werden k�nnen.
Die Anzahl der geschriebenen Bytes ist : 2*InfoHeaderLen+SizeOf(Longint) + <geschriebene Bytes in WriteProc>
Data wird an WriteProc(Data) �bergeben
Der R�ckgabewert ist die Anzahl der geschriebenen Bytes

Warnung : -Manche Dateien werden von Anfang bis zum Ende gelesen dabei k�nnen die hinzugef�gten Daten
           unerw�nschte Nebeneffekte erbringen
          -Manche Programme lesen aus den Dateien nur die erforderlichen Daten und erzeugen dann eine neue
           , dabei verliert man den Informationsheader.
}
function AddInformationToFile(const FileName: string; WriteProc: TWriteProc; Data: Pointer): Longint;

//function _AddInformationToFile(const FileName : String; WriteProc : TWriteProc;Data : Pointer) : Longint;

{
GetInformationFromFile lie�t Daten, die mit AddInformationToFile geschrieben wurden.
Der R�ckgabewert ist die Anzahl der gelesenen Bytes bei Erfolg , oder -1 wenn der
Header besch�digt wurde oder keine Informationen existieren

Warnung : -Manche Dateien werden von Anfang bis zum Ende gelesen dabei k�nnen die hinzugef�gten Daten
           unerw�nschte Nebeneffekte erbringen
          -Manche Programme lesen aus den Dateien nur die erforderlichen Daten und erzeugen dann eine neue
           , dabei verliert man den Informationsheader.                                          }
function GetInformationFromFile(const FileName: string; ReadProc: TWriteProc; Data: Pointer): Longint;

{TestOpenSharedFile testet , ob einen Datei bereits ge�ffnet wurde und liefert
in diesem Fall TRUE zur�ck}
function TestOpenSharedFile(const FileName: string): Boolean;

function IsFileNameValidA(FileName: string): Boolean; //*** 1.306

{IsFileNameValid pr�ft , ob ein Dateiname ung�ltige Zeichen enth�lt (FALSE)}
function IsFileNameValid(FileName: string): Boolean;


{GetApplicationPath liefert das Verzeichnis (mit "\" am Ende) der Anwendung zur�ck}
function GetApplicationPath: string;

{GetDirName ermittelt aus einem Pfad , den n-ten (Level) Pfadname
0 bedeutet entweder der Computername (UNC-Pfad) oder der Laufwerksbuchstabe
Jeder Wert gr��er 0 ist ein Verzeichnissname
der Wert -1 lieft im String die gesamte Anzahl von Verzeichnisnamen ( +1) als String zur�ck}
function GetDirName(Level : Integer; Path : String) : String;


//1.305
{MakeRealPathName erstellt alle noch nicht vorhanden Unterverzeichniss}
function MakeRealPathName(Path : String) : String;

implementation
uses dtSystem,dtStrings,dtDialogs,dtMath,dtNetwork,dtStringsRes;





function GetSpecVolList(DriveTypes: TDriveTypes): TStringList;
var i: Integer;
begin
  //for i := 0 to GetDrives
  raise Exception.Create('Benutzen Sie anstelle von GetSpecVolList GetDrivesEx');
end;


function GetCompletePath(const Path: string): string;
var lw, dir, name, ext: string;
begin
  Filesplitext(Path, lw, dir, name, ext);
  Dir := Lw + dir;
  if Dir[Length(Dir)] <> '\' then
    Insert('\', Dir, Length(Dir) + 1);
  Result := Dir;
end;

function GetDriveType(Drive: TDriveRoot): TDriveType;
var Root: string;
begin
  if not (UpCase(Drive) in ['A'..'Z']) then
    raise Exception.Create('Falsches Laufwerksbezeichner!');
  Root := UpCase(Drive) + ':\';
  case Windows.GetDriveType(PCHAR(Root)) of
    Windows.DRIVE_NO_ROOT_DIR: Result := DRIVE_NO_ROOT_DIR;
    Windows.DRIVE_REMOVABLE: Result := DRIVE_REMOVABLE;
    Windows.DRIVE_FIXED: Result := DRIVE_FIXED;
    Windows.DRIVE_REMOTE: Result := DRIVE_REMOTE;
    Windows.DRIVE_CDROM: Result := DRIVE_CDROM;
    Windows.DRIVE_RAMDISK: Result := DRIVE_RAMDISK;
  else
    Result := DRIVE_UNKNOWN;
  end;
end;

function GetDriveTypeByPath(DrivePath: string): TDriveType;
var lw, dir, name, ext: string;
begin
  Filesplitext(DrivePath, lw, dir, name, ext);
  if lw <> '' then
    Result := GetDriveType(lw[1])
  else
    Result := DRIVE_NO_ROOT_DIR;
end;

function GetDrivesEx(DriveCase: TDriveTypes): TStringList;
var i: Integer;
  List: TStringList;
  dt: TDriveType;
begin
  List := TStringList.Create;
  for i := 1 to 26 do
  begin
    dt := GetDriveType(char(64 + i));
    if (dt <> DRIVE_NO_ROOT_DIR)
      and ((dt in DriveCase) or (DriveCase = [])) then
    begin
      List.Add(UpCase(char(64 + i)) + ':\');
    end;
  end;
  Result := LIst;
end;

function GetMediaList: TStringList;
var Medias: array[0..CharBufferLen] of char;
  i, len: Integer;
begin
  len := GetLogicalDriveStrings(CharBufferLen - 1, Medias);
  if len = 0 then
    raise Exception.Create('GetLogicalDriveStrings meldet : Zu kleinen Laufwerkszeichenbuffer.');
  Result := TStringList.Create;
  for i := 0 to len do
  begin
    if UpCase(Medias[i]) in ['A'..'Z'] then
      Result.Add(Medias[i]);
  end;
end;

function GetDrives: TStringList;
begin
  Result := GetDrivesEx([]);
end;

procedure Filesplitext(filename: string; var lw, dir, name, ext: string);
var s, Files, Files2: string; i, xlw, x: integer;
begin
  s := filename;
  dir := dtSystem.NullStr;
  LW := dtSystem.NullStr;
  ext := dtSystem.NullStr;
  Files := s;
  for i := length(files) downto 1 do
    if Files[i] = '\' then
    begin
      Files[i] := #1;
      break;
    end;
  xlw := pos(':', Files);
  if xlw > 0 then
  begin
    LW := Copy(Files, 1, xlw);
    Delete(Files, 1, xlw);
  end;
  x := pos(#1, Files);
  if X > 0 then
    Files[x] := '\';
  if x > 0 then
  begin
    dir := Copy(Files, xlw, x - xlw);
    if Length(Dir) > 1 then
      if Dir[1] <> '\' then
        Insert('\', dir, 1);
    if Length(dir) > 0 then
      if Dir[Length(Dir)] <> '\' then
        Insert('\', dir, Length(dir) + 1);
  end;
  Delete(Files, 1, x);
  Files2 := GetTransString(Files);
  x := Pos('.', Files2);
  if x > 0 then
  begin
    Ext := //Copy(Files,x+1,Length(Files));
      GetTransString(Copy(Files2, 1, x - 1));
    Delete(Files2, 1, x);
    Files := GetTransString(Files2);
  end;
  name := Files;
  if Ext <> NullStr then
    ext := '.' + ext;
  if Length(Dir) = 0 then
    Insert('\', dir, Length(Dir) + 1);
end;


procedure Filesplit(filename: string; var dir, name, ext: string);
var lw: string;
begin
  Filesplitext(filename, lw, dir, name, ext);
  dir := lw + Dir;
  ext := ext;
end;

function GetFileNameFromPath(Path: string): string;
var dir, name, ext: string;
begin
  Filesplit(Path, dir, name, ext);
  Result := Name + Ext;
end;


function GetDirFromPath(Path: string): string;
var dir, name, ext: string;
begin
  Filesplit(Path, dir, name, ext);
  if Dir = '\' then
    Result := ''
  else
    Result := Dir;
end;

function GetFileExtension(Path: string): string;
var dir, name, ext: string;
begin
  Filesplit(Path, dir, name, ext);
  Result := Copy(Ext, 2, Length(Ext));
end;

function GetFileDateTime_hfile(fileHandle: HFILE; var CreateTime, AcessTime, WriteTime: TSystemTime): Boolean;
var t1, t2, t3: TFileTime;
//    t : TOFStruct;
begin
  result := FALSE;
  if FileHandle <= 0 then exit;
  GetFileTime(fileHandle,
    @t1, // address of creation time
    @t2, // address of last access time
    @t3 // address of last write time
    );
  FileTimeToSystemTime(t1, CreateTime);
  FileTimeToSystemTime(t2, AcessTime);
  FileTimeToSystemTime(t3, WriteTime);
  Result := TRUE;
end;

function GetFileDateTime(const FileName: string; var CreateTime, AcessTime, WriteTime: TSystemTime): Boolean;
var
  f: HFILE;
  t: TOFStruct;
begin
  if FileExists(FileName) then
  begin
    f := OpenFile(PCHAR(FileName), t, OF_READ);
    if f <> HFILE_ERROR then
    begin
      Result := GetFileDateTime_hfile(f, CreateTime, AcessTime, WriteTime);
      CloseHandle(f);
      exit;
    end;
  end;
  Result := FALSE;
end;


function GetCreateFileDateTime(const FileName: string): TDateTime;
var CreateTime, AcessTime, WriteTime: TSystemTime;
begin
  if GetFileDateTime(FileName, CreateTime, AcessTime, WriteTime) then
  begin
    Result := SystemTimeToDateTime(CreateTime);
  end;
end;


function GetFileSize(const FileName: string): longint;
var f: HFILE;
  t: TOFStruct;
begin
  if FileExists(FileName) then
  begin
    f := OpenFile(PCHAR(FileName), t, OF_READ);
    if f <> HFILE_ERROR then
    begin
      Result := GetFileSize_hfile(f);
      CloseHandle(f);
      exit;
    end;
  end;
  Result := -1;
end;

function GetFileSize_hfile(fileHandle: HFILE): Longint;
begin
  result := -1;
  if FileHandle <= 0 then exit;
  Result := Windows.GetFileSize(FileHandle, nil);
end;

function GetFileInformationByHandle(const FileName: string; var lpFileInformation: TByHandleFileInformation): Boolean;
var f: HFILE;
  t: TOFStruct;
begin
  Result := FALSE;
  if FileExists(FileName) then
  begin
    f := OpenFile(PCHAR(FileName), t, OF_READ);
    if f <> HFILE_ERROR then
    begin
      Result :=
        GetFileInformationByHandle_hfile(f, lpFileInformation);
      CloseHandle(f);
      exit;
    end;
  end;
end;

function GetFileInformationByHandle_hfile(fileHandle: HFILE; var lpFileInformation: TByHandleFileInformation): Boolean;
begin
  result := FALSE;
  if FileHandle <= 0 then exit;
  Result := Windows.GetFileInformationByHandle(FileHandle, lpFileInformation);
end;

function GetFileData(const FileName: string; var FileInfo: TFileInfo): Boolean;
var f: HFILE;
  b, b2: Boolean;
begin
  Result := FALSE;
  if FileExists(FileName) then
  begin
    f := OpenFile(PCHAR(FileName), FileInfo.OfStruct, OF_READ);
    if f <> HFILE_ERROR then
    begin
      FileInfo.FileSize := GetFileSize_hfile(f);
      b := GetFileDateTime_hfile(f, FileInfo.CreateTime, FileInfo.AcessTime, FileInfo.WriteTime);
      b2 := GetFileInformationByHandle_hfile(f, FileInfo.lpFileInformation);
      FileInfo.FileType := GetFileType_Hfile(f);
      CloseHandle(f);
      FileInfo.FileAttribute := GetFileAttributes(FileName);
      if (FileInfo.FileSize <= -1) or (not b) or (not b2) or
        (FileInfo.FileType = FILE_TYPE_ERROR) or
        (FileInfo.FileAttribute = [FILE_ATTRIBUTE_ERROR]) then exit;
      Result := TRUE;
    end;
  end;
end;

function GetVolumeInformation(Drive: Char; var VolumeRecord: TVolumeRecord): Boolean;
const StringSize = 512;
var Root: string;
  a1, a2: array[0..511] of char;
begin
  if not (UpCase(Drive) in ['A'..'Z']) then
    raise Exception.Create('Falscher Laufwerksbezeichner!');
{  NewStr('');
  NewStr('');}
  Root := UpCase(Drive) + ':\';
  Result := Windows.GetVolumeInformation(
    PCHAR(Root), // address of root directory of the file system
    a1, // address of name of the volume
    StringSize, // length of lpVolumeNameBuffer
    @VolumeRecord.VolumeSerialNumber, // address of volume serial number
    VolumeRecord.MaximumComponentLength, // address of system's maximum filename length
    VolumeRecord.FileSystemFlags, // address of file system flags
    a2, // address of name of file system
    StringSize // length of lpFileSystemNameBuffer
    );
  VolumeRecord.VolumeName := StrPas(a1);
  VolumeRecord.FileSystemNameBuffer := StrPas(a2);
{  if assigned(a1) then
  DisposeStr(a1);
  if assigned(a2) then
  DisposeStr(a2);}
end;


function GetVolumeName(Drive: Char): string;
var VolumeRecord: TVolumeRecord;
begin
  Result := '';
  if GetVolumeInformation(Drive, VolumeRecord) then
    Result := VolumeRecord.VolumeName;
end;

function GetFileType_Hfile(hFile: HFILE): TFileType;
begin
  Result := FILE_TYPE_ERROR;
  if hfile <= 0 then exit;
  case Windows.GetFileType(hfile) of
    Windows.FILE_TYPE_DISK: Result := FILE_TYPE_DISK;
    Windows.FILE_TYPE_CHAR: Result := FILE_TYPE_CHAR;
    Windows.FILE_TYPE_PIPE: Result := FILE_TYPE_PIPE;
    Windows.FILE_TYPE_REMOTE: Result := FILE_TYPE_REMOTE;
  else
    Result := FILE_TYPE_UNKNOWN;
  end;
end;

function GetFileType(const FileName: string): TFileType;
var f: HFILE;
  t: TOFStruct;
begin
  Result := FILE_TYPE_ERROR;
  if FileExists(FileName) then
  begin
    f := OpenFile(PCHAR(FileName), t, OF_READ);
    if f <> HFILE_ERROR then
    begin
      case Windows.GetFileType(f) of
        Windows.FILE_TYPE_DISK: Result := FILE_TYPE_DISK;
        Windows.FILE_TYPE_CHAR: Result := FILE_TYPE_CHAR;
        Windows.FILE_TYPE_PIPE: Result := FILE_TYPE_PIPE;
        Windows.FILE_TYPE_REMOTE: Result := FILE_TYPE_REMOTE;
      else
        Result := FILE_TYPE_UNKNOWN;
      end;
      CloseHandle(f);
      exit;
    end;
  end;
end;

function GetShortFileName(const FileName: string): string;
var p, p2: array[0..1024] of char;
  i: Integer;
  aFileName: string;
  dir, name, ext: string;
begin
  fillChar(p, sizeof(p), #0);

  Filesplit(FileName, dir, name, ext);

  i := GetShortPathName(PCHAR(Dir), p, 1024);
  Win32Check(Bool(i));

  aFileName := string(p) + Copy(Name, 1, 8) + Copy(Ext, 1, 4);
  Result := aFileName;
   //+ExtractFileName(FileName);
end;

function GetFileAttributes(const FileName: string): TFileAttributes;
var attr: TFileAttributes;
  RetAttr: DWORD;
begin
  attr := [FILE_ATTRIBUTE_ERROR];
  RetAttr := Windows.GetFileAttributes(PCHAR(FileName));
  Result := WordToTFileAttributes(RetAttr);
end;

function TFileAttributesToWord(FileAttributes: TFileAttributes): Word;
begin
  Result := 0;
  if FILE_ATTRIBUTE_ARCHIVE in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_ARCHIVE;

  if FILE_ATTRIBUTE_READONLY in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_READONLY;

  if FILE_ATTRIBUTE_HIDDEN in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_HIDDEN;

  if FILE_ATTRIBUTE_SYSTEM in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_SYSTEM;

  if FILE_ATTRIBUTE_DIRECTORY in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_DIRECTORY;

  if FILE_ATTRIBUTE_NORMAL in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_NORMAL;

  if FILE_ATTRIBUTE_TEMPORARY in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_TEMPORARY;

  if FILE_ATTRIBUTE_COMPRESSED in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_COMPRESSED;

  if FILE_ATTRIBUTE_OFFLINE in FileAttributes then
    Result := Result + Windows.FILE_ATTRIBUTE_OFFLINE;
end;

function WordToTFileAttributes(FileAttributes: Word): TFileAttributes;
var Attr: TFileAttributes;
  RetAttr: Word;
begin
  Attr := [FILE_ATTRIBUTE_ERROR];
  begin
    RetAttr := FileAttributes;
    if RetAttr = -1 then exit;
    Attr := [];
    if RetAttr and Windows.FILE_ATTRIBUTE_ARCHIVE = Windows.FILE_ATTRIBUTE_ARCHIVE then
      Attr := attr + [FILE_ATTRIBUTE_ARCHIVE];
    if RetAttr and Windows.FILE_ATTRIBUTE_READONLY = Windows.FILE_ATTRIBUTE_READONLY then
      Attr := attr + [FILE_ATTRIBUTE_READONLY];
    if RetAttr and Windows.FILE_ATTRIBUTE_HIDDEN = Windows.FILE_ATTRIBUTE_HIDDEN then
      Attr := attr + [FILE_ATTRIBUTE_HIDDEN];
    if RetAttr and Windows.FILE_ATTRIBUTE_SYSTEM = Windows.FILE_ATTRIBUTE_SYSTEM then
      Attr := attr + [FILE_ATTRIBUTE_SYSTEM];
    if RetAttr and Windows.FILE_ATTRIBUTE_DIRECTORY = Windows.FILE_ATTRIBUTE_DIRECTORY then
      Attr := attr + [FILE_ATTRIBUTE_DIRECTORY];
    if RetAttr and Windows.FILE_ATTRIBUTE_NORMAL = Windows.FILE_ATTRIBUTE_NORMAL then
      Attr := attr + [FILE_ATTRIBUTE_NORMAL];
    if RetAttr and Windows.FILE_ATTRIBUTE_TEMPORARY = Windows.FILE_ATTRIBUTE_TEMPORARY then
      Attr := attr + [FILE_ATTRIBUTE_TEMPORARY];
    if RetAttr and Windows.FILE_ATTRIBUTE_COMPRESSED = Windows.FILE_ATTRIBUTE_COMPRESSED then
      Attr := attr + [FILE_ATTRIBUTE_COMPRESSED];
    if RetAttr and Windows.FILE_ATTRIBUTE_OFFLINE = Windows.FILE_ATTRIBUTE_OFFLINE then
      Attr := attr + [FILE_ATTRIBUTE_OFFLINE];
    if Attr = [] then
      attr := [FILE_ATTRIBUTE_ERROR];
  end;
  Result := Attr;
end;

function SetFileAttributes(const FileName: string; Attr: TFileAttributes): Boolean;
var
  RetAttr: DWORD;
begin
  RetAttr := TFileAttributesToWord(Attr);

  Result := Windows.SetFileAttributes(PCHAR(FileName), RetAttr);
end;

function GetDiskFreeSpace(drive: char; FreeSpaceRec: TFreeSpaceRec): Boolean;
var Root: string;
begin
  if not (UpCase(Drive) in ['A'..'Z']) then
    raise Exception.Create('Falscher Laufwerksbezeichner!');
  Root := UpCase(Drive) + ':\';
  Result :=
    Windows.GetDiskFreeSpace(PCHAR(Root),
    FreeSpaceRec.SectorsPerCluster, // address of sectors per cluster
    FreeSpaceRec.BytesPerSector, // address of bytes per sector
    FreeSpaceRec.NumberOfFreeClusters, // address of number of free clusters
    FreeSpaceRec.TotalNumberOfClusters);
end;

function FileExists(const Name: string): Boolean;
var attr: TFileAttributes;
  dir: string;
begin
  Attr := GetFileAttributes(Name);
  if FILE_ATTRIBUTE_DIRECTORY in Attr then
  begin
    dir := GetCurrentDirectory;
    Windows.SetLastError(0);
    SetCurrentDirectory(Name);
    if Windows.GetLastError <> 0 then
      Result := FALSE
    else
    begin
      SetCurrentDirectory(Dir);
      Result := TRUE;
    end;
    exit;
  end
  else
    Result := SysUtils.FileExists(Name);
end;

function GetCurrentDirectory: string;
var l: array[0..512] of char;
begin
  Windows.GetCurrentDirectory(512, l);
  Result := StrPas(l);
end;

function SetCurrentDirectory(Name: string): Integer;
begin
  Windows.SetLastError(0);
  Windows.SetCurrentDirectory(PCHAR(Name));
  Result := Windows.GetLastError;
end;

function GetFullFileName(const ShortName: string): string;
var SName2: string; F: TSearchRec;
begin
  if (Pos('\\', ShortName) + Pos('*', ShortName) + Pos('?', ShortName) = 0) or not FileExists(ShortName) then
  begin
    Result := ShortName;
    exit;
  end;
  SName2 := ShortName;
  Result := '';
  while FindFirst(SName2, $3F, F) = 0 do
  begin
    Result := '\' + F.Name + Result;
    SysUtils.FindClose(f);
    SetLength(SName2, Length(ExtractFilePath(SName2)) - 1);
    if Length(SName2) >= 2 then break;
  end;
  Result := SName2 + Result;
end;

function GetPathNames(const PathName: string; var Paths: TStrings): Integer;
var i, p: Integer;
  d, n, e, s: string;
begin
  FileSplit(PathName, d, n, e);
  Result := -1;
  if d = '' then exit;
  Paths := TStrings(TStringList.Create);
  p := pos(':', d);
  if p <> 0 then
    Paths.Add(d[p - 1] + ':');
  p := 0;
  for i := 1 to Length(d) do
  begin
    if (d[i] = '\') and (p = 0) then p := i
    else
      if (d[i] = '\') and ((p <> 0) or (i = Length(d))) then
      begin
        s := Copy(d, p + 1, i - p - 1);
        Paths.Add(s);
        p := i;
      end;
  end;
  Result := Paths.Count;
end;

function IsFileInDir(const FileName, PathName: string): Integer;
var f: TSearchRec;
  d: string;
  Count: Integer;
begin
  Result := -1;
  if not FileExists(PathName) then exit;
  d := PathName;
  Count := 0;
  if PathName[Length(PathName)] <> '\' then Insert('\', d, Length(d) + 1);
  if FindFirst(d + FileName, faAnyFile, f) = 0 then
    Inc(Count);
  while FindNext(f) = 0 do
    Inc(Count);
  FindClose(f);
  Result := Count;
end;

function IsDirInDir(const DirName, PathName: string): Integer;
var f: TSearchRec;
  d: string;
  Count: Integer;
begin
  Result := -1;
  if not FileExists(PathName) then exit;
  d := PathName;
  Count := 0;
  if PathName[Length(PathName)] <> '\' then Insert('\', d, Length(d) + 1);
  if FindFirst(d + DirName, faDirectory, f) = 0 then
    Inc(Count);
  while FindNext(f) = 0 do
    Inc(Count);
  FindClose(f);
  Result := Count;
end;

function DeleteFile(const FileName: array of string; Form: TCustomForm; AllowUndo: Boolean): Longint;
var h: HWND;
  op: TSHFileOpStruct;
  s: string;
  i: Integer;
begin
  if Form = nil then
    h := 0
  else
    h := Form.Handle;
  op.Wnd := h;
  op.wFunc := FO_DELETE;
  if AllowUndo then
    op.fFlags := FOF_ALLOWUNDO + MoreDelFlags
  else
    op.fFlags := 0;
  s := '';
  for i := 0 to High(FileName) do
    s := s + #0 + FileName[i];
  Delete(s, 1, 1);
  s := s + #0#0;
  op.pFrom := StrNew(PCHAR(s));
  Result := SHFileOperation(op);
end;

function DeleteFileStr(const FileName: TStrings; Form: TCustomForm; AllowUndo: Boolean): Longint;
var h: HWND;
  op: TSHFileOpStruct;
  s: string;
  i: Integer;
begin
  if FileName.Count = 0 then
    raise Exception.Create('No files found');
  if Form = nil then
    h := 0
  else
    h := Form.Handle;

  FillChar(op, SizeOf(op), 0);

  op.Wnd := h;
  op.wFunc := FO_DELETE;
  if AllowUndo then
    op.fFlags := FOF_ALLOWUNDO or MoreDelFlags
  else
    op.fFlags := 0;
  s := '';
  for i := 0 to FileName.Count - 1 do
    s := s + #0 + FileName.Strings[i];
  Delete(s, 1, 1);
  s := s + #0#0;
  op.pFrom := PCHAR(s);
  Result := SHFileOperation(op);
end;

function GetSpecDirectory(Typ: TSpecDirectory): string;
var L : THandle;
    CSIDL: Integer;
    PIDL: PItemIDList;
begin
  L := SHLApplicationHandle;
  if L = -1 then L := GetDesktopWindow;

  if SHGetSpecialFolderLocation(L,Integer(Typ), PIDL) = NOERROR then
    begin
      SetLength(Result, MAX_PATH);
      if SHGetPathFromIDList(PIDL, PChar(Result)) then
        SetLength(Result, StrLen(PChar(Result)))
      else
       Result := '';
    end
    else
     Result := '';
end;


function GetSpecDirectory(Typ: TTypeDirectory): string;
var p: array[0..1023] of char;
begin
  Fillchar(p, sizeof(p), #0);
  case Typ of
    DIR_WINDOWS: GetWindowsDirectory(p, 1024);
    DIR_SYSTEM: GetSystemDirectory(p, 1024);
    DIR_CURRENT: begin
        Result := GetCurrentDirectory;
        exit;
      end;
    DIR_TEMP: GetTempPath(1024, p);
  end;
  Result := string(p);
end;

function GetTempFileEx(const PathName, PrefixString: string;
  Unique: Integer): string;
var p: array[0..1023] of char;
begin
  Result := '';
  Fillchar(p, sizeof(p), #0);
  if GetTempFileName(PCHAR(PathName), PCHAR(PrefixString), Unique, p) = 0 then
    raise Exception.CreateFmt('GetTempFileEx'#10#13 +
      'Es konnte keine Tempor�re Datei erstellt werden.' + return +
      'Win32-Fehlercode : %d' + return + return +
      'Parameterliste : ' + return +
      'PathName       : %s' + return +
      'PrefixString   : %s' + return +
      'Unique         : %d' + return +
      'R�ckgabewert   : %s', [GetLastError,
      PathName, PrefixString, Unique,
        string(p)]);
  Result := string(p);
end;

function GetTempFile(const PrefixString: string): string;
begin
  Result := GetTempFileEx(GetSpecDirectory(DIR_TEMP), PrefixString, 0);
end;

function ExtractFileNameIndent(const FileName: string): string;
var dir, name, ext: string;
begin
  Filesplit(filename, dir, name, ext);
  Result := Name;
end;

function AddDirToFile(const FileName: string; Directory: string; OverWriteExisting: Boolean; VerifyDirectory: Boolean = TRUE): string;
var Name, Dir: string;
begin
  Dir := GetDirFromPath(FileName);
  Name := GetFileNameFromPath(FileName);
  Result := FileName;

  if (Length(Directory) > 0) and (Directory[Length(Directory)] <> '\') then
    Insert('\', Directory, Length(Directory) + 1);

  if not OverWriteExisting and (Length(Dir) = 0) then
    Result := Directory + FileName
  else

    if OverWriteExisting or (VerifyDirectory and not DirectoryExists(Dir)) then
    begin
      Result := Directory + Name;
    end;
end;

function AddExtToFile(const FileName: string; Extension: string; OverWriteExisting: Boolean): string;
var Name, Ext, Dir: string;
begin
  Ext := GetFileExtension(FileName);
  Name := ExtractFileNameIndent(FileName);
  Dir := GetDirFromPath(FileName);

  Result := FileName;

  if (Length(Extension) > 0) and (Extension[1] <> '.') then
    Insert('.', Extension, 1);

  if not OverWriteExisting and (Length(Ext) = 0) then
    Result := Dir + Name + Extension;

  if OverWriteExisting then
  begin
    Result := Dir + Name + Extension;
  end;
end;

function ReplaceInValidFile(const FileName, NewFileName: string): string;
begin
  if not dtFiles.FileExists(FileName) then
    Result := NewFileName
  else
    Result := FileName;
end;


function CreateNullFile(const FileName: string; OwerwriteExisting: Boolean = FALSE): Integer;
var F: file;
begin
  Result := 0;
  if FileExists(FileName) and not OwerwriteExisting then
  begin
    Result := -1;
  end;
  if (OwerwriteExisting) or (not FileExists(FileName) and not OwerwriteExisting) then
  begin
    AssignFile(f, FileName);
    ReWrite(f);
    CloseFile(f);
  end;
end;


function GetLogicalDrives: TStringList;
var w: Longint;
  i, p: Integer;
begin
  w := Windows.GetLogicalDrives;
  Result := TStringList.Create;
  for i := 0 to 25 do
  begin
    p := dtMath.pow(2, i);
    if w and p = p then
      Result.Add(Char(i + 65));
  end;
end;

function ExtractShortPathName(const FileName: string): string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  SetString(Result, Buffer,
    GetShortPathName(PChar(FileName), Buffer, SizeOf(Buffer)));
end;

function ExtractLongPathName(const PathName: string): string;
var
  LastSlash, PathPtr: PChar;

  function ExtractLongFileName(const FileName: string): string;
  var
    Info: TSHFileInfo;
  begin
    if SHGetFileInfo(PChar(FileName), 0, Info, Sizeof(Info),
      SHGFI_DISPLAYNAME) <> 0 then
      Result := string(Info.szDisplayName)
    else
      Result := FileName;
  end;

begin
  Result := '';
  PathPtr := PChar(PathName);
  LastSlash := StrRScan(PathPtr, '\');
  while LastSlash <> nil do
  begin
    Result := '\' + ExtractLongFileName(PathPtr) + Result;
    if LastSlash <> nil then
    begin
      LastSlash^ := #0;
      LastSlash := StrRScan(PathPtr, '\');
    end;
  end;
  Result := PathPtr + Result;
end;


function AddInformationToFile(const FileName: string; WriteProc: TWriteProc; Data: Pointer): Longint;
var Stream: TFileStream;
  s, Size: Longint;
begin
  ASSERT(FileExists(FileName), Format('Datei "%s" nicht gefunden!', [FileName]));
  ASSERT(Assigned(WriteProc), 'Keine Daten zum speichern. WriteProc-Parameter darf nicht nil sein.');
  Stream := TFileStream.Create(FileName, fmOpenWrite);
  Stream.Position := Stream.Size;
  Size := Stream.Size;
  s := Stream.Write(InformationHeader, InfoHeaderLen);
  Result := s;
  Inc(Result, WriteProc(Stream, Data));
  ASSERT(Result >= s, 'Ung�ltige Streamgr��e');
  Inc(Result, Stream.Write(Result, SizeOf(Longint)));
  Inc(Result, Stream.Write(InformationHeader, InfoHeaderLen));

  Stream.Free;
end;


function GetInformationFromFile(const FileName: string; ReadProc: TWriteProc; Data: Pointer): Longint;
var Stream: TFileStream;
  p: array[0..InfoHeaderLen - 1] of char;
  s, Pos, Size: Longint;
begin
  ASSERT(FileExists(FileName), Format('Datei "%s" nicht gefunden!', [FileName]));
  ASSERT(Assigned(ReadProc), 'Keine Daten zum speichern. ReadProc-Parameter darf nicht nil sein.');
  Stream := TFileStream.Create(FileName, fmOpenRead);
  Stream.Position := Stream.Size - InfoHeaderLen;
  s := Stream.Read(p, InfoHeaderLen);
  if CompareStr(string(p), InformationHeader) <> 0 then
  begin
    Result := -1;
    exit;
  end;
  Size := s;
  Stream.Position := Stream.Size - SizeOf(Longint) - InfoHeaderLen;
  pos := 0;
  s := Stream.Read(pos, SizeOf(Longint));
  if pos <= 0 then
  begin
    Result := -1;
    exit;
  end;
  Inc(Size, s);
  Stream.Position := Stream.Size - pos - InfoHeaderLen - SizeOf(Longint);
  s := Stream.Read(p, InfoHeaderLen);
  if CompareStr(string(p), InformationHeader) <> 0 then
  begin
    Result := -1;
    exit;
  end;
  Inc(Size, s);
  Inc(Size, ReadProc(Stream, Data));

  Stream.Free;
  Result := Size;
end;

function TestOpenSharedFile(const FileName: string): Boolean;
var f: Longint;
begin
  Result := TRUE;
  if not FileExists(FileName) then exit;
  try
{$I+}
    f := FileOpen(FileName, fmOpenRead);
    FileClose(f);
    if f = -1 then Result := FALSE;
  except
    Result := FALSE;
  end;
{$I+}
end;

function IsFileNameValidA(FileName: string): Boolean;
var i,i2 : Integer;
begin
  for i := 1 to Length(FileName) do
  begin
    for i2 := low(InvalidChars) to high(InvalidChars) do
    begin
      if FileName[i] = InvalidChars[i2] then
      begin
        result := FALSE;
        exit;
      end;
    end;
  end;
  result := TRUE;
end;



function IsFileNameValid(FileName: string): Boolean;
var temp: string;
  f: file;
begin
  temp := GetSpecDirectory(DIR_TEMP);
  filename := temp + GetFileNameFromPath(Filename);
  AssignFile(f, filename);
{$I-}
  ReWrite(f);
  Result := IOResult = 0;
  CloseFile(f);
{$I+}
end;

function GetApplicationPath: string;
var p: string;
begin
  p := ParamStr(0);
  Result := GetCompletePath(p);
end;

function MakeRealPathName(Path : String) : String;
var i,c : Integer;
    p : String;
begin
  c := StrToIntDef(GetDirName(-1,Path),-1);
  p := GetDirName(0,Path)+':';
  for i := 1 to c -1 do
  begin
    p := p+'\'+GetDirName(i,Path);
    if not DirectoryExists(p) then
     CreateDir(p);
  end;
  result := p+'\';
end;

function GetDirName(Level : Integer; Path : String) : String;
type ADirList  = Array of String;

var p,p2 : Cardinal;
    cP : String;
    Dircount : Cardinal;
    DirList : ADirList;  


procedure ExtractToUNCPath(var Path : String);
var p : Cardinal;
begin
  p := pos('\\',Path);
  if p > 0 then begin Delete(Path,p,1); exit;end;
  p := pos(':',Path);
  Delete(Path,p,1);
  Insert('\',Path,0);
end;

procedure GetDirList(Path : String);
var c,dir : String;
    p,p2 : Cardinal;
begin
  Dircount := 0;

  p := pos(':',Path);
  if p > 0 then
  begin
    c := Copy(Path,1,1);
    SetLength(DirList,DirCount);
    DirList[DirCount-1] := Dir;
  end;

  while Length(Path) > 0 do
  begin
    p := pos('\',Path);
    c := Copy(Path,p+1,Length(Path));
    p2 := pos('\',c);
    if (p > 0) then
    begin
      if p2 = 0 then p2 := Length(c)+1;
      dir := Copy(Path,p+1,p2-1);
      Path := Copy(Path,p2+1,Length(Path));

      if Length(Dir) > 0 then
      begin
        Inc(Dircount);
        SetLength(DirList,DirCount);
        DirList[DirCount-1] := Dir;
      end;
    end
    else break;
  end;
end;

begin
  if IsNetworkPath(Path) then Path := ExpandUNCFileName(Path);
  ExtractToUNCPath(Path);
  if Path = '' then exit;
  GetDirList(Path);
  if (Level < DirCount) and (Level >= 0) then
   Result := DirList[Level]
  else
  begin
    if Level = -1 then
     result := IntToStr(DirCount)
    else
     result := '';
  end;
end;

end.

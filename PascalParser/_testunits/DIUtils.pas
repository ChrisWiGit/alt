{ The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DIUtils.pas.

  The Initial Developer of the Original Code is Ralf Junker.

  E-Mail:    delphi@zeitungsjunge.de
  Internet:  http://www.zeitungsjunge.de/delphi/

  All Rights Reserved. }

{ @author(Ralf Junker <delphi@zeitungsjunge.de>)
  Basic utility functions and procedures. }

unit DIUtils;

{$I DI.inc}

interface

uses
  Windows,
  ShlObj;

const
  { @Name @code(= #$0D#$0A;) }
  CRLF = #$0D#$0A;

  { ---------------------------------------------------------------------------- }
  { Ansi Chars & Strings: Some typed constants                                   }
  { ---------------------------------------------------------------------------- }

  { Prefixes: AC: AnsiChar
              AS: set of AnsiChar / AnsiString
              AA: array of AnsiChar }
  { }
  AC_NULL = AnsiChar(#$00);
  AC_TAB = AnsiChar(#$09);
  AC_SPACE = AnsiChar(#$20);
  AC_EXCLAMATION_MARK = AnsiChar(#$21);
  AC_QUOTATION_MARK = AnsiChar(#$22);
  AC_AMPERSAND = AnsiChar(#$26);
  AC_APOSTROPHE = AnsiChar(#$27);
  AC_ASTERISK = AnsiChar(#$2A);
  AC_COMMA = AnsiChar(#$2C);
  AC_HYPHEN_MINUS = AnsiChar(#$2D);
  AC_FULL_STOP = AnsiChar(#$2E);
  AC_SOLIDUS = AnsiChar(#$2F); // Also known as Slash

  { }
  AC_DIGIT_ZERO = AnsiChar(#$30);
  AC_DIGIT_ONE = AnsiChar(#$31);
  AC_DIGIT_TWO = AnsiChar(#$32);
  AC_DIGIT_THREE = AnsiChar(#$33);
  AC_DIGIT_FOUR = AnsiChar(#$34);
  AC_DIGIT_FIVE = AnsiChar(#$35);
  AC_DIGIT_SIX = AnsiChar(#$36);
  AC_DIGIT_SEVEN = AnsiChar(#$37);
  AC_DIGIT_EIGHT = AnsiChar(#$38);
  AC_DIGIT_NINE = AnsiChar(#$39);

  AC_COLON = AnsiChar(#$3A);
  AC_SEMICOLON = AnsiChar(#$3B);
  AC_EQUALS_SIGN = AnsiChar(#$3D);
  AC_QUESTION_MARK = AnsiChar(#$3F);
  AC_REVERSE_SOLIDUS = AnsiChar(#$5C); // Also known as BackSlash.
  { }
  AC_LOW_LINE = AnsiChar(#$5F); // Also known as Spacing Underscore
  { }
  AC_SOFT_HYPHEN = AnsiChar(#$AD);

  AC_CAPITAL_A = AnsiChar(#$41);
  AC_CAPITAL_B = AnsiChar(#$42);
  AC_CAPITAL_C = AnsiChar(#$43);
  AC_CAPITAL_D = AnsiChar(#$44);
  AC_CAPITAL_E = AnsiChar(#$45);
  AC_CAPITAL_F = AnsiChar(#$46);
  AC_CAPITAL_Z = AnsiChar(#$5A);

  AC_SMALL_A = AnsiChar(#$61);
  AC_SMALL_B = AnsiChar(#$62);
  AC_SMALL_C = AnsiChar(#$63);
  AC_SMALL_D = AnsiChar(#$64);
  AC_SMALL_E = AnsiChar(#$65);
  AC_SMALL_F = AnsiChar(#$66);
  AC_SMALL_Z = AnsiChar(#$7A);

  AC_NO_BREAK_SPACE = AnsiChar(#$A0);

  AC_DRIVE_DELIMITER = AC_COLON;

  AC_DOS_PATH_DELIMITER = AC_REVERSE_SOLIDUS; // Also known as BackSlash
  { }
  AC_UNIX_PATH_DELIMITER = AC_SOLIDUS; // Also known as Forward Slash
  { }
  AC_PATH_DELIMITER = {$IFDEF MSWINDOWS}AC_DOS_PATH_DELIMITER{$ELSE}AC_UNIX_PATH_DELIMITER{$ENDIF};

  { }
  AS_CRLF = AnsiString(#$0D#$0A);

  { }
  AS_DIGITS = [
    AC_DIGIT_ZERO..AC_DIGIT_NINE];
  { }
  AS_HEX_DIGITS = [
    AC_DIGIT_ZERO..AC_DIGIT_NINE,
    AC_CAPITAL_A..AC_CAPITAL_F,
    AC_SMALL_A, AC_SMALL_F];
  { }
  AS_WHITE_SPACE = [
    AC_NULL..AC_SPACE]; // Must NOT include NO-BREAK SPACE (#$A0)!
  { }
  AS_WORD_SEPARATORS = [
    AC_NULL..AC_SPACE,
    AC_DIGIT_ZERO..AC_DIGIT_NINE,
    AC_FULL_STOP, AC_COMMA, AC_COLON, AC_SEMICOLON,
    AC_QUOTATION_MARK, AC_HYPHEN_MINUS, AC_SOLIDUS, AC_AMPERSAND];

  { }
  AA_NUM_TO_HEX: array[0..$F] of AnsiChar = (
    AC_DIGIT_ZERO,
    AC_DIGIT_ONE,
    AC_DIGIT_TWO,
    AC_DIGIT_THREE,
    AC_DIGIT_FOUR,
    AC_DIGIT_FIVE,
    AC_DIGIT_SIX,
    AC_DIGIT_SEVEN,
    AC_DIGIT_EIGHT,
    AC_DIGIT_NINE,
    AC_CAPITAL_A,
    AC_CAPITAL_B,
    AC_CAPITAL_C,
    AC_CAPITAL_D,
    AC_CAPITAL_E,
    AC_CAPITAL_F);

  { ---------------------------------------------------------------------------- }
  { Unicode / Wide Chars & Strings: Some typed constants                         }
  { ---------------------------------------------------------------------------- }

  { }
  WC_NULL = WideChar(#$0000);
  WC_TAB = WideChar(#$0009);
  WC_LF = WideChar(#$000A);
  WC_CR = WideChar(#$000D);
  WC_SPACE = WideChar(#$0020);
  WC_EXCLAMATION_MARK = WideChar(#$0021);
  WC_QUOTATION_MARK = WideChar(#$0022);
  WC_NUMBER_SIGN = WideChar(#$0023);
  WC_DOLLAR_SIGN = WideChar(#$0024);
  WC_PERCENT_SIGN = WideChar(#$0025);
  WC_AMPERSAND = WideChar(#$0026);
  WC_APOSTROPHE = WideChar(#$0027);
  WC_ASTERISK = WideChar(#$002A);
  WC_PLUS_SIGN = WideChar(#$002B);
  WC_COMMA = WideChar(#$002C);
  WC_HYPHEN_MINUS = WideChar(#$002D);
  WC_FULL_STOP = WideChar(#$002E);
  WC_SOLIDUS = WideChar(#$002F); // Also known as Slash.

  WC_DIGIT_ZERO = WideChar(#$0030);
  WC_DIGIT_ONE = WideChar(#$0031);
  WC_DIGIT_TWO = WideChar(#$0032);
  WC_DIGIT_THREE = WideChar(#$0033);
  WC_DIGIT_FOUR = WideChar(#$0034);
  WC_DIGIT_FIVE = WideChar(#$0035);
  WC_DIGIT_SIX = WideChar(#$0036);
  WC_DIGIT_SEVEN = WideChar(#$0037);
  WC_DIGIT_EIGHT = WideChar(#$0038);
  WC_DIGIT_NINE = WideChar(#$0039);

  WC_COLON = WideChar(#$003A);
  WC_SEMICOLON = WideChar(#$003B);
  WC_LESS_THAN_SIGN = WideChar(#$003C);
  WC_EQUALS_SIGN = WideChar(#$003D);
  WC_GREATER_THAN_SIGN = WideChar(#$003E);
  WC_QUESTION_MARK = WideChar(#$003F);
  WC_REVERSE_SOLIDUS = WideChar(#$005C); // Also known as BackSlash.
  WC_LOW_LINE = WideChar(#$005F); // Also known as Spacing Underscore.
  WC_SOFT_HYPHEN = WideChar(#$00AD);

  WC_CAPITAL_A = WideChar(#$0041);
  WC_CAPITAL_B = WideChar(#$0042);
  WC_CAPITAL_C = WideChar(#$0043);
  WC_CAPITAL_D = WideChar(#$0044);
  WC_CAPITAL_E = WideChar(#$0045);
  WC_CAPITAL_F = WideChar(#$0046);
  WC_CAPITAL_H = WideChar(#$0048);
  WC_CAPITAL_I = WideChar(#$0049);
  WC_CAPITAL_L = WideChar(#$004C);
  WC_CAPITAL_P = WideChar(#$0050);
  WC_CAPITAL_R = WideChar(#$0052);
  WC_CAPITAL_S = WideChar(#$0053);
  WC_CAPITAL_T = WideChar(#$0054);
  WC_CAPITAL_X = WideChar(#$0058);
  WC_CAPITAL_Y = WideChar(#$0059);
  WC_CAPITAL_Z = WideChar(#$005A);

  WC_SMALL_A = WideChar(#$0061);
  WC_SMALL_B = WideChar(#$0062);
  WC_SMALL_C = WideChar(#$0063);
  WC_SMALL_D = WideChar(#$0064);
  WC_SMALL_E = WideChar(#$0065);
  WC_SMALL_F = WideChar(#$0066);
  WC_SMALL_H = WideChar(#$0068);
  WC_SMALL_I = WideChar(#$0069);
  WC_SMALL_L = WideChar(#$006C);
  WC_SMALL_P = WideChar(#$0070);
  WC_SMALL_R = WideChar(#$0072);
  WC_SMALL_S = WideChar(#$0073);
  WC_SMALL_T = WideChar(#$0074);
  WC_SMALL_X = WideChar(#$0078);
  WC_SMALL_Y = WideChar(#$0079);
  WC_SMALL_Z = WideChar(#$007A);

  WC_NO_BREAK_SPACE = WideChar(#$00A0);
  WC_EN_DASH = WideChar(#$2013);
  WC_REPLACEMENT_CHARACTER = WideChar(#$FFFD);

  WC_DRIVE_DELIMITER = WC_COLON;

  WC_DOS_PATH_DELIMITER = WC_REVERSE_SOLIDUS;
  WC_UNIX_PATH_DELIMITER = WC_SOLIDUS;
  WC_PATH_DELIMITER = {$IFDEF MSWINDOWS}WC_DOS_PATH_DELIMITER{$ELSE}WC_UNIX_PATH_DELIMITER{$ENDIF};

  WS_CRLF = WideString(#$000D#$000A);

  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  { }
  WS_DIGITS = [
    WC_DIGIT_ZERO..WC_DIGIT_NINE];
  { }
  WS_HEX_DIGITS = [
    WC_DIGIT_ZERO..WC_DIGIT_NINE,
    WC_CAPITAL_A..WC_CAPITAL_F,
    WC_SMALL_A..WC_SMALL_F];
  { }
  WS_WHITE_SPACE = [
    WC_NULL..WC_SPACE]; // Must NOT include NO-BREAK SPACE (#$00A0)!
  {$ENDIF}

  WA_NUM_TO_HEX: array[0..$F] of WideChar = (
    WC_DIGIT_ZERO,
    WC_DIGIT_ONE,
    WC_DIGIT_TWO,
    WC_DIGIT_THREE,
    WC_DIGIT_FOUR,
    WC_DIGIT_FIVE,
    WC_DIGIT_SIX,
    WC_DIGIT_SEVEN,
    WC_DIGIT_EIGHT,
    WC_DIGIT_NINE,
    WC_CAPITAL_A,
    WC_CAPITAL_B,
    WC_CAPITAL_C,
    WC_CAPITAL_D,
    WC_CAPITAL_E,
    WC_CAPITAL_F);

const
  { Constants for TMT19937. }
  { }
  MT19937_N = 624;
  { }
  MT19937_M = 397;

type
  { }
  PCardinal = ^Cardinal;
  { }
  TAnsiCharSet = set of AnsiChar;
  { }
  TIsoDate = Cardinal;

  { }
  TJulianDate = Integer;
  { @Name = ^@link(TJulianDate) }
  PJulianDate = ^TJulianDate;

implementation
  {$IFNDEF Delphi_6_UP}
  TMethod = record
    Code, Data: Pointer;
  end;
  {$ENDIF}

  { }
  TProcedureEvent = procedure of object;

  { }
  TDIValidateWideCharFunc = function(const Char: WideChar): Boolean;


implementation
  { @abstract(Mersenne Twister pseudorandom number generator.)
  This is a Mersenne Twister pseudorandom number generator with a period of
  2^19937-1 and an improved initialization scheme.
  <P>@Name allows to generate a sequence of pseudorandom unsigned integers
  (32 bit) which is uniformly distributed among 0 to 2^32-1 for each call.
  The Mersenne Twister is "designed with consideration of the flaws of
  various existing generators," has a period of 2^19937 - 1, gives a
  sequence that is 623-dimensionally equidistributed, and "has passed many
  stringent tests, including the die-hard test of G. Marsaglia and the load
  test of P. Hellekalek and S. Wegenkittl."
  <P>Copyright (C) 1997-2002, Makoto Matsumoto and Takuji Nishimura,
  all rights reserved. http://www.math.keio.ac.jp/matumoto/emt.html
  <P>This Pascal port is copyright (C) 2002,
  The Delphi Inspiration, all rights reserved.
  http://www.zeitungsjunge.de/delphi/ }
  TMT19937 = class(TObject)
  private
    FState: array[0..MT19937_N - 1] of Cardinal;
    FLeft: Integer;
    FInit: Boolean;
    FNext: PCardinal;
    procedure next_state;
  public
    { Creates an instance of @ClassName and initializes the state vector by
      using one unsigned 32-bit integer "seed", which may be zero. }
    constructor Create(const Seed: Cardinal); overload;
    { Creates an instance of @ClassName and initializes the state vector by
      using an array of unsigned 32-bit integers. If fewer than 624 integers are
      passed, then each array of 32-bit integers gives a distinct initial state
      vector. This is useful if you want a larger seed space than 32-bit word. }
    constructor Create(const Seeds: array of Cardinal); overload;
    { Initializes the state vector by using one unsigned 32-bit integer "seed",
      which may be zero. }
    procedure init_genrand(const Seed: Cardinal);
    { Initializes the state vector by using an array of unsigned 32-bit
      integers. If fewer than 624 integers are passed, then each array of
      32-bit integers gives a distinct initial state vector. This is useful
      if you want a larger seed space than 32-bit word. }
    procedure init_by_array(const Seeds: array of Cardinal);
    { Generates a random number on [0,$FFFFFFFF]-interval, for each call. }
    function genrand_int32: Cardinal;
    { Generates a random number on [0,$7FFFFFFF]-interval, for each call. }
    function genrand_int31: Integer;
    { Generates a random number on [0,$FFFFFFFFFFFFFFFF]-interval, for each call. }
    function genrand_int64: Int64;
    { Generates a random number on [0,$7FFFFFFFFFFFFFFF]-interval, for each call. }
    function genrand_int63: Int64;
    { Generates one pseudorandom real number (double) which is uniformly
      distributed on [0,1]-interval, for each call. }
    function genrand_real1: Double;
    { Generates one pseudorandom real number (double) which is uniformly
      distributed on [0,1]-interval, for each call. }
    function genrand_real2: Double;
    { Generates one pseudorandom real number (double) which is uniformly
      distributed on [0,1]-interval, for each call. }
    function genrand_real3: Double;
    { Generates a random number on [0,1) with 53-bit resolution. }
    function genrand_res53: Double;
  end;

  { }
function BitClear(const Bits, BitNo: Integer): Integer;
{ }
function BitSet(const Bits, BitIndex: Integer): Integer;
{ }
function BitSetTo(const Bits, BitIndex: Integer; const Value: Boolean): Integer;
{ }
function BitTest(const Bits, BitIndex: Integer): Boolean;

{ Reverses the byte order of a given cardinal number.
  For example, 001.002.003.004 returns 004.003.002.001. }
function BSwap(const Value: Cardinal): Cardinal; overload;

{ Reverses the byte order of a given integer number.
  For example, 001.002.003.004 returns 004.003.002.001. }
function BSwap(const Value: Integer): Integer; overload;

{ @Name searches for a substring, Search, in a Buffer and returns
  a pointer to the first character of Search within Buffer. @Name starts
  searching at the beginning of Source and is case-sensitive.
  If Search is not found, @Name returns @nil.}
function BufPosA(const Search: AnsiString; const Buf: PAnsiChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;

function BufPosW(const Search: WideString; const Buf: PWideChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): PWideChar;

{ @Name searches for a substring, Search, in a Buffer and returns
  a pointer to the first character of Search within Buffer. @Name starts
  searching at the beginning of Source and is case-insensitive.
  If Search is not found, @Name returns @nil.}
function BufPosIA(const Search: AnsiString; const Buf: Pointer; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;
{ @Name searches for a substring, Search, in a Buffer and returns
  a pointer to the first character of Search within Buffer. @Name starts
  searching at the beginning of Source and is case-insensitive.
  If Search is not found, @Name returns @nil.}
function BufPosIW(const Search: WideString; const Buf: PWideChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): PWideChar;

{ }
function BufSame(const Buf1, Buf2: Pointer; const BufByteCount: Cardinal): Boolean;
{ }
function BufSameIA(const Buf1, Buf2: Pointer; const BufCharCount: Cardinal): Boolean;

{ Scans Source for the first Character in Set Search. }
function BufPosCharsA(const Buf: PAnsiChar; const BufCharCount: Cardinal; const Search: TAnsiCharSet; const Start: Cardinal = 0): Integer;

{ Case-sensitively compares a buffer and an AnsiString for equality. }
function BufStrSameA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;
{ Case-sensitively compares a buffer and a WideString for equality. }
function BufStrSameW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;

{ Case-insensitively compares a buffer and an AnsiString for equality. }
function BufStrSameIA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;
{ Case-insensitively compares a buffer and a WideString for equality. }
function BufStrSameIW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;

{ Returns the case-folded representation of a given character. }
function CharToCaseFoldW(const Char: WideChar): WideChar;
{ Returns the lower case representation of a given character. }
function CharToLowerW(const Char: WideChar): WideChar;
{ Returns the upper case representation of a given character. }
function CharToUpperW(const Char: WideChar): WideChar;
{ Returns the title case representation of a give character. }
function CharToTitleW(const Char: WideChar): WideChar;

{ @abstract(Adds AnsiCharCount AnsiChars of the buffer pointed to by Buffer to string d.)
  See @link(ConCatStringA) for details on how to use @Name. }
procedure ConCatBufA(const Buffer: Pointer; const AnsiCharCount: Cardinal; var d: AnsiString; var InUse: Cardinal);
{ @abstract(Adds WideCharCount WideChars of the buffer pointed to by Buffer to string d.)
  See @link(ConCatStringW) for details on how to use @Name. }
procedure ConCatBufW(const Buffer: Pointer; const WideCharCount: Cardinal; var d: WideString; var InUse: Cardinal);

{ @abstract(Adds character c to string d.)
  See @link(ConCatStringA) for details on how to use @Name. }
procedure ConCatCharA(const c: AnsiChar; var d: AnsiString; var InUse: Cardinal);
{ @abstract(Adds character c to string d.)
  See @link(ConCatStringA) for details on how to use @Name. }
procedure ConCatCharW(const c: WideChar; var d: WideString; var InUse: Cardinal);

{ @abstract(Appends string s to string d.)
  String concatenation with smart memory allocation. Offers a speed advantage
  when building a long resultant string (d) from many small string fragments.
  <P>@code(InUse) is a user-supplied variable which is updated by the procedure
  to track the portion of @code(d) actually "in use" at any time (typically less than
  the allocated length). Initialize to zero or @code(Length(d)) as appropriate at the
  outset but do not manually alter otherwise.
  <P>Once concatenation is finished, use @Code(SetLength(d,InUse)) to trim
  any unused excess from the resultant.
  <P>See also: @link(ConCatCharA), @link(ConCatBufferA). }
procedure ConCatStrA(const s: AnsiString; var d: AnsiString; var InUse: Cardinal);
{ @abstract(Appends string s to string d.)
  String concatenation with smart memory allocation. Offers a speed advantage
  when building a long resultant string (d) from many small string fragments.
  <P>@code(InUse) is a user-supplied variable which is updated by the procedure
  to track the portion of @code(d) actually "in use" at any time (typically less than
  the allocated length). Initialize to zero or @code(Length(d)) as appropriate at the
  outset but do not manually alter otherwise.
  <P>Once concatenation is finished, use @Code(SetLength(d,InUse)) to trim
  any unused excess from the resultant.
  <P>See also: @link(ConCatCharW), @link(ConCatBufferW). }
procedure ConCatStrW(const w: WideString; var d: WideString; var InUse: Cardinal);

{ @Name calculates the CRC32 value of the given memory Buffer. }
function Crc32OfBuf(const Buffer; const BufferSize: Cardinal): Cardinal;

{ @Name calculates the CRC32 value of the given AnsiString. }
function Crc32OfStrA(const s: AnsiString): Cardinal;

{ @Name calculates the CRC32 value of the given WideString. }
function Crc32OfStrW(const w: WideString): Cardinal;

function CurrentDay: Word;
function CurrentMonth: Word;
function CurrentQuarter: Word;
function CurrentYear: Integer;

{ Returns the current date in Julian date format. }
function CurrentJulianDate: TJulianDate;

function DayOfJulianDate(const JulianDate: TJulianDate): Word;

function DayOfWeek(const JulianDate: TJulianDate): Word; overload;
function DayOfWeek(const Year: Integer; const Month, Day: Word): Word; overload;

{ Returns the number of days in the specified month of a given year. }
function DaysInMonth(const Year: Integer; const Month: Word): Word; overload;
function DaysInMonth(const JulianDate: TJulianDate): Word; overload;

procedure DecDay(var Year: Integer; var Month, Day: Word); overload;
procedure DecDay(var Year: Integer; var Month, Day: Word; const Days: Integer); overload;

{ Deletes the contents of a directory, including itself is @code(DeleteItself) it True. }
function DeleteDirectoryW(Dir: WideString; const DeleteItself: Boolean = True): Boolean;
{ Deletes the contents of a directory, including itself is @code(DeleteItself) it True. }
function DeleteDirectoryA(Dir: AnsiString; const DeleteItself: Boolean = True): Boolean;

{ }
function DirectoryExistsA(const Dir: AnsiString): Boolean; overload;
{ }
function DirectoryExistsW(const Dir: WideString): Boolean; overload;

{ Returns the free disk space in bytes.
  Pass a path to a root directory or an UNC path name, e.g. "C:\" or
  "\\MyServer\MyShare\".
  <P>See also: @link(DiskFreeW), @link(ExtractFileDriveA). }
function DiskFreeA(const Dir: AnsiString): Int64;
{ Returns the free disk space in bytes.
  Pass a path to a root directory or an UNC path name, e.g. "C:\" or
  "\\MyServer\MyShare\".
  <P>See also: @link(DiskFreeA), @link(ExtractFileDriveW). }
function DiskFreeW(const Dir: WideString): Int64;

function EasterSunday(const Year: Integer): TJulianDate; overload;
procedure EasterSunday(const Year: Integer; out Month, Day: Word); overload;

{ }
procedure ExcludeTrailingPathDelimiterA(var s: AnsiString);
{ }
procedure ExcludeTrailingPathDelimiterW(var s: WideString);

{ Returns the drive portion of a fully qualified file name. For file names with
  drive letters, the result is in the form "<drive>:\". For file names with a
  UNC path the result is in the form "\\<servername>\<sharename>\". If the given
  path contains neither style of path prefix, the result is an empty string. }
function ExtractFileDriveA(const FileName: AnsiString): AnsiString;
{ Returns the drive portion of a fully qualified file name. For file names with
  drive letters, the result is in the form "<drive>:\". For file names with a
  UNC path the result is in the form "\\<servername>\<sharename>\". If the given
  path contains neither style of path prefix, the result is an empty string. }
function ExtractFileDriveW(const FileName: WideString): WideString;

{ }
function ExtractFileNameA(const FileName: AnsiString): AnsiString;
{ }
function ExtractFileNameW(const FileName: WideString): WideString;

{ Extracts the drive and directory parts of the given
  filename. The resulting string is the leftmost characters of FileName,
  up to and including the colon or backslash that separates the path
  information from the name and extension. The resulting string is empty
  if FileName contains no drive and directory parts. }
function ExtractFilePathA(const FileName: AnsiString): AnsiString;
{ Extracts the drive and directory parts of the given
  filename. The resulting string is the leftmost characters of FileName,
  up to and including the colon or backslash that separates the path
  information from the name and extension. The resulting string is empty
  if FileName contains no drive and directory parts. }
function ExtractFilePathW(const FileName: WideString): WideString;

{ @Name extracts and returns the next word from a string, starting at position
  @code(StartIndex). @code(StartIndex) also returns information if a word was
  extracted successfully:
  <P>@>=1: Word was successfully extracted, @code(StartIndex) points to the
  beginning of the next word.
  <BR>0: End of string is reached and no more words can be extracted.
  <BR>-1: An error occured (@code(StartIndex) > Length of string, etc.).
  <P>@Name may be called repeatedly in order to extract all words from a given
  string and performs much faster then repeated calls to @link(AnsiExtractWord). }
function ExtractNextWordA(const s: AnsiString; const Delimiters: TAnsiCharSet; var StartIndex: Integer): AnsiString;

{ Extracts the Number-th word from a string. Words are delimited by
  @Code(Delimiters), where each delimiter starts a new word. If two or more
  delimiters directly follow each other, empty strings will be returned.}
function ExtractWordA(const Number: Cardinal; const s: AnsiString; const Delimiters: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;

{ Extracts the first characters of each word in s, up to MaxCharCount and
  concatenates them to the result string.
  <P>Example: @Name@code(('This is a test', 2)) will result in 'Thisate'}
function ExtractWordStartsA(const s: AnsiString; const MaxCharCount: Cardinal; const WordSeparators: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;
{ Extracts the first characters of each word in s, up to MaxCharCount and
  concatenates them to the result string.
  <P>Example: @Name@code(('This is a test', 2)) will result in 'Thisate'}
function ExtractWordStartsW(const s: WideString; const MaxCharCount: Cardinal; const IsWordSep: TDIValidateWideCharFunc): WideString;

{ Returns a boolean value that indicates whether the specified file exists. }
function FileExistsA(const FileName: AnsiString): Boolean;
{ Returns a boolean value that indicates whether the specified file exists. }
function FileExistsW(const FileName: WideString): Boolean;

{ }
function FirstDayOfWeek(const JulianDate: TJulianDate): TJulianDate; overload;
{ }
procedure FirstDayOfWeek(var Year: Integer; var Month, Day: Word); overload;

{ }
function FirstDayOfMonth(const Julian: TJulianDate): TJulianDate; overload;
{ }
procedure FirstDayOfMonth(const Year: Integer; const Month: Word; out Day: Word); overload;

{ }
function ForceDirectoriesA(Dir: AnsiString): Boolean;
{ }
function ForceDirectoriesW(Dir: WideString): Boolean;

{$IFNDEF DELPHI_5_UP}
{ @abstract(Frees an object reference and replaces the reference with @nil.)
  Use @Name to ensure that a variable is nil after you free the object it
  references. Pass any variable that represents an object as the Obj parameter.
  <P>Warning: Do not pass a value for Obj if it is not an instance of TObject
  or one of its descendants. }
procedure FreeAndNil(var Obj);
{$ENDIF}

{ Returns the greatest common divisor (GCD) of the two
  supplied numbers. This is also sometimes referred to as the Highest
  Common Factor (HCF). The function is implemented using Euclid's algorithm. }
function GCD(const X, y: Cardinal): Cardinal;

{ }
function GetSpecialFolderA(const OwnerWindowHandle: HWND; const SpecialFolder: Integer): AnsiString;
{ }
function GetSpecialFolderW(const OwnerWindowHandle: HWND; const SpecialFolder: Integer): WideString;

{ }
function GetUserNameA(out UserNameA: AnsiString): Boolean;
{ }
function GetUserNameW(out UserNameW: WideString): Boolean;

{ Hashes the given Buffer. For repetitive hashes, pass the result to PreviousHash. }
function HashBuf(const Buffer; const BufferSize: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
{ @abstract(Hashes a buffer compsed of AnsiChars. )
  Calculates a hash value for a Buffer pointet to by @code(Buffer) with
  the length of @code(BufferSize) bytes. @Name is case insensitive. }
function HashBufIA(const Buffer; const AnsiCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
{ @abstract(Hashes a buffer composed of WideChars.)
  Calculates a hash value for a Buffer pointet to by @code(Buffer) with
  the length of @code(WideCharCount) WideChars. @Name is case insensitive. }
function HashBufIW(const Buffer; const WideCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;

{ @abstract(Hashes an AnsiString.)
  Calculates a hash value for an AnsiString. @Name is case sensitive. }
function HashStrA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;
{ }
function HashStrW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;

{ @abstract(Hashes an AnsiString.)
  Calculates a hash value for an AnsiString. @Name is case insensitive. }
function HashStrIA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;
{ }
function HashStrIW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;

{ }
function HexToIntA(const s: AnsiString): Integer;
{ }
function HexToIntW(const w: WideString): Integer;

{ }
procedure IncMonth(var Year: Integer; var Month, Day: Word); overload;
{ }
procedure IncMonth(var Year: Integer; var Month, Day: Word; const NumberOfMonths: Integer); overload;

{ }
procedure IncDay(var Year: Integer; var Month, Day: Word); overload;
{ }
procedure IncDay(var Year: Integer; var Month, Day: Word; const Days: Integer); overload;

{ }
procedure IncludeTrailingPathDelimiterByRef(var s: AnsiString); overload;
{ }
procedure IncludeTrailingPathDelimiterByRef(var w: WideString); overload;

{ Returns the hex representation of an integer number.
  <P>@Name converts a number into a string containing the number's
  hexadecimal (base 16) representation. @Code(Value) is the number to convert.
  @Code(Digits) indicates the number of hexadecimal digits to return. }
function IntToHexA(Value: Int64; Digits: Integer): AnsiString;
{ Returns the hex representation of an integer number.
  <P>@Name converts a number into a string containing the number's
  hexadecimal (base 16) representation. @Code(Value) is the number to convert.
  @Code(Digits) indicates the number of hexadecimal digits to return. }
function IntToHexW(Value: Int64; Digits: Integer): WideString;

{ @abstract(@Name converts an Integer to an AnsiString fast.)
  This @Name implementation is faster than
  the original Delphi @Name function found in SysUtils.pas. }
function IntToStrA(const I: Integer): AnsiString; overload;
{ }
function IntToStrA(const I: Int64): AnsiString; overload;

function IntToStrW(const I: Integer): WideString; overload;
{ }
function IntToStrW(const I: Int64): WideString; overload;

{ }
function IsCharDigitW(const c: WideChar): Boolean;
{ }
function IsCharHexDigitW(const c: WideChar): Boolean;
{ }
function IsCharLetterW(const c: WideChar): Boolean;
{ }
function IsCharLowerW(const c: WideChar): Boolean;
{ }
function IsCharTitleW(const c: WideChar): Boolean;
{ }
function IsCharUpperW(const c: WideChar): Boolean;

{ Verify that year, month, and day form a valid date. }
function IsDateValid(const Year: Integer; const Month, Day: Word): Boolean;

{ }
function IsHolidayInGermany(const Year: Integer; const Month, Day: Word): Boolean; overload;
{ }
function IsHolidayInGermany(const Julian: TJulianDate): Boolean; overload;

{ Determines whether the given year is a leap year. }
function IsLeapYear(const Year: Integer): Boolean;

{ }
function IsPathDelimiterA(const s: AnsiString; const Index: Cardinal): Boolean;
{ }
function IsPathDelimiterW(const w: WideString; const Index: Cardinal): Boolean;

{ }
function IsPointInRect(const Point: TPoint; const Rect: TRect): Boolean;

{ }
function ISODateToJulianDate(const ISODate: TIsoDate): TJulianDate;

{ }
procedure ISODateToYmd(const ISODate: TIsoDate; out Year: Integer; out Month, Day: Word);
{ }
function IsCharLowLineW(const c: WideChar): Boolean;
{ }
function IsCharQuoteW(const c: WideChar): Boolean;

{ Returns @True if either one or both of the Shift Keys
  is pressed down at the time this function executes. }
function IsShiftKeyDown: Boolean;

{ }
function IsCharWhiteSpaceW(const c: WideChar): Boolean;
{ }
function IsCharWhiteSpaceOrAmpersandW(const c: WideChar): Boolean;
{ }
function IsCharWhiteSpaceOrNoBreakSpaceW(const c: WideChar): Boolean;
{ }
function IsCharWhiteSpaceOrColonW(const c: WideChar): Boolean;
{ }
function IsCharWhiteSpaceOrGreaterThanSignW(const c: WideChar): Boolean;

{ Returns @True is a given string is empty or contains white space or
  control characters only. }
function IsStrEmptyA(const s: AnsiString): Boolean;
{ Returns @True is a given string is empty or contains white space or
  control characters only. }
function IsStrEmptyW(const w: WideString): Boolean;

{ }
function IsCharWordSeparatorW(const c: WideChar): Boolean;

{ Returns the week number of the week given date. The routine uses the ISO
  standard for determining the week which states that the first week of a year
  is the one that includes the first Thursday of that year. A week is defined
  as a seven day period within a calendar year which starts on Monday. }
function ISOWeekNumber(const JulianDate: TJulianDate): Word; overload;
{ Returns the week number of the week given the date. The routine uses the ISO
  standard for determining the week which states that the first week of a year
  is the one that includes the first Thursday of that year. A week is defined
  as a seven day period within a calendar year which starts on Monday. }
function ISOWeekNumber(const Year: Integer; const Month, Day: Word): Word; overload;
{ Returns a JulianDate for the date specified by Year, WeekOfYear, and DayOfWeek
  according to the ISO 8601 specification (0=Monday, 6=Sunday). }
function ISOWeekToJulianDate(const Year: Integer; const WeekOfYear, DayOfWeek: Word): TJulianDate;

{ Converts a Julian date to an ISO date number. }
function JulianDateToIsoDate(const Julian: TJulianDate): TIsoDate;
{ Converts a Julian date to an ISO date AnsiString. }
function JulianDateToIsoDateA(const Julian: TJulianDate): AnsiString;
{ Converts a Julian date to an ISO date WideString. }
function JulianDateToIsoDateW(const Julian: TJulianDate): WideString;

{ Convert a Julian date to the Gregorian calender's year, month, and day values. }
procedure JulianDateToYmd(const JulianDate: TJulianDate; out Year: Integer; out Month, Day: Word);

{ }
function LastDayOfMonth(const JulianDate: TJulianDate): TJulianDate; overload;
{ }
procedure LastDayOfMonth(const Year: Integer; const Month: Word; out Day: Word); overload;

{ }
function LastDayOfWeek(const JulianDate: TJulianDate): TJulianDate; overload;
{ }
procedure LastDayOfWeek(var Year: Integer; var Month, Day: Word); overload;

{ Returns a string representation of the @code(GetLastError) Windows API
  function. Uses @link(SysErrorMessageA) to convert the error code into
  a string. }
function LastSysErrorMessageA: AnsiString;
{ Returns a string representation of the @code(GetLastError) Windows API
  function. Uses @link(SysErrorMessageW) to convert the error code into
  a string. }
function LastSysErrorMessageW: WideString;

{ Returns the index of the leftmost set bit in Value. Bits are indexed
  from right to left, starting with 0 and ending with 31.
  If no bit is set in Value, @Name returns -1.
  <P>See also: @link(RightMostBit). }
function LeftMostBit(const Value: Cardinal): Integer;

{ }
function MakeMethod(const AData, ACode: Pointer): TMethod;

{ @Name returns the greater of two numeric values. }
function Max(const a, b: Integer): Integer; overload;
{ @Name returns the greater of two numeric values. }
function Max(const a, b: Cardinal): Cardinal; overload;

{ @Name returns the lesser of two numeric values. }
function Min(const a, b: Integer): Integer; overload;
{ @Name returns the lesser of two numeric values. }
function Min(const a, b: Cardinal): Cardinal; overload;

function MonthOfJulianDate(const JulianDate: TJulianDate): Word;

{ Appends characters (c) to left of Source as required to increase length to Count. }
function PadLeftA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;
{ Appends characters (c) to left of Source as required to increase length to Count. }
function PadLeftW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;

{ Appends characters (c) to right of Source as required to increase length to Count. }
function PadRightA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;
{ Appends characters (c) to right of Source as required to increase length to Count. }
function PadRightW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;

{ }
function ProperCaseA(const s: AnsiString): AnsiString; overload;
{ }
function ProperCaseW(const w: WideString): WideString; overload;

{ Upper case the first character in each word and lower case all other characters. }
procedure ProperCaseByRef(var s: AnsiString); overload;
{ Upper case the first character in each word and lower case all other characters. }
procedure ProperCaseByRef(var w: WideString); overload;

{ }
function RegReadRegisteredOrganizationA: AnsiString;
{ }
function RegReadRegisteredOrganizationW: WideString;
{ }
function RegReadRegisteredOwnerA: AnsiString;
{ }
function RegReadRegisteredOwnerW: WideString;

{ }
function RegReadStrDefA(const Key: HKEY; const SubKey, ValueName, Default: AnsiString): AnsiString;
{ }
function RegReadStrDefW(const Key: HKEY; const SubKey, ValueName, Default: WideString): WideString;

{ Repeatedly searches Source for FromString followed by ToString and removes all
  characters from the beginning of FromString up to the end of ToString from it.
  <P>@Name can be used, for example, to remove all image tags from a HTML string
  with the following command:
  <P>&nbsp;&nbsp;@Name(MyHtmlString,'@<IMG', '@>') }
procedure StrRemoveFromToIA(var Source: AnsiString; const FromString, ToString: AnsiString);
{ Repeatedly searches Source for FromString followed by ToString and removes all
  characters from the beginning of FromString up to the end of ToString from it.
  <P>@Name can be used, for example, to remove all image tags from a HTML string
  with the following command:
  <P>&nbsp;&nbsp;@Name(MyHtmlString,'@<IMG', '@>') }
procedure StrRemoveFromToIW(var Source: WideString; const FromString, ToString: WideString);

{ Removes single SpaceChars from string s and compresses multiple SpaceChars
  to one single ReplaceChar. @Name assumes words to be separated by at least two
  SpaceChars, like in the following example:
  <P>@code('D e l p h i  I n s p i r a t i o n' --> 'Delphi Inspiration').
  <P>The comparison is case-sensitive. }
procedure StrRemoveSpacing(var s: AnsiString; const SpaceChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE); overload;
{ Removes single SpaceChars from string s and compresses multiple SpaceChars
  to one single ReplaceChar. @Name assumes words to be separated by at least two
  SpaceChars, like in the following example:
  <P>@code('D e l p h i  I n s p i r a t i o n' --> 'Delphi Inspiration').
  <P>The comparison is case-sensitive. }
procedure StrRemoveSpacing(var w: WideString; IsSpaceChar: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE); overload;

{ Replaces all characters SearchChar in Source with character ReplaceChar.
  The comparison is case sensitive. }
procedure StrReplaceCharA(var Source: AnsiString; const SearchChar, ReplaceChar: AnsiChar);

{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched once and all occurrences of Search will be replaced. The comparison
  operation is case sensitive. }
function StrReplaceA(const Source, Search, Replace: AnsiString): AnsiString;
{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched once and all occurrences of Search will be replaced. The comparison
  operation is case sensitive. }
function StrReplaceW(const Source, Search, Replace: WideString): WideString;

{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched once and all occurrences of Search will be replaced. The comparison
  operation is case insensitive. }
function StrReplaceIA(const Source, Search, Replace: AnsiString): AnsiString;
{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched once and all occurrences of Search will be replaced. The comparison
  operation is case insensitive. }
function StrReplaceIW(const Source, Search, Replace: WideString): WideString;

{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched multiple times until all occurrences of Search will have been
  replaced and search is not any longer found in Source.
  The comparison operation is case sensitive. }
function StrReplaceLoopA(const Source, Search, Replace: AnsiString): AnsiString;
{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched multiple times until all occurrences of Search will have been
  replaced and search is not any longer found in Source.
  The comparison operation is case sensitive. }
function StrReplaceLoopW(const Source, Search, Replace: WideString): WideString;

{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched multiple times until all occurrences of Search will have been
  replaced and search is not any longer found in Source.
  The comparison operation is case insensitive. }
function StrReplaceLoopIA(const Source, Search, Replace: AnsiString): AnsiString;
{ Returns a string with occurrences of one substring replaced by another
  substring. @Name replaces all occurrences of the substring specified by
  Search with the substring specified by Replace. The entire string will be
  searched multiple times until all occurrences of Search will have been
  replaced and search is not any longer found in Source.
  The comparison operation is case insensitive. }
function StrReplaceLoopIW(const Source, Search, Replace: WideString): WideString;

{ Returns the index of the rightmost set bit in Value. Bits are indexed
  from right to left, starting with 0 and ending with 31.
  If no bit is set in Value, @Name returns -1.
  <P>See also: @link(LeftMostBit). }
function RightMostBit(const Value: Cardinal): Integer;

{ Loads a string @code(s) from file @code(FileName). Returns @True on success,
  @False otherwise. }
function LoadStrFromFileA(const FileName: AnsiString; var s: AnsiString): Boolean; overload;

{ Loads a string @code(s) from file @code(FileName). Returns @True on success,
  @False otherwise. }
function LoadStrFromFileW(const FileName: WideString; var s: AnsiString): Boolean; overload;

{ Loads a string @code(s) from file @code(FileName). Returns @True on success,
  @False otherwise. }
function LoadStrFromFileA(const FileName: AnsiString; var s: WideString): Boolean; overload;

{ Loads a string @code(s) from file @code(FileName). Returns @True on success,
  @False otherwise. }
function LoadStrFromFileW(const FileName: WideString; var s: WideString): Boolean; overload;

{ Writes @code(BufferSize) bytes of @code(Buffer) to the file specified by
  @code(FileHandle). Returns the number of bytes written. }
function SaveBufToFile(const Buffer; const BufferSize: Cardinal; const FileHandle: THandle): Boolean;
{ }
function SaveBufToFileA(const Buffer; const BufferSize: Cardinal; const FileName: AnsiString): Boolean;
{ }
function SaveBufToFileW(const Buffer; const BufferSize: Cardinal; const FileName: WideString): Boolean;

{ }
function SaveAStrToFileA(const s: AnsiString; const FileName: AnsiString): Boolean;
{ }
function SaveAStrToFileW(const s: AnsiString; const FileName: WideString): Boolean;

{ }
function SaveWStrToFileA(const w: WideString; const FileName: AnsiString): Boolean;
{ }
function SaveWStrToFileW(const w: WideString; const FileName: WideString): Boolean;

{ Forward scan from Start looking for next matching character (c).
  Returns: Position where/if found; otherwise, 0. }
function StrPosCharA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Cardinal;

{ Scans the Buffer for the first Character in set Search.
  The comparison is not based on the current locale and is case-sensitive. }
function StrPosCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;

{ Scans the Buffer for the first Character that validates.
  The comparison is not based on the current locale and is case-sensitive. }
function StrPosCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;

{ Backward/reverse scan from Start location (1 = First Char., 0 = String End)
  looking for single character, c. Returns: Position where/if found; otherwise, 0. }
function StrPosCharBackA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 0): Cardinal;

{ Backward/reverse scan from Start location (1 = First Char., 0 = String End)
  looking for first char in set Search. Returns: Position where/if found;
  otherwise, 0. }
function StrPosCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;

{ Forward scan from Start looking for next matching character not in set Search.
  Returns: Position where/if found; otherwise, 0. }
function StrPosNotCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;
{ Forward scan from Start looking for next character that validates.
  Returns: Position where/if found; otherwise, 0. }
function StrPosNotCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;

{ Backward/reverse scan from Start location (1 = First Char., 0 = String End)
  looking for first char not in set Search. Returns: Position where/if found;
  otherwise, 0. }
function StrPosNotCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;

{ }
function SetFileDate(const FileHandle: THandle; const Year: Integer; const Month, Day: Word): Boolean;

{ }
function SetFileDateA(const FileName: AnsiString; const JulianDate: TJulianDate): Boolean; overload;
{ }
function SetFileDateA(const FileName: AnsiString; const Year: Integer; const Month, Day: Word): Boolean; overload;

{ }
function SetFileDateW(const FileName: WideString; const JulianDate: TJulianDate): Boolean; overload;
{ }
function SetFileDateW(const FileName: WideString; const Year: Integer; const Month, Day: Word): Boolean; overload;

{ @abstract(Compares two strings case sensitively.)
  @Name compares s1 to s2, with case-sensitivity.
  The return value is less than 0 if s1 is less than s2,
  0 if s1 equals s2, or greater than 0 if s1 is greater than s2.
  The compare operation is based on the 8-bit ordinal value of each
  character and is not affected by the current Windows locale.
  <P>Thus for example, @Name will indicate that the string 'ABC' is less than
  'aaa' because 'A' is less than 'a' in ANSI order. This is in contrast
  to a case-insensitive comparison, where the 'B' would make the first string
  larger, or a locale-based comparison (most locales consider capital letters
  larger than small).
  <P>See also: @link(AnsiCompareCI). }
function StrCompA(const S1, S2: AnsiString): Integer;
{ @abstract(Compares two WideStrings with case sensitivity.)
  The return value is less than 0 if s1 is less than s2,
  0 if s1 equals s2, or greater than 0 if s1 is greater than s2.
  <P>The compare operation is based on the 16-bit ordinal value of each
  character and is not affected by the current language locale.
  <P>Thus for example, @Name will indicate that the string 'ABC' is less than
  'aaa' because 'A' is less than 'a' in Unicode order. This is in contrast
  to a case-insensitive comparison, where the 'B' would make the first string
  larger, or a locale-based comparison (most locales consider capital letters
  larger than small letters).
  <P>See also: @link(WideCompareCI). }
function StrCompW(const S1, S2: WideString): Integer;

{ @abstract(Compares two strings by ordinal value without case sensitivity.)
  @Name compares s1 and s2 and returns 0 if they are equal.
  If s1 is greater than s2, @Name returns an integer greater than 0.
  If s1 is less than s2, @Name returns an integer less than 0.
  @Name is not case sensitive and is not affected by the current Windows locale.
  <P>See also: @link(AnsiCompareCS). }
function StrCompIA(const S1, S2: AnsiString): Integer;
{ @abstract(Compares two WideStrings without case sensitivity.)
  The return value is less than 0 if s1 is less than s2,
  0 if s1 equals s2, or greater than 0 if s1 is greater than s2.
  <P>The compare operation is based on the case-folded 16-bit ordinal value
  of each character and is not affected by the current language locale.
  <P>See also: @link(AnsiCompareCS). }
function StrCompIW(const S1, S2: WideString): Integer;

{ Returns @True if string @code(w) contains character @code(c), @False otherwise. }
function StrContainsCharA(const s: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Boolean;
{ Returns @True if string @code(w) contains character @code(c), @False otherwise. }
function StrContainsCharW(const w: WideString; const c: WideChar; const Start: Cardinal = 1): Boolean;
{ }
function StrContainsCharsW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;
{ }
function StrContainsCharsOnlyW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;

{ Compares two Strings and returns @True if both strings are equal.
  The comparison is not based on the current locale and is case-sensitive. }
function StrSameA(const S1, S2: AnsiString): Boolean;
{ Compares two Strings and returns @True if both strings are equal.
  The comparison is not based on the current locale and is case-sensitive. }
function StrSameW(const S1, S2: WideString): Boolean;

{ Compares two AnsiStrings and returns @True if both strings are equal.
  The comparison is not based on the current locale and is case-insensitive. }
function StrSameIA(const S1, S2: AnsiString): Boolean;
{ Compares two AnsiStrings and returns @True if both strings are equal.
  The comparison is not based on the current locale and is case-insensitive. }
function StrSameIW(const S1, S2: WideString): Boolean;

{ Compares the characters of two strings until the end of the shorter string
  is reached. Returns @True if the characters up to that point are equal.
  The comparison is case-sensitive. }
function StrSameStartA(const S1, S2: AnsiString): Boolean;
{ Compares the characters of two strings until the end of the shorter string
  is reached. Returns @True if the characters up to that point are equal.
  The comparison is case-sensitive. }
function StrSameStartW(const w1, w2: WideString): Boolean;

{ Compares the characters of two strings until the end of the shorter string
  is reached. Returns @True if the characters up to that point are equal.
  The comparison is case-insensitive. }
function StrSameStartIA(const S1, S2: AnsiString): Boolean;
{ Compares the characters of two strings until the end of the shorter string
  is reached. Returns @True if the characters up to that point are equal.
  The comparison is case-insensitive. }
function StrSameStartIW(const w1, w2: WideString): Boolean;

{ Counts how many times the character @code(c) occurs in string @code(Source).
  Counting starts at position @code(StartIndex) and continues up to the end
  of @code(Source). The comparison is case-sensitive. }
function StrCountCharA(const Source: AnsiString; const c: AnsiChar; const StartIndex: Cardinal = 1): Cardinal;
{ Counts how many times the character @code(c) occurs in string @code(Source).
  Counting starts at position @code(StartIndex) and continues up to the end
  of @code(Source). The comparison is case-sensitive. }
function StrCountCharW(const Source: WideString; const c: WideChar; const StartIndex: Cardinal = 1): Cardinal;

{ Returns a string that is a copy of the given string converted to lower case.
  The conversion does not use the current locale. }
function StrToLowerA(const s: AnsiString): AnsiString;

{ Matches Search against Source starting at position Start.
  Comparison is not based on the current locale and is case-sensitive. }
function StrMatchesA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;

{ Matches Search against Source starting at position Start.
  Comparison is not based on the current locale and is case-insensitive. }
function StrMatchesIA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;

{ Indicates whether Source string conforms to the format specified by Mask.
  <P>Each literal character must match a single character in the string.
  The comparison to literal characters is case-sensitive.
  <P>Wildcards are WildChar (*) and MaskChar (?). A WildChar matches any
  number of characters. A MaskChar matches a single arbitrary character.
  <P>@Name returns @True if the string matches the mask and @False if it doesn't. }
function StrMatchWildA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;

{ Indicates whether Source string conforms to the format specified by Mask.
  <P>Each literal character must match a single character in the string.
  The comparison to literal characters is case-insensitive.
  <P>Wildcards are WildChar (*) and MaskChar (?). A WildChar matches any
  number of characters. A MaskChar matches a single arbitrary character.
  <P>@Name returns @True if the string matches the mask and @False if it doesn't. }
function StrMatchWildIA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;

{ Searches for a substring, Search, in a string, Source, and returns
  a cardinal value that is the index of the first character of Search within
  Source. @Name starts searching at the beginning of Source and is
  case-sensitive. If Search is not found, @Name returns zero.}
function StrPosA(const Search, Source: AnsiString; const Start: Cardinal = 1): Cardinal;
{ Searches for a substring, Search, in a string, Source, and returns
  a cardinal value that is the index of the first character of Search within
  Source. @Name starts searching at the beginning of Source and is
  case-sensitive. If Search is not found, @Name returns zero.}
function StrPosW(const Search, Source: WideString; const StartPos: Cardinal = 1): Cardinal;

{ @Name searches for a substring, Search, in a string, Source, and returns
  a cardinal value that is the index of the first character of Search within
  Source. @Name starts searching at the beginning of Source and is
  case-insensitive. If Search is not found, @Name returns zero.}
function StrPosIA(const Search, Source: AnsiString; const StartPos: Cardinal = 1): Cardinal;
{ @Name searches for a substring, Search, in a string, Source, and returns
  a cardinal value that is the index of the first character of Search within
  Source. @Name starts searching at the beginning of Source and is
  case-insensitive. If Search is not found, @Name returns zero.}
function StrPosIW(const Search, Source: WideString; const StartPos: Cardinal = 1): Cardinal;

{ @Name searches for a substring, Search, in a string, Source, and returns
  a cardinal value that is the index of the first character of Search within
  Source. @Name starts searching at the end of Source and is
  case-sensitive. If Search is not found, @Name returns zero.}
function StrPosBackA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;

{ @Name searches for a substring, Search, in a string, Source, and returns
  a cardinal value that is the index of the first character of Search within
  Source. @Name starts searching at the end of Source and is
  case-insensitive. If Search is not found, @Name returns zero.}
function StrPosBackIA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;

{ }
function StrToIntDefW(const w: WideString; const Default: Integer): Integer;
{ }
function StrToInt64DefW(const w: WideString; const Default: Int64): Int64;

{ Returns a string that is a copy of the given string converted to upper case.
  The conversion does not use the current locale. }
function StrToUpperA(const s: AnsiString): AnsiString;

{ Returns an error message string that corresponds to the specified
  Win32 API error code. It is a wrapper around the FormatMessageA Windows API
  function. @Name can be used to convert Windows error codes into strings. }
function SysErrorMessageA(const MessageID: Cardinal): AnsiString;
{ Returns an error message string that corresponds to the specified
  Win32 API error code. It is a wrapper around the FormatMessageW Windows API
  function. @Name can be used to convert Windows error codes into strings. }
function SysErrorMessageW(const MessageID: Cardinal): WideString;
{ }
function TextHeightW(const DC: HDC; const Text: WideString): Integer;

{ }
function TextWidthW(const DC: HDC; const Text: WideString): Integer;

{ }
function TrimA(const Source: AnsiString): AnsiString; overload;
{ Trims leading and trailing characters c from a string.
  Comparison of characters is case-sensitive.}
function TrimA(const Source: AnsiString; const CharToTrim: AnsiChar): AnsiString; overload;
{ Trims leading and trailing characters in set s from a string.
  Comparison of characters is case-sensitive.}
function TrimA(const Source: AnsiString; const CharsToTrim: TAnsiCharSet): AnsiString; overload;

{ }
function TrimW(const w: WideString): WideString; overload;
{ }
function TrimW(const w: WideString; const IsCharToTrim: TDIValidateWideCharFunc): WideString; overload;

{ Trims leading characters in set Chars from string s.
  The comparison is case-sensitive. }
procedure TrimLeftByRefA(var s: AnsiString; const Chars: TAnsiCharSet);

{ Trims trailing characters in set s from a string and returns the result.
  Comparison of characters is case-sensitive. }
function TrimRightA(const Source: AnsiString; const s: TAnsiCharSet): AnsiString;

{ Trims trailing characters in set s from a string.
  Comparison of characters is case-sensitive. }
procedure TrimRightByRefA(var Source: AnsiString; const s: TAnsiCharSet);

{ Removes CharsToCompress from beginning and end of string. Also compresses all
  occurances of multiple CharsToCompress and replaces them with on ReplaceBy
  character. }
procedure TrimCompress(var s: AnsiString; const TrimCompressChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE); overload;
{ Removes CharsToCompress from beginning and end of string. Also compresses all
  occurances of multiple CharsToCompress and replaces them with the ReplaceBy
  character. }
procedure TrimCompress(var w: WideString; Validate: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE); overload;

{ }
procedure TrimRightByRefW(var w: WideString; Validate: TDIValidateWideCharFunc = nil);

{ }
function TryStrToIntW(const w: WideString; out Value: Integer): Boolean;
{ }
function TryStrToInt64W(const w: WideString; out Value: Int64): Boolean;

{ @Name updates the CRC32 value by the contents of the given memory buffer.
  <P>This is the the core Crc32 routine called by all other Crc32 functions. }
function UpdateCrc32OfBuf(const Crc32: Cardinal; const Buffer; const BufferSize: Cardinal): Cardinal;

{ @Name updates the CRC32 value by the contents of the given AnsiString. }
function UpdateCrc32OfStrA(const Crc32: Cardinal; const s: AnsiString): Cardinal;

{ @Name updates the CRC32 value by the contents of the given WideString. }
function UpdateCrc32OfStrW(const Crc32: Cardinal; const w: WideString): Cardinal;

{ Converts a buffer of WideChars to an AnsiString. }
function WBufToAStr(const Buffer: PWideChar; const WideCharCount: Cardinal; const CodePage: Word = CP_ACP): AnsiString;

{ Converts a WideString to an AnsiString. }
function WStrToAStr(const s: WideString; const CodePage: Word = CP_ACP): AnsiString;

{ }
function ValIntW(const w: WideString; out Code: Integer): Integer;
{ }
function ValInt64W(const w: WideString; out Code: Integer): Int64;

{ }
function YearOfJuilanDate(const JulianDate: TJulianDate): Integer;

{ }
function YmdToIsoDate(const Year: Integer; const Month, Day: Word): TIsoDate;
{ }
function YmdToIsoDateA(const Year: Integer; const Month, Day: Word): AnsiString;
{ }
function YmdToIsoDateW(const Year: Integer; const Month, Day: Word): WideString;
{ Convert a Gregorian calender's year, month, and day values to a Julian day. }
function YmdToJulianDate(const Year: Integer; const Month, Day: Word): TJulianDate;

{ Fills Size contiguous bytes with 0 (zero).
  <P>Warning: This function does not perform any range checking. }
procedure ZeroMem(const Buffer; const Size: Cardinal);

{ ---------------------------------------------------------------------------- }
{ Date & Time: Types and Constants                                             }
{ ---------------------------------------------------------------------------- }

type
  { }
  PDIDayTable = ^TDIDayTable;
  TDIDayTable = array[1..12] of Word;

  PDIMonthTable = ^TDIMonthTable;
  TDIMonthTable = array[1..12] of Word;

  PDIQuarterTable = ^TDIQuarterTable;
  TDIQuarterTable = array[1..4] of Word;

const
  ISO_MONDAY = 0;
  ISO_TUESDAY = 1;
  ISO_WEDNESDAY = 2;
  ISO_THURSDAY = 3;
  ISO_FRIDAY = 4;
  ISO_SATURDAY = 5;
  ISO_SUNDAY = 6;

  SHORT_DAY_NAMES_GERMAN_A: array[0..6] of AnsiString =
  ('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So');
  SHORT_DAY_NAMES_GERMAN_W: array[0..6] of WideString =
  ('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So');

  DAYS_IN_MONTH: array[Boolean] of TDIDayTable = (
    (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));
  QUARTER_OF_MONTH: TDIMonthTable =
  (1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4);
  HALF_YEAR_OF_MONTH: TDIMonthTable =
  (1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2);
  HALF_YEAR_OF_QUARTER: TDIQuarterTable =
  (1, 1, 2, 2);

  { Table of corresponding Ansi lower characters.
  @Name['A'] returns 'a'. }
  ANSI_LOWER_CHAR_TABLE: array[#0..#255] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #091, #092, #093, #094, #095,
    #096, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #154, #139, #156, #141, #158, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #154, #155, #156, #157, #158, #255,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #215, #248, #249, #250, #251, #252, #253, #254, #223,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #247, #248, #249, #250, #251, #252, #253, #254, #255);

  { Table of corresponding Ansi upper characters.
    @Name['a'] returns 'A'.}
  ANSI_UPPER_CHAR_TABLE: array[#0..#255] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #091, #092, #093, #094, #095,
    #096, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #138, #139, #140, #141, #142, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #138, #155, #140, #157, #142, #159,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #215, #216, #217, #218, #219, #220, #221, #222, #223,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #247, #216, #217, #218, #219, #220, #221, #222, #159);

  { Table of corresponding Ansi reverse characters.
    @Name['A'] returns 'a' and @Name['a'] returns 'A'.}
  ANSI_REVERSE_CHAR_TABLE: array[#0..#255] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #091, #092, #093, #094, #095,
    #096, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #154, #139, #156, #141, #158, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #138, #155, #140, #157, #142, #255,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #215, #248, #249, #250, #251, #252, #253, #254, #223,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #247, #216, #217, #218, #219, #220, #221, #222, #159);

  CRC_32_INIT = $FFFFFFFF;

  CRC_32_TABLE: array[Byte] of Cardinal = (
    $000000000, $077073096, $0EE0E612C, $0990951BA, $0076DC419, $0706AF48F,
    $0E963A535, $09E6495A3, $00EDB8832, $079DCB8A4, $0E0D5E91E, $097D2D988,
    $009B64C2B, $07EB17CBD, $0E7B82D07, $090BF1D91, $01DB71064, $06AB020F2,
    $0F3B97148, $084BE41DE, $01ADAD47D, $06DDDE4EB, $0F4D4B551, $083D385C7,
    $0136C9856, $0646BA8C0, $0FD62F97A, $08A65C9EC, $014015C4F, $063066CD9,
    $0FA0F3D63, $08D080DF5, $03B6E20C8, $04C69105E, $0D56041E4, $0A2677172,
    $03C03E4D1, $04B04D447, $0D20D85FD, $0A50AB56B, $035B5A8FA, $042B2986C,
    $0DBBBC9D6, $0ACBCF940, $032D86CE3, $045DF5C75, $0DCD60DCF, $0ABD13D59,
    $026D930AC, $051DE003A, $0C8D75180, $0BFD06116, $021B4F4B5, $056B3C423,
    $0CFBA9599, $0B8BDA50F, $02802B89E, $05F058808, $0C60CD9B2, $0B10BE924,
    $02F6F7C87, $058684C11, $0C1611DAB, $0B6662D3D, $076DC4190, $001DB7106,
    $098D220BC, $0EFD5102A, $071B18589, $006B6B51F, $09FBFE4A5, $0E8B8D433,
    $07807C9A2, $00F00F934, $09609A88E, $0E10E9818, $07F6A0DBB, $0086D3D2D,
    $091646C97, $0E6635C01, $06B6B51F4, $01C6C6162, $0856530D8, $0F262004E,
    $06C0695ED, $01B01A57B, $08208F4C1, $0F50FC457, $065B0D9C6, $012B7E950,
    $08BBEB8EA, $0FCB9887C, $062DD1DDF, $015DA2D49, $08CD37CF3, $0FBD44C65,
    $04DB26158, $03AB551CE, $0A3BC0074, $0D4BB30E2, $04ADFA541, $03DD895D7,
    $0A4D1C46D, $0D3D6F4FB, $04369E96A, $0346ED9FC, $0AD678846, $0DA60B8D0,
    $044042D73, $033031DE5, $0AA0A4C5F, $0DD0D7CC9, $05005713C, $0270241AA,
    $0BE0B1010, $0C90C2086, $05768B525, $0206F85B3, $0B966D409, $0CE61E49F,
    $05EDEF90E, $029D9C998, $0B0D09822, $0C7D7A8B4, $059B33D17, $02EB40D81,
    $0B7BD5C3B, $0C0BA6CAD, $0EDB88320, $09ABFB3B6, $003B6E20C, $074B1D29A,
    $0EAD54739, $09DD277AF, $004DB2615, $073DC1683, $0E3630B12, $094643B84,
    $00D6D6A3E, $07A6A5AA8, $0E40ECF0B, $09309FF9D, $00A00AE27, $07D079EB1,
    $0F00F9344, $08708A3D2, $01E01F268, $06906C2FE, $0F762575D, $0806567CB,
    $0196C3671, $06E6B06E7, $0FED41B76, $089D32BE0, $010DA7A5A, $067DD4ACC,
    $0F9B9DF6F, $08EBEEFF9, $017B7BE43, $060B08ED5, $0D6D6A3E8, $0A1D1937E,
    $038D8C2C4, $04FDFF252, $0D1BB67F1, $0A6BC5767, $03FB506DD, $048B2364B,
    $0D80D2BDA, $0AF0A1B4C, $036034AF6, $041047A60, $0DF60EFC3, $0A867DF55,
    $0316E8EEF, $04669BE79, $0CB61B38C, $0BC66831A, $0256FD2A0, $05268E236,
    $0CC0C7795, $0BB0B4703, $0220216B9, $05505262F, $0C5BA3BBE, $0B2BD0B28,
    $02BB45A92, $05CB36A04, $0C2D7FFA7, $0B5D0CF31, $02CD99E8B, $05BDEAE1D,
    $09B64C2B0, $0EC63F226, $0756AA39C, $0026D930A, $09C0906A9, $0EB0E363F,
    $072076785, $005005713, $095BF4A82, $0E2B87A14, $07BB12BAE, $00CB61B38,
    $092D28E9B, $0E5D5BE0D, $07CDCEFB7, $00BDBDF21, $086D3D2D4, $0F1D4E242,
    $068DDB3F8, $01FDA836E, $081BE16CD, $0F6B9265B, $06FB077E1, $018B74777,
    $088085AE6, $0FF0F6A70, $066063BCA, $011010B5C, $08F659EFF, $0F862AE69,
    $0616BFFD3, $0166CCF45, $0A00AE278, $0D70DD2EE, $04E048354, $03903B3C2,
    $0A7672661, $0D06016F7, $04969474D, $03E6E77DB, $0AED16A4A, $0D9D65ADC,
    $040DF0B66, $037D83BF0, $0A9BCAE53, $0DEBB9EC5, $047B2CF7F, $030B5FFE9,
    $0BDBDF21C, $0CABAC28A, $053B39330, $024B4A3A6, $0BAD03605, $0CDD70693,
    $054DE5729, $023D967BF, $0B3667A2E, $0C4614AB8, $05D681B02, $02A6F2B94,
    $0B40BBE37, $0C30C8EA1, $05A05DF1B, $02D02EF8D
    );

  {$IFNDEF DI_No_Win_9X_Support}
var
  IsUnicode: Boolean;
  {$ENDIF}

implementation

uses
  ShellAPI;

{ ---------------------------------------------------------------------------- }
{ Class TMT19937
{ ---------------------------------------------------------------------------- }

constructor TMT19937.Create(const Seed: Cardinal);
begin
  init_genrand(Seed);
end;

{ ---------------------------------------------------------------------------- }

constructor TMT19937.Create(const Seeds: array of Cardinal);
begin
  init_by_array(Seeds);
end;

{ ---------------------------------------------------------------------------- }

procedure TMT19937.init_genrand(const Seed: Cardinal);
var
  j: Cardinal;
begin
  FState[0] := Seed { and $FFFFFFFF };
  j := 1;
  while j < MT19937_N do
    begin
      FState[j] := (1812433253 * (FState[j - 1] xor (FState[j - 1] shr 30)) + j);
      { FState[j] := FState[j] and $FFFFFFFF; }
      Inc(j);
    end;
  FLeft := 1;
  FInit := True;
end;

{ ---------------------------------------------------------------------------- }

procedure TMT19937.init_by_array(const Seeds: array of Cardinal);
var
  I, j, key_length: Cardinal;
  k: Integer;
begin
  init_genrand(19650218);
  I := 1;
  j := 0;

  key_length := High(Seeds) - Low(Seeds);
  k := key_length;
  if k < MT19937_N then k := MT19937_N;

  while k > 0 do
    begin
      Dec(k);
      FState[I] := (FState[I] xor ((FState[I - 1] xor (FState[I - 1] shr 30)) * 1664525)) + Seeds[j] + j;
      { FState[i] := FState[i] and $FFFFFFFF; }
      Inc(I);
      Inc(j);
      if I >= MT19937_N then
        begin
          FState[0] := FState[MT19937_N - 1];
          I := 1;
        end;
      if j > key_length then
        j := 0;
    end;

  k := MT19937_N - 1;
  while k > 0 do
    begin
      Dec(k);
      FState[I] := (FState[I] xor ((FState[I - 1] xor (FState[I - 1] shr 30)) * 1566083941)) - I;
      { FState[i] := FState[i] and $FFFFFFFF; }
      Inc(I);
      if I >= MT19937_N then
        begin
          FState[0] := FState[MT19937_N - 1];
          I := 1;
        end;
    end;

  FState[0] := $80000000;
  FLeft := 1;
  FInit := True;
end;

{ ---------------------------------------------------------------------------- }

procedure TMT19937.next_state;
type
  TMT19937Array = array[-MT19937_N..MT19937_N] of Cardinal; // Trick to make the compiler accept negative array indexes.
  PMT19937Array = ^TMT19937Array;
const
  UMASK = $80000000; // most significant w-r bits.
  LMASK = $7FFFFFFF; // least significant r bits.
  MATRIX_A = $9908B0DF; // constant vector.
var
  p: PMT19937Array;
  j, X: Cardinal;
begin
  if not FInit then init_genrand(5489);

  p := PMT19937Array(@FState);
  Dec(Cardinal(p), MT19937_N * 4); // Trick to make the compiler accept negative array indexes.

  FLeft := MT19937_N;
  FNext := Pointer(@FState);

  j := MT19937_N - MT19937_M; // + 1 deleted in Pascal translation.
  repeat
    X := p^[MT19937_M] xor (((p^[0] and UMASK) or (p^[1] and LMASK)) shr 1);
    if p^[1] and 1 <> 0 then
      p^[0] := X xor MATRIX_A
    else
      p^[0] := X xor 0;
    Inc(Cardinal(p), 4);
    Dec(j);
  until j = 0;

  j := MT19937_M - 1; // -1 inserted in Pascal translation.
  repeat
    X := p^[MT19937_M - MT19937_N] xor (((p^[0] and UMASK) or (p^[1] and LMASK)) shr 1);
    if p^[1] and 1 <> 0 then
      p^[0] := X xor MATRIX_A
    else
      p^[0] := X xor 0;
    Inc(Cardinal(p), 4);
    Dec(j);
  until j = 0;

  X := p^[MT19937_M - MT19937_N] xor (((p^[0] and UMASK) or (p^[1] and LMASK)) shr 1);
  if FState[0] and 1 <> 0 then
    p^[0] := X xor MATRIX_A
  else
    p^[0] := X xor 0;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_int32: Cardinal;
begin
  Dec(FLeft);
  if FLeft = 0 then next_state;
  Result := FNext^;
  Inc(FNext);
  Result := Result xor (Result shr 11);
  Result := Result xor ((Result shl 7) and $9D2C5680);
  Result := Result xor ((Result shl 15) and $EFC60000);
  Result := Result xor (Result shr 18);
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_int31: Integer;
begin
  Result := genrand_int32 shr 1;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_int64: Int64;
type
  TInt64Rec = packed record Lo, Hi: Cardinal; end;
begin
  with TInt64Rec(Result) do
    begin
      Lo := genrand_int32;
      Hi := genrand_int32;
    end;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_int63: Int64;
type
  TInt64Rec = packed record Lo, Hi: Cardinal; end;
begin
  with TInt64Rec(Result) do
    begin
      Lo := genrand_int32;
      Hi := genrand_int32 shr 1;
    end;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_real1: Double;
begin
  Result := genrand_int32 / 4294967295;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_real2: Double;
begin
  Result := genrand_int32 / 4294967296;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_real3: Double;
begin
  Result := (genrand_int32 + 0.5) / 4294967296;
end;

{ ---------------------------------------------------------------------------- }

function TMT19937.genrand_res53;
var
  a, b: Cardinal;
begin
  a := genrand_int32 shr 5;
  b := genrand_int32 shr 6;
  Result := (a * 67108864 + b) / 9007199254740992;
end;

{ ---------------------------------------------------------------------------- }
{ Include Files
{ ---------------------------------------------------------------------------- }

{$I DIIsCharLetterW.inc}
{$I DIIsCharLowerW.inc}
{$I DIIsCharUpperW.inc}
{$I DIIsCharTitleW.inc}

{$I DICharToCaseFoldW.inc}
{$I DICharToLowerW.inc}
{$I DICharToUpperW.inc}
{$I DICharToTitleW.inc}

{ ---------------------------------------------------------------------------- }
{ Local Functions & Procedures
{ ---------------------------------------------------------------------------- }

function InternalGetDiskSpaceW(Drive: WideChar; var TotalSpace, FreeSpaceAvailable: Int64): BOOL;
var
  RootPath: array[0..3] of WideChar;
  RootPtr: PWideChar;
begin
  RootPtr := nil;
  if Drive > WC_NULL then
    begin
      RootPath[0] := Drive;
      RootPath[1] := WC_COLON;
      RootPath[2] := WC_PATH_DELIMITER;
      RootPath[3] := WC_NULL;
      RootPtr := RootPath;
    end;
  Result := GetDiskFreeSpaceExW(RootPtr, FreeSpaceAvailable, TotalSpace, nil);
end;

{ ---------------------------------------------------------------------------- }
{ Interfaced Functions & Procedures
{ ---------------------------------------------------------------------------- }

function BitClear(const Bits, BitNo: Integer): Integer;
begin
  Result := Bits and not (1 shl BitNo);
end;

{ ---------------------------------------------------------------------------- }

function BitSet(const Bits, BitIndex: Integer): Integer;
begin
  Result := Bits or (1 shl BitIndex);
end;

{ ---------------------------------------------------------------------------- }

function BitSetTo(const Bits, BitIndex: Integer; const Value: Boolean): Integer;
begin
  if Value then
    Result := Bits or (1 shl BitIndex)
  else
    Result := Bits and not (1 shl BitIndex);
end;

{ ---------------------------------------------------------------------------- }

function BitTest(const Bits, BitIndex: Integer): Boolean;
begin
  Result := (Bits and (1 shl BitIndex)) <> 0;
end;

{ ---------------------------------------------------------------------------- }

function BSwap(const Value: Cardinal): Cardinal;
asm
  BSWAP EAX
end;

{ ---------------------------------------------------------------------------- }

function BSwap(const Value: Integer): Integer;
asm
  BSWAP EAX
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function BufPosA(const Search: AnsiString; const Buf: PAnsiChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Buf;
  if PSource = nil then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  lSource := BufCharCount;

  if lSearch > lSource then goto Fail;
  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos >= lSource then goto Fail;
  Dec(lSource, StartPos);
  Inc(PSource, StartPos);

  c := pSearch^;
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (PSource^ = c) then goto Zero;
          if (PSource[1] = c) then goto One;
          if (PSource[2] = c) then goto Two;
          if (PSource[3] = c) then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
            if (PSource[2] = c) then goto Two;
          end;
        2:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
          end;
        1:
          begin
            if (PSource^ = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if PSourceTemp^ = pSearchTemp^ then goto Success;
        2: if PWord(PSourceTemp)^ = PWord(pSearchTemp)^ then goto Success;
        3: if (PWord(PSourceTemp)^ = PWord(pSearchTemp)^) and (PSourceTemp[2] = pSearchTemp[2]) then goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := nil;
  Exit;

  Success:
  Result := PSource - 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function BufPosIA(const Search: AnsiString; const Buf: Pointer; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Buf;
  if PSource = nil then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  lSource := BufCharCount;

  if lSearch > lSource then goto Fail;
  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos >= lSource then goto Fail;
  Dec(lSource, StartPos);
  Inc(PSource, StartPos);

  c := ANSI_UPPER_CHAR_TABLE[pSearch^];
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[PSource[3]] = c) then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
            if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          end;
        2:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          end;
        1:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[3]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[3]]) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^] then
            goto Success;
        2: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) then
            goto Success;
        3: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
            (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) then
            goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := nil;
  Exit;

  Success:
  Result := PSource - 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function BufPosW(const Search: WideString; const Buf: PWideChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): PWideChar;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PWideChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: WideChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Buf;
  if PSource = nil then goto Fail;

  lSearch := PCardinal(pSearch - 2)^ div 2;
  if lSearch = 0 then goto Fail;

  lSource := BufCharCount;
  if lSearch > lSource then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos >= lSource then goto Fail;
  Dec(lSource, StartPos);

  Inc(PSource, StartPos);

  c := pSearch^;
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            if PSource[2] = c then goto Two;
          end;
        2:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
          end;
        1:
          begin
            if PSource^ = c then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[1] = pSearchTemp[1]) and
        (PSourceTemp[2] = pSearchTemp[2]) and
        (PSourceTemp[3] = pSearchTemp[3]) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if PSourceTemp^ = pSearchTemp^ then
            goto Success;
        2: if (PSourceTemp^ = pSearchTemp^) and
          (PSourceTemp[1] = pSearchTemp[1]) then
            goto Success;
        3: if (PSourceTemp^ = pSearchTemp^) and
          (PSourceTemp[1] = pSearchTemp[1]) and
            (PSourceTemp[2] = pSearchTemp[2]) then
            goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := nil;
  Exit;

  Success:
  Result := PSource - 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function BufPosIW(const Search: WideString; const Buf: PWideChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): PWideChar;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PWideChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: WideChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Buf;
  if PSource = nil then goto Fail;

  lSearch := PCardinal(pSearch - 2)^ div 2;
  if lSearch = 0 then goto Fail;

  lSource := BufCharCount;
  if lSearch > lSource then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if StartPos >= lSource then goto Fail;
  Dec(lSource, StartPos);

  Inc(PSource, StartPos);

  c := CharToCaseFoldW(pSearch^);
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (CharToCaseFoldW(PSource^) = c) then goto Zero;
          if (CharToCaseFoldW(PSource[1]) = c) then goto One;
          if (CharToCaseFoldW(PSource[2]) = c) then goto Two;
          if (CharToCaseFoldW(PSource[3]) = c) then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (CharToCaseFoldW(PSource^) = c) then goto Zero;
            if (CharToCaseFoldW(PSource[1]) = c) then goto One;
            if (CharToCaseFoldW(PSource[2]) = c) then goto Two;
          end;
        2:
          begin
            if (CharToCaseFoldW(PSource^) = c) then goto Zero;
            if (CharToCaseFoldW(PSource[1]) = c) then goto One;
          end;
        1:
          begin
            if (CharToCaseFoldW(PSource^) = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
        (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) and
        (CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2])) and
        (CharToCaseFoldW(PSourceTemp[3]) = CharToCaseFoldW(pSearchTemp[3])) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^) then
            goto Success;
        2: if (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
          (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) then
            goto Success;
        3: if (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
          (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) and
            (CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2])) then
            goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := nil;
  Exit;

  Success:
  Result := PSource - 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

function BufSame(const Buf1, Buf2: Pointer; const BufByteCount: Cardinal): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  p1 := Buf1;
  p2 := Buf2;
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l := BufByteCount;

  while l >= 4 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function BufSameIA(const Buf1, Buf2: Pointer; const BufCharCount: Cardinal): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  p1 := Buf1;
  p2 := Buf2;
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l := BufCharCount;
  while l >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
          (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Fail; end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function BufPosCharsA(const Buf: PAnsiChar; const BufCharCount: Cardinal; const Search: TAnsiCharSet; const Start: Cardinal = 0): Integer;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Buf;
  if (p = nil) or (Start > BufCharCount) then goto Fail;

  Inc(p, Start);
  l := BufCharCount - Start;

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[1] in Search then goto One;
      if p[2] in Search then goto Two;
      if p[3] in Search then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
        if (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := -1;
  Exit;

  Zero:
  Result := Integer(p) - Integer(Buf);
  Exit;

  One:
  Result := Integer(p) - Integer(Buf) + 1;
  Exit;

  Two:
  Result := Integer(p) - Integer(Buf) + 2;
  Exit;

  Three:
  Result := Integer(p) - Integer(Buf) + 3;
end;

{ ---------------------------------------------------------------------------- }

function BufStrSameA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l2: Cardinal;
begin
  if (Buffer = nil) or (Pointer(s) = nil) then goto Fail;

  l2 := PCardinal(Cardinal(Pointer(s)) - 4)^;

  if AnsiCharCount <> l2 then goto Fail;

  p1 := Buffer;
  p2 := Pointer(s);

  while l2 >= 4 do
    begin
      if (p1^ <> p2^) then goto Fail;
      if (p1[1] <> p2[1]) then goto Fail;
      if (p1[2] <> p2[2]) then goto Fail;
      if (p1[3] <> p2[3]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l2, 4);
    end;

  case l2 of
    3:
      begin
        if (p1^ <> p2^) then goto Fail;
        if (p1[1] <> p2[1]) then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) then goto Fail;
        if (p1[1] <> p2[1]) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function BufStrSameIA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l2: Cardinal;
begin
  if (Buffer = nil) or (Pointer(s) = nil) then goto Fail;

  l2 := PCardinal(Cardinal(s) - 4)^;

  if AnsiCharCount <> l2 then goto Fail;

  p1 := Buffer;
  p2 := Pointer(s);

  while l2 >= 4 do
    begin
      if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
      if (p1[1] <> p2[1]) and (p1[1] <> ANSI_REVERSE_CHAR_TABLE[p2[1]]) then goto Fail;
      if (p1[2] <> p2[2]) and (p1[2] <> ANSI_REVERSE_CHAR_TABLE[p2[2]]) then goto Fail;
      if (p1[3] <> p2[3]) and (p1[3] <> ANSI_REVERSE_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l2, 4);
    end;

  case l2 of
    3:
      begin
        if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
        if (p1[1] <> p2[1]) and (p1[1] <> ANSI_REVERSE_CHAR_TABLE[p2[1]]) then goto Fail;
        if (p1[2] <> p2[2]) and (p1[2] <> ANSI_REVERSE_CHAR_TABLE[p2[2]]) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
        if (p1[1] <> p2[1]) and (p1[1] <> ANSI_REVERSE_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function BufStrSameW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Buffer;
  l1 := WideCharCount;

  p2 := Pointer(w);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^ div 2;

  if l1 <> l2 then goto Fail;

  while l1 >= 2 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 2);
      Inc(p2, 2);
      Dec(l1, 2);
    end;

  if (l1 = 1) and (p1^ <> p2^) then goto Fail;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function BufStrSameIW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Buffer;
  l1 := WideCharCount;

  p2 := Pointer(w);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^ div 2;

  if l1 <> l2 then goto Fail;

  while l1 >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      end;
  end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

procedure ConCatBufA(const Buffer: Pointer; const AnsiCharCount: Cardinal; var d: AnsiString; var InUse: Cardinal);
var
  PAnsiCharS, PAnsiCharD: PAnsiChar;
  lS, lD, NewInUse: Cardinal;
begin
  PAnsiCharS := Buffer;
  if PAnsiCharS = nil then Exit;

  lS := AnsiCharCount;
  if lS = 0 then Exit;

  PAnsiCharD := Pointer(d);
  lD := Cardinal(PAnsiCharD);
  if lD <> 0 then lD := PCardinal(lD - 4)^;

  NewInUse := InUse + lS;

  if NewInUse > lD then
    begin
      SetLength(d, (NewInUse + (NewInUse div 2) + 3) and $FFFFFFFC);
      PAnsiCharD := Pointer(d);
    end;

  Inc(PAnsiCharD, InUse);
  while lS >= 4 do
    begin
      Cardinal(Pointer(PAnsiCharD)^) := Cardinal(Pointer(PAnsiCharS)^);
      Inc(PAnsiCharD, SizeOf(Cardinal));
      Inc(PAnsiCharS, SizeOf(Cardinal));
      Dec(lS, SizeOf(Cardinal));
    end;

  case lS of
    3:
      begin
        PWord(PAnsiCharD)^ := PWord(PAnsiCharS)^;
        PAnsiCharD[2] := PAnsiCharS[2];
      end;
    2:
      begin
        PWord(PAnsiCharD)^ := PWord(PAnsiCharS)^;
      end;
    1:
      begin
        PAnsiCharD^ := PAnsiCharS^;
      end;
  end;

  InUse := NewInUse;
end;

{ ---------------------------------------------------------------------------- }

procedure ConCatBufW(const Buffer: Pointer; const WideCharCount: Cardinal; var d: WideString; var InUse: Cardinal);
var
  PSource, PDest: PWideChar;
  lSource, lDest, NewInUse: Cardinal;
begin
  PSource := Buffer;
  if PSource = nil then Exit;

  lSource := WideCharCount;
  if lSource = 0 then Exit;

  PDest := Pointer(d);
  lDest := Cardinal(PDest);
  if lDest <> 0 then lDest := PCardinal(lDest - 4)^ div 2;

  NewInUse := InUse + lSource;

  if NewInUse > lDest then
    begin
      SetLength(d, (NewInUse + (NewInUse div 2) + 3) and $FFFFFFFC);
      PDest := Pointer(d);
    end;

  Inc(PDest, InUse);
  while lSource >= 4 do
    begin
      PInt64(PDest)^ := PInt64(PSource)^;
      Inc(PDest, 4);
      Inc(PSource, 4);
      Dec(lSource, 4);
    end;

  case lSource of
    3:
      begin
        PCardinal(PDest)^ := PCardinal(PSource)^;
        PDest[2] := PSource[2];
      end;
    2:
      begin
        PCardinal(PDest)^ := PCardinal(PSource)^;
      end;
    1:
      begin
        PDest^ := PSource^;
      end;
  end;

  InUse := NewInUse;
end;

{ ---------------------------------------------------------------------------- }

procedure ConCatCharA(const c: AnsiChar; var d: AnsiString; var InUse: Cardinal);
var
  Dest: PAnsiChar;
  lDest: Cardinal;
begin
  Dest := Pointer(d);
  lDest := Cardinal(Dest);
  if lDest <> 0 then lDest := PCardinal(lDest - 4)^;

  if InUse + 1 > lDest then
    begin
      SetLength(d, (InUse + 1 + (InUse + 1 div 2) + 3) and $FFFFFFFC);
      Dest := Pointer(d);
    end;

  Dest[InUse] := c;
  Inc(InUse);
end;

{ ---------------------------------------------------------------------------- }

procedure ConCatCharW(const c: WideChar; var d: WideString; var InUse: Cardinal);
var
  Dest: PWideChar;
  lDest: Cardinal;
begin
  Dest := Pointer(d);
  lDest := Cardinal(Dest);
  if lDest <> 0 then lDest := PCardinal(lDest - 4)^ div 2;

  if InUse + 1 > lDest then
    begin
      SetLength(d, (InUse + 1 + (InUse + 1 div 2) + 3) and $FFFFFFFC);
      Dest := Pointer(d);
    end;

  Dest[InUse] := c;

  InUse := InUse + 1;
end;

{ ---------------------------------------------------------------------------- }

procedure ConCatStrA(const s: AnsiString; var d: AnsiString; var InUse: Cardinal);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^;
  if l = 0 then Exit;
  ConCatBufA(Pointer(s), l, d, InUse);
end;

{ ---------------------------------------------------------------------------- }

procedure ConCatStrW(const w: WideString; var d: WideString; var InUse: Cardinal);
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^; // div 2 see below.
  if l = 0 then Exit;
  ConCatBufW(Pointer(w), l div 2, d, InUse);
end;

{ ---------------------------------------------------------------------------- }

function Crc32OfBuf(const Buffer; const BufferSize: Cardinal): Cardinal;
begin
  Result := not UpdateCrc32OfBuf(CRC_32_INIT, Buffer, BufferSize);
end;

{ ---------------------------------------------------------------------------- }

function Crc32OfStrA(const s: AnsiString): Cardinal;
begin
  Result := CRC_32_INIT;
  if s <> '' then
    Result := UpdateCrc32OfBuf(Result, Pointer(s)^, PCardinal(Cardinal(s) - 4)^);
  Result := not Result;
end;

{ ---------------------------------------------------------------------------- }

function Crc32OfStrW(const w: WideString): Cardinal;
begin
  Result := CRC_32_INIT;
  if Pointer(w) <> nil then
    Result := UpdateCrc32OfBuf(Result, Pointer(w)^, PCardinal(Cardinal(w) - 4)^);
  Result := not Result;
end;

{ ---------------------------------------------------------------------------- }

function CurrentDay: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wDay;
end;

{ ---------------------------------------------------------------------------- }

function CurrentMonth: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wMonth;
end;

{ ---------------------------------------------------------------------------- }

function CurrentQuarter: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := QUARTER_OF_MONTH[SystemTime.wMonth]
end;

{ ---------------------------------------------------------------------------- }

function CurrentYear: Integer;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;

{ ---------------------------------------------------------------------------- }

function CurrentJulianDate: TJulianDate;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := YmdToJulianDate(wYear, wMonth, wDay);
end;

{ ---------------------------------------------------------------------------- }

function DayOfJulianDate(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Month: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Result);
end;

{ ---------------------------------------------------------------------------- }

function DayOfWeek(const JulianDate: TJulianDate): Word;
{ To Convert to a "Delphi" compatible Day-Of-Week use "(Result + 1) mod 7 + 1". }
begin
  Result := JulianDate mod 7;
end;

{ ---------------------------------------------------------------------------- }

function DayOfWeek(const Year: Integer; const Month, Day: Word): Word;
{ To Convert to a "Delphi" compatible Day-Of-Week use "(Result + 1) mod 7 + 1". }
begin
  Result := YmdToJulianDate(Year, Month, Day) mod 7;
end;

{ ---------------------------------------------------------------------------- }

function DaysInMonth(const Year: Integer; const Month: Word): Word;
begin
  Result := DAYS_IN_MONTH[IsLeapYear(Year)][Month];
end;

{ ---------------------------------------------------------------------------- }

function DaysInMonth(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := DAYS_IN_MONTH[IsLeapYear(Year)][Month];
end;

{ ---------------------------------------------------------------------------- }

procedure DecDay(var Year: Integer; var Month, Day: Word);
begin
  Dec(Day);
  if Day < 1 then
    begin
      Dec(Month);
      if Month < 1 then
        begin
          Month := 12;
          Dec(Year);
        end;
      Day := DaysInMonth(Year, Month);
    end;
end;

{ ---------------------------------------------------------------------------- }

procedure DecDay(var Year: Integer; var Month, Day: Word; const Days: Integer);
var
  JulianDate: TJulianDate;
begin
  JulianDate := YmdToJulianDate(Year, Month, Day);
  Dec(JulianDate, Days);
  JulianDateToYmd(JulianDate, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function DeleteDirectoryA(Dir: AnsiString; const DeleteItself: Boolean = True): Boolean;
var
  FileOpStruct: TSHFileOpStructA;
begin
  if DeleteItself then
    ExcludeTrailingPathDelimiterA(Dir)
  else
    begin
      IncludeTrailingPathDelimiterByRef(Dir);
      Dir := Dir + AC_ASTERISK;
    end;
  { Make sure that the directory name is terminated by a double #0. }
  Dir := Dir + WC_NULL;

  ZeroMem(FileOpStruct, SizeOf(FileOpStruct)); // Important: Clear FileOpStruct.
  // FileOpStruct.Wnd := Application.Handle;
  FileOpStruct.wFunc := FO_DELETE;
  FileOpStruct.PFrom := Pointer(Dir);
  FileOpStruct.fFlags := {FOF_ALLOWUNDO or} FOF_SILENT or FOF_NOCONFIRMATION; // FOF_AlLLOWUNDO schickt alles in den Papierkorb

  Result := SHFileOperationA(FileOpStruct) = 0;
end;

{ ---------------------------------------------------------------------------- }

function DeleteDirectoryW(Dir: WideString; const DeleteItself: Boolean = True): Boolean;
var
  FileOpStruct: TSHFileOpStructW;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if DeleteItself then
        ExcludeTrailingPathDelimiterW(Dir)
      else
        begin
          IncludeTrailingPathDelimiterByRef(Dir);
          Dir := Dir + WC_ASTERISK;
        end;
      { Make sure that the directory name is terminated by a double #0. }
      Dir := Dir + WC_NULL;

      ZeroMem(FileOpStruct, SizeOf(FileOpStruct)); // Important: Clear FileOpStruct.
      // FileOpStruct.Wnd := Application.Handle;
      FileOpStruct.wFunc := FO_DELETE;
      FileOpStruct.PFrom := Pointer(Dir);
      FileOpStruct.fFlags := {FOF_ALLOWUNDO or} FOF_SILENT or FOF_NOCONFIRMATION; // FOF_AlLLOWUNDO schickt alles in den Papierkorb

      Result := SHFileOperationW(FileOpStruct) = 0;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DeleteDirectoryA(Dir, DeleteItself);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function DirectoryExistsA(const Dir: AnsiString): Boolean;
var
  Code: Cardinal;
begin
  Code := GetFileAttributesA(Pointer(Dir));
  Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
end;

{ ---------------------------------------------------------------------------- }

function DirectoryExistsW(const Dir: WideString): Boolean;
var
  Code: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Code := GetFileAttributesW(Pointer(Dir));
      Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DirectoryExistsA(Dir);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

procedure ExcludeTrailingPathDelimiterA(var s: AnsiString);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      if (l > 0) and (s[l] = AC_PATH_DELIMITER) then
        SetLength(s, l - 1);
    end;
end;

{ ---------------------------------------------------------------------------- }

procedure ExcludeTrailingPathDelimiterW(var s: WideString);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ div 2;
      if (l > 0) and (s[l] = WC_PATH_DELIMITER) then
        SetLength(s, l - 1);
    end;
end;

{ ---------------------------------------------------------------------------- }

function DiskFreeA(const Dir: AnsiString): Int64;
var
  Kernel: THandle;
  GetDFSExA: function(
    const lpDirectoryName: PAnsiChar;
    out lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes: TLargeInteger;
    const lpTotalNumberOfFreeBytes: PLargeInteger): BOOL; stdcall;
  SpC, BpS, NoFC, TNoC: Cardinal;
  Temp: Int64;
begin
  // Try extended method with huge disk support beginning with Win95 OSR 2.
  Kernel := GetModuleHandle(Windows.Kernel32);
  if Kernel <> 0 then
    begin
      @GetDFSExA := GetProcAddress(Kernel, 'GetDiskFreeSpaceExA');
      if Assigned(GetDFSExA) then
        begin
          if not GetDFSExA(PAnsiChar(Dir), Result, Temp, nil) then
            Result := -1;
          Exit;
        end;
    end;

  // If extended method is not available (Win95 prior to OSR 2), use old method.
  if GetDiskFreeSpaceA(PAnsiChar(Dir), SpC, BpS, NoFC, TNoC) then
    begin
      Temp := SpC * BpS;
      Result := Temp * NoFC;
    end
  else
    Result := -1;
end;

{ ---------------------------------------------------------------------------- }

function DiskFreeW(const Dir: WideString): Int64;
var
  Temp: Int64;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if not GetDiskFreeSpaceExW(PWideChar(Dir), Result, Temp, nil) then
        Result := -1;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DiskFreeA(Dir);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function EasterSunday(const Year: Integer): TJulianDate;
var
  d, X: Integer;
begin
  d := (234 - 11 * (Year mod 19)) mod 30 + 21;
  if d > 48 then
    X := 1
  else
    X := 0;
  Result := YmdToJulianDate(Year, 3, 1);
  Inc(Result, d - X + 6 - ((Year + (Year div 4) + d - X + 1) mod 7));
end;

{ ---------------------------------------------------------------------------- }

procedure EasterSunday(const Year: Integer; out Month, Day: Word);
var
  DummyYear: Integer;
begin
  JulianDateToYmd(EasterSunday(Year), DummyYear, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function ExtractFileDriveA(const FileName: AnsiString): AnsiString;
var
  I, j, l: Integer;
begin
  l := Length(FileName);
  if (l >= 2) and (FileName[2] = AC_DRIVE_DELIMITER) then
    Result := FileName[1] + AC_DRIVE_DELIMITER + AC_PATH_DELIMITER
  else
    if (l >= 2) and (FileName[1] = AC_PATH_DELIMITER) and (FileName[2] = AC_PATH_DELIMITER) then
      begin
        j := 2;
        I := 3;
        while I <= l do
          begin
            if FileName[I] = AC_PATH_DELIMITER then
              begin
                Dec(j);
                if j = 0 then Break;
              end;
            Inc(I);
          end;
        if I > l then I := l;
        SetString(Result, PAnsiChar(FileName), I);
        if Result[I] <> AC_PATH_DELIMITER then Result := Result + AC_PATH_DELIMITER;
      end
    else
      Result := '';
end;

{ ---------------------------------------------------------------------------- }

function ExtractFileDriveW(const FileName: WideString): WideString;
var
  I, j, l: Integer;
begin
  l := Length(FileName);
  if (l >= 2) and (FileName[2] = WC_DRIVE_DELIMITER) then
    Result := WideString(FileName[1]) + WC_DRIVE_DELIMITER + WC_PATH_DELIMITER
  else
    if (l >= 2) and (FileName[1] = WC_PATH_DELIMITER) and (FileName[2] = WC_PATH_DELIMITER) then
      begin
        j := 2;
        I := 3;
        while I <= l do
          begin
            if FileName[I] = WC_PATH_DELIMITER then
              begin
                Dec(j);
                if j = 0 then Break;
              end;
            Inc(I);
          end;
        if I > l then I := l;
        SetString(Result, PWideChar(FileName), I);
        if Result[I] <> WC_PATH_DELIMITER then Result := Result + WC_PATH_DELIMITER;
      end
    else
      Result := '';
end;

{ ---------------------------------------------------------------------------- }

function ExtractFileNameA(const FileName: AnsiString): AnsiString;
var
  l, Start: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      Start := l;
      while (Start > 0) and (FileName[Start] <> AC_PATH_DELIMITER) and (FileName[Start] <> AC_COLON) do
        Dec(Start);
      SetString(Result, PAnsiChar(FileName) + Start, l - Start);
    end
  else
    Result := '';
end;

{ ---------------------------------------------------------------------------- }

function ExtractFileNameW(const FileName: WideString): WideString;
var
  l, Start: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ div 2;
      Start := l;
      while (Start > 0) and (FileName[Start] <> AC_PATH_DELIMITER) and (FileName[Start] <> AC_COLON) do
        Dec(Start);
      SetString(Result, PWideChar(FileName) + Start, l - Start);
    end
  else
    Result := '';
end;

{ ---------------------------------------------------------------------------- }

function ExtractFilePathA(const FileName: AnsiString): AnsiString;
var
  l: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      while (l > 0) and (FileName[l] <> AC_PATH_DELIMITER) and (FileName[l] <> AC_COLON) do
        Dec(l);
    end;
  SetString(Result, PAnsiChar(FileName), l);
end;

{ ---------------------------------------------------------------------------- }

function ExtractFilePathW(const FileName: WideString): WideString;
var
  l: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ div 2;
      while (l > 0) and (FileName[l] <> WC_PATH_DELIMITER) and (FileName[l] <> WC_COLON) do
        Dec(l);
    end;
  SetString(Result, PWideChar(FileName), l);
end;

{ ---------------------------------------------------------------------------- }

function ExtractNextWordA(const s: AnsiString; const Delimiters: TAnsiCharSet; var StartIndex: Integer): AnsiString;
label
  Fail;
var
  p, pStart: PAnsiChar;
  l: Integer;
begin
  p := Pointer(s);
  if p = nil then goto Fail;
  l := PCardinal(Cardinal(p) - 4)^;

  if (StartIndex < 1) or (StartIndex - 1 > l) then goto Fail;

  Dec(l, StartIndex - 1);
  Inc(p, StartIndex - 1);
  pStart := p;

  while (l > 0) and not (p^ in Delimiters) do
    begin
      Inc(p);
      Dec(l);
    end;

  SetString(Result, pStart, p - pStart);
  if l <= 0 then
    StartIndex := 0
  else
    Inc(StartIndex, p - pStart + 1);

  Exit;

  Fail:
  StartIndex := -1;
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function ExtractWordA(const Number: Cardinal; const s: AnsiString; const Delimiters: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;
label
  ReturnEmptyString, Success;
var
  l, n: Cardinal;
  p, PWordStart: PAnsiChar;
begin
  p := Pointer(s);
  if p = nil then goto ReturnEmptyString;

  l := PCardinal(Cardinal(p) - 4)^;
  if l = 0 then goto ReturnEmptyString;

  n := 0;

  repeat

    while (l > 0) and not (p^ in Delimiters) do
      begin
        Inc(p);
        Dec(l);
      end;

    if l = 0 then goto ReturnEmptyString;

    Inc(p);
    Dec(l);

    Inc(n);
    if n = Number then goto Success;

  until l = 0;

  ReturnEmptyString:
  Result := '';
  Exit;

  Success:
  PWordStart := p;
  while (l > 0) and not (p^ in Delimiters) do
    begin
      Inc(p);
      Dec(l);
    end;
  SetString(Result, PWordStart, p - PWordStart);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

function ExtractWordStartsA(const s: AnsiString; const MaxCharCount: Cardinal; const WordSeparators: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;
var
  I, l, LengthResult: Cardinal;
  p: PAnsiChar;
begin
  Result := '';
  if MaxCharCount = 0 then Exit;

  p := Pointer(s);
  l := Cardinal(p);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^;

  if l > 0 then
    begin
      LengthResult := 0;

      repeat

        while (l > 0) and (p^ in WordSeparators) do
          begin
            Inc(p);
            Dec(l);
          end;

        I := MaxCharCount;
        while (l > 0) and (I > 0) and not (p^ in WordSeparators) do
          begin
            ConCatCharA(p^, Result, LengthResult);
            Inc(p);
            Dec(I);
            Dec(l);
          end;

        while (l > 0) and not (p^ in WordSeparators) do
          begin
            Inc(p);
            Dec(l);
          end;

      until l = 0;

      SetLength(Result, LengthResult);
    end;
end;

{ ---------------------------------------------------------------------------- }

function ExtractWordStartsW(const s: WideString; const MaxCharCount: Cardinal; const IsWordSep: TDIValidateWideCharFunc): WideString;
var
  I, l, LengthResult: Cardinal;
  p: PWideChar;
begin
  Result := '';
  if MaxCharCount = 0 then Exit;

  p := Pointer(s);
  l := Cardinal(p);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^ div 2;

  if l > 0 then
    begin
      LengthResult := 0;

      repeat

        while (l > 0) and IsWordSep(p^) do
          begin
            Inc(p);
            Dec(l);
          end;

        I := MaxCharCount;
        while (l > 0) and (I > 0) and not IsWordSep(p^) do
          begin
            ConCatCharW(p^, Result, LengthResult);
            Inc(p);
            Dec(I);
            Dec(l);
          end;

        while (l > 0) and not IsWordSep(p^) do
          begin
            Inc(p);
            Dec(l);
          end;

      until l = 0;

      SetLength(Result, LengthResult);
    end;
end;

{ ---------------------------------------------------------------------------- }

function FileExistsA(const FileName: AnsiString): Boolean;
var
  Code: Cardinal;
begin
  Code := GetFileAttributesA(Pointer(FileName));
  Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY = 0);
end;

{ ---------------------------------------------------------------------------- }

function FileExistsW(const FileName: WideString): Boolean;
var
  Code: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Code := GetFileAttributesW(Pointer(FileName));
      Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY = 0);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := FileExistsA(FileName);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function FirstDayOfMonth(const Julian: TJulianDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, 1);
end;

{ ---------------------------------------------------------------------------- }

procedure FirstDayOfMonth(const Year: Integer; const Month: Word; out Day: Word);
begin
  Day := 1;
end;

{ ---------------------------------------------------------------------------- }

function FirstDayOfWeek(const JulianDate: TJulianDate): TJulianDate;
begin
  Result := JulianDate;
  Dec(Result, Result mod 7);
end;

{ ---------------------------------------------------------------------------- }

procedure FirstDayOfWeek(var Year: Integer; var Month, Day: Word);
var
  Julian: TJulianDate;
begin
  Julian := YmdToJulianDate(Year, Month, Day);
  Dec(Julian, Julian mod 7);
  JulianDateToYmd(Julian, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function ForceDirectoriesA(Dir: AnsiString): Boolean;
var
  l: Integer;
  UpDir: AnsiString;
begin
  Result := True;
  if DirectoryExistsA(Dir) then Exit;
  ExcludeTrailingPathDelimiterA(Dir);
  l := Length(Dir);
  if l < 3 then Exit;
  UpDir := ExtractFilePathA(Dir); // UpDir will be shorter than Dir if successfull.
  if l = Length(UpDir) then Exit; // Is UpDir really shorter?
  Result := ForceDirectoriesA(UpDir) and CreateDirectoryA(Pointer(Dir), nil);
end;

{ ---------------------------------------------------------------------------- }

function ForceDirectoriesW(Dir: WideString): Boolean;
var
  l: Integer;
  UpDir: WideString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Result := True;
      if DirectoryExistsW(Dir) then Exit;
      ExcludeTrailingPathDelimiterW(Dir);
      l := Length(Dir);
      if l < 3 then Exit;
      UpDir := ExtractFilePathW(Dir); // UpDir will be shorter than Dir if successfull.
      if l = Length(UpDir) then Exit; // Is UpDir really shorter?
      Result := ForceDirectoriesW(UpDir) and CreateDirectoryW(Pointer(Dir), nil);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := ForceDirectoriesA(Dir);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function GCD(const X, y: Cardinal): Cardinal; assembler;
{ From JclMath.pas, replaced AND by TEST. }
asm
     JMP  @01      // We start with EAX <- X, EDX <- Y, and check to see if Y=0
@00:
     MOV  ECX, EDX // ECX <- EDX prepare for division
     XOR  EDX, EDX // clear EDX for Division
     DIV  ECX      // EAX <- EDX:EAX div ECX, EDX <- EDX:EAX mod ECX
     MOV  EAX, ECX // EAX <- ECX, and repeat if EDX <> 0
@01:
     TEST EDX, EDX // test to see if EDX is zero, without changing EDX
     JNE  @00      // when EDX is zero EAX has the Result
end;

{ ---------------------------------------------------------------------------- }

function GetSpecialFolderA(const OwnerWindowHandle: HWND; const SpecialFolder: Integer): AnsiString;
var
  ItemIDList: PItemIDList;
  Buffer: array[0..MAX_PATH - 1] of AnsiChar;
begin
  ItemIDList := nil;
  if SHGetSpecialFolderLocation(OwnerWindowHandle, SpecialFolder, ItemIDList) = NOERROR then
    begin
      if SHGetPathFromIDListA(ItemIDList, Buffer) then
        begin
          Result := Buffer;
          IncludeTrailingPathDelimiterByRef(Result);
          Exit;
        end;
    end;
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function GetSpecialFolderW(const OwnerWindowHandle: HWND; const SpecialFolder: Integer): WideString;
var
  ItemIDList: PItemIDList;
  Buffer: array[0..MAX_PATH - 1] of WideChar;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      ItemIDList := nil;
      if SHGetSpecialFolderLocation(OwnerWindowHandle, SpecialFolder, ItemIDList) = NOERROR then
        begin
          if SHGetPathFromIDListW(ItemIDList, Buffer) then
            begin
              Result := Buffer;
              IncludeTrailingPathDelimiterByRef(Result);
              Exit;
            end;
        end;
      Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetSpecialFolderA(OwnerWindowHandle, SpecialFolder);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function GetUserNameA(out UserNameA: AnsiString): Boolean;
var
  Size: DWORD;
begin
  Size := 256 + 1;
  SetString(UserNameA, nil, Size);
  Result := Windows.GetUserNameA(Pointer(UserNameA), Size);
  if Result then
    SetLength(UserNameA, Size - 1)
  else
    UserNameA := '';
end;

{ ---------------------------------------------------------------------------- }

function GetUserNameW(out UserNameW: WideString): Boolean;
var
  Size: DWORD;
  {$IFNDEF DI_No_Win_9X_Support}
  UserNameA: AnsiString;
  {$ENDIF}
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Size := 256 + 1;
      SetString(UserNameW, nil, Size);
      Result := Windows.GetUserNameW(Pointer(UserNameW), Size);
      if Result then
        SetLength(UserNameW, Size - 1)
      else
        UserNameW := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    begin
      Result := GetUserNameA(UserNameA);
      UserNameW := UserNameA;
    end;
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function StrContainsCharA(const s: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(s);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;

  l := PCardinal(Cardinal(p) - 4)^;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ = c) or (p[1] = c) or (p[2] = c) or (p[3] = c) then goto Match;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      if (p^ = c) or (p[1] = c) or (p[2] = c) then goto Match;
    2:
      if (p^ = c) or (p[1] = c) then goto Match;
    1:
      if (p^ = c) then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

{ ---------------------------------------------------------------------------- }

function StrContainsCharW(const w: WideString; const c: WideChar; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ div 2;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ = c) or (p[1] = c) or (p[2] = c) or (p[3] = c) then goto Match;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      if (p^ = c) or (p[1] = c) or (p[2] = c) then goto Match;
    2:
      if (p^ = c) or (p[1] = c) then goto Match;
    1:
      if (p^ = c) then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

{ ---------------------------------------------------------------------------- }

function StrContainsCharsW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ div 2;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if Validate(p^) or Validate(p[1]) or Validate(p[2]) or Validate(p[3]) then goto Match;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3: if Validate(p^) or Validate(p[1]) or Validate(p[2]) then goto Match;
    2: if Validate(p^) or Validate(p[1]) then goto Match;
    1: if Validate(p^) then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

{ ---------------------------------------------------------------------------- }

function StrContainsCharsOnlyW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ div 2;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not Validate(p^) or not Validate(p[1]) or not Validate(p[2]) or not Validate(p[3]) then goto Fail;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      if not Validate(p^) or not Validate(p[1]) or not Validate(p[2]) then goto Fail;
    2:
      if not Validate(p^) or not Validate(p[1]) then goto Fail;
    1:
      if not Validate(p^) then goto Fail;
  end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function HashBuf(const Buffer; const BufferSize: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
type
  TCardinal3 = packed record
    c1, c2, c3: Cardinal;
  end;
  PCardinal3 = ^TCardinal3;
var
  p: PCardinal3;
  a, b, l: Cardinal;
begin
  a := $9E3779B9; // The golden ratio; an arbitrary value.
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := BufferSize;

  { Handle most of the key. }
  while l >= 12 do
    begin
      Inc(a, p^.c1);
      Inc(b, p^.c2);
      Inc(Result, p^.c3);

      {$I DIHashMix.inc}

      Inc(p);
      Dec(l, 12);
    end;

  { Handle the last 11 bytes. }
  Inc(Result, BufferSize);
  case l of
    11:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);
        { The first byte of Result is reserved for the length. }
        Inc(Result, p^.c3 and $FFFFFF shl 8);
      end;
    10:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);
        { The first byte of Result is reserved for the length. }
        Inc(Result, p^.c3 and $FFFF shl 8);
      end;
    9:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);
        { The first byte of Result is reserved for the length. }
        Inc(Result, p^.c3 and $FF shl 8);
      end;
    8:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);
      end;
    7:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FFFFFF);
      end;
    6:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FFFF);
      end;
    5:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FF);
      end;
    4:
      begin
        Inc(a, p^.c1);
      end;
    3:
      begin
        Inc(a, p^.c1 and $FFFFFF);
      end;
    2:
      begin
        Inc(a, p^.c1 and $FFFF);
      end;
    1:
      begin
        Inc(a, p^.c1 and $FF);
      end;
  end;

  {$I DIHashMix.inc}
end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function HashBufIA(const Buffer; const AnsiCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
label
  l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12;
type
  TAnsiChar4 = packed record
    case Boolean of
      True: (n: Cardinal);
      False: (c1, c2, c3, c4: AnsiChar);
  end;
  TAnsiChar12 = packed record
    c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12: AnsiChar;
  end;
  PAnsiChar12 = ^TAnsiChar12;
var
  p: PAnsiChar12;
  X: TAnsiChar4;
  a, b: Cardinal;
  l: Cardinal;
begin
  a := $9E3779B9; // the golden ratio; an arbitrary value
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := AnsiCharCount;

  { Handle most of the key. }
  while l >= 12 do
    begin
      X.c1 := ANSI_UPPER_CHAR_TABLE[p^.c1];
      X.c2 := ANSI_UPPER_CHAR_TABLE[p^.c2];
      X.c3 := ANSI_UPPER_CHAR_TABLE[p^.c3];
      X.c4 := ANSI_UPPER_CHAR_TABLE[p^.c4];
      Inc(a, X.n);

      X.c1 := ANSI_UPPER_CHAR_TABLE[p^.c5];
      X.c2 := ANSI_UPPER_CHAR_TABLE[p^.c6];
      X.c3 := ANSI_UPPER_CHAR_TABLE[p^.c7];
      X.c4 := ANSI_UPPER_CHAR_TABLE[p^.c8];
      Inc(b, X.n);

      X.c1 := ANSI_UPPER_CHAR_TABLE[p^.c9];
      X.c2 := ANSI_UPPER_CHAR_TABLE[p^.c10];
      X.c3 := ANSI_UPPER_CHAR_TABLE[p^.c11];
      X.c4 := ANSI_UPPER_CHAR_TABLE[p^.c12];
      Inc(Result, X.n);

      {$I DIHashMix.inc}

      Inc(p);
      Dec(l, 12);
    end;

  { Handle the last 11 bytes. }
  Inc(Result, AnsiCharCount);

  X.n := 0;
  case l of
    11: goto l11;
    10: goto l10;
    9: goto l9;
    8: goto l8;
    7: goto l7;
    6: goto l6;
    5: goto l5;
    4: goto l4;
    3: goto l3;
    2: goto l2;
    1: goto l1;
  else
    goto l0;
  end;

  l11:
  X.c4 := ANSI_UPPER_CHAR_TABLE[p^.c11];
  l10:
  X.c3 := ANSI_UPPER_CHAR_TABLE[p^.c10];
  l9:
  X.c2 := ANSI_UPPER_CHAR_TABLE[p^.c9];
  { The first byte of c is reserved for the Length. }
  Inc(Result, X.n);

  l8:
  X.c4 := ANSI_UPPER_CHAR_TABLE[p^.c8];
  l7:
  X.c3 := ANSI_UPPER_CHAR_TABLE[p^.c7];
  l6:
  X.c2 := ANSI_UPPER_CHAR_TABLE[p^.c6];
  l5:
  X.c1 := ANSI_UPPER_CHAR_TABLE[p^.c5];
  Inc(b, X.n);

  l4:
  X.c4 := ANSI_UPPER_CHAR_TABLE[p^.c4];
  l3:
  X.c3 := ANSI_UPPER_CHAR_TABLE[p^.c3];
  l2:
  X.c2 := ANSI_UPPER_CHAR_TABLE[p^.c2];
  l1:
  X.c1 := ANSI_UPPER_CHAR_TABLE[p^.c1];
  Inc(a, X.n);

  l0:

  {$I DIHashMix.inc}
end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function HashBufIW(const Buffer; const WideCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
label
  l0, l1, l2, l3, l4, l5;
type
  TWideChar2 = packed record
    case Boolean of
      True: (n: Cardinal);
      False: (c1, c2: WideChar);
  end;
  TWideChar6 = packed record
    c1, c2, c3, c4, c5, c6: WideChar;
  end;
  PWideChar6 = ^TWideChar6;
var
  p: PWideChar6;
  X: TWideChar2;
  a, b: Cardinal;
  l: Cardinal;
begin
  a := $9E3779B9; // the golden ratio; an arbitrary value
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := WideCharCount;

  { Handle most of the key. }
  while l >= 6 do
    begin
      X.c1 := CharToCaseFoldW(p^.c1);
      X.c2 := CharToCaseFoldW(p^.c2);
      Inc(a, X.n);

      X.c1 := CharToCaseFoldW(p^.c3);
      X.c2 := CharToCaseFoldW(p^.c4);
      Inc(b, X.n);

      X.c1 := CharToCaseFoldW(p^.c5);
      X.c2 := CharToCaseFoldW(p^.c6);
      Inc(Result, X.n);

      {$I DIHashMix.inc}

      Inc(p);
      Dec(l, 6);
    end;

  { Handle the last 5 characters. }
  Inc(Result, WideCharCount);

  X.n := 0;
  case l of
    5: goto l5;
    4: goto l4;
    3: goto l3;
    2: goto l2;
    1: goto l1;
  else
    goto l0;
  end;

  l5:
  X.c2 := CharToCaseFoldW(p^.c5);
  { The first byte of c is reserved for the Length. }
  Inc(b, X.n);

  l4:
  X.c2 := CharToCaseFoldW(p^.c4);
  l3:
  X.c1 := CharToCaseFoldW(p^.c3);
  l2:
  X.c2 := CharToCaseFoldW(p^.c2);
  l1:
  X.c1 := CharToCaseFoldW(p^.c1);
  Inc(a, X.n);

  l0:

  {$I DIHashMix.inc}
end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{ ---------------------------------------------------------------------------- }

function HashStrA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := HashBuf(Pointer(s)^, l, PreviousHash);
end;

{ ---------------------------------------------------------------------------- }

function HashStrW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;
var
  p: PWideChar;
  l: Cardinal;
begin
  p := Pointer(w);
  l := Cardinal(p);
  if l <> 0 then l := PCardinal(l - 4)^; // HashBuff requires be the number of bytes, not characters.
  Result := HashBuf(Pointer(w)^, l, PreviousHash);
end;

{ ---------------------------------------------------------------------------- }

function HashStrIA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := HashBufIA(Pointer(s)^, l, PreviousHash);
end;

{ ---------------------------------------------------------------------------- }

function HashStrIW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;
var
  p: PWideChar;
  l: Cardinal;
begin
  p := Pointer(w);
  l := Cardinal(p);
  if l <> 0 then l := PCardinal(l - 4)^ div 2;
  Result := HashBufIW(Pointer(w)^, l, PreviousHash);
end;

{ ---------------------------------------------------------------------------- }

function HexToIntA(const s: AnsiString): Integer;
var
  c: Integer;
  l: Cardinal;
  p: PByte;
begin
  Result := 0;
  p := Pointer(s);
  if p = nil then Exit;
  l := Cardinal(p);
  l := PCardinal(l - 4)^;
  while l > 0 do
    begin
      c := p^;
      Dec(c, $30);
      if c > $09 then
        begin
          Dec(c, $11);
          if c > $05 then
            begin
              Dec(c, $20);
              if c > $05 then Break;
            end;
          if c < 0 then Break;
          Inc(c, $0A);
        end
      else
        if c < 0 then Break;
      Result := Result shl 4 or c;

      Inc(p);
      Dec(l);
    end;
end;

{ ---------------------------------------------------------------------------- }

function HexToIntW(const w: WideString): Integer;
var
  c: Integer;
  l: Cardinal;
  p: PWord;
begin
  Result := 0;
  p := Pointer(w);
  if p = nil then Exit;
  l := Cardinal(p);
  l := PCardinal(l - 4)^ div 2;
  while l > 0 do
    begin
      c := p^;
      Dec(c, $30);
      if c > $09 then
        begin
          Dec(c, $11);
          if c > $05 then
            begin
              Dec(c, $20);
              if c > $05 then Break;
            end;
          if c < 0 then Break;
          Inc(c, $0A);
        end
      else
        if c < 0 then Break;
      Result := Result shl 4 or c;

      Inc(p);
      Dec(l);
    end;
end;

{ ---------------------------------------------------------------------------- }

procedure IncludeTrailingPathDelimiterByRef(var s: AnsiString);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      if (l > 0) and (s[l] = AC_PATH_DELIMITER) then Exit;
    end;
  s := s + AC_PATH_DELIMITER;
end;

{ ---------------------------------------------------------------------------- }

procedure IncludeTrailingPathDelimiterByRef(var w: WideString);
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ div 2;
      if (l > 0) and (w[l] = WC_PATH_DELIMITER) then Exit;
    end;
  w := w + WC_PATH_DELIMITER;
end;

{ ---------------------------------------------------------------------------- }

function IsLeapYear(const Year: Integer): Boolean;
begin
  Result := (Year and 3 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

{ ---------------------------------------------------------------------------- }

function ISODateToJulianDate(const ISODate: TIsoDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  ISODateToYmd(ISODate, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

procedure ISODateToYmd(const ISODate: TIsoDate; out Year: Integer; out Month, Day: Word);
var
  I: TIsoDate;
begin
  I := ISODate;
  Year := I div 10000;
  Dec(I, Year * 10000);
  Month := I div 100;
  Day := I - Month * 100;
end;

{ ---------------------------------------------------------------------------- }

function IsCharLowLineW(const c: WideChar): Boolean;
begin
  Result := c = WC_LOW_LINE;
end;

{ ---------------------------------------------------------------------------- }

function IsCharQuoteW(const c: WideChar): Boolean;
begin
  Result := c in [WC_APOSTROPHE, WC_QUOTATION_MARK];
end;

{ ---------------------------------------------------------------------------- }

function IsShiftKeyDown: Boolean;
begin
  Result := (GetAsyncKeyState(VK_LSHIFT) < 0) or (GetAsyncKeyState(VK_RSHIFT) < 0);
end;

{ ---------------------------------------------------------------------------- }

function IsCharWhiteSpaceW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE;
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function IsCharWhiteSpaceOrAmpersandW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_AMPERSAND];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_AMPERSAND];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function IsCharWhiteSpaceOrColonW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_COLON];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_COLON];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function IsCharWhiteSpaceOrGreaterThanSignW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_GREATER_THAN_SIGN];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_GREATER_THAN_SIGN];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function IsCharWhiteSpaceOrNoBreakSpaceW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_NO_BREAK_SPACE];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_NO_BREAK_SPACE];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function IsCharDigitW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_DIGITS;
  {$ELSE}
  Result := c in [WC_DIGIT_ZERO..WC_DIGIT_NINE];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function IsCharHexDigitW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_HEX_DIGITS;
  {$ELSE}
  Result := c in [WC_DIGIT_ZERO..WC_DIGIT_NINE, WC_CAPITAL_A..WC_CAPITAL_F, WC_SMALL_A..WC_SMALL_F];
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

procedure IncDay(var Year: Integer; var Month, Day: Word);
begin
  Inc(Day);
  if Day > DaysInMonth(Year, Month) then
    begin
      Day := 1;
      Inc(Month);
      if Month > 12 then
        begin
          Month := 1;
          Inc(Year);
        end;
    end;
end;

{ ---------------------------------------------------------------------------- }

procedure IncDay(var Year: Integer; var Month, Day: Word; const Days: Integer);
var
  JulianDate: TJulianDate;
begin
  JulianDate := YmdToJulianDate(Year, Month, Day);
  Inc(JulianDate, Days);
  JulianDateToYmd(JulianDate, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

procedure IncMonth(var Year: Integer; var Month, Day: Word);
var
  d: Word;
begin
  Inc(Month);
  if Month > 12 then
    begin
      Month := 1;
      Inc(Year);
    end;
  d := DaysInMonth(Year, Month);
  if Day > d then
    Day := d;
end;

{ ---------------------------------------------------------------------------- }

procedure IncMonth(var Year: Integer; var Month, Day: Word; const NumberOfMonths: Integer);
var
  IMonth: Integer;
begin
  IMonth := Month + NumberOfMonths;
  if IMonth > 12 then
    begin
      Inc(Year, (IMonth - 1) div 12);
      IMonth := IMonth mod 12;
      if IMonth = 0 then
        IMonth := 12;
    end
  else
    if IMonth < 1 then
      begin
        Inc(Year, (IMonth div 12) - 1);
        IMonth := 12 + IMonth mod 12;
      end;
  Month := IMonth;
  IMonth := DaysInMonth(Year, Month);
  if Day > IMonth then
    Day := IMonth;
end;

{ ---------------------------------------------------------------------------- }

function IntToHexA(Value: Int64; Digits: Integer): AnsiString;
var
  p: PAnsiChar;
begin
  SetString(Result, nil, Digits);
  p := Pointer(Result);
  while (Value <> 0) and (Digits > 0) do
    begin
      Dec(Digits);
      p[Digits] := AA_NUM_TO_HEX[Value and $000F];
      Value := Value shr 4;
    end;
  while Digits > 0 do
    begin
      Dec(Digits);
      p[Digits] := AC_DIGIT_ZERO;
    end;
end;

{ ---------------------------------------------------------------------------- }

function IntToHexW(Value: Int64; Digits: Integer): WideString;
var
  p: PWideChar;
begin
  SetString(Result, nil, Digits);
  p := Pointer(Result);
  while (Value <> 0) and (Digits > 0) do
    begin
      Dec(Digits);
      p[Digits] := WA_NUM_TO_HEX[Value and $000F];
      Value := Value shr 4;
    end;
  while Digits > 0 do
    begin
      Dec(Digits);
      p[Digits] := WC_DIGIT_ZERO;
    end;
end;

{ ---------------------------------------------------------------------------- }

function IntToStrA(const I: Integer): AnsiString;
begin
  Str(I, Result);
end;

{ ---------------------------------------------------------------------------- }

function IntToStrW(const I: Integer): WideString;
begin
  Str(I, Result);
end;

{ ---------------------------------------------------------------------------- }

function IntToStrA(const I: Int64): AnsiString;
begin
  Str(I, Result);
end;

{ ---------------------------------------------------------------------------- }

function IntToStrW(const I: Int64): WideString;
begin
  Str(I, Result);
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF COMPILER_5_UP}
procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

function IsDateValid(const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := (Month in [1..12]) and (Day > 0) and (Day <= DaysInMonth(Year, Month));
end;

{ ---------------------------------------------------------------------------- }

function IsStrEmptyA(const s: AnsiString): Boolean;
label
  Fail;
var
  p: PAnsiChar;
  l: Cardinal;
begin
  p := Pointer(s);
  if p <> nil then
    begin
      l := PCardinal(p - 4)^;

      while l >= 4 do
        begin
          if (p^ > AC_SPACE) or (p[1] > AC_SPACE) or (p[2] > AC_SPACE) or (p[3] > AC_SPACE) then goto Fail;
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          if (p^ > AC_SPACE) or (p[1] > AC_SPACE) or (p[2] > AC_SPACE) then goto Fail;
        2:
          if (p^ > AC_SPACE) or (p[1] > AC_SPACE) then goto Fail;
        1:
          if (p^ > AC_SPACE) then goto Fail;
      end;
    end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function IsStrEmptyW(const w: WideString): Boolean;
label
  Fail;
var
  p: PWideChar;
  l: Cardinal;
begin
  p := Pointer(w);
  if p <> nil then
    begin
      l := PCardinal(p - 2)^ div 2;

      while l >= 4 do
        begin
          if (p^ > WC_SPACE) or (p[1] > WC_SPACE) or (p[2] > WC_SPACE) or (p[3] > WC_SPACE) then goto Fail;
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          if (p^ > WC_SPACE) or (p[1] > WC_SPACE) or (p[2] > WC_SPACE) then goto Fail;
        2:
          if (p^ > WC_SPACE) or (p[1] > WC_SPACE) then goto Fail;
        1:
          if (p^ > WC_SPACE) then goto Fail;
      end;
    end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function IsHolidayInGermany(const Julian: TJulianDate; const Year: Integer; const Month, Day: Word): Boolean; overload;
label
  Success;
var
  ES: TJulianDate;
begin
  if DayOfWeek(Julian) = ISO_SUNDAY then goto Success;

  case Month of
    1:
      begin // Januar
        case Day of
          1: goto Success; // 'Neujahr';
        end;
      end;
    2:
      begin //Februar
      end;
    3:
      begin //März
      end;
    5:
      begin //Mai
        case Day of
          1: goto Success; // 'Maifeiertag';
        end;
      end;
    6:
      begin // Juni
      end;
    8:
      begin // August
      end;
    9:
      begin // September
      end;
    10:
      begin // Oktober
        case Day of
          3: goto Success; // 'Tag der Deutschen Einheit';
        end;
      end;
    11:
      begin //November
      end;
    12:
      begin //Dezember
        case Day of
          24: goto Success; // 'Heiligabend';
          25: goto Success; // '1.Weihnachtstag';
          26: goto Success; // '2.Weihnachtstag';
          31: goto Success; // 'Silvester';
        end;
      end;
  end;

  { Holidays in relation to Easter Sunday. }
  ES := EasterSunday(Year);

  if Julian = ES - 2 then goto Success; // 'Karfreitag';
  if Julian = ES + 1 then goto Success; // 'Ostermontag';
  if Julian = ES + 39 then goto Success; // 'Christi Himmelfahrt';
  if Julian = ES + 50 then goto Success; // 'Pfingstmontag';

  Result := False;
  Exit;

  Success:
  Result := True;
end;

{ ---------------------------------------------------------------------------- }

function IsHolidayInGermany(const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := IsHolidayInGermany(YmdToJulianDate(Year, Month, Day), Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function IsHolidayInGermany(const Julian: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := IsHolidayInGermany(Julian, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function IsPathDelimiterA(const s: AnsiString; const Index: Cardinal): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := (Index > 0) and (Index <= l) and (s[Index] = AC_PATH_DELIMITER)
end;

{ ---------------------------------------------------------------------------- }

function IsPathDelimiterW(const w: WideString; const Index: Cardinal): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then l := PCardinal(l - 4)^ div 2;
  Result := (Index > 0) and (Index <= l) and (w[Index] = WC_PATH_DELIMITER)
end;

{ ---------------------------------------------------------------------------- }

function IsPointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
  with Point, Rect do
    Result := (X >= Left) and (X <= Right) and (y >= Top) and (y <= Bottom);
end;

{ ---------------------------------------------------------------------------- }

function IsCharWordSeparatorW(const c: WideChar): Boolean;
begin
  Result := c in [
    WC_NULL..WC_SPACE, // WhiteSpace
  WC_DIGIT_ZERO..WC_DIGIT_NINE, // Digits
  WC_FULL_STOP, WC_COMMA, WC_COLON, WC_SEMICOLON, // Punctuation
  WC_QUOTATION_MARK, WC_HYPHEN_MINUS, WC_SOLIDUS, WC_AMPERSAND]; // Other
end;

{ ---------------------------------------------------------------------------- }

function ISOWeekNumber(const JulianDate: TJulianDate): Word;
var
  D4, l: TJulianDate;
begin
  // Source: Calender FAQ at http://www.tondering.dk/claus/calendar.html
  D4 := (JulianDate + 31741 - JulianDate mod 7) mod 146097 mod 36524 mod 1461;
  l := D4 div 1460;
  Result := ((D4 - l) mod 365 + l) div 7 + 1
end;

{ ---------------------------------------------------------------------------- }

function ISOWeekNumber(const Year: Integer; const Month, Day: Word): Word;
begin
  Result := ISOWeekNumber(YmdToJulianDate(Year, Month, Day));
end;

{ ---------------------------------------------------------------------------- }

function ISOWeekToJulianDate(const Year: Integer; const WeekOfYear, DayOfWeek: Word): TJulianDate;
begin
  Result := YmdToJulianDate(Year, 1, 4);
  Inc(Result, (WeekOfYear - 1) * 7 - Result mod 7 + DayOfWeek);
end;

{ ---------------------------------------------------------------------------- }

{.$DEFINE Calender_FAQ}// Default: Off -- it is slower.
procedure JulianDateToYmd(const JulianDate: TJulianDate; out Year: Integer; out Month, Day: Word);
{$IFDEF Calender_FAQ}
var
  a, b, c, d, e, M: Integer;
begin
  a := JulianDate + 32044;
  b := (4 * a + 3) div 146097;
  c := a - (b * 146097) div 4;
  d := (4 * c + 3) div 1461;
  e := c - (1461 * d) div 4;
  M := (5 * e + 2) div 153;
  Day := e - (153 * M + 2) div 5 + 1;
  Month := M + 3 - 12 * (M div 10);
  Year := b * 100 + d - 4800 + M div 10;
end;
{$ELSE}
var
  l, n, I, j: Integer;
begin
  l := JulianDate + 68569;
  n := 4 * l div 146097;
  l := l - (146097 * n + 3) div 4;
  I := 4000 * (l + 1) div 1461001;
  l := l - 1461 * I div 4 + 31;
  j := 80 * l div 2447;
  Day := l - 2447 * j div 80;
  l := j div 11;
  Month := j + 2 - 12 * l;
  Year := 100 * (n - 49) + I + l;
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

function JulianDateToIsoDate(const Julian: TJulianDate): TIsoDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDate(Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function JulianDateToIsoDateA(const Julian: TJulianDate): AnsiString;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDateA(Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function JulianDateToIsoDateW(const Julian: TJulianDate): WideString;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDateW(Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function LastDayOfMonth(const JulianDate: TJulianDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, DaysInMonth(Year, Month));
end;

{ ---------------------------------------------------------------------------- }

procedure LastDayOfMonth(const Year: Integer; const Month: Word; out Day: Word);
begin
  Day := DaysInMonth(Year, Month);
end;

{ ---------------------------------------------------------------------------- }

function LastDayOfWeek(const JulianDate: TJulianDate): TJulianDate;
begin
  Result := JulianDate;
  Inc(Result, 6 - (Result mod 7));
end;

{ ---------------------------------------------------------------------------- }

procedure LastDayOfWeek(var Year: Integer; var Month, Day: Word);
var
  Julian: TJulianDate;
begin
  Julian := YmdToJulianDate(Year, Month, Day);
  Inc(Julian, 6 - (Julian mod 7));
  JulianDateToYmd(Julian, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function LastSysErrorMessageA: AnsiString;
begin
  Result := SysErrorMessageA(GetLastError);
end;

{ ---------------------------------------------------------------------------- }

function LastSysErrorMessageW: WideString;
begin
  Result := SysErrorMessageW(GetLastError);
end;

{ ---------------------------------------------------------------------------- }

function LeftMostBit(const Value: Cardinal): Integer;
asm
  MOV ECX, EAX
  MOV EAX, -1
  BSR EAX, ECX
end;

{ ---------------------------------------------------------------------------- }

function MakeMethod(const AData, ACode: Pointer): TMethod;
begin
  with Result do begin Data := AData; Code := ACode; end;
end;

{ ---------------------------------------------------------------------------- }

function Min(const a, b: Integer): Integer;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

{ ---------------------------------------------------------------------------- }

function Min(const a, b: Cardinal): Cardinal;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

{ ---------------------------------------------------------------------------- }

function Max(const a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

{ ---------------------------------------------------------------------------- }

function Max(const a, b: Cardinal): Cardinal;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

{ ---------------------------------------------------------------------------- }

function MonthOfJulianDate(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Result, Day);
end;

{ ---------------------------------------------------------------------------- }

function PadLeftA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;
var
  I, l: Cardinal;
  p1, p2: PAnsiChar;
begin
  { Figures out the lenght of Source. }
  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^;

  { Do we really need to pad Source or is s already longer then length? }
  if Count > l then
    begin
      { Fill the leading characters with Char X.
        We start with the last character, so we can compare against zero. }
      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      I := Count - l;
      repeat
        Dec(I);
        p2[I] := c;
      until I = 0;
      { If string s has any contents (Length (Source) > 0) ... }
      if l > 0 then
        begin
          { ... copy all characters (one by one) from Source to the result string.
            We start with the last character, so we can compare against zero. }
          Inc(p2, Count - l);
          repeat
            Dec(l);
            p2[l] := p1[l];
          until l = 0;
        end;
    end
  else
    { If we don't need to pad, simply return Source. }
    Result := Source;
end;

{ ---------------------------------------------------------------------------- }

function PadLeftW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;
var
  I, l: Cardinal;
  p1, p2: PWideChar;
begin
  { Figures out the lenght of Source. }
  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^ div 2;

  { Do we really need to pad Source or is s already longer then length? }
  if Count > l then
    begin
      { Fill the leading characters with Char X.
        We start with the last character, so we can compare against zero. }
      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      I := Count - l;
      repeat
        Dec(I);
        p2[I] := c;
      until I = 0;
      { If string s has any contents (Length (Source) > 0) ... }
      if l > 0 then
        begin
          { ... copy all characters (one by one) from Source to the result string.
            We start with the last character, so we can compare against zero. }
          Inc(p2, Count - l);
          repeat
            Dec(l);
            p2[l] := p1[l];
          until l = 0;
        end;
    end
  else
    { If we don't need to pad, simply return Source. }
    Result := Source;
end;

{ ---------------------------------------------------------------------------- }

function PadRightA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;
var
  I, l: Cardinal;
  p1, p2: PAnsiChar;
begin
  { Figures out the lenght of Source. }
  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^;

  { Do we really need to pad Source or is Source already longer then length? }
  if Count > l then
    begin
      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      { Copy Source to begining of Result. }
      I := l;
      while I > 0 do
        begin
          Dec(I);
          p2[I] := p1[I];
        end;
      { Fill trailing chars of Result with char. }
      Inc(p2, l);
      I := Count - l;
      repeat
        Dec(I);
        p2[I] := c;
      until I = 0;
    end
  else
    { If we don't need to add anything, simply return Source. }
    Result := Source;
end;

{ ---------------------------------------------------------------------------- }

function PadRightW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;
var
  I, l: Cardinal;
  p1, p2: PWideChar;
begin
  { Figures out the lenght of Source. }
  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^ div 2;

  { Do we really need to pad Source or is Source already longer then length? }
  if Count > l then
    begin
      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      { Copy Source to begining of Result. }
      I := l;
      while I > 0 do
        begin
          Dec(I);
          p2[I] := p1[I];
        end;
      { Fill trailing chars of Result with char. }
      Inc(p2, l);
      I := Count - l;
      repeat
        Dec(I);
        p2[I] := c;
      until I = 0;
    end
  else
    { If we don't need to add anything, simply return Source. }
    Result := Source;
end;

{ ---------------------------------------------------------------------------- }

function ProperCaseA(const s: AnsiString): AnsiString;
begin
  Result := s;
  ProperCaseByRef(Result);
end;

{ ---------------------------------------------------------------------------- }

function ProperCaseW(const w: WideString): WideString;
begin
  Result := w;
  ProperCaseByRef(Result);
end;

{ ---------------------------------------------------------------------------- }

procedure ProperCaseByRef(var s: AnsiString);
var
  l: Cardinal;
  p: PAnsiChar;
  LastWasSeparator: Boolean;
begin
  p := Pointer(s);
  if p = nil then Exit;
  l := PCardinal(p - 4)^;
  if l > 0 then
    begin
      UniqueString(s);
      LastWasSeparator := True;
      repeat
        // Special Case. TODO: Are there other characters like them?
        if p^ = AC_APOSTROPHE then // Apostrophe
          // Do nothing.
        else
          if p^ in AS_WORD_SEPARATORS then
            LastWasSeparator := True
          else
            if LastWasSeparator then
              begin
                p^ := ANSI_UPPER_CHAR_TABLE[p^]; // Uppercase the character.
                LastWasSeparator := False;
              end
            else
              p^ := ANSI_LOWER_CHAR_TABLE[p^]; // Lowercase the character.
        Inc(p);
        Dec(l);
      until l = 0;
    end;
end;

{ ---------------------------------------------------------------------------- }

procedure ProperCaseByRef(var w: WideString);
var
  l: Cardinal;
  p: PWideChar;
  LastWasSeparator: Boolean;
begin
  p := Pointer(w);
  if p = nil then Exit;
  l := PCardinal(p - 2)^ div 2;
  if l > 0 then
    begin
      // UniqueString(w); // Not necessary. Windows WideStrings are always single reference.
      LastWasSeparator := True;
      repeat
        // Special Case. TODO: Are there other characters like them?
        if p^ = WC_APOSTROPHE then // Apostrophe
          // Do nothing.
        else
          if IsCharWordSeparatorW(p^) then
            LastWasSeparator := True
          else
            if LastWasSeparator then
              begin
                p^ := CharToTitleW(p^); // Uppercase the character.
                LastWasSeparator := False;
              end
            else
              p^ := CharToLowerW(p^); // Lowercase the character.
        Inc(p);
        Dec(l);
      until l = 0;
    end;
end;

{ ---------------------------------------------------------------------------- }

function RegReadStrDefA(const Key: HKEY; const SubKey, ValueName, Default: AnsiString): AnsiString;
label
  Fail;
var
  ResultKey: HKEY;
  ValueType: DWORD;
  DataSize: DWORD;
begin
  if RegOpenKeyExA(Key, Pointer(SubKey), 0, KEY_READ, ResultKey) <> ERROR_SUCCESS then goto Fail;
  if (RegQueryValueExA(ResultKey, Pointer(ValueName), nil, @ValueType, nil, @DataSize) = ERROR_SUCCESS) and
    (ValueType in [REG_EXPAND_SZ, REG_SZ]) then
    begin
      SetString(Result, nil, DataSize - 1);
      if RegQueryValueExA(ResultKey, Pointer(ValueName), nil, nil, Pointer(Result), @DataSize) = ERROR_SUCCESS then
        begin
          RegCloseKey(ResultKey);
          Exit;
        end;
    end;
  RegCloseKey(ResultKey);
  Fail:
  Result := Default;
end;

{ ---------------------------------------------------------------------------- }

function RegReadStrDefW(const Key: HKEY; const SubKey, ValueName, Default: WideString): WideString;
label
  Fail;
var
  ResultKey: HKEY;
  ValueType: DWORD;
  DataSize: DWORD;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if RegOpenKeyExW(Key, Pointer(SubKey), 0, KEY_READ, ResultKey) <> ERROR_SUCCESS then goto Fail;
      if (RegQueryValueExW(ResultKey, Pointer(ValueName), nil, @ValueType, nil, @DataSize) = ERROR_SUCCESS) and
        (ValueType in [REG_EXPAND_SZ, REG_SZ]) then
        begin
          SetString(Result, nil, DataSize - 1);
          if RegQueryValueExW(ResultKey, Pointer(ValueName), nil, nil, Pointer(Result), @DataSize) = ERROR_SUCCESS then
            begin
              RegCloseKey(ResultKey);
              Exit;
            end;
        end;
      RegCloseKey(ResultKey);
      Fail:
      Result := Default;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    RegReadStrDefA(Key, SubKey, ValueName, Default);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

const
  HKLM_CURRENT_VERSION_NT = 'Software\Microsoft\Windows NT\CurrentVersion';
  HKLM_CURRENT_VERSION_WINDOWS = 'Software\Microsoft\Windows\CurrentVersion';

function RegReadRegisteredOrganizationA: AnsiString;
begin
  Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOrganization', '');
  if Result = '' then
    Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_WINDOWS, 'RegisteredOrganization', '');
end;

{ ---------------------------------------------------------------------------- }

function RegReadRegisteredOrganizationW: WideString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    Result := RegReadStrDefW(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOrganization', '')
      {$IFNDEF DI_No_Win_9X_Support}
  else
    Result := RegReadRegisteredOrganizationA;
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function RegReadRegisteredOwnerA: AnsiString;
begin
  Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOwner', '');
  if Result = '' then
    Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_WINDOWS, 'RegisteredOwner', '');
end;

{ ---------------------------------------------------------------------------- }

function RegReadRegisteredOwnerW: WideString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    Result := RegReadStrDefW(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOwner', '')
      {$IFNDEF DI_No_Win_9X_Support}
  else
    Result := RegReadRegisteredOwnerA;
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

procedure StrRemoveFromToIA(var Source: AnsiString; const FromString, ToString: AnsiString);
var
  l, lFromString, lToString: Cardinal;
  Dest, a2, b1, b2: Cardinal;
begin
  Dest := StrPosIA(FromString, Source);
  if Dest = 0 then Exit;

  if Pointer(FromString) = nil
    then
    lFromString := 0
  else
    lFromString := PCardinal(Cardinal(FromString) - 4)^;

  b1 := StrPosIA(ToString, Source, Dest + lFromString);
  if b1 = 0 then Exit;

  if Pointer(ToString) = nil
    then
    lToString := 0
  else
    lToString := PCardinal(Cardinal(ToString) - 4)^;
  Inc(b1, lToString);

  UniqueString(Source);

  while True do
    begin
      a2 := StrPosIA(FromString, Source, b1);
      if a2 = 0 then Break;

      b2 := StrPosIA(ToString, Source, a2 + lFromString);
      if b2 = 0 then Break;
      Inc(b2, lToString);

      System.Move(Source[b1], Source[Dest], a2 - b1);
      Inc(Dest, a2 - b1);
      b1 := b2;
    end;

  { We do not need to test Source against nil,
    as we already know that it containns data. }
  l := PCardinal(Cardinal(Source) - 4)^ - b1;

  System.Move(Source[b1], Source[Dest], l + 1);
  SetLength(Source, Dest + l);
end;

{ ---------------------------------------------------------------------------- }

procedure StrRemoveFromToIW(var Source: WideString; const FromString, ToString: WideString);
var
  l, lFromString, lToString: Cardinal;
  Dest, a2, b1, b2: Cardinal;
begin
  Dest := StrPosIW(FromString, Source);
  if Dest = 0 then Exit;

  lFromString := Cardinal(FromString);
  if lFromString <> 0 then lFromString := PCardinal(lFromString - 4)^ div 2;

  b1 := StrPosIW(ToString, Source, Dest + lFromString);
  if b1 = 0 then Exit;

  lToString := Cardinal(ToString);
  if lToString <> 0 then lToString := PCardinal(lToString - 4)^ div 2;

  Inc(b1, lToString);

  // UniqueString(Source); // Not necessary. Windows WideStrings are always single reference.

  while True do
    begin
      a2 := StrPosIW(FromString, Source, b1);
      if a2 = 0 then Break;

      b2 := StrPosIW(ToString, Source, a2 + lFromString);
      if b2 = 0 then Break;
      Inc(b2, lToString);

      System.Move(Source[b1], Source[Dest], (a2 - b1) * SizeOf(WideChar));
      Inc(Dest, a2 - b1);
      b1 := b2;
    end;

  { We do not need to test Source against nil,
    as we already know that it containns data. }
  l := PCardinal(Cardinal(Source) - 4)^ div 2 - b1;

  System.Move(Source[b1], Source[Dest], (l + 1) * SizeOf(WideChar));
  SetLength(Source, Dest + l);
end;

{ ---------------------------------------------------------------------------- }

procedure StrRemoveSpacing(var s: AnsiString; const SpaceChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE);
var
  I, l: Cardinal;
  pRead, PWrite: PAnsiChar;
begin
  pRead := Pointer(s);
  if pRead = nil then Exit;
  l := PCardinal(pRead - 4)^;

  I := l;
  // Advance to first space character.
  while (I > 0) and not (pRead^ in SpaceChars) do
    begin
      Inc(pRead);
      Dec(I);
    end;

  // End of string reached?
  if I = 0 then Exit;

  // Ensure string is unique and resides in memory.
  UniqueString(s);
  pRead := Pointer(Cardinal(s) + l - I);
  PWrite := pRead;

  while I > 0 do
    begin

      // Consider next char: Space or not?
      Inc(pRead);
      Dec(I);

      if pRead^ in SpaceChars then
        begin
          // Double space:
          // Write ReplaceChar ...
          PWrite^ := ReplaceChar;
          Inc(PWrite);
          // ... and skip additional spaces.
          while (I > 0) and (pRead^ in SpaceChars) do
            begin
              Inc(pRead);
              Dec(I);
            end;
        end;

      // Write text up to next SpaceChar.
      while (I > 0) and not (pRead^ in SpaceChars) do
        begin
          PWrite^ := pRead^;
          Inc(PWrite);
          Inc(pRead);
          Dec(I);
        end;

    end;

  SetLength(s, Cardinal(PWrite) - Cardinal(s));
end;

{ ---------------------------------------------------------------------------- }

procedure StrRemoveSpacing(var w: WideString; IsSpaceChar: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE);
var
  I, l: Cardinal;
  pRead, PWrite: PWideChar;
begin
  pRead := Pointer(w);
  if pRead = nil then Exit;
  l := PCardinal(pRead - 2)^ div 2;

  if not Assigned(IsSpaceChar) then
    IsSpaceChar := IsCharWhiteSpaceW;

  I := l;
  // Advance to first space character.
  while (I > 0) and not IsSpaceChar(pRead^) do
    begin
      Inc(pRead);
      Dec(I);
    end;

  // End of string reached?
  if I = 0 then Exit;

  PWrite := pRead;

  while I > 0 do
    begin

      // Consider next char: Space or not?
      Inc(pRead);
      Dec(I);

      if IsSpaceChar(pRead^) then
        begin
          // Double space:
          // Write ReplaceChar ...
          PWrite^ := ReplaceChar;
          Inc(PWrite);
          // ... and skip additional spaces.
          while (I > 0) and IsSpaceChar(pRead^) do
            begin
              Inc(pRead);
              Dec(I);
            end;
        end;

      // Write text up to next SpaceChar.
      while (I > 0) and not IsSpaceChar(pRead^) do
        begin
          PWrite^ := pRead^;
          Inc(PWrite);
          Inc(pRead);
          Dec(I);
        end;

    end;

  SetLength(w, (Cardinal(PWrite) - Cardinal(w)) div 2);
end;

{ ---------------------------------------------------------------------------- }

procedure StrReplaceCharA(var Source: AnsiString; const SearchChar, ReplaceChar: AnsiChar);
label
  One, Two, Three, Found;
var
  p: PAnsiChar;
  l, I: Cardinal;
begin
  p := Pointer(Source);
  if p = nil then Exit;
  l := PCardinal(p - 4)^;

  I := l;
  while I >= 4 do
    begin
      if p^ = SearchChar then goto Found;
      if p[1] = SearchChar then goto One;
      if p[2] = SearchChar then goto Two;
      if p[3] = SearchChar then goto Three;
      Inc(p, 4);
      Dec(I, 4);
    end;

  case I of
    3:
      begin
        if (p^ = SearchChar) then goto Found;
        if (p[1] = SearchChar) then goto One;
        if (p[2] = SearchChar) then goto Two;
      end;
    2:
      begin
        if (p^ = SearchChar) then goto Found;
        if (p[1] = SearchChar) then goto One;
      end;
    1:
      if (p^ = SearchChar) then goto Found;
  end;

  Exit;

  One:
  Dec(I);
  goto Found;

  Two:
  Dec(I, 2);
  goto Found;

  Three:
  Dec(I, 3);
  goto Found;

  Found:

  UniqueString(Source);
  p := Pointer(Source);
  if p = nil then Exit;
  Inc(p, l - I);

  p^ := ReplaceChar;
  Inc(p);
  Dec(I);

  while I >= 4 do
    begin
      if p^ = SearchChar then p^ := ReplaceChar;
      if p[1] = SearchChar then p[1] := ReplaceChar;
      if p[2] = SearchChar then p[2] := ReplaceChar;
      if p[3] = SearchChar then p[3] := ReplaceChar;
      Inc(p, 4);
      Dec(I, 4);
    end;

  case I of
    3:
      begin
        if p^ = SearchChar then p^ := ReplaceChar;
        if p[1] = SearchChar then p[1] := ReplaceChar;
        if p[2] = SearchChar then p[2] := ReplaceChar;
      end;
    2:
      begin
        if p^ = SearchChar then p^ := ReplaceChar;
        if p[1] = SearchChar then p[1] := ReplaceChar;
      end;
    1:
      begin
        if p^ = SearchChar then p^ := ReplaceChar;
      end;
  end;
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceA(const Source, Search, Replace: AnsiString): AnsiString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: AnsiChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PAnsiChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin
  { Test if strings are not nil. }
  PSource := Pointer(Source);
  if PSource = nil then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  if pSearch = nil then goto ReturnSourceString;

  lSource := PCardinal(Cardinal(PSource) - 4)^;
  lSearch := PCardinal(Cardinal(pSearch) - 4)^;

  { Can search possibly be in source? }
  if lSearch > lSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^;

  { Set length of result string. }
  if lSearch > lReplace then
    SetLength(Result, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  PResult := Pointer(Result);

  // c := pSearch^;

  // Inc (pSearch);
  Dec(lSearch);

  while lSource > lSearch do
    begin
      { Copy until possible match. }
      c := pSearch^; // Increase Priority of c.
      while lSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            if PSource[2] = c then goto Two;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^); PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if PSource^ = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(lSource);
          end;
      end;

      { Here we have no first-char-match and no more chars left to check. }
      Break;

      Three:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^); PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(lSource);

      Match:

      { Test for match. We know that the first character already matches. }
      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (pTempSource^ = pTemp^) and
        (pTempSource[1] = pTemp[1]) and
        (pTempSource[2] = pTemp[2]) and
        (pTempSource[3] = pTemp[3]) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if ((lTemp = 1) and (pTempSource^ = pTemp^)) then goto Copy;
      if ((lTemp = 2) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1])) then goto Copy;
      if ((lTemp = 3) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) and (pTempSource[2] = pTemp[2])) then goto Copy;

      { No match: We assume this to be the more likely case.
        Copy one character and forward source string by 1. }
      PResult^ := pSearch^;
      Inc(PResult);

      Continue;

      Copy:
      { Copy replace string to result string. }
      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, Cardinal(PResult) - Cardinal(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceW(const Source, Search, Replace: WideString): WideString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: WideChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PWideChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin
  { Test if strings are not nil. }
  PSource := Pointer(Source);
  lSource := Cardinal(PSource);
  if lSource = 0 then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  lSearch := Cardinal(pSearch);
  if lSearch = 0 then goto ReturnSourceString;

  lSource := PCardinal(lSource - 4)^ div 2;
  lSearch := PCardinal(lSearch - 4)^ div 2;

  { Can search possibly be in source? }
  if lSearch > lSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^ div 2;

  { Set length of result string. }
  if lSearch >= lReplace then
    SetString(Result, nil, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  PResult := Pointer(Result);

  // c := pSearch^;

  // Inc (pSearch);
  Dec(lSearch);

  while lSource > lSearch do
    begin
      { Copy until possible match. }
      c := pSearch^; // Increase Priority of c.
      while lSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            if PSource[2] = c then goto Two;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if PSource^ = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(lSource);
          end;
      end;

      { Here we have no first-char-match and no more chars left to check. }
      Break;

      Three:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(lSource);

      Match:

      { Test for match. We know that the first character already matches. }
      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (pTempSource^ = pTemp^) and
        (pTempSource[1] = pTemp[1]) and
        (pTempSource[2] = pTemp[2]) and
        (pTempSource[3] = pTemp[3]) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if (lTemp = 1) and (pTempSource^ = pTemp^) then goto Copy;
      if (lTemp = 2) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) then goto Copy;
      if (lTemp = 3) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) and (pTempSource[2] = pTemp[2]) then goto Copy;

      { No match: We assume this to be the more likely case.
        Copy one character and forward source string by 1. }
      PResult^ := PSource[-1];
      Inc(PResult);

      Continue;

      Copy:
      { Copy replace string to result string. }
      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Int64(Pointer(PResult)^) := Int64(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, (Cardinal(PResult) - Cardinal(Result)) div 2);
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceIA(const Source, Search, Replace: AnsiString): AnsiString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: AnsiChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PAnsiChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin
  { Test if strings are not nil. }
  PSource := Pointer(Source);
  if PSource = nil then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  if pSearch = nil then goto ReturnSourceString;

  lSource := PCardinal(Cardinal(PSource) - 4)^;
  lSearch := PCardinal(Cardinal(pSearch) - 4)^;

  { Can search possibly be in source? }
  if lSearch > lSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^;

  { Set length of result string. }
  if lSearch > lReplace then
    SetLength(Result, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  PResult := Pointer(Result);

  // c := pSearch^;

  // Inc (pSearch);
  Dec(lSearch);

  while lSource > lSearch do
    begin
      { Copy until possible match. }
      c := ANSI_UPPER_CHAR_TABLE[pSearch^]; // Increase Priority of c.
      while lSource >= 4 do
        begin
          if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
          if ANSI_UPPER_CHAR_TABLE[PSource[1]] = c then goto One;
          if ANSI_UPPER_CHAR_TABLE[PSource[2]] = c then goto Two;
          if ANSI_UPPER_CHAR_TABLE[PSource[3]] = c then goto Three;
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
            if ANSI_UPPER_CHAR_TABLE[PSource[1]] = c then goto One;
            if ANSI_UPPER_CHAR_TABLE[PSource[2]] = c then goto Two;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^); PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
            if ANSI_UPPER_CHAR_TABLE[PSource[1]] = c then goto One;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(lSource);
          end;
      end;

      { Here we have no first-char-match and no more chars left to check. }
      Break;

      Three:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
      PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(lSource);

      Match:

      { Test for match. We know that the first character already matches. }
      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and
        ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]])) and
        ((pTempSource[2] = pTemp[2]) or (pTempSource[2] = ANSI_REVERSE_CHAR_TABLE[pTemp[2]])) and
        ((pTempSource[3] = pTemp[3]) or (pTempSource[3] = ANSI_REVERSE_CHAR_TABLE[pTemp[3]])) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if ((lTemp = 1) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^]))) then goto Copy;
      if ((lTemp = 2) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]]))) then goto Copy;
      if ((lTemp = 3) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]])) and ((pTempSource[2] = pTemp[2]) or (pTempSource[2] = ANSI_REVERSE_CHAR_TABLE[pTemp[2]]))) then goto Copy;

      { No match: We assume this to be the more likely case.
        Copy one character and forward source string by 1. }
      PResult^ := PSource[-1];
      Inc(PResult);

      Continue;

      Copy:
      { Copy replace string to result string. }
      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, Cardinal(PResult) - Cardinal(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceIW(const Source, Search, Replace: WideString): WideString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: WideChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PWideChar;
  lSearch, lSource, lReplace, lTemp: Cardinal;
begin
  { Test if strings are not nil. }
  PSource := Pointer(Source);
  lSource := Cardinal(PSource);
  if lSource = 0 then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  lSearch := Cardinal(pSearch);
  if lSearch = 0 then goto ReturnSourceString;

  lSource := PCardinal(lSource - 4)^ div 2;
  lSearch := PCardinal(lSearch - 4)^ div 2;

  { Can search possibly be in source? }
  if lSearch > lSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^ div 2;

  { Set length of result string. }
  if lSearch >= lReplace then
    SetString(Result, nil, lSource)
  else
    SetLength(Result, (lSource div lSearch) * lReplace + lSource mod lSearch);
  PResult := Pointer(Result);

  // c := pSearch^;

  // Inc (pSearch);
  Dec(lSearch);

  while lSource > lSearch do
    begin
      { Copy until possible match. }
      c := CharToCaseFoldW(pSearch^); // Increase Priority of c.
      while lSource >= 4 do
        begin
          if CharToCaseFoldW(PSource^) = c then goto Zero;
          if CharToCaseFoldW(PSource[1]) = c then goto One;
          if CharToCaseFoldW(PSource[2]) = c then goto Two;
          if CharToCaseFoldW(PSource[3]) = c then goto Three;
          Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            if CharToCaseFoldW(PSource[1]) = c then goto One;
            if CharToCaseFoldW(PSource[2]) = c then goto Two;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(lSource, 3);
          end;
        2:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            if CharToCaseFoldW(PSource[1]) = c then goto One;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(lSource, 2);
          end;
        1:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(lSource);
          end;
      end;

      { Here we have no first-char-match and no more chars left to check. }
      Break;

      Three:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(lSource, 4);
      goto Match;

      Two:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(lSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(lSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(lSource);

      Match:

      { Test for match. We know that the first character already matches. }
      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and
        (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) and
        (CharToCaseFoldW(pTempSource[2]) = CharToCaseFoldW(pTemp[2])) and
        (CharToCaseFoldW(pTempSource[3]) = CharToCaseFoldW(pTemp[3])) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if (lTemp = 1) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) then goto Copy;
      if (lTemp = 2) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) then goto Copy;
      if (lTemp = 3) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) and (CharToCaseFoldW(pTempSource[2]) = CharToCaseFoldW(pTemp[2])) then goto Copy;

      { No match: We assume this to be the more likely case.
        Copy one character and forward source string by 1. }
      PResult^ := PSource[-1];
      Inc(PResult);

      Continue;

      Copy:
      { Copy replace string to result string. }
      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Int64(Pointer(PResult)^) := Int64(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(lSource, lSearch);
    end;

  while lSource >= 4 do
    begin
      Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(lSource, 4);
    end;
  case lSource of
    3:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, (Cardinal(PResult) - Cardinal(Result)) div 2);
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceLoopA(const Source, Search, Replace: AnsiString): AnsiString;
begin
  Result := Source;
  while StrPosA(Search, Result) > 0 do
    Result := StrReplaceA(Result, Search, Replace);
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceLoopW(const Source, Search, Replace: WideString): WideString;
begin
  Result := Source;
  while StrPosW(Search, Result) > 0 do
    Result := StrReplaceW(Result, Search, Replace);
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceLoopIA(const Source, Search, Replace: AnsiString): AnsiString;
begin
  Result := Source;
  while StrPosIA(Search, Result) > 0 do
    Result := StrReplaceIA(Result, Search, Replace);
end;

{ ---------------------------------------------------------------------------- }

function StrReplaceLoopIW(const Source, Search, Replace: WideString): WideString;
begin
  Result := Source;
  while StrPosIW(Search, Result) > 0 do
    Result := StrReplaceIW(Result, Search, Replace);
end;

{ ---------------------------------------------------------------------------- }

function RightMostBit(const Value: Cardinal): Integer;
asm
  MOV ECX, EAX
  MOV EAX, -1
  BSF EAX, ECX
end;

{ ---------------------------------------------------------------------------- }

function StrSameA(const S1, S2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  p2 := Pointer(S2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 <> l2 then goto Fail;

  while l1 >= 4 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameW(const S1, S2: WideString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^; // Cut length in half below.

  p2 := Pointer(S2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^; // Cut length in half below.

  if l1 <> l2 then goto Fail;

  l1 := l1 div 2; // We are dealing with WideStrings here, so cut length by half.
  while l1 >= 2 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 2);
      Inc(p2, 2);
      Dec(l1, 2);
    end;

  if (l1 = 1) and (p1^ <> p2^) then goto Fail;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameIA(const S1, S2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  p2 := Pointer(S2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 <> l2 then goto Fail;

  while l1 >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
          (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Fail;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameIW(const S1, S2: WideString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^; // Cut length in half below.

  p2 := Pointer(S2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^; // Cut length in half below.

  if l1 <> l2 then goto Fail;

  l1 := l1 div 2; // We are dealing with WideStrings here, so cut length by half.
  while l1 >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      end;
  end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameStartA(const S1, S2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  p2 := Pointer(S2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 > l2 then l1 := l2;

  while l1 >= 4 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameStartW(const w1, w2: WideString): Boolean;
label
  Fail, Match;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(w1);
  p2 := Pointer(w1);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;

  l1 := PCardinal(p1 - 2)^;
  l2 := PCardinal(p2 - 2)^;

  if l1 > l2 then l1 := l2;

  l1 := l1 div 2; // We are dealing with WideStrings here, so cut length by half.
  while l1 >= 4 do
    begin
      if PInt64(p1)^ <> PInt64(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameStartIA(const S1, S2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  p2 := Pointer(S2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 > l2 then l1 := l2;

  while l1 >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
          (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Fail;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrSameStartIW(const w1, w2: WideString): Boolean;
label
  Fail, Match;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(w1);
  p2 := Pointer(w2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;

  l1 := PCardinal(p1 - 2)^;
  l2 := PCardinal(p2 - 2)^;

  if l1 > l2 then l1 := l2;

  l1 := l1 div 2; // We are dealing with WideStrings here, so cut length by half.
  while l1 >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      end;
    1:
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function LoadStrFromFile(var s: AnsiString; const FileHandle: THandle): Boolean; overload;
label
  ReturnFalse;
var
  FileSize, NumberOfBytesRead: DWORD;
begin
  FileSize := GetFileSize(FileHandle, nil);
  if FileSize <> $FFFFFFFF then
    begin
      SetLength(s, FileSize);
      Result := ReadFile(FileHandle, Pointer(s)^, FileSize, NumberOfBytesRead, nil) and
        (FileSize = NumberOfBytesRead);
      if not Result then SetLength(s, NumberOfBytesRead);
    end
  else
    Result := False;
end;

{ ---------------------------------------------------------------------------- }

function LoadStrFromFileA(const FileName: AnsiString; var s: AnsiString): Boolean; overload;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := LoadStrFromFile(s, FileHandle);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;

{ ---------------------------------------------------------------------------- }

function LoadStrFromFileW(const FileName: WideString; var s: AnsiString): Boolean; overload;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := LoadStrFromFile(s, FileHandle);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := LoadStrFromFileA(FileName, s);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function LoadStrFromFile(const FileHandle: THandle; var s: WideString): Boolean; overload;
label
  ReturnFalse;
var
  FileSize, NumberOfBytesRead: DWORD;
begin
  FileSize := GetFileSize(FileHandle, nil);
  if FileSize <> $FFFFFFFF then
    begin
      FileSize := FileSize and not 1;
      SetLength(s, FileSize div 2);
      Result := ReadFile(FileHandle, Pointer(s)^, FileSize, NumberOfBytesRead, nil) and
        (FileSize = NumberOfBytesRead);
      if not Result then SetLength(s, NumberOfBytesRead div 2);
    end
  else
    Result := False;
end;

{ ---------------------------------------------------------------------------- }

function LoadStrFromFileA(const FileName: AnsiString; var s: WideString): Boolean; overload;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := LoadStrFromFile(FileHandle, s);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;

{ ---------------------------------------------------------------------------- }

function LoadStrFromFileW(const FileName: WideString; var s: WideString): Boolean; overload;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := LoadStrFromFile(FileHandle,s);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := LoadStrFromFileA(FileName, s);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function SaveBufToFile(const Buffer; const BufferSize: Cardinal; const FileHandle: THandle): Boolean;
var
  NumberOfBytesWritten: DWORD;
begin
  Result := WriteFile(FileHandle, Buffer, BufferSize, NumberOfBytesWritten, nil) and (BufferSize = NumberOfBytesWritten);
end;

{ ---------------------------------------------------------------------------- }

function SaveBufToFileA(const Buffer; const BufferSize: Cardinal; const FileName: AnsiString): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;

{ ---------------------------------------------------------------------------- }

function SaveBufToFileW(const Buffer; const BufferSize: Cardinal; const FileName: WideString): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SaveBufToFileA(Buffer, BufferSize, FileName);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function SaveAStrToFileA(const s: AnsiString; const FileName: AnsiString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileA(Pointer(s)^, l, FileName);
end;

{ ---------------------------------------------------------------------------- }

function SaveAStrToFileW(const s: AnsiString; const FileName: WideString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileW(Pointer(s)^, l, FileName);
end;

{ ---------------------------------------------------------------------------- }

function SaveWStrToFileA(const w: WideString; const FileName: AnsiString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileA(Pointer(w)^, l, FileName);
end;

{ ---------------------------------------------------------------------------- }

function SaveWStrToFileW(const w: WideString; const FileName: WideString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileW(Pointer(w)^, l, FileName);
end;

{ ---------------------------------------------------------------------------- }

function StrPosCharA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  { Alternatively compare four bytes / characters at a time:

  Compare := Byte (c);
  Compare := (Compare shl 8) or Compare;
  Compare := (Compare shl 16) or Compare;

  while l >= 4 do
   begin
    if (((not (p^ xor Compare)) and (p^ - $01010101)) and $80808080) <> 0 then Break;
    Inc (p);
    Dec (l, 4);
   end;}

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[1] = c then goto One;
      if p[2] = c then goto Two;
      if p[3] = c then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
        if (p[2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source) + 2;
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) + 3;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) + 4;
end;

{ ---------------------------------------------------------------------------- }

function StrPosCharBackA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;

  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[-1] = c then goto One;
      if p[-2] = c then goto Two;
      if p[-3] = c then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
        if (p[-2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source);
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) - 1;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) - 2;
end;

{ ---------------------------------------------------------------------------- }

function StrPosCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[1] in Search then goto One;
      if p[2] in Search then goto Two;
      if p[3] in Search then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
        if (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source) + 2;
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) + 3;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) + 4;
end;

{ ---------------------------------------------------------------------------- }

function StrPosCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^ div 2;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if Validate(p^) then goto Zero;
      if Validate(p[1]) then goto One;
      if Validate(p[2]) then goto Two;
      if Validate(p[3]) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if Validate(p^) then goto Zero;
        if Validate(p[1]) then goto One;
        if Validate(p[2]) then goto Two;
      end;
    2:
      begin
        if Validate(p^) then goto Zero;
        if Validate(p[1]) then goto One;
      end;
    1:
      if Validate(p^) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 1;
  Exit;

  One:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 2;
  Exit;

  Two:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 3;
  Exit;

  Three:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 4;
end;

{ ---------------------------------------------------------------------------- }

function StrPosCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;

  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[-1] in Search then goto One;
      if p[-2] in Search then goto Two;
      if p[-3] in Search then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[-1] in Search) then goto One;
        if (p[-2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[-1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source);
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) - 1;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) - 2;
end;

{ ---------------------------------------------------------------------------- }

function StrPosNotCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not (p^ in Search) then goto Zero;
      if not (p[1] in Search) then goto One;
      if not (p[2] in Search) then goto Two;
      if not (p[3] in Search) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[1] in Search) then goto One;
        if not (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[1] in Search) then goto One;
      end;
    1:
      if not (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source) + 2;
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) + 3;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) + 4;
end;

{ ---------------------------------------------------------------------------- }

function StrPosNotCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ div 2;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not Validate(p^) then goto Zero;
      if not Validate(p[1]) then goto One;
      if not Validate(p[2]) then goto Two;
      if not Validate(p[3]) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not Validate(p^) then goto Zero;
        if not Validate(p[1]) then goto One;
        if not Validate(p[2]) then goto Two;
      end;
    2:
      begin
        if not Validate(p^) then goto Zero;
        if not Validate(p[1]) then goto One;
      end;
    1:
      if not Validate(p^) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 1;
  Exit;

  One:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 2;
  Exit;

  Two:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 3;
  Exit;

  Three:
  Result := (Cardinal(p) - Cardinal(Source)) div 2 + 4;
end;

{ ---------------------------------------------------------------------------- }

function StrPosNotCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;

  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if not (p^ in Search) then goto Zero;
      if not (p[-1] in Search) then goto One;
      if not (p[-2] in Search) then goto Two;
      if not (p[-3] in Search) then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[-1] in Search) then goto One;
        if not (p[-2] in Search) then goto Two;
      end;
    2:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[-1] in Search) then goto One;
      end;
    1:
      if not (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source);
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) - 1;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) - 2;
end;

{ ---------------------------------------------------------------------------- }

function SetFileDate(const FileHandle: THandle; const Year: Integer; const Month, Day: Word): Boolean;
var
  SystemTime: TSystemTime;
  FileTime: TFileTime;
begin
  with SystemTime do
    begin
      wYear := Year;
      wMonth := Month;
      wDay := Day;
      wHour := 12;
      wMinute := 0;
      wSecond := 0;
      wMilliSeconds := 0;
    end;
  Result :=
    SystemTimeToFileTime(SystemTime, FileTime) and
    SetFileTime(FileHandle, @FileTime, @FileTime, @FileTime);
end;

{ ---------------------------------------------------------------------------- }

function SetFileDateA(const FileName: AnsiString; const JulianDate: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := SetFileDateA(FileName, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function SetFileDateA(const FileName: AnsiString; const Year: Integer; const Month, Day: Word): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (FileHandle <> INVALID_HANDLE_VALUE) and
    SetFileDate(FileHandle, Year, Month, Day) and
    CloseHandle(FileHandle);
end;

{ ---------------------------------------------------------------------------- }

function SetFileDateW(const FileName: WideString; const JulianDate: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := SetFileDateW(FileName, Year, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function SetFileDateW(const FileName: WideString; const Year: Integer; const Month, Day: Word): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      Result := (FileHandle <> INVALID_HANDLE_VALUE) and
        SetFileDate(FileHandle, Year, Month, Day) and
        CloseHandle(FileHandle);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SetFileDateA(FileName, Year, Month, Day);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function StrCompA(const S1, S2: AnsiString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PAnsiChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(S2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if p1^ <> p2^ then goto 0;
      if p1[1] <> p2[1] then goto 1;
      if p1[2] <> p2[2] then goto 2;
      if p1[3] <> p2[3] then goto 3;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
        if p1[2] <> p2[2] then goto 2;
      end;
    2:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
      end;
    1:
      begin
        if p1^ <> p2^ then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(p1^) - Ord(p2^);
  Exit;

  1:
  Result := Ord(p1[1]) - Ord(p2[1]);
  Exit;

  2:
  Result := Ord(p1[2]) - Ord(p2[2]);
  Exit;

  3:
  Result := Ord(p1[3]) - Ord(p2[3]);
end;

{ ---------------------------------------------------------------------------- }

function StrCompIA(const S1, S2: AnsiString): Integer;
label
  Zero, One, Two, Three, Match;
var
  p1, p2: PAnsiChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(S2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
      if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
      if (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Two;
      if (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Three;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
        if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
        if (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Two;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
        if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
      end;
  end;

  if l1 > l2 then
    Result := 1
  else
    if l1 = l2 then
      Result := 0
    else
      Result := -1;
  // Result := l1 - l2;
  Exit;

  Match:
  Result := 0;
  Exit;

  Zero:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1^]) - Ord(ANSI_UPPER_CHAR_TABLE[p2^]);
  Exit;

  One:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[1]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[1]]);
  Exit;

  Two:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[2]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[2]]);
  Exit;

  Three:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[3]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[3]]);
end;

{ ---------------------------------------------------------------------------- }

function StrCompW(const S1, S2: WideString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PWideChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(S2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  l := l div 2; // We are dealing with WideStrings here, so cut length by half.
  while l >= 4 do
    begin
      if p1^ <> p2^ then goto 0;
      if p1[1] <> p2[1] then goto 1;
      if p1[2] <> p2[2] then goto 2;
      if p1[3] <> p2[3] then goto 3;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
        if p1[2] <> p2[2] then goto 2;
      end;
    2:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
      end;
    1:
      begin
        if p1^ <> p2^ then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(p1^) - Ord(p2^);
  Exit;

  1:
  Result := Ord(p1[1]) - Ord(p2[1]);
  Exit;

  2:
  Result := Ord(p1[2]) - Ord(p2[2]);
  Exit;

  3:
  Result := Ord(p1[3]) - Ord(p2[3]);
end;

{ ---------------------------------------------------------------------------- }

function StrCompIW(const S1, S2: WideString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PWideChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(S1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(S2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  l := l div 2; // We are dealing with WideStrings here, so cut length by half.
  while l >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto 2;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto 3;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto 2;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(CharToCaseFoldW(p1^)) - Ord(CharToCaseFoldW(p2^));
  Exit;

  1:
  Result := Ord(CharToCaseFoldW(p1[1])) - Ord(CharToCaseFoldW(p2[1]));
  Exit;

  2:
  Result := Ord(CharToCaseFoldW(p1[2])) - Ord(CharToCaseFoldW(p2[2]));
  Exit;

  3:
  Result := Ord(CharToCaseFoldW(p1[3])) - Ord(CharToCaseFoldW(p2[3]));
end;

{ ---------------------------------------------------------------------------- }

function StrCountCharA(const Source: AnsiString; const c: AnsiChar; const StartIndex: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  Result := 0;
  if p = nil then Exit;

  if StartIndex = 0 then Exit;

  l := PCardinal(Cardinal(p) - 4)^;
  if StartIndex > l then Exit;

  Inc(p, StartIndex - 1);
  Dec(l, StartIndex - 1);

  while l >= 4 do
    begin
      if p^ = c then Inc(Result);
      if p[1] = c then Inc(Result);
      if p[2] = c then Inc(Result);
      if p[3] = c then Inc(Result);
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
        if p[2] = c then Inc(Result);
      end;
    2:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
      end;
    1:
      if p^ = c then Inc(Result);
  end;
end;

{ ---------------------------------------------------------------------------- }

function StrCountCharW(const Source: WideString; const c: WideChar; const StartIndex: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  Result := 0;
  if p = nil then Exit;

  if StartIndex = 0 then Exit;

  l := PCardinal(p - 2)^ div 2;
  if StartIndex > l then Exit;

  Inc(p, StartIndex - 1);
  Dec(l, StartIndex - 1);

  while l >= 4 do
    begin
      if p^ = c then Inc(Result);
      if p[1] = c then Inc(Result);
      if p[2] = c then Inc(Result);
      if p[3] = c then Inc(Result);
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
        if p[2] = c then Inc(Result);
      end;
    2:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
      end;
    1:
      if p^ = c then Inc(Result);
  end;
end;

{ ---------------------------------------------------------------------------- }

function StrMatchesA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;
label
  Fail, Success;
var
  pSearch, PSource: PAnsiChar;
  lSearch, lSource: Cardinal;
begin
  if Start = 0 then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;
  lSource := Cardinal(Pointer(PSource - 4)^);
  if Start > lSource then goto Fail;

  pSearch := Pointer(Search);
  if pSearch = nil then goto Success;
  lSearch := Cardinal(Pointer(pSearch - 4)^);

  Dec(lSource, Start - 1);
  if lSource < lSearch then goto Fail;

  Inc(PSource, Start - 1);

  while lSearch >= 4 do
    begin
      if PCardinal(pSearch)^ <> PCardinal(PSource)^ then goto Fail;
      Inc(pSearch, 4);
      Inc(PSource, 4);
      Dec(lSearch, 4);
    end;

  case lSearch of
    3:
      begin
        if PWord(pSearch)^ <> PWord(PSource)^ then goto Fail;
        if pSearch[2] <> PSource[2] then goto Fail;
      end;
    2:
      begin
        if PWord(pSearch)^ <> PWord(PSource)^ then goto Fail;
      end;
    1:
      begin
        if pSearch^ <> PSource^ then goto Fail;
      end;
  end;

  Success:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrMatchesIA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;
label
  Fail, Success;
var
  pSearch, PSource: PAnsiChar;
  lSearch, lSource: Cardinal;
begin
  if Start = 0 then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;
  lSource := PCardinal(PSource - 4)^;

  if Start > lSource then goto Fail;

  pSearch := Pointer(Search);
  if pSearch = nil then goto Success;
  lSearch := PCardinal(pSearch - 4)^;

  Dec(lSource, Start - 1);
  if lSource < lSearch then goto Fail;

  Inc(PSource, Start - 1);

  while lSearch >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[PSource[1]]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[2]] <> ANSI_UPPER_CHAR_TABLE[PSource[2]]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[3]] <> ANSI_UPPER_CHAR_TABLE[PSource[3]]) then goto Fail;
      Inc(pSearch, 4);
      Inc(PSource, 4);
      Dec(lSearch, 4);
    end;

  case lSearch of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) or
          (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[PSource[1]]) or
          (ANSI_UPPER_CHAR_TABLE[pSearch[2]] <> ANSI_UPPER_CHAR_TABLE[PSource[2]]) then goto Fail;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) or
          (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[PSource[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) then goto Fail;
      end;
  end;

  Success:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{ ---------------------------------------------------------------------------- }

function StrMatchWildA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;
{ Name         Source        Mask        Expected Result
  Back Track   123412345     *12*34*     True
  ? Dilemma    asdf          *s?*f       True
  ? Dilemma    asf          *s?*f        False
  Star Trap 1  *1            *           True
  Star Trap 2  *1            *1          True
  Star Trap 3  *1            *?          True }
label
  Failure, Success, BackTrack;
var
  c: AnsiChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PAnsiChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source);
  SourceLength := Cardinal(SourcePtr);
  if SourceLength <> 0 then SourceLength := PCardinal(SourceLength - 4)^;

  MaskPtr := Pointer(Mask);
  MaskLength := Cardinal(MaskPtr);
  if MaskLength <> 0 then MaskLength := PCardinal(MaskLength - 4)^;

  // First loop up to end of mask or possible WildChar.
  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
      Inc(MaskPtr);
      Inc(SourcePtr);
      Dec(MaskLength);
      Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat
            // Jump over consecutive WildChar
            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr);
                Dec(MaskLength);
              end;

            // If MaskLength is zero at this point,
            // then WildChar is the last char in mask
            // and matches all the rest of source.
            if MaskLength = 0 then goto Success;

            // MaskPtr now points to the next char we have to match.
            // Remember this!
            LastWild := MaskPtr;

            BackTrack:

            // Try to find next matching char in source.
            c := MaskPtr^;
            while (SourceLength > 0) and (c <> MaskChar) and (c <> SourcePtr^) do
              begin
                Inc(SourcePtr);
                Dec(SourceLength);
              end;

            // If we run out of source, there is no match.
            if SourceLength = 0 then goto Failure;

            // Here both mask and source point to the first matching char after WildChar.
            // Advance to the next char which should match and test.
            Inc(SourcePtr);
            Dec(SourceLength);

            // This source char is the starting point for backtracking.
            // Remember this!
            LastSource := SourcePtr;

            Inc(MaskPtr);
            Dec(MaskLength);

            // Try to match chars after WildChar up to another WildChar
            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
                Inc(MaskPtr);
                Inc(SourcePtr);
                Dec(MaskLength);
                Dec(SourceLength);
              end;

            // If not at end of mask and MaskPtr is not WildChar, we need to backtrack.
            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          // Are we at end of source by now?
          if SourceLength = 0 then goto Success;

          // Not at end of source: Test if the last wild-char matches end of source.
          MaskLength := MaskPtr - LastWild;

          // Be careful to consider only source chars not considered yet.
          // If LastWild is initialized, LastSource is also initialized.

          // Is the following line necessary or not?
          // if MaskLength + LastSource > SourcePtr + SourceLength then goto Failure;

          MaskPtr := LastWild;
          Inc(SourcePtr, SourceLength - MaskLength);

          while (MaskLength > 0) do // ((MaskPtr^ = SourcePtr^) or (MaskPtr^ = MaskChar)) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (c <> SourcePtr^) then Break;
              Inc(MaskPtr);
              Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else // if MaskLength > 0
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

{ ---------------------------------------------------------------------------- }

function StrMatchWildIA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;
{ Name         Source        Mask        Expected Result
  Back Track   123412345     *12*34*     True
  ? Dilemma    asdf          *s?*f       True
  ? Dilemma    asf          *s?*f        False
  Star Trap 1  *1            *           True
  Star Trap 2  *1            *1          True
  Star Trap 3  *1            *?          True }
label
  Failure, Success, BackTrack;
var
  c: AnsiChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PAnsiChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source);
  SourceLength := Cardinal(SourcePtr);
  if SourceLength <> 0 then SourceLength := PCardinal(SourceLength - 4)^;

  MaskPtr := Pointer(Mask);
  MaskLength := Cardinal(MaskPtr);
  if MaskLength <> 0 then MaskLength := PCardinal(MaskLength - 4)^;

  // First loop up to end of mask or possible WildChar.
  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^])) then Break;
      Inc(MaskPtr);
      Inc(SourcePtr);
      Dec(MaskLength);
      Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat
            // Jump over consecutive WildChar
            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr);
                Dec(MaskLength);
              end;

            // If MaskLength is zero at this point,
            // then WildChar is the last char in mask
            // and matches all the rest of source.
            if MaskLength = 0 then goto Success;

            // MaskPtr now points to the next char we have to match.
            // Remember this!
            LastWild := MaskPtr;

            BackTrack:

            // Try to find next matching char in source.
            c := ANSI_UPPER_CHAR_TABLE[MaskPtr^];
            while (SourceLength > 0) and (c <> MaskChar) and (c <> ANSI_UPPER_CHAR_TABLE[SourcePtr^]) do
              begin
                Inc(SourcePtr);
                Dec(SourceLength);
              end;

            // If we run out of source, there is no match.
            if SourceLength = 0 then goto Failure;

            // Here both mask and source point to the first matching char after WildChar.
            // Advance to the next char which should match and test.
            Inc(SourcePtr);
            Dec(SourceLength);

            // This source char is the starting point for backtracking.
            // Remember this!
            LastSource := SourcePtr;

            Inc(MaskPtr);
            Dec(MaskLength);

            // Try to match chars after WildChar up to another WildChar
            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^])) then Break;
                Inc(MaskPtr);
                Inc(SourcePtr);
                Dec(MaskLength);
                Dec(SourceLength);
              end;

            // If not at end of mask and MaskPtr is not WildChar, we need to backtrack.
            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          // Are we at end of source by now?
          if SourceLength = 0 then goto Success;

          // Not at end of source: Test if the last wild-char matches end of source.
          MaskLength := MaskPtr - LastWild;

          // Be careful to consider only source chars not considered yet.
          // If LastWild is initialized, LastSource is also initialized.

          // Is the following line necessary or not?
          // if MaskLength + LastSource > SourcePtr + SourceLength then goto Failure;

          MaskPtr := LastWild;
          Inc(SourcePtr, SourceLength - MaskLength);

          while (MaskLength > 0) do // ((MaskPtr^ = SourcePtr^) or (MaskPtr^ = MaskChar)) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^]) then Break;
              Inc(MaskPtr);
              Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else // if MaskLength > 0
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosA(const Search, Source: AnsiString; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  if Start = 0 then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  lSource := PCardinal(PSource - 4)^;

  if lSearch > lSource then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if lSource <= Start - 1 then goto Fail;
  Dec(lSource, Start - 1);
  Inc(PSource, Start - 1);

  c := pSearch^;
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (PSource^ = c) then goto Zero;
          if (PSource[1] = c) then goto One;
          if (PSource[2] = c) then goto Two;
          if (PSource[3] = c) then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
            if (PSource[2] = c) then goto Two;
          end;
        2:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
          end;
        1:
          begin
            if (PSource^ = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if PSourceTemp^ = pSearchTemp^ then goto Success;
        2: if PWord(PSourceTemp)^ = PWord(pSearchTemp)^ then goto Success;
        3: if (PWord(PSourceTemp)^ = PWord(pSearchTemp)^) and (PSourceTemp[2] = pSearchTemp[2]) then goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosW(const Search, Source: WideString; const StartPos: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PWideChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: WideChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  if StartPos = 0 then goto Fail;

  lSearch := PCardinal(Cardinal(pSearch) - 4)^ div 2;
  lSource := PCardinal(Cardinal(PSource) - 4)^ div 2;

  if lSearch > lSource then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if lSource <= StartPos - 1 then goto Fail;
  Dec(lSource, StartPos - 1);
  Inc(PSource, StartPos - 1);

  c := CharToCaseFoldW(pSearch^);
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            if PSource[2] = c then goto Two;
          end;
        2:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
          end;
        1:
          begin
            if PSource^ = c then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[1] = pSearchTemp[1]) and
        (PSourceTemp[2] = pSearchTemp[2]) and
        (PSourceTemp[3] = pSearchTemp[3]) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if PSourceTemp^ = pSearchTemp^ then
            goto Success;
        2: if (PSourceTemp^ = pSearchTemp^) and
          (PSourceTemp[1] = pSearchTemp[1]) then
            goto Success;
        3: if (PSourceTemp^ = pSearchTemp^) and
          (PSourceTemp[1] = pSearchTemp[1]) and
            (PSourceTemp[2] = pSearchTemp[2]) then
            goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := (Cardinal(PSource) - Cardinal(Source)) div 2;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosIA(const Search, Source: AnsiString; const StartPos: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  if StartPos = 0 then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  lSource := PCardinal(PSource - 4)^;

  if lSearch > lSource then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if lSource <= StartPos - 1 then goto Fail;
  Dec(lSource, StartPos - 1);
  Inc(PSource, StartPos - 1);

  c := ANSI_UPPER_CHAR_TABLE[pSearch^];
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[PSource[3]] = c) then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
            if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          end;
        2:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          end;
        1:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[3]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[3]]) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^] then
            goto Success;
        2: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) then
            goto Success;
        3: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
            (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) then
            goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosIW(const Search, Source: WideString; const StartPos: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PWideChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: WideChar;
begin
  pSearch := Pointer(Search);
  lSearch := Cardinal(pSearch);
  if lSearch = 0 then goto Fail;

  PSource := Pointer(Source);
  lSource := Cardinal(PSource);
  if lSource = 0 then goto Fail;

  if StartPos = 0 then goto Fail;

  lSearch := PCardinal(lSearch - 4)^ div 2;
  if lSearch = 0 then goto Fail;

  lSource := PCardinal(lSource - 4)^ div 2;
  if lSearch > lSource then goto Fail;

  Dec(lSearch);
  Dec(lSource, lSearch);

  if lSource <= StartPos - 1 then goto Fail;
  Dec(lSource, StartPos - 1);
  Inc(PSource, StartPos - 1);

  c := CharToCaseFoldW(pSearch^);
  Inc(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if CharToCaseFoldW(PSource^) = c then goto Zero;
          if CharToCaseFoldW(PSource[1]) = c then goto One;
          if CharToCaseFoldW(PSource[2]) = c then goto Two;
          if CharToCaseFoldW(PSource[3]) = c then goto Three;
          Inc(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            if CharToCaseFoldW(PSource[1]) = c then goto One;
            if CharToCaseFoldW(PSource[2]) = c then goto Two;
          end;
        2:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            if CharToCaseFoldW(PSource[1]) = c then goto One;
          end;
        1:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4); { Already Inc (pSource) here. }
      Dec(lSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3); { Already Inc (pSource) here. }
      Dec(lSource, 2);
      goto Match;

      One:
      Inc(PSource, 2); { Already Inc (pSource) here. }
      Dec(lSource, 1);
      goto Match;

      Zero:
      Inc(PSource); { Already Inc (pSource) here. }

      Match:

      { The first character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
        (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) and
        (CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2])) and
        (CharToCaseFoldW(PSourceTemp[3]) = CharToCaseFoldW(pSearchTemp[3])) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^) then
            goto Success;
        2: if (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
          (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) then
            goto Success;
        3: if (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
          (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) and
            (CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2])) then
            goto Success;
      end;

      { No match this time around: Adjust source length. Source itself is already adjusted. }
      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := (Cardinal(PSource) - Cardinal(Source)) div 2;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosBackA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: AnsiChar;
begin
  if Start = 0 then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  lSearch := Cardinal(Pointer(pSearch - 4)^);
  lSource := Cardinal(Pointer(PSource - 4)^);

  if lSource > Start then lSource := Start;

  if lSource < lSearch then goto Fail;

  Inc(PSource, lSource - 1);

  Dec(lSearch);
  Dec(lSource, lSearch);

  Inc(pSearch, lSearch);
  c := pSearch^;
  Dec(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (PSource^ = c) then goto Zero;
          if (PSource[-1] = c) then goto One;
          if (PSource[-2] = c) then goto Two;
          if (PSource[-3] = c) then goto Three;
          Dec(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[-1] = c) then goto One;
            if (PSource[-2] = c) then goto Two;
          end;
        2:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[-1] = c) then goto One;
          end;
        1:
          begin
            if (PSource^ = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Dec(PSource, 4);
      Dec(lSource, 3);
      goto Match;

      Two:
      Dec(PSource, 3);
      Dec(lSource, 2);
      goto Match;

      One:
      Dec(PSource, 2);
      Dec(lSource, 1);
      goto Match;

      Zero:
      Dec(PSource);

      Match:

      { The last character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[-1] = pSearchTemp[-1]) and
        (PSourceTemp[-2] = pSearchTemp[-2]) and
        (PSourceTemp[-3] = pSearchTemp[-3]) do
        begin
          Dec(PSourceTemp, 4);
          Dec(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      if (lSearchTemp = 0) then goto Success;
      if ((lSearchTemp = 1) and
        (PSourceTemp^ = pSearchTemp^)) then goto Success;
      if ((lSearchTemp = 2) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[-1] = pSearchTemp[-1])) then goto Success;
      if ((lSearchTemp = 3) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[-1] = pSearchTemp[-1]) and
        (PSourceTemp[-2] = pSearchTemp[-2])) then goto Success;

      { No match this time. }
      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source) - lSearch + 2;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosBackIA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, lSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  lSource := PCardinal(PSource - 4)^;

  if Start > lSource then goto Fail;
  if Start <> 0 then lSource := Start;

  lSearch := PCardinal(pSearch - 4)^;

  if lSource < lSearch then goto Fail;

  Inc(PSource, lSource - 1);

  Dec(lSearch);
  Dec(lSource, lSearch);

  Inc(pSearch, lSearch);
  c := ANSI_UPPER_CHAR_TABLE[pSearch^];
  Dec(pSearch);

  while lSource > 0 do
    begin

      while lSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[PSource[-1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[PSource[-2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[PSource[-3]] = c) then goto Three;
          Dec(PSource, 4);
          Dec(lSource, 4);
        end;

      case lSource of
        3:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[-1]] = c) then goto One;
            if (ANSI_UPPER_CHAR_TABLE[PSource[-2]] = c) then goto Two;
          end;
        2:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[-1]] = c) then goto One;
          end;
        1:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Dec(PSource, 4);
      Dec(lSource, 3);
      goto Match;

      Two:
      Dec(PSource, 3);
      Dec(lSource, 2);
      goto Match;

      One:
      Dec(PSource, 2);
      Dec(lSource, 1);
      goto Match;

      Zero:
      Dec(PSource);

      Match:

      { The last character already matches. }
      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) and
        ((PSourceTemp[-1] = pSearchTemp[-1]) or (PSourceTemp[-1] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-1]])) and
        ((PSourceTemp[-2] = pSearchTemp[-2]) or (PSourceTemp[-2] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-2]])) and
        ((PSourceTemp[-3] = pSearchTemp[-3]) or (PSourceTemp[-3] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-3]])) do
        begin
          Dec(PSourceTemp, 4);
          Dec(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      if (lSearchTemp = 0) then goto Success;
      if (lSearchTemp = 1) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) then goto Success;
      if (lSearchTemp = 1) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) and
        ((PSourceTemp[-1] = pSearchTemp[-1]) or (PSourceTemp[-1] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-1]])) then goto Success;
      if (lSearchTemp = 3) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) and
        ((PSourceTemp[-1] = pSearchTemp[-1]) or (PSourceTemp[-1] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-1]])) and
        ((PSourceTemp[-2] = pSearchTemp[-2]) or (PSourceTemp[-2] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-2]])) then goto Success;

      { No match this time. }
      Dec(lSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source) - lSearch + 2;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

function StrToIntDefW(const w: WideString; const Default: Integer): Integer;
var
  e: Integer;
begin
  Result := ValIntW(w, e);
  if e <> 0 then Result := Default;
end;

{ ---------------------------------------------------------------------------- }

function StrToInt64DefW(const w: WideString; const Default: Int64): Int64;
var
  e: Integer;
begin
  Result := ValInt64W(w, e);
  if e <> 0 then Result := Default;
end;

{ ---------------------------------------------------------------------------- }

function StrToLowerA(const s: AnsiString): AnsiString;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  if s = '' then Exit;

  p1 := Pointer(s);
  l := PCardinal(Cardinal(p1) - 4)^;

  SetString(Result, nil, l);
  p2 := Pointer(Result);

  while l >= 4 do
    begin
      p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
      p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
      p2[2] := ANSI_LOWER_CHAR_TABLE[p1[2]];
      p2[3] := ANSI_LOWER_CHAR_TABLE[p1[3]];
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
        p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
        p2[2] := ANSI_LOWER_CHAR_TABLE[p1[2]];
      end;
    2:
      begin
        p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
        p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
      end;
    1:
      begin
        p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
      end;
  end;
end;

{ ---------------------------------------------------------------------------- }

function StrToUpperA(const s: AnsiString): AnsiString;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  if s = '' then Exit;

  p1 := Pointer(s);
  l := PCardinal(Cardinal(p1) - 4)^;

  SetString(Result, nil, l);
  p2 := Pointer(Result);

  while l >= 4 do
    begin
      p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
      p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
      p2[2] := ANSI_UPPER_CHAR_TABLE[p1[2]];
      p2[3] := ANSI_UPPER_CHAR_TABLE[p1[3]];
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
        p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
        p2[2] := ANSI_UPPER_CHAR_TABLE[p1[2]];
      end;
    2:
      begin
        p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
        p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
      end;
    1:
      begin
        p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
      end;
  end;
end;

{ ---------------------------------------------------------------------------- }

function SysErrorMessageA(const MessageID: Cardinal): AnsiString;
const
  BUFFER_SIZE = $0100;
var
  l: Cardinal;
begin
  SetString(Result, nil, BUFFER_SIZE);
  l := FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, nil, MessageID, 0, Pointer(Result), BUFFER_SIZE, nil);
  while (l > 0) and (Result[l] in [AC_NULL..AC_SPACE, AC_FULL_STOP]) do
    Dec(l);
  SetLength(Result, l);
end;

{ ---------------------------------------------------------------------------- }

function SysErrorMessageW(const MessageID: Cardinal): WideString;
const
  BUFFER_SIZE = $0100;
var
  l: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      SetString(Result, nil, BUFFER_SIZE);
      l := FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, MessageID, 0, Pointer(Result), BUFFER_SIZE, nil);
      while (l > 0) and (Result[l] in [WC_NULL..WC_SPACE, WC_FULL_STOP]) do
        Dec(l);
      SetLength(Result, l);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SysErrorMessageA(MessageID);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

function TextHeightW(const DC: HDC; const Text: WideString): Integer;
var
  Size: TSize;
begin
  Result := Integer(Text);
  if Result <> 0 then
    begin
      Result := PInteger(Result - 4)^ div 2;
      GetTextExtentPoint32W(DC, Pointer(Text), Result, Size);
      Result := Size.cy;
    end;
end;

{ ---------------------------------------------------------------------------- }

function TextWidthW(const DC: HDC; const Text: WideString): Integer;
var
  Size: TSize;
begin
  Result := Integer(Text);
  if Result <> 0 then
    begin
      Result := PInteger(Result - 4)^ div 2;
      GetTextExtentPoint32W(DC, Pointer(Text), Result, Size);
      Result := Size.cx;
    end;
end;

{ ---------------------------------------------------------------------------- }

function TrimA(const Source: AnsiString): AnsiString;
begin
  Result := TrimA(Source, AS_WHITE_SPACE);
end;

{ ---------------------------------------------------------------------------- }

function TrimA(const Source: AnsiString; const CharToTrim: AnsiChar): AnsiString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Length: Cardinal;
  p, e: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto ReturnEmptyString;

  Length := PCardinal(Cardinal(p) - 4)^;
  if Length = 0 then goto ReturnEmptyString;

  l := Length;
  e := p + l - 1;

  while l >= 4 do
    begin
      if p^ <> CharToTrim then goto BeginZero;
      if p[1] <> CharToTrim then goto BeginOne;
      if p[2] <> CharToTrim then goto BeginTwo;
      if p[3] <> CharToTrim then goto BeginThree;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        if p[1] <> CharToTrim then goto BeginOne;
        if p[2] <> CharToTrim then goto BeginTwo;
        Inc(p, 3);
      end;
    2:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        if p[1] <> CharToTrim then goto BeginOne;
        Inc(p, 2);
      end;
    1:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        Inc(p);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Inc(p, 3);
  goto BeginZero;

  BeginTwo:
  Inc(p, 2);
  goto BeginZero;

  BeginOne:
  Inc(p);

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if e^ <> CharToTrim then goto EndZero;
      if e[-1] <> CharToTrim then goto EndOne;
      if e[-2] <> CharToTrim then goto EndTwo;
      if e[-3] <> CharToTrim then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if e^ <> CharToTrim then goto EndZero;
        if e[-1] <> CharToTrim then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if e^ <> CharToTrim then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Length then
    Result := Source
  else
    begin
      SetString(Result, nil, l);
      e := Pointer(Result);

      while l >= 4 do
        begin
          PCardinal(e)^ := PCardinal(p)^;
          Inc(e, 4);
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          begin
            PWord(e)^ := PWord(p)^;
            e[2] := p[2];
          end;
        2:
          begin
            PWord(e)^ := PWord(p)^;
          end;
        1:
          begin
            e^ := p^;
          end;
      end;
    end;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function TrimA(const Source: AnsiString; const CharsToTrim: TAnsiCharSet): AnsiString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Length: Cardinal;
  p, e: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto ReturnEmptyString;

  Length := PCardinal(p - 4)^;
  if Length = 0 then goto ReturnEmptyString;

  l := Length;
  e := p + l - 1;

  while l >= 4 do
    begin
      if not (p^ in CharsToTrim) then goto BeginZero;
      if not (p[1] in CharsToTrim) then goto BeginOne;
      if not (p[2] in CharsToTrim) then goto BeginTwo;
      if not (p[3] in CharsToTrim) then goto BeginThree;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        if not (p[1] in CharsToTrim) then goto BeginOne;
        if not (p[2] in CharsToTrim) then goto BeginTwo;
        Inc(p, 3);
      end;
    2:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        if not (p[1] in CharsToTrim) then goto BeginOne;
        Inc(p, 2);
      end;
    1:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        Inc(p);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Inc(p, 3);
  goto BeginZero;

  BeginTwo:
  Inc(p, 2);
  goto BeginZero;

  BeginOne:
  Inc(p);

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if not (e^ in CharsToTrim) then goto EndZero;
      if not (e[-1] in CharsToTrim) then goto EndOne;
      if not (e[-2] in CharsToTrim) then goto EndTwo;
      if not (e[-3] in CharsToTrim) then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (e^ in CharsToTrim) then goto EndZero;
        if not (e[-1] in CharsToTrim) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (e^ in CharsToTrim) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Length then
    Result := Source
  else
    begin
      SetLength(Result, l);
      e := Pointer(Result);

      while l >= 4 do
        begin
          PCardinal(e)^ := PCardinal(p)^;
          Inc(e, 4);
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          begin
            PWord(e)^ := PWord(p)^;
            e[2] := p[2];
          end;
        2:
          begin
            PWord(e)^ := PWord(p)^;
          end;
        1:
          begin
            e^ := p^;
          end;
      end;
    end;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function TrimW(const w: WideString): WideString;
begin
  Result := TrimW(w, IsCharWhiteSpaceW);
end;

{ ---------------------------------------------------------------------------- }

function TrimW(const w: WideString; const IsCharToTrim: TDIValidateWideCharFunc): WideString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Length: Cardinal;
  p, e: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto ReturnEmptyString;

  Length := PCardinal(p - 2)^ div 2;
  if Length = 0 then goto ReturnEmptyString;

  l := Length;
  e := p + l - 1;

  while l >= 4 do
    begin
      if not IsCharToTrim(p^) then goto BeginZero;
      if not IsCharToTrim(p[1]) then goto BeginOne;
      if not IsCharToTrim(p[2]) then goto BeginTwo;
      if not IsCharToTrim(p[3]) then goto BeginThree;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        if not IsCharToTrim(p[1]) then goto BeginOne;
        if not IsCharToTrim(p[2]) then goto BeginTwo;
        Inc(p, 3);
      end;
    2:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        if not IsCharToTrim(p[1]) then goto BeginOne;
        Inc(p, 2);
      end;
    1:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        Inc(p);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Inc(p, 3);
  goto BeginZero;

  BeginTwo:
  Inc(p, 2);
  goto BeginZero;

  BeginOne:
  Inc(p);

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if not IsCharToTrim(e^) then goto EndZero;
      if not IsCharToTrim(e[-1]) then goto EndOne;
      if not IsCharToTrim(e[-2]) then goto EndTwo;
      if not IsCharToTrim(e[-3]) then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not IsCharToTrim(e^) then goto EndZero;
        if not IsCharToTrim(e[-1]) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not IsCharToTrim(e^) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Length then
    Result := w
  else
    begin
      SetString(Result, nil, l);
      e := Pointer(Result);

      while l >= 4 do
        begin
          PInt64(e)^ := PInt64(p)^;
          Inc(e, 4);
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          begin
            PCardinal(e)^ := PCardinal(p)^;
            e[2] := p[2];
          end;
        2:
          begin
            PCardinal(e)^ := PCardinal(p)^;
          end;
        1:
          begin
            e^ := p^;
          end;
      end;
    end;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

procedure TrimLeftByRefA(var s: AnsiString; const Chars: TAnsiCharSet);
label
  BeginZero, BeginOne, BeginTwo, BeginThree, ReturnEmptyString;
var
  I, l: Cardinal;
  pRead, PWrite: PAnsiChar;
begin
  pRead := Pointer(s);
  if pRead = nil then Exit;
  l := PCardinal(pRead - 4)^;

  // If first char is not in Chars, there is nothing to trim.
  if (l = 0) or not (pRead^ in Chars) then Exit;

  // Advance to 2nd character.
  Inc(pRead);
  I := l - 1;

  // Skip initial characters to trim.
  while I >= 4 do
    begin
      if not (pRead^ in Chars) then goto BeginZero;
      if not (pRead[1] in Chars) then goto BeginOne;
      if not (pRead[2] in Chars) then goto BeginTwo;
      if not (pRead[3] in Chars) then goto BeginThree;
      Inc(pRead, 4);
      Dec(I, 4);
    end;

  case l of
    3:
      begin
        if not (pRead^ in Chars) then goto BeginZero;
        if not (pRead[1] in Chars) then goto BeginOne;
        if not (pRead[2] in Chars) then goto BeginTwo;
        Dec(I, 3);
      end;
    2:
      begin
        if not (pRead^ in Chars) then goto BeginZero;
        if not (pRead[1] in Chars) then goto BeginOne;
        Dec(I, 2);
      end;
    1:
      begin
        if not (pRead^ in Chars) then goto BeginZero;
        Dec(I);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Dec(I, 3);
  goto BeginZero;

  BeginTwo:
  Dec(I, 2);
  goto BeginZero;

  BeginOne:
  Dec(I);

  BeginZero:

  if I = 0 then goto ReturnEmptyString;

  // Make sure string resides in memory.
  UniqueString(s);
  PWrite := Pointer(s);
  pRead := PWrite + l - I;
  l := I;

  // Copy remaining characters.
  while I >= 4 do
    begin
      PCardinal(PWrite)^ := PCardinal(pRead)^;
      Inc(PWrite, 4);
      Inc(pRead, 4);
      Dec(I, 4);
    end;

  case I of
    3:
      begin
        PWord(PWrite)^ := PWord(pRead)^;
        PWrite[2] := pRead[2];
      end;
    2:
      PWord(PWrite)^ := PWord(pRead)^;
    1:
      PWrite^ := pRead^;
  end;

  SetLength(s, l);
  Exit;

  ReturnEmptyString:
  s := '';
end;

{ ---------------------------------------------------------------------------- }

function TrimRightA(const Source: AnsiString; const s: TAnsiCharSet): AnsiString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, lNew: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto ReturnEmptyString;

  l := PCardinal(p - 4)^;
  if l = 0 then goto ReturnEmptyString;

  lNew := l;
  Inc(p, lNew - 1);

  while lNew >= 4 do
    begin
      if not (p^ in s) then goto EndZero;
      if not (p[-1] in s) then goto EndOne;
      if not (p[-2] in s) then goto EndTwo;
      if not (p[-3] in s) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not (p^ in s) then goto EndZero;
        if not (p[-1] in s) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (p^ in s) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:

  Result := Source;
  if lNew <> l then SetLength(Result, lNew);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

procedure TrimCompress(var s: AnsiString; const TrimCompressChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE);
label
  ReturnEmptyString, SetLengthWrite;
var
  I, j, l: Cardinal;
  pRead, PWrite: PAnsiChar;
begin
  pRead := Pointer(s);
  if pRead = nil then Exit;
  l := PCardinal(pRead - 4)^;
  if l = 0 then Exit;

  I := l;
  if pRead^ in TrimCompressChars then
    begin
      // Skip initial CompressChars
      repeat
        Dec(I);
        if I = 0 then goto ReturnEmptyString;
        Inc(pRead);
      until not (pRead^ in TrimCompressChars);

      UniqueString(s);
      PWrite := Pointer(s);
      pRead := PWrite + l - I;
    end
  else
    begin

      repeat
        // Skip Text.
        repeat
          Dec(I);
          if I = 0 then Exit;
          Inc(pRead);
        until pRead^ in TrimCompressChars;

        PWrite := pRead;

        // Skip Compress Chars.
        repeat
          Dec(I);
          if I = 0 then goto SetLengthWrite;
          Inc(pRead);
        until not (pRead^ in TrimCompressChars);

        j := pRead - PWrite;
      until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      UniqueString(s);
      pRead := Pointer(Cardinal(s) + l - I);
      PWrite := pRead - j;
      PWrite^ := ReplaceChar;

      if j = 1 then
        repeat
          // Skip Text.
          repeat
            Dec(I);
            if I = 0 then Exit;
            Inc(pRead);
          until pRead^ in TrimCompressChars;

          PWrite := pRead;

          // Skip Compress Chars.
          repeat
            Dec(I);
            if I = 0 then goto SetLengthWrite;
            Inc(pRead);
          until not (pRead^ in TrimCompressChars);

          PWrite^ := ReplaceChar;

          j := pRead - PWrite;
        until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      Inc(PWrite);
    end;

  // Main Loop - eventually used by both of the above branches.
  repeat

    // Copy non-CompressChars
    repeat
      PWrite^ := pRead^;
      Inc(PWrite);
      Dec(I);
      if I = 0 then goto SetLengthWrite;
      Inc(pRead);
    until pRead^ in TrimCompressChars;

    // Skip CompressChars
    repeat
      Dec(I);
      if I = 0 then goto SetLengthWrite;
      Inc(pRead);
    until not (pRead^ in TrimCompressChars);

    PWrite^ := ReplaceChar;
    Inc(PWrite);

  until False;

  SetLengthWrite:
  SetLength(s, Cardinal(PWrite) - Cardinal(s));
  Exit;

  ReturnEmptyString:
  s := '';
end;

{ ---------------------------------------------------------------------------- }

procedure TrimCompress(var w: WideString; Validate: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE);
label
  ReturnEmptyString, SetLengthWrite;
var
  I, j, l: Cardinal;
  pRead, PWrite: PWideChar;
begin
  pRead := Pointer(w);
  if pRead = nil then Exit;
  l := PCardinal(pRead - 2)^ div 2;
  if l = 0 then Exit;

  if not Assigned(Validate) then
    Validate := IsCharWhiteSpaceW;

  I := l;
  if Validate(pRead^) then
    begin
      // Skip initial CompressChars
      repeat
        Dec(I);
        if I = 0 then goto ReturnEmptyString;
        Inc(pRead);
      until not Validate(pRead^);

      // UniqueString(s); // Not necessary. Windows WideStrings are always single reference.
      PWrite := Pointer(w);
      pRead := PWrite + l - I;
    end
  else
    begin

      repeat
        // Skip Text.
        repeat
          Dec(I);
          if I = 0 then Exit;
          Inc(pRead);
        until Validate(pRead^);

        PWrite := pRead;

        // Skip Compress Chars.
        repeat
          Dec(I);
          if I = 0 then goto SetLengthWrite;
          Inc(pRead);
        until not Validate(pRead^);

        j := pRead - PWrite;
      until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      // UniqueString(s); // Not necessary. Windows WideStrings are always single reference.
      pRead := Pointer(w);
      Inc(pRead, l - I);
      PWrite := pRead - j;
      PWrite^ := ReplaceChar;

      if j = 1 then
        repeat
          // Skip Text.
          repeat
            Dec(I);
            if I = 0 then Exit;
            Inc(pRead);
          until Validate(pRead^);

          PWrite := pRead;

          // Skip Compress Chars.
          repeat
            Dec(I);
            if I = 0 then goto SetLengthWrite;
            Inc(pRead);
          until not Validate(pRead^);

          PWrite^ := ReplaceChar;

          j := pRead - PWrite;
        until (j > 1) or (pRead[-1] <> ReplaceChar); ;

      Inc(PWrite);
    end;

  // Main Loop - eventually used by both of the above branches.
  repeat

    // Copy non-CompressChars
    repeat
      PWrite^ := pRead^;
      Inc(PWrite);
      Dec(I);
      if I = 0 then goto SetLengthWrite;
      Inc(pRead);
    until Validate(pRead^);

    // Skip CompressChars
    repeat
      Dec(I);
      if I = 0 then goto SetLengthWrite;
      Inc(pRead);
    until not Validate(pRead^);

    PWrite^ := ReplaceChar;
    Inc(PWrite);

  until False;

  SetLengthWrite:
  SetLength(w, (Cardinal(PWrite) - Cardinal(w)) div 2);
  Exit;

  ReturnEmptyString:
  w := '';
end;

{ ---------------------------------------------------------------------------- }

procedure TrimRightByRefA(var Source: AnsiString; const s: TAnsiCharSet);
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree;
var
  l, lNew: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then Exit;

  l := PCardinal(p - 4)^;
  if l = 0 then Exit;

  lNew := l;
  Inc(p, lNew - 1);

  while lNew >= 4 do
    begin
      if not (p^ in s) then goto EndZero;
      if not (p[-1] in s) then goto EndOne;
      if not (p[-2] in s) then goto EndTwo;
      if not (p[-3] in s) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not (p^ in s) then goto EndZero;
        if not (p[-1] in s) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (p^ in s) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:
  if lNew <> l then SetLength(Source, lNew);
end;

{ ---------------------------------------------------------------------------- }

procedure TrimRightByRefW(var w: WideString; Validate: TDIValidateWideCharFunc = nil);
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree;
var
  l, lNew: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then Exit;
  l := PCardinal(p - 2)^ div 2;
  if l = 0 then Exit;

  lNew := l;
  Inc(p, lNew - 1);

  if not Assigned(Validate) then
    Validate := IsCharWhiteSpaceW;

  while lNew >= 4 do
    begin
      if not Validate(p^) then goto EndZero;
      if not Validate(p[-1]) then goto EndOne;
      if not Validate(p[-2]) then goto EndTwo;
      if not Validate(p[-3]) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not Validate(p^) then goto EndZero;
        if not Validate(p[-1]) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not Validate(p^) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:
  if lNew <> l then
    SetLength(w, lNew);
end;

{ ---------------------------------------------------------------------------- }

function TryStrToIntW(const w: WideString; out Value: Integer): Boolean;
var
  e: Integer;
begin
  Value := ValIntW(w, e);
  Result := e = 0;
end;

{ ---------------------------------------------------------------------------- }

function TryStrToInt64W(const w: WideString; out Value: Int64): Boolean;
var
  e: Integer;
begin
  Value := ValInt64W(w, e);
  Result := e = 0;
end;

{ ---------------------------------------------------------------------------- }

function UpdateCrc32OfBuf(const Crc32: Cardinal; const Buffer; const BufferSize: Cardinal): Cardinal;

type
  PByte4 = ^TByte4;
  TByte4 = packed record
    b1: Byte;
    b2: Byte;
    b3: Byte;
    b4: Byte;
  end;

var
  p: PByte4;
  b: Cardinal;
  l: Cardinal;
begin
  Result := Crc32;
  p := @Buffer;
  l := BufferSize;

  while l >= 4 do
    begin
      b := Result xor p^.b1;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      b := Byte(Result) xor p^.b2;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      b := Byte(Result) xor p^.b3;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      b := Byte(Result) xor p^.b4;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      Inc(p);
      Dec(l, 4);
    end;

  while l > 0 do
    begin
      b := Byte(Result) xor p^.b1;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      Inc(Cardinal(p));
      Dec(l);
    end;
end;

{ ---------------------------------------------------------------------------- }

function UpdateCrc32OfStrA(const Crc32: Cardinal; const s: AnsiString): Cardinal;
begin
  Result := Crc32;
  if s <> '' then
    Result := UpdateCrc32OfBuf(Result, Pointer(s)^, PCardinal(Cardinal(s) - 4)^)
end;

{ ---------------------------------------------------------------------------- }

function UpdateCrc32OfStrW(const Crc32: Cardinal; const w: WideString): Cardinal;
begin
  Result := Crc32;
  if Pointer(w) <> nil then
    Result := UpdateCrc32OfBuf(Result, Pointer(w)^, PCardinal(Cardinal(w) - 4)^);
end;

{ ---------------------------------------------------------------------------- }

function WBufToAStr(const Buffer: PWideChar; const WideCharCount: Cardinal; const CodePage: Word = CP_ACP): AnsiString;
label
  Fail;
var
  OutputLength: Cardinal;
begin
  if (Buffer = nil) or (WideCharCount = 0) then goto Fail;
  OutputLength := WideCharToMultiByte(CodePage, 0, Buffer, WideCharCount, nil, 0, nil, nil);
  SetString(Result, nil, OutputLength);
  WideCharToMultiByte(CodePage, 0, Buffer, WideCharCount, PAnsiChar(Result), OutputLength, nil, nil);
  Exit;

  Fail:
  Result := '';
end;

{ ---------------------------------------------------------------------------- }

function WStrToAStr(const s: WideString; const CodePage: Word = CP_ACP): AnsiString;
var
  InputLength, OutputLength: Integer;
begin
  InputLength := Length(s);
  OutputLength := WideCharToMultiByte(CodePage, 0, PWideChar(s), InputLength, nil, 0, nil, nil);
  SetLength(Result, OutputLength);
  WideCharToMultiByte(CodePage, 0, PWideChar(s), InputLength, PAnsiChar(Result), OutputLength, nil, nil);
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function ValIntW(const w: WideString; out Code: Integer): Integer;
{$DEFINE VAL_INT}
{$I DIValIntW.inc}
{$UNDEF VAL_INT}
end; // Return value is undefined only in case of error.
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function ValInt64W(const w: WideString; out Code: Integer): Int64;
{$DEFINE VAL_INT_64}
{$I DIValIntW.inc}
{$UNDEF VAL_INT_64}
end; // Return value is undefined only in case of error.
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }

function YearOfJuilanDate(const JulianDate: TJulianDate): Integer;
var
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Result, Month, Day);
end;

{ ---------------------------------------------------------------------------- }

function YmdToIsoDate(const Year: Integer; const Month, Day: Word): TIsoDate;
begin
  Result := Year * 10000 + Month * 100 + Day;
end;

{ ---------------------------------------------------------------------------- }

function YmdToIsoDateA(const Year: Integer; const Month, Day: Word): AnsiString;
begin
  Result := PadLeftA(IntToStrA(Year * 10000 + Month * 100 + Day), 8, AC_DIGIT_ZERO);
end;

{ ---------------------------------------------------------------------------- }

function YmdToIsoDateW(const Year: Integer; const Month, Day: Word): WideString;
begin
  Result := PadLeftW(IntToStrW(Year * 10000 + Month * 100 + Day), 8, WC_DIGIT_ZERO);
end;

{ ---------------------------------------------------------------------------- }

function YmdToJulianDate(const Year: Integer; const Month, Day: Word): TJulianDate;
{$IFDEF Calender_FAQ}
var
  a, y, M: Integer;
begin
  a := (14 - Month) div 12;
  y := Year + 4800 - a;
  M := Month + 12 * a - 3;
  Result := Day + (153 * M + 2) div 5 + y * 365 + y div 4 - y div 100 + y div 400 - 32045;
end;
{$ELSE}
begin
  Result := (1461 * (Year + 4800 + (Month - 14) div 12)) div 4 +
    (367 * (Month - 2 - 12 * ((Month - 14) div 12))) div 12 -
    (3 * ((Year + 4900 + (Month - 14) div 12) div 100)) div 4 +
    Day - 32075;
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

procedure ZeroMem(const Buffer; const Size: Cardinal);
{ Modified version of QStrings 6.01.412 by Andrew N. Driazgov <andrey@asp.tstu.ru>.
  Original name is Q_ZeroMem. }
asm
        PUSH    EDI
        MOV     ECX,EAX
        XOR     EAX,EAX
        MOV     EDI,ECX
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_No_Win_9X_Support}
procedure Init;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  IsUnicode := GetVersionEx(OSVersionInfo) and (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT);
end;

initialization
  Init;
  {$ENDIF}

end.


/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

// VString.h: Schnittstelle f�r die Klasse VString.
//
//////////////////////////////////////////////////////////////////////

#ifndef VSTRING_H
#define VSTRING_H

#ifdef UNICODE
#pragma message ("Warning : VString does not yet support unicode. Use WideCharToMultiByte and WideCharToMultiByte to convert!")
#endif


#include "definitions.h"
#include <list>
#include <ctype.h> 
#include <vector> 

#include "InlineContainer.h"

#pragma once
	
//Using name "string" with "VString"
//#define __USESTRINGNAME__

#if ((defined(__DOTRACE__) && defined(_DEBUG)) || defined(__AFX_H__))
//#include "afx.h"
#else
#include <windows.h>
#endif

#include <sstream>

#define THREADSAFE
#ifndef THREADSAFE
#include "ThreadSafeClass.h"
#endif

namespace vtools
{

//#undef CHAR
//#define CHAR char
//typedef char CHAR;


#ifdef STRING
#pragma message("Warning: STRING is already defined.")
#endif


//#undef STRING
//#define STRING char*
typedef char* STRING;

//v1.3 VCHAR replaces all char definitions
typedef unsigned char VCHAR;

/*#ifndef LPVOID
#define LPVOID void*
#endif*/

//string allocation size used in Format/FormatV as a default
#define MAXFORMATLEN 2*1024

/*
   renames of known functions
*/
#define	StrToIntDefL Str2IntDefL
#define StrToIntDef Str2IntDef
#define IntToStr Int2Str
#define IntToStr Int2Str 

#define	_StrToIntDefL _Str2IntDefL
#define _StrToIntDef _Str2IntDef
#define _IntToStr _Int2Str
#define _IntToStr _Int2Str 

/* 
	Shortcut of known functions
*/

#define _MakeUp _MakeUpper
#define _CompareText _CmpText
#define _FormatString _FormatStr
#define _FmtString _FormatStr
#define _FmtStr _FormatStr

/*
   Shortcut for converting VString into pointer to a char.
   
   Example:
    SetWindowText(_V(MyText));
*/
#define _V(p) p.c_str()
#define _VSTR(p) p.c_str()

#define _VLen(p) p.GetLength()
#define _VLenMax(p,m) p.GetLength(m)

#define _VEmpty(p) (p.IsEmpty() == 0)

class VString;

#ifdef V_USE_LITTLE_STRINGNAME__
//#define string VString
typedef VString string;
#endif

#ifdef V_USE_STD_STRINGNAME__
//#define String VString
typedef VString String;
#endif

typedef std::vector<VString> STRINGS;


typedef std::list<void*> VList;



/*Index is 1-based!*/

class _EXPORT_DLL_ VString
    #ifndef THREADSAFE
    :VThreadSafeClass 
    #endif
{
protected:
	int StrAlloc(STRING &Buffer, int Length) const;
	STRING mData;
	int mLength;

public:
	
	bool CmpCaseSensitive;
	
    VString();
	VString(const char String,bool nCmpCaseSensitive = FALSE) ;
	VString(const VString &String,bool nCmpCaseSensitive = FALSE) ;
	VString(const STRING String,bool nCmpCaseSensitive = FALSE);
	VString(const STRING String, int LenOrPort, bool IsIP =FALSE,bool nCmpCaseSensitive = FALSE); 
	VString(const STRING IPAddress,const STRING Port);
	
	virtual ~VString();

	void Init();

	bool IsValidIndex(int nIndex)  const;
	void MakeReverse( );
	VString MakeReverseV();

	void MakeLower();
	VString MakeLowerV();

	void MakeUpper();
	/*Erzeugt aus dem String der Klasse eine Kopie und gibt das Ergebnis von MakeUpper zur�ck.
	Die Daten des String werden dabei nicht ver�ndert.*/
	VString MakeUpperV();

	int Replace(const STRING lpszOld,const STRING lpszNew );

	int Remove(const  CHAR ch );
	
	/*F�gt einen String an der Stelle nIndex ein.
	Soll ein String vor dem ersten Zeichen eingef�gt werden, muss nIndex  0 sein*/
	int Insert( int nIndex, const STRING pstr, int Length = 0 );
	int Append(const STRING pstr, int Length = 0 );
	int Append(int value);
	

	int Delete( int nIndex, int nCount = 1 );

	void Format(const vtools::STRING lpszFormat, ... );
	void FormatV(const vtools::STRING lpszFormat, va_list argList );

    /*creates an formatted string and returns it
    */
    static VString FormatString(const vtools::STRING lpszFormat, ... );


	//formats a text and adds with append
	void FormatAdd(const STRING lpszFormat, ... );


	/*Zeichen links und rechts l�schen
	Ist ch nicht angegeben, wird nach \t \n \r ' ' gesucht
	*/
	void TrimLeft(CHAR ch = NULL);
	void TrimRight(CHAR ch = NULL);
	void TrimWhiteSpaces();
	void TrimCReturns();

	/*not implemented*/
	void FormatMessage(const  STRING lpszFormat, ... );

	/*sucht nach einem SubString pstr (Unterscheidung v. Gro�-Kleinschreibung mit CmpCaseSensitive)
	ab nStart und gibt das erste Zeichen des gefundenen Substrings zur�ck.
	nStart und der R�ckgabewert basiert auf dem ersten Zeichen, das den Index 1 besitzt.
	Wenn nichts gefunden wird, wird 0 zur�ckgegeben, Bei Fehlerfall -1
	*/
	int Find(const STRING pstr, int nStart = 1) const;
	int Find(const char pstr, int nStart = 1) const
	{
		return Find((STRING)&pstr,nStart);
	}
	
	int ReverseFind(const CHAR ch ) const;

	//
	VString Mid( int nFirst,  int nCount ) const;
	VString Left( int nCount ) const;
	VString Right( int nCount ) const;

		
	bool IsEmpty() const;
	void Empty();

	//Zeichenoperationen
	bool SetAt(int nIndex, CHAR ch) ;
	CHAR GetAt(int Index) const;
	
	//Vergleichsmethoden
	int Compare(const STRING lpsz ) const;
	int CompareCase(const STRING lpsz) const;
	int CompareNoCase(const STRING lpsz ) const;

	VString SpanExcluding(const STRING lpszCharSet) const;
	VString SpanIncluding(const STRING lpszCharSet) const;


	int FindOneOf(STRING lpszCharSet ) ;

	//returns the length of string, but only if string length is smaller than maxlen
	//in this case it returns maxlen
	int GetLength(DWORD maxlen = 0) const;



	//returns a longint from this string - if fails returns Def
	long Str2IntDefL(int Def);
    //same as Str2IntDefL but is static
    //e.g. long test = VString::Str2IntDefL(myNumber,-1);
    static long Str2IntDefL(VString str,int Def) {return str.Str2IntDefL(Def);};

	int Str2IntDef(int Def);
    static long Str2IntDef(VString str,int Def) {return str.Str2IntDef(Def);};

    long Str2IntL() ;
    static long Str2IntL(VString str) {return str.Str2IntL();};
	int Str2Int();
    static long Str2Int(VString str) {return str.Str2Int();};



    //converts a value to a string
    //it sets this string to value and also returns a copy !!
	VString Int2Str(long Value);

    void IntToStr2(long Value) ;

    //converts a value to a string
    //it sets this string to value and also returns a copy !!
	VString Int2Str(int Value);

    void IntToStr2(int Value) ;


	bool IsNumberInt();
    static bool IsNumberInt(VString Number);
    

	
	
	//String als IP-Addresse mit Port
	int GetPort();
	int GetPortDef(int Default = 80);


    //is string an IPv4 address?
	bool IsValidIP();
	VString GetIP();

	/*VString p("4E5");
	ULONG d = (ULONG)(p.StringToType <double> ());*/
	template <class T> T StringToType ()
	{
		T result;
		std::stringstream ssm (mData);
		ssm >> result;
		return result;
	}


	//Routinen zum direkten Puffereingriff
	int GetBuffer(STRING &Buffer);
	//inline STRING GetBuffer(size_t Length = -1) 
	
	STRING GetBuffer();
	int SetBuffer(const STRING p, int len);

	//Zugriff auf einzelne Zeichen
	CHAR operator [](int nIndex) const;

	//additional functions out of basic_string


	inline STRING c_str() 
	{
		return this->GetBuffer();
	};
	operator STRING() const;

	size_t capacity( ) const
	{
		return mLength - strlen(mData);
	};
	
	inline void swap(VString &_Str)
	{
		VString s(_Str);
		_Str = (*this);
        (*this) = s;		
	};

	inline void swap(STRING &_Str,size_t Length = 0)
	{
		VString s;
		if (Length == 0)
			s = _Str;
		else
			s.Append(_Str,Length);
		memcpy(_Str,mData,mLength);

        (*this) = s;		
	};
	inline void swap(char &_Str)
	{
		char s = _Str;
		_Str = this->GetAt(1);
        (*this) = s;		
	};

	//VString substr(size_t _Off = 0,  size_t _Count = npos) const;





	//Ver�nderungsoperatoren
	VString operator +( const VString& string);
	VString operator +( const CHAR ch);

	const VString& operator +=( const VString& string );
	const VString& operator +=( const CHAR ch );
	
	VString& operator =( const VString& String );
	//VString& operator =(void *String) { (*this) };

	/*Vergleichsoperatoren.
	Unterscheidung zwischen Gro�- und Kleinschreibung durch 
	Setzen von CmpCaseSensitive.
	*/

	BOOL operator ==( const STRING s);


	BOOL operator !=(const STRING s);


	BOOL operator <(const STRING s);



	BOOL operator >(const STRING s);


	BOOL operator <=(const STRING s);


	BOOL operator >=(const STRING s);
};


/*
 Helper functions
*/

//integer conversions

extern _EXPORT_DLL_ long _Str2IntDefL(const STRING,int Def);
extern _EXPORT_DLL_ int _Str2IntDef(const STRING,int Def);
extern _EXPORT_DLL_ STRING _Int2Str(long Value);
extern _EXPORT_DLL_ STRING _Int2Str(int Value);

extern _EXPORT_DLL_ long Str2IntDefL(const VString Num,int Def);
extern _EXPORT_DLL_ int Str2IntDef(const VString Num,int Def);
extern _EXPORT_DLL_ VString Int2Str(long Value);
extern _EXPORT_DLL_ VString Int2Str(int Value);


//case sensitive conversions
extern _EXPORT_DLL_ int _MakeUpper(STRING &text);
extern _EXPORT_DLL_ int _MakeUpper(char &ch);

extern _EXPORT_DLL_ int _MakeLower(STRING &text);
extern _EXPORT_DLL_ int _MakeLower(char &ch);

//comparison
extern _EXPORT_DLL_ int _CmpText(const STRING str1,const STRING str2);

//format

//formats an text and returns int
extern _EXPORT_DLL_ STRING _FormatStr(const STRING lpFormatString,...);


//network functions

//tries to retrieve an IPv4 Address from string
extern _EXPORT_DLL_ char* GetIPFromAddress(const char *Address);
extern _EXPORT_DLL_ int GetPortFromAddress(const STRING Address);

//checks for a valid IPv4 
//
extern _EXPORT_DLL_ bool IsValidIP(const STRING ipaddr);


//Verkn�pft einen oder mehrere Strings miteinander
//
//VString a("hallo "), b("wie "), c("123");
//VString r = Concatenate(a,b.c_str(),c.c_str());
//Beachte, dass ab dem zweiten Paramter ::c_str() verwendet werden muss !
extern _EXPORT_DLL_ vtools::VString Concatenate(const STRING s1, ...);

//Verkn�pft einen oder mehrere Strings miteinander
//
//VString a("hallo "), b("wie "), c("123");
//VString r = Concatenate(make_str(a)(b)(c));
extern _EXPORT_DLL_ vtools::VString Concatenate(const std::vector<VString> &v);

template <class T>
inline inline_container<T> make_str(const T &a) 
{
    return inline_container<T>(a);
}


static vtools::VString operator +(const VString s1, const VString s2)
{
    VString s3(s1);
	s3 += s2;
    return s3;
};

static vtools::VString operator +(const char s1, const VString s2)
{
    VString s3((char)s1);
    s3 += s2;
    return s3;
};

/*
  MessageBoxFmt
  extends the winapi Message box with ...
  See Format
*/
extern "C" int MessageBoxFmt(HWND hWnd,
    LPCTSTR lpText,
    LPCTSTR lpCaption,
    UINT uType,
	...
	);

extern vtools::VString Bool2Str(bool Value);

/*Formats a date/time to string
For Date/TimeFormat and dwFlags see GetDateFormat
*/
extern vtools::VString FormatDate(STRING DateFormat, DWORD dwFlags);
extern vtools::VString FormatTime(STRING TimeFormat, DWORD dwFlags);

/*
Use instead :
char *xy;
if (VString(xy,CaseSensitive) == s2)


static bool operator ==(const char *s1, const VString s2)
{
    VString s3((STRING)s1);
    return s3.operator ==(s2)!=0;
};*/

/*static char* operator +=(const char* s1,const VString s2)
{
    VString s3((STRING)s1);
    s3.Append(s2);
    return s3.GetBuffer();
};


static char* operator +=(const VString s1,const VString s2)
{
    VString s3(s1);
    s3.Append(s2);
    return s3.GetBuffer();
};*/

/*static vtools::char operator +=(const VString s1)
{
    VString s3((char)s1);
    s3 += s2;
    return s3;
};*/


/*
auskommentiert, weil CaseSensetive von s2 nicht beachtet wird

extern BOOL operator ==(const STRING s1, const VString s2);
//extern BOOL operator !=(const STRING s1, const VString s2);
extern BOOL operator !=(const STRING s1, const VString s2);

extern BOOL operator <(const STRING s1, const VString s2);
extern BOOL operator >(const STRING s1, const VString s2);
extern BOOL operator <=(const STRING s1, const VString s2);
extern BOOL operator >=(const STRING s1, const VString s2);
*/
};


#endif // !defined(AFX_VString_H__9FFFB23E_7397_4BAA_8EDE_01F0B10E81DC__INCLUDED_)





/*

Archive/Dump 

operator << Inserts a VString object to an archive or dump context. 
operator >> 

  */

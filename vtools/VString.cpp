/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

// VString.cpp: Implementierung der Klasse VString.
//
//////////////////////////////////////////////////////////////////////


#include "VString.h"
#include "assertions.h"
#include <stdio.h> 
#include <stdarg.h>
#include <ctype.h>


//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////
//#include <string.h>
//#include <malloc.h>

//#define NULL 0
//using namespace vtools;

namespace vtools
{

VString::VString()
#ifndef THREADSAFE
    :VThreadSafeClass()
#endif

{
	Init();
}

void VString::Init() 

{
	mData = NULL;
	mLength = 0;
	CmpCaseSensitive = false;	
}

VString::VString(const char String,bool nCmpCaseSensitive /*= false*/) 
#ifndef THREADSAFE
    :VThreadSafeClass()
#endif
{
	Init();
	CmpCaseSensitive = nCmpCaseSensitive;
	mLength = StrAlloc(mData,1);
	memcpy(mData,&String,1);
}

VString::VString(const VString &String,bool nCmpCaseSensitive /*= false*/) 
#ifndef THREADSAFE
    :VThreadSafeClass()
#endif
{
	Init();
	CmpCaseSensitive = nCmpCaseSensitive;
	if (!String.IsEmpty())
	{
		mLength = StrAlloc(mData,String.GetLength());
		memcpy(mData,String.mData,mLength);		
	}
	else
		mData = NULL;
}

VString::VString(const STRING String, int LenOrPort, bool IsIP /*=false*/ ,bool nCmpCaseSensitive /*= false*/)
#ifndef THREADSAFE
    :VThreadSafeClass()
#endif

{
	Init();
	CmpCaseSensitive = nCmpCaseSensitive;

	if (String == NULL) return;
	
	if (IsIP)
	{
		(*this) = String;
		if (LenOrPort > -1)
		{
			(*this).operator += (":");
			(*this).operator += (vtools::IntToStr(LenOrPort));
		}
	}
	else
	if (strlen(String) > 0)
	{
		mLength = StrAlloc(mData,LenOrPort);
		memcpy(mData,String,mLength);
	}
	else
		mData = NULL;
}



VString::VString(const STRING String,bool nCmpCaseSensitive /*= false*/) 
#ifndef THREADSAFE
    :VThreadSafeClass()
#endif

{
	Init();
	CmpCaseSensitive = nCmpCaseSensitive;
	if (strlen(String) > 0)
	{
		mLength = StrAlloc(mData,strlen(String));
		strcpy((STRING&)mData,String);	
	}
	else
		mData = NULL;
}

VString::VString(const STRING IPAddress,const STRING Port)
#ifndef THREADSAFE
    :VThreadSafeClass()
#endif

{
	Init();

	(*this) = IPAddress;
	if (VString(Port).IsNumberInt())
	{
		this->operator += (":");
		(*this).operator += (Port);
	}
}


VString::~VString() 
{
	Empty();
}


VString::operator STRING() const
{
/*	char *p;
	if (IsEmpty())
	{
		StrAlloc(p,0);	
		return (STRING)p;
	}
		
	StrAlloc(p,mLength);	

	memcpy(p,mData,mLength);
	return (STRING)p;
*/
	return mData;
}

VString VString::operator +( const VString& string)
{
	int len = this->GetLength() + string.GetLength();
	
	if (IsEmpty() && (string.GetLength()==0)) 
		return VString("");

	VString tmps(mData,mLength);
	tmps.Append(string);

	return tmps;	
}

VString VString::operator +( const char ch)
{
	this->Insert(GetLength(),(STRING)(ch));
	return (*this);
}

int VString::GetLength(DWORD maxlen) const
{
	if ((mLength > maxlen) && (maxlen > 0))
		return maxlen;
	else
		return mLength;
}


VString VString::SpanIncluding(const STRING lpszCharSet) const
{
	return Left(strspn(mData, lpszCharSet));
}


VString VString::SpanExcluding(const STRING lpszCharSet) const
{
	return Left(strcspn(mData, lpszCharSet));
}

const VString& VString::operator +=( const VString& string )
{
	VString s(mData,mLength);
	if (IsEmpty()) 
	{
		(*this) = string;
	}
	else
	{
		if (!string.IsEmpty())
		{
			(*this) = this->operator +(string);
		}
	}

	
	return (*this);
}

const VString& VString::operator +=( const char ch )
{
	//if (IsEmpty()) 
	{
		//(*this) = &ch;
        this->Append((STRING)&ch,1);
	}
	/*else
        (*this) = //(*this) + (STRING)(&ch);
        this->operator +((STRING)(&ch));
*/
	return (*this);
}

VString& VString::operator =( const VString& String )
{
	Empty();
	
	mLength = StrAlloc(mData,String.GetLength());
	memcpy(mData,String.mData,mLength);

	return (*this);
}

int VString::SetBuffer(char *p, int len)
{
	mData = p;
	mLength = len;
	return len;
}

int VString::GetBuffer(STRING &Buffer)
{
	if (mData == NULL)
	{
		StrAlloc(mData,0);
		mLength = 0;
	}
	Buffer = (STRING)mData;
	
	return mLength;
}

STRING VString::GetBuffer()
{
	char *p;
	GetBuffer(p);
	return p;
}

int VString::StrAlloc(STRING &Buffer, int Length)const
{
#ifndef THREADSAFE
    Lock();
#endif
    
	Buffer = new char[Length+1];		
	memset(Buffer,0,Length+1);	
#ifndef THREADSAFE
    Unlock();
#endif
    
	return Length;
}

char VString::GetAt(int Index)const
{
	if (!IsValidIndex(Index)) return '\0';

	return ((STRING)(mData))[Index-1];
}

char VString::operator [](int nIndex ) const
{
	return GetAt(nIndex);
}

void VString::Empty() 
{
#ifndef THREADSAFE
    Lock();
#endif

	if (mData != NULL)
    {
        try
        {
            delete[] mData;
        }
        catch (...)
        {
        }
    }
		
    //delete ((STRING)(mData));
	mData = NULL;
	mLength = 0;
#ifndef THREADSAFE
    Unlock();
#endif

}

bool VString::SetAt(int nIndex, char ch)
{
	if (!IsValidIndex(nIndex)) return false;

	mData[nIndex-1] = ch;
	return true;
}

bool VString::IsEmpty() const
{
	return ((mData == NULL) || ((mData != NULL) && (mLength == 0)));	
}

int VString::CompareCase(const STRING lpsz) const
{
	if (IsEmpty() && strlen(lpsz)==0)	
		return 0;
	if (IsEmpty() && strlen(lpsz)!=0)	
		return 3;

	if (strlen(lpsz)!=mLength)
		return 2;

	return strncmp(mData,lpsz, mLength);
}

int VString::Compare(const STRING lpsz) const
{
	if (CmpCaseSensitive)
		return CompareCase(lpsz);
	else
		return CompareNoCase(lpsz);
}

int VString::CompareNoCase(const STRING lpsz ) const
{
	if (IsEmpty() && strlen(lpsz)==0)	
		return 0;
	if (IsEmpty() && strlen(lpsz)!=0)	
		return 3;

	if (strlen(lpsz)!=mLength)
		return 2;

	return _strnicmp(mData,lpsz, mLength);

}

BOOL VString::operator ==(const STRING s)
{
	return Compare(s) == 0;
}


BOOL VString::operator !=(const STRING s)
{
	return Compare(s) != 0;
}



BOOL VString::operator <(const STRING s)
{
	return Compare(s) < 0;
}



BOOL VString::operator >(const STRING s)
{
	return Compare(s) > 0;
}


BOOL VString::operator <=(const STRING s)
{
	return Compare(s) <= 0;
}



BOOL VString::operator >=(const STRING s)
{
	return Compare(s) >= 0;
}


void VString::MakeUpper()
{
	if (IsEmpty()) return;
	_strupr(mData);
}

VString VString::MakeUpperV( )
{
	if (IsEmpty()) return VString("");
	
	VString s(mData);
	s.MakeUpper();
	return s;
}


void VString::MakeLower()
{
	if (IsEmpty()) return;
	
	_strlwr(mData);
}


VString VString::MakeLowerV( )
{
	if (IsEmpty()) return VString("");

	VString s(mData);
	s.MakeLower();
	return s;
}

void VString::MakeReverse()
{
	//char *p = 
	if (IsEmpty()) return;
	_strrev(mData);
//	memcpy(mData,p,mLength);
}

VString VString::MakeReverseV()
{
	if (IsEmpty()) return VString("");
	
	VString s(mData);
	s.MakeReverse();
	return s;
}


int VString::Replace(const  STRING lpszOld,const STRING lpszNew )
{
	if (IsEmpty()) return -1;
	
	int p = 1;
	int cnt = 0;

	VString s;
	
	while ((p = Find(lpszOld)) > 0)
	{
		if (p > 1)
			s = Left(p-1);
		//s.Insert(s.GetLength(),lpszNew);

		s.operator +=(lpszNew);		
		s.operator +=(Mid(p+strlen(lpszOld),GetLength()));
		cnt++;

		(*this) = s;
	}
	
	return cnt;
}




int VString::Remove(const char ch )
{
	if (IsEmpty()) return -1;

	VString s;
	char c[2] = "\0";
	int cnt = 0;

	for (int i = 0; i < mLength; i++)
	{
		if (mData[i] != ch)
		{
			//s.Insert(s.GetLength(),&ch);
			strncpy(c,&mData[i],1);
			//s.Insert(s.GetLength(),c);
			s.operator +=(c);
		}
		else
			cnt++;
	}
	
	(*this) = s;
	
	
	return cnt;
}

int VString::Append(const STRING pstr, int Length /*= 0 */)
{
	if ( (Length == 0) && pstr)
		Length = strlen(pstr);

	if (Length==0)
		return mLength;

	if (IsEmpty())
	{
		mLength = StrAlloc(mData,Length);
		memcpy(mData,pstr,mLength);
		return mLength;
	}

	int len = this->GetLength() + Length;
	
	if (len == 0) return 0;

	char *str,*str2;
	StrAlloc(str,len);

	memcpy(str,mData,mLength);

	str2 = str + this->GetLength();

	memcpy(str2,pstr,Length);	

	delete[] mData;	

	mData = str;
	mLength = len;

	return len;	

}

// Wandelt einen Integer in einen String und h�ngt diesen an den VString an
int VString::Append(int value)
{
	char intstr[20];
	sprintf(intstr, "%d", value);
	return Append(intstr);
}

int VString::Insert( int nIndex,const  STRING pstr, int Length /*= 0*/  )
{
	if (Length == 0) 
		Length = strlen(pstr);

	if (IsEmpty())
		mLength = StrAlloc(mData,Length);
	
	VString s;
	if (nIndex > 0)
		s = Left(nIndex);

	//s += pstr;
	s.Append(pstr,Length);
	s .operator +=(Mid(nIndex+1,0));

	(*this) = s;
	
	return GetLength();
}

int VString::Delete( int nIndex, int nCount /*= 1*/ )
{
	if (!IsValidIndex(nIndex)) return -1;

	VString s;
	if (nIndex > 1)
		s = Left(nIndex-1);

	s.operator +=(Mid(nIndex+nCount,GetLength()));
		
	(*this) = s;


	return GetLength();
}

void VString::Format(const STRING lpszFormat, ... )
{
  va_list vaList;

  va_start(vaList, lpszFormat);

  FormatV(lpszFormat,vaList);

  va_end(vaList);
}

void VString::FormatV(const STRING lpszFormat, va_list argList )
{
	Empty();
	char s[MAXFORMATLEN];
	mLength = vsprintf(s,lpszFormat,argList);
	VString v(s,mLength);
	(*this) = v;
}

void VString::FormatAdd(const STRING lpszFormat, ... )
{
	 va_list vaList;

	 va_start(vaList, lpszFormat);

	 VString dummy_Str;
	 dummy_Str.FormatV(lpszFormat,vaList);

     va_end(vaList);

	 this->Append(dummy_Str);
}

VString VString::FormatString(const vtools::STRING lpszFormat, ... )
{
	 va_list vaList;

	 va_start(vaList, lpszFormat);

	 VString dummy_Str;
	 dummy_Str.FormatV(lpszFormat,vaList);

     va_end(vaList);

 
     return dummy_Str;
}


VString VString::Mid( int nFirst,int nCount ) const
{
	if (!IsValidIndex(nFirst)) return VString("");
	//if (nCount == 0) return VString("");

	char *p = &mData[nFirst-1];
	if ((nFirst-1+nCount > GetLength()) || (nCount <= 0) )
		nCount = GetLength() - nFirst+1;

	VString s(p,nCount);

	return s;
}

VString VString::Left(  int nCount ) const
{
	return Mid(1,nCount);
}

VString VString::Right( int nCount ) const
{
	return Mid(mLength-nCount+1,0);
}

void VString::TrimLeft(const char ch /*= NULL*/)
{
	if (IsEmpty()) return;

	int i = 0;
	if (ch == NULL)
	{
		char *p = mData;
		
		while ((p[0] == '\n') || (p[0] == '\r') || (p[0] == '\t') || (p[0] == ' '))
		{
			i++;
			p++;
		}
	}
	else
	{
		char *p = mData;
		
		while (p[0] == ch)
		{
			i++;
			p++;
		}
	}
	
	(*this) = Right(mLength - i );
}

void VString::TrimRight(const char ch /*= NULL*/)
{
	if (IsEmpty()) return;
	MakeReverse();
	TrimLeft(ch);
	MakeReverse();
}

int VString::FindOneOf(const STRING lpszCharSet ) 
{
	LPTSTR lpsz = strpbrk(mData, lpszCharSet);
	return (lpsz == NULL) ? -1 : (int)(lpsz - mData);
}


void VString::TrimWhiteSpaces()
{
	Remove(' ');
}

void VString::TrimCReturns()
{
	Remove('\r');
	Remove('\n');
}


void VString::FormatMessage(const  STRING lpszFormat, ... )
{
	ASSERT0(FALSE,"Sorry, not implemented yet.");
}


int VString::Find(const STRING pstr, int nStart /*= 1*/) const
{
	if (!IsValidIndex(nStart)) return -1;

	if (IsEmpty()) return -1;

	VString s(&mData[nStart-1]),s2(pstr);
	
	
	if (!CmpCaseSensitive)
	{
		s.MakeUpper();
		s2.MakeUpper();
	}
	

	// sv: strstr gibt NULL zur�ck wenn der suchstring nicht gefunden wurde
	char *p = s.c_str();
	char *pdest = strstr(p, s2.c_str() );
	int result = -1;

	if(pdest)
    result = (nStart-1) + pdest - p + 1;

	return result;
}

int VString::ReverseFind(const char ch ) const
{
	if (IsEmpty()) return -1;

	VString s(mData);
	
	if (!CmpCaseSensitive)
	{
		s.MakeUpper();
	}

	char *p = s.c_str();
	char *pdest = strrchr(p, ch );
    int result = pdest - p + 1;

	return result;
}

bool VString::IsValidIndex(int nIndex) const
{
	if (IsEmpty() || 
		(nIndex <= 0) || (nIndex > mLength)) return false;
	return true;
}

long VString::Str2IntL() //throw(int)
{
	if (IsEmpty()) 
	{
		ASSERT1(FALSE,"Could not convert empty string to number. Use VString::Str2IntDefL instead ",this->c_str());
		return -1;
	}
	for (int i = 1; i <= GetLength();i++)
	{
		char s = GetAt(i);
		if (!isdigit(s))
		{
			if (!((i == 1) && ((s != '+') || (s != '-'))))
			{
				ASSERT1(FALSE,"Could not convert '%s' to a number",this->c_str());
				return -1;
			}
		}
	}
	return atol((*this));
}


int VString::Str2Int() //throw(int)
{
	if (IsEmpty()) 
	{
        ASSERT1(FALSE,"Could not convert empty string to number. Use VString::Str2IntDef instead ",this->c_str());
		return -1;
	}
	for (int i = 1; i <= GetLength();i++)
	{
		char s = GetAt(i);
		if (!isdigit(s))
		{
			if (!((i == 1) && ((s != '+') || (s != '-'))))
			{
				//throw 2;
                ASSERT1(FALSE,"Could not convert '%s' to a number",this->c_str());
				return -1;
			}
		}
	}
	return atol(this->c_str());
}

long VString::Str2IntDefL(int Def)
{
	if (IsEmpty()) return Def;
	for (int i = 1; i <= GetLength();i++)
	{
		char s = GetAt(i);
		if (!isdigit(s))
		{
			if (!((i == 1) && ((s != '+') || (s != '-'))))
			{
				return Def;
			}
		}
	}
	return atol(this->c_str());
}

int VString::Str2IntDef(int Def)
{
	if (IsEmpty()) return Def;
	for (int i = 1; i <= GetLength();i++)
	{
		char s = GetAt(i);
		if (!isdigit(s))
		{
			if (!((i == 1) && ((s != '+') || (s != '-'))))
			{
				return Def;
			}
		}
	}
	return atoi(this->c_str());
}

void VString::IntToStr2(long Value) 
{
    this->Int2Str(Value);
}

void VString::IntToStr2(int Value) 
{
    this->Int2Str(Value);
}

VString VString::Int2Str(long Value)
{
	char s[40];
	_ultoa(Value,s,10);
	(*this) = s;
	return (*this);
}


VString VString::Int2Str(int Value)
{
	char s[40];
	ltoa(Value,s,10);
	(*this) = s;
	return (*this);
}


VString VString::GetIP()
{
	int p = Find(":");
	if (p <= 0)
		p = this->GetLength() + 1;
	return Left(p-1);
}

int VString::GetPort()
{
	int p = Find(":");
	if (p < 0)
		return -1;  // Port -1, falls nichts anderes angegeben
	
	VString s = Mid(p+1,-1);
	return s.Str2IntDef(-1);
}

int VString::GetPortDef(int Default /*= 80*/)
{
	int p = Find(":");
	if (p < 0)
		return 80;  // Port 80, falls nichts anderes angegeben
	
	VString s = Mid(p+1,-1);
	return s.Str2IntDef(-1);
}


bool VString::IsValidIP()
{
	//if (!IsValidIP()) return false;

	VString cs(GetIP());

    if (cs.IsEmpty())
        cs = GetBuffer();

    //nur f�r IPv4
    if (cs.GetLength() > (3*4+3) ||
        cs.GetLength() < (1*4+3)) return false;
	
	char ip[20];
	strcpy(ip,cs);
	
	
	int i = 1;
	int points = 0;
	char *s = &ip[0];
	char c = s[0];

	while (true)
	{
		if (c == '\0') break;
		
		if (!isdigit(c)
			&& (c != '.')) 
		{
			return false;
		}

		if (isdigit(c) && (i > 3)) return false;

		if (isdigit(c)) i++;
		else
		if (c == '.') 
		{
			i = 0;
			points++;
			if (points >= 4 ) return false;
		}

		s = &s[1];
		c = s[0];
	}

    
    if(points < 3)
        return false;
    else
        return true;
}

     

bool VString::IsNumberInt()
{
	if (IsEmpty()) return false;
	for (int i = 1; i <= GetLength();i++)
	{
		char s = GetAt(i);
		if (!isdigit(s))
		{
			if ((i == 1) && ((s == '+') || (s == '-')))
			{
			}
			else
			//if (!((i == 1) && ((s != '+') || (s != '-'))))
			{
				return false;
			}
		}
	}
	return true;
}

bool VString::IsNumberInt(VString Number)
{
    
    return Number.IsNumberInt();
}

char* GetIPFromAddress(const char *Address)
{
	VString	a((STRING)Address);
	return a.GetIP();
}

int GetPortFromAddress(const STRING Address)
{
	VString	a(Address);
	return a.GetPort();
}

bool IsValidIP(const STRING ipaddr)
{
	VString	a(ipaddr);
	return a.IsValidIP();		
}


long _Str2IntDefL(const STRING s,int Def)
{
	VString p(s);
	return p.Str2IntDefL(Def);
}
int _Str2IntDef(const STRING s,int Def)
{
	VString p(s);
	return p.Str2IntDef(Def);
}
STRING _Int2Str(long Value)
{
	VString p;
	return p.Int2Str(Value);
}
STRING _Int2Str(int Value)
{
	VString p;
	return p.Int2Str(Value);
}

/*STRING _MakeUpper(const STRING text)
{
	VString t(text);
	t.MakeUpper();
	return t;
}*/

int _MakeUpper(STRING &text)
{
	CharUpper(text);
	return strlen(text);
}
int _MakeUpper(char &ch)
{
	CharUpper((char*)&ch);
	return 1;
}

int _MakeLower(STRING &text)
{
	CharLower(text);
	return strlen(text);
}
int _MakeLower(char &ch)
{
	CharLower((char*)&ch);
	return 1;
}

//Verkn�pft einen oder mehrere Strings miteinander
//
//VString a("hallo "), b("wie "), c("123");
//VString r = Concatenate(a,b.c_str(),c.c_str());
//Beachte, dass ab dem zweiten Paramter ::c_str() verwendet werden muss !

vtools::VString Concatenate(const STRING s1, ...)
{
   VString Result;

   va_list marker;
   char *p = s1;

   va_start( marker, s1 );     /* Initialize variable arguments. */
   while( p != NULL )
   {
	  Result.Append((STRING)p);
	  p = va_arg( marker, char*);
   }
   va_end( marker );              /* Reset variable arguments.      */  

   return Result;
}


//Verkn�pft einen oder mehrere Strings miteinander
//
//VString a("hallo "), b("wie "), c("123");
//VString r = Concatenate(make_str(a)(b)(c));
vtools::VString Concatenate(const std::vector<VString> &v)
{
   VString Result;

   for (int i=0; i < v.size(); i++)
   {
	   Result.Append(v[i]);
   }          

   return Result;
}



int _CmpText(const STRING str1,const STRING str2)
{
	/*VString s1(str1),s2(str2);
	s1.MakeUpper();
	s2.MakeUpper();
	return strcmp(s1,s2);*/
	return CompareString(LOCALE_SYSTEM_DEFAULT,NORM_IGNORECASE,str1,-1,str2,-1);

}


STRING _FormatStr(const STRING lpFormatString,...)
{
  va_list vaList;

  va_start(vaList, lpFormatString);

  VString result;
  result.FormatV(lpFormatString,vaList);

  va_end(vaList);
 
  return result;
}

long Str2IntDefL(const VString Num,int Def)
{
	VString s(Num);
	return s.Str2IntDefL(Def);
}
int Str2IntDef(const VString Num,int Def)
{
	VString s(Num);
	return s.Str2IntDef(Def);
}
VString Int2Str(long Value)
{
	return VString().Int2Str(Value);
}
VString Int2Str(int Value)
{
	return VString().Int2Str(Value);
}



BOOL operator ==(const STRING s1, const VString s2)
{
	return s2.Compare(s1) == 0;
}


/*BOOL operator !=(const STRING s1, const VString s2)
{
	return s2.Compare(s1) != 0;
}*/

BOOL operator !=(const STRING s1, const VString s2)
{
	return s2.Compare(s1) != 0;
}



BOOL operator <(const STRING s1, const VString s2)
{
	return s2.Compare(s1) < 0;
}



BOOL operator >(const STRING s1, const VString s2)
{
	return s2.Compare(s1) > 0;
}


BOOL operator <=(const STRING s1, const VString s2)
{
	return s2.Compare(s1) <= 0;
}


BOOL operator >=(const STRING s1, const VString s2)
{
	return s2.Compare(s1) >= 0;
}

int MessageBoxFmt(HWND hWnd,
    LPCTSTR lpText,
    LPCTSTR lpCaption,
    UINT uType,
	...
)
{
	VString Text;
	va_list vaList;

	va_start(vaList, uType);
	Text.FormatV((char*)lpText,vaList);
	va_end(vaList);
 
	return ::MessageBox(hWnd,Text.c_str(),lpCaption,uType);
}

vtools::VString Bool2Str(bool Value)
{
	if (Value) 
		return VString("TRUE(1)");
	else
		return VString("FALSE(0)");
}


VString FormatDate(STRING DateFormat, DWORD dwFlags)
{
	ASSERTN0((DateFormat != NULL) && (dwFlags != 0),"Only one parameter can be defined. The other one must be NULL.");
	
	int Len;
	if (DateFormat == NULL)
		Len = GetDateFormat(LOCALE_SYSTEM_DEFAULT,dwFlags,NULL,DateFormat,NULL,0);

	else
        Len = GetDateFormat(LOCALE_SYSTEM_DEFAULT,0,NULL,DateFormat,NULL,0);

	ASSERTN(Len == 0);

	char *Date = new char[Len];


	if (DateFormat == NULL)
   		GetDateFormat(LOCALE_SYSTEM_DEFAULT,dwFlags,NULL,DateFormat,(LPSTR)Date,Len);
	else
		GetDateFormat(LOCALE_SYSTEM_DEFAULT,0,NULL,DateFormat,(LPSTR)Date,Len);

	VString vDate(Date);
	delete[] Date;
	return vDate;
}

//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/intl/nls_6at0.asp
VString FormatTime(STRING TimeFormat, DWORD dwFlags)
{
	ASSERTN0((TimeFormat != NULL) && (dwFlags != 0),"Only one parameter can be defined. The other one must be NULL.");
	
	int Len;

	if (TimeFormat == NULL)
		Len = GetTimeFormat(LOCALE_SYSTEM_DEFAULT,dwFlags,NULL,NULL,NULL,0);
	else
        Len = GetTimeFormat(LOCALE_SYSTEM_DEFAULT,0,NULL,TimeFormat,NULL,0);

	ASSERTN(Len == 0);

	char *Time = new char[Len];

	if (TimeFormat == NULL)
		GetTimeFormat(LOCALE_SYSTEM_DEFAULT,dwFlags,NULL,
						  NULL,(LPSTR)Time,Len);

	GetTimeFormat(LOCALE_SYSTEM_DEFAULT,TIME_FORCE24HOURFORMAT,NULL,
						  TimeFormat,(LPSTR)Time,Len);

	VString vTime(Time);
	delete[] Time;
	return vTime;
}





/*
char TimeStr[100];
			memset(&TimeStr,0,sizeof(TimeStr));
			GetTimeFormat(LOCALE_SYSTEM_DEFAULT,TIME_FORCE24HOURFORMAT,NULL,
						  "hh':'mm':'ss",(LPSTR)&TimeStr,sizeof(TimeStr));

			char DateStr[50];
			memset(&DateStr,0,sizeof(DateStr));
			GetDateFormat(LOCALE_SYSTEM_DEFAULT,0,NULL,
				"dd.MM.yyyy"

				,(LPSTR)&DateStr,sizeof(DateStr));


*/

}
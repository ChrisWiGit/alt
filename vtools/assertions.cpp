/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

/*
changelog
4/2/2005 - GetLastErrorString: lpMsgBuf is now checked for null
*/

#include "assertions.h"

using namespace vtools;

namespace vtools
{

//#ifndef _DEBUG

std::string GetLastErrorString(DWORD dwErr)
{
	LPVOID lpMsgBuf = NULL;
	FormatMessage(     
		FORMAT_MESSAGE_ALLOCATE_BUFFER |     FORMAT_MESSAGE_FROM_SYSTEM ,
		//|     FORMAT_MESSAGE_IGNORE_INSERTS,    

		NULL,    
		dwErr, // or any return value from GetLastError    
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language    
		(LPTSTR) &lpMsgBuf,    
		0,    
		NULL );
	// Process any inserts in lpMsgBuf.// ...
	// Display the string.	
	
	std::string str;
	int ret = GetLastError();
	//ret = 87 - wrong parameter means, that dwErr is not windows network message number
	if (lpMsgBuf && (ret != 87))
	{
		try
		{
			str.append((LPCTSTR)lpMsgBuf);
			// Free the buffer.
			LocalFree( lpMsgBuf );
		}catch (...) {};
	}
	else
	{
		//char p[200];
		VString p;
		p.FormatAdd("Internal Format Message Error: \"%d\" ist not a valid windows network message number.\nType \"net helpmsg <number>\" in a console.",dwErr);
		
		ASSERT0(false,_VSTR(p));

		str = p.c_str();
		SetLastError(ret);
	}
	return str;
}

void OutputDebugV(char *s,...)
{
#ifndef _DEBUG
	//return;
#else
  VString a(s);
  va_list vaList;

  va_start(vaList, s);

  a.FormatV(s,vaList);

  va_end(vaList);	
  
  OutputDebugString(a);
#endif
}

void TRACE_(char *s,...)
{
#ifndef _DEBUG
	//return;
#else
  VString a(s),k;
  va_list vaList;

  va_start(vaList, s);

  a.FormatV(s,vaList);

  k.Format("%s(%d): ",__FILE__,__LINE__);

  a.Insert(0,k); 

  va_end(vaList);	
  
  OutputDebugString(a);
#endif
}

/*void DEBUGV_(char *s,...)
{
#ifndef _DEBUG
	//return;
#else
  VString a(s),k;
  va_list vaList;

  va_start(vaList, s);

  a.FormatV(s,vaList);

  k.Format("%s(%d): ",__FILE__,__LINE__);

  a.Insert(0,k); 

  va_end(vaList);	
  
  std::cout << a.c_str();
#endif
}*/

bool FailedMessage(const char* File, const int Line, const char* UserText,...)
{
	char text[1024];

	sprintf(text,sDebugErrorString,File,Line);    	
	if (UserText != NULL)
	{
		char usr[500];
		va_list vaList;
		va_start(vaList, UserText);
		wvsprintf(usr,UserText,vaList);
		va_end(vaList);	
		
		
		strcat(text,"Information: ");
		strcat(text,usr);
	}
	strcat(text,"\r\n");
	
	TRACE2("\r\n%s(%i): ",File,Line);
	TRACE(text);
	return MessageBox(GetActiveWindow(),text,"Application Exception",MB_OKCANCEL | MB_ICONSTOP | MB_APPLMODAL | MB_DEFBUTTON1 | 0) == IDCANCEL;
}

//#endif

};
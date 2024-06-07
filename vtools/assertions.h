/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#ifndef VASSERTIONS_H
#define VASSERTIONS_H

#include "definitions.h"

#pragma once
#define V_USE_STRING_ASSERT


#include <windows.h>
#include <stdarg.h>
#include <ctype.h>
#include <string>
#include "vstring.h"

namespace vtools
{
//these defines are the same as the ones in MFC library- 
//see help for more information

static char *sDebugErrorString = "\r\nAn Assertion occured in application\r\nin file '%s' \r\nat line %d.\r\n\r\n";

extern "C" _EXPORT_DLL_ inline void OutputDebugV(char *s,...);
extern "C" _EXPORT_DLL_ inline void TRACE_(char *s,...);

//returns a string that explains a windows given error index
extern std::string  GetLastErrorString(DWORD dwErr);

//pops up an msgbox with information about File, Line and UserText
bool FailedMessage(const char* File, const int Line, const char* UserText,...);



/*
Warning:
ASSERT(f) does not compute (f) in a release!
Use instead VERIFY(f)
*/

#ifdef _DEBUG

#define TRACE					OutputDebugV
#define TRACE1(s,s1)			{OutputDebugV(s,s1);}
#define TRACE2(s,s1,s2)			{OutputDebugV(s,s1,s2);}
#define TRACE3(s,s1,s2,s3)		{OutputDebugV(s,s1,s2,s3);}
#define TRACE4(s,s1,s2,s3,s4)	{OutputDebugV(s,s1,s2,s3,s4);}

#define TRACEV		TRACE2("%s(%i): ",__FILE__,__LINE__);TRACE
#define TRACEV1		TRACE2("%s(%i): ",__FILE__,__LINE__);TRACE1
#define TRACEV2		TRACE2("%s(%i): ",__FILE__,__LINE__);TRACE2
#define TRACEV3		TRACE2("%s(%i): ",__FILE__,__LINE__);TRACE3
#define TRACEV4		TRACE2("%s(%i): ",__FILE__,__LINE__);TRACE4


//if defined, use std:out for messages
//this works also in release
//
#undef DEBUG
#ifdef DEBUG_STD
	#define _DEBUGV(errorStr)                
		{std::cout << __FILE__ << ":" << __LINE__; 
		std::cout << " " << errorStr 
	#define _DEBUG(errorStr)                
		{std::cout << __FILE__ << ":" << __LINE__; 
		std::cout << " " << errorStr 

	#define DEBUG(s)					_DEBUG(s) << std::endl;}
	#define DEBUG1(s,s1)			_DEBUG(s) << s1 << std::endl;}
	#define DEBUG2(s,s1,s2)			_DEBUG(s) << s1 << s2 << std::endl;}
	#define DEBUG3(s,s1,s2,s3)		_DEBUG(s) << s1 << s2 << s3 << std::endl;}
	#define DEBUG4(s,s1,s2,s3,s4)	_DEBUG(s) << s1 << s2 << s3 << s4 << std::endl;}

	#define DEBUGV(s)				_DEBUGV(s) << std::endl;}
	#define DEBUGV1(s,s1)			_DEBUGV(s) << s1 << std::endl;}
	#define DEBUGV2(s,s1,s2)		_DEBUGV(s) << s1 << s2 << std::endl;}
	#define DEBUGV3(s,s1,s2,s3)		_DEBUGV(s) << s1 << s2 << s3 << std::endl;}
	#define DEBUGV4(s,s1,s2,s3,s4)	_DEBUGV(s) << s1 << s2 << s3 << s4 << std::endl;}

#else
	#define DEBUG					TRACE
	#define DEBUG1(s,s1)			TRACE1(s,s1)
	#define DEBUG2(s,s1,s2)			TRACE2(s,s1)
	#define DEBUG3(s,s1,s2,s3)		TRACE3(s,s1)
	#define DEBUG4(s,s1,s2,s3,s4)	TRACE4(s,s1)

	#define DEBUGV					TRACEV
	#define DEBUGV1(s,s1)			TRACEV1(s,s1)
	#define DEBUGV2(s,s1,s2)		TRACEV2(s,s1)
	#define DEBUGV3(s,s1,s2,s3)		TRACEV3(s,s1)
	#define DEBUGV4(s,s1,s2,s3,s4)	TRACEV4(s,s1)

#endif

#define ASSERT(f)	 {(void) ((f) || !FailedMessage(__FILE__, __LINE__,NULL) || (DebugBreak(), 0));}
#define ASSERTN(f)	 ASSERT(!f)

#define ASSERT0(f,s)				{(void) ((f) || !FailedMessage(__FILE__, __LINE__,s)			 || (DebugBreak(), 0));}
#define ASSERT1(f,s,p)				{(void) ((f) || !FailedMessage(__FILE__, __LINE__,s,p)			 || (OutputDebugV(s,p),0)			|| (DebugBreak(), 0));}
#define ASSERT2(f,s,p1,p2)			{(void) ((f) || !FailedMessage(__FILE__, __LINE__,s,p1,p2)		 || (OutputDebugV(s,p1,p2),0)		|| (DebugBreak(), 0));}
#define ASSERT3(f,s,p1,p2,p3)		{(void) ((f) || !FailedMessage(__FILE__, __LINE__,s,p1,p2,p3)	 || (OutputDebugV(s,p1,p2,p3),0)	|| (DebugBreak(), 0));}
#define ASSERT4(f,s,p1,p2,p3,p4)	{(void) ((f) || !FailedMessage(__FILE__, __LINE__,s,p1,p2,p3,p4) || (OutputDebugV(s,p1,p2,p3,p4),0) || (DebugBreak(), 0));}

#define ASSERTN0(f,s)				ASSERT0(!f,s)
#define ASSERTN1(f,s,p)				ASSERT1(!f,s,p)
#define ASSERTN2(f,s,p1,p2)			ASSERT2(!f,s,p1,p2)
#define ASSERTN3(f,s,p1,p2,p3)		ASSERT3(!f,s,p1,p2,p3)
#define ASSERTN4(f,s,p1,p2,p3,p4)	ASSERT4(!f,s,p1,p2,p3,p4)

#define DEBUG_ONLY(f)      (f)

//#define ASSERTS1(f,s,s1) ASSERTS(


#define VERIFY(f)						  ASSERT(f)
#define VERIFY0(f,s)					  ASSERT0(f,s,p)
#define VERIFY1(f,s,p)					  ASSERT1(f,s,p)
#define VERIFY2(f,s,p1,p2)				  ASSERT2(f,s,p1,p2)
#define VERIFY3(f,s,p1,p2,p3)			  ASSERT3(f,s,p1,p2,p3)
#define VERIFY4(f,s,p1,p2,p3,p4)          ASSERT4(f,s,p1,p2,p3,p4)

#define VERIFYN(f)						  ASSERTN(f)
#define VERIFYN0(f,s)					  ASSERTN0(f,s,p)
#define VERIFYN1(f,s,p)					  ASSERTN1(f,s,p)
#define VERIFYN2(f,s,p1,p2)				  ASSERTN2(f,s,p1,p2)
#define VERIFYN3(f,s,p1,p2,p3)			  ASSERTN3(f,s,p1,p2,p3)
#define VERIFYN4(f,s,p1,p2,p3,p4)         ASSERTN4(f,s,p1,p2,p3,p4)

//throws exception with a message
//this works only in DEBUG mode !
#define THROWM(s)						  ASSERT(FALSE,s)
#define THROWM1(f,s,p)					  ASSERT1(FALSE,s,p)
#define THROWM2(f,s,p1,p2)				  ASSERT2(FALSE,s,p1,p2)
#define THROWM3(f,s,p1,p2,p3)			  ASSERT3(FALSE,s,p1,p2,p3)
#define THROWM4(f,s,p1,p2,p3,p4)          ASSERT4(FALSE,s,p1,p2,p3,p4)



#else

#define TRACEV  {}
#define TRACEV1 {}
#define TRACEV2 {}
#define TRACEV3 {}
#define TRACEV4 {}

#define TRACE {}
#define TRACE1(s,s1) {}
#define TRACE2(s,s1,s2) {}
#define TRACE3(s,s1,s2,s3) {}
#define TRACE4(s,s1,s2,s3,s4) {} 



//if defined, use std:out for messages
//this works also in release
//
#undef DEBUG
#ifdef DEBUG_STD
	#define _DEBUGV(errorStr)                
		{std::cout << __FILE__ << ":" << __LINE__; 
		std::cout << " " << errorStr 
	#define _DEBUG(errorStr)                
		{std::cout << __FILE__ << ":" << __LINE__; 
		std::cout << " " << errorStr 

	#define DEBUG(s)					_DEBUG(s) << std::endl;}
	#define DEBUG1(s,s1)			_DEBUG(s) << s1 << std::endl;}
	#define DEBUG2(s,s1,s2)			_DEBUG(s) << s1 << s2 << std::endl;}
	#define DEBUG3(s,s1,s2,s3)		_DEBUG(s) << s1 << s2 << s3 << std::endl;}
	#define DEBUG4(s,s1,s2,s3,s4)	_DEBUG(s) << s1 << s2 << s3 << s4 << std::endl;}

	#define DEBUGV(s)				_DEBUGV(s) << std::endl;}
	#define DEBUGV1(s,s1)			_DEBUGV(s) << s1 << std::endl;}
	#define DEBUGV2(s,s1,s2)		_DEBUGV(s) << s1 << s2 << std::endl;}
	#define DEBUGV3(s,s1,s2,s3)		_DEBUGV(s) << s1 << s2 << s3 << std::endl;}
	#define DEBUGV4(s,s1,s2,s3,s4)	_DEBUGV(s) << s1 << s2 << s3 << s4 << std::endl;}

#else
	#define DEBUG					TRACE
	#define DEBUG1(s,s1)			TRACE1(s,s1)
	#define DEBUG2(s,s1,s2)			TRACE2(s,s1)
	#define DEBUG3(s,s1,s2,s3)		TRACE3(s,s1)
	#define DEBUG4(s,s1,s2,s3,s4)	TRACE4(s,s1)

	#define DEBUGV					TRACEV
	#define DEBUGV1(s,s1)			TRACEV1(s,s1)
	#define DEBUGV2(s,s1,s2)		TRACEV2(s,s1)
	#define DEBUGV3(s,s1,s2,s3)		TRACEV3(s,s1)
	#define DEBUGV4(s,s1,s2,s3,s4)	TRACEV4(s,s1)

#endif

#define ASSERT(f)       {((void)0);}
#define ASSERTN(f)		ASSERT(f)

#define ASSERTSN(f,s)	ASSERTS(f,s)

#define ASSERT0(f,s)				ASSERT(f) 
#define ASSERT1(f,s,p)				ASSERT(f)
#define ASSERT2(f,s,p1,p2)			ASSERT(f)
#define ASSERT3(f,s,p1,p2,p3)		ASSERT(f)
#define ASSERT4(f,s,p1,p2,p3,p4)	ASSERT(f)

#define ASSERTN0(f,s)				ASSERT(!f) 
#define ASSERTN1(f,s,p)				ASSERT(!f) 
#define ASSERTN2(f,s,p1,p2)			ASSERT(!f) 
#define ASSERTN3(f,s,p1,p2,p3)		ASSERT(!f) 
#define ASSERTN4(f,s,p1,p2,p3,p4)	ASSERT(!f) 


#define VERIFY(f)						 ((void)(f))
#define VERIFY0(f,s)				     ASSERT0(f,s)
#define VERIFY1(f,s,p)					 ASSERT1(f,s,p)
#define VERIFY2(f,s,p1,p2)				 ASSERT2(f,s,p1,p2)
#define VERIFY3(f,s,p1,p2,p3)			 ASSERT3(f,s,p1,p2,p3)
#define VERIFY4(f,s,p1,p2,p3,p4)         ASSERT4(f,s,p1,p2,p3,p4)

#define VERIFYN(f)						 ASSERTN(f)
#define VERIFYN0(f,s)					 ASSERTN0(f,s,p)
#define VERIFYN1(f,s,p)					 ASSERTN1(f,s,p)
#define VERIFYN2(f,s,p1,p2)				 ASSERTN2(f,s,p1,p2)
#define VERIFYN3(f,s,p1,p2,p3)			 ASSERTN3(f,s,p1,p2,p3)
#define VERIFYN4(f,s,p1,p2,p3,p4)        ASSERTN4(f,s,p1,p2,p3,p4)

#define THROWM(s)						  ASSERT0(FALSE,s)
#define THROWM1(f,s,p)					  ASSERT1(FALSE,s,p)
#define THROWM2(f,s,p1,p2)				  ASSERT2(FALSE,s,p1,p2)
#define THROWM3(f,s,p1,p2,p3)			  ASSERT3(FALSE,s,p1,p2,p3)
#define THROWM4(f,s,p1,p2,p3,p4)          ASSERT4(FALSE,s,p1,p2,p3,p4)


#define DEBUG_ONLY(f)      ()


#endif






}
#endif
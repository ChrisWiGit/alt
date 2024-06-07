/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

// ThreadSafeClass.h: Schnittstelle f�r die Klasse CThreadSafeClass.
//
//////////////////////////////////////////////////////////////////////
#include "definitions.h"

#ifndef VTHREADSAFECLASS_H
#define VTHREADSAFECLASS_H 


#pragma once


#if ((defined(__DOTRACE__) && defined(_DEBUG)) || defined(__AFX_H__))
//#include "afx.h"
#else
#include <windows.h>
#endif


//#define VThreadSafeClass CThreadSafeClass  

//#define UnLock Unlock

namespace vtools
{

class _EXPORT_DLL_ VThreadSafeClass  
{
	HANDLE _hMutex;            // used to lock/unlock object
public:
	VThreadSafeClass();
	virtual ~VThreadSafeClass();

	void Unlock () const;
	bool Lock () const;  
};
};
#endif 

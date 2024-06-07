/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

// ThreadSafeClass.cpp: Implementierung der Klasse CThreadSafeClass.
//
//////////////////////////////////////////////////////////////////////

#include "ThreadSafeClass.h"

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////

namespace vtools
{


VThreadSafeClass::VThreadSafeClass()
{
	_hMutex = ::CreateMutex( NULL, false,NULL) ; 
}

VThreadSafeClass::~VThreadSafeClass()
{
	::CloseHandle( _hMutex );
}

bool VThreadSafeClass::Lock () const
{
	if ( _hMutex == NULL )
		return false;
#ifdef __DOTRACE__	
	TRACE("%s(%s) - Enter VThreadSafeClass::Lock()",__FILE__,__LINE__);
#endif
	WaitForSingleObject( _hMutex, INFINITE );
	return true;
}
    
void VThreadSafeClass::Unlock () const
{ 
	ReleaseMutex(_hMutex);      
}
};
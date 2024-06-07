/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#ifndef DEFINITIONS_H
#define DEFINITIONS_H

#pragma once

#define _WIN32_WINNT 0x0500
#include "windows.h"

namespace vtools
{

#define NOWARNINGS


#ifdef EXP_STL
# define _EXPORT_DLL_ __declspec(dllexport)
# define _EXPORT_STL_ extern 
# define _EXPORT_STL_C_ extern "C"
#else
# define _EXPORT_DLL_ 
	//__declspec(dllimport)
# define _EXPORT_STL_ static
# define _EXPORT_STL_C_ static
#endif

//#define _EXPORT_DLL_ __declspec(dllexport)


/*struct _EXPORT_DLL_ VPoint
{
	int x,y;
};*/

typedef _COORD VPoint;

struct _EXPORT_DLL_ VRect
{
	VPoint Top,Bottom;
	int Width() {return Bottom.X - Top.X+1;};
	int Height() {return Bottom.Y - Top.Y+1;};
};


#ifdef NOWARNINGS
#pragma warning(disable:4267)
#pragma warning(disable:4244)
#pragma warning(disable:4390)
#pragma warning(disable:4018)
#pragma warning(disable:4018)
#pragma warning(disable:4018)

#pragma warning(disable:4800) //forcing value to bool true opr false
#endif
}

#endif
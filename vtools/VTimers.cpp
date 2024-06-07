/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#ifndef VLISTS_H
#define VLISTS_H

#include "definitions.h"
#include <list>
#include <vector>
#include <windows.h>
#include <sstream>
#include "vstring.h"
#include "vlists.h"

#pragma once


namespace vtools
{
	class VTimer 
	{
		VIntVector m_timer;
	public:
			VTimer();
			virtual ~VTimer;

			void Init(HWND WinHandle);
			int AddTimer(UINT nIDEvent,UINT uElapse);
			bool RemoveTimer(UINT_PTR Timer);

			virtual TimerProc(HWND hwnd, UINT uMsg, UINT_PTR idEvent,  DWORD dwTime);

	}
}

#endif
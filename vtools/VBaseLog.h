#ifndef VBASELOG_H
#define VBASELOG_H

#pragma once

#include "definitions.h"
#include <list>
#include <fstream>


#define DOTRACE true
//#define USING_MAINLOG

namespace vtools
{

//using namespace std;

class VBaseLog;

typedef std::string VLogStringList;
typedef void (*NEWLOG)(VBaseLog *Log, char* sLog, bool &bAdd);


class _EXPORT_DLL_ VBaseLog
{
public:
	VLogStringList m_sLogString;

	VBaseLog();
	~VBaseLog();
    
	void Add(const char* s,...);

	bool m_bDoTrace;
	NEWLOG m_pOnAdd;

	void* m_pData;
	std::fstream *m_pStream;

protected:
	LPCRITICAL_SECTION cs;

};


extern VBaseLog MainLog;



}


#endif
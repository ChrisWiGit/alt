#include "vbaselog.h"
#include "assertions.h"

namespace vtools
{

VBaseLog MainLog;

//bool VBaseLog::m_bDoTrace = DOTRACE;

VBaseLog::VBaseLog()
{
	m_bDoTrace = true;
	m_pOnAdd = NULL;

	cs=new CRITICAL_SECTION;
	InitializeCriticalSection(cs);
}

VBaseLog::~VBaseLog()
{
	m_sLogString.clear();

	DeleteCriticalSection(cs);
}

void VBaseLog::Add(const char* s,...)
{
#ifdef _DEBUG
	char p[1024];
	va_list vaList;
	va_start(vaList, s);
	wvsprintf(p,s,vaList);
	va_end(vaList);	

	bool DoAdd = true;
	if (m_pOnAdd != NULL)
		m_pOnAdd(this,p,DoAdd);

	if (DoAdd)
	{
		EnterCriticalSection(cs);
		m_sLogString.append(p);
		if (m_bDoTrace)
		{
			vtools::OutputDebugV(p);
		}
		LeaveCriticalSection(cs);
	}
#endif
}

};
#include "stdafx.h"
#ifndef GLOBAL
#define GLOBAL
BOOL IsCode=FALSE;
BOOL GetIsCode()
{
	return IsCode;
}
BOOL SetIsCode(BOOL x)
{
	IsCode = x;
	return x;
}


#endif
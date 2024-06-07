#pragma once

#include "resource.h"
#include "vstring.h"
#include "vdialog.h"


using namespace vtools;

class VRunAsDialogHandler : public VDlgHandler
{
	
public :
	//VDlgHandler(void);
	//WM_INITDIALOG 
	//called for initialisation
	//return valued is used by DialogProc
	virtual BOOL OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam);

	virtual BOOL OnShow(long Status, bool FirstShow);
	//WM_COMMAND
	//return valued is used by DialogProc
	virtual BOOL OnCommand(UINT message, WPARAM wParam, LPARAM lParam);

	//WM_NOTIFY
	//use this OnNotify instead of OnDefaultMessage for WM_NOTIFY messages
	//return valued is ignored
	//virtual BOOL OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr) {return FALSE;};

	//WM_DESTROY
	//return value is ignored
	virtual BOOL OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam);


};

/*
	VDialog Template Class Header File.

	Use this file to create your own winapi dialog.

	Simple steps 
	1. Copy both files : VTemplateDialog.h AND VTemplateDialog.cpp 
	    to another location and rename them
	2. Rename all placeholder _NAME_ to a correct expression
	
*/

#ifndef _V_NAME_DIALOG_H
#define _V_NAME_DIALOG_H 



#include "..\vdialog.h"
//add this resource to access your resources ID
//#include "resource.h"

//Change this to your dialog resource ID 
const int VDLG_NAME_RESOURCEID = 118;

/*
Use these includes if neccessary
*/
//#include "windows.h"
//#include "VString.h"
//#include "assertions.h"

//using namespace vtools to access vtools members
using namespace vtools;

class V_NAME_DialogHandler :
	public VDlgHandler
{
public:
	V_NAME_DialogHandler(void);
	~V_NAME_DialogHandler(void);

	/*
	You can use these message methods
	*/

	//WM_INITDIALOG 
	//called for initialisation
	//return valued is used by DialogProc
	virtual BOOL OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam);

	//WM_COMMAND
	//return valued is used by DialogProc
	virtual BOOL OnCommand(UINT message, WPARAM wParam, LPARAM lParam);

	//WM_SYSCOMMAND
	//return valued is used by DialogProc
	virtual BOOL OnSysCommand(UINT message, WPARAM wParam, LPARAM lParam);

	//Message not handled by other message methods
	//return valued is used by DialogProc
	virtual BOOL OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam);

	//called everytime before each type of message - even if dialog is not initialised
	//return valued is used by DialogProc
	virtual BOOL OnAllMessage(UINT message, WPARAM wParam, LPARAM lParam) ;

	//called before a dialoge is closed
	//return TRUE if dialog can be closed otherwise FALSE
	virtual BOOL OnCloseQuery(UINT message, WPARAM wParam, LPARAM lParam) ;

	//called when a dialoge is about to be closed
	//return valued is ignored
	virtual int OnClose(UINT message, WPARAM wParam, LPARAM lParam);

	//WM_NOTIFY
	//use this OnNotify instead of OnDefaultMessage for WM_NOTIFY messages
	//return valued is ignored
	virtual BOOL OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr);

	//WM_DESTROY
	//return value is ignored
	virtual BOOL OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam);


	//WM_SHOWWINDOW
	//Status : see MSDN "WM_SHOWWINDOW"
	//FirstShow indicates whether dialoge is shown the first time
	//return value is ignored
	virtual BOOL OnShow(long Status, bool FirstShow);
	virtual BOOL OnHide(long Status);
	



	
};
extern bool Execute_NAME_Dialog(HWND hParentWindow);

#endif
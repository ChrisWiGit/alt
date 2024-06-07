/*
	VDialog Template Class Header File.

	Use this file to create your own winapi dialog.

	Simple steps 
	1. Copy both files : VTemplateDialog.h AND VTemplateDialog.cpp 
	    to another location and rename them
	2. Rename all placeholder _NAME_ to a correct expression
	
*/

#include "vtemplatedialog.h"

V_NAME_DialogHandler::V_NAME_DialogHandler(void) : VDlgHandler()
{
	//your code here...
}

V_NAME_DialogHandler::~V_NAME_DialogHandler(void)
{
	//your code here...
}


//WM_INITDIALOG 
//called for initialisation
BOOL V_NAME_DialogHandler::OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam)
{
	/*
	You can also center the window on screen or desktop
	*/
	//this->m_hDialog->CenterWindow();

	//your code here...
	return VDlgHandler::OnInitDialog(hwnd,message,wParam,lParam);
}


//WM_COMMAND
BOOL V_NAME_DialogHandler::OnCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnCommand(message,wParam,lParam);;
}


//WM_SYSCOMMAND
BOOL V_NAME_DialogHandler::OnSysCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnSysCommand(message,wParam,lParam);
}


//Message not handled by other message methods
BOOL V_NAME_DialogHandler::OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnDefaultMessage(message,wParam,lParam);
}


//called everytime before each type of message - even if dialog is not initialised
BOOL V_NAME_DialogHandler::OnAllMessage(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnAllMessage(message,wParam,lParam);
}


//called before a dialoge is closed
//return TRUE if dialog can be closed otherwise FALSE
BOOL V_NAME_DialogHandler::OnCloseQuery(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnCloseQuery(message,wParam,lParam);
}


//called when a dialoge is about to be closed
int V_NAME_DialogHandler::OnClose(UINT message, WPARAM wParam, LPARAM lParam)
{
	/*
	Program does not exit.
	If you are using a main dialog you must call PostQuitMessage to stop
	main event loop;
	*/
	//PostQuitMessage(0);

	//your code here...
	return VDlgHandler::OnClose(message,wParam,lParam);
}


//WM_NOTIFY
//use this OnNotify instead of OnDefaultMessage for WM_NOTIFY messages
BOOL V_NAME_DialogHandler::OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr)
{
	//your code here...
	return VDlgHandler::OnNotify(hWnd,IdFrom,pnmhdr);
}


//WM_DESTROY
//return value is ignored
BOOL V_NAME_DialogHandler::OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnDestroyDialog(message,wParam,lParam);
}

//WM_SHOWWINDOW
//Status : see MSDN "WM_SHOWWINDOW"
//FirstShow indicates whether dialoge is shown first time
//return value is ignored
BOOL V_NAME_DialogHandler::OnShow(long Status, bool FirstShow) 
{
	//your code here...

	//you must call predecessor
	return VDlgHandler::OnShow(Status,FirstShow); //return value is ignored
}

BOOL V_NAME_DialogHandler::OnHide(long Status)
{
	return TRUE; //return value is ignored
}
	
/*
Example how to create an show a modal dialog box.
You must set VDLG_NAME_RESOURCEID in header file
to a dialoge resource ID

*/
bool Execute_NAME_Dialog(HWND hParentWindow)
{
	V_NAME_DialogHandler DlgHandler;
	VDialog TheDialog((HINSTANCE)GetModuleHandle(NULL),VDLG_NAME_RESOURCEID,hParentWindow,&DlgHandler);

	return TheDialog.Execute();
}
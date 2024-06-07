/*
	VDialog Template Class Header File.

	Use this file to create your own winapi dialog.

	Simple steps 
	1. Copy both files : VTemplateDialog.h AND VTemplateDialog.cpp 
	    to another location and rename them
	2. Rename all placeholder _NAME_ to a correct expression
	
*/

#include "vtemplatetabdialog.h"

V_NAME_MainTabDialogHandler::V_NAME_MainTabDialogHandler(void) : VDlgHandler()
{

	//your code here...
}

V_NAME_MainTabDialogHandler::~V_NAME_MainTabDialogHandler(void)
{

	//your code here...
}


//WM_INITDIALOG 
//called for initialisation
BOOL V_NAME_MainTabDialogHandler::OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam)
{

	//inits the tab control
	HWND hTabControl = GetDlgItem(this->m_hDialog->m_hWnd,VTABCONTROL_RESOURCEID);

	//be aware that in a release version this check does not exist!
	ASSERT0(hTabControl != NULL,"OnInitDialog: The tab control handle returned by GetDlgItem is invalid!");

	m_MainTabControl.Init(hTabControl,this->m_hDialog->m_hWnd,this->m_hDialog->m_MainApp);

	//sets the main dialog handler class
	//you should set this for all new debughandlers

	this->m_DlgHandler.m_pTabControlHandler = this;

	//Add new pages
	//to add new pages adapt NAME_TabSheets in your header file
	for (int page=0;page < _NAME_TABSHEETS_SIZE; page++)
	{
		//change NULL to this because NULL is not acceptable
		if (_NAME_TabSheets[page].pDialogHandler == NULL)
		{
			_NAME_TabSheets[page].pDialogHandler = &this->m_DlgHandler;
		}

		m_MainTabControl.AddTab(page,_NAME_TabSheets[page].sName,
			_NAME_TabSheets[page].pDialogHandler,
			_NAME_TabSheets[page].wDlgResourceID);
	}

	//select first tab
	m_MainTabControl.SelectTab(0);

	/*
	You can also center the window on screen or desktop
	*/
	this->m_hDialog->CenterWindow(ct_screen);



	//your code here...
	return VDlgHandler::OnInitDialog(hwnd,message,wParam,lParam);
}


//WM_COMMAND
BOOL V_NAME_MainTabDialogHandler::OnCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	/*
	Warning:
	this->m_MainTabDialogHandler->OnCommand(message,wParam,lParam);
	and similar calls in all functions of this class 
	  can have unpredictable results!
	
	*/
	//your code here...
	return VDlgHandler::OnCommand(message,wParam,lParam);;
}


//WM_SYSCOMMAND
BOOL V_NAME_MainTabDialogHandler::OnSysCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnSysCommand(message,wParam,lParam);
}


//Message not handled by other message methods
BOOL V_NAME_MainTabDialogHandler::OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnDefaultMessage(message,wParam,lParam);
}


//called everytime before each type of message - even if dialog is not initialised
BOOL V_NAME_MainTabDialogHandler::OnAllMessage(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnAllMessage(message,wParam,lParam);
}


//called before a dialoge is closed
//return TRUE if dialog can be closed otherwise FALSE
BOOL V_NAME_MainTabDialogHandler::OnCloseQuery(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnCloseQuery(message,wParam,lParam);
}


//called when a dialoge is about to be closed
int V_NAME_MainTabDialogHandler::OnClose(UINT message, WPARAM wParam, LPARAM lParam)
{
	//tabs entfernen damit sie das nächste Mal wieder erscheinen
	try
	{
		this->m_MainTabControl.Clear();
	}
	catch(...)
	{
	}

	/*
	Program does not exit.
	If you are using a main dialog you must call PostQuitMessage to stop
	main event loop;
	*/
	PostQuitMessage(0);

	//your code here...
	return VDlgHandler::OnClose(message,wParam,lParam);
}


//WM_NOTIFY
//use this OnNotify instead of OnDefaultMessage for WM_NOTIFY messages
BOOL V_NAME_MainTabDialogHandler::OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr)
{
	//we must notify tab control
	if (this->m_MainTabControl.OnDefaultMessage(WM_NOTIFY,IdFrom,(LPARAM)pnmhdr) == TRUE)
		return TRUE;

	//your code here...
	return VDlgHandler::OnNotify(hWnd,IdFrom,pnmhdr);
}


//WM_DESTROY
//return value is ignored
BOOL V_NAME_MainTabDialogHandler::OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnDestroyDialog(message,wParam,lParam);
}

//WM_SHOWWINDOW
//Status : see MSDN "WM_SHOWWINDOW"
//FirstShow indicates whether dialoge is shown first time
//return value is ignored
BOOL V_NAME_MainTabDialogHandler::OnShow(long Status, bool FirstShow) 
{
	//your code here...

	//you must call predecessor
	return VDlgHandler::OnShow(Status,FirstShow); //return value is ignored
}

BOOL V_NAME_MainTabDialogHandler::OnHide(long Status)
{
	return TRUE; //return value is ignored
}

/********************************************







********************************************/

V_NAME_TabHandler::V_NAME_TabHandler(void) : VDlgHandler()
{

	//your code here...
}

V_NAME_TabHandler::~V_NAME_TabHandler(void)
{

	//your code here...
}


//WM_INITDIALOG 
//called for initialisation
BOOL V_NAME_TabHandler::OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnInitDialog(hwnd,message,wParam,lParam);
}


//WM_COMMAND
BOOL V_NAME_TabHandler::OnCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnCommand(message,wParam,lParam);;
}


//WM_SYSCOMMAND
BOOL V_NAME_TabHandler::OnSysCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnSysCommand(message,wParam,lParam);
}


//Message not handled by other message methods
BOOL V_NAME_TabHandler::OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnDefaultMessage(message,wParam,lParam);
}


//called everytime before each type of message - even if dialog is not initialised
BOOL V_NAME_TabHandler::OnAllMessage(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnAllMessage(message,wParam,lParam);
}


//called before a dialoge is closed
//return TRUE if dialog can be closed otherwise FALSE
BOOL V_NAME_TabHandler::OnCloseQuery(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnCloseQuery(message,wParam,lParam);
}


//called when a dialoge is about to be closed
int V_NAME_TabHandler::OnClose(UINT message, WPARAM wParam, LPARAM lParam)
{
	//your code here...
	return VDlgHandler::OnClose(message,wParam,lParam);
}


//WM_NOTIFY
//use this OnNotify instead of OnDefaultMessage for WM_NOTIFY messages
BOOL V_NAME_TabHandler::OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr)
{
	//your code here...
	return VDlgHandler::OnNotify(hWnd,IdFrom,pnmhdr);
}


//WM_DESTROY
//return value is ignored
BOOL V_NAME_TabHandler::OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam) 
{
	//your code here...
	return VDlgHandler::OnDestroyDialog(message,wParam,lParam);
}

//WM_SHOWWINDOW
//Status : see MSDN "WM_SHOWWINDOW"
//FirstShow indicates whether dialoge is shown first time
//return value is ignored
BOOL V_NAME_TabHandler::OnShow(long Status, bool FirstShow) 
{
	//your code here...

	//you must call predecessor
	return VDlgHandler::OnShow(Status,FirstShow); //return value is ignored
}

BOOL V_NAME_TabHandler::OnHide(long Status)
{
	return TRUE; //return value is ignored
}

/*
Example how to create an show a modal dialog box.
You must set VDLG_NAME_RESOURCEID in header file
to a dialoge resource ID

*/
bool ExecuteNAMETabDialog(HWND hParentWindow)
{
	V_NAME_MainTabDialogHandler DlgHandler;
	VDialog TheDialog((HINSTANCE)GetModuleHandle(NULL),VDLG_NAME_RESOURCEID,hParentWindow,&DlgHandler);

	return TheDialog.Execute();
}
/*
	VTabDialog Template Class Header File.

	Use this file to create your own winapi dialog with a tab.

	Simple steps 
	1. Copy both files : VTemplateTabDialog.h AND VTemplateTabDialog.cpp 
	    to another location and rename them
	2. Rename all placeholder _NAME_ to a correct expression of your choice
	
	Further steps:
	1. Adapt _NAME_TabSheets to add new pages
	2. Add your code into the methods of both dialog handlers
	   

*/
//#include "..\definitions.h"

#ifndef _V_NAME_TABDIALOG_H
#define _V_NAME_TABDIALOG_H 



#include "..\vdialog.h"
#include "..\vTabControl.h"
//add your here your resource header file the defined constants 
//#include "resource.h"  

//Change this constant to your dialog resource ID
const int VDLG_NAME_RESOURCEID = 122; //IDD_YOUR_DIALOG

//Change this constant to your tab control dialog resource ID
const int VTABCONTROL_RESOURCEID = 1047;//IDC_YOUR_TAB_CONTROL

//Amount of tabsheets in your main tab control
const int _NAME_TABSHEETS_SIZE = 2;

//set the dialog tabsheets
//you can add here your new tabsheets
structDialogTabSheet _NAME_TabSheets[_NAME_TABSHEETS_SIZE] = 
{ 
//first dialog	
  "123", //tab caption
  NULL,  //dialog handler - NULL if main tab control handler (V_NAME_TabHandler) shall be used
  124,	 //dialog resource ID that shall be used

//second dialog 
  "123",NULL,4020
//and so on...
};

/*
Use these includes if neccessary
*/
//#include "windows.h"
//#include "VString.h"
//#include "assertions.h"

//using namespace vtools to access vtools members
using namespace vtools;


class _NAME_TabHandler;

/**********************************
Main dialog message handler class
**********************************/

class V_NAME_MainTabDialogHandler :
	public VDlgHandler
{
public:
	VTabControl m_MainTabControl;

	VDlgHandler m_DlgHandler;
public:
	V_NAME_MainTabDialogHandler(void);
	~V_NAME_MainTabDialogHandler(void);

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

/*
This is your tab sheet debug handler class
You can it use for even more than one tab dialog!

Do not try to use the class above!
*/

class V_NAME_TabHandler :
	public VDlgHandler
{
public:
	//a pointer to the main V_NAME_MainTabDialogHandler class
	V_NAME_MainTabDialogHandler *m_MainTabDialogHandler;

public:
	V_NAME_TabHandler(void);
	~V_NAME_TabHandler(void);

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





extern bool ExecuteNAMETabDialog(HWND hParentWindow);



#endif
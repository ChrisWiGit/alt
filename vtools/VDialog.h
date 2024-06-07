/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#include "definitions.h"

#ifndef VDIALOG_H
#define VDIALOG_H

#pragma once

#define V_USE_ASSERTION

#include <map>
#include "windows.h"
#include "vstring.h"
//#include "VNCMain.h"
#include "assertions.h"


namespace vtools
{
	using namespace std;

class VDialog;

struct _EXPORT_DLL_ tMessage
{
	VDialog *Dialog;
	HINSTANCE hInstance;
	int iMessage;
	LPVOID lpData;
};

#pragma warning(disable : 4251) //Info: http://www.c-plusplus.de/forum/viewtopic.php?p=360203#360203

typedef void (*CMDPROC)(tMessage Message);

/*Abstrakte Nachrichtenbehandlungsklasse f�r Dialoge
*/
class _EXPORT_DLL_ VDlgHandler
{
public:
	//a pointer to a tab control handler. You can set this by yourself if necessary. 
	//It is not used internally.
	VDlgHandler *m_pTabControlHandler; 

	VDialog *m_hDialog;
	bool wasShown;
public :
	VDlgHandler(void);
	/*
	You can use these message methods

	
	For return value consider following extract from DialogProc Function
		(http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/windowing/dialogboxes/dialogboxreference/dialogboxfunctions/dialogproc.asp)

	Typically, the dialog box procedure should return TRUE if it processed the message, 
	and FALSE if it did not. If the dialog box procedure returns FALSE, the dialog manager 
	performs the default dialog operation in response to the message.

	If the dialog box procedure processes a message that requires a specific 
	return value, the dialog box procedure should set the desired return value by 
	calling SetWindowLong(hwndDlg, DWL_MSGRESULT, lResult) immediately before returning TRUE. 
	Note that you must call SetWindowLong immediately before returning TRUE; 
	doing so earlier may result in the DWL_MSGRESULT value being 
	overwritten by a nested dialog box message.

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
	virtual BOOL OnSysCommand(UINT message, WPARAM wParam, LPARAM lParam) {return FALSE;};

	//Message not handled by other message methods
	//return valued is used by DialogProc
	virtual BOOL OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam) {return FALSE;};

	//called everytime before each type of message - even if dialog is not initialised
	//return valued is used by DialogProc
	virtual BOOL OnAllMessage(UINT message, WPARAM wParam, LPARAM lParam) {return FALSE;};

	//called before a dialoge is closed
	//return TRUE if dialog can be closed otherwise FALSE
	virtual BOOL OnCloseQuery(UINT message, WPARAM wParam, LPARAM lParam) {return TRUE;};

	//called when a dialoge is about to be closed
	//return valued is ignored
	virtual int OnClose(UINT message, WPARAM wParam, LPARAM lParam);

	//WM_NOTIFY
	//use this OnNotify instead of OnDefaultMessage for WM_NOTIFY messages
	//return valued is ignored
	virtual BOOL OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr) {return FALSE;};

	//WM_DESTROY
	//return value is ignored
	virtual BOOL OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam) {return TRUE;};


	//WM_SHOWWINDOW
	//Status : see MSDN "WM_SHOWWINDOW"
	//FirstShow indicates whether dialoge is shown the first time
	//return value is ignored
	virtual BOOL OnShow(long Status, bool FirstShow) {wasShown = true; return TRUE;};
	virtual BOOL OnHide(long Status) {return TRUE;};
	

	//returns the dialog status
	//true if OnShow was called before otherwise false
	bool AlreadyShown() {return wasShown;};
};

//class VDialog;
//EXPORT_STL template class EXPORT_DLL std::map <_Kty,_Ty>;

//template class std::map<HWND,VDialog*> map_<_Kty,_Ty>;

//_EXPORT_STL_ template class EXPORT_DLL std::map <HWND, VDialog*>;

//template class __declspec(dllexport) map<HWND,VDialog*>;

#ifdef EXP_STL
template __declspec(dllexport) std::map<HWND, VDialog*>;
#else
//extern template __declspec(dllimport) std::map<HWND, VDialog*>;
#endif


typedef map<HWND,VDialog*> DIALOGLIST;
enum _EXPORT_DLL_ Center_Type {ct_screen,ct_desktop,ct_parent};

class _EXPORT_DLL_ VDialog
{
protected:
    /*contains a list of VDialog (this pointer) accessed by the window handle
    (these handles are unique, so several windows can be used with by only one VDlgHandler!)
    */
    static DIALOGLIST m_DialogList;	    
	VDialog(HINSTANCE MainApp,const LPCTSTR lpTemplate,  HWND hWndParent,VDlgHandler *Handler);

	bool m_CenterWindow;

	//
public:
    VDlgHandler *m_Handler; //message handler class
    HWND m_hWnd;  //dialog handle
    HINSTANCE m_MainApp; //application instance handle
	WORD m_lpTemplate; //resource template
    HWND m_hWndParent; //parent
	CMDPROC m_proc;	

	//main DialogProc for all VDialog instances - do not use directly!
	static BOOL CALLBACK DialogProc(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam);		
	
public:
	//Constructors
	VDialog(HINSTANCE MainApp, WORD lpTemplate,  HWND hWndParent,VDlgHandler *Handler, CMDPROC proc = NULL);
	//Standard-Constructor use Init to initialize Members
	VDialog() {};
	virtual ~VDialog(void);

	//initializes all given members, but does not create any dialog structure
	void Init(HINSTANCE MainApp, WORD lpTemplate,  HWND hWndParent,VDlgHandler *Handler, CMDPROC proc = NULL);
	
	//Creats a dialog, initialises all members and returns the dialog handle
	HWND Create(HINSTANCE hInstance,WORD lpTemplate, HWND hWndParent,VDlgHandler *Handler);
	//Create needs a Destroy() to free dialog resources !
	void Destroy();

	//connects VDialog to a given dialog handle
	void SetHWnd(HWND handle){if (m_hWnd == 0) m_hWnd = handle;};

	//Runs a modal Dialogbox 
	int Run(BOOL Modal = FALSE);
	//Runs a modal Dialogbox and returns Ok or Cancel  (TRUE - FALSE)
	BOOL Execute(void);
	//stops executing a dialog and returns with retvalue
	BOOL EndDialog(int retvalue, int lParam = 0);

    //center the dialog within the screen
    //void CenterWindow();
    void CenterWindow(Center_Type aCenter = ct_screen);

	//routines for control editing
	void SetEditText(int DlgItem,const VString Text);
	VString GetEditText(int DlgItem);

	//enables a dialog item, or dialog itself if DlgItem is 0
	void EnableWindow(int DlgItem, bool bEnable);
	bool IsWindowEnabled(int DlgItem);

	//sets or unset Top_Most state of dialog
	void TopMost(bool Top); 
	//gets TopMost state of dialog
	bool IsTopMost();

	//switch between Top_Most and not Top_Most state of dialog
	//returns the new state (true if now top most, otherwise false)
	bool FlipTopMost();
			
	bool AlreadyShown() {return m_Handler->AlreadyShown();};

		//gets visibility state of an item
	//set DlgItem 0 retrieves v. state of dialog itself
	bool IsWindowVisible(int DlgItem);

	void BringToTop() { ::BringWindowToTop(this->m_hWnd); };

	//see global GetVDialogByHandle
	static VDialog *GetVDialogByHandle(HWND hwnd);
};


/*
Retrieves a pointer to a VDialog class that owns the window handle hwnd.
If no dialog class could be found, it returns NULL.

This function uses the static method GetVDialogByHandle of VDialog,
that has access to m_DialogList, which contains all Dialog window handles
of all instances, because it is static. That means, each instance of VDialog
is listed in that list and can be access through a simple window handle.
*/
extern VDialog *GetVDialogByHandle(HWND hwnd);


extern int GetEditTextLength(HWND hwnd,int DlgItem);
extern VString GetEditText(HWND hwnd,int DlgItem);
extern void SetEditText(HWND hwnd,int DlgItem,const VString Text);

};


#endif // ifdef H_VDIALOG
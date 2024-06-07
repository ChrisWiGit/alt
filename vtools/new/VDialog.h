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
	VDialog *m_hDialog;
public :
	VDlgHandler(void);
	virtual BOOL OnCommand(UINT message, WPARAM wParam, LPARAM lParam);
	virtual BOOL OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam);
	virtual BOOL OnSysCommand(UINT message, WPARAM wParam, LPARAM lParam) {return FALSE;};
	virtual BOOL OnNotify(UINT message, WPARAM wParam, LPARAM lParam) {return FALSE;};
	virtual BOOL OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam) {return FALSE;};

	virtual BOOL OnCloseQuery(UINT message, WPARAM wParam, LPARAM lParam) {return TRUE;};
	virtual int OnClose(UINT message, WPARAM wParam, LPARAM lParam);

	virtual BOOL OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam) {return TRUE;};

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


class _EXPORT_DLL_ VDialog
{
protected:
    bool m_CenterWindow;
	/*contains a list of VDialog (this pointer) accessed by the window handle
    (these handles are unique, so several windows can be used with by only one VDlgHandler!)
    */
    static DIALOGLIST m_DialogList;	    
	VDialog(HINSTANCE MainApp,const LPCTSTR lpTemplate,  HWND hWndParent,VDlgHandler *Handler);

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
	void Destroy() {::DestroyWindow(m_hWnd); m_hWnd = 0;};

	//connects VDialog to a given dialog handle
	void SetHWnd(HWND handle){if (m_hWnd == 0) m_hWnd = handle;};

	//Runs a modal Dialogbox 
	int Run(BOOL Modal = FALSE);
	//Runs a modal Dialogbox and returns Ok or Cancel  (TRUE - FALSE)
	BOOL Execute(void);
	//stops executing a dialog and returns with retvalue
	BOOL EndDialog(int retvalue);

    //center the dialog within the screen
    void CenterWindow();

	//routines for control editing
	void SetEditText(int DlgItem,const VString Text);
	VString GetEditText(int DlgItem);

	//enables a dialog item, or dialog itself if DlgItem is 0
	void EnableWindow(int DlgItem, bool bEnable);
	bool IsWindowEnabled(int DlgItem);

	//gets visibility state of an item
	//set DlgItem 0 retrieves v. state of dialog itself
	bool IsWindowVisible(int DlgItem);

	bool BringToTop() {return (bool)::BringWindowToTop(this->m_hWnd);};

	
};

};


#endif // ifdef H_VDIALOG
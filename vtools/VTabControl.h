#pragma once


#include <vector>
#include "windows.h"
#include "commctrl.h"
#include "VDialog.h"

using namespace vtools;

namespace vtools
{

typedef std::vector<VDialog*> TABSHEETS;


/*
This TabControl class provides basic functionality for a tab control,
to use not implemented functions lookup the keyword "TabCtrl_"
in MSDN

http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/tab/reflist.asp

*/
class _EXPORT_DLL_ VTabControl
{
	HWND m_hTabCtrl; //Tab Ctrl Handle
	HWND m_hDialog; //Parent handle of TabCtrl
	HINSTANCE m_hInstance;

	TABSHEETS m_TabSheets;

//	RECT m_rect;
public:
	VTabControl(void);
	~VTabControl(void);
	void Init(HWND hTabCtrl, HWND hDialog,HINSTANCE hInstance);

	/*call this func. in your VDialog::OnDefaultMessage and check result.
	If TRUE the message was used by TabControl.
	*/
	virtual BOOL OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam);

	/*Adds a new Tab with a dialog resource to the TabControl
	use hExtraInstance, if a dialog resource should be used of another instance
	*/
	int AddTab(int iIdx, const LPTSTR Text,VDlgHandler *Handler,WORD wTemplate,HINSTANCE hExtraInstance = 0);
	int AddTab(int iIdx, const LPTCITEM pitem, VDlgHandler *Handler,WORD wTemplate,HINSTANCE hExtraInstance= 0);

	//removes all Tabs
	int Clear();

	/*brings the tab with iIdx to foreground
	  it does not change tab control buttons
	  use instead SetTabIndex
	*/
	bool ShowTab(int iIdx,bool show = true);

	/*
	selects a tab like SetTabIndex
	*/
	void SelectTab(int iIdx);

	/*
	  changes the tab button to iIdx
	  it also hides the actual window and shows the new one, with the ID iIdx
	  if iIdx is not a valid index (ranges from 0 to Count -1 it does nothing and returns -1
	*/
	int SetTabIndex(int iIdx);

	int GetTabIndex();

	int Count() {return TabCtrl_GetItemCount(m_hTabCtrl);};


	bool IsValidIndex(int iIdx);

	VDialog *GetDialog(int iIdx);
	VDialog *GetSelectedDialog() {return GetDialog(GetSelected());}
	
	/*same as GetTabIndex*/
	int GetSelected() {return GetTabIndex();};
    
	/*
	returns coordinates of the inner tab control area
	*/
	RECT GetTabArea();

	void AdjustDisplayRect(RECT &rect)
	{
		TabCtrl_AdjustRect(m_hTabCtrl,TRUE,&rect);
	};
	void AdjustWindowRect(RECT &rect)
	{
		TabCtrl_AdjustRect(m_hTabCtrl,FALSE,&rect);
	};


	HWND getTabCtrl() {return m_hTabCtrl;};
	HINSTANCE getInstance() {return m_hInstance;};
};

/*
A struct to create an array of tabsheets for easy creating
*/
struct _EXPORT_DLL_ structDialogTabSheet 
{
	//tab caption
	VString sName;		
	//pointer to tab dialog handler 
	//NULL if main tab control handler shall be used
	VDlgHandler *pDialogHandler; 
	
	//dialog resource ID that shall be used
	WORD wDlgResourceID;
};


}
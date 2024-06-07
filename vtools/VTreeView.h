#ifndef VTREEVIEW
#define VTREEVIEW

/*
	VTreeview
	TreeView control for VTools Version 0.5

	If you miss some routines look here: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/treeview/reflist.asp
	Maybe you want to add them as a method ?
*/

#pragma once

#include "windows.h"
#include <commctrl.h>

#include "vstring.h"
#include "VDialog.h"

using namespace vtools;

class VTreeView;

typedef short (*TREEMESSAGE)(VTreeView *Sender,long message, LPVOID Data);

typedef short (*TREEMESSAGE_TVN_SELCHANGED)(VTreeView *Sender,long message, LPNMTREEVIEW Data);
typedef short (*TREEMESSAGE_TVN_GETINFOTIP)(VTreeView *Sender,long message, LPNMTVGETINFOTIP Data);

typedef short (*TREEMESSAGE_DESTROYITEM)(VTreeView *Sender,HTREEITEM item, LPVOID *Data);

typedef short (*TREEMESSAGE_DEFAULT)(VTreeView *Sender,long message, LPVOID Data);




/*
A treeItem data structur that is beeing attached to each treeitem in lParam
use pData for your purposes (its set in AddItem)
*/
struct TreeItem
{
	VTreeView* pParent;
	VString sText;
	LPVOID pData;
};
typedef TreeItem *LPTreeItem;


class VTreeView
{
	
public:
	VTreeView(void);
	~VTreeView(void);

    HWND m_hParent;
	HWND m_hTreeView;

	/****
	  messages

	  can be set to a function that is not a method
	  if you want to use methods you must declare them static and make explicit type conversion
	   e.g. : this->m_Tree->p_OnSelChanged = (TREEMESSAGE_TVN_SELCHANGED)&this->m_Handler.OnTreeSelChanged;
    */
    TREEMESSAGE_TVN_SELCHANGED p_OnSelChanged;
	TREEMESSAGE_TVN_GETINFOTIP p_OnGetInfoTip;
	TREEMESSAGE_DESTROYITEM p_OnDestroyItem;
	TREEMESSAGE_DEFAULT p_OnDefault;

	//sets TreeView styles - see SetWindowLong
	void SetTVProperty(LONG style);
	/*removes Treeview styles
	  Warning: if you try to remove styles that are not set they will be set!
	*/
	void SetTVPropertyOff(LONG style);

	/* Returns all window styles if style is zero.
	   If style is nonzero style will be returned if the windows style contains it
	    otherwise zero.

	*/
	long GetTVProperty(int style = 0);

	//Inits the Treeview
    bool AttachToControl(HWND aParent,HWND aTreeView);
	//Inits the Treeview using VDialog
	bool AttachToControl(VDialog *aParent,int TreeControlItemID);

	//Adds an item 
	//for more information see macro "TreeView_InsertItem" in MSDN
	HTREEITEM AddItem(HTREEITEM hParent,HTREEITEM hInsertAfter,  VString sText, void* lpData);

	//retrieves the TreeItem data structur of the item or null if error
	LPTreeItem GetTreeItemData(HTREEITEM item);

	HTREEITEM GetSelectedItem() {return TreeView_GetSelection(m_hTreeView);};
	bool SelectItem(HTREEITEM Item) {return TreeView_SelectItem(m_hTreeView,Item);};

    void CheckItem(HTREEITEM AItem, bool CheckState);
    bool IsChecked(HTREEITEM AItem);

    /*
    Returns the the parent item that is at root
    */
    HTREEITEM GetRootParent(HTREEITEM AItem);


    UINT GetItemState(HTREEITEM hItem,UINT stateMask);
    UINT SetItemState(HTREEITEM hItem,UINT state,UINT stateMask);


	/*	removes an treeitem from tree
		calls TVN_DELETEITEM in a WM_NOTIFY message (for all sub items)
			that means you have to set OnNotifyMessage

		if you experience problems after removing the last item and then adding a new one
		  the new item will be shown with no text :
	    see SolveDeleteLastItemProblem
	*/
	bool DeleteItem(HTREEITEM hitem);


	/*
		If you experience problems after removing the last item and then adding a new one.
		  The new item will be shown with no text.

	    You can solve this problem in your resource editor by enable AutoScroll

		CONTROL         "",IDC_TREE1,"SysTreeView32",TVS_NOTOOLTIPS | 
                    TVS_NOSCROLL | WS_GROUP | WS_TABSTOP,7,22,233,103,

		TVS_NOSCROLL prevents item to be shown
					
		Or you call this function. That extract TVS_NOSCROLL from window style

		The usual way is to set and unset the TVS_NOSCROLL flag.
		If that does not work try the hard way, that means remove that flag.
	*/
	void SolveDeleteLastItemProblem(bool doHardFix = false);


	/*
		removes all treeitems
		calls TVN_DELETEITEM in a WM_NOTIFY message
			that means you have to set OnNotifyMessage
		call this in your OnClose function before you stop message queue
	*/
	void DeleteAllItems() {if (m_hTreeView)	TreeView_DeleteAllItems(m_hTreeView);};

	bool ExpandItem(HTREEITEM Item) {return TreeView_Expand(m_hTreeView,Item,TVE_EXPAND);};
	bool EnsureVisible(HTREEITEM Item) { return TreeView_EnsureVisible(m_hTreeView,Item);};
	HTREEITEM GetFirstVisible() {return TreeView_GetFirstVisible(m_hTreeView);};



	//call this in your message handler (it checks for WM_NOTIFY)
    bool OnNotifyMessage(UINT message, WPARAM wParam, LPARAM lParam);
	//or this
	bool OnNotifyMessage(HWND hWnd, int IdFrom, NMHDR* pnmhdr);
	

};

#endif
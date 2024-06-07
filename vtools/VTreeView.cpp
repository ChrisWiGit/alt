#include ".\vtreeview.h"

using namespace vtools;

VTreeView::VTreeView(void)
{
	p_OnSelChanged = NULL;
	p_OnGetInfoTip = NULL;
	p_OnDestroyItem = NULL;
	p_OnDefault = NULL;
}

VTreeView::~VTreeView(void)
{
	if (m_hTreeView)
	{
		TreeView_DeleteAllItems(m_hTreeView);
	}
}

bool VTreeView::AttachToControl(HWND aParent,HWND aTreeView)
{
    m_hParent = aParent;
    m_hTreeView = aTreeView;
    return true;
}

bool VTreeView::AttachToControl(VDialog *aParent,int TreeControlItemID)
{
	return this->AttachToControl(aParent->m_hWnd,(HWND)GetDlgItem(aParent->m_hWnd,TreeControlItemID));
}

void VTreeView::SolveDeleteLastItemProblem(bool doHardFix)
{
	if (doHardFix)
	{
		LONG oldstyle = GetWindowLong(m_hTreeView, GWL_STYLE);
	
		if (oldstyle & TVS_NOSCROLL)
			oldstyle ^= TVS_NOSCROLL; //XOR removes bit (10.0000.0000.0000) 
		::SetWindowLong(m_hTreeView, GWL_STYLE, oldstyle);
	}
	else
	{
		//this works fine for me
		SetTVProperty(TVS_NOSCROLL );
		SetTVPropertyOff(TVS_NOSCROLL);
	}
	//retrieves the invisible items
	RECT rect;
	GetClientRect(m_hTreeView,&rect);
	InvalidateRect(m_hTreeView,&rect,TRUE);


/*	CONTROL         "",IDC_TREE1,"SysTreeView32",TVS_NOTOOLTIPS | 
                    TVS_NOSCROLL | WS_GROUP | WS_TABSTOP,7,22,233,103,

					TVS_NOSCROLL  prevents item to be shown
					
					*/
}


HTREEITEM VTreeView::AddItem(HTREEITEM hParent,HTREEITEM hInsertAfter, VString sText, void* lpData)
{
	TVINSERTSTRUCT istruct;
    memset(&istruct,0,sizeof(istruct));
	
	

	//TVITEM &iItem = istruct.item;
    //memset(&iItem,0,sizeof(iItem));
	//iItem.mask = TVIF_STATE | TVIF_TEXT | TVIF_PARAM;
	istruct.itemex.mask = TVIF_TEXT | TVIF_PARAM;
	istruct.itemex.state = 0;

	LPTreeItem Data = new TreeItem;
	Data->pParent = this;
	Data->sText = sText;
	Data->pData = lpData;

	istruct.itemex.lParam = (LPARAM)Data;
	//iItem.lParam = 0;
	
	istruct.item.pszText = LPSTR_TEXTCALLBACK;
	//istruct.item.pszText = "123";
	//istruct.itemex.pszText =  (LPTSTR)sText.c_str();
	//istruct.itemex.cchTextMax = _VLen(sText);
	/*iItem.pszText = new char[_VLen(sText)+1];
	memset(iItem.pszText,0,_VLen(sText)+1);
	
	strncpy(iItem.pszText,sText,_VLen(sText));*/
	//iItem.cchTextMax = 50000 ;
	//iItem.cchTextMax = 3;


	istruct.hParent = hParent;
	istruct.hInsertAfter = hInsertAfter;
	//istruct.item = iItem;




	HTREEITEM res = TreeView_InsertItem(m_hTreeView,&istruct);
	int err = GetLastError();
	return res;
}

void  VTreeView::SetTVProperty(LONG style)
{
	LONG oldstyle = GetWindowLong(m_hTreeView, GWL_STYLE);
	SetWindowLong(m_hTreeView, GWL_STYLE, oldstyle | style);
}


void VTreeView::SetTVPropertyOff(LONG style)
{
	LONG oldstyle = GetWindowLong(m_hTreeView, GWL_STYLE);
	SetWindowLong(m_hTreeView, GWL_STYLE, oldstyle ^ style);
}
long VTreeView::GetTVProperty(int style /*= 0*/)
{
	LONG oldstyle = GetWindowLong(m_hTreeView, GWL_STYLE);
	if (style != 0)
	{
		if ((oldstyle & style) == style)
			return true;
		else
			return false;
	}
	return oldstyle;
}



bool VTreeView::OnNotifyMessage(HWND hWnd, int IdFrom, NMHDR* pnmhdr)
{
	return this->OnNotifyMessage(WM_NOTIFY,(WPARAM)IdFrom,(LPARAM)pnmhdr);
}

bool VTreeView::DeleteItem(HTREEITEM hitem)
{
	if (hitem != NULL)
	{
		bool b = (bool)TreeView_DeleteItem(this->m_hTreeView,hitem);
		int i = GetLastError();
		return b;
	}
	else
		return false;
}


LPTreeItem VTreeView::GetTreeItemData(HTREEITEM item)
{
	if (item != NULL)
	{
		TVITEM tvItem;
		memset(&tvItem,0,sizeof(tvItem));
		tvItem.hItem = item;
		tvItem.mask = TVIF_PARAM;
		if (TreeView_GetItem(this->m_hTreeView,&tvItem) != FALSE)
			return (LPTreeItem)tvItem.lParam;
	}
	return NULL;
}

bool VTreeView::OnNotifyMessage(UINT message, WPARAM wParam, LPARAM lParam)
{
    if ((message == WM_NOTIFY) && (m_hTreeView != NULL) && (lParam != 0) && (wParam == GetDlgCtrlID(m_hTreeView)))
    {
        switch (((LPNMHDR)lParam)->code)
			{
				case TVN_GETDISPINFO :
					{
						LPNMTVDISPINFO Info = (LPNMTVDISPINFO)lParam;
						if (Info && (Info->item.mask & TVIF_TEXT))
						{
							LPTreeItem Item = (LPTreeItem)Info->item.lParam;
							if (Item != NULL)
								Info->item.pszText = Item->sText.c_str();
							else
								Info->item.pszText = "Error: GetTreeItemData returned NULL\0";
							Info->item.cchTextMax = strlen(Info->item.pszText);
						}
						return true;
					}	
				case TVN_DELETEITEM:
					{
						 LPNMTREEVIEW Item = (LPNMTREEVIEW) lParam;
						 LPTreeItem ItemData = GetTreeItemData(Item->itemOld.hItem);
						 if (ItemData != NULL)
						 {
							 if (p_OnDestroyItem)
								 p_OnDestroyItem(this,Item->itemOld.hItem,&ItemData->pData);
			 
							//delete ItemData;
							Item->itemOld.lParam = NULL;
						 }
						 return true;
					}
				case TVN_SELCHANGED: 
					{
						NMTREEVIEW* pnmtv = (NMTREEVIEW*)lParam;
						
						if (p_OnSelChanged != NULL)
							return p_OnSelChanged(this,((LPNMHDR)lParam)->code,pnmtv);

	/*TREEMESSAGE_TVN_GETINFOTIP p_OnGetInfoTip;

						if (pnmtv->action == TVC_BYKEYBOARD)
							MessageBox(0,"keyb","test",MB_OK);
						else
							MessageBox(0,"maus","test",MB_OK);
*/
						return false;
					}
				case TVN_GETINFOTIP:
					{
						if (p_OnGetInfoTip != NULL)
							return p_OnGetInfoTip(this,((LPNMHDR)lParam)->code,(LPNMTVGETINFOTIP)lParam);
						break;
					}
				default :
					{
						if (p_OnDefault)
							p_OnDefault(this,((LPNMHDR)lParam)->code,(LPVOID)lParam);
				}

			}
    }
    return false;
}

UINT VTreeView::GetItemState(HTREEITEM hItem,UINT stateMask)
{
   return TreeView_GetItemState(this->m_hTreeView,hItem,stateMask);
}

UINT VTreeView::SetItemState(HTREEITEM hItem,UINT state,UINT stateMask)
{
  
    TreeView_SetItemState(this->m_hTreeView,hItem,state, stateMask);
    return 0;
}

bool VTreeView::IsChecked(HTREEITEM AItem)
{
    UINT OldState = GetItemState(AItem, TVIS_STATEIMAGEMASK);
    return !((OldState  >> 12) & 1);
}

void VTreeView::CheckItem(HTREEITEM AItem, bool CheckState)
{

    if (AItem!=NULL)
	{
		// ... calculate the new state, use a bitmask
		UINT OldState = GetItemState(AItem, TVIS_STATEIMAGEMASK);
		//if ((OldState >> 12) & 1)
        if (CheckState)
			SetItemState(AItem,INDEXTOSTATEIMAGEMASK (2), TVIS_STATEIMAGEMASK);
		else
			SetItemState(AItem,INDEXTOSTATEIMAGEMASK (1), TVIS_STATEIMAGEMASK);
	}
}

HTREEITEM VTreeView::GetRootParent(HTREEITEM AItem)
{
    HTREEITEM Parent = TreeView_GetParent(this->m_hTreeView,AItem);
    HTREEITEM oldParent = AItem;
    while (Parent != NULL)
    {
        oldParent = Parent;
        Parent = TreeView_GetParent(this->m_hTreeView,Parent);
    }

    return oldParent;
}
#include ".\vtabcontrol.h"

VTabControl::VTabControl(void)
{
}

VTabControl::~VTabControl(void)
{
}

void VTabControl::Init(HWND hTabCtrl, HWND hDialog,HINSTANCE hInstance)
{
	m_hTabCtrl = hTabCtrl;
	m_hDialog = hDialog;
	m_hInstance = hInstance;
//	memset(&m_rect,0,sizeof(RECT));
}

int VTabControl::AddTab(int iIdx, const LPTSTR Text,VDlgHandler *Handler,WORD wTemplate,HINSTANCE hExtraInstance)
{
	TC_ITEM item;

	item.mask = TCIF_TEXT;
	item.iImage = -1;
	item.pszText = Text;
	return AddTab(iIdx,&item,Handler,wTemplate,hExtraInstance);
}

int VTabControl::AddTab(int iIdx, const LPTCITEM pitem, VDlgHandler *Handler,WORD wTemplate,HINSTANCE hExtraInstance)
{
	if (hExtraInstance == 0)
		hExtraInstance = m_hInstance;

	VDialog *Dlg = new VDialog();
	Dlg->Create(hExtraInstance,wTemplate, /*m_hDialog*/m_hTabCtrl, Handler);
	m_TabSheets.push_back (Dlg);

		/*Brings dialog to maximum tab rect
		*/
		RECT m_rect;
		GetClientRect(m_hTabCtrl,&m_rect);
		TabCtrl_AdjustRect(m_hTabCtrl,FALSE,&m_rect);
		MoveWindow(Dlg->m_hWnd,m_rect.left,m_rect.top,(m_rect.right-m_rect.left),m_rect.bottom-m_rect.top,TRUE);	


	int res = TabCtrl_InsertItem(m_hTabCtrl,iIdx,pitem);

	return res;
}

bool VTabControl::ShowTab(int iIdx, bool show)
{
	/*NMHDR p;
	p.hwndFrom = m_hTabCtrl;
    p.idFrom = GetDlgCtrlID(m_hTabCtrl);
    p.code = TCN_SELCHANGE;
	return SendMessage(m_hDialog,WM_NOTIFY,0,(LPARAM)&p);*/
	if (m_TabSheets[iIdx] == NULL) return false;
	VDialog *Tab = (VDialog*)m_TabSheets[iIdx];
	
	EnableWindow(Tab->m_hWnd,show!=0);
	if (show)
	{
				/*Brings dialog to maximum tab rect
		*/
		RECT m_rect;
		GetClientRect(m_hTabCtrl,&m_rect);
		TabCtrl_AdjustRect(m_hTabCtrl,FALSE,&m_rect);
		MoveWindow(Tab->m_hWnd,m_rect.left,m_rect.top,(m_rect.right-m_rect.left),m_rect.bottom-m_rect.top,TRUE);	


		ShowWindow(Tab->m_hWnd,SW_SHOW);
	}
	else
		ShowWindow(Tab->m_hWnd,SW_HIDE);
	return true;
}
void VTabControl::SelectTab(int iIdx)
{
	SetTabIndex(iIdx);
}

RECT VTabControl::GetTabArea()
{
	RECT m_rect;
	GetClientRect(m_hTabCtrl,&m_rect);
	TabCtrl_AdjustRect(m_hTabCtrl,FALSE,&m_rect);
	return m_rect;
}

VDialog *VTabControl::GetDialog(int iIdx) 
{
	if (IsValidIndex(iIdx))
		return (VDialog*)m_TabSheets[iIdx];
	else 
		return NULL;
}

int VTabControl::GetTabIndex()
{
	return TabCtrl_GetCurSel(m_hTabCtrl);
}

bool VTabControl::IsValidIndex(int iIdx)
{
	if (m_TabSheets.size() == 0) return false;

	return (iIdx >= 0 && iIdx < m_TabSheets.size()) ;
}

int VTabControl::SetTabIndex(int iIdx)
{
	if (!IsValidIndex(iIdx))
		return -1;
	ShowTab(GetTabIndex(),false);
	ShowTab(iIdx,true);
	return TabCtrl_SetCurSel(m_hTabCtrl,iIdx);
}


int VTabControl::Clear()
{
	int c = m_TabSheets.size();
	for (int i=0; i < c; i++)
	{
		try
		{
			VDialog *p = (VDialog*)m_TabSheets.at(i);
			p->Destroy();
			delete p;
		}
		catch(...)
		{
		}

	}
	m_TabSheets.clear();
	TabCtrl_DeleteAllItems(m_hTabCtrl);
	return c;
}

BOOL VTabControl::OnDefaultMessage(UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		case WM_NOTIFY :
		{
            if (wParam != GetDlgCtrlID(m_hTabCtrl))
                return FALSE;

			//auf tabctrl nachrichten reagieren
			NMHDR FAR *tem=(NMHDR FAR *)lParam;
			HWND htab = m_hTabCtrl;

			int num=TabCtrl_GetCurSel(tem->hwndFrom);
			if (m_TabSheets[num] == NULL) break;
			//VDialog *Tab = (VDialog*)m_TabSheets[num];
			
			switch (tem->code)
			{
				case TCN_SELCHANGING : 
				{
					ShowTab(num,false);
					return TRUE;
				}
				case TCN_SELCHANGE :
				{
					ShowTab(num,true);
					return TRUE;
				}
			}
		}
	}
	return FALSE;
}
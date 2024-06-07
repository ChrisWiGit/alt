#include "vdialog.h"
#include "commctrl.h"


namespace vtools
{

/*VDlgHandler * VDialog::m_Handler = 0;
HWND  VDialog::m_hWnd = 0;*/
DIALOGLIST VDialog::m_DialogList;	

VDialog::VDialog(HINSTANCE MainApp,const LPCTSTR lpTemplate,  HWND hWndParent,VDlgHandler *Handler)
{
	ASSERT0(false,"not implemented");
	//m_MainApp = MainApp;
   // m_lpTemplate = lpTemplate;
    //m_hWndParent = hWndParent;
}
VDialog::VDialog(HINSTANCE MainApp, WORD lpTemplate,  HWND hWndParent,VDlgHandler *Handler, CMDPROC proc /*= NULL*/)
{
	Init(MainApp,lpTemplate,hWndParent,Handler,proc);
}
void VDialog::Init(HINSTANCE MainApp, WORD lpTemplate,  HWND hWndParent,VDlgHandler *Handler, CMDPROC proc /*= NULL*/)
{
	ASSERT0((Handler != NULL),"DialogProc: Handler must not be NULL");
	
	m_MainApp = MainApp;
	m_proc = proc;
	
	m_lpTemplate = lpTemplate;
    m_hWndParent = hWndParent;
	//m_hWndParent = 0;

	m_Handler = Handler;
	m_Handler->m_hDialog = this;

	m_CenterWindow = false;

	m_hWnd = 0;


}

HWND VDialog::Create(HINSTANCE hInstance,WORD lpTemplate, HWND hWndParent,VDlgHandler *Handler)
{
	HWND res = ::CreateDialog(hInstance,MAKEINTRESOURCE(lpTemplate),hWndParent,(DLGPROC)&DialogProc);
	Init(hInstance,lpTemplate,hWndParent,Handler,0);
	//InitDialog aufgerufen?
	
	SendMessage(res,WM_INITDIALOG,0,(LPARAM)this);
	return res;
}

VDialog::~VDialog(void)
{
	this->m_Handler = NULL;
	this->m_hWnd = 0;
}



BOOL CALLBACK VDialog::DialogProc(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam)
{
    VDialog *_this = NULL;
    

    if (message != WM_INITDIALOG && message != WM_SETFONT) //SETFONT will be thrown before WM_INITDIALOG
        _this = m_DialogList[hwnd];
    
	if ((_this != NULL)&&(_this->m_Handler->OnAllMessage(message,wParam,lParam)))
		return TRUE;

	/*
	Important : 
	  this must not be null!

	  return false if no instance exists
	  */
    if ((message != WM_INITDIALOG)&&(_this == NULL)) 
		return false;
	else

    switch (message)
    {
	 case WM_INITDIALOG: 
		 {			
			if (lParam == 0) break;
			
			m_DialogList[hwnd] = (VDialog*)lParam;
			_this = m_DialogList[hwnd];

			_this->m_hWnd = hwnd;

			//long sy = GetWindowLong(hwnd,GWL_STYLE);
		//	SetWindowLong(hwnd, GWL_STYLE, DS_CENTER);
			
			return _this->m_Handler->OnInitDialog(hwnd,message,wParam,lParam);
		 }

	 case WM_SHOWWINDOW :
		 {
			/*	if (_this->m_CenterWindow)
				{
					_this->CenterWindow();
					_this->m_CenterWindow = false;
				}*/

			 //return false;
			 if ((bool)wParam == TRUE)
				_this->m_Handler->OnShow(lParam,!_this->m_Handler->AlreadyShown());
			 else
				_this->m_Handler->OnHide(lParam);


			 break;
		 }
	
   	 case WM_SYSCOMMAND :
		 {
			 
		 return _this->m_Handler->OnSysCommand(message,wParam,lParam);
		 }
	 case WM_COMMAND :
		 return _this->m_Handler->OnCommand(message,wParam,lParam);

    case WM_CLOSE:
	{
		if (_this->m_Handler->OnCloseQuery(message,wParam,lParam) == false) 
			/*do not change return value!
		  otherwise dialog will not be destroyed!
		*/
			return true;

		/*do not change return value!
		  otherwise dialog will not be destroyed!
		*/
		_this->m_Handler->OnClose(message,wParam,lParam);
	    return true;

	
		
	}

	 case WM_DESTROY:
		 {
			if (_this->m_Handler->OnDestroyDialog(message,wParam,lParam) == TRUE);
			
            //remove handle from map if exists
            if (m_DialogList.find(hwnd) != m_DialogList.end())
             if (m_DialogList.erase(hwnd) > 1)
                    ASSERT0(false,"Dialog list erased more than one window handle.");
    
			_this->m_hWnd = 0;
			return true;
		 }
	 case WM_NOTIFY:
		 {
			 //virtual BOOL HandleTheNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr);
			 /*if (&_this->m_Handler->OnNotify)
				return HANDLE_WM_NOTIFY(hwnd,wParam,lParam,_this->m_Handler->OnNotify);
			 else
				return false;*/

			 if (_this->m_Handler)
				_this->m_Handler->OnNotify(_this->m_hWnd,wParam,(NMHDR*)lParam);
			 return true;

		 }
	 default :
         if (_this != NULL)
		    return _this->m_Handler->OnDefaultMessage(message,wParam,lParam);
	 }
	return false;
}

int VDialog::Run(BOOL Modal /*= false*/)
{
	ASSERT(m_MainApp);

	//if (Modal && (m_hWndParent != NULL))
	//	EnableWindow(m_hWndParent,false);

   //MAMS
	int res;
	
	if (Modal == FALSE)
	{
		res = -1;
		
		this->m_hWnd = CreateDialogParam(this->m_MainApp,MAKEINTRESOURCE(m_lpTemplate)
						 ,m_hWndParent,(DLGPROC)(this->DialogProc), (LPARAM)this);
		ShowWindow(this->m_hWnd,SW_SHOWNORMAL);

		/*
		
		RECT lpRect;
		memset(&lpRect,0,sizeof(RECT));
		GetWindowRect(this->m_hWnd,&lpRect);

		lpRects has invalid position data

		if (this->m_CenterWindow)
			{
				this->CenterWindow();
				this->m_CenterWindow = false;
			}
*/


		int i =  GetLastError();
		ASSERT1(i == 0,"Dialog could not be created : %d",i);
	}
	else


	res = DialogBoxParam(this->m_MainApp,MAKEINTRESOURCE(m_lpTemplate)
      					 ,m_hWndParent,(DLGPROC)(this->DialogProc), (LPARAM)this);
	
	//TRACE2("Run executed Dialogbox with return code %d and GetLastError %d",res,GetLastError());

	//if (Modal && (m_hWndParent != NULL))
	//	EnableWindow(m_hWndParent,true);
	
	return res;
}

BOOL VDialog::Execute(void)
{
	int ires = Run(true);
	ASSERTN((ires < 0));
	return (ires == IDOK) ?  true : false;
}

BOOL VDialog::EndDialog(int retvalue, int lParam /*= 0*/)
{
	if (m_hWnd == 0) return false;
	return (SendMessage(m_hWnd,WM_CLOSE,retvalue,lParam) == 0);

	
	//return ::EndDialog(m_hWnd,retvalue);
	//else return false;
}
void VDialog::Destroy()
{
	try
	{
	::DestroyWindow(m_hWnd); 
	}
	catch (...)
	{
	}
	m_hWnd = 0;
}

/*
void VDialog::CenterWindow()
{
    ASSERT0(m_hWnd,"VDialog::CenterWindow : Invalid Window Handle - Is Dialog already constructed? (Execute,Run)");
    RECT lpRect;
	memset(&lpRect,0,sizeof(RECT));
	GetWindowRect(m_hWnd,&lpRect);
	lpRect.left = (GetSystemMetrics(SM_CXSCREEN) / 2) - (lpRect.right / 2);
	lpRect.top = (GetSystemMetrics(SM_CYSCREEN) / 2) - (lpRect.bottom / 2);
    //::MoveWindow(m_hWnd,lpRect.left,lpRect.top,lpRect.right,lpRect.bottom,FALSE);
	::SetWindowPos(m_hWnd,0,lpRect.left,lpRect.top,0,0,SWP_NOSIZE);
}
*/

void VDialog::CenterWindow(Center_Type aCenter /*= ct_screen*/)
{
        RECT rc, rcDlg,rcOwner;
        HWND hwndDlg = this->m_hWnd;

        //if ((hwndOwner = GetParent(hwndDlg)) == NULL) 
        HWND hwndOwner = 0;

        if (aCenter == ct_desktop)
        {
            //hwndOwner = GetDesktopWindow(); 
            SystemParametersInfo(SPI_GETWORKAREA,0,(void*)&rcOwner,0);
        }
        else
        if (aCenter == ct_screen)
        {
            rcOwner.left = 0;
            rcOwner.right = GetSystemMetrics(SM_CXSCREEN);
            rcOwner.top = 0;
            rcOwner.bottom = GetSystemMetrics(SM_CYSCREEN);
        }
        else
           hwndOwner = GetParent(hwndDlg);

        if (hwndOwner != 0)
            GetWindowRect(hwndOwner, &rcOwner); 

        GetWindowRect(hwndDlg, &rcDlg); 
        CopyRect(&rc, &rcOwner); 
 
         // Offset the owner and dialog box rectangles so that 
         // right and bottom values represent the width and 
         // height, and then offset the owner again to discard 
         // space taken up by the dialog box. 
 
        OffsetRect(&rcDlg, -rcDlg.left, -rcDlg.top); 
        OffsetRect(&rc, -rc.left, -rc.top); 
        OffsetRect(&rc, -rcDlg.right, -rcDlg.bottom); 
 
         // The new position is the sum of half the remaining 
         // space and the owner's original position. 
 
        SetWindowPos(hwndDlg, 
            HWND_TOP, 
            rcOwner.left + (rc.right / 2), 
            rcOwner.top + (rc.bottom / 2), 
            0, 0,          // ignores size arguments 
            SWP_NOSIZE); 

}

VString VDialog::GetEditText(int DlgItem)
{
    
	return vtools::GetEditText(this->m_hWnd,DlgItem);
}
void VDialog::SetEditText(int DlgItem,const VString Text)
{
    SetDlgItemText(m_hWnd,DlgItem,Text);
}
void VDialog::EnableWindow(int DlgItem, bool bEnable)
{
	HWND hWnd = m_hWnd;
	if (DlgItem != 0)
		hWnd = GetDlgItem(m_hWnd,DlgItem);
	::EnableWindow(hWnd,bEnable);
}

bool VDialog::IsWindowEnabled(int DlgItem)
{
	HWND hWnd = m_hWnd;
	if (DlgItem != 0)
		hWnd = GetDlgItem(m_hWnd,DlgItem);
	return ::IsWindowEnabled(hWnd) != 0;
}

void VDialog::TopMost(bool Top) 
{
	if (Top)
       SetWindowPos(this->m_hWnd,HWND_TOPMOST,0,0,0,0,SWP_SHOWWINDOW | SWP_NOSIZE | SWP_NOMOVE );
	else
  	   SetWindowPos(this->m_hWnd,HWND_NOTOPMOST,0,0,0,0,SWP_SHOWWINDOW | SWP_NOSIZE | SWP_NOMOVE);	
}
bool VDialog::IsTopMost() 
{
	return ((GetWindowLong(this->m_hWnd,GWL_EXSTYLE) &  WS_EX_TOPMOST) ==  WS_EX_TOPMOST);
}
bool VDialog::FlipTopMost() 
{
	TopMost(!IsTopMost()); 
	return IsTopMost();
}
	

bool VDialog::IsWindowVisible(int DlgItem)
{
	if (this->m_hWnd == 0)
		return false;

	HWND hWnd = m_hWnd;
	if (DlgItem != 0)
	{
		hWnd = GetDlgItem(m_hWnd,DlgItem);
		return ::IsWindowVisible(hWnd) != 0;
	}
	else
		return ::IsWindowVisible(this->m_hWnd) != 0;
}

VDialog *VDialog::GetVDialogByHandle(HWND hwnd)
{
	if (m_DialogList.find(hwnd) != m_DialogList.end())
        return m_DialogList[hwnd];
	else
		return NULL;
}


/*

Dialog Handler Class


*/

VDlgHandler::VDlgHandler(void)
{
	wasShown = false;
	m_pTabControlHandler = NULL;
}


BOOL VDlgHandler::OnCommand(UINT message, WPARAM wParam, LPARAM lParam) 
{
	switch (LOWORD(wParam))
	{
	case IDOK :
	case IDCANCEL : m_hDialog->EndDialog(LOWORD(wParam)); break;
	default : return false;
	}
	return true;
}
int VDlgHandler::OnClose(UINT message, WPARAM wParam, LPARAM lParam) 
{
	int ires = LOWORD(wParam);

/*	if ((ires < 0) && (lParam != 0))
			ires = wParam;
		else if (lParam == 0)
			ires = IDOK;*/
	
	::EndDialog (m_hDialog->m_hWnd,ires);
	return ires;
};

/*BOOL VDlgHandler::OnNotify(HWND hWnd, int IdFrom, NMHDR* pnmhdr)
{
	return FALSE;
}*/

BOOL VDlgHandler::OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam) 
{
	//m_hDialog->SetHWnd(hwnd);		
	return true;
}


VDialog *GetVDialogByHandle(HWND hwnd)
{
	return VDialog::GetVDialogByHandle(hwnd);
}



int GetEditTextLength(HWND hwnd,int DlgItem)
{
    return SendMessage(GetDlgItem(hwnd,DlgItem),WM_GETTEXTLENGTH ,0,0);	
}


VString GetEditText(HWND hwnd,int DlgItem)
{
	int len = GetEditTextLength(hwnd,DlgItem)+1;
	char *Buffer = new char[len];
    
	if (GetDlgItemText(hwnd,DlgItem,Buffer,len) == 0)
	{
        delete Buffer;
		return VString("");
	}
    VString s(Buffer);
	delete Buffer;
	return s;
}

void SetEditText(HWND hwnd,int DlgItem,const VString Text)
{
    SetDlgItemText(hwnd,DlgItem,Text);
}



};


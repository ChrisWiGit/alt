/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

//#undef VDIALOG_H
#include "vdialog.h"

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

	m_Handler = Handler;
	m_Handler->m_hDialog = this;
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
}


BOOL CALLBACK VDialog::DialogProc(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam)
{
    VDialog *_this = NULL;
    

    if (message != WM_INITDIALOG && message != WM_SETFONT) //SETFONT will be thrown before WM_INITDIALOG
        _this = m_DialogList[hwnd];
    
    switch (message)
    {
	 case WM_INITDIALOG: 
		 {			
			if (lParam == 0) break;
									
			m_DialogList[hwnd] = (VDialog*)lParam;
			_this = m_DialogList[hwnd];

			_this->m_hWnd = hwnd;

			//ASSERT(_this == NULL || _this->m_Handler == NULL);
			return _this->m_Handler->OnInitDialog(hwnd,message,wParam,lParam);
		 }
	/* case WM_SHOW :
		 {
			if (_this->m_CenterWindow)
			{
				_this->CenterWindow();
				_this->m_CenterWindow = false;
			}
			return false;
		 }*/
   	 case WM_SYSCOMMAND :
		 {
		 return _this->m_Handler->OnSysCommand(message,wParam,lParam);
		 }
	 case WM_COMMAND :
		 return _this->m_Handler->OnCommand(message,wParam,lParam);

    case WM_CLOSE:
	{
		if (_this->m_Handler->OnCloseQuery(message,wParam,lParam) == false) return true;
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

   
	int res = 0;
	/*if (Modal == FALSE)
	{
		res = -1;
		CreateDialogParam(this->m_MainApp,MAKEINTRESOURCE(m_lpTemplate)
      		,m_hWndParent,(DLGPROC)(this->DialogProc), (LPARAM)this);
		ShowWindow(this->m_hWnd,SW_SHOW);

		int i =  GetLastError();
		ASSERT0(i == 0,"Dialog could not be created");
	}
	else*/
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

BOOL VDialog::EndDialog(int retvalue)
{
	if (m_hWnd == 0) return false;


	return (SendMessage(m_hWnd,WM_CLOSE,retvalue,1) == 0);

	
	//return ::EndDialog(m_hWnd,retvalue);
	//else return false;
}

void VDialog::CenterWindow()
{
/*	if (m_hWnd == 0)
	{
		//window will be centered next time it is displayed!
		//see Run()
		m_CenterWindow = true;
		return;
	}*/
    ASSERT0(m_hWnd,"VDialog::CenterWindow : Invalid Window Handle - Is Dialog already constructed? (Execute,Run)");
    RECT lpRect;
	GetWindowRect(m_hWnd,&lpRect);
	lpRect.left = (GetSystemMetrics(SM_CXSCREEN) / 2) - (lpRect.right / 2);
	lpRect.top = (GetSystemMetrics(SM_CYSCREEN) / 2) - (lpRect.bottom / 2);
    ::MoveWindow(m_hWnd,lpRect.left,lpRect.top,lpRect.right,lpRect.bottom,FALSE);
}

VString VDialog::GetEditText(int DlgItem)
{
    char Buffer[255];
    if (GetDlgItemText(m_hWnd,DlgItem,Buffer,sizeof(Buffer)) == 0)
        return VString("");
    return VString(Buffer);
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

/*

Dialog Handler Class


*/

VDlgHandler::VDlgHandler(void)
{}


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
	int ires = 0;

/*	if ((ires < 0) && (lParam != 0))
			ires = wParam;
		else if (lParam == 0)
			ires = IDOK;*/
	
	::EndDialog (m_hDialog->m_hWnd,ires);
	return ires;
};

BOOL VDlgHandler::OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam) 
{
	//m_hDialog->SetHWnd(hwnd);		
	return true;
}




};


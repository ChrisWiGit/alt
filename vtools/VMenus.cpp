#include ".\vmenus.h"


static UINT GlobalIdents = 1052000;

VSysTrayMenu::VSysTrayMenu(HWND hWnd,HINSTANCE hInstance)
{
	Init(hWnd,hInstance);
}

VSysTrayMenu::~VSysTrayMenu(void)
{
	Visible(false);
}

void VSysTrayMenu::Init(HWND hWnd,HINSTANCE hInstance)
{
	memset(&NID,0,sizeof(NOTIFYICONDATA));
	NID.cbSize = sizeof(NOTIFYICONDATA);
	NID.hWnd = hWnd;
	NID.uID = (++GlobalIdents);

	this->hInstance = hInstance;
	bVisible = false;
}

bool VSysTrayMenu::Visible(bool bVisible)
{
	bool ret = false;
	if (bVisible && !this->bVisible)
		ret = Shell_NotifyIcon(NIM_ADD,&NID)!=0;
	else
	if (!bVisible && this->bVisible)
		ret = Shell_NotifyIcon(NIM_DELETE,&NID)!=0;
	
	this->bVisible = bVisible;

	return ret;
}
bool VSysTrayMenu::Visible()
{
	return bVisible;
}

bool VSysTrayMenu::Icon(HICON hIcon)
{
	NID.hIcon = hIcon;
	NID.uFlags = NID.uFlags && NIF_ICON;
	if (bVisible)
		return Shell_NotifyIcon(NIM_MODIFY,&NID)!=0;
	return true;
}
bool VSysTrayMenu::Icon(LPCTSTR lpIconName)
{
	HICON hIcon = LoadIcon(hInstance,lpIconName);
	if (hIcon == NULL) return false;

	NID.uFlags = NID.uFlags | NIF_ICON;
	NID.hIcon = hIcon;
	if (bVisible)
		return Shell_NotifyIcon(NIM_MODIFY,&NID)!=0;
	return true;
}

HICON VSysTrayMenu::Icon()
{
	return NID.hIcon;
}

bool VSysTrayMenu::Flags(UINT Flags)
{
	NID.uFlags = Flags;
	if (bVisible)
		return Shell_NotifyIcon(NIM_MODIFY,&NID)!=0;
	return true;
}

bool VSysTrayMenu::Flags(bool ICON,bool MESSAGE,bool TIP,bool STATE,bool INFO)
{
	UINT Flags = 0;
	if (ICON)
		Flags = Flags | NIF_ICON;
	if (MESSAGE)
		Flags = Flags | NIF_MESSAGE;
	if (TIP)
		Flags = Flags | NIF_TIP;
/*
#if (_WIN32_IE > 0x0500)
	if (STATE)
		Flags = Flags | NIF_STATE;
	if (INFO)
		Flags = Flags | NIF_INFO;
#endif*/

	NID.uFlags = Flags;
	if (bVisible)
		return Shell_NotifyIcon(NIM_MODIFY,&NID)!=0;
	return true;
}

bool VSysTrayMenu::CallBackMessage(UINT uCallBackMsg)
{
	NID.uFlags = NID.uFlags | NIF_MESSAGE;
	NID.uCallbackMessage = uCallBackMsg;

	if (bVisible)
		return Shell_NotifyIcon(NIM_MODIFY,&NID)!=0;
	return true;
}

bool VSysTrayMenu::TipString(const char *Tip)
{
	strcpy(NID.szTip,Tip);

	NID.uFlags = NID.uFlags | NIF_TIP;

	if (bVisible)
		return Shell_NotifyIcon(NIM_MODIFY,&NID)!=0;
	return true;
}
	

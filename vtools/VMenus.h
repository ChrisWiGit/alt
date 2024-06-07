#pragma once

#ifndef VMENUS_H
#define VMENUS_H

//Uses extended Explorer Flags

/*#if (_WIN32_IE <= 0x0500)
#define _WIN32_IE 0x0560
#endif*/

#include "windows.h"
#include "shellapi.h"



//#if (_WIN32_IE >= 0x0500)
//enum NotifyFlags {NF_ICON=NIF_ICON,NF_MESSAGE=NIF_MESSAGE,NF_TIP=NIF_TIP,NF_STATE=NIF_STATE,NF_INFO=NIF_INFO};
//#else
//#pragma message ("Warning: using NF_STATE and NF_INFO can have unpredictable consequences due to no support")
enum NotifyFlags {NF_ICON=NIF_ICON,NF_MESSAGE=NIF_MESSAGE,NF_TIP=NIF_TIP,NF_STATE=0x00000008,NF_INFO=0x00000010};
//#endif

class VSysTrayMenu
{
	//main tray data
	NOTIFYICONDATA NID;
	
	//
	HINSTANCE hInstance;

	//intern class data
	bool bVisible;
public:
	VSysTrayMenu(HWND hWnd,HINSTANCE hInstance);
	VSysTrayMenu() {};
	~VSysTrayMenu(void);

	void Init(HWND hWnd,HINSTANCE hInstance);
	//UINT uCallBackMsg

	UINT Flags() {return NID.uFlags;};
	bool Flags(NotifyFlags Flags) {return (NID.uFlags | Flags) == Flags; };
	bool Flags(UINT Flags);
	bool Flags(bool ICON,bool MESSAGE,bool TIP,bool STATE,bool INFO);

	bool Visible(bool bVisible);
	bool Visible();

	bool CallBackMessage(UINT uCallBackMsg);
	UINT CallBackMessage() {return NID.uCallbackMessage;};

	bool TipString(const char *Tip);
	char *TipString();


	bool Icon(HICON hIcon);
	bool Icon(LPCTSTR lpIconName);
	HICON Icon();

	
};

#endif
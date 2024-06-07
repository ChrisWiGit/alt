// RunAsGUI.cpp : Definiert den Einstiegspunkt f�r die Anwendung.
//
/*
RunAs by Christian Wimmer 2005
OpenSource
No warranty at all!

known restriction:
none

hints:
+ to execute cpl - files use "control <cplfile>.cpl" otherwise an error "Cannot execute corrupt file" occur
+ "mmc %windir%\System32\compmgmt.msc"
+ to execute multiple instances of regedit call "regedit -m"
+ you must check "every explorer has its own process" to execute an admin explorer

Call for non-admins:


*/

#include "stdafx.h"
#include "RunAsGUI.h"
#include "VConsole.h"
#include "vstrList.h"

/*
#define WinXP 
Uses attachconsole that is only available under XP and 2003 Server
It directly attaches to an opened console and writes an output to it.
Does not work under Windows 2000 - instead we use a messagebox.
*/
#define WinXP


#define MAX_LOADSTRING 100

// Globale Variablen:
HINSTANCE hInst;								// Aktuelle Instanz

int iGlobalReturn = 0;

const	int RET_SUCCESS		  = 0;
		int RET_ABORT_BY_USER = -1;
		int RET_ERROR_CMDLINE = -2;
		int RET_PARAMETER_ERROR = -3;


VString sCommandLine;
bool bCommandLine = true;

VString sParameter;
bool bParameter = true;

VString sUserName;
bool bUserName = true;
VString sPassword;
bool bPassword = true;

bool bDontClose = false;
bool bDisableDontClose = false;
bool bShowError = true;

//miscenalleous
int iSelection = -1;
///env - uses Log on, then load the user profile in the HKEY_USERS registry key. 
bool bLocalLogOn = true;
bool bDisableLocalLogOn = false;


//OpenDialog Initial Dir in workplace
WCHAR sInitialDir[] = TEXT("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\0");

//Standard error MessageBox caption
WCHAR ErrorString[100] = TEXT("Error");

/*
This help cannot be read from a string resource by now.
LoadString only returns 734 chars 
So I decided to harcode it.

http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/resources/strings/stringreference/stringfunctions/loadstring.asp
*/
const int MAX_HELPSTRING = 15;
const VString sHelpString[MAX_HELPSTRING] =

{("\r\nSyntax von runAsGUI \r\n"),
("runasGUI [/e] [/!c] [/!q] [/!p] [/!u] [/password:<Passwort>] [/user:<Benutzer>] [/parameter:('<Parameter>')] <Programm>"),
		("\r\n\r\n"),

		("/q\tDer Dialog wird nach dem Programmstart nicht geschlossen\r\n"),
		("/e\tFehler werden nicht im Dialog dargestellt.\r\n\tEs wird nur ein R�ckgabewert geliefert.\r\n\tDie Fehlermeldung wird trotdem angezeigt, wenn der Parameter /e angegeben wurde!\r\n"),
		("\r\n"),
		("Parameter mit einem Ausrufezeichen, deaktivieren im Dialog das jeweilige Eingabefeld\r\n"),
		
		("/!c\t Die Kommandozeile Eingabe wird deaktiviert (mit Browse-Button)\r\n"),
		("/!u\t Die Benutzer Eingabe wird deaktiviert\r\n"),
		("/!p\t Die Passwort Eingabe wird deaktiviert\r\n"),
		("/!q\t Die M�glichkeit das Feld \"Dialogfeld schlie�en nach Start\" wird gesperrt\r\n"),
		("/!r\t Die Parameter Eingabe wird deaktiviert.\r\n"),

		"\r\nHinweis: Die Angabe des Passworts �ber die Kommandozeile ist ein Sicherheitsrisiko!\r\n",
		"Parameter k�nnen statt �ber den Parameter /parameter:(\"<Parameter>\") auch hinter den Programmnamen geh�ngt werden.\r\n",
		"\tAllerdings funktioniert dann der �ffnen-Dialog nicht"

	};


/*
Zeros a VString in memory to avoid reading
*/
void ZeroString(VString &Str)
{
	int Len = Str.GetLength();

	for (int i=0;i<Len;i++)
	{
		Str.SetAt(i,'0');
	}	
	Str = "";
}

/*
Gets the amount of neccessary chars to convert a VString to a UNICODE string
*/
int VString2WCharLen(VString Str)
{
	return MultiByteToWideChar(CP_ACP,0,_VSTR(Str),Str.GetLength(),NULL,0);
}

/*
converts a VString to a UNICODE string
*/
TCHAR *VString2WChar(VString Str)
{
	int widelen = VString2WCharLen(Str); 
		
	if (widelen <= 0)
		return NULL;

	TCHAR *p = new TCHAR[widelen+1];
	p[widelen] = '\0';
			
		
	//http://msdn.microsoft.com/library/en-us/intl/unicode_17si.asp
	widelen = MultiByteToWideChar(CP_ACP,0,_VSTR(Str),Str.GetLength(),p,widelen);

	if (widelen <= 0)
	{
		delete[] p;
		return NULL;
	}

	return p;
}

/*
Converts a UNICODE string to a VString
*/
VString WChar2VString(WCHAR *Str)
{

	BOOL Mapped;
	//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/intl/unicode_2bj9.asp
	int widelen = WideCharToMultiByte(CP_ACP,0,Str,-1,NULL,0,NULL,NULL);

	
	int k = GetLastError();

	if (widelen <= 0)
		return VString("");


	char *mstr = new char[widelen+1];
	mstr[widelen] = '\0';

	
	widelen = WideCharToMultiByte(CP_ACP,0,Str,widelen,mstr,widelen,NULL,NULL);

	int i = GetLastError();

	if (widelen <= 0)
	{
		delete[] mstr;
		return VString("");
	}

	VString s(mstr);
	delete[] mstr;

	return s;
}

/*
Runs an application using global names
*/

bool RunApplicationWithUserName()
{
 //http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dllproc/base/createprocesswithlogonw.asp
  PROCESS_INFORMATION  pif;
  STARTUPINFOW si;

  memset(&si,0,sizeof(si));
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = 1;

  SetLastError(0);

  VString CommandLine = sCommandLine;
  if (sParameter && (sParameter.GetLength() > 0))
	  CommandLine.Format("%s \"%s\"",_VSTR(sCommandLine),_VSTR(sParameter));

  TCHAR *UserName = VString2WChar(sUserName);
  TCHAR *Password = VString2WChar(sPassword);
  TCHAR *CmdLine = VString2WChar(CommandLine);

  DWORD dwFlags = 0;
  if (bLocalLogOn)
	  dwFlags = LOGON_WITH_PROFILE;

  return CreateProcessWithLogonW(UserName,0,
	  Password,dwFlags,
	  0,CmdLine,
      CREATE_DEFAULT_ERROR_MODE, 0, 0, &si, &pif);

  int Err = GetLastError();

  delete[] UserName;
  delete[] Password;
  delete[] CmdLine;
}

/*
Copies the data from dialog controls to global variables
*/

void UpdateGlobalData(HWND hwnd)
{

	sCommandLine = GetEditText(hwnd,IDC_APPLICATION_EDIT);
	sParameter = GetEditText(hwnd,IDC_PARAMETER_EDIT);
	

	sUserName = GetEditText(hwnd,IDC_USERNAME_COMBO);

	ZeroString(sPassword);
	sPassword = GetEditText(hwnd,IDC_PASSWORD_EDIT);

	bDontClose = (IsDlgButtonChecked(hwnd,IDC_DONTCLOSE_CHECK) == BST_CHECKED);
}

/*
Shows getlasterror message box with an error string
*/
void ShowErrorBox(HWND hWnd,int ReturnValue)
{

/*
	There are some error codes that are not listed for FormatMessage
	However they are here :
	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wcesdkr/html/_sdk_error_values.asp

	I dont know how to solve this in another way.

	Not all errors are covered.
*/
	VString Msg;
	
	switch (ReturnValue)
	{
	
	case ERROR_INFLOOP_IN_RELOC_CHAIN:
	case ERROR_RELOC_CHAIN_XEEDS_SEGLIM:
	case ERROR_AUTODATASEG_EXCEEDS_64k:
	case ERROR_INVALID_SEGDPL:
	case ERROR_IOPL_NOT_ENABLED:
	case ERROR_DYNLINK_FROM_INVALID_RING:
	case ERROR_INVALID_MINALLOCSIZE:
	case ERROR_ITERATED_DATA_EXCEEDS_64k:
	case ERROR_EXE_MARKED_INVALID:
	case ERROR_INVALID_EXE_SIGNATURE:
	case ERROR_INVALID_MODULETYPE:
	case ERROR_INVALID_STACKSEG:
	case ERROR_BAD_EXE_FORMAT : 
	case ERROR_INVALID_STARTING_CODESEG: 
		{
			WCHAR pStr[1000];
			int l = LoadString(GetModuleHandle(NULL),IDS_APP_ERROR,pStr,sizeof(pStr));
			if (l != 0)
				Msg.FormatAdd(WChar2VString(pStr),ReturnValue);
			else
				Msg.FormatAdd("The operating system cannot run the application (File is maybe corrupt?).\nError code %d.\nLook error up at\nhttp://msdn.microsoft.com/library/default.asp?url=/library/en-us/wcesdkr/html/_sdk_error_values.asp",ReturnValue); 


			break;
		}

	default : 
		{
			std::string s;	
			s = GetLastErrorString(ReturnValue); //see assertions.h in vtools : returns std::string
			Msg = s._Myptr();
		}
	}

	
	if (GetLastError() == 87)
	{
		VString p;
		p.FormatAdd("Could not retrieve Error message!\n%s\n\nCould not execute statement.\n\nSorry there is nothing I can do!",_VSTR(Msg));
		Msg = p;
	}
				
	TCHAR *str = VString2WChar(Msg);

	if (!str)
	{
		if (bShowError || bDontClose)
		{
			int err = GetLastError();
	
			if (err)
			{
				WCHAR pStr[1000];
				//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/resources/strings/stringreference/stringfunctions/loadstring.asp
				int l = LoadString(GetModuleHandle(NULL),IDS_UNICODE_CONVERT_ERROR,pStr,sizeof(pStr));

				WCHAR p[1000];
				wsprintf(p,pStr,err);
				//wvnsprintf(p,sizeof(p),pStr,err);
				MessageBox(hWnd,p,ErrorString,MB_ICONERROR | MB_OK);
			}
		}
		PostQuitMessage(-1000);
		delete[] str;
		
		return;
	}

	if (bShowError || bDontClose)
		MessageBox(hWnd,str,ErrorString,MB_ICONERROR | MB_OK);

	delete[] str;
}

/*
Writes a text to the console if possible.
It attaches itself to the current console.

If SendUserLine is true, a Return KeyMessage is sent to console,
to retrieve the console prompt.

*/
bool WriteLn(VString S, bool SendUserLine = false)
{
	SetLastError(0);
	//bool b = AttachConsole(ATTACH_PARENT_PROCESS);
		
	//if (!b)
	//	return b;

	HANDLE m_STD_OUTPUT_HANDLE = GetStdHandle(STD_OUTPUT_HANDLE);
	if (m_STD_OUTPUT_HANDLE == INVALID_HANDLE_VALUE)
		return false;

	HANDLE m_STD_INPUT_HANDLE = GetStdHandle(STD_INPUT_HANDLE);

	DWORD l;
	TCHAR *p = VString2WChar(S);
	WriteConsole(m_STD_OUTPUT_HANDLE,p,VString2WCharLen(S),&l,NULL);

	if (SendUserLine)
	{
		FlushConsoleInputBuffer(m_STD_INPUT_HANDLE);
		/*
		sendet ein Enter zur Konsole, damit der Prompt dargestellt wird.
		Vorher wird die Eingabe gel�scht
		*/

		HWND hwnd = GetConsoleWindow();
		SendMessage(hwnd,WM_CHAR,13,0);
	}


	//FreeConsole();
	return true;
}

/*
Enumerates all users
*/
void EnumUsers(VStringList &List)
{

   PNET_DISPLAY_USER pBuff, p;
   DWORD res, dwRec, i = 0;

   

   do // begin do
   { 
      //
      // Call the NetQueryDisplayInformation function;
      //   specify information level 3 (group account information).
      //
//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/netmgmt/netmgmt/netquerydisplayinformation.asp	  
      res = NetQueryDisplayInformation(NULL, 1, i, 1000, MAX_PREFERRED_LENGTH, &dwRec, (PVOID*)&pBuff);
      //
      // If the call succeeds,
      //
      if((res==ERROR_SUCCESS) || (res==ERROR_MORE_DATA))
      {
         p = pBuff;
         for(;dwRec>0;dwRec--)
         {
            //
            // Print the retrieved group information.
            //
            
			 TRACE4("Name:      %S\n"
                  "Comment:   %S\n"
                  "Group ID:  %u\n"
                  "Attributes: %u\n"
                  "--------------------------------\n",
				  p->usri1_name,
				  p->usri1_comment,
				  p->usri1_user_id,
				  p->usri1_flags);

		    List.AddHead(WChar2VString(p->usri1_name));
            //
            // If there is more data, set the index.
            //
			i = p->usri1_next_index;
            p++;

			

         }
         //
         // Free the allocated memory.
         //
         NetApiBufferFree(pBuff);
      }
      else
         printf("Error: %u\n", res);
   //
   // Continue while there is more data.
   //
	   } while (res==ERROR_MORE_DATA); // end do


}

BOOL VRunAsDialogHandler::OnShow(long Status, bool FirstShow) 
{
	if (FirstShow)
	{

		/*
		if default branch is executed,
		in a second time the focus is set
		otherwise it is set twice (does not matter)
		*/
		for (int i=0;i<2;i++)
		switch (iSelection)
		{
		case 0 : SetFocus(GetDlgItem(this->m_hDialog->m_hWnd,IDC_APPLICATION_EDIT)); break;
		case 1 : SetFocus(GetDlgItem(this->m_hDialog->m_hWnd,IDC_PARAMETER_EDIT)); break;
		case 2 : SetFocus(GetDlgItem(this->m_hDialog->m_hWnd,IDC_USERNAME_COMBO)); break;
		case 3 : SetFocus(GetDlgItem(this->m_hDialog->m_hWnd,IDC_PASSWORD_EDIT)); break;
		default:
			{
				//gets strings into global data
				//mainly to get Password
				UpdateGlobalData(this->m_hDialog->m_hWnd);

				if (sCommandLine.IsEmpty() && bCommandLine)
					iSelection = 0;
				else
				if (sUserName.IsEmpty() && bUserName)
					iSelection = 2;
				else
				if (sPassword.IsEmpty() && bPassword)
					iSelection = 3;
				else
				if (sParameter.IsEmpty() && bParameter)
					iSelection = 1;
				else
					SetFocus(GetDlgItem(this->m_hDialog->m_hWnd,ID_RUN)); 

				//clear password again
				ZeroString(sPassword);
			
				//next: see for loop
			}
		}
		
	}

	return VDlgHandler::OnShow(Status,FirstShow);
}

void InitAppList(HWND hwnd)
{
	HWND hAppBox = GetDlgItem(hwnd,IDC_APPLICATION_EDIT);
	SendMessage(GetDlgItem(hwnd,IDC_USERNAME_COMBO), CB_ADDSTRING,0,(LPARAM)VString2WChar((Users.GetAt(i)).c_str()));
}

BOOL VRunAsDialogHandler::OnInitDialog(HWND hwnd,UINT message, WPARAM wParam, LPARAM lParam)
{
	this->m_hDialog->CenterWindow();


	SetLastError(0);
	WCHAR pErrorString[100];
	int l = LoadString(GetModuleHandle(NULL),IDS_ERROR,pErrorString,sizeof(pErrorString));
	
	if (GetLastError() == 0)
		lstrcpyn(ErrorString,pErrorString,l+1);

	//update strings in controls

	SetEditText(hwnd,IDC_APPLICATION_EDIT,sCommandLine);
	this->m_hDialog->EnableWindow(IDC_APPLICATION_EDIT,bCommandLine);
	this->m_hDialog->EnableWindow(IDC_BROWSE_BUTTON,bCommandLine);



	SetEditText(hwnd,IDC_PARAMETER_EDIT,sParameter);
	this->m_hDialog->EnableWindow(IDC_PARAMETER_EDIT,bParameter);
	
	

	SetEditText(hwnd,IDC_USERNAME_COMBO,sUserName);
	this->m_hDialog->EnableWindow(IDC_USERNAME_COMBO,bUserName);


	//gets users
	VStringList Users;
	EnumUsers(Users);
	
	for (int i=0; i<Users.GetCount();i++)
		SendMessage(GetDlgItem(hwnd,IDC_USERNAME_COMBO), CB_ADDSTRING,0,(LPARAM)VString2WChar((Users.GetAt(i)).c_str()));


	SetEditText(hwnd,IDC_PASSWORD_EDIT,sPassword);
	this->m_hDialog->EnableWindow(IDC_PASSWORD_EDIT,bPassword);
	//zeros password
	ZeroString(sPassword);

	CheckDlgButton(hwnd,IDC_DONTCLOSE_CHECK,(int)bDontClose);
	this->m_hDialog->EnableWindow(IDC_DONTCLOSE_CHECK,!bDisableDontClose);
	
	CheckDlgButton(hwnd,IDC_LOCAL_LOGON,(int)bLocalLogOn);
	this->m_hDialog->EnableWindow(IDC_LOCAL_LOGON,!bDisableLocalLogOn);
	

	//update strings

	
	WCHAR p[1234];
	SetLastError(0);
	LoadString(GetModuleHandle(NULL),IDS_APP_TITLE,p,sizeof(p));
	if (GetLastError() == 0)
		SetWindowText(hwnd,p);

	SetLastError(0);
	LoadString(GetModuleHandle(NULL),IDS_USERNAME,p,sizeof(p));
	if (GetLastError() == 0)
		SetWindowText(GetDlgItem(hwnd,IDC_NAME_STATIC),p);

	SetLastError(0);
	LoadString(GetModuleHandle(NULL),IDS_PARAMETER,p,sizeof(p));
	if (GetLastError() == 0)
		SetWindowText(GetDlgItem(hwnd,IDC_PARAMETER_STATIC),p);


	SetLastError(0);
	LoadString(GetModuleHandle(NULL),IDS_PASSWORD,p,sizeof(p));
	if (GetLastError() == 0)
		SetWindowText(GetDlgItem(hwnd,IDC_PASSWORD_STATIC),p);

	SetLastError(0);
	LoadString(GetModuleHandle(NULL),IDS_DONTCLOSE,p,sizeof(p));
	if (GetLastError() == 0)
		SetWindowText(GetDlgItem(hwnd,IDC_DONTCLOSE_CHECK),p);

	SetLastError(0);
	LoadString(GetModuleHandle(NULL),IDS_LOCAL_LOGON,p,sizeof(p));
	if (GetLastError() == 0)
		SetWindowText(GetDlgItem(hwnd,IDC_LOCAL_LOGON),p);

	

	/*
	get version information of this file

	Product version will be set if a patch is made

	A lot of work for such a tiny thing like Product Version Information

	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/resources/versioninformation.asp
	http://www.mindcracker.com/mindcracker/c_cafe/winapi/version.asp
	*/

	//get the filname of executable
	WCHAR ModuleFileName[MAX_PATH];
	DWORD dwSize = GetModuleFileName(GetModuleHandle(NULL),ModuleFileName,MAX_PATH);

	if (dwSize > 0)
	{
		//get version info size
		DWORD Handle;
		dwSize = GetFileVersionInfoSize(ModuleFileName,&Handle);

		if (dwSize > 0)
		{
			char *rcData = new char[dwSize];

			int result = GetFileVersionInfo(ModuleFileName,0,dwSize,(LPVOID)rcData);

			if (result)
			{
				struct LANGANDCODEPAGE {
				WORD wLanguage;
				WORD wCodePage;
				} *lpTranslate;

				DWORD wSize;

				//retrieve all languages (standard: only one : german)
				result = VerQueryValue(rcData, TEXT("\\VarFileInfo\\Translation"),(LPVOID*)&lpTranslate,(PUINT)&wSize);

				if (result)
				{
					//create language branch
					//and jump to ProductVersion (leaf)
					WCHAR SubBlock[MAX_PATH];
					wsprintf(SubBlock,
						TEXT("\\StringFileInfo\\%04x%04x\\ProductVersion"),
						lpTranslate[0].wLanguage,
						lpTranslate[0].wCodePage);


					LPVOID lpBuffer;
					 
					//get data from leaf
					SetLastError(0);
					result = VerQueryValue(rcData, SubBlock, (LPVOID*)&lpBuffer, (PUINT)&wSize);
					if (result)
					{
						//VString S = WChar2VString((WCHAR*)lpBuffer);

						WCHAR Caption[500];
		
						GetWindowText(hwnd,Caption,sizeof(Caption));
						wsprintf(Caption,TEXT("%s  \t (Version %s)\0"),Caption,(WCHAR*)lpBuffer);
						SetWindowText(hwnd,Caption);
					}
				}
				// ShowErrorBox(0,GetLastError());
			}
			//finally
			delete[] rcData;
		}
	}


WCHAR Caption[500];
		
GetWindowText(hwnd,Caption,sizeof(Caption));

#ifdef WinXP
	wsprintf(Caption,TEXT("%s  WinXP only Version\0"),Caption);
#else
	wsprintf(Caption,TEXT("%s  Win2k/XP Version\0"),Caption);
#endif

SetWindowText(hwnd,Caption);

	return VDlgHandler::OnInitDialog(hwnd,message,wParam,lParam);
}

BOOL VRunAsDialogHandler::OnCommand(UINT message, WPARAM wParam, LPARAM lParam)
{
	switch LOWORD(wParam) 
	{
		/*
		OpenFile Dialog
		*/
	case IDC_BROWSE_BUTTON : 
		{
			OPENFILENAME of;
			memset(&of,0,sizeof(of));
			of.lStructSize = sizeof(of);
			of.nMaxFile = MAX_PATH;
			of.nMaxFileTitle = MAX_PATH;

			//Initial Dir if filename is empty
			of.lpstrInitialDir = sInitialDir;
			
            
			of.hwndOwner = this->m_hDialog->m_hWnd;

			//get filename
			WCHAR FileName[MAX_PATH];
			of.lpstrFile = FileName;
			GetWindowText(GetDlgItem(this->m_hDialog->m_hWnd,IDC_APPLICATION_EDIT),of.lpstrFile,MAX_PATH);

			//get filter from resource or standard
			WCHAR Filter[1000];
			memset(Filter,0,sizeof(Filter));
			SetLastError(0);
			LoadString(GetModuleHandle(NULL),IDS_FILETYPES,Filter,sizeof(Filter));

			if (GetLastError() == 0)
			{
				of.lpstrFilter = Filter;
			}
			else
				of.lpstrFilter = TEXT("*.*\0*.*\0\0");
			
			of.Flags = OFN_ENABLESIZING;
				//| OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST;
			int err = 0;
			BOOL res = GetOpenFileName(&of);
			err = GetLastError();
			if (res)
			{
				err = GetLastError();
				sCommandLine = WChar2VString(of.lpstrFile);
				SetEditText(this->m_hDialog->m_hWnd,IDC_APPLICATION_EDIT,sCommandLine);
			
				UpdateGlobalData(this->m_hDialog->m_hWnd);
			}
			
			if (err != 0)
				ShowErrorBox(0,GetLastError());

			break;
		}
	case IDC_PARAMETER_HELP_BUTTON :
		{
			VString s;
			for (int i=0;i < MAX_HELPSTRING;i++)
			{
				s += sHelpString[i];
			}
			MessageBox(0,VString2WChar(s),ErrorString,MB_ICONINFORMATION | MB_OK);
			break;
		}
	case ID_RUN : 
		{
			//updates global data from controls
			UpdateGlobalData(this->m_hDialog->m_hWnd);

			int ReturnValue = RET_SUCCESS;

			if (sUserName.IsEmpty())
			{
				//LPCTSTR *p = new TCHAR[1044;
				WCHAR p[1234];
				LoadString(GetModuleHandle(NULL),IDS_USER_MISSING,p,sizeof(p));
				MessageBox(this->m_hDialog->m_hWnd,p,ErrorString,MB_ICONERROR | MB_OK);
				
				break;
			}
			else
			if (sPassword.IsEmpty())
			{
				//LPCTSTR *p = new TCHAR[1044;
				WCHAR p[1234];
				LoadString(GetModuleHandle(NULL),IDS_PASSWORD_MISSING,p,sizeof(p));
				MessageBox(this->m_hDialog->m_hWnd,p,ErrorString,MB_ICONERROR | MB_OK);
				
				break;
			}
			else
			if (sCommandLine.IsEmpty())
			{
				//LPCTSTR *p = new TCHAR[1044;
				WCHAR p[1234];
				LoadString(GetModuleHandle(NULL),IDS_APP_MISSING,p,sizeof(p));
				MessageBox(this->m_hDialog->m_hWnd,p,ErrorString,MB_ICONERROR | MB_OK);
				
				break;
			}


			//runs command
			if (!RunApplicationWithUserName())
				ReturnValue = GetLastError();
			
			if (ReturnValue != RET_SUCCESS)
			{
				ShowErrorBox(this->m_hDialog->m_hWnd,ReturnValue);
			}

			if (!bDontClose && (ReturnValue == RET_SUCCESS))
				PostQuitMessage(ReturnValue);

			break;
		}
	default:break;
	}
	return VDlgHandler::OnCommand(message,wParam,lParam);
}

BOOL VRunAsDialogHandler::OnDestroyDialog(UINT message, WPARAM wParam, LPARAM lParam) 
{
	ZeroString(sPassword);

	return VDlgHandler::OnDestroyDialog(message,wParam,lParam);
}


void InitParameters(VString CmdLine)
{
	if (!CmdLine)
		return;

	int p = 0;

	int d = 0;

	p = CmdLine.Find("/parameter:('");
	if (p > 0)
	{
		d = CmdLine.Find("')",p);

		if (d-(p+13) > 0) //Mid(x,0) returns everything
			sParameter = CmdLine.Mid(p+13,d-(p+13));
		CmdLine.Delete(p,d-p+2);
		CmdLine.TrimLeft();

		p = CmdLine.Find("/!r");
		if (p > 0)
		{
			bParameter = false;
			CmdLine.Delete(p,3);
			CmdLine.TrimLeft();
		}
	}

	/*
	parameter user
	*/
	p = CmdLine.Find("/user:");
	if (p > 0)
	{
		d = CmdLine.Find(" ",p);
		sUserName = CmdLine.Mid(p+6,d-(p+6));
		CmdLine.Delete(p,d-p);
		CmdLine.TrimLeft();

		p = CmdLine.Find("/!u");
		if (p > 0)
		{
			bUserName = false;
			CmdLine.Delete(p,3);
			CmdLine.TrimLeft();
		}
	}

	/*
	parameter passwort
	*/
	p = CmdLine.Find("/password:");
	if (p > 0)
	{
		d = CmdLine.Find(" ",p );
		sPassword = CmdLine.Mid(p+10,d-(p+10));
		CmdLine.Delete(p,d-p);
		CmdLine.TrimLeft();
		p = CmdLine.Find("/!p");
		if (p > 0)
		{
			bPassword = false;
			CmdLine.Delete(p,3);
			CmdLine.TrimLeft();
		}
	}

	/*
	parameter passwort
	*/
	p = CmdLine.Find("/env");
	if (p > 0)
	{
		CmdLine.Delete(p,4);
		CmdLine.TrimLeft();
		bLocalLogOn = false;
		p = CmdLine.Find("/!env");
		if (p > 0)
		{
			bDisableLocalLogOn = true;
			CmdLine.Delete(p,5);
			CmdLine.TrimLeft();
		}
	}

	
	/*
	parameter 
	Dialog nach Run nicht schlie�en
	*/
	p = CmdLine.Find("/q");
	if (p > 0)
	{
		bDontClose = true;
		CmdLine.Delete(p,3);
		CmdLine.TrimLeft();
	}

	/*
	parameter 
	Die Checkbox "nach Run nicht schlie�en" deaktivieren
	*/
	p = CmdLine.Find("/!q");
	if (p > 0)
	{
		bDisableDontClose = true;
		CmdLine.Delete(p,3);
		CmdLine.TrimLeft();
	}

	/*
	parameter 
	Kommandozeilen edit nicht editierbar
	*/
	p = CmdLine.Find("/!c"); 
	if (p > 0)
	{
		bCommandLine = false;
		CmdLine.Delete(p,3);
		CmdLine.TrimLeft();
	}

	/*
	parameter 
	Fehler nicht im Dialog anzeigen
	*/
	p = CmdLine.Find("/e");
	if (p > 0)
	{
		bShowError = false;
		CmdLine.Delete(p,2);
		CmdLine.TrimLeft();
	}

	/*
	parameter 
	selektiert ein bestimmtes Eingabefeld
	*/
	p = CmdLine.Find("/#");
	if (p > 0)
	{
		
		VString snum;
		snum = CmdLine.Mid(p+2,1);
		//only get one number - /#123 is not recognized (however as 1)
		int num = VString::Str2IntDef(snum,-1);
		if (snum.IsEmpty() || (num < 0) || (num > 3))
		{
			WCHAR str[1234];
			SetLastError(0);
			LoadString(GetModuleHandle(NULL),IDS_APP_TITLE,str,sizeof(str));
							
#ifdef WinXP
			
			if (AttachConsole(ATTACH_PARENT_PROCESS))
			{
				if (GetLastError() == 0)
					WriteLn("/# needs a number (e.g. /#1)",true);
				else
					WriteLn(WChar2VString(str),true);
			}
			else
#endif
			if (GetLastError() == 0)
				MessageBox(0,TEXT("/# needs a number (e.g. /#1)"),ErrorString,MB_ICONERROR | MB_OK);
			else
				MessageBox(0,str,ErrorString,MB_ICONERROR | MB_OK);

			PostQuitMessage(RET_PARAMETER_ERROR);
			return;
		}
		CmdLine.Delete(p,3);
		CmdLine.TrimLeft();

		iSelection = num;		
	}

	p = CmdLine.Find("/?");
	int p2 = CmdLine.Find("/help");
	if ((p > 0) ||(p2 > 0))
	{
#ifdef WinXP
		if (!AttachConsole(ATTACH_PARENT_PROCESS))
		{
		//AllocConsole();
		HANDLE m_STD_OUTPUT_HANDLE = GetStdHandle(STD_OUTPUT_HANDLE);
		if (m_STD_OUTPUT_HANDLE == INVALID_HANDLE_VALUE)
		{
#endif

			VString s;
			for (int i=0;i < MAX_HELPSTRING;i++)
			{
				s += sHelpString[i];
			}
			MessageBox(0,VString2WChar(s),ErrorString,MB_ICONINFORMATION | MB_OK);
			PostQuitMessage(RET_SUCCESS);
			return;

#ifdef WinXP
		}
		return;
		}
		//FreeConsole();
		//printf("%d\n",MAX_HELPSTRING);	
		for (int i=0;i < MAX_HELPSTRING;i++)
		{
			
			//printf("%d",i);

			WriteLn(sHelpString[i]);


			//WCHAR *s;
			//s = VString2WChar(sHelpString[i]);
			
			//wprintf(s);
			
			//printf(&s);
		}
		WriteLn("\r\n",true);

#endif
		
	
		/*TCHAR pData[5024];
		int l = sizeof(pData);
		
		int s = 0;
		int p = 0;
		
		TCHAR pTemp[1024];
		s = LoadString(GetModuleHandle(NULL),IDS_COMMANDS_HELP,pTemp,l);
		
		
		

		if (GetLastError() == 0)
			WriteLn(WChar2VString(pData),true);
		else
		{
			ShowErrorBox(0,GetLastError());
			WriteLn("Fehler beim auslesen der String daten",true);
		}*/


		//ShowErrorBox(NULL,GetLastError());
		PostQuitMessage(RET_SUCCESS);
	}

	
	/*
	parameter 
	Fehler nicht im Dialog anzeigen
	*/
	if (!bCommandLine && (CmdLine.GetLength() == 0))
	{
		printf("bCommandLine");
		if (bShowError)
			MessageBox(NULL,TEXT("CMD"),ErrorString,MB_ICONERROR | MB_OK);
		PostQuitMessage(RET_ERROR_CMDLINE);
	}

	if (CmdLine.GetLength() > 0)
	{
		if (CmdLine[1] == '"')
			CmdLine.Delete(1);
		if (CmdLine[CmdLine.GetLength()] == '"')
			CmdLine.Delete(CmdLine.GetLength());
		sCommandLine = CmdLine;
	}


/*	VString sCommandLine;
bool bCommandLine = true;
VString sParameter;
bool bParameter = true;

VString sUserName;
bool bUserName = true;
VString sPassword;
bool bPassword = true;

bool bDontClose = false;
*/
}

#ifndef UNICODE
//no unicode
int APIENTRY _tWinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPTSTR    lpCmdLine,
                     int       nCmdShow)

#else 
//unicode
#ifdef _CONSOLE
int _tmain(int argc, _TCHAR* argv[])
#else
int WINAPI WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     PSTR    lpCmdLine,
                     int       nCmdShow)
#endif
#endif
{

#ifdef _CONSOLE
	FreeConsole();
	SetLastError(0);
	HINSTANCE hInstance = GetModuleHandle(NULL);

	hInst = hInstance;
	VString S;
	int i = 0;
	while (argv[i])
	{
		S += " " + VString(argv[i]);
		i++;
	}


	InitParameters(S);
#else
	InitParameters(VString((STRING)lpCmdLine));
#endif

	VRunAsDialogHandler DlgHandler;
	VDialog MainDlg(hInstance,IDD_MAIN_DIALOG,0,&DlgHandler);

	if (!MainDlg.Execute())
		return RET_ABORT_BY_USER;
	else	
		return iGlobalReturn;
}




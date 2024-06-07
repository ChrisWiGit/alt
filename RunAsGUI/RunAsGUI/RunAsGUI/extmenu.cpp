#include "stdafx.h"
#include "extmenu.h"
#include "windows.h"


using namespace vtools;

/*
Load_Reg_String(HKEY key, char* KeyName)
{
    DWORD dwData = 0;
    DWORD wlen;
    VString Data;

    //Größe des Strings ermitteln und ob der Eintrag überhaupt existiert.
    if (RegQueryValueEx(key,KeyName,NULL,NULL,NULL,&wlen) == ERROR_SUCCESS)
        {
            char *sData = new char[wlen+1];
			memset(sData,0,wlen+1);
          
            if (RegQueryValueEx(key,KeyName,NULL,NULL,(BYTE*)sData,&wlen) == ERROR_SUCCESS)
            {
                try
                { 
                  VString p(sData);
                  Data = p;                
                }
                catch (...)
                {
                    Data.Empty();
                }
                    
            }

            try
            {
             delete[] sData;
            }
            catch(...)
            {
            }
        }
    return Data;
}*/

bool CreateMenuInfo(MENUITEMINFO &Info,VString String,UINT fMask,UINT fType,UINT wID)
{
	/*memset(&Info,0,sizeof(MENUITEMINFO));
	Info.cbSize = sizeof(Info);
	Info.fMask = fMask;
	Info.fType = fType  | MFT_STRING;
	Info.wID = wID;
	Info.dwTypeData = _VSTR(String);
	Info.cch = String.GetLength();
*/
	return true;
}


bool ReadMenuFromRegistry()
{
	MENUITEMINFO Info;
	memset(&Info,0,sizeof(MENUITEMINFO));
	Info.cbSize = sizeof(Info);
	return false;
//	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/resources/menus/menureference/menustructures/menuiteminfo.asp
}
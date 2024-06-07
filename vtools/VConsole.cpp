/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#include ".\vconsole.h"
#include <stdarg.h>
#include <ctype.h>
//#include <fstream>

#include <map>
namespace vtools
{

typedef std::map<HWND, VConsole*> VConsoleMap;
static VConsoleMap g_WindowMap;



VConsole Console;

BOOL VConsole::Init(void)
{
	m_STD_INPUT_HANDLE = GetStdHandle(STD_INPUT_HANDLE);
	m_STD_OUTPUT_HANDLE = GetStdHandle(STD_OUTPUT_HANDLE);
	m_STD_ERROR_HANDLE = GetStdHandle(STD_ERROR_HANDLE);

	GetConsoleCursorInfo(m_STD_OUTPUT_HANDLE,&m_CurInfo);

    HWND hwnd = GetConsoleWindow();

	g_WindowMap[hwnd] = (VConsole*)this;

	VConsole *this_ = this;

	return true;
}

VConsole::VConsole(void)
: m_vKeyCode(0)
#ifdef INPUT_FLAVOUR_STD
	, m_bBufferEmpty(true) // sv: initialisierung der member variabel
#endif
{
	this->Init();	
}

VConsole::~VConsole(void)
{
}

BOOL WINAPI VConsole::HandlerRoutine(DWORD dwCtrlType)
{
	HWND hwnd = GetConsoleWindow();
	
	  VConsole *_this;
	_this = (VConsole*)g_WindowMap[hwnd];

	if (_this != NULL && _this->m_CtrlHandler != NULL)
		return _this->m_CtrlHandler(dwCtrlType);
	else
		return false;
}


bool VConsole::SetUserHandler(CONSOLEHANDLERPROC routine,bool Add)
{
	m_CtrlHandler = (CONSOLEHANDLERPROC)routine;
	return ::SetConsoleCtrlHandler(HandlerRoutine,Add)!=0;

		//routine,Add)!=0;
}

void VConsole::SetConsoleTitle(VString Text)
{
	::SetConsoleTitle(Text);
}
VString VConsole::GetConsoleTitle()
{
	char p[1025];
	::GetConsoleTitle(p,sizeof(p));
	return VString(p);
}

void VConsole::SetColor(TextAttributes Attr)
{
	SetConsoleTextAttribute(m_STD_OUTPUT_HANDLE,Attr);	
}

TextAttributes VConsole::GetColor()
{
	CONSOLE_SCREEN_BUFFER_INFO p;
	GetConsoleScreenBufferInfo(m_STD_OUTPUT_HANDLE,&p);
	return p.wAttributes;
}


bool VConsole::WriteChar(char Char)
{
	DWORD l;
	return WriteConsole(m_STD_OUTPUT_HANDLE,&Char,1,&l,NULL)!=0;
}

bool VConsole::GotoXY(int x, int y)
{
	CONSOLE_SCREEN_BUFFER_INFO csbiInfo; 

	memset(&csbiInfo,0,sizeof(csbiInfo));
	csbiInfo.dwCursorPosition.X = x-1; 
    csbiInfo.dwCursorPosition.Y = y-1; 
 
    return SetConsoleCursorPosition(m_STD_OUTPUT_HANDLE,csbiInfo.dwCursorPosition)!=0;
}

VPoint VConsole::GetCursorPos(void)
{
	CONSOLE_SCREEN_BUFFER_INFO csbiInfo; 
	VPoint p;
	memset(&p,0,sizeof(p));

	memset(&csbiInfo,0,sizeof(csbiInfo));
	if (GetConsoleScreenBufferInfo(m_STD_OUTPUT_HANDLE,&csbiInfo))
	{	
		p.X = csbiInfo.dwCursorPosition.X+1;
		p.Y = csbiInfo.dwCursorPosition.Y+1;
		return p;
	}
	return p;
}

VRect VConsole::GetWindowRect()
{
	CONSOLE_SCREEN_BUFFER_INFO csbiInfo; 
	memset(&csbiInfo,0,sizeof(csbiInfo));
	VRect p;

	if (GetConsoleScreenBufferInfo(m_STD_OUTPUT_HANDLE,&csbiInfo))
	{	
		p.Top.X = csbiInfo.srWindow.Top+1;
		p.Top.Y = csbiInfo.srWindow.Left+1;
		p.Bottom.X = csbiInfo.srWindow.Right+1;
		p.Bottom.Y = csbiInfo.srWindow.Bottom+1;
		
		
		return p;
	}
	return VRect();
}

int VConsole::ReadPassword(VString &szPassword)
{
	DWORD dwOldMode;
	GetConsoleMode(m_STD_INPUT_HANDLE,&dwOldMode);  
	SetConsoleMode(m_STD_INPUT_HANDLE,0);
		
	char c;
	char PassChar = '*';
	DWORD w;
	
	VPoint pt = this->GetCursorPos();

	szPassword.Empty();
	do
	{
		if (!ReadConsole(m_STD_INPUT_HANDLE,&c,1,&w,NULL)) break;
		if ((c != '\n') && (c != '\r') && (c != 8))
		{
			WriteConsole(m_STD_OUTPUT_HANDLE,&PassChar,1,&w,NULL);			
			szPassword += c;
		}
		else
		if (c == 8)
		{
			if (!szPassword.IsEmpty())
			{
				szPassword.Delete(szPassword.GetLength());
				this->GotoXY(this->GetCursorPos().X-1,this->GetCursorPos().Y);
				c = ' ';
				WriteConsole(m_STD_OUTPUT_HANDLE,&c,1,&w,NULL);			
				this->GotoXY(this->GetCursorPos().X-1,this->GetCursorPos().Y);
			}
		}

	}
	while ((c != '\n') && (c != '\r'));
	
	SetConsoleMode(m_STD_INPUT_HANDLE,dwOldMode);
	FlushConsoleInputBuffer(m_STD_INPUT_HANDLE);	

	return 0;
}

bool VConsole::Write(const char* str,...)
{
	VString s;
	va_list vaList;
	va_start(vaList, str);
	s.FormatV((STRING)str,vaList);
	bool b = this->WriteV(s,vaList);
	va_end(vaList);

	return b!=0;
}

bool VConsole::WriteV(const char* str,va_list argList )
{
	VString s;
	s.FormatV((STRING)str,argList);

	DWORD l;
	return WriteConsole(m_STD_OUTPUT_HANDLE,s.GetBuffer(),s.GetLength(),&l,NULL)!=0;
}

bool VConsole::WriteLn(const char* str,...)
{
	VString s;
	
	va_list vaList;
	va_start(vaList, str);
	s.FormatV((STRING)str,vaList);
    s.operator +=("\r\n");

	bool b = WriteV(s.GetBuffer(),vaList);

	va_end(vaList);

	return b != 0;
}

bool VConsole::KeyPressed()
{
	DWORD events;
	
//	memset(&input,0,sizeof(input));

//	WaitForSingleObject(m_STD_INPUT_HANDLE,INFINITE);
	GetNumberOfConsoleInputEvents(m_STD_INPUT_HANDLE,&events);

	INPUT_RECORD *input = new INPUT_RECORD[events];

	if (events <= 0) return false;

	PeekConsoleInput(m_STD_INPUT_HANDLE,input,events,&events);
	
	for (DWORD i = 0; i < events; i++)
	{
		if ((input[i].EventType == KEY_EVENT) && (input[i].Event.KeyEvent.bKeyDown))
		{
			return true;
		}
	}
	if ((input[0].EventType == KEY_EVENT) && (input[0].Event.KeyEvent.bKeyDown)) 
	{
		delete[] input;	
		return true;
	}

	delete[] input;	
	return false;
}
char VConsole::ReadKey()
{
	

	DWORD reads,Len;
	INPUT_RECORD input[2];
	Len = sizeof(input);

	memset(&input,0,Len);

	do
	{
		FlushConsoleInputBuffer(m_STD_INPUT_HANDLE);	
		WaitForSingleObject(m_STD_INPUT_HANDLE,INFINITE);
		PeekConsoleInput(m_STD_INPUT_HANDLE,input,1,&reads);
	}
	while ((input[0].EventType != KEY_EVENT));
		//&& (input.Event.KeyEvent.));
	
	
	ReadConsoleInput(m_STD_INPUT_HANDLE,input,2,&reads);

	if (input[0].EventType == KEY_EVENT)
	{
		if (input[0].Event.KeyEvent.bKeyDown)
		{
			FlushConsoleInputBuffer(m_STD_INPUT_HANDLE);		
			m_vKeyCode = input[0].Event.KeyEvent.wVirtualKeyCode;
			return (char)(unsigned char)input[0].Event.KeyEvent.uChar.AsciiChar; 
		}
		else
			return ReadKey();
	}
	else
		return ReadKey();

	return 0;
}

int VConsole::ReadPasswordC(LPTSTR &szPassword,size_t &Length)
{
	DWORD dwOldMode;
	GetConsoleMode(m_STD_INPUT_HANDLE,&dwOldMode);  

	SetConsoleMode(m_STD_INPUT_HANDLE,0);
		
	unsigned char c;

	char PassChar = '*';
	DWORD w;
	int i = 0;

	memset(szPassword,0,Length);
	do
	{
		c = '\0';
		
		if (!ReadConsole(m_STD_INPUT_HANDLE,&c,1,&w,NULL)) break;
		if ((i < Length) && (c != '\n') && (c != '\r') && (c != '\b'))
		{
			i++;
			WriteConsole(m_STD_OUTPUT_HANDLE,&PassChar,1,&w,NULL);			
			strncat(szPassword,(char*)&c,1);
		}
		if ((c == '\b') && (i > 0))
		{
			i--;
			
			//Ermittelt die X-Position
			CONSOLE_SCREEN_BUFFER_INFO csbiInfo; 
			memset(&csbiInfo,0,sizeof(csbiInfo));
			GetConsoleScreenBufferInfo(m_STD_OUTPUT_HANDLE,&csbiInfo);
			
			csbiInfo.dwCursorPosition.X--;
			SetConsoleCursorPosition(m_STD_OUTPUT_HANDLE,csbiInfo.dwCursorPosition);

			c = ' ';
			WriteConsole(m_STD_OUTPUT_HANDLE,(char*)&c,1,&w,NULL);			
			
			SetConsoleCursorPosition(m_STD_OUTPUT_HANDLE,csbiInfo.dwCursorPosition);
			/*Dieser Code funktioniert nicht �ber das Zeilenende hinaus!*/
			
			szPassword[i] = '\0';
		}
	}
	while ((c != '\n') && (c != '\r'));
	
	Length = strlen(szPassword);

	SetConsoleMode(m_STD_INPUT_HANDLE,dwOldMode);
	FlushConsoleInputBuffer(m_STD_INPUT_HANDLE);	

	return 0;
}

 bool IsCharNumber(unsigned char &c, const int pos, const VString vString, LPVOID lpData)
 {
	if (((c == '-')||(c == '+'))&& (pos == 0)) return true;
	if ((c >= '0') && (c <= '9'))
	{
		return true;
	}
	else
		return false;
}

bool VConsole::ReadInt(VString& Data,size_t MaxLen )
{
	return ReadLine(Data,MaxLen,&IsCharNumber,NULL,NULL,NULL);
}
int VConsole::ReadInt(size_t MaxLen)
{
	VString dez;
	ReadInt(dez,MaxLen);
	return  dez.Str2Int();
}


struct MaskData
{
	VConsole *_this;
	char *Mask;
};

#define MASKCHARS "d"

int getWhiteMask(char* Mask, char* &WhiteMask)
{
	if (strlen(Mask) == 0) return NULL;
	char *p = new char [strlen(Mask)];
	WhiteMask = p;

	strcpy(p,Mask);
    while (p[0] != '\0')
	{
		switch (p[0])
		{
			case 'd' : p[0] = '_';
		}
		p++;
	}
	return strlen(WhiteMask);
}


bool OnMaskedDoCmd(unsigned char &c, const int pos,  VString vString, LPVOID lpData)
{
	MaskData *Mask = (MaskData*)lpData;
	return TRUE;
}



bool OnMaskedKeyDown(unsigned char &c,unsigned char &retchar,int &m_vKeyCode,int &pos, int &afterpos, VString &vString, LPVOID lpData)
{
	MaskData *Mask = (MaskData*)lpData;
	VConsole *_this = Mask->_this;

	if ((m_vKeyCode == 45) || (m_vKeyCode == 46)) return FALSE; //no insert

	if ((c == '\r') ||(c == '\n')) return TRUE;

	if (c == 8)
	{
		if (pos-1 >= 0 && strchr(MASKCHARS,Mask->Mask[pos-1]) == NULL)
			retchar = Mask->Mask[pos-1];
		else
			retchar = '_';
	}

	if (pos >= strlen(Mask->Mask) )
	{
		if (m_vKeyCode == 39) return FALSE;
		
		if (/*(c == '\r') ||(c == '\n') || */(c == 8) || (m_vKeyCode == 37)) return TRUE;
		
		return FALSE;
	}
	else
		if ((c == '\r') ||(c == '\n')) return FALSE;

	if ((c > 31) && (c < 255) ) //sichtbare Zeichen
	{
		if (Mask->Mask[pos] == 'd')
		{
			if ((c >= '0') && (c <= '9'))
			{
				if ((pos < strlen(Mask->Mask) && strchr(MASKCHARS,Mask->Mask[pos+1]) == NULL))
				{
					pos ++;
					vString.SetAt(pos,c);
					vString.SetAt(pos+1,Mask->Mask[pos]);

					pos ++;
															
					_this->WriteChar(c);
					_this->WriteChar(Mask->Mask[pos-1]);
					
					afterpos = 1;
					return FALSE;
				}	
				else
				{
					pos ++;
					vString.SetAt(pos,c);

					_this->WriteChar(c);
					return FALSE;					
				}
			}				
			else
				return FALSE;
		}
		else
		{
			c = 0;
			if (pos >= vString.GetLength())
				vString += Mask->Mask[pos];
			else
				vString.SetAt(pos+1,Mask->Mask[pos]);
			_this->WriteChar(Mask->Mask[pos]);
			pos++;
			return FALSE;
		}
	}
	return TRUE;
}
bool OnMaskedInit(int &pos,  VString &vString, LPVOID lpData)
{
	MaskData *Mask = (MaskData*)lpData;
	VConsole *_this = Mask->_this;

	VPoint pt = _this->GetCursorPos();

	int len = strlen(Mask->Mask);
	char *WhiteMask = new char[len];
	getWhiteMask(Mask->Mask,WhiteMask);
	
	if (vString.IsEmpty())
	{
		vString = WhiteMask;;	
		_this->Write(WhiteMask);
	}

		

//	delete[] WhiteMask;
	_this->GotoXY(pt);	

	return TRUE;
}



bool VConsole::ReadMasked(char *Mask,VString& Data)
{
	MaskData aMask;
	aMask._this = this;
	aMask.Mask = Mask;
	
	return ReadLine(Data,0,&OnMaskedDoCmd,&OnMaskedInit,&OnMaskedKeyDown,(void*)&aMask);	
}

bool OnKeySetKeyDown(unsigned char &c,unsigned char &retchar,int &m_vKeyCode,int &pos, int &afterpos, VString &vString, LPVOID lpData)
{
	char *Str = (char*)(lpData);
	if (c == '\n') return TRUE;
	bool b = (strchr(Str,c) != 0);
	return b;
}
bool VConsole::ReadOfCharSet(char &ch,const VString CharSet)
{
	/*void *p = (char*)CharSet;
	VString s(ch);
	bool b = ReadLine(s,1,NULL,NULL,&OnKeySetKeyDown,p);
	ch = s[0];
	return b;*/
	
	VPoint pt = GetCursorPos();
	
	WriteChar(ch);GotoXY(pt);
	while (true)
	{
		char c = ReadKey();
		if (strchr(CharSet,c) != 0)
		{
			WriteChar(c);
			ch = c;
			GotoXY(pt);
		}
		else
		{
			char *b = strchr(CharSet,ch);
			if ((c == 13) && (b != NULL))
				return TRUE;						
		}
	}	
	return FALSE;
}

bool VConsole::ReadLine(VString& Data,size_t MaxLen,VCONSOLECMDPROC proc,
						INITREAD initr ,KEYDOWN keydown,
						LPVOID lpData)
{
	unsigned char c;
	int x,y,pos = 0;
	bool InsertMode = true;
	VPoint pt = GetCursorPos();

	//Data.Empty();
	if (initr != NULL) 
		if (!initr(pos,Data,lpData)) return false;

	if (!Data.IsEmpty())
	{
		Write(Data);
		GotoXY(pt);
	}
	
	do
	{
		c = ReadKey();		
		unsigned char retchar = c;
		int afterpos = 0;

		if ((keydown != NULL) &&
			(keydown(c,retchar,m_vKeyCode,pos,afterpos,Data,lpData)) ||
			(keydown == NULL) )
		{
						if (c == 8)
						{
							if (keydown == NULL) retchar = ' ';
							
							if (!Data.IsEmpty() && pos > 0)
							{
								Data.Delete(pos);
								pos--;
								
								VRect r = this->GetWindowRect();
								x = this->GetCursorPos().X-1;
								y = this->GetCursorPos().Y;
							
								if ((x < r.Top.X) && (y > r.Top.Y)) 
								{
									y--;
									x = r.Width();
								}

								GotoXY(pt.X,pt.Y);
								
								if (m_PasswordChar == 0)
									Write(Data);
								else
								{
									for (int i=1; i <= Data.GetLength();i++)
										WriteChar(m_PasswordChar);
								}
								WriteChar(retchar);
								GotoXY(x,y);
							}
						}

						if ((c == '\r') ||(c == '\n')) break;
						else
						
						if ((c > 31) && (c < 255) )
						{
								if	((((proc != NULL) && (proc(c,pos,Data,lpData))|| (proc == NULL))))
								if ((MaxLen == 0) || (InsertMode && Data.GetLength() < MaxLen ) || (!InsertMode && pos < Data.GetLength()))
								{
									if (m_PasswordChar == 0)
										WriteChar(c);
									else
										WriteChar(m_PasswordChar);
									pos++;
									pos += afterpos;

									if (InsertMode)
									{
										VPoint pp = this->GetCursorPos();

										Data.Insert(pos-1,(STRING)&c,1);
										{
											GotoXY(pt.X,pt.Y);
											if (m_PasswordChar == 0)
												Write(Data);
											else
											{
												for (int i=1; i <= Data.GetLength();i++)
													WriteChar(m_PasswordChar);
											}
											
											GotoXY(pp);
										}
									}
									else
										Data.SetAt(pos,c);
									
								}
						}
						else
							if (c < 31)
						{
							//37,39
							switch (m_vKeyCode)
							{
								//Links
							case 37 : {
										if (pos >= 1)
										{
											pos--;
											VRect r = this->GetWindowRect();
											x = this->GetCursorPos().X-1;
											y = this->GetCursorPos().Y;
										
											if ((x < r.Top.X) && (y > r.Top.Y)) 
											{
												y--;
												x = r.Width();
											}
											GotoXY(x,y);
										}
										break;
									}
								//rechts
							case 39 : {
										if (pos < Data.GetLength())
										{
											pos++;
											
											VRect r = this->GetWindowRect();
											x = this->GetCursorPos().X+1;
											y = this->GetCursorPos().Y;
										
											if ((x > r.Bottom.X)) 
											{
												y++;
												x = 1;
											}
											GotoXY(x,y);
											break;
										}
									}
							//Entf
							case 46 : {
										if (!Data.IsEmpty() && pos < Data.GetLength())
										{
											Data.Delete(pos+1);
											
											x = this->GetCursorPos().X;
											y = this->GetCursorPos().Y;
											GotoXY(pt.X,pt.Y);
											if (m_PasswordChar == 0)
												Write(Data);
											else
											{
												for (int i=1; i <= Data.GetLength();i++)
													WriteChar(m_PasswordChar);
											}
											Write(" ");
											GotoXY(x,y);
										}
										break;
									}
							//Einf
							case 45 : {
										InsertMode = !InsertMode;
										SetCursorBlockMode(!InsertMode);
										break;
									}
							//Pos1
							case 36 : {
										GotoXY(pt.X,pt.Y);
										pos = 0;
										break;
									}
						//Ende
							case 35 : {
										VRect r = this->GetWindowRect();
										x = this->GetCursorPos().X;
										y = this->GetCursorPos().Y;

										while (pos < Data.GetLength())
										{
											pos++;
											
											VRect r = this->GetWindowRect();
											x = this->GetCursorPos().X+1;
											y = this->GetCursorPos().Y;
										
											if ((x > r.Bottom.X)) 
											{
												y++;
												x = 1;
											}
											GotoXY(x,y);
										}

										break;
									}
							}
						}			
		}
	}
	while (true);
	
	FlushConsoleInputBuffer(m_STD_INPUT_HANDLE);	
	return true;
}

bool VConsole::SetCursorBlockMode(bool BlockMode)
{
	CONSOLE_CURSOR_INFO cur;
	
	if (BlockMode)
		cur.dwSize = 100;
	else
		cur.dwSize = m_CurInfo.dwSize;

	return SetConsoleCursorInfo(m_STD_OUTPUT_HANDLE,&cur)!=0;
}

};
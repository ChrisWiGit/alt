/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)

thanks :
asm_cpp
*/


/* sv:
	INPUT_FLAVOUR_STD
	dieses flag legt fest wie der operator f�r das einlesen von daten ( >> )
	reagieren soll.
	
	wenn dieses flag definiert ist, verh�lt sich der operator wie der von cin.
	d.h. man kann nur w�rter ohne leerzeichen eingeben aber es ist auch m�glich
	verschiedene sachen ohne zeilenumbruch einzulesen.

	wenn dieses flag nicht definiert ist, muss man f�r jede variable die man einlesen
	m�chte, den text eingeben und dann mit enter die eingabe abschliessen. was den
	vorteil hat dass strings mit leerzeichen eingeben kann, weicht aber vom standard
	verhalten ab (who cares *G*)...
*/
// #define INPUT_FLAVOUR_STD

	
#include "definitions.h"

#ifndef VCONSOLE_H
#define VCONSOLE_H

#pragma once

#include "windows.h"


#include "Assertions.h"
#include "vstring.h"
#include <sstream>

//using namespace vtools;
namespace vtools
{
/*enum TextAttributes 
{
	FOREGROUND_GREEN
};*/
typedef WORD TextAttributes;
	
/*#define FOREGROUND_ FOREGROUND_BLUE Text color contains blue. 
FOREGROUND_GREEN Text color contains green. 
FOREGROUND_RED Text color contains red. 
FOREGROUND_INTENSITY Text color is intensified. 
BACKGROUND_BLUE Background color contains blue. 
BACKGROUND_GREEN Background color contains green. 
BACKGROUND_RED Background color contains red. 
BACKGROUND_INTENSITY Background color is intensified. 
COMMON_LVB_LEADING_BYTE Leading byte. 
COMMON_LVB_TRAILING_BYTE Trailing byte. 
COMMON_LVB_GRID_HORIZONTAL Top horizontal. 
COMMON_LVB_GRID_LVERTICAL Left vertical. 
COMMON_LVB_GRID_RVERTICAL Right vertical. 
COMMON_LVB_REVERSE_VIDEO Reverse foreground and background attributes. 
COMMON_LVB_UNDERSCORE 
*/



typedef bool (*VCONSOLECMDPROC)(unsigned char &c, const int pos,  VString vString, LPVOID lpData);
typedef bool (*KEYDOWN)(unsigned char &c,unsigned char &retchar,int &pos,int &m_vKeyCode, int &afterpos,  VString &vString, LPVOID lpData);
typedef bool (*INITREAD)(int &pos,  VString &vString, LPVOID lpData);


typedef	bool (*CONSOLEHANDLERPROC)(WORD dbCtrl);

//#define LPCHAR char*


class _EXPORT_DLL_ VConsole
{
protected:
  HANDLE m_STD_INPUT_HANDLE;
  HANDLE m_STD_OUTPUT_HANDLE; 
  HANDLE m_STD_ERROR_HANDLE;

  CONSOLE_CURSOR_INFO m_CurInfo;

  
  static BOOL WINAPI HandlerRoutine(DWORD dwCtrlType);

#ifdef INPUT_FLAVOUR_STD
  bool m_bBufferEmpty;
  VString m_Buffer;
#endif // INPUT_FLAVOUR_STD

public:
	VConsole(void);
	virtual ~VConsole(void);	
	virtual BOOL Init(void);

	VPoint GetCursorPos(void);
	VRect GetWindowRect();


	bool GotoXY(int x, int y);
	inline bool GotoXY(VPoint Pt) {return this->GotoXY(Pt.X,Pt.Y);};

	bool WriteChar(char Char);

	bool WriteLn(const char* str,...);
	bool WriteV(const char* str,va_list argList );
	bool Write(const char* str,...);

	char ReadKey();
	bool KeyPressed();
	
	//obsolete
	char m_PasswordChar;
	int ReadPassword(VString &szPassword);
	int ReadPasswordC(LPTSTR &szPassword,size_t &Length);
	//
	//ALPHA Version
	//use : ReadMasked("ddd.ddd.ddd.ddd:ddd",s);
	bool ReadMasked(char *Mask,VString& Data);

	bool ReadOfCharSet(char &ch,const VString CharSet);

	bool ReadLine(VString& Data,size_t MaxLen = 0,VCONSOLECMDPROC proc = NULL,INITREAD initr = NULL,KEYDOWN keydown = NULL,LPVOID lpData=NULL);
	
	bool ReadInt(VString& Data,size_t MaxLen = 0);
	int ReadInt(size_t MaxLen = 0);

    //Todo:
    float ReadFloat(size_t MaxLen = 0) {return 0;};

   /*VConsole &operator >> (VString &s){ReadLine(s); return (*this);};
    VConsole &operator >> (int &s){VString p;ReadInt(p); s = p.Str2Int(); return (*this);};*/

   /* VConsole &operator << (const STRING s){Write(s); return (*this);};
    VConsole &operator << (const int s){Write("%d",s); return (*this);};
    
    //Console << "Hello " << (float)4.43;
    VConsole &operator << (const float s){Write("%f",s); return (*this);};*/

	 // sv: eingabe-routinen
#ifdef INPUT_FLAVOUR_STD
	 template <class T> VConsole & operator >> (T & s)
	 {
		if(m_bBufferEmpty)
		{
			ReadLine(m_Buffer);
		}

		const int iSpaceCharPos = m_Buffer.Find(" ", 1);

		if(iSpaceCharPos > 0)
		{
			// space gefunden, der token vor dem space wird 
			// herausgeschnitten und aus dem buffer gel�scht
			VString SubStr = m_Buffer.Left(iSpaceCharPos - 1);
			s = SubStr.StringToType<T>();
			m_Buffer.Delete(1, iSpaceCharPos);

			// checken ob der buffer leer ist
			m_bBufferEmpty = m_Buffer.IsEmpty();

			// im buffer ist jetzt das ganze zeugs nach dem space noch drin
			// (oder auch nicht). beim n�chsten aufruf des operators wird zuerst aus
			// dem buffer gelesen falls noch zeugs drin ist.

		} else
		{
			// kein space gefunden, der string wird
			// als ganzes in die �bergebene variabel gekickt
			s = m_Buffer.StringToType<T>();

			// den buffer leeren
			m_bBufferEmpty = true;
			m_Buffer.Empty();

			(*this) << endl;
		}
		 return(*this);
	 }
#else // INPUT_FLAVOUR_STD
	 template <class T> VConsole & operator >> (T & s)
	 {
		 VString xclLine;
		 ReadLine(xclLine);

		 s = xclLine.StringToType<T>();
		 (*this) << endl;

		 return(*this);
	 }
#endif // INPUT_FLAVOUR_STD


	 VConsole & operator << (VConsole & endl (VConsole &)) // sv: �berladen f�r endl 
	 {
		 return(endl(*this));
	 }

  //sv: alternative ausgabe routinen
	 VConsole & operator << (const VString & s)	// sv: VString klasse braucht eine spezielle
	 {															// �berladung des operators
		 Write(s);
		 return(*this);
	 }

	 template <class T> VConsole & operator << (const T & s)
	 {
		 std::stringstream xclStream;

		 xclStream << s;

		 Write(xclStream.str().c_str());
		 return(*this);
	 }

/*    template <class T> VConsole &operator << (const T s)
	{
	    std::stringstream ssm (s);
        char p[100];
        //ssm >> p;
        
	    //ssm >> result;

        Write(p);
	    return (*this);
	}
*/

    

	bool SetCursorBlockMode(bool BlockMode);
	
	void SetColor(TextAttributes Attr);
	TextAttributes GetColor();

	bool SetUserHandler(CONSOLEHANDLERPROC routine,bool Add = TRUE);

	void SetConsoleTitle(VString Text);
	VString GetConsoleTitle();


	int m_vKeyCode;
	
	CONSOLEHANDLERPROC m_CtrlHandler;
	
};

// sv: die endl funktion ist speziell f�r die VConsole
// (in der stl gibts das selbe f�r basic_ostream)
inline VConsole & endl(VConsole & rclConsole)
{
	 rclConsole.Write("\r\n");
	 return(rclConsole);
}

extern _EXPORT_DLL_ VConsole Console;
};

#endif
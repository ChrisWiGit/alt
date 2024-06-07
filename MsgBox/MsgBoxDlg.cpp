// MsgBoxDlg.cpp : implementation file
//

#include "stdafx.h"
#include "WndScroller.h"
#include "MsgBox.h"
#include "MsgBoxDlg.h"
#include "DataDlg.h"
#include "DataObj.h"
#include "resource.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

//#define DIALOGWIDTH  398
//#define DIALOGHEIGHT  408

//602
/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About



class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMsgBoxDlg dialog

CMsgBoxDlg::CMsgBoxDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMsgBoxDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMsgBoxDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_Scroller = new CWndScroller(this);
	DIALOGWIDTH = 398;
    DIALOGHEIGHT = 408;


}

void CMsgBoxDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMsgBoxDlg)
	DDX_Control(pDX, IDC_STANDARD, m_Standard);
	DDX_Control(pDX, IDC_COMBO2, m_Code);
	DDX_Control(pDX, IDC_REANICOMBO, m_ReAniCombo);
	DDX_Control(pDX, IDC_COMBO1, m_SndType);
	DDX_Control(pDX, IDC_MESSAGEBEEP, m_MessageBeep);
	DDX_Control(pDX, IDC_TASKMODAL, m_TaskModal);
	DDX_Control(pDX, IDC_SYSTEMLMODAL, m_SystemModal);
	DDX_Control(pDX, IDC_APPLMODAL, m_ApplModal);
	DDX_Control(pDX, ID_DEL, m_Del);
	DDX_Control(pDX, ID_CLIP, m_Clip);
	DDX_Control(pDX, IDC_EDIT5, m_DefCount);
	DDX_Control(pDX, IDC_SLIDER1, m_DefinesCount);
	DDX_Control(pDX, IDC_EDIT4, m_Return);
	DDX_Control(pDX, IDC_EDIT3, m_CopyEdit);
	DDX_Control(pDX, IDC_CHECK8, m_TOPMOST);
	DDX_Control(pDX, IDC_RADIO5, m_NoIcon);
	DDX_Control(pDX, IDC_CHECK7, m_Abort_Retry_Ignore_Button);
	DDX_Control(pDX, IDC_CHECK6, m_Retry_Button);
	DDX_Control(pDX, IDC_CHECK5, m_Yes_No_Cancel_Button);
	DDX_Control(pDX, IDC_CHECK4, m_Yes_No_Button);
	DDX_Control(pDX, IDC_CHECK3, m_Help_Button);
	DDX_Control(pDX, IDC_CHECK2, m_Cancel_Button);
	DDX_Control(pDX, IDC_CHECK1, m_Ok_Button);
	DDX_Control(pDX, IDC_RADIO4, m_Stop);
	DDX_Control(pDX, IDC_RADIO3, m_Question);
	DDX_Control(pDX, IDC_RADIO2, m_Information);
	DDX_Control(pDX, IDC_RADIO1, m_Exclamation);
	DDX_Control(pDX, IDC_EDIT2, m_Message);
	DDX_Control(pDX, IDC_EDIT1, m_Title);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMsgBoxDlg, CDialog)
	ON_WM_CONTEXTMENU()
	//{{AFX_MSG_MAP(CMsgBoxDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_CHECK7, OnCheck7)
	ON_BN_CLICKED(IDC_CHECK6, OnCheck6)
	ON_BN_CLICKED(IDC_CHECK5, OnCheck5)
	ON_BN_CLICKED(IDC_CHECK4, OnCheck4)
	ON_BN_CLICKED(IDC_CHECK1, OnCheck1)
	ON_BN_CLICKED(IDC_CHECK2, OnCheck2)
	ON_BN_CLICKED(IDWRITE, OnWrite)
	ON_BN_CLICKED(ID_CLIP, OnClip)
	ON_BN_CLICKED(ID_DEL, OnDel)
	ON_BN_CLICKED(Info, OnInfo)
	ON_WM_HSCROLL()
	ON_BN_CLICKED(IDC_CHECK3, OnCheck3)
	ON_BN_CLICKED(IDC_APPLMODAL, OnApplmodal)
	ON_BN_CLICKED(IDC_SYSTEMLMODAL, OnSystemlmodal)
	ON_BN_CLICKED(IDC_TASKMODAL, OnTaskmodal)
	ON_BN_CLICKED(IDC_MESSAGEBEEP, OnMessagebeep)
	ON_BN_CLICKED(IDC_REANICOMBO, OnReanicombo)
	ON_BN_CLICKED(IDC_HELP2, OnHelp2)
	ON_BN_CLICKED(IDC_CLOSE, OnClose)
	ON_BN_CLICKED(IDC_TEST, OnTest)
	ON_EN_CHANGE(IDC_EDIT3, OnChangeEdit3)
	ON_CBN_SELCHANGE(IDC_COMBO2, OnSelchangeCombo2)
	ON_BN_CLICKED(IDC_LOADSAVE, OnLoadsave)
	ON_BN_CLICKED(IDC_DELETE, OnDelete)
	ON_WM_VSCROLL()
	ON_COMMAND(ID_POPUP_NEUDARSTELLEN, OnPopupNeudarstellen)
	ON_BN_CLICKED(IDC_STANDARD, OnStandard)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMsgBoxDlg message handlers

BOOL CMsgBoxDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here

	m_Stop.SetIcon(((CWinApp*)GetParent())->LoadStandardIcon(IDI_HAND));
	m_Question.SetIcon(((CWinApp*)GetParent())->LoadStandardIcon(IDI_QUESTION));
	m_Information.SetIcon(((CWinApp*)GetParent())->LoadStandardIcon(IDI_ASTERISK));
	m_Exclamation.SetIcon(((CWinApp*)GetParent())->LoadStandardIcon(IDI_EXCLAMATION));

	m_Stop.SetCheck(FALSE);
	m_Question.SetCheck(FALSE);
	m_Information.SetCheck(TRUE);
	m_Exclamation.SetCheck(FALSE);

	m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
	m_Retry_Button.SetCheck(FALSE);
	m_Yes_No_Cancel_Button.SetCheck(FALSE);
	m_Yes_No_Button.SetCheck(FALSE);
	m_Help_Button.SetCheck(FALSE);
	m_Cancel_Button.SetCheck(FALSE);

	m_Ok_Button.SetCheck(TRUE);
	OnCheck1();

	m_Return.SetWindowText("Kein Wert");
	m_DefinesCount.SetRange(1,4);
	m_DefinesCount.SetPos(1);
	
	CString s;
	s.Format("%i",m_DefinesCount.GetPos());
	m_DefCount.SetWindowText(s);
	
	OnChangeEdit3();

	m_SndType.SetCurSel(0);
	OnMessagebeep() ;
	
	SetRightSlider1();

	m_Code.SetCurSel(1);
	m_Message.LimitText(999);

	InitList();
	_SetModify(FALSE);
	
	
	int y = GetSystemMetrics(SM_CYFULLSCREEN);
	int sx = GetSystemMetrics(SM_CXHSCROLL);
	Screen.cx = y;
	Screen.cy = sx;
	m_Scroller->Create(TRUE,FALSE);
	m_Scroller->ShowScroller(FALSE,FALSE);
	CRect r;
	GetWindowRect(r);
	//GetClientRect(r);

	DIALOGHEIGHT = r.Height();
	DIALOGWIDTH  = r.Width();

/*	WndRect = r;
	if (y <= 600)
	{
		m_Scroller->EnableScroller(FALSE,TRUE);
		m_Scroller->ShowScroller(FALSE,TRUE);
		int xy = 150;
		m_Scroller->SetVertRange(1,xy);
		MoveWindow(r.TopLeft().x,r.TopLeft().y,
			       r.Width()+sx,
				   y);
	}*/
	OnPopupNeudarstellen();
	SetScrollPos(SB_VERT,0,TRUE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMsgBoxDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if (nID == 61536)
	{
		OnClose();
		//EndDialog(0);
	}

	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}



// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMsgBoxDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMsgBoxDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CMsgBoxDlg::OnCheck7() 
{
	// TODO: Add your control notification handler code here
	if (m_Abort_Retry_Ignore_Button.GetCheck()==1)
	{
		m_Retry_Button.SetCheck(FALSE);
		m_Retry_Button.EnableWindow(FALSE);

		m_Yes_No_Cancel_Button.SetCheck(FALSE);
		m_Yes_No_Cancel_Button.EnableWindow(FALSE);

		m_Cancel_Button.SetCheck(FALSE);
		m_Ok_Button.EnableWindow(FALSE);
		
		m_Ok_Button.SetCheck(FALSE);
		m_Cancel_Button.EnableWindow(FALSE);

		m_Yes_No_Button.SetCheck(FALSE);
		m_Yes_No_Button.EnableWindow(FALSE);
		
	}
	else
	{
		m_Ok_Button.EnableWindow(TRUE);
		m_Cancel_Button.EnableWindow(TRUE);
		m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);
		m_Yes_No_Button.EnableWindow(TRUE);
		m_Yes_No_Cancel_Button.EnableWindow(TRUE);

	    m_Retry_Button.EnableWindow(TRUE);
	}
	SetRightSlider1();
}

void CMsgBoxDlg::OnCheck6() 
{
	// TODO: Add your control notification handler code here
	if (m_Retry_Button.GetCheck()==1)
	{
		m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
		m_Abort_Retry_Ignore_Button.EnableWindow(FALSE);

		
		m_Yes_No_Cancel_Button.SetCheck(FALSE);
		m_Yes_No_Cancel_Button.EnableWindow(FALSE);

		m_Cancel_Button.SetCheck(FALSE);
		m_Ok_Button.EnableWindow(FALSE);
		
		m_Ok_Button.SetCheck(FALSE);
		m_Cancel_Button.EnableWindow(FALSE);

		m_Yes_No_Button.SetCheck(FALSE);
		m_Yes_No_Button.EnableWindow(FALSE);
	}
	else
	{
 		m_Ok_Button.EnableWindow(TRUE);
		m_Cancel_Button.EnableWindow(TRUE);
		m_Yes_No_Button.EnableWindow(TRUE);
		m_Yes_No_Cancel_Button.EnableWindow(TRUE);

		m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);	
	}
	SetRightSlider1();
}

void CMsgBoxDlg::OnCheck5() 
{
	// TODO: Add your control notification handler code here
	if (m_Yes_No_Cancel_Button.GetCheck()==1)
	{
		m_Yes_No_Button.SetCheck(FALSE);
		m_Yes_No_Button.EnableWindow(FALSE);

		m_Cancel_Button.SetCheck(FALSE);
		m_Ok_Button.EnableWindow(FALSE);
		
		m_Ok_Button.SetCheck(FALSE);
		m_Cancel_Button.EnableWindow(FALSE);
		
		m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
		m_Abort_Retry_Ignore_Button.EnableWindow(FALSE);

		m_Retry_Button.SetCheck(FALSE);
		m_Retry_Button.EnableWindow(FALSE);

	}
	else
	{
 		m_Ok_Button.EnableWindow(TRUE);
		m_Cancel_Button.EnableWindow(TRUE);
		m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);
		m_Retry_Button.EnableWindow(TRUE);

		m_Yes_No_Button.EnableWindow(TRUE);	
	}
	SetRightSlider1();
}

void CMsgBoxDlg::OnCheck4() 
{
	// TODO: Add your control notification handler code here
	if (m_Yes_No_Button.GetCheck()==1)
	{
		m_Yes_No_Cancel_Button.SetCheck(FALSE);
		m_Yes_No_Cancel_Button.EnableWindow(FALSE);

		m_Cancel_Button.SetCheck(FALSE);
		m_Ok_Button.EnableWindow(FALSE);
		
		m_Ok_Button.SetCheck(FALSE);
		m_Cancel_Button.EnableWindow(FALSE);
		
		m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
		m_Abort_Retry_Ignore_Button.EnableWindow(FALSE);

		m_Retry_Button.SetCheck(FALSE);
		m_Retry_Button.EnableWindow(FALSE);

	}
	else
	{
		m_Yes_No_Cancel_Button.EnableWindow(TRUE);	
		m_Ok_Button.EnableWindow(TRUE);
		m_Cancel_Button.EnableWindow(TRUE);
		m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);
		m_Retry_Button.EnableWindow(TRUE);
	}
	SetRightSlider1();
}
/*
if (.GetCheck()==1)
	{
		.SetCheck(FALSE);
		.EnableWindow(FALSE);
	}
	else
	    .EnableWindow(TRUE);	
*/

void CMsgBoxDlg::OnCheck1() 
{
	// TODO: Add your control notification handler code here
	if (m_Ok_Button.GetCheck()==1)
	{
		m_Yes_No_Button.SetCheck(FALSE);
		m_Yes_No_Button.EnableWindow(FALSE);

		m_Yes_No_Cancel_Button.SetCheck(FALSE);
		m_Yes_No_Cancel_Button.EnableWindow(FALSE);

				
	
		m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
		m_Abort_Retry_Ignore_Button.EnableWindow(FALSE);

		m_Retry_Button.SetCheck(FALSE);
		m_Retry_Button.EnableWindow(FALSE);

	}
	else
	{
		m_Yes_No_Cancel_Button.EnableWindow(TRUE);	
		m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);
		m_Retry_Button.EnableWindow(TRUE);
		m_Yes_No_Button.EnableWindow(TRUE);
	}
	SetRightSlider1();
	
}

void CMsgBoxDlg::OnCheck2() 
{
	// TODO: Add your control notification handler code here
	if (m_Cancel_Button.GetCheck()==1)
	{
		m_Ok_Button.SetCheck(TRUE);	
		m_Ok_Button.EnableWindow(FALSE);
		

		m_Yes_No_Button.SetCheck(FALSE);
		m_Yes_No_Button.EnableWindow(FALSE);

		m_Yes_No_Cancel_Button.SetCheck(FALSE);
		m_Yes_No_Cancel_Button.EnableWindow(FALSE);

				
		
		m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
		m_Abort_Retry_Ignore_Button.EnableWindow(FALSE);

		m_Retry_Button.SetCheck(FALSE);
		m_Retry_Button.EnableWindow(FALSE);

	}
	else
	{
		m_Yes_No_Cancel_Button.EnableWindow(TRUE);	
		m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);
		m_Retry_Button.EnableWindow(TRUE);
		m_Yes_No_Button.EnableWindow(TRUE);
		m_Ok_Button.EnableWindow(TRUE);
		m_Ok_Button.SetCheck(FALSE);	
	}
	SetRightSlider1();
	
}



void CMsgBoxDlg::CheckCheckers()
{
	int Result = 0;
	if (m_Cancel_Button.GetCheck()==1) Result++;
	if (m_Ok_Button.GetCheck()==1)		Result++;
	if (m_Yes_No_Button.GetCheck()==1)	Result++;
	if (m_Yes_No_Cancel_Button.GetCheck()==1)	Result++;
	if (m_Retry_Button.GetCheck()==1)	Result++;
	if (m_Abort_Retry_Ignore_Button.GetCheck()==1) Result++;
	if (Result <= 0)
	{
		m_Ok_Button.SetCheck(TRUE);
		OnCheck1();
	}
}

void CMsgBoxDlg::WriteData()
{

	CheckCheckers();
	
	SetDlgItemText(IDC_EDIT3,"");

	CString Ext;
	CString Source2;
	CString Source1;	
	CString Source;
	if (m_Code.GetCurSel() != 4)
	{
			switch (m_Code.GetCurSel())
			{
			case 0 : Ext = " + ";break;
			case 2 : Ext = " + ";break;
			case 1 : Ext = " | ";break;
			case 3 : Ext = " | ";break;
			}
			

			if (m_MessageBeep.GetCheck())  
			{
				Source1 = "MessageBeep(";
				int Scale = 0xFFFFFFFF;
				if (m_SndType.GetCurSel() == 5)
				{
					if (m_Stop.GetCheck())		   Source1 += "MB_ICONHAND"; else
					if (m_Question.GetCheck())	   Source1 += "MB_ICONQUESTION"; else
					if (m_Information.GetCheck())  Source1 += "MB_ICONINFORMATION"; else
					if (m_Exclamation.GetCheck())  Source1 += "MB_ICONEXCLAMATION"; else
						Source1 += "0xFFFFFFFF";

				}   
				else
					switch (m_SndType.GetCurSel())
				{
					case 1 : Source1 += "MB_ICONASTERISK" ;break;
					case 2 : Source1 += "MB_ICONEXCLAMATION";break;
					case 3 : Source1 += "MB_ICONHAND" ;break;
					case 4 : Source1 += "MB_ICONQUESTION" ;break;
					default : Source1 += "0xFFFFFFFF" ;break;
				}
				Source1 += ");";
			}


			char Title[99];
			GetDlgItemText(IDC_EDIT1,Title,100);

			//LPTSTR Msg = new char;
			
			char Msg3[999];
			GetDlgItemText(IDC_EDIT2,Msg3,1000);

			Source = "MessageBox(";
				
			switch (m_Code.GetCurSel())
			{
			case 0 : Source += "GetFocus,";break;
			case 2 : Source += "GetFocus,";break;
			}
			

			m_Message.FmtLines(FALSE);	
			CString Msg2;
			char s[999];

			int Lines = m_Message.GetLineCount();
			
			m_Message.GetLine(0,s,m_Message.LineLength(0));
			
			int len;
			switch (m_Code.GetCurSel())
			{
			case 0 : Source += "'";break;
			case 2 : Source += "'";break;
			case 1 : Source += "\"";break;
			case 3 : Source += "\"";break;
			}
			
			CString x ;
			m_Message.GetWindowText(x);

			int r;
			for (int i=1;i<=Lines;i++)
			{
				len = m_Message.LineLength(i-1);
				r = m_Message.GetLine(i-1,s);
				if (r!=0)
				{
					Msg2 = s;
					if (Msg2.GetLength() > 0)
					{
						Msg2 = Msg2.Left(r);
						Source += Msg2;
					}
				}
			switch (m_Code.GetCurSel())
			{
			case 0 : Source += "'#13+'";break;
			case 2 : Source += "'#13+'";break;
			case 1 : Source += "\\n";break;
			case 3 : Source += "\\n";break;
			}


			}
			switch (m_Code.GetCurSel())
			{
			case 1 : Source += "\"";break;
			case 3 : Source += "\"";break;
			case 0 : Source += "'";break;
			case 2 : Source += "'";break;
			}


			CString Style;
			if (m_Ok_Button.GetCheck()==1) Style += "MB_OK"+Ext;
			if (m_Cancel_Button.GetCheck()==1)	Style += "MB_OKCANCEL"+Ext ;
			if (m_Help_Button.GetCheck()==1)	Style += "MB_HELP"+Ext ;
			if (m_Yes_No_Button.GetCheck()==1)	Style += "MB_YESNO"+Ext;
			if (m_Yes_No_Cancel_Button.GetCheck()==1) Style += "MB_YESNOCANCEL"+Ext;
			if (m_Retry_Button.GetCheck()==1) Style += "MB_RETRYCANCEL"+Ext;
			if (m_Abort_Retry_Ignore_Button.GetCheck()==1) Style += "MB_ABORTRETRYIGNORE"+Ext;

			if (m_TOPMOST.GetCheck()==1) 
			{
				switch (m_Code.GetCurSel())
				{
				case 1 : Style += "MB_TOPMOST"+Ext;break;
				case 3 : Style += "4000"+Ext;break;
				case 0 : Style += "MB_TOPMOST"+Ext;break;
				case 2 : Style += "4000"+Ext;break;			
				}
				
			
			}
			
			
			if (m_Stop.GetCheck())		   Style += "MB_ICONSTOP"+Ext;
			if (m_Question.GetCheck())	   Style += "MB_ICONQUESTION"+Ext;
			if (m_Information.GetCheck())  Style += "MB_ICONINFORMATION"+Ext;
			if (m_Exclamation.GetCheck())  Style += "MB_ICONEXCLAMATION"+Ext;


			if (m_ApplModal.GetCheck())	   Style += "MB_APPLMODAL"+Ext;
			if (m_TaskModal.GetCheck())    Style += "MB_TASKMODAL"+Ext;
			if (m_SystemModal.GetCheck())  Style += "MB_SYSTEMMODAL"+Ext;


			switch (m_DefinesCount.GetPos())
			{
				case 1 : Style += "MB_DEFBUTTON1"+Ext;break;
				case 2 : Style += "MB_DEFBUTTON2"+Ext;break;
				case 3 : Style += "MB_DEFBUTTON3"+Ext;break;
				case 4 : {
							switch (m_Code.GetCurSel())
							{
							case 1 : Style += "MB_DEFBUTTON4"+Ext;break;
							case 3 : Style += "300"+Ext;break;
							case 0 : Style += "MB_DEFBUTTON4"+Ext;break;
							case 2 : Style += "300"+Ext;break;
							}
						 }
			}

			Style += "0);";


			switch (m_Code.GetCurSel())
			{
			case 1 : Source += ",\"";break;
			case 3 : Source += ",\"";break;
			case 0 : Source += ",'";break;
			case 2 : Source += ",'";break;
			}

			
			Source +=Title;
			switch (m_Code.GetCurSel())
			{
			case 1 : Source += "\",";break;
			case 3 : Source += "\",";break;
			case 0 : Source += "',";break;
			case 2 : Source += "',";break;			
			}

			Source +=Style;
			if (m_MessageBeep.GetCheck())  Source2 = " MessageBeep(0);";

	}
	else
	{
		Source1 = "MessageDlg('";
        char Msg3[999];
//		GetDlgItemText(IDC_EDIT2,Msg3,1000);
		CString sa(Msg3);
        char s[999];
//		Source = "'";
//		Source += sa+"'";
        
		CString x,Msg2 ;
			m_Message.GetWindowText(x);

			int r,len;
			
			m_Message.GetLine(0,s,m_Message.LineLength(0));
            int Lines = m_Message.GetLineCount();
			for (int i=1;i<=Lines;i++)
			{
				len = m_Message.LineLength(i-1);
				r = m_Message.GetLine(i-1,s);
				if (r!=0)
				{
					Msg2 = s;
					if (Msg2.GetLength() > 0)
					{
						Msg2 = Msg2.Left(r);
						Source += Msg2;
						if (i != Lines) 
							 Source += "'#13+'";
					     
					}
				}
//			    Source += "'#13";
			}
			Source += "'";
			CString Style("mtCustom");

			if (m_Stop.GetCheck())		   Style = "mtError";
			if (m_Question.GetCheck())	   Style = "mtConfirmation";
			if (m_Information.GetCheck())  Style = "mtInformation";
			if (m_Exclamation.GetCheck())  Style = "mtWarning";		

			Source2 = ","+Style;
			Source2 += ",[";

			Style = "";
			
			if (m_Ok_Button.GetCheck()==1) 
			{
				Style += "mbOK";
			}
			if (m_Cancel_Button.GetCheck()==1)	
			{	
				if (Style.GetLength() > 0) Style += ",";
				Style += "mbCANCEL";
			}
			if (m_Help_Button.GetCheck()==1)	
			{
				if (Style.GetLength() > 0) Style += ",";
				Style += "mbHELP";
			}
			if (m_Yes_No_Button.GetCheck()==1)	
			{
				if (Style.GetLength() > 0) Style += ",";
				Style += "mbYES,mbNO";
			}
			if (m_Yes_No_Cancel_Button.GetCheck()==1) 
			{
			    if (Style.GetLength() > 0) Style += ",";				
				Style += "mbYES,mbNO,mbCANCEL";
			}
			if (m_Retry_Button.GetCheck()==1) 
			{
				if (Style.GetLength() > 0) Style += ",";				
				Style += "mbRETRY,mbCANCEL";
			}
			if (m_Abort_Retry_Ignore_Button.GetCheck()==1) 
			{
			    if (Style.GetLength() > 0) Style += ",";				
				Style += "mbABORT,mbRETRY,mbIGNORE";
			}

			Source2 += Style;

			Source2 += "],0);";
			
			
			/*
			switch (m_Code.GetCurSel())
			{
			case 1 : Source += "\"";break;
			case 3 : Source += "\"";break;
			case 0 : Source += "'";break;
			case 2 : Source += "'";break;
			}*/
	}

	SetDlgItemText(IDC_EDIT3,Source1+Source+Source2);

	OnChangeEdit3() ;
}

void CMsgBoxDlg::OnWrite() 
{
	// TODO: Add your control notification handler code here
	WriteData();
}

void CMsgBoxDlg::OnClip() 
{
	// TODO: Add your control notification handler code here
	m_CopyEdit.SetSel(0,-1);
	m_CopyEdit.Copy();
	m_CopyEdit.LineScroll(0,0);

	OnChangeEdit3() ;

}

void CMsgBoxDlg::OnDel() 
{
	// TODO: Add your control notification handler code here
	
	SetDlgItemText(IDC_EDIT3,"");
	OnChangeEdit3() ;

}

void CMsgBoxDlg::OnInfo() 
{
	// TODO: Add your control notification handler code here
	CAboutDlg dlg	;
	dlg.DoModal();
}


void CMsgBoxDlg::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar) 
{
	// TODO: Add your message handler code here and/or call default
	
	CDialog::OnHScroll(nSBCode, nPos, pScrollBar);
	if ((CSliderCtrl*)pScrollBar == &m_DefinesCount)
	{
		CString s;
		s.Format("%i",m_DefinesCount.GetPos());
		m_DefCount.SetWindowText(s);
		
	}
}

void CMsgBoxDlg::SetRightSlider1()
{

	int Range = 1;
	if (m_Ok_Button.GetCheck()==1) Range = 1;
	if (m_Cancel_Button.GetCheck()==1) Range = 2;
	if (m_Yes_No_Button.GetCheck()==1) Range = 2;
	if (m_Yes_No_Cancel_Button.GetCheck()==1) Range = 3;
	if (m_Retry_Button.GetCheck()==1)Range = 2;
	if (m_Abort_Retry_Ignore_Button.GetCheck()==1)Range = 3;
	if (m_Help_Button.GetCheck()==1) Range++;

	
	
	m_DefinesCount.SetRange(1,Range);
	m_DefinesCount.SetPos(1);
	
	CString s;
	s.Format("%i",m_DefinesCount.GetPos());
	m_DefCount.SetWindowText(s);
}

void CMsgBoxDlg::OnCheck3() 
{
	// TODO: Add your control notification handler code here
	SetRightSlider1();	
}

void CMsgBoxDlg::OnChangeEdit3() 
{
	// TODO: If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function to send the EM_SETEVENTMASK message to the control
	// with the ENM_CHANGE flag ORed into the lParam mask.
	
	// TODO: Add your control notification handler code here
	if (m_CopyEdit.GetLineCount() <= 1 && m_CopyEdit.LineLength(1) <= 0)
	{
		GotoDlgCtrl(&m_Ok);
		m_Clip.EnableWindow(FALSE);
		m_Del.EnableWindow(FALSE);
	}
	else
	{
		m_Clip.EnableWindow(TRUE);
		m_Del.EnableWindow(TRUE);
	}
}

void CMsgBoxDlg::OnApplmodal() 
{
	// TODO: Add your control notification handler code here
	if (m_ApplModal.GetCheck())
	{
		m_TaskModal.EnableWindow(FALSE);
		m_SystemModal.EnableWindow(FALSE);
	}
	else
	{
		m_TaskModal.EnableWindow(TRUE);
		m_SystemModal.EnableWindow(TRUE);
	}	

	
}

void CMsgBoxDlg::OnSystemlmodal() 
{
	// TODO: Add your control notification handler code here
	if (m_SystemModal.GetCheck())
	{
		m_TaskModal.EnableWindow(FALSE);
		m_ApplModal.EnableWindow(FALSE);
	}
	else
	{
		m_TaskModal.EnableWindow(TRUE);
		m_ApplModal.EnableWindow(TRUE);
	}
}

void CMsgBoxDlg::OnTaskmodal() 
{
	// TODO: Add your control notification handler code here
	if (m_TaskModal.GetCheck())
	{
		m_SystemModal.EnableWindow(FALSE);
		m_ApplModal.EnableWindow(FALSE);
	}
	else
	{
		m_SystemModal.EnableWindow(TRUE);
		m_ApplModal.EnableWindow(TRUE);
	}	
}

void CMsgBoxDlg::OnMessagebeep() 
{
	// TODO: Add your control notification handler code here
	if (!m_MessageBeep.GetCheck())
	{
		m_SndType.EnableWindow(FALSE);	
		m_ReAniCombo.EnableWindow(FALSE);	
	}
	else
	{
		m_SndType.EnableWindow(TRUE);	
		m_ReAniCombo.EnableWindow(TRUE);	
	}
}

void CMsgBoxDlg::OnReanicombo() 
{
	// TODO: Add your control notification handler code here
	m_SndType.SetCurSel(0);
	if (m_Stop.GetCheck()) m_SndType.SetCurSel(3);
	if (m_Question.GetCheck())	   m_SndType.SetCurSel(4);
	if (m_Information.GetCheck())  m_SndType.SetCurSel(1);
	if (m_Exclamation.GetCheck())  m_SndType.SetCurSel(2);
}




void CMsgBoxDlg::OnHelp2() 
{
	// TODO: Add your control notification handler code here
	// TODO: Add your control notification handler code here
	int ret = WinExec("C:\\PROGRAMME\\ZUBEHÖR\\WORDPAD.EXE MSGBOX.RTF",
				  	  SW_SHOW);
	
}


BOOL CMsgBoxDlg::OnCommand(WPARAM wParam, LPARAM lParam) 
{
	// TODO: Add your specialized code here and/or call the base class
	//if (wParam	== IDC_TEST) goto next;
	
	if (wParam	== IDCANCEL)
	{
		//EndDialog(0);
	/*	MessageBox("Schließen Sie das Programm nur mit dem Schaltknopf \"Schließen\" \n oder benutzten Sie eine Möglichkeit von Windows die Anwendung\nzu schließen.n Sie eine Möglichkeit von Windows die Anwendung"\n\n","Information",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);

  */
 // MessageBox("Schließen Sie das Programm nur mit dem Schaltknopf \"Schließen\" \noder benutzten Sie eine Möglichkeit von Windows die Anwendung\nzu schließen.\n","Information",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);  
  /*
Schließen Sie das Programm nur mit dem Schaltknopf \"Schließen\" 
oder benutzten Sie eine Möglichkeit von Windows die Anwendung
zu schließen.
	*/
		return -1;
	}
	if (wParam	== IDOK)
	{
		//EndDialog(0);
		return -1;
	}
	 
//next:;
	return CDialog::OnCommand(wParam, lParam);
}


void CMsgBoxDlg::OnClose() 
{
	// TODO: Add your control notification handler code here
	if (GetModify())
	{
		if (MessageBox("Ihre Daten sind noch nicht gesichert worden.\nWollen Sie wirklich die Anwendung beenden?\n","MessageBox Creator",MB_YESNO | MB_ICONQUESTION | MB_APPLMODAL | MB_DEFBUTTON2 | 0) == IDNO)
			goto End;
	}
	else
	{
		if (MessageBox("Wollen Sie den MessageBoxCreator wirklich beenden?\n","MessageBoxCreator beenden",MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON3 | 0)== IDNO)
			goto End;
	}
		
	EndDialog(0);	
End:;
}

void CMsgBoxDlg::OnTest() 
{
	// TODO: Add your control notification handler code here
	CheckCheckers();
	int Style = 0;
	if (m_Ok_Button.GetCheck()==1) Style |= MB_OK;
	if (m_Cancel_Button.GetCheck()==1)	Style |= MB_OKCANCEL;
	if (m_Help_Button.GetCheck()==1)	Style |= MB_HELP ;
	if (m_Yes_No_Button.GetCheck()==1)	Style |= MB_YESNO;
	if (m_Yes_No_Cancel_Button.GetCheck()==1) Style |= MB_YESNOCANCEL;
	if (m_Retry_Button.GetCheck()==1) Style |= MB_RETRYCANCEL;
	if (m_Abort_Retry_Ignore_Button.GetCheck()==1) Style |= MB_ABORTRETRYIGNORE;

	if (m_Code.GetCurSel() != 4)
	 if (m_TOPMOST.GetCheck()==1) Style |= MB_TOPMOST;
	
	char Title[99];
	if (m_Code.GetCurSel() != 4)
	{

	    GetDlgItemText(IDC_EDIT1,Title,100);

		if (m_Stop.GetCheck())		   Style |= MB_ICONSTOP;
		if (m_Question.GetCheck())	   Style |= MB_ICONQUESTION;
		if (m_Information.GetCheck())  Style |= MB_ICONINFORMATION;
		if (m_Exclamation.GetCheck())  Style |= MB_ICONEXCLAMATION;
	}else
	{
		strcpy(Title,"<Programmname>");
		if (m_Stop.GetCheck())		   
		{
			Style |= MB_ICONSTOP;
			strcpy(Title,"Fehler");
		}
		if (m_Question.GetCheck())	   
		{
			Style |= MB_ICONQUESTION;
			strcpy(Title,"Bestätigen");
		}
		if (m_Information.GetCheck())  
		{
			Style |= MB_ICONINFORMATION;
			strcpy(Title,"Information");
		}
		if (m_Exclamation.GetCheck())
		{
			Style |= MB_ICONEXCLAMATION;
			strcpy(Title,"Warnung");
		}
	}	

	if (m_Code.GetCurSel() != 4)
	{
	if (m_ApplModal.GetCheck())	   Style |= MB_APPLMODAL;
	if (m_TaskModal.GetCheck())  Style |= MB_TASKMODAL;
	if (m_SystemModal.GetCheck())  Style |= MB_SYSTEMMODAL;
	

	switch (m_DefinesCount.GetPos())
	{
		case 1 : Style |= MB_DEFBUTTON1;break;
		case 2 : Style |= MB_DEFBUTTON2;break;
		case 3 : Style |= MB_DEFBUTTON3;break;
		case 4 : Style |= MB_DEFBUTTON4;break;

	}
	}
	char Msg[999];
	GetDlgItemText(IDC_EDIT2,Msg,1000);
/*Lautsprecher  
SystemAsterisk 
SystemExclamation 
SystemHand 
SystemQuestion 
Voreinstellung
	*/	
	
	if ((m_Code.GetCurSel() != 4) && (m_MessageBeep.GetCheck()) ) 
	{
		int Scale = 0xFFFFFFFF;
	    if (m_SndType.GetCurSel() == 5)
		{
			if (m_Stop.GetCheck())		   Scale = MB_ICONHAND;
			if (m_Question.GetCheck())	   Scale = MB_ICONQUESTION;
			if (m_Information.GetCheck())  Scale = MB_ICONINFORMATION;
			if (m_Exclamation.GetCheck())  Scale = MB_ICONEXCLAMATION;
		}
		else
			switch (m_SndType.GetCurSel())
		{
			case 1 : Scale = MB_ICONASTERISK ;break;
			case 2 : Scale = MB_ICONEXCLAMATION;break;
			case 3 : Scale = MB_ICONHAND ;break;
			case 4 : Scale = MB_ICONQUESTION ;break;
		}

	
		MessageBeep(Scale);
	}

	int ret = MessageBox(Msg,Title,Style);

	if ((m_Code.GetCurSel() != 4) &&(m_MessageBeep.GetCheck()))  MessageBeep(0);
	
	CString s,s2;
	s2 = "%s (%i)";
	switch (ret)
	{
	case IDABORT : s.Format(s2,"IDABORT",ret);break;
	case IDCANCEL: s.Format(s2,"IDCANCEL",ret);break;
	case IDIGNORE: s.Format(s2,"IDIGNORE",ret);break;
	case IDNO    : s.Format(s2,"IDNO"    ,ret);break;
	case IDOK    : s.Format(s2,"IDOK",ret);break;
	case IDRETRY : s.Format(s2,"IDRETRY",ret);break;
	case IDYES	 : s.Format(s2,"IDYES",ret);break;
	default : s.Format(s2,"?",ret);break;
	}
	
	
	m_Return.SetWindowText(s);
	WriteData();

	
}

void CMsgBoxDlg::OnSelchangeCombo2() 
{
	// TODO: Add your control notification handler code here
	if (m_Code.GetCurSel() == 2 ||m_Code.GetCurSel() == 3)
	{
		m_TOPMOST.SetCheck(FALSE);
		m_TOPMOST.EnableWindow(FALSE);
		m_Help_Button.SetCheck(FALSE);
		m_Help_Button.EnableWindow(FALSE);
		SetRightSlider1();
	}
	else
	{
		m_TOPMOST.EnableWindow();
		m_Help_Button.EnableWindow();
	}	

	if (m_Code.GetCurSel() == 4)
	{
		m_TOPMOST.SetCheck(FALSE);
		m_TOPMOST.EnableWindow(FALSE);
		SetRightSlider1();
        m_MessageBeep.EnableWindow(FALSE);
	    m_TaskModal.EnableWindow(FALSE);
	    m_SystemModal.EnableWindow(FALSE);
	    m_ApplModal.EnableWindow(FALSE);
		m_DefinesCount.SetPos(1);
		m_DefinesCount.EnableWindow(FALSE);
		m_Title.EnableWindow(FALSE);
	}
	else
	{
		m_TOPMOST.EnableWindow();
		m_TOPMOST.EnableWindow();
        m_MessageBeep.EnableWindow();
	    m_TaskModal.EnableWindow();
	    m_SystemModal.EnableWindow();
	    m_ApplModal.EnableWindow();
		m_DefinesCount.EnableWindow();
		m_Title.EnableWindow();
		SetRightSlider1();
	}	
	
}

void CMsgBoxDlg::OnLoadsave() 
{
	// TODO: Add your control notification handler code here
	CString s1,s2;
	m_Message.GetWindowText(s1);
	m_Title.GetWindowText(s2);
	
	CDataDlg dlg;
	dlg.SetDataHandler(s1,s2);
	//dlg.DataObj
	
	dlg.DataObj.IconType = 0;
	if (m_Stop.GetCheck())		   dlg.DataObj.IconType = 1;
	if (m_Question.GetCheck())	   dlg.DataObj.IconType = 2;
	if (m_Information.GetCheck())  dlg.DataObj.IconType = 3;
	if (m_Exclamation.GetCheck())  dlg.DataObj.IconType = 4;
	
	
	dlg.DataObj.Button1 = FALSE;
	dlg.DataObj.Button2 = FALSE;
	dlg.DataObj.Button3 = FALSE;
	dlg.DataObj.Button4 = FALSE;
	dlg.DataObj.Button5 = FALSE;
	dlg.DataObj.Button6 = FALSE;
	dlg.DataObj.Button7 = FALSE;

	
	if (m_Ok_Button.GetCheck()==1) dlg.DataObj.Button1 = TRUE;
	if (m_Cancel_Button.GetCheck()==1)	dlg.DataObj.Button2 = TRUE;
	if (m_Help_Button.GetCheck()==1)	dlg.DataObj.Button3 = TRUE;
	if (m_Yes_No_Button.GetCheck()==1)	dlg.DataObj.Button4 = TRUE;
	if (m_Yes_No_Cancel_Button.GetCheck()==1)dlg.DataObj.Button5 = TRUE;
	if (m_Retry_Button.GetCheck()==1) dlg.DataObj.Button6 = TRUE;
	if (m_Abort_Retry_Ignore_Button.GetCheck()==1) dlg.DataObj.Button7 = TRUE;

	dlg.DataObj.DefaultButton = m_DefinesCount.GetPos();
	
	dlg.DataObj.TopMost = FALSE;
	if (m_TOPMOST.GetCheck()==1) dlg.DataObj.TopMost = TRUE;
	
	dlg.DataObj.Sound = m_MessageBeep.GetCheck();

	dlg.DataObj.SoundType = m_SndType.GetCurSel();

	dlg.DataObj.Modal = 0;
	if (m_ApplModal.GetCheck())	   dlg.DataObj.Modal = 1;
	if (m_TaskModal.GetCheck())  dlg.DataObj.Modal = 2;
	if (m_SystemModal.GetCheck()) dlg.DataObj.Modal = 3;
	



	int ret = dlg.DoModal();
	if (ret == IDABORT)
	{
		CDataObj *Data = dlg.RetData;
		if (!Data) goto failure;
		
		m_Stop.SetCheck(FALSE)		   ;
		m_Question.SetCheck(FALSE)	   ;
		m_Information.SetCheck(FALSE)  ;
		m_Exclamation.SetCheck(FALSE)  ;
		m_NoIcon.SetCheck(FALSE)  ;
		
		switch (Data->IconType)
		{
			case 1 :{m_Stop.SetCheck(TRUE)		   ;break;}
			case 2 :{m_Question.SetCheck(TRUE)	   ;break;}
			case 3 :{m_Information.SetCheck(TRUE)  ;break;}
			case 4 :{m_Exclamation.SetCheck(TRUE)  ;break;}
			default :{ m_NoIcon.SetCheck(TRUE)  ;break;}
		}
	
		m_Ok_Button.SetCheck(FALSE);
		m_Cancel_Button.SetCheck(FALSE);
		m_Help_Button.SetCheck(FALSE);
		m_Yes_No_Button.SetCheck(FALSE)	;
		m_Yes_No_Cancel_Button.SetCheck(FALSE);
		m_Retry_Button.SetCheck(FALSE);
		m_Abort_Retry_Ignore_Button.SetCheck(FALSE);

	m_Ok_Button.EnableWindow(TRUE);
	m_Abort_Retry_Ignore_Button.EnableWindow(TRUE);
	m_Retry_Button.EnableWindow(TRUE);
	m_Yes_No_Cancel_Button.EnableWindow(TRUE);
	m_Yes_No_Button.EnableWindow(TRUE);
	m_Help_Button.EnableWindow(TRUE);
	m_Cancel_Button.EnableWindow(TRUE);


		if (Data->Button1){m_Ok_Button.SetCheck(TRUE);		OnCheck1();}
		if (Data->Button2){m_Cancel_Button.SetCheck(TRUE);OnCheck2();}
		if (Data->Button3){m_Help_Button.SetCheck(TRUE);OnCheck3();}
		if (Data->Button4){m_Yes_No_Button.SetCheck(TRUE)	;OnCheck4();}
		if (Data->Button5){m_Yes_No_Cancel_Button.SetCheck(TRUE);}
		if (Data->Button6){m_Retry_Button.SetCheck(TRUE);OnCheck5();}
		if (Data->Button7){m_Abort_Retry_Ignore_Button.SetCheck(TRUE);OnCheck6();}
		
		m_DefinesCount.SetPos(Data->DefaultButton);
		m_TOPMOST.SetCheck(Data->TopMost);
		m_MessageBeep.SetCheck(Data->Sound);

	
/*Lautsprecher  
SystemAsterisk 
SystemExclamation 
SystemHand 
SystemQuestion 
Voreinstellung*/

		m_SndType.SetCurSel(Data->SoundType) ;
		m_ApplModal.SetCheck(FALSE);
		m_TaskModal.SetCheck(FALSE);
		m_SystemModal.SetCheck(FALSE);
		
		m_SystemModal.EnableWindow();
		m_TaskModal.EnableWindow();
		m_ApplModal.EnableWindow();
		switch (Data->Modal)
		{
			case 1: m_ApplModal.SetCheck(TRUE);OnApplmodal() ;break;
			case 2: m_TaskModal.SetCheck(TRUE);OnTaskmodal() ;break;
			case 3: m_SystemModal.SetCheck(TRUE) ;OnSystemlmodal(); break;
		}

		CString s;
		s.Format("%i",m_DefinesCount.GetPos());
		m_DefCount.SetWindowText(s);
		OnMessagebeep(); 

		m_Title.SetWindowText(Data->Caption);
		m_Message.SetWindowText(Data->Message);
		
		/*SetRightSlider1();
		OnSelchangeCombo2();
		OnMessagebeep(); 
		OnTaskmodal() ;
		OnReanicombo() ;
		OnSystemlmodal(); 
		OnApplmodal() ;
		OnChangeEdit3() ;*/
	}
failure:;
}

void CMsgBoxDlg::OnDelete() 
{
	// TODO: Add your control notification handler code here
	if (MessageBox("Wollen Sie ihre aktuellen Daten wirklich löschen?\nHinweis:\n              Es werden nur die Daten im Dialogfenster restauriert.\n              Dabei wird an der aktuellen geöffneten Datei nichts\n              verändert!","Daten löschen",MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2 | 0)
		==IDNO) return;
	
	m_Stop.SetCheck(FALSE);
	m_Question.SetCheck(FALSE);
	m_Information.SetCheck(TRUE);
	m_Exclamation.SetCheck(FALSE);
	m_NoIcon.SetCheck(FALSE);

	m_Abort_Retry_Ignore_Button.SetCheck(FALSE);
	m_Retry_Button.SetCheck(FALSE);
	m_Yes_No_Cancel_Button.SetCheck(FALSE);
	m_Yes_No_Button.SetCheck(FALSE);
	m_Help_Button.SetCheck(FALSE);
	m_Cancel_Button.SetCheck(FALSE);

	m_Ok_Button.SetCheck(TRUE);
	m_Ok_Button.EnableWindow();
	OnCheck1();

	m_Return.SetWindowText("Kein Wert");
	
	
	CString s;
	s.Format("%i",m_DefinesCount.GetPos());
	m_DefCount.SetWindowText(s);
	
	
	m_SndType.SetCurSel(0);
	OnMessagebeep() ;
	
	

	m_Code.SetCurSel(1);
	m_Message.LimitText(999);
	m_Message.SetWindowText("");
	m_Title.SetWindowText("");
	m_CopyEdit.SetWindowText("");
	
	OnChangeEdit3() ;
	m_DefinesCount.SetPos(1);
	SetRightSlider1();
	m_TOPMOST.SetCheck(FALSE);
	m_MessageBeep.SetCheck(FALSE);
	m_ReAniCombo.EnableWindow(FALSE);
	m_SndType.EnableWindow(FALSE);


	m_TaskModal.SetCheck(FALSE);
	m_TaskModal.EnableWindow(TRUE);
	m_ApplModal.SetCheck(FALSE);
	m_ApplModal.EnableWindow(TRUE);
	m_SystemModal.SetCheck(FALSE);
	m_SystemModal.EnableWindow(TRUE);


	
	

}

void CMsgBoxDlg::OnContextMenu(CWnd*, CPoint point)
{

	// CG: This block was added by the Pop-up Menu component
	{
		if (point.x == -1 && point.y == -1){
			//keystroke invocation
			CRect rect;
			GetClientRect(rect);
			ClientToScreen(rect);

			point = rect.TopLeft();
			point.Offset(5, 5);
		}

		CMenu menu;
		VERIFY(menu.LoadMenu(CG_IDR_POPUP_MSG_BOX_DLG));

		CMenu* pPopup = menu.GetSubMenu(0);
		ASSERT(pPopup != NULL);
		CWnd* pWndPopupOwner = this;

		while (pWndPopupOwner->GetStyle() & WS_CHILD)
			pWndPopupOwner = pWndPopupOwner->GetParent();

		pPopup->TrackPopupMenu(TPM_LEFTALIGN | TPM_RIGHTBUTTON, point.x, point.y,
			pWndPopupOwner);
	}
}


void CMsgBoxDlg::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar) 
{
	// TODO: Add your message handler code here and/or call default
	m_Scroller->OnVScroll(nSBCode,nPos,pScrollBar);	
//	CDialog::OnVScroll(nSBCode, nPos, pScrollBar);
}

CMsgBoxDlg::~CMsgBoxDlg()
{
	DoneList();
	delete m_Scroller;
}

 

void CMsgBoxDlg::OnPopupNeudarstellen() 
{
	// TODO: Add your command handler code here
	int y = GetSystemMetrics(SM_CYFULLSCREEN);
	//int x = GetSystemMetrics(SM_CXFULLSCREEN);
	int sx = GetSystemMetrics(SM_CXHSCROLL);
/*	if (Screen.cx == y) 
	{	
		Invalidate(0);
		return;
	}*/
	Screen.cx = y;
	CRect r;
	GetWindowRect(r);
	int w = 0;
	w = DIALOGWIDTH;
	
	m_Scroller->ShowScroller(FALSE,FALSE);
	if (y <= DIALOGHEIGHT)
	{
		m_Scroller->EnableScroller(FALSE,TRUE);
		
		w+=sx;
			
		CPoint p;
		p = m_Scroller->GetPos();
		//m_Scroller->ScrollWndVertical(p.y,FALSE);
		SetScrollPos(SB_VERT,-p.y);
		p = m_Scroller->GetPos();
		
        MoveWindow(r.TopLeft().x,r.TopLeft().y,
			       w,
				   y);
		

		CRect r2,r3,r3a,r4;
		GetClientRect(r4);
		//GetWindowRect(r4);
		//m_PosCtrl.GetClientRect(r3);
		//m_Scroller->GetWindowRect(r3a);
		int DropBtnH = GetSystemMetrics(SM_CXHSCROLL);
		int xy = r4.bottom - DIALOGHEIGHT - DropBtnH*2;
		if (xy < 0) xy = -xy;
			
			//			r2.BottomRight().y;
			//r2.BottomRight().y+r2.Right().y;
		
		m_Scroller->SetVertRange(0,xy);
		m_Scroller->ShowScroller(FALSE,TRUE);
	    
		//SetScrollPos(SB_VERT,p.y,TRUE);
		UpdateWindow();
		
	}
	else
	{
		CRect r;
		GetWindowRect(r);

		CPoint p;
		p = m_Scroller->GetPos();
		m_Scroller->ScrollWndVertical(p.y,1);
//		m_Scroller->SetVertRange(1,1);
		
		MoveWindow(r.TopLeft().x,r.TopLeft().y
			       ,DIALOGWIDTH,683);
		m_Scroller->ShowScroller(FALSE,FALSE);
	}

	Screen.cy = sx;
	UpdateWindow();

}


void CMsgBoxDlg::OnStandard() 
{
	// TODO: Add your control notification handler code here
	CString s1,s2;
	CDataDlg dlg;
	dlg.DisableForStandard();
	int ret = dlg.DoModal();
	
//	if (ret == IDABORT)
	
}



LRESULT CMsgBoxDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	// TODO: Add your specialized code here and/or call the base class
	switch(message)
	{
	case WM_DISPLAYCHANGE : {
							  OnPopupNeudarstellen();						      
						      break;
							}

	}
	return CDialog::WindowProc(message, wParam, lParam);
}

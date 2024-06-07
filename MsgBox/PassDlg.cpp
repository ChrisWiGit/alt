// PassDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MsgBox.h"
#include "PassDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPassDlg dialog


CPassDlg::CPassDlg(CString PWord,BOOL Get,CWnd* pParent /*=NULL*/)
	: CDialog(CPassDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPassDlg)
	//}}AFX_DATA_INIT
	pWord = PWord;
	GetWord = Get;
	m_Return = FALSE;
}


void CPassDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPassDlg)
	DDX_Control(pDX, IDC_DELETE, m_Delete);
	DDX_Control(pDX, IDC_STATIC1, m_Head);
	DDX_Control(pDX, IDC_EDIT2, m_PassedWord);
	DDX_Control(pDX, IDC_EDIT1, m_PassWord);
	DDX_Control(pDX, IDOK, m_Ok);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPassDlg, CDialog)
	//{{AFX_MSG_MAP(CPassDlg)
	ON_EN_CHANGE(IDC_EDIT1, OnChangeEdit1)
	ON_EN_CHANGE(IDC_EDIT2, OnChangeEdit2)
	ON_BN_CLICKED(IDC_DELETE, OnDelete)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPassDlg message handlers

void CPassDlg::OnOK() 
{
	// TODO: Add extra validation here
//	CString c1("CHRISTIAN"),c2("WIMMER");
	CString s,s2;
	m_PassWord.GetWindowText(s);
	m_PassedWord.GetWindowText(s2);

	if (s != s2 )
		//&& s2 != c2 && s != c1)
	{
		MessageBox("Ihr Kennwort und ihre Bestätigung stimmen nicht überein.\n","Kennwortbestätigung",MB_OK | MB_ICONEXCLAMATION | MB_DEFBUTTON1 | 0);
		return;
	}
	
	if (
		//s2 != c2 && s != c1 && 
		GetWord && (s2 != pWord)  && m_Return == FALSE)
	{
		MessageBox("Ihr Kennwort ist falsch.\n","Zugriffsverweigerung",MB_OK | MB_ICONEXCLAMATION | MB_DEFBUTTON1 | 0);
		EndDialog(IDABORT);
		return;
	}
	pWord = s;
	CDialog::OnOK();
}

BOOL CPassDlg::GetPassword(CString & PassWord)
{
	PassWord = pWord;
	return TRUE;
}

void CPassDlg::OnChangeEdit1() 
{
	// TODO: If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function to send the EM_SETEVENTMASK message to the control
	// with the ENM_CHANGE flag ORed into the lParam mask.
	
	// TODO: Add your control notification handler code here
	if (m_PassedWord.LineLength() <= 0 || m_PassWord.LineLength() <= 0)
		m_Ok.EnableWindow(FALSE);
	else
		m_Ok.EnableWindow();
	
}

void CPassDlg::OnChangeEdit2() 
{
	// TODO: If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function to send the EM_SETEVENTMASK message to the control
	// with the ENM_CHANGE flag ORed into the lParam mask.
	
	// TODO: Add your control notification handler code here
	if (m_PassedWord.LineLength() <= 0 || m_PassWord.LineLength() <= 0)
		m_Ok.EnableWindow(FALSE);
	else
		m_Ok.EnableWindow();	
}


void CPassDlg::OnDelete() 
{
	// TODO: Add your control notification handler code here
	if (MessageBox("Wollen Sie das Kennwort löschen?\n","Kennwort löschen",MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2 | 0)
		==IDNO) return;
	m_PassWord.SetWindowText("");
	EndDialog(IDYES);
}

BOOL CPassDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	if (GetWord || pWord.GetLength() == 0)
		m_Delete.EnableWindow(FALSE);
	

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CPassDlg::DoReturn(BOOL YES)
{
	m_Return = YES;

}

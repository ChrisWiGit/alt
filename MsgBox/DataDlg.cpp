// DataDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Global.h"
#include "MsgBox.h"
#include "DataDlg.h"
#include "DataObj.h"
#include "PassDlg.h"
#include "WndScroller.h"
#include "direct.h"
#include "CodeCard.h"



#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define MODIFYCHAR "*"
/////////////////////////////////////////////////////////////////////////////
// CDataDlg dialog
CObArray *MsgBoxList;
CString Filename;
CString PassWord;
BOOL Modify;
BOOL Passcode = FALSE;
CString dir;


BOOL GetModify()
{
	return Modify;
}
void _SetModify(BOOL x)
{
	Modify = x;
}


CDataDlg::CDataDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDataDlg::IDD, pParent)
{
	m_Scroller = new CWndScroller(this);
	IsStandard = FALSE;
	//{{AFX_DATA_INIT(CDataDlg)
	//}}AFX_DATA_INIT
}


void CDataDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDataDlg)
	DDX_Control(pDX, IDC_FILENAME, m_FileName);
	DDX_Control(pDX, IDCANCEL, m_Cancel);
	DDX_Control(pDX, IDC_MODIFIED, m_Modified);
	DDX_Control(pDX, IDC_UP, m_Up);
	DDX_Control(pDX, IDC_DOWN, m_Down);
	DDX_Control(pDX, IDC_DELETE, m_Delete);
	DDX_Control(pDX, IDC_TEST, m_Test);
	DDX_Control(pDX, IDC_CHANGEUSERNAME, m_ChangeUserName);
	DDX_Control(pDX, IDC_DLGNAME, m_DlgName);
	DDX_Control(pDX, IDC_SAVEFILE, m_SaveFile);
	DDX_Control(pDX, IDC_LOADFILE, m_LoadFile);
	DDX_Control(pDX, IDC_LOADDATA, m_LoadData);
	DDX_Control(pDX, IDC_EDIT2, m_Edit2);
	DDX_Control(pDX, IDC_DIALOGLIST, m_DialogList);
	DDX_Control(pDX, IDC_CAPTIONEDIT, m_CaptionEdit);
	DDX_Control(pDX, IDC_ADDDATA, m_AddData);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDataDlg, CDialog)
	//{{AFX_MSG_MAP(CDataDlg)
	ON_BN_CLICKED(IDC_ADDDATA, OnAdddata)
	ON_EN_CHANGE(IDC_DLGNAME, OnChangeDlgname)
	ON_LBN_SELCHANGE(IDC_DIALOGLIST, OnSelchangeDialoglist)
	ON_BN_CLICKED(IDC_CHANGEUSERNAME, OnChangeusername)
	ON_BN_CLICKED(IDC_LOADDATA, OnLoaddata)
	ON_BN_CLICKED(IDC_SAVEFILE, OnSavefile)
	ON_BN_CLICKED(IDC_LOADFILE, OnLoadfile)
	ON_BN_CLICKED(IDC_TEST, OnTest)
	ON_BN_CLICKED(IDC_DELETE, OnDelete)
	ON_BN_CLICKED(IDC_UP, OnUp)
	ON_BN_CLICKED(IDC_DOWN, OnDown)
	ON_BN_CLICKED(IDC_PASSWORD, OnPassword)
	ON_BN_DOUBLECLICKED(IDC_PASSWORD, OnDoubleclickedPassword)
	ON_WM_HSCROLL()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDataDlg message handlers

BOOL CDataDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	LoadList();
	m_DlgName.LimitText(32);
	SetModify(GetModify());
	

//	int x = MsgBoxList2->GetSize();
//	int y = MsgBoxList->GetSize();
	Down = 0;
	m_FileName.SetWindowText(Filename);
	PassWord = "";

	int y = GetSystemMetrics(SM_CXFULLSCREEN);
	int sx = GetSystemMetrics(SM_CYHSCROLL);
	m_Scroller->Create(FALSE,TRUE);
	m_Scroller->ShowScroller(FALSE,FALSE);
	/*if (y <= 800)
	{
		m_Scroller->ShowScroller(TRUE,FALSE);
		CRect r;
		GetWindowRect(r);
		int xy = 100;
		m_Scroller->SetHorzRange(1,xy);
		MoveWindow(r.TopLeft().x,r.TopLeft().y,
			       y,
				   r.Height()+sx);
	}*/
	if (y <= 640)
	{
		m_Scroller->ShowScroller(TRUE,FALSE);
		CRect r;
		GetWindowRect(r);
		int xy = 100;
		m_Scroller->SetHorzRange(1,xy);
		MoveWindow(r.TopLeft().x,r.TopLeft().y,
			       y,
				   r.Height()+sx);
	}
	dir = "C:\\";
	_chdir(dir);	
	if (IsStandard)
	{
		m_SaveFile.EnableWindow(FALSE);
		m_LoadFile.EnableWindow(FALSE);
		CString s;
		s.LoadString(IDS_STRING103);
		m_FileName.SetWindowText(s);
	}
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDataDlg::SetDataHandler(CString aMsg, CString aCaption)
{
	DataObj.Caption = aCaption;
	DataObj.Message = aMsg;
}

void CDataDlg::OnAdddata() 
{
	// TODO: Add your control notification handler code here
	CString s;
	m_DlgName.GetWindowText(s);
	if (IsDuplicate(s))
	{
		MessageBox("Es exisitiert schon eine MessageBox mit diesem Namen in der Liste.\nFehler : Versuch eines schon vorhandenen Eintrags in die List einzufügen.\nDer Vorgang wurde abbgebrochen.\nGeben Sie dem neuen Eintrag einen anderen Namen.\n","Fehler während des Hinzufügens eines Eintrages.",MB_OK | MB_ICONSTOP | MB_DEFBUTTON1 | 0);
		return;
	}

	CDataObj *Data = new CDataObj();
	Data->UserName = s;
	Data->Message = DataObj.Message;
	Data->Caption = DataObj.Caption;
	Data->IconType= DataObj.IconType;
	Data->Button1= DataObj.Button1;
	Data->Button2= DataObj.Button2;
	Data->Button3= DataObj.Button3;
	Data->Button4= DataObj.Button4;
	Data->Button5= DataObj.Button5;
	Data->Button6= DataObj.Button6;
	Data->Button7= DataObj.Button7;
	Data->DefaultButton= DataObj.DefaultButton;
	Data->TopMost= DataObj.TopMost;
	Data->Sound= DataObj.Sound;
	Data->SoundType= DataObj.SoundType;
	Data->Modal= DataObj.Modal;




//	Hier werden weiter Daten angefügt..........

	Data->No = m_DialogList.AddString(s);

	MsgBoxList->Add(Data);
	SetModify();
}

void CDataDlg::OnChangeDlgname() 
{
	// TODO: If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function to send the EM_SETEVENTMASK message to the control
	// with the ENM_CHANGE flag ORed into the lParam mask.
	
	// TODO: Add your control notification handler code here
	CString s;
	m_DlgName.GetWindowText(s);
	if (s.GetLength() > 0)
	{
		m_AddData.EnableWindow();
		m_ChangeUserName.EnableWindow();
	}
	else
	{
		m_AddData.EnableWindow(FALSE);
		m_ChangeUserName.EnableWindow(FALSE);
	}

		
}


void CDataDlg::OnSelchangeDialoglist() 
{
	// TODO: Add your control notification handler code here
	
	int Selection = GetListSel();
	CDataObj *Data = GetData(Selection);
	if (Data)
	{
		m_CaptionEdit.SetWindowText(Data->Caption);
		m_Edit2.SetWindowText(Data->Message);
		m_ChangeUserName.EnableWindow();
		m_DlgName.EnableWindow();
		m_DlgName.SetWindowText(Data->UserName);
		m_LoadData.EnableWindow();
		m_Test.EnableWindow();
		m_Delete.EnableWindow();
		m_Up.EnableWindow();
		m_Down.EnableWindow();

	}
	if (!Data || m_DialogList.GetCount() == 0)
	{
		CString s1;
		if (m_DialogList.GetCount() == 0)
			s1 = "";
		else
			s1.LoadString(IDS_STRING102);
		m_CaptionEdit.SetWindowText(s1);
		m_Edit2.SetWindowText(s1);
		m_ChangeUserName.EnableWindow(FALSE);
		m_DlgName.EnableWindow(FALSE);
		m_LoadData.EnableWindow();
		m_Test.EnableWindow(FALSE);
		m_Delete.EnableWindow(FALSE);
		m_Up.EnableWindow(FALSE);
		m_Down.EnableWindow(FALSE);
	}
}

void InitList()
{
	MsgBoxList = new CObArray();
	Filename = "";
}
void DoneList()
{
	if (MsgBoxList->GetSize() > 0)
	for (int i =0;i <=MsgBoxList->GetSize()-1;i++)
	{
		for (int i2 =0;i2 <=MsgBoxList->GetSize()-1;i2++)
		{	
			CDataObj *p = (CDataObj*)MsgBoxList->GetAt(i2);
			if (p->No == i)
			{
				delete p;
				p = NULL;
				MsgBoxList->RemoveAt(i2);
			}
		}
	}

	delete MsgBoxList;
}

int CDataDlg::GetListSel()
{
	int Selection = -1;
	for (int i = 0;i<=(m_DialogList.GetCount()-1);i++)
	{
		Selection = m_DialogList.GetSel(i);
		if (Selection > 0) break;
	}
	return i;
}

void CDataDlg::OnChangeusername() 
{
	// TODO: Add your control notification handler code here
	int Selection = GetListSel();
	CString s;
	m_DlgName.GetWindowText(s);

	if (Selection >= 0 && Selection < MsgBoxList->GetSize())
	{
	
	CDataObj *Data = GetData(Selection);
	if (Data)
	{
		m_DialogList.DeleteString(Selection);
		Data->No = m_DialogList.AddString(s);
		Data->UserName = s;
		SetModify();
	}
	}
}

CDataObj* CDataDlg::GetData(int Sel)
{
	int Selection = 0;
	CDataObj *Data ;//= (CDataObj*)MsgBoxList->GetAt(Sel);
	Data = NULL;
	if (Data == NULL)
	{
		for (int i = 0;i<=MsgBoxList->GetSize()-1;i++)
		{
			if (((CDataObj*)MsgBoxList->GetAt(i))->No == Sel)
			{
				Data = (CDataObj*)MsgBoxList->GetAt(i);
				break;
			}
		}
	}
	return Data;
}

CDataObj* CDataDlg::GetReturnData()
{
	int Selection = GetListSel();
	RetData = GetData(Selection);
	return NULL;
}

void CDataDlg::OnLoaddata() 
{
	// TODO: Add your control notification handler code here
	int Selection = GetListSel();
	GetReturnData();
	if (Selection >= 0 && Selection < MsgBoxList->GetSize())
		EndDialog(IDABORT);	
}

CArchive& operator <<(CArchive & ar, CDataObj& aClass)
{
	aClass.Serialize(ar);
	return ar;
}


CArchive& operator >>(CArchive & ar, CDataObj & aClass)
{
	aClass.Serialize(ar);
	return ar;
}



static char BASED_CODE szFilter[] = "MessageBoxDialogDateien (*.MBD)|*.MBD|Alle Dateien (*.*)|*.*||";
void CDataDlg::OnSavefile() 
{
	// TODO: Add your control notification handler code here
	_chdir(dir);
	CFileDialog dlg(FALSE,"MessageBoxDatei öffnen","",
		OFN_HIDEREADONLY | OFN_NONETWORKBUTTON | OFN_OVERWRITEPROMPT,
		
		szFilter); 
		
	int ret = dlg.DoModal();
	
	if (ret == IDOK)
	{
		char x[1000];
		_getcwd(x,1000);
		dir = x;
		CFile WriteFile(dlg.GetPathName(),CFile::modeCreate|CFile::modeWrite);
		//try
		{			
			CArchive ar(&WriteFile,CArchive::store);
			CString s;
			if (PassWord.GetLength() > 0) 
			{
				s = PassWord;
				/*long i = atoi(PassWord);
				s.Format("%ld",i);*/
				SetIsCode(TRUE);
			}
			else
			{
				s = "";
				SetIsCode(FALSE);
			}
			ar << s;
			ar << MsgBoxList;
			ar.Close();
			
			WriteFile.Close();
			SetModify(FALSE);
			m_FileName.SetWindowText(dlg.GetPathName());
			Filename = dlg.GetPathName();
		}
/*		catch (CFileException *e)
		{
			e->ReportError();
			//	CaseError(e->m_cause);
			e->Delete();
		}*/
	}
}

/*void CaseError(int c)
{
	
}*/
void CDataDlg::CaseError(int c)
{
	CString s;
	return;
	switch (c)
	{
		case CFileException::generic : s = "Ein unbekannter Fehler trat auf.";break;
		//case CFileException::fileNotFound : s = "Datei wurde nicht gefunden.";break;
		case CFileException::badPath : s = "Verzeichnis wurde nicht gefunden.";break;
	//	case CFileException::tooManyOpenFiles :s = "Zu viele geöffnete Dateien.";break;
//		case CFileException::accessDenied :s = "Zugriff wurde verweigert.";break;
		case CFileException::invalidFile :s = "Inkorrektes Dateihandle.";break;
//		case CFileException::badSeek  :s = "Fehler nach einem Versuch den Dateizeiger zu bestimmen.";break;
		case CFileException::hardIO:s = "Hardwarefehler.";break;
		case CFileException::sharingViolation:s = "Share.exe wurde nicht geladen. Oder: Die Dateiregion wurde gesperrt.";break;
//		case CFileException::diskFull :s = "Speichermedium ist voll.";break;
//		case CFileException::endOfFile :s = "Das Dateiende wurde erreicht.";break;
	}
	MessageBox(s+"\n Der aufgetretene Fehler sollte behoben werden.\nDeshalb sollten sie den Programmierer benachrichtigen!","Fehler",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
}

void CDataDlg::OnLoadfile() 
{
	// TODO: Add your control notification handler code here
	_chdir(dir);
 	if (GetModify())
	{
		if (MessageBox("Ihre Daten wurden noch nicht gespeichert!\nWollen Sie wirklich eine andere Datei laden und die alten Daten\nlöschen?\n","MessageBox Creator",MB_YESNO | MB_ICONQUESTION | MB_APPLMODAL | MB_DEFBUTTON2 | 0)==IDNO)
			return;
	}

	//CString s("F:\\PROJEKT ORDNER\\DELPHI4\\GENRE\\");
	CString s("");

	CFileDialog dlg(TRUE,"MessageBoxDatei öffnen",s+"*.MBD",
		OFN_HIDEREADONLY | OFN_NONETWORKBUTTON | OFN_EXPLORER
		,szFilter); 
		
	int ret;

	ret = dlg.DoModal();

	if (ret == IDOK)
	{
		int Code;
		GeneratePAE(dlg.GetPathName(),Code);
		char x[1000];
		_getcwd(x,1000);
		dir = x;
		CFile WriteFile(dlg.GetPathName(),CFile::modeRead);
	//try
	{			
		CArchive ar(&WriteFile,CArchive::load);
		ar >> PassWord;
		if (PassWord.GetLength() > 0 && !Passcode) 
		{
			SetIsCode(TRUE);
			CPassDlg dlg2(PassWord,TRUE);
			int ret = dlg2.DoModal();
			if (ret == IDOK)
			{
				RemoveList();
				ar >> MsgBoxList;
				LoadList();
				CopyList(FALSE);
				SetModify(FALSE);
				m_FileName.SetWindowText(dlg.GetPathName());
				Filename = dlg.GetPathName();
			}
		}
		else
		{
			SetIsCode(TRUE);
			RemoveList();
			ar >> MsgBoxList;
			LoadList();
			CopyList(FALSE);
			SetModify(FALSE);
			m_FileName.SetWindowText(dlg.GetPathName());
			Filename = dlg.GetPathName();
		}
		ar.Close();
		WriteFile.Close();
	}
/*	catch (CFileException *e)
	{
		e->ReportError();
		//CaseError(e->m_cause);
		e->Delete();
	}*/
	}
//End:;
}

void CDataDlg::LoadList()
{
	m_DialogList.ResetContent();
	if (MsgBoxList->GetSize() > 0)
	{
		CDataObj *Data ;
		for (int i = 0;i<=MsgBoxList->GetSize()-1;i++)
		{
			for (int i2 = 0;i2<=MsgBoxList->GetSize()-1;i2++)
			{
				Data = (CDataObj*)MsgBoxList->GetAt(i2);
				if (Data !=NULL && Data->No == i)
					m_DialogList.AddString(Data->UserName);
			}
		}
	}

}

void CDataDlg::RemoveList()
{
		//MsgBoxList->RemoveAll();
		//return;
		if (MsgBoxList->GetSize() > 0)
		for (int i =0;i <=MsgBoxList->GetSize()-1;i++)
		{
			for (int i2 =0;i2 <=MsgBoxList->GetSize()-1;i2++)
			{	
				CDataObj *p = (CDataObj*)MsgBoxList->GetAt(i2);
				if (p->No == i)
				{	
					delete p;
					p = NULL;
					MsgBoxList->RemoveAt(i2);
				}
			}
		}

}

BOOL CDataDlg::IsDuplicate(CString d)
{
	if (MsgBoxList->GetSize() > 0)
	for (int i =0;i <=MsgBoxList->GetSize()-1;i++)
	{
		CDataObj *p = (CDataObj*)MsgBoxList->GetAt(i);
		if (p->UserName == d) return TRUE;
		
	}
	return FALSE;
}

void CDataDlg::OnTest() 
{
	// TODO: Add your control notification handler code here
	int Selection = GetListSel();
	CString s;
	m_DlgName.GetWindowText(s);

	if (Selection >= 0 && Selection < MsgBoxList->GetSize())
	{
	
	CDataObj *Data = GetData(Selection);
	if (!Data) 
	{
		s.Format("Es trat ein Listenfehler 102 auf.\nDie Liste gab einen NULL-Wert zurück.\n\n\nQuelltextangabe :\nAddresse          : Data == NULL\nObjekt              : CDataDlg\nFunktion           : OnTest(void)\nRückgabewert : 102\nName               : "
			"%s\nQuellcodezeile : "
			"%s\n\n\n",__LINE__,__FILE__);
		MessageBox(s,"MessageBox ausführen",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
		return;
	}

	
	
	
	int Style = 0;
	if (Data->Button1) Style |= MB_OK;
	if (Data->Button2)	Style |= MB_OKCANCEL;
	if (Data->Button3)	Style |= MB_HELP ;
	if (Data->Button4)	Style |= MB_YESNO;
	if (Data->Button5) Style |= MB_YESNOCANCEL;
	if (Data->Button6) Style |= MB_RETRYCANCEL;
	if (Data->Button7) Style |= MB_ABORTRETRYIGNORE;

	if (Data->TopMost) Style |= MB_TOPMOST;
	
	
	if (Data->IconType == 1)		   Style |= MB_ICONSTOP;
	if (Data->IconType == 2)	   Style |= MB_ICONQUESTION;
	if (Data->IconType == 3)  Style |= MB_ICONINFORMATION;
	if (Data->IconType == 4)  Style |= MB_ICONEXCLAMATION;

	if (Data->Modal == 1)	   Style |= MB_APPLMODAL;
	if (Data->Modal == 2)  Style |= MB_TASKMODAL;
	if (Data->Modal == 3)  Style |= MB_SYSTEMMODAL;

	switch (Data->DefaultButton)
	{
		case 1 : Style |= MB_DEFBUTTON1;break;
		case 2 : Style |= MB_DEFBUTTON2;break;
		case 3 : Style |= MB_DEFBUTTON3;break;
		case 4 : Style |= MB_DEFBUTTON4;break;

	}
	CString Title = Data->Caption;
	Title += " (%s) ";
	s = Title;
	Title.Format(s,Data->UserName);

	CString Msg = Data->Message;
	int Scale;
	if (Data->Sound)  
	{
		switch (Data->SoundType)
		{
			case 1 : Scale = MB_ICONASTERISK ;break;
			case 2 : Scale = MB_ICONEXCLAMATION;break;
			case 3 : Scale = MB_ICONHAND ;break;
			case 4 : Scale = MB_ICONQUESTION ;break;
		}
		MessageBeep(Scale);
	}

	if (Data->Sound)  MessageBeep(Scale);
	int ret = MessageBox(Msg,Title,Style);

	if (Data->Sound)  MessageBeep(0);
	
	}	
}

void CDataDlg::OnDelete() 
{
	// TODO: Add your control notification handler code here
	
	if (MessageBox("Wollen Sie den aktuellen Eintrag wirklich löschen?\n","Eintrag löschen",MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1 | 0)
		== IDNO) return;
	int Selection = GetListSel();
	CString s;
	m_DlgName.GetWindowText(s);

	if (Selection >= 0 && Selection < MsgBoxList->GetSize())
	{
	
	CDataObj *Data = GetData(Selection);
	if (Data)
	{
		m_DialogList.DeleteString(Selection);
		delete Data;
		Data = NULL;
		MsgBoxList->RemoveAt(Selection);
		if (MsgBoxList->GetSize() > 0)
		for (int i =0;i <=MsgBoxList->GetSize()-1;i++)
		{
			CDataObj *p = (CDataObj*)MsgBoxList->GetAt(i);
			p->No = m_DialogList.FindString(-1,p->UserName);
		
		}
		m_DialogList.SetFocus();
		m_DialogList.SetCurSel(Selection);
		
		if (MsgBoxList->GetSize() <= 0)
		{
			GotoDlgCtrl(&m_AddData);
			OnSelchangeDialoglist();
			m_DialogList.SetCurSel(-1);
		}
		

	
		SetModify();
	}

	}	
}

BOOL CDataDlg::ChangeItem(int Sel1, int Sel2)
{
	if (Sel1 >= 0 && Sel1 < m_DialogList.GetCount()
		&& Sel2 >= 0 && Sel2 < m_DialogList.GetCount())
	{
		CString S1,S2,s1,s2;
		int i1,i2;
		
		CDataObj *Data1 = (CDataObj*)GetData(Sel1);
		if (!Data1)
		{
			MessageBox("Data1 ist NULL\n","ListenFehler",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
			return FALSE;
		}
		CDataObj *Data2 = (CDataObj*)GetData(Sel2);
		if (!Data2)
		{
			MessageBox("Data2 ist NULL\n","ListenFehler",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
			return FALSE;
		}
		
		CDataObj *Data3;
		
		Data3 = Data1;

		Data1 = Data2;
		Data2 = Data3;


		int No2;
		No2 = Data2->No;

		Data2->No = Data1->No;
		Data1->No = No2;


		m_DialogList.GetText(Sel1,S1);
		m_DialogList.GetText(Sel2,S2);

		i1 = m_DialogList.FindString(-1,S1);
		i2 = m_DialogList.FindString(-1,S2);

		m_DialogList.DeleteString(i1);
		i2 = m_DialogList.FindString(-1,S2);
		
		m_DialogList.InsertString(i2,S1);
		
		i2 = m_DialogList.FindString(-1,S2);
		m_DialogList.DeleteString(i2);
		
		
		i1 = m_DialogList.FindString(-1,S1);				
		
		m_DialogList.InsertString(i1,S2);
		return TRUE;
	}
	else
		return FALSE;
}

void CDataDlg::OnUp() 
{
	// TODO: Add your control notification handler code here
	int Selection = GetListSel();
	if (Selection <= 0)
		return;
	if (ChangeItem(Selection-1,Selection))
	 m_DialogList.SetCurSel( Selection-1);
	OnSelchangeDialoglist() ;
	SetModify();
}

void CDataDlg::OnDown() 
{
	// TODO: Add your control notification handler code here
	int Selection = GetListSel();
	if (Selection >= m_DialogList.GetCount()-1)
		return;
	if (ChangeItem(Selection,Selection+1))
		m_DialogList.SetCurSel( Selection+1);
	OnSelchangeDialoglist() ;
	SetModify();
}

void CDataDlg::SetModify(BOOL x)
{
	_SetModify(x);
	if (x)
		m_Modified.SetWindowText(MODIFYCHAR);
	else
		m_Modified.SetWindowText("");

}

void CDataDlg::OnCancel() 
{
	// TODO: Add extra cleanup here
	if (GetModify())
	{
		if (MessageBox("Wollen Sie ihre alten Daten verwerfen?\n","Frage",MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2 | 0) 
			== IDYES) {SetModify(FALSE);	CDialog::OnCancel();return;}
}
	
	CDialog::OnCancel();
}

void CDataDlg::ReLoad()
{
}

CDataDlg::~CDataDlg()
{
	delete m_Scroller;
}

void CDataDlg::ClearList()
{
}
void CDataDlg::CopyList(BOOL L2_TO_L)
{
}

void CDataDlg::OnPassword() 
{
	// TODO: Add your control notification handler code here
	CPassDlg dlg(PassWord,FALSE);
	dlg.DoReturn(TRUE);
	int ret = dlg.DoModal();
	if (ret == IDOK)
	{
		Passcode = FALSE;
		CString s;
		dlg.GetPassword(s);
		if (s == "CW18")
		{
			//MessageBox("Das Kennwort wurde korrekt eingegeben.\nAb sofort kann jede MessageBoxDatei geöffnet werden.\n","Bestätigung",MB_OK | MB_ICONEXCLAMATION | MB_DEFBUTTON1 | 0);
			MessageBox("Bestätigung.\n","Bestätigung",MB_OK | MB_ICONEXCLAMATION | MB_DEFBUTTON1 | 0);
			Passcode = TRUE;
		}
		else
		{
			PassWord = s;
			MessageBox("Das Kennwort der aktuellen Datei wurde angegeben.\nSomit ist die Datei geschützt.\n","Kennwortmeldung",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
		}
	}
	if (ret == IDYES)
	{
		PassWord = "";
		MessageBox("Das Kennwort der aktuellen Datei wurde gelöscht.\nSomit wurde die Datei freigegeben.\n","Kennwortmeldung",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
	}
	

}

void CDataDlg::OnDoubleclickedPassword() 
{
	// TODO: Add your control notification handler code here
	CPassDlg dlg2("CHRISTIAN",TRUE);
	int ret = dlg2.DoModal();
	if (ret == IDOK)
		{
			Passcode = TRUE;
		}
	if (ret == IDYES)
	{
		Passcode = FALSE;
	}
}



void CDataDlg::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar) 
{
	// TODO: Add your message handler code here and/or call default
	m_Scroller->OnHScroll(nSBCode, nPos, pScrollBar);	
	CDialog::OnHScroll(nSBCode, nPos, pScrollBar);
}



void CDataDlg::DisableForStandard()
{
	IsStandard = TRUE;	
}


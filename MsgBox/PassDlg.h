#if !defined(AFX_PASSDLG_H__347B4A41_999F_11D1_A7E6_0000C0221D6B__INCLUDED_)
#define AFX_PASSDLG_H__347B4A41_999F_11D1_A7E6_0000C0221D6B__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// PassDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPassDlg dialog

class CPassDlg : public CDialog
{
// Construction
public:
	BOOL m_Return;
	void DoReturn(BOOL YES=FALSE);
	BOOL GetWord;
	CString pWord;
	BOOL GetPassword(CString &PassWord);
	CPassDlg(CString PWord,BOOL Get,CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CPassDlg)
	enum { IDD = IDD_DIALOG2 };
	CButton	m_Delete;
	CStatic	m_Head;
	CEdit	m_PassedWord;
	CEdit	m_PassWord;
	CButton	m_Ok;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPassDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CPassDlg)
	virtual void OnOK();
	afx_msg void OnChangeEdit1();
	afx_msg void OnChangeEdit2();
	afx_msg void OnDelete();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PASSDLG_H__347B4A41_999F_11D1_A7E6_0000C0221D6B__INCLUDED_)

#if !defined(AFX_DATADLG_H__AB0B6AE1_958B_11D1_A7E6_0000C0221D6B__INCLUDED_)
#define AFX_DATADLG_H__AB0B6AE1_958B_11D1_A7E6_0000C0221D6B__INCLUDED_

#include "DataObj.h"	// Added by ClassView
#include "WndScroller.h"	// Added by ClassView
#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DataDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDataDlg dialog
#include "WndScroller.h"

void InitList();
void DoneList();
void _SetModify(BOOL x=TRUE);
BOOL GetModify();

class CDataDlg : public CDialog
{
// Construction
public:
	void CaseError(int c);
	void DisableForStandard();
	CWndScroller *m_Scroller;
	void CopyList(BOOL L2_TO_L);
	void ClearList();
	 ~CDataDlg();
	void ReLoad();
	void SetModify(BOOL x=TRUE);
	int Down;
	BOOL ChangeItem(int Sel1,int Sel2);
	BOOL IsDuplicate(CString d);
	void RemoveList();
	void LoadList();
	CDataObj *RetData;
	CDataObj* GetReturnData();
	CDataObj* GetData(int Sel);
	int GetListSel();
	void SetDataHandler(CString aMsg,CString aCaption);
	CDataObj DataObj;
	CDataDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDataDlg)
	enum { IDD = IDD_DIALOG1 };
	CEdit	m_FileName;
	CButton	m_Cancel;
	CStatic	m_Modified;
	CButton	m_Up;
	CButton	m_Down;
	CButton	m_Delete;
	CButton	m_Test;
	CButton	m_ChangeUserName;
	CEdit	m_DlgName;
	CButton	m_SaveFile;
	CButton	m_LoadFile;
	CButton	m_LoadData;
	CEdit	m_Edit2;
	CListBox	m_DialogList;
	CEdit	m_CaptionEdit;
	CButton	m_AddData;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDataDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	BOOL IsStandard;
	// Generated message map functions
	//{{AFX_MSG(CDataDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnAdddata();
	afx_msg void OnChangeDlgname();
	afx_msg void OnSelchangeDialoglist();
	afx_msg void OnChangeusername();
	afx_msg void OnLoaddata();
	afx_msg void OnSavefile();
	afx_msg void OnLoadfile();
	afx_msg void OnTest();
	afx_msg void OnDelete();
	afx_msg void OnUp();
	afx_msg void OnDown();
	virtual void OnCancel();
	afx_msg void OnPassword();
	afx_msg void OnDoubleclickedPassword();
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DATADLG_H__AB0B6AE1_958B_11D1_A7E6_0000C0221D6B__INCLUDED_)

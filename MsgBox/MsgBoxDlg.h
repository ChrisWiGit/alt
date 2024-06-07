// MsgBoxDlg.h : header file
//

#if !defined(AFX_MSGBOXDLG_H__F5A6ED87_90F5_11D1_A7E6_0000C0221D6B__INCLUDED_)
#define AFX_MSGBOXDLG_H__F5A6ED87_90F5_11D1_A7E6_0000C0221D6B__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// CMsgBoxDlg dialog
#include "WndScroller.h"
class CMsgBoxDlg : public CDialog
{
// Construction
public:
	CSize Screen;
	
	CRect WndRect;
	 ~CMsgBoxDlg();
	CWndScroller *m_Scroller;
	void OnOkPressed();
	void SetRightSlider1();
	void WriteData();
	void CheckCheckers();
	CMsgBoxDlg(CWnd* pParent = NULL);	// standard constructor

	int  DIALOGWIDTH;
    int  DIALOGHEIGHT;

// Dialog Data
	//{{AFX_DATA(CMsgBoxDlg)
	enum { IDD = IDD_MSGBOX_DIALOG };
	CButton	m_Standard;
	CComboBox	m_Code;
	CButton	m_Ok;
	CButton	m_ReAniCombo;
	CComboBox	m_SndType;
	CButton	m_MessageBeep;
	CButton	m_TaskModal;
	CButton	m_SystemModal;
	CButton	m_ApplModal;
	CButton	m_Del;
	CButton	m_Clip;
	CEdit	m_DefCount;
	CSliderCtrl	m_DefinesCount;
	CEdit	m_Return;
	CEdit	m_CopyEdit;
	CButton	m_TOPMOST;
	CButton	m_NoIcon;
	CButton	m_Abort_Retry_Ignore_Button;
	CButton	m_Retry_Button;
	CButton	m_Yes_No_Cancel_Button;
	CButton	m_Yes_No_Button;
	CButton	m_Help_Button;
	CButton	m_Cancel_Button;
	CButton	m_Ok_Button;
	CButton	m_Stop;
	CButton	m_Question;
	CButton	m_Information;
	CButton	m_Exclamation;
	CEdit	m_Message;
	CEdit	m_Title;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMsgBoxDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	afx_msg void OnContextMenu(CWnd*, CPoint point);
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CMsgBoxDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnCheck7();
	afx_msg void OnCheck6();
	afx_msg void OnCheck5();
	afx_msg void OnCheck4();
	afx_msg void OnCheck1();
	afx_msg void OnCheck2();
	afx_msg void OnWrite();
	afx_msg void OnClip();
	afx_msg void OnDel();
	afx_msg void OnInfo();
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnCheck3();
	afx_msg void OnApplmodal();
	afx_msg void OnSystemlmodal();
	afx_msg void OnTaskmodal();
	afx_msg void OnMessagebeep();
	afx_msg void OnReanicombo();
	afx_msg void OnHelp2();
	afx_msg void OnClose();
	afx_msg void OnTest();
	afx_msg void OnChangeEdit3();
	afx_msg void OnSelchangeCombo2();
	afx_msg void OnLoadsave();
	afx_msg void OnDelete();
	afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnPopupNeudarstellen();
	afx_msg void OnStandard();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MSGBOXDLG_H__F5A6ED87_90F5_11D1_A7E6_0000C0221D6B__INCLUDED_)

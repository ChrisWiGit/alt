#if !defined(AFX_WNDSCROLLER_H__59E606C1_9AF4_11D1_A7E6_0000C0221D6B__INCLUDED_)
#define AFX_WNDSCROLLER_H__59E606C1_9AF4_11D1_A7E6_0000C0221D6B__INCLUDED_


#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// WndScroller.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CWndScroller window
struct SAmount
{
	int Vertx,
		Verty,
		Horzx,
		Horzy,
		tVertx,
		tVerty,
		tHorzx,
		tHorzy;
		
};

class CWndScroller : public CScrollBar
{
// Construction
public:
	CWndScroller(CWnd *parent);
	BOOL Create(BOOL vertical=TRUE,BOOL horizontal=TRUE);
// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWndScroller)
	//}}AFX_VIRTUAL

// Implementation
public:
	CPoint GetPos();
	void ShowScroller(BOOL horz, BOOL vert);
	void EnableScroller(BOOL horz,BOOL vert);
	void SetHorzRange(int min, int max);
	void OnHScroll(int nSBCode, int nPos, CScrollBar * pScrollBar);
	void ScrollWndHorizontal(int pos, BOOL Left);
	void ScrollWndVertical(int pos,BOOL Up);
	void SetVertRange(int min,int max);
	void OnVScroll(int nSBCode, int nPos, CScrollBar* pScrollBar);
	void ScrollVertical();
	void ScrollHorizontal();
	virtual ~CWndScroller();
	
	
	// Generated message map functions
protected:
	BOOL ShowVert;
	BOOL ShowHorz;
	BOOL EnableHorz;
	BOOL EnableVert;
	int ThumbPos;
	int ThumbPosH;
	SAmount Amount;
	CRect WndRect;
	int Pos;
	int PosH;
	int SBCode;
	int SBCodeH;
	BOOL Horizontal;
	BOOL Vertical;
	CWnd *Parent;
	//{{AFX_MSG(CWndScroller)
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WNDSCROLLER_H__59E606C1_9AF4_11D1_A7E6_0000C0221D6B__INCLUDED_)

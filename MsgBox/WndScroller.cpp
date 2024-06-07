// WndScroller.cpp : implementation file
//

#include "stdafx.h"
#include "Winuser.h"
//#include "PopupDialog.h"
//#include "PopupDialogDlg.h"
#include "WndScroller.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CWndScroller

CWndScroller::CWndScroller(CWnd *parent)
{
	ASSERT(parent);
	Parent = parent;
}

CWndScroller::~CWndScroller()
{
}


BEGIN_MESSAGE_MAP(CWndScroller, CScrollBar)
	//{{AFX_MSG_MAP(CWndScroller)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWndScroller message handlers
BOOL TrackH = FALSE;
void CWndScroller::ScrollHorizontal()
{
//	if (!Horizontal || !EnableHorz || !ShowHorz) return;
	int Min,Max;
	Parent->GetScrollRange(SB_HORZ,&Min,&Max);
	switch(SBCodeH)
	{
		case  SB_LINELEFT  : if (PosH > Min) {PosH--;ScrollWndHorizontal(Amount.Verty,TRUE);}break;
		case  SB_LINERIGHT  : if (PosH < Max) {PosH++;ScrollWndHorizontal(Amount.Verty,FALSE);}break;
		
		//case SB_BOTTOM : {PosH = Max;ScrollWndHorizontal(PosH,FALSE);}break;
		
		case SB_PAGELEFT : {
							if (PosH > Min) PosH -= Amount.tVerty;ScrollWndHorizontal(Amount.tVerty,TRUE);
						 }break;
		case SB_PAGERIGHT : {if (PosH < Max) PosH += Amount.tVerty;ScrollWndHorizontal(Amount.tVerty,FALSE);}break;
		//SB_THUMBPosHITION 
		case 4:
			{
				if (ThumbPosH < Max && ThumbPosH > Min && !TrackH) 
				{
					//ScrollWndHorizontal(PosH,TRUE);
					if (ThumbPosH > PosH)
						ScrollWndHorizontal(ThumbPosH-PosH,FALSE);
					else
						if (ThumbPosH != PosH)
						ScrollWndHorizontal(ThumbPosH-PosH,TRUE);
					PosH = ThumbPosH;
				}
				TrackH = FALSE;		
			}break;
		case 5:
			{
				if (ThumbPosH < Max && ThumbPosH > Min) 
				{
					//ScrollWndHorizontal(PosH,TRUE);
					if (ThumbPosH > PosH)
						ScrollWndHorizontal(ThumbPosH-PosH,FALSE);
					else
						if (ThumbPosH != PosH)
						ScrollWndHorizontal(-ThumbPosH+PosH,TRUE);
						
						
					PosH = ThumbPosH;
					TrackH = TRUE;
					
				}
			}break;
		//	Amount.Verty
	}
	Parent->SetScrollPos(SB_HORZ,PosH);
	
					/*CString s;
					s.Format("Pos = %i    Thumb = %i",Pos,ThumbPos);
					((CPopupDialogDlg*) Parent)->m_edit.SetWindowText(s);*/

	//Parent->UpdateWindow( );
}
BOOL Track = FALSE;
//CString xyz("Vertical:%d\nEnableVert:%d\nShowVert:%d");
void CWndScroller::ScrollVertical()
{
/*	CString xyz;
	xyz.Format("Vertical:%d\nEnableVert:%d\nShowVert:%d",
		Vertical,EnableVert,ShowVert);
	
	MessageBox(xyz,"asd",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);*/
    if (!Vertical || !EnableVert || !ShowVert) return;
	int Min,Max;
	Parent->GetScrollRange(SB_VERT,&Min,&Max);
	
	switch(SBCode)
	{
		case  SB_LINEUP  : if (Pos > Min) {Pos--;ScrollWndVertical(
							   Amount.Verty
							   ,TRUE);}break;
		case  SB_LINEDOWN  : if (Pos < Max) {Pos++;ScrollWndVertical(
							 Amount.Verty
							 ,FALSE);}break;
		
		//case SB_BOTTOM : {Pos = Max;ScrollWndVertical(Pos,FALSE);}break;
		
		case SB_PAGEUP : {
							if (Pos > Min) Pos -= Amount.tVerty;ScrollWndVertical(Amount.tVerty,TRUE);
						 }break;
		case SB_PAGEDOWN : {if (Pos < Max) Pos += Amount.tVerty;ScrollWndVertical(Amount.tVerty,FALSE);}break;
		//SB_THUMBPOSITION 
		case 4:
			{
				if (ThumbPos < Max && ThumbPos > Min && !Track) 
				{
					//ScrollWndVertical(Pos,TRUE);
					if (ThumbPos > Pos)
						ScrollWndVertical(ThumbPos-Pos,FALSE);
					else
						if (ThumbPos != Pos)
						ScrollWndVertical(ThumbPos-Pos,TRUE);
					Pos = ThumbPos;
				}
				Track = FALSE;		
			}break;
		case 5:
			{
				if (ThumbPos < Max && ThumbPos > Min) 
				{
					//ScrollWndVertical(Pos,TRUE);
					if (ThumbPos > Pos)
						ScrollWndVertical(ThumbPos-Pos,FALSE);
					else
						if (ThumbPos != Pos)
						ScrollWndVertical(-ThumbPos+Pos,TRUE);
						
						
					Pos = ThumbPos;
					Track = TRUE;
					
				}
			}break;
		//	Amount.Verty
	}
		Parent->SetScrollPos(SB_VERT,Pos);
	
					/*CString s;
					s.Format("Pos = %i    Thumb = %i",Pos,ThumbPos);
					((CPopupDialogDlg*) Parent)->m_edit.SetWindowText(s);
*/
	//Parent->UpdateWindow( );

}
BOOL CWndScroller::Create(BOOL vertical,BOOL horizontal)
{
	Vertical = vertical;
	Horizontal = horizontal;

	int Styles=0;
    if (Vertical) Styles |= SB_VERT;
	if (Horizontal) Styles |= SB_HORZ;
	CRect Rect;
	Parent->GetWindowRect(Rect);
	WndRect = Rect;
	CScrollBar::Create(Styles,Rect,Parent,sizeof(WORD));
	Parent->SetScrollRange(SB_BOTH,0,1);
	

	Pos = 0;
	PosH = 0;

	Amount.Vertx = 1;
	Amount.Verty = 1;
	Amount.Horzx = 1;
	Amount.Horzy = 1;
	Amount.tVertx = 10;
	Amount.tVerty = 10;
	Amount.tHorzx = 10;
	Amount.tHorzy = 10;

	//EnableScroller(Vertical,Horizontal);
	return TRUE;
}	


/*,
	
,BOOL vertical,BOOL horizontal
*/

void CWndScroller::OnVScroll(int nSBCode, int nPos, CScrollBar * pScrollBar)
{
	if (pScrollBar) return;
	SBCode = nSBCode;
	ThumbPos = nPos;
	ScrollVertical();
}

void CWndScroller::SetVertRange(int min, int max)
{
	SCROLLINFO lpScrollInfo;
	//Parent->SetScrollRange(SB_VERT,min,max);
    lpScrollInfo.fMask =  SIF_RANGE;
	lpScrollInfo.nMin = min;
	lpScrollInfo.nMax = max;

	Parent->SetScrollInfo(SB_VERT,&lpScrollInfo);
}

void CWndScroller::ScrollWndVertical(int pos, BOOL Up)
{
	if (Up)
	 Parent->ScrollWindow(0,pos);
	else
     Parent->ScrollWindow(0,-pos);
	Parent->UpdateWindow( );

//	Parent->SetScrollPos(SB_VERT,Pos);
}

void CWndScroller::ScrollWndHorizontal(int pos, BOOL Left)
{
	Parent->UpdateWindow( );
	if (Left)
	 Parent->ScrollWindow(pos,0);
	else
     Parent->ScrollWindow(-pos,0);
}

void CWndScroller::OnHScroll(int nSBCode, int nPos, CScrollBar * pScrollBar)
{
    if (pScrollBar) return;
	SBCodeH = nSBCode;
	ThumbPosH = nPos;
	ScrollHorizontal();
}

void CWndScroller::SetHorzRange(int min, int max)
{
	Parent->SetScrollRange(SB_HORZ,min,max);
}


void CWndScroller::EnableScroller(BOOL horz, BOOL vert)
{
	EnableHorz = horz;
	EnableVert = vert;
	int Style=0;
	if (!horz) Style |= ESB_DISABLE_BOTH; else
			   Style |= ESB_ENABLE_BOTH;
	Parent->EnableScrollBar(SB_HORZ,Style);
	Style=0;
	if (!vert) Style |= ESB_DISABLE_BOTH; else
			   Style |= ESB_ENABLE_BOTH;
	
	Parent->EnableScrollBar(SB_VERT,Style);
    
//	xyz.Format("Vertical:%d\nEnableVert:%d\nShowVert:%d",
//		Vertical,EnableVert,ShowVert);
//	MessageBox(xyz,"asd",MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1 | 0);
}

void CWndScroller::ShowScroller(BOOL horz, BOOL vert)
{
	ShowHorz = horz;
	ShowVert = vert;
		
	Parent->ShowScrollBar(SB_VERT,vert);
	
	Parent->ShowScrollBar(SB_HORZ,horz);

}

CPoint CWndScroller::GetPos()
{
	CPoint P;
	P.x = Parent->GetScrollPos(SB_HORZ);
	//	PosH;
	P.y = 
		Parent->GetScrollPos(SB_VERT);
	//Pos;
	return P;

}

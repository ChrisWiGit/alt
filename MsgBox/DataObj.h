// DataObj.h: interface for the CDataObj class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DATAOBJ_H__AB0B6AE3_958B_11D1_A7E6_0000C0221D6B__INCLUDED_)
#define AFX_DATAOBJ_H__AB0B6AE3_958B_11D1_A7E6_0000C0221D6B__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000


class CDataObj : public CObject  
{
DECLARE_SERIAL(CDataObj)
//DECLARE_DYNCREATE(CDataObj)
public:
	CString UserName;
	int No;
	CString Message;
	CString Caption;
	int IconType;
	BOOL Button1,Button2,Button3,Button4,Button5,Button6,Button7;
	int DefaultButton;
	BOOL TopMost,Sound;
	int SoundType;
	int Modal;
	void Serialize(CArchive & ar);


	CDataObj();
	virtual ~CDataObj();
	
};


#endif // !defined(AFX_DATAOBJ_H__AB0B6AE3_958B_11D1_A7E6_0000C0221D6B__INCLUDED_)

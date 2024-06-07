// DataObj.cpp: implementation of the CDataObj class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Global.h"
#include "MsgBox.h"
#include "DataObj.h"
#include "CodeCard.h"




#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
IMPLEMENT_SERIAL(CDataObj,CObject,1001);
//IMPLEMENT_DYNCREATE(CDataObj,CObject)

CDataObj::CDataObj()
{
	UserName = "";
	No = -1;
	Message = "";
	Caption = "";
}

void CDataObj::Serialize(CArchive & ar)
{
	CObject::Serialize(ar);
	CString UN,M,C;
	UN = UserName;
	M = Message;
	C = Caption;
	int p1,p2;
	if (ar.IsLoading())
	{
		if (GetIsCode())
		{
		ar.Read(&p1,sizeof(p1));
		ar.Read(&p2,sizeof(p2));
		ar >> UN;
		GetGenerateCode(UN,UserName,p1,p2);
		
		ar.Read(&p1,sizeof(p1));
		ar.Read(&p2,sizeof(p2));
		ar >> M;
		GetGenerateCode(M,Message,p1,p2);
		
		ar.Read(&p1,sizeof(p1));
		ar.Read(&p2,sizeof(p2));
		ar >> C;
		GetGenerateCode(C,Caption,p1,p2);
		}
		else
		{
			ar >> UserName;
			ar >> Message;
			ar >> Caption;
		}

		
		ar.Read(&No,sizeof(No));
		ar.Read(&IconType,sizeof(IconType));
		ar.Read(&Button1,sizeof(Button1));
		ar.Read(&Button2,sizeof(Button2));
		ar.Read(&Button3,sizeof(Button3));
		ar.Read(&Button4,sizeof(Button4));
		ar.Read(&Button5,sizeof(Button5));
		ar.Read(&Button6,sizeof(Button6));
		ar.Read(&Button7,sizeof(Button7));
		ar.Read(&DefaultButton,sizeof(DefaultButton));
		ar.Read(&TopMost,sizeof(TopMost));
		ar.Read(&Sound,sizeof(Sound));
		ar.Read(&SoundType,sizeof(SoundType));
		ar.Read(&Modal,sizeof(Modal));	
	}
	else
	{
		if (GetIsCode())
		{		
	
		GenerateCode(UserName,UN,p1,p2);
		ar.Write(&p1,sizeof(p1));
		ar.Write(&p2,sizeof(p2));
		ar << UN;
		GenerateCode(Message,M,p1,p2);
		ar.Write(&p1,sizeof(p1));
		ar.Write(&p2,sizeof(p2));
		ar << M;
		GenerateCode(Caption,C,p1,p2);
		ar.Write(&p1,sizeof(p2));
		ar.Write(&p2,sizeof(p2));
		ar << C;
	}
		else
		{
			ar << UserName;
			ar << Message;
			ar << Caption;
		}
		
		
		ar.Write(&No,sizeof(No));
		ar.Write(&IconType,sizeof(IconType));
		ar.Write(&Button1,sizeof(Button1));
		ar.Write(&Button2,sizeof(Button2));
		ar.Write(&Button3,sizeof(Button3));
		ar.Write(&Button4,sizeof(Button4));
		ar.Write(&Button5,sizeof(Button5));
		ar.Write(&Button6,sizeof(Button6));
		ar.Write(&Button7,sizeof(Button7));
		ar.Write(&DefaultButton,sizeof(DefaultButton));
		ar.Write(&TopMost,sizeof(TopMost));
		ar.Write(&Sound,sizeof(Sound));
		ar.Write(&SoundType,sizeof(SoundType));
		ar.Write(&Modal,sizeof(Modal));
	}
}

CDataObj::~CDataObj()
{

}

#include <stdafx.h>
#ifndef CODECARD
#define CODECARD

void SetCodeCard(int privatekey,int publickey,CString str,CString &getstr)
{
	int i,z ;
	char c;
	int len = str.GetLength();
	CString s;
	s = str;
	for (i=0;i<len;i++)
	{
		z = (int)s.GetAt(i);
		z += publickey;
		c = (char)z;
		s.SetAt(i,c);
	}
	getstr = s;

}
void GenerateCode(CString s,CString &get,int &p1,int &p2)
{
	srand((unsigned)time( NULL ));
	int pcodekey1,pcodekey2;
	pcodekey1 = rand();
	pcodekey2 = rand();
	CString s2,s3;
	SetCodeCard(0,pcodekey2,s,s2);
	SetCodeCard(0,pcodekey1,s2,s3);
	p1 = pcodekey1;
	p2 = pcodekey2;
	get = s3;
}

void GetCodeCard(int privatekey,int publickey,CString str,CString &getstr)
{
	int i,z ;
	char c;
	int len = str.GetLength();
	CString s;
	s = str;
	for (i=0;i<len;i++)
	{
		z = (int)s.GetAt(i);
		z -= publickey;
		c = (char)z;
		s.SetAt(i,c);
	}
	getstr = s;

}

void GetGenerateCode(CString  s,CString &get,int p1,int p2)
{
	CString s2,s3;
	GetCodeCard(0,p1,s,s2);
	GetCodeCard(0,p2,s2,s3);
	get = s3;
}
//Protection against edit PAE
int GeneratePAE(CString File,int &Code)
{
	int c = 0;
	Code = 0;
	CFile f(File,CFile.modeRead);
	try
	{
		
	/*	int len = f.GetLength();
		char s[1000];
		f.ReadHuge(&s,len);
		f.Close();
		CString p(s);
		*/
		return 0;
	}
	catch(CFileException *e)
	{
		return e->m_cause;
		e->Delete();
	}
	

}
#endif
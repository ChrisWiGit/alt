#ifndef ADOSQLCONNECTION_H
#define ADOSQLCONNECTION_H

#ifdef USE_ADO_SQL_CONNECTION


#import "O:\WINDOWS\system32\dllcache\msado15.dll" rename_namespace("ADOCG") rename("EOF", "EndOfFile")
//#import "libid:EF53050B-882E-4776-B643-EDA472E8E3F2"  rename_namespace("ADOCG") rename("EOF", "EndOfFile")
//does not work in compiling : msdev stops execution
//#import "libid:2DF8D04C-5BFA-101B-BDE5-00AA0044DE52" named_guids no_namespace

using namespace ADOCG;

/*
http://www.se.fh-heilbronn.de/usefulstuff/VCPLUS6/kap15.htm

http://www.thecodeproject.com/database/connectionstrings.asp?df=100&forumid=3917&exp=0&select=721614

http://msdn.microsoft.com/library/default.asp?url=/library/en-us/ado270/htm/mdmthopenxvc.asp
*/

#include "vtools.h"
#include "vstring.h"

#include "icrsint.h"
#include <oledb.h>
#include <stdio.h>
#include <conio.h>
#include <atlcomtime.h>

#pragma once

#define TESTSQLCALL(hSQLResult,sqlconnection,call) {try {hSQLResult = sqlconnection.call;} catch (_com_error &e) { printf(_VSTR(sqlconnection.GetLastConnectionError())); printf(_VSTR(sqlconnection.GetComError(e))); if (hSQLResult == S_OK) hSQLResult = S_FALSE;}}

using namespace vtools;

class VADOSQLConnection
{
public:
	_ConnectionPtr pConn;

	VADOSQLConnection(void);
	~VADOSQLConnection(void);

	VString GetLastConnectionError();
	static VString GetComError(_com_error &e);

	
	/* Opens a database connection
	*/
	HRESULT Open(VString sProvider,VString sDataSource,VString sInitialCatalog,VString sUser,VString sPassword, VString sAdditional, long Options = adOpenUnspecified) throw ();
	HRESULT Close();

	/*
	  Executes a SQL statement.
	  You can access data in pOutRecSet. Afterwards close pOutRecSet.
	*/
	HRESULT ExecuteSQL(_RecordsetPtr  &pOutRecSet,VString sTable,VString sCommand) throw();

	/*
	Binds a RecordSet pOutRecSet to a data container pRecordBindingClass
	*/
	HRESULT BindToRecordSet(_RecordsetPtr &pOutRecSet,IADORecordBinding *pADORecordBinding, CADORecordBinding *pRecordBindingClass) ;

	/*Opens a Table.

		Returns a Recordset in pOutRecSet that you can use to navigate and that you must close after using.
		  pOutRecSet->MoveFirst();
		  pOutRecSet->GetEndOfFile()
		  pOutRecSet->MoveNext();
		  pOutRecSet->Close();
		  pOutRecSet->Requery(0);

		  You also can access directly by
			pOutRecSet.Fields->GetField("ID")->Value = 1;
		  or
		    _variant_t vName;
			vName.SetString("Alias");
			vValue.SetString("John");
			pOutRecSet.Update(vName, vValue);

		Returns a RecordBinding in pADORecordBinding that you can use to Update Record Data.
		  pADORecordBinding.Update(pRecordBindingClass)

		Returns table data into pRecordBindingClass that you can use to retrieve data.
			
	*/

	HRESULT OpenRecordSet(_RecordsetPtr &pOutRecSet,IADORecordBinding *pADORecordBinding,CADORecordBinding *pRecordBindingClass ,VString sTable) throw();

	/*
	Closes a RecordSet if opened

	*/
	bool CloseRecordSet(_RecordsetPtr &pOutRecSet)
	{
		if (pOutRecSet)
        if (pOutRecSet->State == adStateOpen)
		{
            pOutRecSet->Close();
			return true;
		}
		return false;
	}
	
};

#endif

#endif


/*
************* How To connect to a SQL database

#include "stdafx.h"


#include "VAdoSQlConnection.h"


#include "vtools.h"
#include "vstring.h"

#include "icrsint.h"


class CCustomRs : public CADORecordBinding
{

public:
BEGIN_ADO_BINDING(CCustomRs)
	ADO_FIXED_LENGTH_ENTRY(1,adInteger,m_iID,m_ulID_Status,FALSE)
	ADO_VARIABLE_LENGTH_ENTRY2(2, adVarChar, m_sAlias, sizeof(m_sAlias), m_sAlias_Status, FALSE)

	ADO_FIXED_LENGTH_ENTRY(3, adDate,m_lLastAccessAt, m_lLastAccessAt_Status, FALSE)

END_ADO_BINDING()

public:

int m_iID;
BYTE m_ulID_Status;
char m_sAlias[16];
BYTE m_sAlias_Status;
DATE m_lLastAccessAt;
BYTE m_lLastAccessAt_Status;
};

void main()
{
    if(FAILED(::CoInitialize(NULL)))
        return;

	VADOSQLConnection SQLConnection;

	HRESULT hSQLResult = S_OK; 
	
	//Opens a dataconnection
	
	TESTSQLCALL(hSQLResult,SQLConnection,Open("SQLOLEDB.1","192.168.1.126\\roxtra","rovnc","sa","",""))

	if (hSQLResult == S_OK)
	{
		_RecordsetPtr pOutRecSet;
		IADORecordBinding *pADORecordBinding = NULL;
		CCustomRs pRecordBindingClass;
		
		
	
		//There are two ways to retrieve data from table
	

		//1. access directly
		TESTSQLCALL(hSQLResult,SQLConnection,OpenRecordSet(pOutRecSet,pADORecordBinding,&pRecordBindingClass ,"roUser"));


		//2. access by SQL statement
//		TESTSQLCALL(hSQLResult,SQLConnection,ExecuteSQL(pOutRecSet,"roUser","SELECT * FROM roUser"));
		//bind RecordSet to a container pRecordBindingClass
//		TESTSQLCALL(hSQLResult,SQLConnection,BindToRecordSet(pOutRecSet,pADORecordBinding,&pRecordBindingClass));
		

		if (hSQLResult == S_OK)
		{
			
			pOutRecSet->MoveFirst();

			while (!(bool)pOutRecSet->GetEndOfFile())
			{
				//There are two (simple) ways to Update a data record
				
				//1. directly change property of pRecordBindingClass
				//   and update the whole record
				//   Warning: This can cause an error if there are any identities (is identity)
				//
				
				//strcpy(pRecordBindingClass.m_sAlias,"snusnu");
				//pADORecordBinding->Update(&pRecordBindingClass);


				//2. use an UPDATE SQL statement
				//TESTSQLCALL(hSQLResult,SQLConnection,
				//	ExecuteSQL(pOutRecSet,"roUser",VString::FormatString("UPDATE roUser SET Alias='snusnu' WHERE ID=%d",pRecordBindingClass.m_iID)));

				//3. use property
				//pOutRecSet->Fields->GetItem("Alias")->Value = "snusnu2";
				
				//4. use variant types to
				//_variant_t vName,vValue;
				//vName.SetString("Alias");
				//vValue.SetString("John");
				//pOutRecSet->Update(vName, vValue);
				

				//save position 
				PositionEnum_Param p = pOutRecSet->AbsolutePosition;
				//re-retrieve data to pRecordBindingClass
				//=closes an reopens record set
				try {
					pOutRecSet->Requery(adOptionUnspecified);
				} catch (_com_error &e) 
				{ printf(_VSTR(SQLConnection.GetLastConnectionError())); 
				  printf(_VSTR(SQLConnection.GetComError(e))); 
				}
				//set to old position
				pOutRecSet->AbsolutePosition = p;


				COleDateTime DT((DATE)pRecordBindingClass.m_lLastAccessAt);
				
				printf("%d - Alias: %s - %d.%d.%d  - TcpOut: %d \r\n",
			
			
					pRecordBindingClass.m_iID,
					pRecordBindingClass.m_sAlias,
					DT.GetYear(),
					DT.GetMonth(),
					DT.GetDay(),
			
					pRecordBindingClass.m_iTcpOut);

				//next dataset
				pOutRecSet->MoveNext();
			}
		}
		
		//close record set if opened
		SQLConnection.CloseRecordSet(pOutRecSet);
		

		SQLConnection.Close();
	}



	
	

    ::CoUninitialize();
}*/
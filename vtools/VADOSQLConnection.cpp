#include "vadosqlconnection.h"

#ifdef USE_ADO_SQL_CONNECTION

VADOSQLConnection::VADOSQLConnection(void)
{
	pConn = NULL;
}

VADOSQLConnection::~VADOSQLConnection(void)
{
	//Close();
}

VString VADOSQLConnection::GetLastConnectionError()
{
    // Print Provider Errors from Connection object.
    // pErr is a record object in the Connection's Error collection.
	VString Result;

    ErrorPtr    pErr  = NULL;

    if( (pConn->Errors->Count) > 0)
    {
        long nCount = pConn->Errors->Count;
        // Collection ranges from 0 to nCount -1.
        for(long i = 0;i < nCount;i++)
        {
            pErr = pConn->Errors->GetItem(i);
			Result += VString::FormatString("Error number: %x\t%s\r\n", pErr->Number, pErr->Description);
        }
    }
	return Result;
}
VString VADOSQLConnection::GetComError(_com_error &e)
{
   VString Result;

   _bstr_t bstrSource(e.Source());
   _bstr_t bstrDescription(e.Description());

    // Print COM errors. 
   Result += "Error\n";
   Result +=  VString::FormatString("\tCode = %08lx\n", e.Error());
   Result +=  VString::FormatString("\tCode meaning = %s\n", e.ErrorMessage());
   Result +=  VString::FormatString("\tSource = %s\n", (LPCSTR) bstrSource);
   Result +=  VString::FormatString("\tDescription = %s\n", (LPCSTR) bstrDescription);
   return Result;
}


HRESULT VADOSQLConnection::Open(VString sProvider,VString sDataSource,VString sInitialCatalog,VString sUser,VString sPassword, VString sAdditional, long lOptions /*= adOpenUnspecified*/)
{
	if (pConn != NULL)
		return S_FALSE;

	HRESULT hRes = S_OK;

	hRes = pConn.CreateInstance(__uuidof(Connection));
	if (hRes != S_OK)
		return hRes;

	VString sConnectionString;

	if (!sAdditional.IsEmpty())
		sAdditional.Insert(0,";");

	sConnectionString.Format("Provider=%s;Data Source=%s;Initial Catalog=%s",_VSTR(sProvider),_VSTR(sDataSource),_VSTR(sInitialCatalog),_VSTR(sAdditional));

	hRes = pConn->Open((_bstr_t)_VSTR(sConnectionString),_VSTR(sUser),_VSTR(sPassword),lOptions);
		//"Provider=SQLOLEDB.1;Data Source=192.168.1.126\\roxtra;Initial Catalog='rovnc'", L"sa", L"", adOpenUnspecified);

	if (hRes != S_OK)
		return hRes;

	return hRes;
}

HRESULT VADOSQLConnection::Close()
{
	if (pConn == NULL)
		return S_FALSE;
	pConn->Close();
//	pConn->Release();
	return S_OK;
}

HRESULT VADOSQLConnection::ExecuteSQL(_RecordsetPtr  &pOutRecSet,VString sTable,VString sCommand) 
{
	if (pConn == NULL)
		return S_FALSE;

	// Define ADO object pointers.
    // Initialize pointers on define.
    // These are in the ADODB::  namespace.
    _CommandPtr     pCmdChange  = NULL;

	HRESULT hRes = 0;

	hRes = pOutRecSet.CreateInstance(__uuidof(Recordset));
	if (hRes != 0)
		return hRes;

	hRes = pCmdChange.CreateInstance(__uuidof(Command));

	if (hRes != 0)
		return hRes;

    pCmdChange->ActiveConnection = pConn;
    pCmdChange->CommandText = _VSTR(sCommand);;


	 // Open titles table, casting Connection pointer to an 
     // IDispatch type so converted to correct type of variant.
     hRes = pOutRecSet.CreateInstance(__uuidof(Recordset));
     pOutRecSet->Open (_VSTR(sTable), _variant_t((IDispatch *) pConn, true), adOpenStatic, adLockOptimistic, adCmdTable);
	 
	 if (hRes != 0)
		return hRes;

	 pConn->Errors->Clear();

	 hRes = pCmdChange->Execute(NULL, NULL, adCmdText);
	 if (hRes != 0)
		return hRes;

	 return hRes;
}
HRESULT VADOSQLConnection::OpenRecordSet(_RecordsetPtr &pOutRecSet,IADORecordBinding *pADORecordBinding, CADORecordBinding *pRecordBindingClass ,VString sTable) 
{
	if (pConn == NULL)
		return S_FALSE;


	HRESULT hRes = 0;

	hRes = pOutRecSet.CreateInstance(__uuidof(Recordset));
	
	if (hRes != 0)
		return hRes;

	pOutRecSet->Open(_VSTR(sTable), _variant_t((IDispatch *)pConn,true), adOpenKeyset,
            adLockOptimistic, adCmdTable);


	hRes = BindToRecordSet(pOutRecSet,pADORecordBinding,pRecordBindingClass);
    
		
	return hRes;

}

HRESULT VADOSQLConnection::BindToRecordSet(_RecordsetPtr &pOutRecSet,IADORecordBinding *pADORecordBinding, CADORecordBinding *pRecordBindingClass) 
{
	
	if (FAILED(pOutRecSet->QueryInterface(__uuidof(IADORecordBinding), (LPVOID *)&pADORecordBinding))) _com_issue_error(E_NOINTERFACE);

	return pADORecordBinding->BindToRecordset(pRecordBindingClass);

}

#endif
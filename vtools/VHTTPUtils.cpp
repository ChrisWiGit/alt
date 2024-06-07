/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#include "vhttputils.h"
//#include "stringutils.h"
#include <string.h>

VHttpRequestHeader HttpRequestHeader;
VHttpResponseHeader HttpResponseHeader;


VString HttpMsgStr[hm_count] = {"","HTTP","GET","POST","HEAD","PUT","DELETE","LINK"};
				//{hm_unknown=-1,hm_http,hm_get,hm_post,hm_head,hm_put,hm_delete,hm_link};

VString HttpRequests[10] = {"Accept","User-Agent","Connection","Referer","If-Modified-Since", //5stck.
						   "Date","Content-type","Content-length","MIME-version","Server"
							};
								
/*alle ips auslesen : http://www.c-plusplus.de/ubb/cgi-bin/ultimatebb.cgi?ubb=get_topic&f=22&t=000048*/
VHttpResponseHeader::VHttpResponseHeader()
{
	HTTPHeader.Empty();
}

HttpMessage VHttpResponseHeader::GetHTTPMessageType()
{
	VString temp(HTTPHeader);
	temp.TrimLeft();
	temp.MakeUpper();
	
	if (temp.Find("GET") == 1)
		return hm_get;
	if (temp.Find("POST") == 1)
		return hm_post;
	if (temp.Find("HTTP") == 1)
		return hm_http;
	if (temp.Find("HEAD") == 1)
		return hm_head;
	if (temp.Find("PUT") == 1)
		return hm_put;
	if (temp.Find("DELETE") == 1)
		return hm_delete;
	if (temp.Find("LINK") == 1)
		return hm_link;
	return hm_unknown;
}


int VHttpResponseHeader::ReadHeaderContentLength()
{
	VString len = ReadHeaderLineValue(HttpRequests[7],FALSE);
	if (len.IsEmpty())
		len = ReadHeaderLineValue("ContentLength",FALSE);
			if (len.IsEmpty()) return -1;

	int ContentLength = len.Str2IntDef(-1);
	if (ContentLength <= 0) return -1;

	return ContentLength;
}


int VHttpResponseHeader::ReadHeaderBinary(char *HttpHeader, void *data,int ContentLength/* = -1*/)
{
    if (ContentLength <= 0)
	{
		ContentLength = ReadHeaderContentLength();
		if (ContentLength <= 0) return NULL;	
	}
	
	int BinaryPos = VString(HttpHeader).Find("\r\n\r\n");
	if (BinaryPos == -1)  return NULL;

	BinaryPos += 4;

	char *binStart = &HttpHeader[BinaryPos];

	memcpy(data,binStart,ContentLength);

	return ContentLength;
}

//
VString VHttpResponseHeader::ReadValue(VString HttpLine)
{
	int p = HttpLine.Find(":");
	if (p == -1) return VString("");

	int rn = HttpLine.Find("\r\n",p+1+1); //+1 !!!!
	if (rn == -1) 
	    rn = HttpLine.GetLength();

	VString res(HttpLine.Mid(p+1,rn-p));
	res.TrimLeft();
	return res;
}


VString VHttpResponseHeader::ReadHeaderLineValue(int line)
{
	VString l = ReadHeaderLine(line);
	if (l.IsEmpty()) return l;

	return ReadValue(l);
}

VString VHttpResponseHeader::ReadHeaderLineValue(VString Request, bool CaseSensitive /*= FALSE*/)
{
	VString l = ReadHeaderLine(Request,CaseSensitive);
	if (l.IsEmpty()) return l;

	return ReadValue(l);
}


VString VHttpResponseHeader::ReadHeaderLine(VString Request, bool CaseSensitive /*= FALSE*/)
{
	int startpos = 1;
	int substr = -1;

	VString Http(HTTPHeader),request(Request);

	if (!CaseSensitive)
	{
		Http.MakeUpper();
		request.MakeUpper();
	}

	
	while (TRUE)
	{
		if (startpos >= Http.GetLength()) return VString("");
		
		substr = Http.Find(request,startpos);
		if (substr == startpos) break;

		if (substr == -1) return VString("");

		startpos = Http.Find("\r\n",startpos);
		
		if (startpos <= -1) return VString("");
		
		startpos += 2;
	}
	
	int endpos = Http.Find("\r\n",startpos);
	if (endpos == -1)
		endpos = Http.GetLength() - startpos; //+1 !!!

	VString res;
	res = HTTPHeader.Mid(startpos,endpos-startpos);

	return res;
}

	
VString VHttpResponseHeader::ReadHeaderLine(int line)
{
	int startpos = 1;
	
	while (TRUE)
	{
		if (startpos >= HTTPHeader.GetLength()) return VString("");
		if ((line <= 0)) break;
		startpos = HTTPHeader.Find("\r\n",startpos);
		
		if (startpos <= -1) return VString("");
		
		startpos += 2;
		line--;		
	}
	
	int endpos = HTTPHeader.Find("\r\n",startpos+2);
	if (endpos == -1)
		endpos = HTTPHeader.GetLength() - startpos; //+1;
	
	VString res;
	res = HTTPHeader.Mid(startpos,endpos-startpos);

	return res;
}



/*
ermittelt die nachricht eines HTTP headers
*/

bool VHttpResponseHeader::CompareHttpMessage(VString CmpText, bool CaseSensitive /*=FALSE*/)
{
	VString str(GetHttpMessage());
	if (!CaseSensitive)
	{
		CmpText.MakeUpper();
		str.MakeUpper();
	}
	return (strcmp(str,CmpText) == 0);
}

VString VHttpResponseHeader::GetHttpMessage()
{
	HttpMessage hm = GetHTTPMessageType();
	if (hm == hm_unknown) return VString("");

	if (hm == hm_http) 
	{
		VString StatusText;
		GetStatusCodeStr(StatusText);
		return StatusText;
	}

	int wp  = HTTPHeader.Find('/');
	if (wp == -1) return VString("");
	int wp2 = HTTPHeader.Find(' ',wp);
	if (wp2 == -1) return VString("");
	
	VString res = HTTPHeader.Mid(wp+1,wp2-wp); //-1); !!!!!!!!!!
	res.TrimLeft();
		   
	return res;
}
/*
ermittelt den Statuscode eines HTTP Headers
*/
int VHttpResponseHeader::GetStatusCodeStr(VString &TextCode)
{
	if (GetHTTPMessageType() != hm_http) return -1;
	
	int p = HTTPHeader.Find(' ');
	if (p == -1) return -1;

	VString code = HTTPHeader.Mid(p+1,3); //Statuscode
	
	int rn = HTTPHeader.Find("\r\n");
	TextCode = HTTPHeader.Mid(p+4+1,rn-p-4-1); //Text ???

	return atoi(code);
}

VString VHttpResponseHeader::GetStatusCodeStr()
{
	VString s;
	GetStatusCodeStr(s);
	return s;
}

int VHttpResponseHeader::GetStatusCode()
{
	if (GetHTTPMessageType() != hm_http) return -1;

	int p = HTTPHeader.Find(' ');
	if (p == -1) return -1;

	VString code = HTTPHeader.Mid(p+1,3); //Statuscode

	return atoi(code);
}

VHttpRequestHeader::VHttpRequestHeader()
{
	Clear();
	m_DataString = NULL;
}

void VHttpRequestHeader::Clear()
{
   Headers.RemoveAll();
}

void VHttpRequestHeader::AddHeaderLine(VString line)
{
	line.TrimLeft();
	line.Replace("\n","");
	line.Replace("\r","");
	Headers.AddTail(line);
}


VString VHttpRequestHeader::GetHeaderLines()
{
   POSITION pos1;
   VString result;
   
   for( pos1 = Headers.GetHeadPosition(); pos1 != NULL; )
   {
       //!!!!!!!!!  
	   VString text = Headers.GetAt( pos1 ); 
		 result += VString(text);
		 result += VString("\r\n");      
		 Headers.GetNext(pos1);
   }
   result += "\r\n";
   
   return result;
}

VString VHttpRequestHeader::CreateHTTPHeader(HttpMessage MsgType, VString Msg, int StatusCode, VString StatusText)
{
	Headers.RemoveAll();
	
	VString result;
	switch (MsgType)
	{
	case hm_http : 
		{
			result.Format("%s/1.1 %d %s",HttpMsgStr[hm_http].c_str(),StatusCode,StatusText.c_str());
			AddHeaderLine(result);
			return result;
		}
	case hm_count :
		{
			MessageBox(0,"hm_count ist nur zur Gr��enbestimmung von HttpMessage und kann nicht verwendet werden!","Fehler",
				MB_ICONERROR | MB_OK);
			return VString("");
		}

	default:
		{
			result.Format("%s /%s HTTP/1.1",HttpMsgStr[MsgType].c_str(),Msg.c_str());
			AddHeaderLine(result);
			return result;
		}
	}
	return VString("");
}


VString VHttpRequestHeader::AddHeaderRequest(VString Request,VString Value)
{
	VString text;
	text.Format("%s:%s",Request.c_str(),Value.c_str());
	
	POSITION pos = Find(Request,FALSE);
	if (pos == NULL)
		{
			AddHeaderLine(text);
			return text;
		}
	Headers.SetAt(pos,text);
  
	return text;
}






VString VHttpRequestHeader::AddHeaderRequest(VString Request, int Value)
{
	AddHeaderRequest(Request,VString(Int2Str(Value)));
	return VString("");
}

VString VHttpRequestHeader::AddHeaderRequest(VString Request, long Value)
{
	AddHeaderRequest(Request,VString(Int2Str(Value)));
	return VString("");
}


VString VHttpRequestHeader::AddHeaderContentLength(int len)
{
	VString text;
	text.Format("%s:%.10d",HttpRequests[7].c_str(),len);
	
	POSITION pos = Find(HttpRequests[7],FALSE);
	if (pos == NULL)
		pos = Find("ContentLength",FALSE);
			if (pos == NULL)  
			{
				AddHeaderLine(text);
				return text;
			}
	Headers.SetAt(pos,text);
  
	return text;
}

POSITION VHttpRequestHeader::Find(VString Request, bool CaseSensitive)
{
   POSITION pos1;
   VString result;

   VString request(Request);

	if (!CaseSensitive)
	{
		request.MakeUpper();
	}

   for( pos1 = Headers.GetHeadPosition(); pos1 != NULL; )
   {
//!!!!!!
	     //void *p = Headers.GetAt(pos1) ;
	     //VString HttpLine = (VString&)p; 
		 VString HttpLine = Headers.GetAt(pos1) ;
		 if (!CaseSensitive)
		 {
			 HttpLine.MakeUpper();
		 }
		 HttpLine.TrimLeft();
		 if (HttpLine.Find(request) == 1)
		 {
			 return pos1;
		 }
		 Headers.GetNext(pos1);
   }
   return NULL;
}

int VHttpRequestHeader::CreateHeaderBinary(void *dest,void *bin, int len)
{
	if (len <= 0)
	if ((len = GetResponse()->ReadHeaderContentLength()) <= 0)
	{
		return -1;
	}

	if (len <= 0)
	{
		len = GetResponse()->ReadHeaderContentLength();
	}else
		AddHeaderContentLength(len);

	VString Lines = GetHeaderLines();
	int count = Lines.GetLength();

	memcpy(dest,(void*)Lines.GetBuffer(),count);
	
	char* bin2 = (char*)dest;
	bin2 += count;
	
	memcpy(bin2,bin,len);

	return len + count;
}

int VHttpRequestHeader::GetLength()
{
	VString Lines = GetHeaderLines();
	return Lines.GetLength();
}


VString VHttpRequestHeader::CreateHTTPOKHeader()
{
	Clear();
	CreateHTTPHeader(hm_http,"",200,"OK");
	AddHeaderContentLength(0);
	return this->GetHeaderLines(); 
}

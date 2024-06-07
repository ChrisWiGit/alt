/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#ifndef HTTP_UTILS_H
#define HTTP_UTILS_H

#pragma once

#include "definitions.h"
#include "vstring.h"
#include "vstrlist.h"

//#include <afx.h>

using namespace vtools;

//m�gliche HTTP-Header werte
extern enum HttpMessage {hm_unknown=-1,hm_http=1,hm_get,hm_post,hm_head,hm_put,hm_delete,hm_link,hm_count};

//HttpMessage als String
extern VString HttpMsgStr[hm_count];

//StringArray f�r vorderinierte HTTP-Request-Kommandos 
extern VString HttpRequests[10]; 
/*
In jeweils 5 Zeilen aufgegliedert
"Accept","User-Agent","Connection","Referer","If-Modified-Since", //5stck.
"Date","Content-type","Content-length","MIME-version","Server"
							
*/
/*
HTTP Client Request Methods

Method
 Action
 
GET
 Retrieve data specified in the URL
 
HEAD
 Return HTTP server response header informationonly
 
POST
 Send information to the HTTP server for further action
 
PUT
 Send information to the HTTP server for storage
 
DELETE
 Delete the resource specified in the URL
 
LINK
 Establish one or more link relationships between specified URLs
*/

//Vorw�rtsdefinition 
class VHttpResponseHeader;
class VHttpRequestHeader;

//Standardklasse zur einfachen Requestbehandlung (read & write)
extern VHttpRequestHeader HttpRequestHeader;
//Standardklasse zur einfachen Responsebehandlung (read)
extern VHttpResponseHeader HttpResponseHeader;


class VHttpResponseHeader 
{
public:
    VString HTTPHeader;

	VHttpResponseHeader(); 

	/*ergibt die m�glichkeit, einen String der zu VString kompatibel ist,
	direkt zur Eigenschaft HTTPHeader zuzuweisen (Kopie)
	*/
	VHttpResponseHeader & operator=(const VString text)
	{
		HTTPHeader = text;
		return (*this);
	}
		
	//liest die Inhaltsgr��e der Bin�rdaten aus einem HTTP-Header ein
	 int ReadHeaderContentLength();
	
	/* Lie�t die Bin�rdaten aus einem HTTP-Header ein,
	   mit der L�nge der im Header angegebenen Inhaltsgr��e, wenn ContentLength -1 ist.
	   der Speicherbereich data muss vorher mit der richtigen Gr��e allokiert worden sein.
	   Die n�tige Gr��e wird durch ReadHeaderContentLength bestimmt.
	   Das Ergebnis ist die gr��e des Bin�rblocks	 

	   Beispiel:	
		recv(socket,ReceivedData,DataLen);
		int clen = HttpResponseHeader.ReadHeaderContentLength();
		char *data = (char*)malloc(clen+1);
		clen = HttpResponseHeader.ReadHeaderBinary(ReceivedData,data,clen);

		this->ServerSession->Send(data,clen,1);
	*/
    int ReadHeaderBinary(char *HttpHeader, void *data,int ContentLength = -1);
	
	//Lie�t den Wert einen HTTP-Request-Strings ein, der einem doppelpunkt nach Request folgen muss
	VString ReadHeaderLineValue(VString Request, bool CaseSensitive = FALSE);
	
	/*Lie�t den Wert einen HTTP-Request-Strings der angegebenen Zeile ein
	die erste zeile hat die nummer 0 und so fort
	*/
	VString ReadHeaderLineValue(int line);
	
	//lie�t den Wert einer einzelnen HTTP-Request Zeile ein
	VString ReadValue(VString HttpLine);
	
	/*gibt die Zeile line des HTTP Request zur�ck, wenn line nicht existiert wird eine leere VString-Klasse zur�ckgeliefert
	die erste zeile hat die nummer 0 und so fort
	*/
	VString ReadHeaderLine(int line);
	
	//gibt die Zeile des HTTP Request zur�ck, wenn line nicht existiert wird eine leere VString-Klasse zur�ckgeliefert
	VString ReadHeaderLine(VString Request, bool CaseSensitive = FALSE);
	
	/*liefert den String der ersten Zeile zur�ck der nach einem "/" (Slash) auftaucht und bis zum n�chsten leerzeichen geht.
	bei einem HTTP-Request wird der Statustext nach dem Statuscode zur�ckgeliefert
	*/
	VString GetHttpMessage();

	//Vergleicht mit eine MessageString mit einem anderen
	bool CompareHttpMessage(VString CmpText, bool CaseSensitive =FALSE);
	
	//ermittelt die Art des HTTP-Headers
	HttpMessage GetHTTPMessageType();
	
	//ermittelt den Statuscode einer HTTP-Antwort
	int GetStatusCode();
	
	//ermittelt den Statustext einer HTTP-Antwort
	int GetStatusCodeStr(VString &TextCode);
	VString GetStatusCodeStr();
};


class VHttpRequestHeader 
{
	VHttpResponseHeader B;	
	char *m_DataString;
public :
	VHttpRequestHeader();
	
	virtual ~VHttpRequestHeader()
	{
		if (m_DataString != NULL)
			delete[] m_DataString;
	}

	VString CreateHTTPOKHeader();
	VString AddHeaderRequest(VString Request,int Value);
	VString AddHeaderRequest(VString Request, long Value);
	//unterh�lt die HTTP-Header strings
	VStringList Headers;
	
	
	operator LPCTSTR() 
	{
		if (m_DataString != NULL)
			delete[] m_DataString;

		VString s(GetHeaderLines());
		int len = s.GetLength();
		m_DataString = new char[len+1];
		m_DataString[len] = '\0';
		//memset(m_DataString,0,len+1);
		memcpy(m_DataString,s,len);		
		
		return m_DataString;
	}

	//Findet einen String in der Liste und gibt die Position zur�ck
	POSITION Find(VString Request, bool CaseSensitive = FALSE);
	
	//F�gt oder ersetzt falls vorhanden, die Inhaltsl�nge am Ende an
	VString AddHeaderContentLength(int len);
	
	//F�gt oder ersetzt falls vorhanden, ein HeaderRequest mit Wert
	VString AddHeaderRequest(VString Request,VString Value);

	//Erstellt einen HTTP-Header (l�scht den vorhanden), und f�llt ihn mit Werten
	VString CreateHTTPHeader(HttpMessage MsgType, VString Msg, int StatusCode = 0, VString StatusText = "");

	/*erstellt aus dem HTTP-Header und bin�ren Daten aus bin, einen Speicherbereich dest,
	der den kompletten Header enth�lt und gibt die Gr��e dieses Bereichs zur�ck oder -1,
	wenn len <= 0 ist und kein Content-length-request im Header vorliegt.
	Ist len > 0 wird die Gr��e automatisch im Header eingetragen.

	Der Speicherbereich muss zuvor angelegt worden sein und GetLength()+len oder
	GetLength()+ die Gr��e von bin sein.

    Beispiel :

		HttpRequestHeader.CreateHTTPHeader(hm_post,"hallo");
		
		char bin[12] = "data1\0data2";
		int len = HttpRequestHeader.GetLength()+sizeof(bin);
		
		char *s = new char[len];
		HttpRequestHeader.AddHeaderContentLength(sizeof(bin));
		
		len = HttpRequestHeader.CreateHeaderBinary(s,&bin,0);
	    //len ist jetzt die gr��e mit HTTPHeader und bin
		  ...
		send(s,len);
		...
	    delete[] s;
	*/
	int CreateHeaderBinary(void *dest,void *bin,int len = 0);

	//Gibt alle Strings in der Liste getrennt durch \r\n zur�ck
	VString GetHeaderLines();

	/*F�gt eine Headerzeile ans Ende hinzu
	entfernt vorher vorhandene breaks oder anf�ngliche Leerzeichn/Tabs
	*/
	void AddHeaderLine(VString line);
	
	//L�scht den HTTP-Header
	void Clear();

	//ermittelt die Zeichenanzahl im Headerstring eingschlie�lich aller breaks und das leerzeichen am ende
	int GetLength();

	//F�gt eine Headerzeile ans Ende hinzu
	VHttpRequestHeader *operator+=(VString text)
	{
		AddHeaderLine(text);
		return this;
	}
	
	VHttpResponseHeader *GetResponse()
	{
		B.HTTPHeader = GetHeaderLines();
		return &B;		
	}

	//erm�glicht es die Headerliste mit der Hilfe von VHttpResponseHeader auszulesen 
	VHttpResponseHeader *operator->()
	{
		B.HTTPHeader = GetHeaderLines();
		return &B;		
	}
};





#endif
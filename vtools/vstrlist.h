/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#ifndef VSTRLIST_H
#define VSTRLIST_H

#include "definitions.h"
#include "vlists.h"
#include "vstring.h"



namespace vtools
{
class VStringList;
typedef short (*STRINGFUNC)(VStringList *StringList,POSITION nPos,VString* &vString, void* Data);
typedef short (*STRINGSORTFUNC)(VStringList *PtrList,POSITION nPos1,POSITION nPos2, short Direction,void* Data);

class VStringList : public VPtrList
{
public:
	VStringList() {};
	VStringList(const STRING First, ... );
	virtual ~VStringList();

	virtual POSITION AddHead(VString &newElement);
	virtual POSITION AddTail(VString &newElement);

	 POSITION AddHead(STRING newElement);
	 POSITION AddTail(STRING newElement);

	POSITION InsertBefore(POSITION position, VString &newElement);
	POSITION InsertAfter(POSITION position, VString &newElement);

	POSITION Find(STRING searchValue, POSITION startAfter = NULL, bool CaseSensitive = false);
	POSITION Find(VString& searchValue, POSITION startAfter = NULL);
	
	VString& GetNext(POSITION& rPosition);

	virtual	void RemoveAt(POSITION position);
	virtual void RemoveAll();

	virtual void Swap(POSITION pos1,POSITION pos2);

	VString &GetAt(POSITION Index);
	VString &GetAt(int nIndex) {return this->GetAt(this->FindIndex(nIndex));};	
	
	void SetAt(POSITION pos, VString &newElement);
	void SetAt(int npos, VString &newElement) {SetAt(this->FindIndex(npos),newElement);};

	VString &operator [](POSITION nPos) {return this->GetAt(nPos);};	
	VString &operator [](int nIndex) {return this->GetAt(nIndex);};	

	virtual int ForEach(STRINGFUNC StringFunc,POSITION StartAt = NULL,void *Data = NULL); 

	//sort : to Do
	virtual int Sort(short direction, void* Data);
	virtual int CustomSort(STRINGSORTFUNC PtrFunc,short direction, void* Data);
};


};

#endif


//CStringList

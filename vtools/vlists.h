/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#ifndef VLISTS_H
#define VLISTS_H

#include "definitions.h"
#include <list>
#include <vector>
#include <windows.h>
#include <sstream>
#include "vstring.h"

#pragma once

namespace vtools
{
typedef std::vector<void*> CVoidVector;
typedef	std::vector<int> VIntVector; //need a mfc-like template class for ordinary types?

/*defines POSITION as a pointer to an Index (unsigned long)

*/
typedef PULONG POSITION;

/*A list of pointers
behaves like CPtrList
*/
class VPtrList;

typedef short (*PTRFUNC)(VPtrList *PtrList,POSITION nPos,void* &vPtr, void* Data);
typedef short (*PTRSORTFUNC)(VPtrList *PtrList,POSITION nPos1,POSITION nPos2,short direction, void* Data);



class VPtrList
{

public:
	VPtrList();
	virtual ~VPtrList();

	//inline POSITION Add(void* Ptr) {return this->AddTail(Ptr);};
	//virtual void Insert(int nPos,void* Ptr){};

	virtual POSITION AddHead(void* newElement);
	virtual POSITION AddTail(void* newElement);

	// inserting before or after a given position
	POSITION InsertBefore(POSITION position, void* newElement);
	POSITION InsertAfter(POSITION position, void* newElement);


	POSITION GetHeadPosition() const;
	POSITION GetTailPosition() const;
	
	bool IsEmpty() const;

    ULONG GetCount() const;

	inline ULONG GetSize() {return GetCount();};
	//inline bool IsEmpty() { return (GetCount() == 0);};
	

	void*& GetNext(POSITION& rPosition);
	void*& GetPrev(POSITION& rPosition);

	void Remove(void* searchValue, POSITION startAfter = NULL) { EnterCriticalSection(cs); RemoveAt(this->Find(searchValue, startAfter)); LeaveCriticalSection(cs);};
	virtual	void RemoveAt(POSITION position);
	inline void RemoveAt(int nIndex) { EnterCriticalSection(cs); RemoveAt(this->FindIndex(nIndex)); LeaveCriticalSection(cs);};
	virtual void RemoveAll();

    //Removes an element of the list, but does not delete it
    //it sets Element to NULL when it was successfully removed otherwise nothing happens
    virtual void Delete(void* &Element);

	inline void RemoveHead() {RemoveAt(0);};
	inline void RemoveTail() {EnterCriticalSection(cs);RemoveAt(GetCount()-1);LeaveCriticalSection(cs);};


	virtual void Swap(POSITION pos1,POSITION pos2);

	//POSITION Find(CObject* searchValue, POSITION startAfter = NULL) const;

	void *&GetAt(POSITION Index) ;
	void *&GetAt(int nIndex) {return this->GetAt(this->FindIndex(nIndex));};	

	void SetAt(POSITION pos, void* newElement) ;
	void SetAt(int nIndex, void* newElement)  {EnterCriticalSection(cs); this->SetAt(this->FindIndex(nIndex),newElement);LeaveCriticalSection(cs);};	

	void *&operator [](POSITION nIndex) 
				{return this->GetAt(nIndex);};	

	// helper functions (note: O(n) speed)
	POSITION Find(void* searchValue, POSITION startAfter = NULL) ;
						// defaults to starting at the HEAD
						// return NULL if not found
	POSITION FindIndex(int nIndex) ;
						// get the 'nIndex'th element (may return NULL)*/
	int GetIndex(POSITION nPos);

	virtual int ForEach(PTRFUNC PtrFunc,POSITION StartAt = NULL,void *Data = NULL); 

	//must be override
	virtual int CustomSort(PTRSORTFUNC PtrFunc,short direction, void* Data) {return -1;};

protected:
	LPCRITICAL_SECTION cs;

	CVoidVector mList;	
	POSITION HeadPos;
	POSITION TailPos;
	static void* NULLPtr;
};

//typedef VPtrList VStringList;

};

#endif
	




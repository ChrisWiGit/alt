/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#include "vlists.h"

namespace vtools
{

//POSITION VPtrList::HeadPos = new ULONG;
void* VPtrList::NULLPtr = NULL;

VPtrList::VPtrList()
{
	HeadPos = new ULONG;
	TailPos = new ULONG;

	cs = new CRITICAL_SECTION;
	InitializeCriticalSection(cs);
}


VPtrList::~VPtrList()
{
	delete HeadPos;
	delete TailPos;

	DeleteCriticalSection(cs);
}

POSITION VPtrList::AddHead(void* newElement)
{
	EnterCriticalSection(cs);
	std::vector<void*>::iterator it = mList.insert(this->mList.begin(),newElement);
	std::vector<void*>::difference_type Index = std::distance (mList.begin (), it);
	LeaveCriticalSection(cs);

	return (POSITION)Index;
}

POSITION VPtrList::AddTail(void* newElement)
{
	EnterCriticalSection(cs);
	std::vector<void*>::iterator it = mList.insert(this->mList.end(),newElement);
	std::vector<void*>::difference_type Index = std::distance (mList.begin (), it);
	LeaveCriticalSection(cs);

	return (POSITION)Index;
}


void VPtrList::RemoveAll()
{
	mList.clear();
}
//POSITION Find(CObject* searchValue, POSITION startAfter = NULL) const;
bool VPtrList::IsEmpty() const
{
	return (GetCount() == 0) ? true : false;
}

void VPtrList::Swap(POSITION pos1,POSITION pos2)
{
	EnterCriticalSection(cs);
	void* s1 = GetAt(pos1);

	SetAt(pos1,GetAt(pos2));
	SetAt(pos2,s1);
	LeaveCriticalSection(cs);
}

POSITION VPtrList::GetHeadPosition() const
{
	if (IsEmpty()) 
		return NULL;

	(*HeadPos) = 0;

	return HeadPos;
}
POSITION VPtrList::GetTailPosition() const
{
	if (IsEmpty()) 
		return NULL;

	(*TailPos) = mList.size();

	return TailPos;
}

void*& VPtrList::GetNext(POSITION& rPosition)
{
	(*rPosition)++;
	if ((*rPosition) >= GetCount())
	{
		//(*rPosition) = 0;
		rPosition = NULL;
		return (void*&)rPosition;
	}
	return GetAt(rPosition);
}

void*& VPtrList::GetPrev(POSITION& rPosition)
{
	(*rPosition)--;
	if ((*rPosition) < 0)
	{
		//(*rPosition) = 0;
		rPosition = NULL;

		return (void*&)rPosition;
			//NULLPtr;
	}
	return GetAt(rPosition);
}

void*& VPtrList::GetAt(POSITION Index) 
{
	if (Index == NULL) return this->NULLPtr;
	ULONG pos = (ULONG)(*Index);
	return (void*&)mList.at(pos);
}
void VPtrList::SetAt(POSITION pos, void* newElement) 
{
	EnterCriticalSection(cs);
	ULONG p = (ULONG)(*pos);
	mList[p] = newElement;
	LeaveCriticalSection(cs);
}

void VPtrList::RemoveAt(POSITION position)
{
	EnterCriticalSection(cs);
	ULONG p = (ULONG)(*position);
	mList.erase(mList.begin() + p);
	LeaveCriticalSection(cs);
}

void VPtrList::Delete(void* &Element)
{
	EnterCriticalSection(cs);
    POSITION p = this->Find(Element);
    if (p != NULL)
    {
        Element = NULL;
        RemoveAt(p);
    }
	LeaveCriticalSection(cs);
}


// inserting before or after a given position
POSITION VPtrList::InsertBefore(POSITION position, void* newElement)
{
	std::vector<void*>::iterator it = mList.insert(this->mList.begin() + (*position) -1,newElement);
	std::vector<void*>::difference_type Index = std::distance (mList.begin (), it);
	
	(*HeadPos) = Index;

	return HeadPos;

}

POSITION VPtrList::InsertAfter(POSITION position, void* newElement)
{
	std::vector<void*>::iterator it = mList.insert(this->mList.begin() + (*position)+1,newElement);
	std::vector<void*>::difference_type Index = std::distance (mList.begin (), it);
	
	(*HeadPos) = Index;

	return NULL;
}
POSITION VPtrList::Find(void* searchValue, POSITION startAfter /*= NULL*/) 
{
	POSITION pos1, 
			 startpos = startAfter;
	if (startpos == NULL)
		startpos = this->GetHeadPosition();

	EnterCriticalSection(cs);
	for(pos1 = startpos; pos1 != NULL; )
    {
		//TR: Folgende Zeilen m.E. fehlerhaft.
		//void *p = &this->GetAt(pos1);
		//if ((&searchValue) == ((void*)&p))
		void *p = this->GetAt(pos1);
		if ((searchValue) == ((void*)p))
		{
			LeaveCriticalSection(cs);
			return pos1;
		}
		this->GetNext(pos1);
    }
	LeaveCriticalSection(cs);
	return NULL;
}

POSITION VPtrList::FindIndex(int nIndex) 
{
	POSITION pos1;

	EnterCriticalSection(cs);
	for(pos1 = this->GetHeadPosition(); pos1 != NULL; )
    {
		if ((*pos1) == nIndex) 
		{
			LeaveCriticalSection(cs);
			return pos1;
		}
		this->GetNext(pos1);
    }
	LeaveCriticalSection(cs);
	return NULL;
}

int VPtrList::GetIndex(POSITION nPos)
{
	if (nPos == NULL) return -1;
	return (*nPos);
}

ULONG VPtrList::GetCount() const
{
	 return mList.size();
}
//int VPtrList::ForEach(STRINGFUNC StringFunc,POSITION StartAt /*= NULL*/,void *Data)
int VPtrList::ForEach(PTRFUNC PtrFunc,POSITION StartAt /*= NULL*/,void *Data)
{
	if (PtrFunc == NULL) return 0;

	POSITION pos1, 
			 startpos = StartAt;
	ULONG Count = 0;
	
	if (startpos == NULL)
		startpos = this->GetHeadPosition();
		
	for(pos1 = startpos; pos1 != NULL; )
    {
		Count++;
		if (!PtrFunc(this,pos1,this->GetAt(pos1),Data)) break;
		
		this->GetNext(pos1);
    }
	return Count;
}

int CustomSort(PTRSORTFUNC PtrFunc,short direction, void* Data)
{
	return -1;
}

};
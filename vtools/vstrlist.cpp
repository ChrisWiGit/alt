/*
License
-------

Feel free to use this library (complete or parts), as long as you don't claim that you wrote it
and this copyright notice stays intact in the source files.
If you use this class in commercial applications, please inform the author 
at author_AT_example.com (replace _AT_ with @)
*/

#include "vstrlist.h"

#include <stdio.h>
#include <stdarg.h>


namespace vtools
{

VStringList::VStringList(const STRING First, ... )
{
   va_list marker;
   char *p = First;

   va_start( marker, First );     /* Initialize variable arguments. */
   while( p != NULL )
   {
      AddTail(VString(p));
	  p = va_arg( marker, char*);
   }
   va_end( marker );              /* Reset variable arguments.      */  
}

VStringList::~VStringList()
{
	this->RemoveAll();
}

POSITION VStringList::AddHead(VString &newElement)
{
	return VPtrList::AddHead(new VString(newElement));
		//(void*)&newElement);
}

POSITION VStringList::AddTail(VString &newElement)
{
	return VPtrList::AddTail(new VString(newElement));
}
POSITION VStringList::AddHead(STRING newElement)
{
	return VPtrList::AddHead(new VString(newElement));
}
POSITION VStringList::AddTail(STRING newElement)
{
	return VPtrList::AddTail(new VString(newElement));
}

void VStringList::SetAt(POSITION pos, VString &newElement)
{
	VString *p = &this->GetAt(pos);
	delete p;

	/*
	known heap leak!
	*/
	VPtrList::SetAt(pos,new VString(newElement));
}

VString& VStringList::GetAt(POSITION Index)
{
	//VString *p = (VString*)VPtrList::GetAt(Index);
	//VString e = (*p);
	//return (VString&)(*p);
	return  (VString&)(*((VString*)VPtrList::GetAt(Index)));
}

VString& VStringList::GetNext(POSITION& rPosition)
{
	return  (VString&)(*((VString*)VPtrList::GetNext(rPosition)));
}

POSITION VStringList::InsertBefore(POSITION position, VString &newElement)
{
	return VPtrList::InsertBefore(position,new VString(newElement));
}

POSITION VStringList::InsertAfter(POSITION position, VString &newElement)
{
	return VPtrList::InsertAfter(position,new VString(newElement));
}

POSITION VStringList::Find(VString &searchValue, POSITION startAfter) 
{
	POSITION pos1, 
			 startpos = startAfter;
	if (startpos == NULL)
		startpos = this->GetHeadPosition();
		
	for(pos1 = startpos; pos1 != NULL; )
    {
		if (searchValue == this->GetAt(pos1))
		{
			return pos1;
		}
		this->GetNext(pos1);
    }
	return NULL;
}

POSITION VStringList::Find(STRING searchValue, POSITION startAfter, bool CaseSensitive)
{
	POSITION pos1, 
			 startpos = startAfter;
	if (startpos == NULL)
		startpos = this->GetHeadPosition();
	
	vtools::VString SearchS(searchValue,CaseSensitive);

	for(pos1 = startpos; pos1 != NULL; )
    {
		if (SearchS == this->GetAt(pos1))
		{
			return pos1;
		}
		this->GetNext(pos1);
    }
	return NULL;
}

void VStringList::RemoveAt(POSITION position)
{
	VString *p = &this->GetAt(position);
	delete p;

	VPtrList::RemoveAt(position);
}

void VStringList::RemoveAll()
{
	POSITION pos1;
			 
	for(pos1 = this->GetHeadPosition(); pos1 != NULL; )
    {
		VString *p = &this->GetAt(pos1);
		delete p;
		
		this->GetNext(pos1);
    }

	VPtrList::RemoveAll();
}

int VStringList::ForEach(STRINGFUNC StringFunc,POSITION StartAt /*= NULL*/,void *Data /*= NULL*/)
{
	return VPtrList::ForEach((PTRFUNC)StringFunc,StartAt,Data);
}

void VStringList::Swap(POSITION pos1,POSITION pos2)
{
	VString s1(GetAt(pos1));//, s2(PtrList->GetAt(Pos2));

	SetAt(pos1,GetAt(pos2));
	SetAt(pos2,s1);

}

static short CustomSortFunc(VStringList *PtrList,POSITION nPos1,POSITION nPos2, short Direction,void* Data)
{
	VString s1(PtrList->GetAt(nPos1)),s2(PtrList->GetAt(nPos2));

	short cmp = s1.Compare(s2);
	return cmp;
}

int VStringList::Sort(short direction, void* Data)
{
	return CustomSort(CustomSortFunc,direction,Data);
}

int VStringList::CustomSort(STRINGSORTFUNC PtrFunc,short direction, void* Data)
{
	if (PtrFunc == NULL) return -1;
	
		
	VString min,hilf;
	int merke;
	for (int i = 0; i < GetCount(); i++)
	{
		min = GetAt(i);
		merke = i;
		for (int j = i+1; j < GetCount();j++)
		{
			if (GetAt(j) < min)
			{
				min = GetAt(j);
				merke = j;
			}
			hilf = GetAt(merke);
			SetAt(merke,GetAt(i));
			SetAt(i,hilf);
		}
	}

	return GetCount();
}
};

/*
for(pos1 = this->GetHeadPosition(); pos1 != NULL; )
    {
		(*pos2) = (*pos1);		
		this->GetNext(pos1);
		
		if ((pos1 == NULL) || (pos2 == NULL))
		{
			break;
		}
		short cmp = PtrFunc(this,pos1,pos2,direction,Data);
		
		if (cmp != 0)
		{
			ULONG tmp1;
			if (direction == true)
			{
				tmp1 = (*pos1);
				(*pos1) = (*pos2);
				(*pos2) = tmp1;

				pos1 = pos2;
				
			}
			else
			{
				tmp1 = (*pos2);
				(*pos2) = (*pos1);
				(*pos1) = tmp1;

			}

			
			//pos1 = this->GetHeadPosition();
		}
    }	
	
*/
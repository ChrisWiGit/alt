#ifndef VLISTVIEW
#define VLISTVIEW

#pragma once



// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/listview/reflist.asp

class VListView
{

public:
	HANDLE m_hListView;

	VListView(void);
	~VListView(void);


};

#endif
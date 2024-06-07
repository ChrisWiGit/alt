; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CMsgBoxDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "MsgBox.h"

ClassCount=5
Class1=CMsgBoxApp
Class2=CMsgBoxDlg
Class3=CAboutDlg

ResourceCount=8
Resource1=IDD_DIALOG3
Resource2=IDR_MAINFRAME
Resource3=IDD_DIALOG4
Class4=CDataDlg
Resource4=IDD_ABOUTBOX
Class5=CPassDlg
Resource5=IDD_MSGBOX_DIALOG
Resource6=IDD_DIALOG1
Resource7=IDD_DIALOG2
Resource8=CG_IDR_POPUP_MSG_BOX_DLG

[CLS:CMsgBoxApp]
Type=0
HeaderFile=MsgBox.h
ImplementationFile=MsgBox.cpp
Filter=N
LastObject=CMsgBoxApp

[CLS:CMsgBoxDlg]
Type=0
HeaderFile=MsgBoxDlg.h
ImplementationFile=MsgBoxDlg.cpp
Filter=D
LastObject=CMsgBoxDlg
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=MsgBoxDlg.h
ImplementationFile=MsgBoxDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177795
Control2=IDC_STATIC,static,1342308353
Control3=IDC_STATIC,static,1342308353
Control4=IDOK,button,1342373889

[DLG:IDD_MSGBOX_DIALOG]
Type=1
Class=CMsgBoxDlg
ControlCount=49
Control1=IDC_EDIT1,edit,1350631552
Control2=IDC_EDIT2,edit,1353781700
Control3=IDC_RADIO1,button,1342181449
Control4=IDC_RADIO2,button,1342181449
Control5=IDC_RADIO3,button,1342181449
Control6=IDC_RADIO4,button,1342181449
Control7=IDC_RADIO5,button,1342189577
Control8=IDC_CHECK1,button,1342242819
Control9=IDC_CHECK2,button,1342242819
Control10=IDC_CHECK3,button,1342242819
Control11=IDC_CHECK4,button,1342242819
Control12=IDC_CHECK5,button,1342242819
Control13=IDC_CHECK6,button,1342242819
Control14=IDC_CHECK7,button,1342242819
Control15=IDC_SLIDER1,msctls_trackbar32,1342242817
Control16=IDC_CHECK8,button,1342242819
Control17=IDC_MESSAGEBEEP,button,1342242819
Control18=IDC_COMBO1,combobox,1344340035
Control19=IDC_REANICOMBO,button,1342242816
Control20=IDC_APPLMODAL,button,1342242819
Control21=IDC_SYSTEMLMODAL,button,1342242819
Control22=IDC_TASKMODAL,button,1342242819
Control23=ID_DEL,button,1342242816
Control24=ID_CLIP,button,1342373888
Control25=IDC_EDIT3,edit,1345394692
Control26=IDC_CLOSE,button,1342373888
Control27=IDC_TEST,button,1342242816
Control28=IDWRITE,button,1342242816
Control29=Info,button,1342373888
Control30=IDC_HELP2,button,1342373888
Control31=IDC_EDIT4,edit,1342244992
Control32=IDC_STATIC,static,1342308352
Control33=IDC_STATIC,static,1342308352
Control34=IDC_STATIC,static,1342308352
Control35=IDC_EDIT5,edit,1342244992
Control36=IDC_STATIC,button,1342177287
Control37=IDC_STATIC,button,1342177287
Control38=IDC_STATIC,button,1342177287
Control39=IDC_STATIC,button,1342177287
Control40=IDC_STATIC,button,1342177287
Control41=IDC_STATIC,button,1342177287
Control42=IDC_STATIC,button,1342177287
Control43=IDC_STATIC,button,1342177287
Control44=IDC_COMBO2,combobox,1344339971
Control45=IDC_LOADSAVE,button,1342242816
Control46=IDC_STATIC,button,1342177287
Control47=IDC_STATIC,button,1342177287
Control48=IDC_DELETE,button,1342373888
Control49=IDC_STANDARD,button,1342242816

[DLG:IDD_DIALOG1]
Type=1
Class=CDataDlg
ControlCount=29
Control1=IDOK,button,1342242816
Control2=IDCANCEL,button,1073807360
Control3=IDC_STATIC,button,1342177287
Control4=IDC_DIALOGLIST,listbox,1352729857
Control5=IDC_LOADFILE,button,1342242816
Control6=IDC_STATIC,static,1342308352
Control7=IDC_CAPTIONEDIT,edit,1350633600
Control8=IDC_STATIC1,static,1342308352
Control9=IDC_EDIT2,edit,1353779396
Control10=IDC_STATIC,static,1342308352
Control11=IDC_SAVEFILE,button,1342242816
Control12=IDC_STATIC,button,1342177287
Control13=IDC_ADDDATA,button,1476460544
Control14=IDC_LOADDATA,button,1476460544
Control15=IDC_DLGNAME,edit,1350631552
Control16=IDC_STATIC,static,1342308352
Control17=IDC_CHANGEUSERNAME,button,1476460544
Control18=IDC_TEST,button,1476460544
Control19=IDC_DELETE,button,1476460544
Control20=IDC_STATIC,button,1342177287
Control21=IDC_UP,button,1476460544
Control22=IDC_DOWN,button,1476460544
Control23=IDC_MODIFIED,static,1342308352
Control24=IDC_STATIC,static,1342308352
Control25=IDC_STATIC,button,1342177287
Control26=IDC_STATIC,button,1342177287
Control27=IDC_FILENAME,edit,1350633600
Control28=IDC_STATIC,button,1342177287
Control29=IDC_PASSWORD,button,1342242816

[CLS:CDataDlg]
Type=0
HeaderFile=DataDlg.h
ImplementationFile=DataDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_LOADFILE

[DLG:IDD_DIALOG2]
Type=1
Class=CPassDlg
ControlCount=10
Control1=IDC_EDIT1,edit,1350631592
Control2=IDC_EDIT2,edit,1350631592
Control3=IDOK,button,1476460545
Control4=IDCANCEL,button,1342242816
Control5=IDC_DELETE,button,1342242816
Control6=IDC_STATIC1,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352
Control9=IDC_STATIC,button,1342177287
Control10=IDC_STATIC,static,1342177280

[CLS:CPassDlg]
Type=0
HeaderFile=PassDlg.h
ImplementationFile=PassDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDOK

[MNU:CG_IDR_POPUP_MSG_BOX_DLG]
Type=1
Class=?
Command1=IDC_LOADSAVE
Command2=IDC_DELETE
Command3=IDC_TEST
Command4=IDWRITE
Command5=ID_POPUP_NEUDARSTELLEN
Command6=IDC_CLOSE
CommandCount=6

[DLG:IDD_DIALOG3]
Type=1
Class=?
ControlCount=2
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816

[DLG:IDD_DIALOG4]
Type=1
Class=?
ControlCount=2
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816


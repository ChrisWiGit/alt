//.NET Enterprise Server Feedback
//Version 1.1.

//*************************************************************************
//***Start: Localization section 1 of 1					***
//*************************************************************************

//-------------------------------------------------------------------------
//--- IMPORTANT: The values in this section vary for each deliverable. 	---
//---            Modify the values in this section.			---
//-------------------------------------------------------------------------

var fbParagraph_Text = 'For further ADO assistance, please post to the appropriate <A HREF="http://go.microsoft.com/fwlink/?LinkId=6362">Microsoft public newsgroup for ADO</A>.</P> <P>This newsgroup provides a forum for ADO discussions and support and is monitored by Microsoft employees with experience working with ADO. These include Microsoft Product Support Services (PSS) engineers, as well as experienced programmer writers who have familiarity with the ADO SDK documentation. You will also have the chance to interact with experienced ADO developers outside of Microsoft.</P><P>Going forward, please use the newsgroups for all questions and concerns about ADO.';

//-------------------------------------------------------------------------
//---These values do not need to be modified for US deliverables. 	---
//---(The text must be localized for non-US deliverables.)		---
//-------------------------------------------------------------------------

var fbTitle_Text = 'Support Contact for ADO';
var fbCancel_Text = 'Cancel';

//*************************************************************************
//***End: Localization section 1 of 1					***
//*************************************************************************

var theObj;

function startFeedback(obj)
{
theObj=obj;
var stream;

stream = '<DIV ID="feedbackarea">'
	+ '<br>'
	+ '<hr COLOR="#99CCFF">'
	+ '<H6 STYLE="margin-top:0.5em;">' + fbTitle_Text + '</H6>'
	+ '<P>' + fbParagraph_Text + '</P>'
	+ '<P STYLE="width:97%;position:relative;float:left;clear:left;margin-bottom:-0.7em;margin-top:0em;" align=right><A HREF="#Feedback" TARGET="_self" ONCLICK=fbReload(' + obj.id + ')>' + fbCancel_Text
	+ '</A>&nbsp;</P><BR>'
	+ '<hr COLOR="#99CCFF">'	
	+ '</DIV>';

obj.innerHTML = stream;
}

//---Reloads window.---
function fbReload()
{
	window.location.reload(true);

}

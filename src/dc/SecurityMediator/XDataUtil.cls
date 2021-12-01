/// Description
Class dc.SecurityMediator.XDataUtil
{

ClassMethod GetXDataContent(className, methodName) As %String
{
     
    Set qryXdata = "SELECT parent, Name, Description FROM %Dictionary.MethodDefinition WHERE parent = ? and Name = ?"
    Set stmXdata = ##class(%SQL.Statement).%New()
    Set qStatus = stmXdata.%Prepare(qryXdata)
    If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
    Set rsetXdata = stmXdata.%Execute(className, methodName) 
    Set result = ""
    While rsetXdata.%Next() { 
        Set result = rsetXdata.Description
    }
    Return result
}

ClassMethod foo() As %String
{
    Quit
}

ClassMethod bar()
{
    #Dim str As %String = ..foo()
}

/// Description
ClassMethod ExtractXDataContent(className, xDataName) As %Status
{
    
    Set content = ""
    For i=1:1:$$$comMemberKeyGet(className,$$$cCLASSxdata,xDataName,$$$cXDATAdata) {
        Set content = content_$$$comMemberArrayGet(className,$$$cCLASSxdata,xDataName,$$$cXDATAdata,i)
    }
    Return content
}

}

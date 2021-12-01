/// Description
Class dc.SecurityMediator.XDataUtil
{

ClassMethod GetXDataContent(className, methodName, Output xData As %String) As %Status
{
    SET tSC = $$$OK
    
    Try {
        Set qryXdata = "SELECT parent, Name, Description FROM %Dictionary.MethodDefinition WHERE parent = ? and Name = ?"
        Set stmXdata = ##class(%SQL.Statement).%New()
        Set qStatus = stmXdata.%Prepare(qryXdata)
        If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
        Set rsetXdata = stmXdata.%Execute(className, methodName) 
        Set xData = ""
        While rsetXdata.%Next() { 
            Set xData = rsetXdata.Description
        }
    } CATCH ex {
        SET tSC = ex.AsStatus()
    }

    Return tSC
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

Class dc.SecurityMediator.SecurityMediator Extends %CSP.REST
{

ClassMethod AccessCheck(Output pAuthorized As %Boolean = 0) As %Status
{
  
  Do ##super()
  
  Set message = {}
  
  Set tSC = $$$OK
  
  Set message.verb = %request.Method

  Set message.url = %request.URL

  Set message.url = "/"_$REPLACE(message.url, %request.Application, "")

  Set message.application = %request.Application
  
  Set methodName = ""
  Do ..GetClassMethodName(message.url, %request.Method, .methodName)
  
  Set message.method = methodName

  Set message.header = $Get(%request.CgiEnvs("HTTP_ORGANIZATION")) 

  Set xdata = ##class(dc.SecurityMediator.XDataUtil).GetXDataContent($CLASSNAME(), methodName)

  Do ..GetSecurityRules(xdata, .rules, .roles, .header, .operator)

  Set UserRoles = $LISTFROMSTRING($ROLES,",")
  Set RolesAllowed = UserRoles
  
  Set HasRole = 0
  Set HasHeader = 0

  If $FIND(xdata, "@security") > 0 && $FIND(xdata, "roles:") {
    Set RolesAllowed = $LISTFROMSTRING(roles,",")

    For RoleIdx=1:1:$LISTLENGTH(UserRoles) {
      If $LISTFIND(RolesAllowed, $LIST(UserRoles, RoleIdx)) {
        Set HasRole = 1
        Quit
      }
    }
  } Else {
    Set HasRole = 1
  }

  If $FIND(xdata, "@security") > 0 && $FIND(xdata, "header:") {
    Set HeaderKey = $PIECE(header,"=")
    Set HeaderKey = $ZSTRIP(HeaderKey, "<>W")
    Set HeaderValue = $PIECE(header,"=",2)
    Set HeaderValue = $ZSTRIP(HeaderValue, "<>W")

    If $Get(%request.CgiEnvs(HeaderKey)) = HeaderValue {
      Set HasHeader = 1
    } Else {
      Set HasHeader = 0
    }
  } Else {
    Set HasHeader = 1
  }

  If HasRole {
    Set pAuthorized = 1 
  } Else {
    Set pAuthorized = 0
    Set message.error = $USERNAME_" is not authorized for this request. User Roles Allowed is not in User Roles"
    Write message.%ToJSON()
  }

  If HasHeader {
    Set pAuthorized = 1 
  } Else {
    Set pAuthorized = 0
    Set message.error = header_" is required in the request header"
    Write message.%ToJSON()
  }

  Return tSC
}

/// Adapted from InterSystens IRIS Class %CSP.REST to get the ClassMethod assigned to the URL in URLMap XData section.
ClassMethod GetClassMethodName(pUrl As %String, pMethod As %String, Output methodName As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tMatcher As %Regex.Matcher
    
    #dim tClass,tMatchUrl,tMapEntry,tRegEx,tTarget,tType As %String
    #dim tI,tIndex As %Integer
    #dim tResourceMatched,tContinue As %Boolean
    #dim tMethodMatched As %Boolean
    
    Try {
        
        Set (tResourceMatched,tMethodMatched)=0
                
        Set tMatchUrl=pUrl
        
        #; Uppercase the method
        Set pMethod=$ZCONVERT(pMethod,"U")
            
        #; Walk the dispatch map in collation order of definition
        For tIndex=1:1 {
            
            #; Get the next map entry
            Set tMapEntry=..DispatchMap(tIndex) If tMapEntry="" Quit
             
            #; Pick out the RegEx
            Set tRegEx=$LIST(tMapEntry,2)
            
            #; Create a matcher
            Set:$LENGTH(tRegEx) tMatcher=##class(%Regex.Matcher).%New(tRegEx)
            
            #; Test each regular expression in turn, extracting the arguments,
            #; dispatching to the named method  
            If $SELECT('$LENGTH(tRegEx):'$LENGTH(tMatchUrl), 1:tMatcher.Match(tMatchUrl)) {
                
                #; We have matched the resource
                Set tResourceMatched=1
                
                Set tType=$LIST(tMapEntry,1)
                
                #; If we are a simple route
                If tType="R" {
                    
                    #; comparison is case-insensitive now and supports multiple methods delimited by ","
                    Set tMethods = $ZSTRIP($ZCONVERT($LIST(tMapEntry,3),"U"),"*W"),tFound = 0
                    For tI = 1:1:$LENGTH(tMethods,",") If pMethod = $PIECE(tMethods,",",tI) Set tFound = 1 Quit
                    If 'tFound Continue
                    
                    Set tTarget=$LIST(tMapEntry,4)
                    
                    #; We have matched a method
                    Set tMethodMatched=1
                    
                    Set methodName = tTarget
                       
                } 
                
                If $$$ISERR(tSC) Quit
                
                #; Don't want multiple matches
                Quit
            }
        }
        
        #; Didn't have a match for the resource, report not found
        If tResourceMatched=0 Set tSC=..ReportHttpStatusCode(..#HTTP404NOTFOUND) Quit
                  
        #; Had a match for resource but method not matched
        If tMethodMatched=0 {
            
            Set tSC=..SupportedVerbs(tMatchUrl,.tSupportedVerbs)
            If $$$ISERR(tSC) Quit
            
            Set tSC=..Http405(tSupportedVerbs) Quit
        }
            
    } Catch (e) {
        
        Set tSC=e.AsStatus()
    }
    
    Quit tSC
}

/// Description
ClassMethod GetSecurityRules(xdata As %String, Output rules, Output roles As %String, Output header As %String, Output operator As %String) As %Status
{
  Set sc = $$$OK
  Set sentence = $EXTRACT(xdata, $FIND(xdata, "@security:"), *)
  Set rules = sentence
  Set roles = $EXTRACT(sentence, $FIND(sentence,"roles:"), *)
  Set roles = $EXTRACT(roles, $FIND(roles,"{"), $FIND(roles,"}")-2)
  Set roles = $REPLACE(roles, " ","")
  Set header = $EXTRACT(sentence, $FIND(sentence,"header:"), *)
  Set header = $EXTRACT(header, $FIND(header,"{"), $FIND(header,"}")-2)
  Set header = $ZSTRIP(header, "<>W")

  If $FIND(rules,"@security.and") > 0 {
    Set operator = "AND"
  } Else {
    Set operator = "OR"
  }

  Return sc
}

}

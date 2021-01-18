Class dc.mkdocs.Generator
{

ClassMethod Generate()
{
    Set qry = "SELECT parent, Name, Description FROM %Dictionary.XDataDefinition WHERE MimeType IN ('text/markdown','text/html')"
    Set stm = ##class(%SQL.Statement).%New()
    Set qStatus = stm.%Prepare(qry)
    If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
    Set rset = stm.%Execute() 
    While rset.%Next() { 
        Write "Row count ",rset.%ROWCOUNT,!
        Write rset.parent
        Write ": ",rset.Description,!
        Set xDataContent = ..GetXDataContent(rset.parent,rset.Name)
        Do ..SaveToFile(xDataContent, "/mkdocs/iris-publisher/docs/"_rset.Name_".md")
        Do ##class(%SYSTEM.Process).CurrentDirectory("/mkdocs/iris-publisher/")
        Set status = $ZF(-100,"/SHELL", "mkdocs","build")
        Set status = $ZF(-100,"/SHELL", "mkdocs","serve")
        Write status
        Write xDataContent,!!
    }
    Write !,"Total row count=",rset.%ROWCOUNT
}

ClassMethod GetXDataContent(className, xdataName) As %String
{
    Set content = ""
    For i=1:1:$$$comMemberKeyGet(className,$$$cCLASSxdata,xdataName,$$$cXDATAdata) {
        Set content = content_$$$comMemberArrayGet(className,$$$cCLASSxdata,xdataName,$$$cXDATAdata,i)
    }
    Quit content
}

ClassMethod SaveToFile(content As %String, path As %String) As %Status
{
    Set file = ##class(%Stream.FileCharacter).%New()
    Set file.Filename = path
    Do file.Write(content)
    Do file.%Save()
}

}

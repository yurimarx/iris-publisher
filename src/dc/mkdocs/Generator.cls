Class dc.mkdocs.Generator
{

ClassMethod Generate()
{
 
    Set docconfig = ##class(dc.Sample.DocConfig).%OpenId(1)

    Set file = ##class(%Stream.FileCharacter).%New()
    Set file.Filename = "/mkdocs/iris-publisher/mkdocs.yml"

    If '$IsObject(docconfig) {
        Do file.Write("site_name: 'IRIS Publisher'")  
    } Else {
        Do file.Write("site_name: '"_docconfig.SiteName_"'")
    }

    Do file.WriteLine()
    Do file.Write("pages:")
    Do file.WriteLine()
    
    If '$IsObject(docconfig) {
        Do file.Write("    - 'Overview': 'index.md'")   
    } Else {
        Do file.WriteLine()
        Do file.Write("    - 'Index': 'index.md'")
        Do file.WriteLine()
        Do file.Write("    - 'Overview': 'dynaindex.md'")
    }
    
    Do file.WriteLine()
    Do file.Write("    - 'Classes': ")
    Do file.WriteLine()
    
    Set qryClass = "SELECT distinct c.ID, c.Description FROM %Dictionary.ClassDefinition c inner join %Dictionary.XDataDefinition x on c.ID = x.parent WHERE x.MimeType IN ('text/markdown','text/html')"
    Set stmClass = ##class(%SQL.Statement).%New()
    Set qStatus = stmClass.%Prepare(qryClass)
    If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
    Set rsetClass = stmClass.%Execute() 

    While rsetClass.%Next() { 
        
        Set fileClass = ##class(%Stream.FileCharacter).%New()
        Set className = $PIECE(rsetClass.ID, ".",$LENGTH(rsetClass.ID,"."))
        Write className
        Set fileClass.Filename = "/mkdocs/iris-publisher/docs/"_className_".md"
        
        Do fileClass.Write("# Class Name")
        Do fileClass.WriteLine()
        Do fileClass.Write(rsetClass.ID)
        Do fileClass.WriteLine()
        Do fileClass.Write(rsetClass.Description)

        Set qryXdata = "SELECT parent, Name, Description FROM %Dictionary.XDataDefinition WHERE MimeType IN ('text/markdown','text/html') AND parent = '"_rsetClass.ID_"'"
        Set stmXdata = ##class(%SQL.Statement).%New()
        Set qStatus = stmXdata.%Prepare(qryXdata)
        If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
        Set rsetXdata = stmXdata.%Execute() 

        Do fileClass.WriteLine()
        Do fileClass.Write("# Class Documentation")
        While rsetXdata.%Next() {

            Set xDataContent = ..GetXDataContent(rsetXdata.parent,rsetXdata.Name)
            Do fileClass.WriteLine()
            Do fileClass.Write(xDataContent)
        }

        Do fileClass.WriteLine()
        Do fileClass.Write("# Properties")
        
        Set qryProp = "SELECT ID, Name, Description FROM %Dictionary.PropertyDefinition WHERE parent = '"_rsetClass.ID_"'"
        Set stmProp = ##class(%SQL.Statement).%New()
        Set qStatus = stmProp.%Prepare(qryProp)
        If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
        Set rsetProp = stmProp.%Execute() 

        While rsetProp.%Next() {

            Do fileClass.WriteLine()
            Do fileClass.Write("* **"_rsetProp.Name_": **")
            Do fileClass.WriteLine()
            Do fileClass.Write(rsetProp.Description)
        }
        
        Do fileClass.WriteLine()
        Do fileClass.Write("# Methods")
        
        Set qryMethod = "SELECT parent, Name, Description FROM %Dictionary.MethodDefinition WHERE parent = '"_rsetClass.ID_"'"
        Set stmMethod = ##class(%SQL.Statement).%New()
        Set qStatus = stmMethod.%Prepare(qryMethod)
        If qStatus'=1 {Write "%Prepare  failed:" Do $System.Status.DisplayError(qStatus) Quit}
        Set rsetMethod = stmMethod.%Execute() 

        While rsetMethod.%Next() {

            Do fileClass.WriteLine()
            Do fileClass.Write("* **"_rsetMethod.Name_": **")
            Do fileClass.WriteLine()
            Do fileClass.Write(rsetMethod.Description)
        }
        
        Do fileClass.%Save()
        
        Do file.Write("        - '"_className_"': '"_className_".md"_"'")
        Do file.WriteLine()
    }
    
    If '$IsObject(docconfig) {
        Do file.Write("    - 'About': 'about.md'")
    } Else {
        Do file.Write("    - 'About': 'dynaabout.md'")
    }

    If $IsObject(docconfig) {
        If (docconfig.Theme = "readthedocs") {
            Do file.WriteLine()
            Do file.Write("theme: readthedocs")
        }
    }
    
    Do file.WriteLine()
    Do file.Write("dev_addr: '0.0.0.0:8000'")   
    Do file.%Save()

    If $IsObject(docconfig) {
    
        Set fileindex = ##class(%Stream.FileCharacter).%New()
        Set fileindex.Filename = "/mkdocs/iris-publisher/docs/dynaindex.md"
        Do fileindex.Write("#"_docconfig.Summary)
        Do fileindex.WriteLine()
        Do fileindex.Write(docconfig.Description)
        Do fileindex.WriteLine()
        Do fileindex.Write("## Important files and folders")
        Do fileindex.WriteLine()
        Do fileindex.Write("* **docs source folder** - Edit about.md to change developer information and index.md to change this home page.")
        Do fileindex.WriteLine()
        Do fileindex.Write("* **mkdocs source folder** - Edit Generator.cls to change generation logic, if necessary and execute Generator.cls, method Generate() to generate the project documentation.")
        Do fileindex.WriteLine()
        Do fileindex.Write("* **mkdocs folder into docker instance** - root folder to the generated documentation site, inside site subfolder is possible download static documentation site.")
        Do fileindex.%Save()

        Set fileabout = ##class(%Stream.FileCharacter).%New()
        Set fileabout.Filename = "/mkdocs/iris-publisher/docs/dynaabout.md"
        Do fileabout.Write("# About us")
        Do fileabout.WriteLine()
        Do fileabout.Write("* **Developer:** "_docconfig.DeveloperName)
        Do fileabout.WriteLine()
        Do fileabout.Write("* **Email:** "_docconfig.DeveloperEmail)
        Do fileabout.WriteLine()
        Do fileabout.Write("* **Website:** "_docconfig.DeveloperWebsite)
        Do fileabout.%Save()
        
    }
    
    Do ##class(%SYSTEM.Process).CurrentDirectory("/mkdocs/iris-publisher/")
    Set status = $ZF(-100,"/SHELL", "mkdocs","build", "--clean")
    Set status = $ZF(-100,"/SHELL", "mkdocs","serve")
    Write status
        
    Quit status
}

ClassMethod GetXDataContent(className, xdataName) As %String
{
    Set content = ""
    For i=1:1:$$$comMemberKeyGet(className,$$$cCLASSxdata,xdataName,$$$cXDATAdata) {
        Set content = content_$$$comMemberArrayGet(className,$$$cCLASSxdata,xdataName,$$$cXDATAdata,i)
    }
    Quit content
}

}

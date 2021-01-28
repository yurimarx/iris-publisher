Class dc.Sample.MultiModelREST Extends Sample.REST.Base
{

Parameter Version = "1.0.0";

Parameter Global = "^dc.Sample.DocConfigD";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Get the current DocConfig data -->
<Route Url="/docconfig" Method="GET" Call="GetDocConfig"/>
<!-- Update the docconfig data-->
<Route Url="/docconfig" Method="PUT" Call="UpdateDocConfig"/>
<!-- Initiate Publisher -->
<Route Url="/docconfig/init" Method="GET" Call="InitiatePublisher"/>

</Routes>
}

/// PersonsREST general information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET info = {
    "version": (version)
  }
  RETURN ..%ProcessResult($$$OK, info)
}

/// Return DocConfig data 
ClassMethod GetDocConfig() As %Status
{
	set sc = $$$OK
    set record=$get(@..#Global@(1))
    If record="" Quit ..Http404()
    set json={}
    set json.SiteName=$lg(record,2)
    set json.Summary=$lg(record,3)
    set json.Description=$lg(record,4)
    set json.DeveloperName=$lg(record,5)
    set json.DeveloperEmail=$lg(record,6)
    set json.DeveloperWebsite=$lg(record,7)
    set json.Theme=$lg(record,8)
    write json.%ToJSON()
    return sc
}

/// Update DocConfig data
ClassMethod UpdateDocConfig() As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set docconfig = ##class(dc.Sample.DocConfig).%OpenId(1)
    If '$IsObject(docconfig) {
        Set docconfig = ##class(dc.Sample.DocConfig).%New()
    }

    Set data=%request.Content

    $$$TOE(tSC,docconfig.%JSONImport(data))
    $$$TOE(tSC,docconfig.%Save())

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do docconfig.%JSONExport()

    Quit tSC
}

/// Initiate the MkDocs site
ClassMethod InitiatePublisher() As %Status
{
      
    Do ##class(dc.mkdocs.Generator).Generate()
    Quit $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/crud"
  Set swagger.info.title = "IRIS Publisher API Documentation"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}

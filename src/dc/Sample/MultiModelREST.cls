Class dc.Sample.MultiModelREST Extends Sample.REST.Base
{

Parameter Version = "1.0.0";

Parameter Global = "^dc.Sample.PersonD";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Get all records of Person class -->
<Route Url="/persons/all" Method="GET" Call="GetAllPersons"/>
<!-- Generate records of Person class -->
<Route Url="/persons/gen/:amount" Method="GET" Call="GenerateRecords"/>
<!-- Get a record via Object API-->
<Route Url="/multi/object/:id" Method="GET" Call="GetPersonObject"/>
<!-- Update a person with id via Object API-->
<Route Url="/multi/object/:id" Method="PUT" Call="UpdatePersonObject"/>
<!-- Create a person-->
<Route Url="/multi/object/" Method="POST" Call="CreatePersonObject"/>
<!-- Get a record via SQL API-->
<Route Url="/multi/sql/:id" Method="GET" Call="GetPersonSQL"/>
<!-- Get a record via KeyValue API-->
<Route Url="/multi/keyval/:id" Method="GET" Call="GetPersonKeyValue"/>
<!-- Delete a record via Object API-->
<Route Url="/multi/object/:id" Method="DELETE" Call="DeletePersonObject"/>
<!-- Delete a record via SQL API-->
<Route Url="/multi/sql/:id" Method="DELETE" Call="DeletePersonSQL"/>
<!-- Delete a record via Key Value-->
<Route Url="/multi/keyval/:id" Method="DELETE" Call="DeletePersonKeyValue"/>


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

/// Generate records of Sample.Person
ClassMethod GenerateRecords(amount As %Integer) As %Status
{
    set sc = $$$OK
    do ##class(dc.Sample.Person).AddTestData(amount)
    return sc
}

/// Retreive all the records of dc.Sample.Person in JSON
ClassMethod GetAllPersons() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(dc.Sample.Person).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write "["
    if rset.%Next() {
        Set person = ##class(dc.Sample.Person).%OpenId(rset.ID)    
        Do person.%JSONExport()
    }
    While rset.%Next() {   
        Write ","
        Set person = ##class(dc.Sample.Person).%OpenId(rset.ID)    
        Do person.%JSONExport()
    }
    Write "]"
    Quit tSC
}

/// Return one record of dc.Sample.Person in JSON via ObjectScript 
ClassMethod GetPersonObject(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set person = ##class(dc.Sample.Person).%OpenId(id)
    If '$IsObject(person) Quit ..Http404()
    Do person.%JSONExport()
    Quit tSC
}

/// return a record of dc.Sample.Person in JSON via SQL API
ClassMethod GetPersonSQL(id As %Integer) As %Status
{
    set sc = $$$OK
    set sql="SELECT * FROM dc_Sample.Person WHERE Id="_id
    do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,sql)
    return sc
}

/// return a record of dc.Sample.Person in JSON via Key Value
ClassMethod GetPersonKeyValue(id As %Integer) As %Status
{
    set sc = $$$OK
    set record=$get(@..#Global@(id))
    If record="" Quit ..Http404()
    set json={}
    set json.Name=$lg(record,2)
    set json.Title=$lg(record,3)
    set json.Company=$lg(record,4)
    write json.%ToJSON()
    return sc
}

/// Creates a new Sample.Person record
ClassMethod CreatePersonObject() As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set person = ##class(dc.Sample.Person).%New()
    Set data=%request.Content


    $$$TOE(tSC,person.%JSONImport(data))
    $$$TOE(tSC,person.%Save())

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    //d data.%ToJSON()
    Do person.%JSONExport()

    Quit tSC
}

/// Update a record in Sample.Person with id
ClassMethod UpdatePersonObject(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set person = ##class(dc.Sample.Person).%OpenId(id)
    If '$IsObject(person) Return ..Http404()
    Set data=%request.Content

    $$$TOE(tSC,person.%JSONImport(data))
    $$$TOE(tSC,person.%Save())

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do person.%JSONExport()

    Quit tSC
}

/// Delete a person by id via Object API
ClassMethod DeletePersonObject(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    Set person = ##class(dc.Sample.Person).%OpenId(id)
    If '$IsObject(person) Return ..Http404()
    $$$TOE(tSC,person.%DeleteId(id))
    Quit tSC
}

/// Delete a person by id via SQL API
ClassMethod DeletePersonSQL(id As %Integer) As %Status
{
    set sc = $$$OK
    set sql="Delete * FROM dc_Sample.Person WHERE Id="_id
    do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,sql)
    return $$$OK
}

/// Delete a person by id via Key Value
ClassMethod DeletePersonKeyValue(id As %Integer) As %Status
{
    set sc = $$$OK
    Kill @..#Global@(id)
    return sc
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/crud"
  Set swagger.info.title = "InterSystems IRIS REST MULTI-MODEL CRUD demo"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}

Class dc.Sample.DocConfig Extends (%Persistent, %JSON.Adaptor)
{

/// Documentation site name. 
Property SiteName As %String;

/// Summary about the application
Property Summary As %String;

/// Application description
Property Description As %String(MAXLEN = 1000);

/// Developer's full name
Property DeveloperName As %String;

/// Developer's email
Property DeveloperEmail As %String;

/// Developer's site name E.g: wwww.intersystems.com
Property DeveloperWebsite As %String;

/// MkDocs Theme. Options: default or readthedocs
Property Theme As %String;

/// Documentation for DocConfig in HTML
XData DocConfig [ MimeType = text/html ]
{
<b>This is the DocConfig class. This class is used to hold general parameters to documentation generation</b>
}

Storage Default
{
<Data name="DocConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SiteName</Value>
</Value>
<Value name="3">
<Value>Summary</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DeveloperName</Value>
</Value>
<Value name="6">
<Value>DeveloperEmail</Value>
</Value>
<Value name="7">
<Value>DeveloperWebsite</Value>
</Value>
<Value name="8">
<Value>Theme</Value>
</Value>
</Data>
<DataLocation>^dc.Sample.DocConfigD</DataLocation>
<DefaultData>DocConfigDefaultData</DefaultData>
<IdLocation>^dc.Sample.DocConfigD</IdLocation>
<IndexLocation>^dc.Sample.DocConfigI</IndexLocation>
<StreamLocation>^dc.Sample.DocConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

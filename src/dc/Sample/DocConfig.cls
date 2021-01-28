Class dc.Sample.DocConfig Extends (%Persistent, %JSON.Adaptor)
{

Property SiteName As %String;

Property Summary As %String;

Property Description As %String(MAXLEN = 1000);

Property DeveloperName As %String;

Property DeveloperEmail As %String;

Property DeveloperWebsite As %String;

Property Theme As %String;

/// Documentation for DocConfig in HTML
XData DocConfig [ MimeType = text/html ]
{
<h1>This is the DocConfig class</h1>
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

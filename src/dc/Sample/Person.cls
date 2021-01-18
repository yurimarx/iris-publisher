Class dc.Sample.Person Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Property Name As %VarString;

Property Title As %String;

Property Company As %String;

Property Phone As %VarString;

Property DOB As %Date(MAXVAL = "$piece($horolog, "","", 1)");

/// Index for property DOB
Index DOBIndex On DOB;

ClassMethod AddTestData(amount As %Integer = 10)
{
    d ..Populate(amount)
}

XData LoadData
{
<table>
 <row>1^Minor</row>
 <row>2^Moderate</row>
 <row>3^Life-threatening</row>
 <row>9^Inactive</row>
 <row>99^Unable to determine</row>
</table>
}

/// Documentation for Person in HTML
XData PersonDocHtml [ MimeType = text/html ]
{
<h1>This is the Person class</h1>
}

/// Documentation for Person in Markdown
XData PersonDocMarkdown [ MimeType = text/markdown ]
{
<h1>This is the Person class in MD</h1>
}

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Company</Value>
</Value>
<Value name="5">
<Value>Phone</Value>
</Value>
<Value name="6">
<Value>DOB</Value>
</Value>
</Data>
<DataLocation>^dc.Sample.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^dc.Sample.PersonD</IdLocation>
<IndexLocation>^dc.Sample.PersonI</IndexLocation>
<StreamLocation>^dc.Sample.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

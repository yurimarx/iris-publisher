Class dc.Sample.Person Extends (%Persistent, %JSON.Adaptor, %Populate)
{

/// Person first and last name
Property Name As %VarString;

/// Title for person
Property Title As %String;

/// Person's company name
Property Company As %String;

/// Person's phone
Property Phone As %VarString;

/// Person's date of birth
Property DOB As %Date(MAXVAL = "$piece($horolog, "","", 1)");

/// Index for property DOB
Index DOBIndex On DOB;

/// Add person data to test up to the amount parameter 
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
XData PersonDocHtml [ MimeType = text/markdown ]
{
<h5>This is the Person class</h5>
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

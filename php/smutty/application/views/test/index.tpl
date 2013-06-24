<html>
<head>
<title>Testing</title>

{ajax_libs}

</head>

<body>

<h1>Result:</h1>

<span id="Result"></span>

<h2>Form</h2>

{form url={ action="foo" } update="Result" }

	{field name="name" value="rod@you"}

	{submit text="Go"}

{form_end}

<h2>Form Single Multiple</h2>

{form url={ action="foo" } update="Result" }

	{field name="foo" value="rod@bar"}

	{field name="name[]" value="rod@you"}

	{submit text="Go"}

{form_end}

<h2>Form Many Multiples</h2>

{form url={ action="foo" } update="Result" }

	{field name="foo" value="rod@bar"}

	{field name="na me[]" value="rod@you"}

	{field name="na me[]" value="foo@bar"}

	{submit text="Go"}

{form_end}

</body>
</html>
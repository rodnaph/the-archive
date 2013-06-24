
{include file="include/header.tpl" title="Delete Model"}

<p>Are you <b>ABSOLUTELY</b> sure you want to delete this record?  There
is no undo, this is unrecoverable.  If you're really sure click the
delete button below.</p>

{form url={ action="modelDelete" smutty_modelClass=$modelClass
	smutty_modelId=$modelId } }

	{hidden name="confirmCode" value=$confirmCode}

	{submit text="I'm sure, delete the record"}

{form_end}

{include file="include/footer.tpl"}

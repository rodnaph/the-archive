
{include file="include/header.tpl" title="Smutty Login"}

{form url={ action="login" } }

	{field name=$nameParam label="Username:"}

	{password name=$passParam label="Password:"}

	{submit text="Login"}

{form_end}

{include file="include/footer.tpl"}

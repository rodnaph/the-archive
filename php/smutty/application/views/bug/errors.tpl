
<h3 style="color:#f33;">Error!</h3>

<ul>
{foreach item="error" from=$errors}
<li>{$error|escape}</li>
{/foreach}
</ul>
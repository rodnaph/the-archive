
{include file="include/header.tpl" title="Posting a comment"}

<h2>Posting a comment</h2>

{if $errors}
	<h3 class="error">Error Saving</h3>
	<ul>
	{foreach item="error" from=$errors}
		<li>{$error|escape}</li>
	{/foreach}
	</ul>
	</ul>
{/if}

<p>Comments should be used to critique or add information to wiki
pages.  If you have another issue (contacting me, requesting a
feature, reporting a bug, etc...) then please either post
to the <a href="http://code.google.com/p/smutty/issues/list">issue tracker</a>,
or email me at <b>rod at pu-gh dot com</b>.</p>

{form
	url={ action="saveComment" name=$page->name} }

	<fieldset>

		{hidden name="sess_code" value=$smutty->session->code}

		{field name="nsplease" label="Type Smutty:"}
		(this is to help stop spam)

		{field name="user_name" label="Name:"}

		{field name="email" label="Email (opt):"}

		{label text="Comments:"}
		<textarea style="width:260px;height:150px;float:left;" name="body"></textarea>

		<input type="submit" value="Post comment" />

	</fieldset>

{form_end}

{include file="include/footer.tpl"}

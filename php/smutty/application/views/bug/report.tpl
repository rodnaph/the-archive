
{include file="include/header.tpl" title="Smutty Bugs" enableAjax="true"}

<h2>Reporting a Bug</h2>

<p>To report a bug with Smutty just fill out the form
below and click the submit button.</p>

<div id="reportResult"></div>

{form url={ action="reportBug" } update="reportResult" feedback="reportResult" }

	<fieldset>

		{if !$smutty->session->user}
			{field label="Name:" name="bug.user_name"}
		{/if}

		{field name="bug.name" label="Short Desc:"}

		{textarea name="bug.body" label="Description:"}

		{submit text="Submit Bug"}

	</fieldset>

{form_end}

{include file="bug/sidebar.tpl"}
{include file="include/footer.tpl"}


{include file="include/header.tpl" title="Preferences"}

<h2>Preferences</h2>

{if $smutty->session->user}

{if $prefsSaved}<h3 class="descr">YOUR CHANGES WERE SAVED</h3>{/if}

<p>To edit your preferences just change whatever, then click
<b>save</b> at the bottom.</p>

{form url={ action="savePrefs" } }

	<fieldset>

	<legend>Contact Stuff</legend>

	{field name="user.msn" label="MSN:" value=$user->msn}
	{field name="user.icq" label="ICQ:" value=$user->icq}
	{field name="user.aim" label="AIM:" value=$user->aim}
	{field name="user.sig" label="Signature:" value=$user->sig}

	</fieldset>

	<fieldset>

	<legend>Where Are You?!?</legend>

	{select from=$countries group="locations" label="Home:"
		name="user.home" selected=$user->home}

	{select from=$countries group="locations" label="Current Location:"
		name="user.current_location" selected=$user->current_location}

	</fieldset>

	<fieldset>

	<legend>Site Options</legend>

	</fieldset>

	{submit text="Save Changes"}

{form_end}

<div class="clearer"></div>

{else}
Not Logged In
{/if}

{include file="include/footer.tpl"}

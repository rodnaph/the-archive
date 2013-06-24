
{include file="include/header.tpl" title="Smutty Bugs"}

<h2>Smutty Bugs</h2>

<table>
	<tr>
		<th>ID</th>
		<th>Desc</th>
		<th>Status</th>
		<th>Posted</th>
	</tr>
	{foreach item="bug" from=$bugs}
	<tr>
		<td>{link url={ action="show" id=$bug->id } text=$bug->id }</td>
		<td>{link url={ action="show" id=$bug->id } text=$bug->name }</td>
		<td>{$bug->bug_status->name}</td>
		<td>{$bug->date_created|date_format:"%Y-%m-%d"}</td>
	</tr>
	{/foreach}
	</ul>
</table>

{include file="bug/sidebar.tpl"}
{include file="include/footer.tpl"}

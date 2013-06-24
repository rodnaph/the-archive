
{include file="include/header.tpl" title="Pending Users: `$group->name`" section="Group"}

<script type="text/javascript" src="../javascript/groups.js"></script>

<h2>Pending Users: {$group->name|escape}</h2>

{assign var="isMember" value=$group->isMember($user)}

<ul>
{foreach item="u" from=$group->getPendingUsers()}
	<li>{if $isMember}<a href="javascript:approveJoinGroup('{$group->id}','{$u->id}');">APPROVE</a>{/if}
	 {$u->name|escape}</li>
{/foreach}
</ul>

{include file="include/footer.tpl"}

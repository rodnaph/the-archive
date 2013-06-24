
{foreach item="p" from=$user->getPages()}
	{if ($p->parentID == $parentID) && ($p->group->id == $groupID)}
	<li><a href="../pages/view.php?id={$p->id}">{$p->name|escape}</a>
		<ul>{include file="pages/page-tree.tpl" parentID=$p->id groupID=$groupID}</ul>
	</li>
	{/if}
{/foreach}

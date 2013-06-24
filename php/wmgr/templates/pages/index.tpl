
{include file="include/header.tpl" title="Page: `$page->name`" section="Page"}

<h2><img src="../images/22x22/page.png" /> All Pages</h2>

{foreach item="group" from=$user->getGroups()}

	<h3><img src="../images/12x12/group.png" /> {$group->name|escape}</h3>
	
	<ul>
	{include file="pages/page-tree.tpl" parentID="" groupID=$group->id}
	</ul>
	
{/foreach}

{include file="include/footer.tpl"}

{include file="include/header-xml.tpl"}

<user id="{$user->id}">
	<groups>
		{foreach item="group" from=$user->getGroups()}
		<group id="{$group->id}">
			<name>{$group->name|escape}</name>
		</group>
		{/foreach}
	</groups>
</user>

{include file="include/header-xml.tpl"}

<myMenu>

	<groups>
	{foreach item="group" from=$user->getGroups()}
		<group id="{$group->id}">
			<name>{$group->name|escape}</name>
		</group>
	{/foreach}
	</groups>

	<projects>
	{foreach item="project" from=$user->getProjects()}
		<project id="{$project->id}">
			<name>{$project->name|escape}</name>
		</project>
	{/foreach}
	</projects>

	<tasks>
	{foreach item="task" from=$user->getTasks()}
		<task id="{$task->id}">
			<name>{$task->name|escape}</name>
			<status id="{$task->status->id}">
				<name>{$task->status->name|escape}</name>
				<icon id="{$task->status->icon->id}">
					<name>{$task->status->icon->name|escape}</name>
					<filename>{$task->status->icon->filename}</filename>
				</icon>
			</status>
		</task>
	{/foreach}
	</tasks>

</myMenu>
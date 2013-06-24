
<p>
	{link url={ action="models" } text="All Models" } |
	{link url={ action="modelBrowse" smutty_modelClass=$modelClass } text="Browse All" } |
	{link url={ action="modelEdit" smutty_modelClass=$modelClass } text="Add New" }
	{if $edit}
		| {link url={ action="modelEdit" smutty_modelClass=$modelClass smutty_modelId=$modelId } text="Edit Record" }
	{/if}
</p>

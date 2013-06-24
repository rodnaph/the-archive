
{if $relatedModels}
<div><b>Related<span style="font-weight:normal;">Models</span>:</b>

	{assign var="first" value="1"}
	{foreach name="related" item="model" from=$relatedModels
		}{if $smarty.foreach.related.last && !$smarty.foreach.related.first} and {
		elseif !$smarty.foreach.related.first}, {/if}{link
			url={ action="modelBrowse" smutty_modelClass=$model } text=$model
	}{/foreach}
</div>
<br />
{/if}

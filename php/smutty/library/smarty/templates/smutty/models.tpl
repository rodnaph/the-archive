
{include file="include/header.tpl" title="Your Models"}

{foreach key="model" item="total" from=$models}
	<h3 class="link">
		{link url={ action="modelBrowse" smutty_modelClass=$model } text=$model|pluralize }
		<span style="font-size:0.3em;font-weight:normal;">({$total|plural:"record"})</span>
	</h3>
{foreachelse}
	<h3>No Models Found</h3>
	<p>Looks like you haven't created any models yet! If you need some
	help you can read the tutorial on the wiki to find out
	<a href="http://smutty.pu-gh.com/wiki/ClassSmutty_Model">about models</a>,
	and how <a href="http://smutty.pu-gh.com/wiki/SmuttySmut">use <b>smut</b> to create them</a>.</p>
{/foreach}

{include file="include/footer.tpl"}

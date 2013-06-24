 
{include file="include/header.tpl" title="Live Search Demo" enableAjax="true"}

<style type="text/css">
#searchBox {ldelim}
	border: 1px #aaa dashed;
	background-color: #eee;
	padding: 15px;
{rdelim}
</style>

<h2>Live Search Demo</h2>

<p>The text field below implements basic "live search" type functionality.  The
field is created with the <a href="{$smutty->baseUrl}/wiki/SmartyFunction_field">{ldelim}field{rdelim}</a>
function, but this time we use the <code>update</code> and <code>url</code>
attributes to enable ajax callbacks.  The <code>feedback</code> attribute is
also set to specify the element to show feedback of how the call is going.</p>

<div id="searchBox">

<p><b>Search:</b> <i>(hint: try ajax!)</i>
{field
	name="myField"
	url={ action="liveSearchQuery" }
	update="searchResults"
	feedback="searchResults"
}
</p>

<p><b>Results:</b> <span id="searchResults">(type something first!)</span></p>

</div>

<p>If you type some text into the field above then after a pause (it checks
you've stopped typing for a moment) it'll submit the query to the server
and then the results will be displayed.</p>

<p><a href="javascript:;" onclick="Effect.SlideDown('source');">Show Me The Source!</a></p>

<div id="source" style="display:none;">
<pre>
# liveSearch.tpl
{ldelim}field
	name="myField"
	url&#61;{ldelim} action="liveSearchQuery" {rdelim}
	update="searchResults"
	feedback="searchResults"
{rdelim}

# liveSearchQuery.tpl
&lt;ul&gt;
{ldelim}if $pages{rdelim}
	{ldelim}foreach item="page" from=$pages{rdelim}
		&lt;li&gt;{ldelim}link url&#61;{ldelim} controller="wiki" name=$page->name {rdelim} text=$page->name{rdelim}&lt;/li&gt;
	{ldelim}/foreach{rdelim}
{ldelim}else{rdelim}
	&lt;li>Nothing found...&lt;/li&gt;
{ldelim}/if{rdelim}
&lt;/ul&gt;

# demo controller
function liveSearchQueryAction( $data ) {ldelim}
		$pages = Page::fetchAll( false, array(
			'body:contains' => $data->string('id')
		), 10 );
		$this->set( 'pages', $pages );
		$this->view();
{rdelim}
</pre>
</div>

{include file="include/sidebar.tpl"}

{include file="include/footer.tpl"}

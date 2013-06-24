
{include file="include/header.tpl" title="Simple Ajax Links" enableAjax="true"}

<h2>Simple Ajax Links</h2>

<p>You may already be familiar with the <a href="{$smutty->baseUrl}/wiki/SmartyFunction_link">{ldelim}link{rdelim}</a>
function for creating links in your application.  This is the exact same
function you'll use for creating Ajax enabled links, so no re-learning
required.</p>

<h3>Updating an element</h3>

<p>The simplest way to use ajax links is to make the link update an element
on the page.  You do this by specifing the id of the element to update with
the <code>update</code> attribute.  The link below is to an action which
just prints out the current date and time.</p>

<pre>
# template code
{ldelim}link
    update="myDiv"
    url&#61;{ldelim} controller="demo" action="theDate" {rdelim}
    text="Show Me The Date"
{rdelim}
</pre>

<pre>
# demo controller
function theDateAction() {ldelim}
	echo date( 'Y/m/d H:i:s' );
{rdelim}
</pre>

<p><b>CLICK ME:</b> {link
   update="myDiv"
   url={ controller="demo" action="theDate" }
   text="Show Me The Date"}</p>

<div id="myDiv">MyDiv (no date until you click the link above)</div>

<p>If you keep clicking the link you'll see that the second are incrementing.
How easy was that!</p>

{include file="include/sidebar.tpl"}

{include file="include/footer.tpl"}

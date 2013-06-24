
{include file="include/header.tpl" title="Unit Tests"}

<h3>Test Cases</h3>

<p>Below are listed the test cases you have created for your application.  To
run a particular test case just click on it.</p>

<ul>
{foreach item="test" from=$tests}
	<li>{link url={ action="testRun" file=$test } text=$test }</li>
{/foreach}
</ul>

{include file="include/footer.tpl"}

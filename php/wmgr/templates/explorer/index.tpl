
{include file="include/header-simple.tpl" title="Explorer"}

<script type="text/javascript" src="../javascript/explorer.js"></script>

<h2>Explorer</h2>

<div id="ExplorerTree"></div>

<div id="ExplorerControls">
	<input type="button" value="None" onclick="noneClicked()" />
	<input type="button" value="Cancel" onclick="self.close()" />
	<input type="button" value="Ok" onclick="okClicked()" />
</div>

<div id="ExplorerDisplay"></div>

<script type="text/javascript">
var oRoot = new ExplorerNode(
	document.getElementById('ExplorerTree'),
	self.oInitialProvider
);
oRoot.toggle();
selectExplorerNode( null );
</script>

{include file="include/footer-simple.tpl"}

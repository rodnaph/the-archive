
{if $page}
<script type="text/javascript">

var page = new Menu( 'Page',null,'page.png' );
page.add( new Menu('Edit','/pages/edit.php?id={$page->id}') );
page.add( new Menu('View History','/pages/history.php?id={$page->id}') );
page.add( new Menu('View Current','/pages/view.php?id={$page->id}') );
page.add( new Menu('Delete','/pages/delete.php?id={$page->id}','delete.png') );
page.init();

</script>
{/if}

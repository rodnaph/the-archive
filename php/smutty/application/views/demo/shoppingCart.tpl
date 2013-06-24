
{include file="include/header.tpl" title="Shopping Cart Demo" enableAjax="true"}

<style type="text/css">
#cart {ldelim}
	border: 1px #aaa dashed;
	height: 80px;
	width: 400px;
	margin-bottom: 20px;
	padding: 10px;
{rdelim}
#trash {ldelim}
	padding: 10px;
	border: 1px #aaa solid;
	height: 30px;
	width: 400px;
	background-color: #ddd;
{rdelim}
</style>

<h2>Drag and Drop Shopping Cart</h2>

{draggable
	id="item_mug"
	image="/images/demo/mug.jpg"
	class="product" }

{draggable
	image="/images/demo/tshirt.jpg"
	id="item_tshirt"
	class="product"
}

<h3>Shopping Cart - Drop Items Here!</h3>

{droppable
	id="cart"
	drop_url={ controller="demo" action="shoppingCartAdd" }
	load_url={ controller="demo" action="showCart" }
	accept="product"
	feedback="cart"
}

<b style="color:#f33;">Trash - Drop Items Here to Delete</b>
{droppable
	id="trash"
	update="cart"
	accept="cartItem"
	feedback="cart"
	drop_url={ controller="demo" action="shoppingCartRemove" }
}

<p>Or you can {link
	update="cart"
	url={ action="shoppingCartClear" }
	feedback="cart"
	text="click here to clear the cart"}.</p>

<p><a href="javascript:;" onclick="Effect.SlideDown('source');">Show Me The Source!</a></p>
<div id="source" style="display:none;">
<pre>
#
#  views/demo/shoppingCartDemo.tpl
#
{ldelim}draggable
	id="item_mug"
	image="/images/demo/mug.jpg"
	class="product" {rdelim}

{ldelim}draggable
	image="/images/demo/tshirt.jpg"
	id="item_tshirt"
	class="product"
{rdelim}

&lt;h3&gt;Shopping Cart - Drop Items Here!&lt;/h3&gt;

{ldelim}droppable
	id="cart"
	drop_url&#61;{ldelim} controller="demo" action="shoppingCartAdd" {rdelim}
	accept="product"
	load_url&#61;{ldelim} controller="demo" action="showCart" {rdelim}
	feedback="cart"
{rdelim}

&lt;b style="color:#f33;"&gt;Trash - Drop Items Here to Delete&lt;/b&gt;
{ldelim}droppable
	id="trash"
	update="cart"
	accept="cartItem"
	feedback="cart"
	drop_url&#61;{ldelim} controller="demo" action="shoppingCartRemove" {rdelim}
{rdelim}

&lt;p&gt;Or you can {ldelim}link
	update="cart"
	url&#61;{ldelim} action="shoppingCartClear" {rdelim}
	feedback="cart"
	text="click here to clear the cart"{rdelim}.&lt;/p&gt;

#
#  views/demo/shoppingCart.tpl
#
{ldelim}foreach key="id" item="item" from=$smutty->session->cart{rdelim}
	{ldelim}if $item{rdelim}
	{ldelim}draggable
		image="/images/demo/$id-small.jpg"
		id="cart_$id"
		class="cartItem"} ({ldelim}$item{rdelim})
	{ldelim}/if{rdelim}
{ldelim}/foreach{rdelim}

#
#  controllers/DemoController.php
#
class DemoController extends Smutty_Controller {ldelim}

	function shoppingCartDemoAction() {ldelim}
		$this->view();
	{rdelim}

	function shoppingCartAddAction( $data, &amp;$session ) {ldelim}
		$id = $data->string( 'element_id' );
		if ( !$session->cart[$id] )
			$session->cart[$id] = 1;
		else
			$session->cart[$id]++;
		$this->showCart();
	{rdelim}

	function shoppingCartRemoveAction( $data, &amp;$session ) {ldelim}
		$id = $data->string( 'element_id' );
		$id = substr( $id, 5 ); // remove cart_ prefix
		$session->cart[$id]--;
		$this->showCart();
	{rdelim}

	function shoppingCartClearAction( $data, &amp;$session ) {ldelim}
		$session->cart = array();
		$this->showCart();
	{rdelim}

	function showCartAction() {ldelim}
		$this->showCart();
	{rdelim}

	function showCart() {ldelim}
		$this->view( 'demo/shoppingCart.tpl' );
	{rdelim}

{rdelim}
</pre>
</div>

<p>As you can see, Smutty turns complicated Ajax calls into easy to
understand (and so hopefully less buggy!) code for your application.</p>

{include file="include/sidebar.tpl"}

{include file="include/footer.tpl"}

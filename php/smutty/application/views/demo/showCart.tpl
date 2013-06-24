
{foreach key="id" item="item" from=$smutty->session->cart}
	{if $item}
	{draggable
		image="/images/demo/$id-small.jpg"
		id="cart_$id"
		class="cartItem" } ({$item})
	{/if}
{/foreach}

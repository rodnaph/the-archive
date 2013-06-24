<?

class DemoController extends Smutty_Controller {

	function indexAction() {
		$this->view();
	}

	/**
	 *  live search demo
	 *
	 */

	function liveSearchAction() {
		$this->view();
	}

	function liveSearchQueryAction( $data ) {
		$pages = Page::fetchAll( false, array(
			'body:contains' => $data->string('id')
		), 10 );
		$this->set( 'pages', $pages );
		$this->view();
	}

	/**
	 *  simple links demo
	 *
	 */

	function simpleLinksAction() {
		$this->view();
	}

	function theDateAction() {
		echo date( 'Y/m/d H:i:s' );
	}

	/**
	 *  shopping cart demo
	 *
	 */

	function shoppingCartAction( $data, &$session ) {
		if ( !isset($session->cart) )
			$session->cart = array();
		$this->view();
	}

	function shoppingCartAddAction( $data, &$session ) {
		$id = $data->string( 'element_id' );
		if ( !isset($session->cart[$id]) )
			$session->cart[$id] = 1;
		else
			$session->cart[$id]++;
		$this->showCart();
	}

	function shoppingCartRemoveAction( $data, &$session ) {
		$id = $data->string( 'element_id' );
		$id = substr( $id, 5 ); // remove cart_ prefix
		$session->cart[$id]--;
		$this->showCart();
	}

	function shoppingCartClearAction( $data, &$session ) {
		$session->cart = array();
		$this->showCart();
	}

	function showCartAction() {
		$this->showCart();
	}

	function showCart() {
		$this->view( 'demo/showCart.tpl' );
	}

	/**
	 *  enigform
	 *
	 */

	function enigformAction() {
		$this->view();
	}

	function efLoginAction( $data ) {
		if ( $key = $data->isVerified() ) {
			$user = EnigformUser::find( $key->getKeyId(), 'gpgkeyid' );
			if ( $user->name == $data->string('name') ) {
				echo 'Welcome back ' . $user->name;
				return;
			}
		}
		echo 'Verification failed...';
	}

	function efRegisterAction( $data ) {

		if ( !EnigformUser::find($data->string('name'),'name') ) {

			$gpg = new Smutty_GPG();

			if ( $key = $gpg->import($data->string('public_key')) ) {
				$user = new EnigformUser();
				$user->name = $data->string( 'name' );
				$user->gpgkeyid = $key->getKeyId();
				if ( $user->save() )
					echo 'Registration Complete!';
				else
					echo 'could not save user';
			}

			else echo 'invalid public key';

		}

		else echo 'username is already taken';

	}

	function efCheckNameAction( $data ) {
		if ( $name = $data->string('id') ) {
			echo EnigformUser::fetchAll( false, array(
				'name' => $name
			)) ? 'Sorry, name taken...' : 'Username available!';
		}
	}

}

?>
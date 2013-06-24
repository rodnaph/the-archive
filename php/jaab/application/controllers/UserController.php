<?

Smutty_Main::loadClass( 'Smutty_Controller_Session' );

class UserController extends Smutty_Controller_Session {

	function profileAction( $data, $session ) {

		$id = $session->user ? $session->user->id : $data->int('id');
		$user = User::find( $id );

		$comments = Comment::fetchAll( 'date:desc', array(
			'user' => $user->id
		), 10 );

		$this->set( 'comments', $comments );
		$this->set( 'user', $user );
		$this->view();

	}

	function prefsAction( $data, $session ) {

		$user = ( $session->user )
			? User::find( $session->user->id ) : false;
		$countries = Country::fetchAll( 'name' );

		$this->set( 'prefsSaved', $data->string('prefsSaved') );
		$this->set( 'countries', $countries );
		$this->set( 'user', $user );
		$this->view();

	}

	function savePrefsAction( &$data, $session ) {

		$user = User::find( $session->user->id );
		$user->fill();
		if ( $user->save() )
			$data->set( 'prefsSaved', 'yes' );

		$this->action( 'prefs' );

	}

}

?>
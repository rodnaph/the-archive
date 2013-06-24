<?

class EntryController extends Smutty_Controller {

	function indexAction() {
		$this->set( 'entries', Entry::fetchAll( 'date:desc', false, 10 ) );
		$this->view();
	}

	function showAction( $data ) {
		$this->set( 'entry', Entry::find( $data->int('id') ) );
		$this->view();
	}

	function searchAction( $data ) {

		$perPage = 10;
		$start = $data->int( 'start' );
		$fetch = $perPage + 1;
		$params = array();
		if ( $start )
			$fetch = "$start:$fetch";

		if ( $userId = $data->int('userId') ) {
			$params['user'] = $userId;
			$this->set( 'userId', $userId );
		}

		if ( $key = $data->string('q') ) {
			$params['body:contains'] = $key;
			$this->set( 'q', $key );
		}

		if ( $location = $data->int('location') ) {
			$params['location'] = $location;
			$this->set( 'location', $location );
		}

		$entries = Entry::fetchAll( 'date:desc', $params, $fetch );
		//$total = Entry::getTotal( $params );
		$more = false;
		$less = ( $start );

		if ( sizeof($entries) > $perPage ) {
			array_pop( $entries );
			$more = true;
		}

		$this->set( 'countries', Country::fetchAll('name') );
		$this->set( 'entries', $entries );
		$this->set( 'total', 100 );
		$this->set( 'start', $start );
		$this->set( 'perPage', $perPage );
		$this->set( 'users', User::fetchAll('name') );
		$this->view();

	}

	function postAction( $data, $session ) {
		if ( !$session->user )
			$this->redirect(array(
				'controller' => 'user',
				'action' => 'login'
			));
		$this->set( 'user', User::find($session->user->id) );
		$this->set( 'countries', Country::fetchAll('name') );
		$this->set( 'locations', Location::fetchAll('name') );
		$this->view();
	}

	function postPreviewAction( $data ) {
		$hash = $data->data('entry');
		$this->set( 'subject', $hash->string('subject') );
		$this->set( 'body', $hash->string('body') );
		$this->view();
	}

	function saveAction( $data, $session ) {

		$hash = $data->data('entry');
		$user = User::find( $session->user->id );
		$user->current_location = $hash->int('location');
		$entry = new Entry();
		$entry->fill();
		$entry->user = $user->id;
		$entry->views = 1;
		$entry->topic = 1;

		$trans = new Smutty_Model_Transaction();
		$trans->add( $user );
		$trans->add( $entry );

		if ( $trans->save() )
			$this->redirect(array(
				'action' => 'show',
				'id' => $entry->id
			));

		else $this->action( 'post' );

	}

	function commentAction( $data ) {
		$this->set( 'entry', Entry::find($data->int('id')) );
		$this->view();
	}

	function commentSaveAction( $data, $session ) {

		$userID = $session->user ? $session->user->id : '';

		$comment = new Comment();
		$comment->fill();
		$comment->thread = $data->int( 'id' );
		$comment->user = $userID;

		if ( $comment->save() )
			$this->action( 'show' );
		else
			$this->action( 'comment' );

	}

}

?>
